import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';

abstract interface class TaskRepository {
  Future<TaskPage> list(TaskStatus status, {int page = 1});
  Future<TaskItem> detail(String id);
  Future<TaskOptions> options(String? farmId);
  Future<TaskItem> save(TaskInput input, {TaskItem? original});
  Future<TaskItem> cancel(String id, String reason);
}
