import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';

final class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._remote, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final TaskRemoteDataSource _remote;
  final DateTime Function() _now;
  @override
  Future<TaskPage> list(TaskStatus status, {int page = 1}) =>
      _remote.list(status, page);
  @override
  Future<TaskItem> detail(String id) => _remote.detail(id);
  @override
  Future<TaskOptions> options(String? farmId) => _remote.options(farmId);
  @override
  Future<TaskItem> cancel(String id, String reason) {
    final trimmed = reason.trim();
    final error = TaskRules.cancellationReasonError(trimmed);
    if (error != null) throw ApiException(error);
    return _remote.cancel(id, trimmed);
  }

  @override
  Future<TaskItem> save(TaskInput input, {TaskItem? original}) {
    final error =
        TaskRules.titleError(input.title) ??
        TaskRules.descriptionError(input.description);
    if (error != null) throw ApiException(error);
    if (input.priority == TaskPriority.unknown) {
      throw const ApiException('Mức độ ưu tiên không hợp lệ.');
    }
    if (original != null && !original.canEdit) {
      throw const ApiException(
        'Nhiệm vụ đã hoàn thành hoặc đã hủy, không thể thay đổi.',
      );
    }
    if (original?.dueAt == null ||
        !input.dueAt.isAtSameMomentAs(original!.dueAt!)) {
      final deadlineError = TaskRules.deadlineError(input.dueAt, _now());
      if (deadlineError != null) throw ApiException(deadlineError);
    }
    final body = input.toJson()
      ..['title'] = input.title.trim()
      ..['description'] = input.description?.trim()
      ..['dueAt'] = input.dueAt.toUtc().toIso8601String();
    // A season assignment is resolved by BE, never trusted from the selected card.
    if (input.seasonId != null) body.remove('assignedTo');
    if (body['assignedTo'] == null) body.remove('assignedTo');
    if (original == null) return _remote.create(body);
    if (original.status == TaskStatus.inProgress) {
      body.removeWhere(
        (key, _) => !['description', 'priority', 'dueAt'].contains(key),
      );
    }
    final previous = original.toJson();
    body.removeWhere((key, value) => value == previous[key]);
    if (body.isEmpty) return Future.value(original);
    return _remote.update(original.id, body);
  }
}

final class AssignedTaskRepositoryImpl implements AssignedTaskRepository {
  AssignedTaskRepositoryImpl(this._remote);
  final AssignedTaskRemoteDataSource _remote;

  @override
  Future<TaskPage> list(TaskGroup group, {int page = 1}) =>
      _remote.listAssigned(group == TaskGroup.todo ? 'TODO' : 'ENDED', page);

  @override
  Future<TaskItem> detail(String id) => _remote.assignedDetail(id);

  @override
  Future<TaskItem> advance(TaskItem task) {
    final next = switch (task.status) {
      TaskStatus.pending => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.completed,
      _ => null,
    };
    if (next == null) {
      throw const ApiException(
        'Nhiệm vụ đã hoàn thành hoặc đã hủy, không thể thay đổi.',
      );
    }
    return _remote.updateStatus(task.id, next);
  }
}
