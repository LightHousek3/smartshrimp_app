import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

import '../../data/disease_case_api_service.dart';
import '../../domain/entities/owner_disease_case.dart';
import '../../domain/repositories/owner_disease_case_repository.dart';

final diseaseCaseRepositoryProvider = Provider<DiseaseCaseRepository>(
  (ref) => DiseaseCaseApiService(ref.watch(apiClientProvider)),
);

final diseaseCaseDetailProvider = FutureProvider.autoDispose
    .family<DiseaseCaseDetail, String>((ref, caseId) {
      _watchOwner(ref);
      final repository = ref.watch(diseaseCaseRepositoryProvider);
      return _withSession(ref, () => repository.detail(caseId));
    }, retry: (_, _) => null);

final diseaseCaseListProvider = AsyncNotifierProvider.autoDispose
    .family<DiseaseCaseListController, DiseaseCasePage, String>(
      DiseaseCaseListController.new,
      retry: (_, _) => null,
    );

class DiseaseCaseListController extends AsyncNotifier<DiseaseCasePage> {
  DiseaseCaseListController(this.seasonId);

  final String seasonId;
  bool _resolved = false;
  bool _loadingMore = false;
  int _revision = 0;

  @override
  Future<DiseaseCasePage> build() {
    _revision++;
    _loadingMore = false;
    _watchOwner(ref);
    final repository = ref.watch(diseaseCaseRepositoryProvider);
    return _fetch(repository, page: 1);
  }

  void selectTab({required bool resolved}) {
    if (_resolved == resolved) return;
    _resolved = resolved;
    _revision++;
    ref.invalidateSelf();
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (state.isLoading ||
        _loadingMore ||
        current == null ||
        !current.hasNextPage) {
      return;
    }
    final revision = _revision;
    _loadingMore = true;
    try {
      final next = await _fetch(
        ref.read(diseaseCaseRepositoryProvider),
        page: current.page + 1,
      );
      if (!ref.mounted || revision != _revision) return;
      final ids = current.items.map((item) => item.id).toSet();
      state = AsyncData(
        next.copyWith(
          items: [
            ...current.items,
            ...next.items.where((item) => ids.add(item.id)),
          ],
        ),
      );
    } on AppException {
      if (ref.mounted && revision == _revision) rethrow;
    } finally {
      if (revision == _revision) _loadingMore = false;
    }
  }

  Future<DiseaseCasePage> _fetch(
    DiseaseCaseRepository repository, {
    required int page,
  }) => _withSession(
    ref,
    () => repository.list(seasonId: seasonId, resolved: _resolved, page: page),
  );
}

void _watchOwner(Ref ref) {
  final (id, role, status) = ref.watch(
    authControllerProvider.select(
      (state) => (state.value?.id, state.value?.role, state.value?.status),
    ),
  );
  if (id == null) throw const SessionExpiredException();
  if (role != AccountRole.farmOwner || status != AccountStatus.active) {
    throw const UnsupportedRoleException();
  }
}

Future<T> _withSession<T>(Ref ref, Future<T> Function() request) async {
  final account = ref.read(authControllerProvider).value;
  try {
    return await request();
  } on SessionExpiredException {
    if (ref.mounted && ref.read(authControllerProvider).value == account) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}
