import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';

final assignedTaskRepositoryProvider = Provider<AssignedTaskRepository>(
  (ref) =>
      AssignedTaskRepositoryImpl(TaskApiService(ref.watch(apiClientProvider))),
);

Future<T> _authorized<T>(
  Ref ref,
  Future<T> Function(AssignedTaskRepository) operation,
) async {
  final account = ref.read(authControllerProvider).value;
  if (account == null) throw const SessionExpiredException();
  if (account.role != AccountRole.technician) {
    throw const UnsupportedRoleException();
  }
  try {
    return await operation(ref.read(assignedTaskRepositoryProvider));
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

final assignedTaskDetailProvider = FutureProvider.autoDispose
    .family<TaskItem, String>((ref, id) {
      ref.watch(authControllerProvider);
      return _authorized(ref, (repo) => repo.detail(id));
    }, retry: (_, _) => null);

final assignedTaskListProvider = AsyncNotifierProvider.autoDispose
    .family<AssignedTaskListController, TaskPage, TaskGroup>(
      AssignedTaskListController.new,
      retry: (_, _) => null,
    );

final class AssignedTaskListController extends AsyncNotifier<TaskPage> {
  AssignedTaskListController(this.group);
  final TaskGroup group;
  bool _loadingMore = false;
  int _generation = 0;

  @override
  Future<TaskPage> build() {
    ref.watch(authControllerProvider);
    _generation++;
    _loadingMore = false;
    return _authorized(ref, (repo) => repo.list(group));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (_loadingMore || current == null || !current.hasNextPage) return;
    _loadingMore = true;
    final generation = _generation;
    try {
      final next = await _authorized(
        ref,
        (repo) => repo.list(group, page: current.page + 1),
      );
      if (ref.mounted && generation == _generation) {
        final items = {
          for (final task in [...current.items, ...next.items]) task.id: task,
        };
        state = AsyncData(next.copyWith(items: items.values.toList()));
      }
    } finally {
      if (generation == _generation) _loadingMore = false;
    }
  }
}

final assignedTaskMutationProvider =
    AsyncNotifierProvider.autoDispose<AssignedTaskMutationController, void>(
      AssignedTaskMutationController.new,
    );

final class AssignedTaskMutationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<TaskItem> advance(TaskItem task) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading();
    try {
      final updated = await _authorized(ref, (repo) => repo.advance(task));
      if (ref.mounted) {
        state = const AsyncData(null);
        ref.invalidate(assignedTaskListProvider);
        ref.invalidate(assignedTaskDetailProvider(task.id));
      }
      return updated;
    } catch (error, stack) {
      if (ref.mounted) {
        state = AsyncError(error, stack);
        if (error is AppException &&
            [403, 404, 409].contains(error.statusCode)) {
          ref.invalidate(assignedTaskDetailProvider(task.id));
          ref.invalidate(assignedTaskListProvider);
        }
      }
      rethrow;
    }
  }
}
