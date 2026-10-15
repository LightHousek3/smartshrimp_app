import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/data/repositories/water_log_repository_impl.dart';
import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_list_state.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_read_retry.dart';

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
    .family<WaterLogListController, WaterLogListState, String>(
      WaterLogListController.new,
    );

final waterLogMetadataProvider = FutureProvider.autoDispose
    .family<WaterLogMetadata, String>((ref, seasonId) async {
      ref.watch(waterLogRevisionProvider(seasonId));
      try {
        return await ref
            .watch(waterLogRepositoryProvider)
            .getMetadata(seasonId: seasonId);
      } on SessionExpiredException {
        if (ref.mounted) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
        rethrow;
      }
    }, retry: waterLogReadRetry);

final waterLogCanWriteProvider = Provider.autoDispose.family<bool, String>((
  ref,
  seasonId,
) {
  if (ref.watch(authControllerProvider).value?.role != AccountRole.technician) {
    return false;
  }
  return ref
          .watch(assignedSeasonDetailProvider(seasonId))
          .asData
          ?.value
          .status ==
      AssignedSeasonStatus.active;
});

typedef WaterLogStatsQuery = ({String seasonId, int days, String granularity});

final waterLogStatisticsProvider = FutureProvider.autoDispose
    .family<WaterLogStatistics, WaterLogStatsQuery>((ref, query) async {
      ref.watch(waterLogRevisionProvider(query.seasonId));
      final repository = ref.watch(waterLogRepositoryProvider);
      final to = DateTime.now();
      try {
        return await repository.getStatistics(
          seasonId: query.seasonId,
          from: to.subtract(Duration(days: query.days)),
          to: to,
          granularity: query.granularity,
        );
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

final waterLogRevisionProvider = NotifierProvider.autoDispose
    .family<WaterLogRevision, int, String>(WaterLogRevision.new);

final class WaterLogRevision extends Notifier<int> {
  WaterLogRevision(this.seasonId);
  final String seasonId;
  @override
  int build() => 0;
  void changed() => state++;
}

/// Invalidate other water views after a read refresh or successful write.
void invalidateWaterLogViews(WidgetRef ref, String seasonId) {
  ref.invalidate(latestWaterLogProvider(seasonId));
  ref.read(waterLogRevisionProvider(seasonId).notifier).changed();
}

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

final class WaterLogListController extends AsyncNotifier<WaterLogListState> {
  WaterLogListController(this.seasonId);

  final String seasonId;
  int _generation = 0;
  int? _loadingMoreGeneration;
  bool _refreshing = false;
  WaterLogFilter _filter = WaterLogFilter.all;
  DateTime? _from;
  DateTime? _to;
  WaterLogFilter get filter => _filter;

  Future<WaterLogMetadata> loadMetadata() async {
    try {
      // Fetch on each submission: no stale species/policy/account cache.
      return await ref
          .read(waterLogRepositoryProvider)
          .getMetadata(seasonId: seasonId);
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  @override
  Future<WaterLogListState> build() async {
    ref.watch(waterLogRepositoryProvider);
    _generation++;
    _refreshing = false;
    _loadingMoreGeneration = null;
    return WaterLogListState(page: await _fetch());
  }

  Future<WaterLogPage> _fetch({String? cursor}) async {
    final generation = _generation;
    try {
      return await ref
          .read(waterLogRepositoryProvider)
          .getWaterLogs(
            seasonId: seasonId,
            filter: _filter,
            from: _from,
            to: _to,
            includeCounts: cursor == null,
            cursor: cursor,
          );
    } on SessionExpiredException {
      if (ref.mounted && generation == _generation) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }

  Future<void> refresh() async {
    if (state.isLoading) {
      // Let Riverpod cancel an unfinished build, including its automatic state update.
      ref.invalidateSelf();
      await future;
      return;
    }
    final generation = ++_generation;
    _refreshing = true;
    _loadingMoreGeneration = null;
    final previous = state.value;
    if (previous != null) {
      state = AsyncData(
        previous.copyWith(loadingMore: false, paginationError: null),
      );
    }
    try {
      final refreshed = await _fetch();
      if (!ref.mounted || generation != _generation) return;
      _refreshing = false;
      state = AsyncData(WaterLogListState(page: refreshed));
    } on Object catch (error, stackTrace) {
      if (!ref.mounted || generation != _generation) return;
      if (previous == null) {
        state = AsyncError<WaterLogListState>(error, stackTrace);
      }
      // Giữ dữ liệu cũ hiển thị, để page báo lỗi.
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      if (generation == _generation) _refreshing = false;
    }
  }

  Future<void> setQuery({
    required WaterLogFilter filter,
    DateTime? from,
    DateTime? to,
  }) async {
    if (filter == _filter && from == _from && to == _to) return;
    _filter = filter;
    _from = from;
    _to = to;
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Riverpod has published the first-page error for this query.
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    final generation = _generation;
    if (current == null ||
        !current.page.hasNextPage ||
        _refreshing ||
        _loadingMoreGeneration == generation) {
      return;
    }
    _loadingMoreGeneration = generation;
    state = AsyncData(
      current.copyWith(loadingMore: true, paginationError: null),
    );
    try {
      final cursor = current.page.nextCursor;
      if (cursor == null || cursor.trim().isEmpty) {
        throw const InvalidResponseException();
      }
      final next = await _fetch(cursor: cursor);
      // A refresh starts a new snapshot; late pages belong to the old one.
      if (ref.mounted && generation == _generation) {
        if (next.hasNextPage &&
            (next.nextCursor == null ||
                next.nextCursor!.trim().isEmpty ||
                next.nextCursor == cursor)) {
          throw const InvalidResponseException();
        }
        state = AsyncData(WaterLogListState(page: current.page.append(next)));
      }
    } on Object catch (error) {
      // Errors from superseded pages must not replace the current snapshot.
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        current.copyWith(loadingMore: false, paginationError: error),
      );
    } finally {
      if (_loadingMoreGeneration == generation) _loadingMoreGeneration = null;
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
    ref.read(waterLogRevisionProvider(seasonId).notifier).changed();
    try {
      await refresh();
    } on Object {
      // The write already succeeded. Refresh errors must not ask users to
      // submit it again; refresh() keeps the previous list or its error state.
    }
  }
}
