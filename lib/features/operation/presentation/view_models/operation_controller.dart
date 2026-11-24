import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/operation/data/repositories/operation_repository_impl.dart';
import 'package:smartshrimp_app/features/operation/data/services/operation_api_service.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';

final operationRepositoryProvider = Provider<OperationRepository>(
  (ref) => OperationRepositoryImpl(
    OperationApiService(ref.watch(apiClientProvider)),
  ),
);

final operationFilterTabProvider =
    NotifierProvider.autoDispose<OperationFilterTabController, String>(
      OperationFilterTabController.new,
    );

final class OperationFilterTabController extends Notifier<String> {
  @override
  String build() => 'PLANNED';

  void setTab(String tab) => state = tab;
}

final operationDateFilterProvider =
    NotifierProvider.autoDispose<OperationDateFilterController, DateTime>(
      OperationDateFilterController.new,
    );

final class OperationDateFilterController extends Notifier<DateTime> {
  @override
  DateTime build() => AssignedSeasonRules.vietnamDay(DateTime.now());

  void setDate(DateTime date) =>
      state = DateTime.utc(date.year, date.month, date.day);
}

final operationListProvider = AsyncNotifierProvider.autoDispose
    .family<OperationListController, OperationListResult, String>(
      OperationListController.new,
    );

final operationDetailProvider = AsyncNotifierProvider.autoDispose
    .family<OperationDetailController, OperationSchedule, String>(
      OperationDetailController.new,
    );

final operationStatsProvider = FutureProvider.autoDispose
    .family<OperationStats, String>((ref, seasonId) async {
      try {
        return await ref
            .watch(operationRepositoryProvider)
            .getSeasonStats(seasonId);
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

final class OperationListController extends AsyncNotifier<OperationListResult> {
  OperationListController(this.seasonId);
  final String seasonId;

  final Map<String, OperationListResult> _cacheByDate =
      <String, OperationListResult>{};
  int _requestSeq = 0;
  int _cacheGeneration = 0;

  String _formatDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Future<OperationListResult> build() async {
    final selectedDate = ref.read(operationDateFilterProvider);
    final dateStr = _formatDate(selectedDate);
    final result = await _fetch(dateStr);
    _cacheByDate[dateStr] = result;
    if (ref.mounted) _prefetchUpcomingDays();
    return result;
  }

  Future<OperationListResult> _fetch(String dateStr) async {
    try {
      final repository = ref.read(operationRepositoryProvider);
      const limit = AssignedSeasonRules.operationPageSize;
      final first = await repository.getSchedules(
        seasonId,
        date: dateStr,
        limit: limit,
      );
      if (first.nextPage == null) return first;

      // Load the whole day before grouping materials into occurrences.
      final schedules = {for (final row in first.schedules) row.id: row};
      var nextPage = first.nextPage;
      while (nextPage != null) {
        final result = await repository.getSchedules(
          seasonId,
          date: dateStr,
          page: nextPage,
          limit: limit,
        );
        for (final row in result.schedules) {
          schedules[row.id] = row;
        }
        nextPage = result.nextPage;
      }
      return OperationListResult(
        summary: first.summary,
        banner: first.banner,
        schedules: schedules.values.toList(growable: false),
        seasonName: first.seasonName,
        pondName: first.pondName,
        seasonStartDate: first.seasonStartDate,
        historicalFeedingAvailable: first.historicalFeedingAvailable,
        historicalSchedules: first.historicalSchedules,
      );
    } on SessionExpiredException {
      if (ref.mounted) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }

  Future<void> _prefetchUpcomingDays() async {
    final generation = _cacheGeneration;
    final today = AssignedSeasonRules.vietnamDay(DateTime.now());
    final targets = <DateTime>[
      today,
      today.add(const Duration(days: 1)),
      today.add(const Duration(days: 2)),
    ];

    for (final day in targets) {
      if (!ref.mounted || generation != _cacheGeneration) return;
      final key = _formatDate(day);
      if (_cacheByDate.containsKey(key)) continue;
      try {
        final data = await _fetch(key);
        if (!ref.mounted || generation != _cacheGeneration) return;
        _cacheByDate.putIfAbsent(key, () => data);
      } catch (_) {
        // Retry unavailable data when the user selects the date.
      }
    }
  }

  Future<void> selectDate(DateTime date) async {
    ref.read(operationDateFilterProvider.notifier).setDate(date);
    final dateStr = _formatDate(date);

    final seq = ++_requestSeq;
    final cached = _cacheByDate[dateStr];
    if (cached != null) {
      state = AsyncData(cached);
      return;
    }

    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(() => _fetch(dateStr));
    if (!ref.mounted || seq != _requestSeq) return;
    if (nextState case AsyncData(:final value)) {
      _cacheByDate[dateStr] = value;
    }
    state = nextState;
  }

  Future<void> refresh() async {
    _cacheGeneration++;
    _cacheByDate.clear();
    final selectedDate = ref.read(operationDateFilterProvider);
    final dateStr = _formatDate(selectedDate);
    final seq = ++_requestSeq;
    final nextState = await AsyncValue.guard(() => _fetch(dateStr));
    if (!ref.mounted || seq != _requestSeq) return;
    if (nextState case AsyncData(:final value)) {
      _cacheByDate[dateStr] = value;
      _prefetchUpcomingDays();
    }
    state = nextState;
  }

  void setFilterTab(String tab) {
    ref.read(operationFilterTabProvider.notifier).setTab(tab);
  }
}

final class OperationDetailController extends AsyncNotifier<OperationSchedule> {
  OperationDetailController(this.scheduleId);
  final String scheduleId;

  @override
  Future<OperationSchedule> build() => _fetch();

  Future<OperationSchedule> _fetch() async {
    try {
      return await ref
          .read(operationRepositoryProvider)
          .getSchedule(scheduleId);
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted) state = result;
  }
}
