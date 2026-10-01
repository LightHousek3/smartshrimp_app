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

final class ActivePersonnelSummary {
  const ActivePersonnelSummary({
    required this.technicians,
    required this.experts,
  });

  final int technicians;
  final int experts;

  int get total => technicians + experts;
}

final activePersonnelSummaryProvider =
    FutureProvider.autoDispose<ActivePersonnelSummary>((ref) async {
      if (ref.watch(authControllerProvider).value?.role !=
          AccountRole.farmOwner) {
        throw const UnsupportedRoleException();
      }
      try {
        final repository = ref.read(personnelRepositoryProvider);
        final pages = await Future.wait(<Future<ManagedPersonnelPage>>[
          repository.getPersonnel(
            limit: 1,
            role: AccountRole.technician,
            status: AccountStatus.active,
          ),
          repository.getPersonnel(
            limit: 1,
            role: AccountRole.expert,
            status: AccountStatus.active,
          ),
        ]);
        return ActivePersonnelSummary(
          technicians: pages[0].totalResults,
          experts: pages[1].totalResults,
        );
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
    .family<PersonnelDetailController, ManagedPersonnelDetail, String>(
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
  static const _pageSize = 100;

  PersonnelRoleFilter _roleFilter = PersonnelRoleFilter.all;
  PersonnelStatusFilter _statusFilter = PersonnelStatusFilter.all;
  String _search = '';
  List<ManagedPersonnel> _allPersonnel = const <ManagedPersonnel>[];
  int _generation = 0;

  @override
  Future<ManagedPersonnelPage> build() async {
    requireOwner();
    final page = await _loadAllPersonnel();
    _allPersonnel = page.items;
    return _applyLocalFilters(page);
  }

  void applyFilters({
    required PersonnelRoleFilter roleFilter,
    required PersonnelStatusFilter statusFilter,
    String search = '',
  }) {
    _roleFilter = roleFilter;
    _statusFilter = statusFilter;
    _search = search;
    final current = state.value;
    if (current != null) state = AsyncData(_applyLocalFilters(current));
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    final result = await AsyncValue.guard(_loadAllPersonnel);
    if (!ref.mounted || generation != _generation) return;
    if (result case AsyncData(:final value)) {
      _allPersonnel = value.items;
      state = AsyncData(_applyLocalFilters(value));
    } else {
      state = result;
    }
  }

  ManagedPersonnelPage _applyLocalFilters(ManagedPersonnelPage source) {
    final role = switch (_roleFilter) {
      PersonnelRoleFilter.all => null,
      PersonnelRoleFilter.technician => AccountRole.technician,
      PersonnelRoleFilter.expert => AccountRole.expert,
    };
    final status = switch (_statusFilter) {
      PersonnelStatusFilter.all => null,
      PersonnelStatusFilter.active => AccountStatus.active,
      PersonnelStatusFilter.pendingActivation =>
        AccountStatus.pendingActivation,
      PersonnelStatusFilter.inactive => AccountStatus.inactive,
      PersonnelStatusFilter.blocked => AccountStatus.blocked,
    };
    final search = _search.trim().toLowerCase();
    final filtered = _allPersonnel
        .where((person) {
          if (role != null && person.role != role) return false;
          if (status != null && person.status != status) return false;
          return search.isEmpty ||
              person.displayName.toLowerCase().contains(search);
        })
        .toList(growable: false);
    return source.copyWith(
      items: filtered,
      totalResults: filtered.length,
      hasNextPage: false,
      nextCursor: null,
    );
  }

  Future<ManagedPersonnelPage> _loadAllPersonnel() =>
      runAuthenticated(() async {
        final repository = ref.read(personnelRepositoryProvider);
        final items = <ManagedPersonnel>[];
        final knownIds = <String>{};
        final seenCursors = <String>{};
        String? cursor;

        do {
          final page = await repository.getPersonnel(
            cursor: cursor,
            limit: _pageSize,
          );
          items.addAll(page.items.where((person) => knownIds.add(person.id)));
          if (!page.hasNextPage) break;
          final nextCursor = page.nextCursor;
          if (nextCursor == null || !seenCursors.add(nextCursor)) {
            throw const InvalidResponseException();
          }
          cursor = nextCursor;
        } while (true);

        return ManagedPersonnelPage(
          items: items,
          limit: _pageSize,
          totalResults: items.length,
          hasNextPage: false,
        );
      });
}

final class PersonnelDetailController
    extends _OwnerPersonnelController<ManagedPersonnelDetail> {
  PersonnelDetailController(this.personnelId);

  final String personnelId;

  @override
  Future<ManagedPersonnelDetail> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<ManagedPersonnelDetail> _load() => runAuthenticated(
    () => ref.read(personnelRepositoryProvider).getPersonnelById(personnelId),
  );
}
