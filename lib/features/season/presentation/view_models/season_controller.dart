import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/data/repositories/season_repository_impl.dart';
import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';

typedef PondSeasonScope = ({String farmId, String pondId});

final seasonRemoteDataSourceProvider = Provider<SeasonRemoteDataSource>((ref) {
  return SeasonApiService(ref.watch(apiClientProvider));
});

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return SeasonRepositoryImpl(ref.watch(seasonRemoteDataSourceProvider));
});

final pondSeasonHistoryProvider = FutureProvider.autoDispose
    .family<List<AquacultureSeason>, PondSeasonScope>((ref, scope) async {
      if (ref.watch(authControllerProvider).value?.role !=
          AccountRole.farmOwner) {
        throw const UnsupportedRoleException();
      }

      final seasons = <AquacultureSeason>[];
      final knownIds = <String>{};
      final seenCursors = <String>{};
      String? cursor;
      try {
        do {
          final page = await ref
              .read(seasonRepositoryProvider)
              .getSeasons(
                farmId: scope.farmId,
                pondId: scope.pondId,
                cursor: cursor,
                limit: 100,
              );
          seasons.addAll(page.items.where((item) => knownIds.add(item.id)));
          if (!page.hasNextPage) break;

          final nextCursor = page.nextCursor;
          if (nextCursor == null || !seenCursors.add(nextCursor)) {
            throw const InvalidResponseException();
          }
          cursor = nextCursor;
        } while (true);
        return seasons;
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

final seasonDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SeasonDetailController, AquacultureSeason, String>(
      SeasonDetailController.new,
    );

final seasonMutationControllerProvider =
    AsyncNotifierProvider.autoDispose<SeasonMutationController, void>(
      SeasonMutationController.new,
    );

final assignablePersonnelProvider = FutureProvider.autoDispose
    .family<List<ManagedPersonnel>, AccountRole>((ref, role) async {
      if (role != AccountRole.technician && role != AccountRole.expert) {
        throw ArgumentError.value(role, 'role', 'Vai trò không hợp lệ');
      }
      if (ref.watch(authControllerProvider).value?.role !=
          AccountRole.farmOwner) {
        throw const UnsupportedRoleException();
      }

      final result = <ManagedPersonnel>[];
      final knownIds = <String>{};
      final seenCursors = <String>{};
      String? cursor;
      try {
        do {
          final page = await ref
              .read(personnelRepositoryProvider)
              .getPersonnel(
                cursor: cursor,
                limit: 100,
                role: role,
                status: AccountStatus.active,
              );
          result.addAll(page.items.where((item) => knownIds.add(item.id)));
          if (!page.hasNextPage) break;
          final nextCursor = page.nextCursor;
          if (nextCursor == null || !seenCursors.add(nextCursor)) {
            throw const InvalidResponseException();
          }
          cursor = nextCursor;
        } while (true);
        return result;
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

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

  Future<SeasonAssignment> assignPersonnel({
    required String farmId,
    required AquacultureSeason current,
    required String accountId,
    required AccountRole role,
  }) => _mutate(
    () => ref
        .read(seasonRepositoryProvider)
        .assignPersonnel(
          seasonId: current.id,
          accountId: accountId,
          role: role,
        ),
    farmId: farmId,
    pondId: current.pondId,
    seasonId: current.id,
    invalidatePersonnel: true,
    invalidateSeasonDetail: false,
  );

  Future<SeasonPersonnelReplacementResult> replacePersonnel({
    required String farmId,
    required AquacultureSeason current,
    required String accountId,
    required AccountRole role,
    required String expectedAssignmentId,
    required String reason,
  }) => _mutate(
    () => ref
        .read(seasonRepositoryProvider)
        .replacePersonnel(
          seasonId: current.id,
          accountId: accountId,
          role: role,
          expectedAssignmentId: expectedAssignmentId,
          reason: reason,
        ),
    farmId: farmId,
    pondId: current.pondId,
    seasonId: current.id,
    invalidatePersonnel: true,
    invalidateSeasonDetail: false,
  );

  Future<R> _mutate<R>(
    Future<R> Function() operation, {
    required String farmId,
    required String pondId,
    String? seasonId,
    bool invalidatePersonnel = false,
    bool invalidateSeasonDetail = true,
  }) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading<void>();
    try {
      final result = await runAuthenticated(operation);
      state = const AsyncData<void>(null);
      ref
        ..invalidate(
          pondSeasonHistoryProvider((farmId: farmId, pondId: pondId)),
        )
        ..invalidate(farmDetailControllerProvider(farmId))
        ..invalidate(
          pondDetailControllerProvider((farmId: farmId, pondId: pondId)),
        );
      if (seasonId != null && invalidateSeasonDetail) {
        ref.invalidate(seasonDetailControllerProvider(seasonId));
      }
      if (invalidatePersonnel) {
        ref
          ..invalidate(assignablePersonnelProvider)
          ..invalidate(personnelListControllerProvider)
          ..invalidate(activePersonnelCountProvider);
      }
      return result;
    } on Object catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}
