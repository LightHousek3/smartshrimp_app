import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/home/data/owner_dashboard_api_service.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/owner_dashboard_repository.dart';

final ownerDashboardRepositoryProvider = Provider<OwnerDashboardRepository>(
  (ref) => OwnerDashboardApiService(ref.watch(apiClientProvider)),
);

// Retain the current response when slivers/routes lose their listeners.
// Account identity/access changes invalidate it; profile-only updates do not.
// UI retry/refresh owns reloads after errors, without automatic provider retries.
final ownerDashboardProvider = FutureProvider<OwnerDashboard>((ref) async {
  final account = ref.watch(
    authControllerProvider.select(
      (state) => (
        id: state.value?.id,
        role: state.value?.role,
        status: state.value?.status,
      ),
    ),
  );
  if (account.role != AccountRole.farmOwner) {
    throw const UnsupportedRoleException();
  }
  // Observe successful CRUD without changing the Farm feature's mutation policy.
  // Its initial async build is not a mutation and must not trigger another fetch.
  var mutationStarted = false;
  var mutationAccount = ref.read(authControllerProvider).value;
  ref.listen(farmMutationControllerProvider, (previous, next) {
    final currentAccount = ref.read(authControllerProvider).value;
    // Farm's controller also rebuilds on profile updates. Only loading under the
    // same account snapshot represents a write; an auth-driven rebuild does not.
    if (previous != null && !previous.isLoading && next.isLoading) {
      mutationStarted = currentAccount == mutationAccount;
    }
    mutationAccount = currentAccount;
    if (mutationStarted && !next.isLoading) {
      mutationStarted = false;
      if (next is AsyncData<void>) {
        ref.invalidateSelf();
        ref.invalidate(ownerFinanceProvider);
      }
    }
  });
  try {
    final dashboard = await ref
        .watch(ownerDashboardRepositoryProvider)
        .getOverview();
    if (ref.mounted) {
      final filter = ref.read(financeFilterProvider);
      if (filter.farmId != null &&
          !dashboard.financeFarms.any((farm) => farm.id == filter.farmId)) {
        ref.read(financeFilterProvider.notifier).selectFarm(null);
      }
    }
    return dashboard;
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}, retry: (retryCount, error) => null);

final financeFilterProvider =
    NotifierProvider<FinanceFilterController, FinanceFilter>(
      FinanceFilterController.new,
    );

class FinanceFilterController extends Notifier<FinanceFilter> {
  @override
  FinanceFilter build() {
    ref.watch(authControllerProvider.select((state) => state.value?.id));
    return const FinanceFilter();
  }

  void selectFarm(String? farmId) => state = state.copyWith(farmId: farmId);
  void selectPeriod(FinancePeriod period, DateTime today) =>
      state = state.copyWith(
        period: period,
        from: period == FinancePeriod.custom
            ? state.from ?? DateTime(today.year, today.month, 1)
            : null,
        to: period == FinancePeriod.custom ? state.to ?? today : null,
      );
  void selectDates(DateTime from, DateTime to) =>
      state = state.copyWith(from: from, to: to);
}

// Cache only the current filter result; changing filters or explicit invalidation reloads it.
final ownerFinanceProvider = FutureProvider<OwnerFinance>((ref) async {
  final account = ref.watch(
    authControllerProvider.select(
      (state) => (
        id: state.value?.id,
        role: state.value?.role,
        status: state.value?.status,
      ),
    ),
  );
  if (account.role != AccountRole.farmOwner) {
    throw const UnsupportedRoleException();
  }
  final filter = ref.watch(financeFilterProvider);
  try {
    return await ref.watch(ownerDashboardRepositoryProvider).getFinance(filter);
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}, retry: (retryCount, error) => null);
