import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/data/repositories/assigned_season_repository_impl.dart';
import 'package:smartshrimp_app/features/assigned_season/data/services/assigned_season_api_service.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';

// Existing composition root also acts as the feature's public barrel.
export 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
export 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';

/// Independent preview state prevents the full operation page's filters from
/// changing what "today" means on the assigned-season detail page.
final assignedSeasonTodayOperationsProvider = FutureProvider.autoDispose
    .family<List<OperationSchedule>, String>(
      (ref, seasonId) async {
        final now = DateTime.now().toUtc();
        final day = AssignedSeasonRules.vietnamDay(now);
        final start = day.subtract(AssignedSeasonRules.vietnamOffset);
        final end = start.add(const Duration(days: 1));
        // Refresh at Vietnam midnight even if the page stays open overnight.
        final midnight = Timer(end.difference(now), ref.invalidateSelf);
        ref.onDispose(midnight.cancel);
        try {
          final repository = ref.watch(operationRepositoryProvider);
          // The API date filter is UTC. Vietnam today overlaps two UTC dates.
          final batches = await Future.wait([
            _loadOperationPreviewDay(repository, seasonId, start, start, end),
            _loadOperationPreviewDay(repository, seasonId, day, start, end),
          ]);
          final schedules = batches.expand((items) => items).toList()
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
          return schedules
              .take(AssignedSeasonRules.operationPreviewSize)
              .toList();
        } on SessionExpiredException {
          await ref.read(authControllerProvider.notifier).expireSession();
          rethrow;
        }
      },
      // Surface failures immediately; the detail page owns the explicit retry action.
      retry: (_, _) => null,
    );

/// Read beyond the first page when earlier UTC hours fill it. The API orders
/// schedules by time, so three matches per UTC date are enough for this preview.
Future<List<OperationSchedule>> _loadOperationPreviewDay(
  OperationRepository repository,
  String seasonId,
  DateTime utcDay,
  DateTime start,
  DateTime end,
) async {
  final matches = <OperationSchedule>[];
  for (var page = 1; ; page++) {
    final result = await repository.getSchedules(
      seasonId,
      date: AssignedSeasonRules.dateOnly(utcDay),
      page: page,
      limit: AssignedSeasonRules.operationPageSize,
    );
    matches.addAll(
      result.schedules.where(
        (schedule) =>
            !schedule.scheduledAt.isBefore(start) &&
            schedule.scheduledAt.isBefore(end),
      ),
    );
    if (matches.length >= AssignedSeasonRules.operationPreviewSize ||
        result.schedules.length < AssignedSeasonRules.operationPageSize ||
        !result.schedules.last.scheduledAt.isBefore(end)) {
      return matches;
    }
  }
}

final assignedSeasonRepositoryProvider = Provider<AssignedSeasonRepository>(
  (ref) => AssignedSeasonRepositoryImpl(
    AssignedSeasonApiService(ref.watch(apiClientProvider)),
  ),
);

/// Farm options are independent of list filters and discarded on account change.
final assignedSeasonFarmOptionsProvider =
    FutureProvider.autoDispose<List<AssignedSeasonFarm>>((ref) async {
      ref.watch(authControllerProvider.select((state) => state.value?.id));
      try {
        return await ref
            .watch(assignedSeasonRepositoryProvider)
            .getAssignedSeasonFarms();
      } on SessionExpiredException {
        if (ref.mounted) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
        rethrow;
      }
    }, retry: (_, _) => null);

typedef AssignedSeasonFilter = ({
  AssignedSeasonStatus? status,
  String search,
  String? farmId,
});

final assignedSeasonListProvider =
    AsyncNotifierProvider.autoDispose<
      AssignedSeasonListController,
      AssignedSeasonPage
    >(AssignedSeasonListController.new, retry: (_, _) => null);
final assignedSeasonDetailProvider = AsyncNotifierProvider.autoDispose
    .family<AssignedSeasonDetailController, AssignedSeasonDetail, String>(
      AssignedSeasonDetailController.new,
    );

final class AssignedSeasonListController
    extends AsyncNotifier<AssignedSeasonPage> {
  AssignedSeasonFilter _filter = (
    status: AssignedSeasonStatus.active,
    search: '',
    farmId: null,
  );
  bool _loadingMore = false;
  int _revision = 0;
  AssignedSeasonFilter? _dataFilter;

  // Retained Riverpod data is safe to display only under its original filter.
  bool get retainRowsOnRefresh => _dataFilter == _filter;
  AssignedSeasonFilter get filter => _filter;

  @override
  Future<AssignedSeasonPage> build() {
    _revision++;
    _loadingMore = false;
    return _fetch(filter: _filter);
  }

  bool _isCurrent(int revision) => ref.mounted && revision == _revision;

  Future<AssignedSeasonPage> _fetch({
    required AssignedSeasonFilter filter,
    String? cursor,
  }) async {
    final revision = _revision;
    try {
      final page = await ref
          .read(assignedSeasonRepositoryProvider)
          .getAssignedSeasons(
            status: filter.status,
            search: filter.search,
            farmId: filter.farmId,
            cursor: cursor,
          );
      if (_isCurrent(revision)) _dataFilter = filter;
      return page;
    } on SessionExpiredException {
      if (ref.mounted) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }

  Future<void> setActiveOnly(bool activeOnly) => setFilters(
    status: activeOnly ? AssignedSeasonStatus.active : null,
    search: _filter.search,
    farmId: _filter.farmId,
  );

  /// Apply the whole query atomically so pagination never mixes filter scopes.
  Future<void> setFilters({
    required AssignedSeasonStatus? status,
    required String search,
    required String? farmId,
  }) async {
    final next = (status: status, search: search.trim(), farmId: farmId);
    if (next == _filter) return;
    _filter = next;
    await AsyncValue.guard(_reload);
  }

  Future<void> refresh() async {
    await _reload();
  }

  Future<void> _reload() async {
    // Invalidate immediately, including pagination still awaiting a response.
    // Rebuilding also cancels the initial build future; manual state assignment
    // would allow that initial response to overwrite a newer refresh result.
    _revision++;
    _loadingMore = false;
    ref.invalidateSelf();
    // Riverpod retains previous data on refresh failure; the page reports it.
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (state.isLoading ||
        !retainRowsOnRefresh ||
        current == null ||
        !current.hasNextPage ||
        _loadingMore) {
      return;
    }
    final revision = _revision;
    final filter = _filter;
    _loadingMore = true;
    try {
      final next = await _fetch(filter: filter, cursor: current.nextCursor);
      if (_isCurrent(revision)) state = AsyncData(current.append(next));
    } on Object {
      // A failure from an obsolete query must not appear under the new filter.
      if (_isCurrent(revision)) rethrow;
    } finally {
      // An old request must not release a newer query's pagination lock.
      if (_isCurrent(revision)) _loadingMore = false;
    }
  }
}

final class AssignedSeasonDetailController
    extends AsyncNotifier<AssignedSeasonDetail> {
  AssignedSeasonDetailController(this.seasonId);
  final String seasonId;
  @override
  Future<AssignedSeasonDetail> build() => _load();
  Future<AssignedSeasonDetail> _load() async {
    try {
      return await ref
          .read(assignedSeasonRepositoryProvider)
          .getAssignedSeason(seasonId);
    } on SessionExpiredException {
      // Keep detail and list consistent when refresh-token recovery fails.
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> refresh() async => state = await AsyncValue.guard(_load);
}
