import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/assigned_task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_list_view.dart';

class AssignedTaskListPage extends ConsumerStatefulWidget {
  const AssignedTaskListPage({super.key});
  @override
  ConsumerState<AssignedTaskListPage> createState() =>
      _AssignedTaskListPageState();
}

class _AssignedTaskListPageState extends ConsumerState<AssignedTaskListPage> {
  TaskGroup _group = TaskGroup.todo;
  Timer? _clock;
  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && TickerMode.getValuesNotifier(context).value.enabled) {
        ref.invalidate(assignedTaskListProvider(_group));
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
    final provider = assignedTaskListProvider(_group);
    final tasks = ref.watch(provider);
    final counts = tasks.value?.counts;
    return TaskListView(
      tasks: tasks,
      subtitle: 'Công việc Chủ trang trại giao cho bạn',
      tabs: [
        'Cần làm${counts == null ? '' : ' (${counts.pending + counts.inProgress})'}',
        'Đã kết thúc${counts == null ? '' : ' (${counts.completed + counts.cancelled})'}',
      ],
      selectedTab: _group.index,
      onSelectTab: (index) => setState(() => _group = TaskGroup.values[index]),
      onRefresh: ref.read(provider.notifier).refresh,
      onRetry: () => ref.invalidate(provider),
      onLoadMore: ref.read(provider.notifier).loadMore,
      onOpenTask: (id) => context.push('/tasks/$id'),
    );
  }
}
