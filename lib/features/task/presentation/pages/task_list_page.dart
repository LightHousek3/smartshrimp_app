import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});
  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  TaskStatus _status = TaskStatus.pending;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) ref.invalidate(taskListProvider(_status));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider(_status));
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PageHeaderBar(
              title: 'Nhiệm vụ',
              subtitle: 'Phân công nhiệm vụ cho Kỹ thuật viên',
              showBack: false,
              backgroundColor: Colors.transparent,
              titleStyle: taskHeadingStyle(
                size: 22,
                weight: FontWeight.w800,
              ).copyWith(letterSpacing: -.55),
              subtitleStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.inkSoft,
                height: 1.5,
              ),
              trailing: AppCircleButton(
                icon: Icons.add,
                tooltip: 'Tạo và giao nhiệm vụ',
                onPressed: () => context.push('/tasks/create'),
                size: 40,
                filled: true,
                borderRadius: BorderRadius.circular(12),
                iconWidget: const Center(
                  child: AppSvgIcon(
                    AppSvgIconName.plus,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _statusTabs(tasks.value?.counts),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ref.read(taskListProvider(_status).notifier).refresh,
                child: CustomScrollView(
                  key: ValueKey(_status),
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: tasks.when(
                    loading: () => const <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                    error: (error, _) => <Widget>[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: TaskLoadError(
                            error,
                            () => ref.invalidate(taskListProvider(_status)),
                          ),
                        ),
                      ),
                    ],
                    data: (page) => <Widget>[
                      if (page.items.isEmpty)
                        const SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverToBoxAdapter(child: TaskEmpty()),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList.separated(
                            itemCount: page.items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, index) => _TaskCard(
                              page.items[index],
                              now: page.serverNow,
                              onTap: () => context.push(
                                '/tasks/${page.items[index].id}',
                              ),
                            ),
                          ),
                        ),
                      if (page.hasNextPage)
                        SliverToBoxAdapter(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(taskListProvider(_status).notifier)
                                    .loadMore();
                              } catch (error) {
                                if (context.mounted) {
                                  AppNoticeService.danger(
                                    context,
                                    taskError(error),
                                  );
                                }
                              }
                            },
                            child: const Text('Tải thêm'),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTabs(TaskCounts? counts) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xB3D3E8FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: TaskStatus.values
          .where((status) => status != TaskStatus.unknown)
          .map((status) {
            final count = counts?.forStatus(status);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: status == TaskStatus.cancelled ? 0 : 4,
                ),
                child: Semantics(
                  selected: _status == status,
                  button: true,
                  child: Material(
                    color: _status == status
                        ? const Color(0xFF1D7AD6)
                        : const Color(0xA6FFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _status = status),
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            '${taskStatusLabel(status)}${count == null ? '' : ' ($count)'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _status == status
                                  ? Colors.white
                                  : AppColors.inkSoft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(),
    ),
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard(this.task, {required this.now, required this.onTap});
  final TaskItem task;
  final DateTime now;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: priorityColors(task.priority).$1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppSvgIcon(
                AppSvgIconName.tasks,
                size: 16,
                color: priorityColors(task.priority).$2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TaskBadges(task, now: now),
                  const SizedBox(height: 4),
                  Text(
                    '${task.assignee.name} · ${'Hạn ${taskDate(task.dueAt)}'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: AppSvgIcon(
                AppSvgIconName.chevron,
                size: 16,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
