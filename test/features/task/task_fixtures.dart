import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';

const taskTechnician = TaskChoice(id: 'tech1', name: 'Cô Thái Bảo');
const taskSecondTechnician = TaskChoice(id: 'tech2', name: 'Trần Minh Khoa');
const taskFarm = TaskChoice(id: 'farm1', name: 'Trang trại Cửa Lấp');
const taskSeason = TaskChoice(id: 'season1', name: 'Vụ Đông Xuân 2025');
final taskNow = DateTime.parse('2026-10-19T08:00:00+07:00');
final progressTask = TaskItem(
  id: 'progress',
  title: 'Kiểm tra & xử lý NO2 cao tại Ao A3',
  description:
      'NO2 sáng nay đạt 1.9 mg/L vượt ngưỡng. Tạt Yucca theo lịch, tăng cường quạt nước và theo dõi lại sau 6 giờ.',
  priority: TaskPriority.urgent,
  status: TaskStatus.inProgress,
  dueAt: DateTime.parse('2026-09-08T12:00:00+07:00'),
  farmId: taskFarm.id,
  farm: taskFarm,
  seasonId: taskSeason.id,
  season: taskSeason,
  assignedTo: taskTechnician.id,
  assignee: taskTechnician,
  assigner: const TaskChoice(id: 'owner1', name: 'Nguyễn Văn Đạt'),
  pond: const TaskChoice(id: 'pond1', name: 'Ao A3'),
  createdAt: DateTime.parse('2026-09-08T06:25:00+07:00'),
  startedAt: DateTime.parse('2026-09-08T06:40:00+07:00'),
);
final pendingTask = progressTask.copyWith(
  id: 'pending',
  title: 'Chài kiểm tra sinh khối Ao A5',
  description:
      'Đã đến kỳ lấy mẫu tính sinh khối để cập nhật liều cho ăn tuần tới.',
  status: TaskStatus.pending,
  priority: TaskPriority.high,
  startedAt: null,
  dueAt: DateTime.parse('2026-09-08T17:00:00+07:00'),
);
final completedTask = progressTask.copyWith(
  id: 'completed',
  title: 'Ghi nhận cho ăn cữ chiều Ao A3',
  description: 'Hoàn tất và ghi nhận cữ ăn số 3 trong ngày.',
  status: TaskStatus.completed,
  priority: TaskPriority.normal,
  dueAt: DateTime.parse('2026-09-08T15:30:00+07:00'),
  completedAt: DateTime.parse('2026-09-08T15:00:00+07:00'),
);
final cancelledTask = progressTask.copyWith(
  id: 'cancelled',
  title: 'Kiểm tra hệ thống quạt nước ao D2',
  description: 'Kiểm tra và vệ sinh toàn bộ hệ thống quạt trước khi thả giống.',
  status: TaskStatus.cancelled,
  priority: TaskPriority.high,
  seasonId: null,
  season: null,
  assignee: taskSecondTechnician,
  assignedTo: taskSecondTechnician.id,
  cancellationReason: 'Không cần thực hiện',
  cancelledAt: DateTime.parse('2026-10-18T23:46:00+07:00'),
  dueAt: DateTime.parse('2026-09-15T08:00:00+07:00'),
);

class TaskFixtureRepository implements TaskRepository {
  bool emptyCancelled = false;
  Object? failure;
  TaskInput? saved;
  String? cancelledReason;
  final List<String> optionFarms = [];
  final tasks = <String, TaskItem>{
    for (final t in [progressTask, pendingTask, completedTask, cancelledTask])
      t.id: t,
  };
  @override
  Future<TaskPage> list(TaskStatus tab, {int page = 1}) async {
    if (failure != null) throw failure!;
    final visible = tasks.values.where((task) => task.status == tab).toList();
    return TaskPage(
      items: tab == TaskStatus.cancelled && emptyCancelled ? [] : visible,
      page: page,
      hasNextPage: false,
      totalResults: tab == TaskStatus.cancelled && emptyCancelled
          ? 0
          : visible.length,
      counts: TaskCounts(
        pending: tasks.values
            .where((t) => t.status == TaskStatus.pending)
            .length,
        inProgress: tasks.values
            .where((t) => t.status == TaskStatus.inProgress)
            .length,
        completed: tasks.values
            .where((t) => t.status == TaskStatus.completed)
            .length,
        cancelled: emptyCancelled
            ? 0
            : tasks.values
                  .where((t) => t.status == TaskStatus.cancelled)
                  .length,
      ),
      serverNow: taskNow,
    );
  }

  @override
  Future<TaskItem> detail(String id) async {
    if (failure != null) throw failure!;
    return tasks[id]!;
  }

  @override
  Future<TaskOptions> options(String? farmId) async {
    optionFarms.add(farmId ?? '');
    return TaskOptions(
      farms: const [
        taskFarm,
        TaskChoice(id: 'farm2', name: 'Trang trại Đông Hải'),
      ],
      technicians: const [taskTechnician, taskSecondTechnician],
      seasons: farmId == taskFarm.id
          ? [
              TaskSeasonChoice(
                id: taskSeason.id,
                name: taskSeason.name,
                pondName: 'Ao A3',
                technician: taskTechnician,
              ),
            ]
          : [],
    );
  }

  @override
  Future<TaskItem> save(TaskInput input, {TaskItem? original}) async {
    if (failure != null) throw failure!;
    saved = input;
    return pendingTask;
  }

  @override
  Future<TaskItem> cancel(String id, String reason) async {
    if (failure != null) throw failure!;
    cancelledReason = reason;
    return tasks[id] = tasks[id]!.copyWith(
      status: TaskStatus.cancelled,
      cancellationReason: reason,
      cancelledAt: cancelledTask.cancelledAt,
    );
  }
}
