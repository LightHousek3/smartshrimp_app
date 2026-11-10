import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/data/technician_dashboard_api_service.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/technician_dashboard_repository.dart';

final technicianDashboardRepositoryProvider =
    Provider<TechnicianDashboardRepository>(
      (ref) => TechnicianDashboardApiService(ref.watch(apiClientProvider)),
    );

/// Cache by authenticated identity/access; no timer, focus polling or automatic retry.
final technicianDashboardProvider = FutureProvider<TechnicianDashboard>((
  ref,
) async {
  final account = ref.watch(
    authControllerProvider.select(
      (state) => (
        id: state.value?.id,
        role: state.value?.role,
        status: state.value?.status,
      ),
    ),
  );
  if (account.id == null) throw const SessionExpiredException();
  if (account.role != AccountRole.technician) {
    throw const UnsupportedRoleException();
  }
  try {
    return await ref.watch(technicianDashboardRepositoryProvider).getOverview();
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}, retry: (_, _) => null);
