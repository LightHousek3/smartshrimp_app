import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/data/repositories/assigned_season_repository_impl.dart';
import 'package:smartshrimp_app/features/assigned_season/data/services/assigned_season_api_service.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

final assignedSeasonRepositoryProvider = Provider<AssignedSeasonRepository>(
  (ref) => AssignedSeasonRepositoryImpl(
    AssignedSeasonApiService(ref.watch(apiClientProvider)),
  ),
);

final assignedSeasonListProvider =
    AsyncNotifierProvider.autoDispose<
      AssignedSeasonListController,
      AssignedSeasonPage
    >(AssignedSeasonListController.new);
final assignedSeasonDetailProvider = AsyncNotifierProvider.autoDispose
    .family<AssignedSeasonDetailController, AssignedSeasonDetail, String>(
      AssignedSeasonDetailController.new,
    );

final class AssignedSeasonListController
    extends AsyncNotifier<AssignedSeasonPage> {
  AssignedSeasonStatus? _status = AssignedSeasonStatus.active;
  bool _loadingMore = false;
  @override
  Future<AssignedSeasonPage> build() => _fetch();

  Future<AssignedSeasonPage> _fetch({String? cursor}) async {
    try {
      return await ref
          .read(assignedSeasonRepositoryProvider)
          .getAssignedSeasons(status: _status, cursor: cursor);
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> setActiveOnly(bool activeOnly) async {
    _status = activeOnly ? AssignedSeasonStatus.active : null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refresh() async {
    final previous = state.value;
    try {
      final refreshed = await _fetch();
      if (ref.mounted) state = AsyncData(refreshed);
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      if (previous == null) {
        state = AsyncError<AssignedSeasonPage>(error, stackTrace);
      }
      // Keep current data visible while letting the page report the failure.
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await _fetch(cursor: current.nextCursor);
      state = AsyncData(current.append(next));
    } finally {
      _loadingMore = false;
    }
  }
}

final class AssignedSeasonDetailController
    extends AsyncNotifier<AssignedSeasonDetail> {
  AssignedSeasonDetailController(this.seasonId);
  final String seasonId;
  @override
  Future<AssignedSeasonDetail> build() => _load();
  Future<AssignedSeasonDetail> _load() =>
      ref.read(assignedSeasonRepositoryProvider).getAssignedSeason(seasonId);
  Future<void> refresh() async => state = await AsyncValue.guard(_load);
}
