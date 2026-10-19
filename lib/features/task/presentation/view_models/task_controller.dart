import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';

final taskRemoteProvider = Provider<TaskRemoteDataSource>(
  (ref) => TaskApiService(ref.watch(apiClientProvider)),
);
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(ref.watch(taskRemoteProvider)),
);

Future<T> _authorized<T>(
  Ref ref,
  Future<T> Function(TaskRepository) operation,
) async {
  final account = ref.read(authControllerProvider).value;
  if (account?.role != AccountRole.farmOwner) {
    throw const UnsupportedRoleException();
  }
  try {
    return await operation(ref.read(taskRepositoryProvider));
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

final taskOptionsProvider = FutureProvider.autoDispose
    .family<TaskOptions, String?>((ref, farmId) {
      ref.watch(authControllerProvider);
      return _authorized(ref, (repo) => repo.options(farmId));
    }, retry: (_, _) => null);
final taskDetailProvider = FutureProvider.autoDispose.family<TaskItem, String>((
  ref,
  id,
) {
  ref.watch(authControllerProvider);
  return _authorized(ref, (repo) => repo.detail(id));
}, retry: (_, _) => null);
final taskListProvider = AsyncNotifierProvider.autoDispose
    .family<TaskListController, TaskPage, TaskStatus>(
      TaskListController.new,
      retry: (_, _) => null,
    );

final class TaskListController extends AsyncNotifier<TaskPage> {
  TaskListController(this.status);
  final TaskStatus status;
  bool _loadingMore = false;
  int _generation = 0;
  @override
  Future<TaskPage> build() {
    ref.watch(authControllerProvider);
    _generation++;
    _loadingMore = false;
    return _authorized(ref, (repo) => repo.list(status));
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
        (repo) => repo.list(status, page: current.page + 1),
      );
      if (ref.mounted && generation == _generation) {
        state = AsyncData(
          next.copyWith(items: [...current.items, ...next.items]),
        );
      }
    } finally {
      if (generation == _generation) _loadingMore = false;
    }
  }
}

final taskMutationProvider =
    AsyncNotifierProvider.autoDispose<TaskMutationController, void>(
      TaskMutationController.new,
    );

final class TaskMutationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}
  Future<TaskItem> save(TaskInput input, {TaskItem? original}) =>
      _mutate((repo) => repo.save(input, original: original));
  Future<TaskItem> cancel(String id, String reason) =>
      _mutate((repo) => repo.cancel(id, reason));
  Future<TaskItem> _mutate(
    Future<TaskItem> Function(TaskRepository) operation,
  ) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading();
    try {
      final task = await _authorized(ref, operation);
      if (ref.mounted) {
        state = const AsyncData(null);
        ref.invalidate(taskListProvider);
        ref.invalidate(taskDetailProvider(task.id));
        ref.invalidate(taskOptionsProvider);
      }
      return task;
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      rethrow;
    }
  }
}
