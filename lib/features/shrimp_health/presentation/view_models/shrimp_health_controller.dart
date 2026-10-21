import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/data/repositories/shrimp_health_repository_impl.dart';
import 'package:smartshrimp_app/features/shrimp_health/data/services/shrimp_health_api_service.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/repositories/shrimp_health_repository.dart';

final shrimpHealthRepositoryProvider = Provider<ShrimpHealthRepository>((ref) {
  final role = ref.watch(authControllerProvider).value?.role;
  final basePath = switch (role) {
    AccountRole.technician => '/me/seasons',
    AccountRole.expert => '/expert/seasons',
    AccountRole.farmOwner => '/owner/seasons',
    _ => '/me/seasons',
  };
  return ShrimpHealthRepositoryImpl(
    ShrimpHealthApiService(ref.watch(apiClientProvider), basePath: basePath),
  );
});

/// State filter for tab selection: 'all', 'valid', 'voided'
final shrimpHealthFilterTabProvider =
    NotifierProvider.autoDispose<ShrimpHealthFilterTabController, String>(
      ShrimpHealthFilterTabController.new,
    );

final class ShrimpHealthFilterTabController extends Notifier<String> {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;
}

final shrimpHealthListProvider = AsyncNotifierProvider.autoDispose
    .family<ShrimpHealthListController, ShrimpHealthListResult, String>(
      ShrimpHealthListController.new,
    );

final class ShrimpHealthListController extends AsyncNotifier<ShrimpHealthListResult> {
  ShrimpHealthListController(this.seasonId);
  final String seasonId;

  String? _filter = 'all';
  String? _healthStatus;
  DateTime? _from;
  DateTime? _to;
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<ShrimpHealthListResult> build() => _fetch();

  Future<ShrimpHealthListResult> _fetch({String? cursor}) async {
    try {
      return await ref.read(shrimpHealthRepositoryProvider).listLogs(
        seasonId,
        filter: _filter,
        healthStatus: _healthStatus,
        from: _from,
        to: _to,
        cursor: cursor,
        includeCounts: true,
      );
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> setFilter({
    String? filter,
    String? healthStatus,
    DateTime? from,
    DateTime? to,
  }) async {
    _filter = filter ?? _filter;
    _healthStatus = healthStatus;
    _from = from;
    _to = to;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasNext || current.nextCursor == null || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    try {
      final more = await _fetch(cursor: current.nextCursor);
      state = AsyncData(
        ShrimpHealthListResult(
          logs: [...current.logs, ...more.logs],
          nextCursor: more.nextCursor,
          hasNext: more.hasNext,
          counts: more.counts ?? current.counts,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

typedef ShrimpHealthStatsQuery = ({
  String seasonId,
  int days,
});

final shrimpHealthStatsProvider = FutureProvider.autoDispose
    .family<ShrimpHealthStatsResult, ShrimpHealthStatsQuery>(
      (ref, query) async {
        final now = DateTime.now();
        final to = now;
        final from = now.subtract(Duration(days: query.days));
        final granularity = query.days <= 14 ? 'day' : 'day';

        try {
          return await ref.read(shrimpHealthRepositoryProvider).getStatistics(
            query.seasonId,
            from: from,
            to: to,
            granularity: granularity,
          );
        } on SessionExpiredException {
          await ref.read(authControllerProvider.notifier).expireSession();
          rethrow;
        }
      },
    );

typedef ShrimpHealthDetailQuery = ({
  String seasonId,
  String logId,
});

final shrimpHealthDetailProvider = FutureProvider.autoDispose
    .family<ShrimpHealthLog, ShrimpHealthDetailQuery>(
      (ref, query) async {
        try {
          return await ref.watch(shrimpHealthRepositoryProvider).getLogDetail(
            query.seasonId,
            query.logId,
          );
        } on SessionExpiredException {
          await ref.read(authControllerProvider.notifier).expireSession();
          rethrow;
        }
      },
    );

