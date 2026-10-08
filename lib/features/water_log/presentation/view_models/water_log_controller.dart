import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/data/repositories/water_log_repository_impl.dart';
import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';

final waterLogRepositoryProvider = Provider<WaterLogRepository>((ref) {
  final role = ref.watch(authControllerProvider).value?.role;
  final basePath = switch (role) {
    AccountRole.technician => '/me/seasons',
    AccountRole.expert => '/expert/seasons',
    AccountRole.farmOwner => '/owner/seasons',
    _ => throw const UnsupportedRoleException(),
  };
  return WaterLogRepositoryImpl(
    WaterLogApiService(ref.watch(apiClientProvider), basePath),
  );
});

final waterLogListProvider = AsyncNotifierProvider.autoDispose
    .family<WaterLogListController, WaterLogPage, String>(
      WaterLogListController.new,
    );

/// Nhật ký mới nhất (chưa hủy) của vụ — dùng cho card "Đo nước gần nhất".
final latestWaterLogProvider = FutureProvider.autoDispose
    .family<WaterLog?, String>((ref, seasonId) async {
      final repository = ref.watch(waterLogRepositoryProvider);
      try {
        final page = await repository.getWaterLogs(
          seasonId: seasonId,
          limit: 1,
        );
        return page.items.isEmpty ? null : page.items.first;
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

final class WaterLogListController extends AsyncNotifier<WaterLogPage> {
  WaterLogListController(this.seasonId);

  final String seasonId;
  bool _loadingMore = false;

  @override
  Future<WaterLogPage> build() => _fetch();

  Future<WaterLogPage> _fetch({String? cursor}) async {
    try {
      return await ref
          .read(waterLogRepositoryProvider)
          .getWaterLogs(
            seasonId: seasonId,
            includeVoided: true,
            cursor: cursor,
          );
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> refresh() async {
    final previous = state.value;
    try {
      final refreshed = await _fetch();
      if (ref.mounted) state = AsyncData(refreshed);
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      if (previous == null) {
        state = AsyncError<WaterLogPage>(error, stackTrace);
      }
      // Giữ dữ liệu cũ hiển thị, để page báo lỗi.
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await _fetch(cursor: current.nextCursor);
      if (ref.mounted) state = AsyncData(current.append(next));
    } finally {
      _loadingMore = false;
    }
  }

  /// Tạo nhật ký mới rồi refresh danh sách. Trả về log vừa tạo.
  Future<WaterLog> createWaterLog({
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) async {
    try {
      final created = await ref
          .read(waterLogRepositoryProvider)
          .createWaterLog(
            seasonId: seasonId,
            payload: payload,
            idempotencyKey: idempotencyKey,
          );
      await _refreshAfterMutation();
      return created;
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  /// Hủy hiệu lực rồi refresh danh sách.
  Future<void> voidWaterLog({
    required String logId,
    required String voidReason,
  }) async {
    try {
      await ref
          .read(waterLogRepositoryProvider)
          .voidWaterLog(
            seasonId: seasonId,
            logId: logId,
            voidReason: voidReason,
          );
      await _refreshAfterMutation();
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> _refreshAfterMutation() async {
    if (!ref.mounted) return;
    ref.invalidate(latestWaterLogProvider(seasonId));
    try {
      await refresh();
    } on Object {
      // The write already succeeded. Refresh errors must not ask users to
      // submit it again; refresh() keeps the previous list or its error state.
    }
  }
}
