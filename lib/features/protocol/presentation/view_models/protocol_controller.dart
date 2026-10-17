import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/protocol/data/protocol_api_service.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/repositories/protocol_repository.dart';

typedef ProtocolListScope = ({
  String? seasonId,
  ProtocolType type,
  bool pendingOnly,
});
typedef ProtocolDayScope = ({String id, int day});
typedef ProtocolInventoryScope = ({String id, String scheduleId});

final protocolClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final protocolRepositoryProvider = Provider<ProtocolRepository>(
  (ref) => ProtocolApiService(ref.watch(apiClientProvider)),
);

void _watchOwner(Ref ref) {
  final account = ref.watch(
    authControllerProvider.select(
      (s) => (id: s.value?.id, role: s.value?.role, status: s.value?.status),
    ),
  );
  if (account.role != AccountRole.farmOwner ||
      account.status != AccountStatus.active) {
    throw const UnsupportedRoleException();
  }
}

Future<T> _session<T>(Ref ref, Future<T> Function() action) async {
  try {
    return await action();
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

final protocolDetailProvider = FutureProvider.autoDispose
    .family<ProtocolDetail, String>((ref, id) {
      _watchOwner(ref);
      return _session(
        ref,
        () => ref.watch(protocolRepositoryProvider).detail(id),
      );
    }, retry: (count, error) => null);
final protocolDayProvider = FutureProvider.autoDispose
    .family<ProtocolDay, ProtocolDayScope>((ref, scope) {
      _watchOwner(ref);
      return _session(
        ref,
        () => ref.watch(protocolRepositoryProvider).day(scope.id, scope.day),
      );
    }, retry: (count, error) => null);

final protocolListProvider = AsyncNotifierProvider.autoDispose
    .family<ProtocolListController, ProtocolPage, ProtocolListScope>(
      ProtocolListController.new,
    );
final protocolInventoryProvider = FutureProvider.autoDispose
    .family<List<ProtocolInventoryEntry>, ProtocolInventoryScope>((ref, scope) {
      _watchOwner(ref);
      return _session(
        ref,
        () => ref
            .watch(protocolRepositoryProvider)
            .inventory(scope.id, scope.scheduleId),
      );
    }, retry: (count, error) => null);

class ProtocolListController extends AsyncNotifier<ProtocolPage> {
  ProtocolListController(this.scope);
  final ProtocolListScope scope;
  bool _loadingMore = false;
  @override
  Future<ProtocolPage> build() {
    _watchOwner(ref);
    return _fetch(1);
  }

  Future<ProtocolPage> _fetch(int page) => _session(
    ref,
    () => ref
        .read(protocolRepositoryProvider)
        .list(
          seasonId: scope.seasonId,
          type: scope.type,
          pendingOnly: scope.pendingOnly,
          page: page,
        ),
  );

  Future<void> loadMore() async {
    final current = state.value;
    if (_loadingMore || current == null || !current.hasNextPage) return;
    _loadingMore = true;
    try {
      final next = await _fetch(current.page + 1);
      if (ref.mounted) {
        final ids = current.items.map((i) => i.id).toSet();
        state = AsyncData(
          next.copyWith(
            items: [
              ...current.items,
              ...next.items.where((i) => ids.add(i.id)),
            ],
          ),
        );
      }
    } finally {
      _loadingMore = false;
    }
  }
}

final protocolReviewProvider = AsyncNotifierProvider.autoDispose
    .family<ProtocolReviewController, bool?, String>(
      ProtocolReviewController.new,
      retry: (count, error) => null,
    );

class ProtocolReviewController extends AsyncNotifier<bool?> {
  ProtocolReviewController(this.id);
  final String id;
  @override
  bool? build() {
    _watchOwner(ref);
    return null;
  }

  Future<bool> submit(
    ProtocolDetail detail, {
    required bool approve,
    String? reason,
  }) async {
    if (state.isLoading || !detail.canReview) return false;
    if (!approve &&
        (reason == null ||
            reason.trim().isEmpty ||
            reason.trim().length > 2000)) {
      state = AsyncError(
        const ApiException('Vui lòng nhập lý do từ chối (tối đa 2000 ký tự).'),
        StackTrace.current,
      );
      return false;
    }
    state = const AsyncLoading();
    final result = await AsyncValue.guard<bool?>(() async {
      await _session(
        ref,
        () => ref
            .read(protocolRepositoryProvider)
            .review(
              id,
              updatedAt: detail.updatedAt,
              approve: approve,
              reason: reason,
            ),
      );
      return approve;
    });
    if (!ref.mounted) return result is AsyncData<bool?>;
    state = result;
    if (result is AsyncData<bool?>) {
      ref.invalidate(protocolListProvider);
      ref.invalidate(protocolDetailProvider(id));
      ref.invalidate(protocolDayProvider);
      ref.invalidate(seasonDetailControllerProvider(detail.card.seasonId));
      ref.invalidate(ownerDashboardProvider);
      return true;
    }
    if (result.error is AppException &&
        (result.error as AppException).statusCode == 409) {
      ref.invalidate(protocolDetailProvider(id));
      ref.invalidate(protocolDayProvider);
    }
    return false;
  }
}
