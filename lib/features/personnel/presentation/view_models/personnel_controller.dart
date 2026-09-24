import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/personnel/data/repositories/personnel_repository_impl.dart';
import 'package:smartshrimp_app/features/personnel/data/services/personnel_api_service.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';

enum PersonnelRoleFilter { all, technician, expert }

enum PersonnelStatusFilter { all, active, pendingActivation, inactive, blocked }

final personnelRemoteDataSourceProvider = Provider<PersonnelRemoteDataSource>((
  ref,
) {
  return PersonnelApiService(ref.watch(apiClientProvider));
});

final personnelRepositoryProvider = Provider<PersonnelRepository>((ref) {
  return PersonnelRepositoryImpl(ref.watch(personnelRemoteDataSourceProvider));
});

final activePersonnelCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  if (ref.watch(authControllerProvider).value?.role != AccountRole.farmOwner) {
    throw const UnsupportedRoleException();
  }
  try {
    final page = await ref
        .read(personnelRepositoryProvider)
        .getPersonnel(limit: 1, status: AccountStatus.active);
    return page.totalResults;
  } on SessionExpiredException {
    await ref.read(authControllerProvider.notifier).expireSession();
    rethrow;
  }
});

final personnelListControllerProvider =
    AsyncNotifierProvider.autoDispose<
      PersonnelListController,
      ManagedPersonnelPage
    >(PersonnelListController.new);

final personnelDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PersonnelDetailController, ManagedPersonnel, String>(
      PersonnelDetailController.new,
    );

abstract base class _OwnerPersonnelController<T> extends AsyncNotifier<T> {
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

final class PersonnelListController
    extends _OwnerPersonnelController<ManagedPersonnelPage> {
  static const _pageSize = 20;

  PersonnelRoleFilter _roleFilter = PersonnelRoleFilter.all;
  PersonnelStatusFilter _statusFilter = PersonnelStatusFilter.all;
  String _search = '';
  int _generation = 0;
  bool _loadingMore = false;

  @override
  Future<ManagedPersonnelPage> build() {
    requireOwner();
    return _loadPage();
  }

  Future<void> applyFilters({
    required PersonnelRoleFilter roleFilter,
    required PersonnelStatusFilter statusFilter,
    String search = '',
  }) async {
    _roleFilter = roleFilter;
    _statusFilter = statusFilter;
    _search = search;
    final generation = ++_generation;
    state = const AsyncLoading<ManagedPersonnelPage>();
    final result = await AsyncValue.guard(_loadPage);
    if (ref.mounted && generation == _generation) state = result;
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    final result = await AsyncValue.guard(_loadPage);
    if (ref.mounted && generation == _generation) state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (_loadingMore ||
        current == null ||
        !current.hasNextPage ||
        cursor == null) {
      return;
    }

    _loadingMore = true;
    final generation = _generation;
    try {
      final next = await _loadPage(cursor: cursor);
      if (!ref.mounted || generation != _generation) return;
      final latest = state.value;
      if (latest == null || latest.nextCursor != cursor) return;
      final knownIds = latest.items.map((item) => item.id).toSet();
      state = AsyncData(
        next.copyWith(
          items: <ManagedPersonnel>[
            ...latest.items,
            ...next.items.where((item) => knownIds.add(item.id)),
          ],
        ),
      );
    } finally {
      _loadingMore = false;
    }
  }

  Future<ManagedPersonnelPage> _loadPage({String? cursor}) => runAuthenticated(
    () => ref
        .read(personnelRepositoryProvider)
        .getPersonnel(
          cursor: cursor,
          limit: _pageSize,
          role: switch (_roleFilter) {
            PersonnelRoleFilter.all => null,
            PersonnelRoleFilter.technician => AccountRole.technician,
            PersonnelRoleFilter.expert => AccountRole.expert,
          },
          status: switch (_statusFilter) {
            PersonnelStatusFilter.all => null,
            PersonnelStatusFilter.active => AccountStatus.active,
            PersonnelStatusFilter.pendingActivation =>
              AccountStatus.pendingActivation,
            PersonnelStatusFilter.inactive => AccountStatus.inactive,
            PersonnelStatusFilter.blocked => AccountStatus.blocked,
          },
          search: _search,
        ),
  );
}

final class PersonnelDetailController
    extends _OwnerPersonnelController<ManagedPersonnel> {
  PersonnelDetailController(this.personnelId);

  final String personnelId;

  @override
  Future<ManagedPersonnel> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<ManagedPersonnel> _load() => runAuthenticated(
    () => ref.read(personnelRepositoryProvider).getPersonnelById(personnelId),
  );
}
