import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/data/repositories/season_repository_impl.dart';
import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';

typedef SeasonListScope = ({String? farmId, String? pondId});

final seasonRemoteDataSourceProvider = Provider<SeasonRemoteDataSource>((ref) {
  return SeasonApiService(ref.watch(apiClientProvider));
});

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return SeasonRepositoryImpl(ref.watch(seasonRemoteDataSourceProvider));
});

final seasonListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SeasonListController, SeasonPage, SeasonListScope>(
      SeasonListController.new,
    );

final seasonDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SeasonDetailController, AquacultureSeason, String>(
      SeasonDetailController.new,
    );

final seasonMutationControllerProvider =
    AsyncNotifierProvider.autoDispose<SeasonMutationController, void>(
      SeasonMutationController.new,
    );

abstract base class _OwnerSeasonController<T> extends AsyncNotifier<T> {
  void requireOwner() {
    if (ref.watch(authControllerProvider).value?.role !=
        AccountRole.farmOwner) {
      throw const UnsupportedRoleException();
    }
  }

  Future<R> runAuthenticated<R>(Future<R> Function() operation) async {
    try {
      return await operation();
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }
}

final class SeasonListController extends _OwnerSeasonController<SeasonPage> {
  SeasonListController(this.scope);

  final SeasonListScope scope;
  static const _limit = 20;
  String _search = '';
  SeasonStatus? _status;
  bool _loadingMore = false;
  int _generation = 0;

  @override
  Future<SeasonPage> build() {
    requireOwner();
    return _fetch();
  }

  Future<void> applyFilters({
    String? search,
    SeasonStatus? status,
    bool clearStatus = false,
  }) async {
    if (search != null) _search = search;
    if (clearStatus) {
      _status = null;
    } else if (status != null) {
      _status = status;
    }
    await refresh();
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted && generation == _generation) state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || _loadingMore) return;
    _loadingMore = true;
    final generation = ++_generation;
    try {
      final next = await _fetch(cursor: current.nextCursor);
      if (ref.mounted && generation == _generation) {
        state = AsyncData(current.append(next));
      }
    } on Object catch (error, stackTrace) {
      if (ref.mounted && generation == _generation) {
        state = AsyncError<SeasonPage>(error, stackTrace);
      }
    } finally {
      _loadingMore = false;
    }
  }

  Future<SeasonPage> _fetch({String? cursor}) => runAuthenticated(
    () => ref
        .read(seasonRepositoryProvider)
        .getSeasons(
          farmId: scope.farmId,
          pondId: scope.pondId,
          status: _status,
          search: _search,
          cursor: cursor,
          limit: _limit,
        ),
  );
}

final class SeasonDetailController
    extends _OwnerSeasonController<AquacultureSeason> {
  SeasonDetailController(this.seasonId);

  final String seasonId;

  @override
  Future<AquacultureSeason> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async => state = await AsyncValue.guard(_load);

  Future<AquacultureSeason> _load() => runAuthenticated(
    () => ref.read(seasonRepositoryProvider).getSeason(seasonId),
  );
}

final class SeasonMutationController extends _OwnerSeasonController<void> {
  @override
  Future<void> build() async => requireOwner();

  Future<AquacultureSeason> create({
    required String farmId,
    required String pondId,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  }) => _mutate(
    () => ref
        .read(seasonRepositoryProvider)
        .createSeason(
          pondId: pondId,
          name: name,
          shrimpType: shrimpType,
          stockingDate: stockingDate,
          expectedEndDate: expectedEndDate,
          initialQuantity: initialQuantity,
          initialAvgWeightG: initialAvgWeightG,
        ),
    farmId: farmId,
    pondId: pondId,
  );

  Future<AquacultureSeason> updateSeason({
    required String farmId,
    required AquacultureSeason current,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  }) => _mutate(
    () => ref
        .read(seasonRepositoryProvider)
        .updateSeason(
          current: current,
          name: name,
          shrimpType: shrimpType,
          stockingDate: stockingDate,
          expectedEndDate: expectedEndDate,
          initialQuantity: initialQuantity,
          initialAvgWeightG: initialAvgWeightG,
        ),
    farmId: farmId,
    pondId: current.pondId,
    seasonId: current.id,
  );

  Future<AquacultureSeason> activate({
    required String farmId,
    required AquacultureSeason current,
  }) => _mutate(
    () => ref.read(seasonRepositoryProvider).activateSeason(current),
    farmId: farmId,
    pondId: current.pondId,
    seasonId: current.id,
  );

  Future<SeasonCancellationResult> cancel({
    required String farmId,
    required AquacultureSeason current,
    required String reason,
  }) => _mutate(
    () => ref
        .read(seasonRepositoryProvider)
        .cancelSeason(current: current, reason: reason),
    farmId: farmId,
    pondId: current.pondId,
    seasonId: current.id,
  );

  Future<R> _mutate<R>(
    Future<R> Function() operation, {
    required String farmId,
    required String pondId,
    String? seasonId,
  }) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading<void>();
    try {
      final result = await runAuthenticated(operation);
      state = const AsyncData<void>(null);
      ref
        ..invalidate(seasonListControllerProvider)
        ..invalidate(farmDetailControllerProvider(farmId))
        ..invalidate(
          pondDetailControllerProvider((farmId: farmId, pondId: pondId)),
        );
      if (seasonId != null) {
        ref.invalidate(seasonDetailControllerProvider(seasonId));
      }
      return result;
    } on Object catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}
