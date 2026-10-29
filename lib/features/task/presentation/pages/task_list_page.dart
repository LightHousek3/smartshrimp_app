import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_list_view.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});
  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  TaskStatus _status = TaskStatus.pending;
  Timer? _clock;
  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && TickerMode.getValuesNotifier(context).value.enabled) {
        ref.invalidate(taskListProvider(_status));
      }
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = taskListProvider(_status);
    final tasks = ref.watch(provider);
    final statuses = TaskStatus.values
        .where((s) => s != TaskStatus.unknown)
        .toList();
    return TaskListView(
      tasks: tasks,
      subtitle: 'Phân công nhiệm vụ cho Kỹ thuật viên',
      tabs: [
        for (final status in statuses)
          '${taskStatusLabel(status)}${tasks.value == null ? '' : ' (${tasks.value!.counts.forStatus(status)})'}',
      ],
      selectedTab: statuses.indexOf(_status),
      onSelectTab: (index) => setState(() => _status = statuses[index]),
      onRefresh: ref.read(provider.notifier).refresh,
      onRetry: () => ref.invalidate(provider),
      onLoadMore: ref.read(provider.notifier).loadMore,
      onOpenTask: (id) => context.push('/tasks/$id'),
      onCreate: () => context.push('/tasks/create'),
      showAssignee: true,
    );
  }
}
