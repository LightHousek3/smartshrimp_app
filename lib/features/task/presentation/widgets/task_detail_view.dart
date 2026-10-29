import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'task_ui.dart';

/// Roles supply permitted actions; every task fact has one shared rendering.
class TaskDetailView extends StatefulWidget {
  const TaskDetailView({
    required this.detail,
    required this.onBack,
    required this.onRetry,
    required this.onRefresh,
    required this.actions,
    this.trailing,
    super.key,
  });
  final AsyncValue<TaskItem> detail;
  final VoidCallback onBack, onRetry;
  final Future<void> Function() onRefresh;
  final List<Widget> Function(TaskItem task) actions;
  final Widget? trailing;
  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  Timer? _clock;
  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppGradientBackground(
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          TaskHeader(
            title: 'Chi tiết nhiệm vụ',
            insetTop: true,
            trailing: widget.trailing,
            onBack: widget.onBack,
          ),
          Expanded(
            child: widget.detail.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: TaskLoadError(error, widget.onRetry)),
              data: (task) => RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _TaskHeading(task, now: DateTime.now()),
                    const SizedBox(height: 16),
                    _TaskAssignment(task, now: DateTime.now()),
                    const SizedBox(height: 16),
                    TaskTimeline(task),
                    if (task.status == TaskStatus.cancelled) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: taskRed,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFB9C7),
                            width: .8,
                          ),
                        ),
                        child: Text(
                          'Lý do hủy: ${task.cancellationReason ?? 'Không có thông tin'}',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                    ...widget.actions(task),
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

class _TaskHeading extends StatelessWidget {
  const _TaskHeading(this.task, {required this.now});
  final TaskItem task;
  final DateTime now;
  @override
  Widget build(BuildContext context) => TaskPanel(
    elevated: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        TaskBadges(task, detail: true, now: now),
        if (task.description?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          Text(
            task.description!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.625,
              color: AppColors.inkSoft,
            ),
          ),
        ],
      ],
    ),
  );
}

class _TaskAssignment extends StatelessWidget {
  const _TaskAssignment(this.task, {required this.now});
  final TaskItem task;
  final DateTime now;
  @override
  Widget build(BuildContext context) {
    final overdue = task.canEdit && task.overdueAt(now);
    return TaskPanel(
      elevated: true,
      child: Column(
        children: [
          _TaskInfoRow(
            'Người giao',
            task.assigner?.name ?? '—',
            AppSvgIconName.person,
          ),
          const SizedBox(height: 16),
          _TaskInfoRow(
            'Giao cho',
            task.assignee?.name ?? '—',
            AppSvgIconName.badge,
          ),
          const SizedBox(height: 16),
          _TaskInfoRow(
            'Hạn hoàn thành',
            taskTimestamp(task.dueAt),
            AppSvgIconName.clock,
            colors: overdue
                ? (taskRed, AppColors.error)
                : (taskAmber, const Color(0xFFD98314)),
            valueColor: overdue ? AppColors.error : AppColors.ink,
          ),
          const SizedBox(height: 16),
          _TaskInfoRow(
            'Trang trại',
            task.farm?.name ?? '—',
            AppSvgIconName.farmCompact,
          ),
          if (task.season != null) ...[
            const SizedBox(height: 16),
            _TaskInfoRow(
              'Ao · Vụ nuôi liên quan',
              [
                if (task.pond != null) task.pond!.name,
                task.season!.name,
              ].join(' · '),
              AppSvgIconName.shrimp,
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskInfoRow extends StatelessWidget {
  const _TaskInfoRow(
    this.label,
    this.value,
    this.icon, {
    this.colors = (taskBlue, AppColors.ocean),
    this.valueColor = AppColors.ink,
  });
  final String label, value;
  final AppSvgIconName icon;
  final (Color, Color) colors;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colors.$1, shape: BoxShape.circle),
        child: AppSvgIcon(icon, size: 15, color: colors.$2),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                height: 1.3333,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                height: 1.4286,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class TaskTimeline extends StatelessWidget {
  const TaskTimeline(this.task, {super.key});
  final TaskItem task;
  @override
  Widget build(BuildContext context) => TaskPanel(
    elevated: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
          child: Text(
            'Tiến trình thực hiện',
            style: taskHeadingStyle(
              size: 15,
            ).copyWith(letterSpacing: -.375, height: 1.5),
          ),
        ),
        _TaskInfoRow(
          'Được giao',
          taskTimestamp(task.createdAt, empty: 'Không có thông tin'),
          AppSvgIconName.calendarDays,
        ),
        const SizedBox(height: 16),
        _TaskInfoRow(
          'Bắt đầu làm',
          taskTimestamp(
            task.startedAt,
            empty: task.status == TaskStatus.cancelled
                ? 'Đã hủy trước khi bắt đầu'
                : 'Chưa bắt đầu',
          ),
          AppSvgIconName.sparkles,
          colors: task.startedAt == null
              ? (taskGray, const Color(0xFF64748B))
              : (taskBlue, AppColors.ocean),
        ),
        const SizedBox(height: 16),
        if (task.status == TaskStatus.cancelled)
          _TaskInfoRow(
            'Đã hủy',
            taskTimestamp(task.cancelledAt, empty: 'Không có thông tin'),
            AppSvgIconName.close,
            colors: (taskRed, AppColors.error),
            valueColor: AppColors.error,
          )
        else
          _TaskInfoRow(
            'Hoàn thành',
            taskTimestamp(task.completedAt, empty: 'Chưa hoàn thành'),
            AppSvgIconName.check,
            colors: task.completedAt == null
                ? (taskGray, const Color(0xFF64748B))
                : (taskGreen, const Color(0xFF0F9B8E)),
          ),
      ],
    ),
  );
}
