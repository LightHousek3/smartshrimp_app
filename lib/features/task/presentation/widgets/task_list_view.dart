import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'task_ui.dart';

/// The same list layout renders owner status tabs and technician grouped tabs.
class TaskListView extends StatelessWidget {
  const TaskListView({
    required this.tasks,
    required this.subtitle,
    required this.tabs,
    required this.selectedTab,
    required this.onSelectTab,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onOpenTask,
    this.onCreate,
    this.showAssignee = false,
    super.key,
  });
  final AsyncValue<TaskPage> tasks;
  final String subtitle;
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onSelectTab;
  final Future<void> Function() onRefresh, onLoadMore;
  final VoidCallback onRetry;
  final ValueChanged<String> onOpenTask;
  final VoidCallback? onCreate;
  final bool showAssignee;

  @override
  Widget build(BuildContext context) => AppGradientBackground(
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nhiệm vụ',
                        style: taskHeadingStyle(
                          size: 22,
                          weight: FontWeight.w800,
                        ).copyWith(letterSpacing: -.55),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onCreate != null)
                  IconButton(
                    tooltip: 'Tạo và giao nhiệm vụ',
                    onPressed: onCreate,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.ocean,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const AppSvgIcon(
                      AppSvgIconName.plus,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _TaskTabs(
              labels: tabs,
              selected: selectedTab,
              onSelected: onSelectTab,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: CustomScrollView(
                key: ValueKey(selectedTab),
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: tasks.when(
                  loading: () => const [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                  error: (error, _) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: TaskLoadError(error, onRetry)),
                    ),
                  ],
                  data: (page) => [
                    if (page.items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: TaskEmpty(canCreate: onCreate != null),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.separated(
                          itemCount: page.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) => TaskCard(
                            page.items[index],
                            now: page.serverNow,
                            showAssignee: showAssignee,
                            onTap: () => onOpenTask(page.items[index].id),
                          ),
                        ),
                      ),
                    if (page.hasNextPage)
                      SliverToBoxAdapter(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              await onLoadMore();
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

class _TaskTabs extends StatelessWidget {
  const _TaskTabs({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xB3D3E8FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(
            child: Semantics(
              selected: i == selected,
              button: true,
              child: Material(
                color: i == selected
                    ? const Color(0xFF1D7AD6)
                    : const Color(0xA6FFFFFF),
                elevation: i == selected ? 2 : 0,
                shadowColor: const Color(0x1A000000),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelected(i),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: i == selected
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
        ],
      ],
    ),
  );
}

class TaskCard extends StatelessWidget {
  const TaskCard(
    this.task, {
    required this.now,
    required this.onTap,
    this.showAssignee = false,
    super.key,
  });
  final TaskItem task;
  final DateTime now;
  final VoidCallback onTap;
  final bool showAssignee;
  @override
  Widget build(BuildContext context) {
    final overdue = task.canEdit && task.overdueAt(now);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          height: 1.375,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TaskBadges(task, now: now, detail: true),
                      if (showAssignee || task.dueAt != null) ...[
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              if (showAssignee)
                                TextSpan(
                                  text: '${task.assignee?.name ?? '—'} · ',
                                ),
                              TextSpan(
                                text: 'Hạn: ${taskTimestamp(task.dueAt)}',
                                style: TextStyle(
                                  fontWeight: overdue
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: overdue
                                      ? AppColors.error
                                      : AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.625,
                            fontWeight: FontWeight.w400,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: AppSvgIcon(
                    AppSvgIconName.chevronCompact,
                    size: 16,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
