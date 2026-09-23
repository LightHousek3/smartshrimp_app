import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/pond/data/repositories/pond_repository_impl.dart';
import 'package:smartshrimp_app/features/pond/data/services/pond_api_service.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/repositories/pond_repository.dart';

final pondRemoteDataSourceProvider = Provider<PondRemoteDataSource>((ref) {
  return PondApiService(ref.watch(apiClientProvider));
});

final pondRepositoryProvider = Provider<PondRepository>((ref) {
  return PondRepositoryImpl(ref.watch(pondRemoteDataSourceProvider));
});

final pondListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PondListController, PondPage, String>(PondListController.new);

final pondDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PondDetailController, Pond, ({String farmId, String pondId})>(
      PondDetailController.new,
    );

final pondMutationControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PondMutationController, void, String>(PondMutationController.new);

abstract base class _OwnerPondController<T> extends AsyncNotifier<T> {
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

final class PondListController extends _OwnerPondController<PondPage> {
  PondListController(this.farmId);
  final String farmId;

  static const _limit = 20;
  String _search = '';
  PondStatus? _status;
  PondType? _type;
  bool _loadingMore = false;
  int _generation = 0;

  @override
  Future<PondPage> build() {
    requireOwner();
    return _fetch(1);
  }

  Future<void> applyFilters({
    String? search,
    PondStatus? status,
    PondType? type,
    bool clearStatus = false,
    bool clearType = false,
  }) async {
    if (search != null) _search = search;
    if (clearStatus) {
      _status = null;
    } else if (status != null) {
      _status = status;
    }
    if (clearType) {
      _type = null;
    } else if (type != null) {
      _type = type;
    }
    await refresh();
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    final result = await AsyncValue.guard(() => _fetch(1));
    if (ref.mounted && generation == _generation) state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || _loadingMore) return;
    _loadingMore = true;
    final generation = ++_generation;
    try {
      final next = await _fetch(current.page + 1);
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        next.copyWith(items: <Pond>[...current.items, ...next.items]),
      );
    } on Object catch (error, stackTrace) {
      if (ref.mounted && generation == _generation) {
        state = AsyncError<PondPage>(error, stackTrace);
      }
    } finally {
      _loadingMore = false;
    }
  }

  Future<PondPage> _fetch(int page) => runAuthenticated(
    () => ref
        .read(pondRepositoryProvider)
        .getPonds(
          farmId: farmId,
          page: page,
          limit: _limit,
          search: _search,
          status: _status,
          type: _type,
        ),
  );
}

final class PondDetailController extends _OwnerPondController<Pond> {
  PondDetailController(this.ids);
  final ({String farmId, String pondId}) ids;

  @override
  Future<Pond> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async => state = await AsyncValue.guard(_load);

  Future<Pond> _load() => runAuthenticated(
    () => ref.read(pondRepositoryProvider).getPond(ids.farmId, ids.pondId),
  );
}

final class PondMutationController extends _OwnerPondController<void> {
  PondMutationController(this.farmId);
  final String farmId;

  @override
  Future<void> build() async => requireOwner();

  Future<Pond> save({
    String? pondId,
    required String name,
    required double areaM2,
    required double depthM,
    required PondType type,
    required PondStatus status,
  }) => _mutate(
    () => pondId == null
        ? ref
              .read(pondRepositoryProvider)
              .createPond(
                farmId: farmId,
                name: name,
                areaM2: areaM2,
                depthM: depthM,
                type: type,
                status: status,
              )
        : ref
              .read(pondRepositoryProvider)
              .updatePond(
                farmId: farmId,
                pondId: pondId,
                name: name,
                areaM2: areaM2,
                depthM: depthM,
                type: type,
                status: status,
              ),
    pondId: pondId,
  );

  Future<Pond> delete(String pondId) => _mutate(
    () => ref.read(pondRepositoryProvider).deletePond(farmId, pondId),
    pondId: pondId,
  );

  Future<Pond> _mutate(
    Future<Pond> Function() operation, {
    String? pondId,
  }) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading<void>();
    try {
      final pond = await runAuthenticated(operation);
      state = const AsyncData<void>(null);
      ref.invalidate(pondListControllerProvider(farmId));
      ref.invalidate(farmDetailControllerProvider(farmId));
      if (pondId != null) {
        ref.invalidate(
          pondDetailControllerProvider((farmId: farmId, pondId: pondId)),
        );
      }
      return pond;
    } on Object catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}
