import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/data/repositories/farm_repository_impl.dart';
import 'package:smartshrimp_app/features/farm/data/services/farm_api_service.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';

final farmRemoteDataSourceProvider = Provider<FarmRemoteDataSource>((ref) {
  return FarmApiService(ref.watch(apiClientProvider));
});

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return FarmRepositoryImpl(ref.watch(farmRemoteDataSourceProvider));
});

final farmListControllerProvider =
    AsyncNotifierProvider.autoDispose<FarmListController, FarmPage>(
      FarmListController.new,
    );

final farmDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<FarmDetailController, Farm, String>(FarmDetailController.new);

final farmMutationControllerProvider =
    AsyncNotifierProvider.autoDispose<FarmMutationController, void>(
      FarmMutationController.new,
    );

abstract base class _OwnerFarmController<T> extends AsyncNotifier<T> {
  void requireOwner() {
    final account = ref.watch(authControllerProvider).value;
    if (account?.role != AccountRole.farmOwner) {
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

final class FarmListController extends _OwnerFarmController<FarmPage> {
  static const _pageSize = 20;

  List<Farm> _allFarms = const <Farm>[];
  String _search = '';
  int _currentPage = 1;
  int _generation = 0;

  @override
  Future<FarmPage> build() async {
    requireOwner();
    _allFarms = await _fetchAll();
    return _buildPage();
  }

  Future<void> load({String search = ''}) async {
    _search = search;
    _currentPage = 1;
    state = AsyncData(_buildPage());
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    final result = await AsyncValue.guard(() async {
      _allFarms = await _fetchAll();
      _currentPage = 1;
      return _buildPage();
    });
    if (ref.mounted && generation == _generation) state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage) return;
    _currentPage++;
    state = AsyncData(_buildPage());
  }

  FarmPage _buildPage() {
    final normalizedSearch = _search.trim().toLowerCase();
    final filtered = _allFarms
        .where((farm) {
          final matchesName =
              normalizedSearch.isEmpty ||
              farm.name.toLowerCase().contains(normalizedSearch);
          return matchesName;
        })
        .toList(growable: false);
    final totalPages = (filtered.length + _pageSize - 1) ~/ _pageSize;
    final requestedCount = _currentPage * _pageSize;
    final visibleCount = requestedCount < filtered.length
        ? requestedCount
        : filtered.length;
    return FarmPage(
      items: filtered.take(visibleCount).toList(growable: false),
      page: _currentPage,
      limit: _pageSize,
      totalResults: filtered.length,
      totalPages: totalPages,
    );
  }

  Future<List<Farm>> _fetchAll() =>
      runAuthenticated(() => ref.read(farmRepositoryProvider).getFarms());
}

final class FarmDetailController extends _OwnerFarmController<Farm> {
  FarmDetailController(this.farmId);

  final String farmId;

  @override
  Future<Farm> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<Farm> _load() =>
      runAuthenticated(() => ref.read(farmRepositoryProvider).getFarm(farmId));
}

final class FarmMutationController extends _OwnerFarmController<void> {
  @override
  Future<void> build() async {
    requireOwner();
  }

  Future<Farm> create({
    required String name,
    String? address,
    double? totalAreaHectares,
  }) => _mutate(
    () => ref
        .read(farmRepositoryProvider)
        .createFarm(
          name: name,
          address: address,
          totalAreaHectares: totalAreaHectares,
        ),
  );

  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? totalAreaHectares,
  }) => _mutate(
    () => ref
        .read(farmRepositoryProvider)
        .updateFarm(
          farmId: farmId,
          name: name,
          address: address,
          totalAreaHectares: totalAreaHectares,
        ),
    farmId: farmId,
  );

  Future<Farm> deleteFarm(String farmId) => _mutate(
    () => ref.read(farmRepositoryProvider).deleteFarm(farmId),
    farmId: farmId,
  );

  Future<Farm> _mutate(
    Future<Farm> Function() operation, {
    String? farmId,
  }) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading<void>();
    try {
      final farm = await runAuthenticated(operation);
      state = const AsyncData<void>(null);
      ref.invalidate(farmListControllerProvider);
      if (farmId != null) ref.invalidate(farmDetailControllerProvider(farmId));
      return farm;
    } on Object catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}
