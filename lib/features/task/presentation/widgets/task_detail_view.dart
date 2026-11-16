import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'task_ui.dart';

/// Roles supply permitted actions; assignment facts and milestones share one view.
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // The design's gradient spans the viewport, including the shell navigation.
      final gradientEnd = Color.lerp(
        AppColors.backgroundTop,
        AppColors.backgroundBottom,
        (constraints.maxHeight / MediaQuery.sizeOf(context).height).clamp(0, 1),
      )!;
      return DefaultTextStyle.merge(
        style: const TextStyle(fontFamily: 'PlusJakartaSans', letterSpacing: 0),
        child: AppGradientBackground(
          colors: [AppColors.backgroundTop, gradientEnd],
          stops: const [0, 1],
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                TaskHeader(
                  title: 'Chi tiết nhiệm vụ',
                  trailing: widget.trailing,
                  onBack: widget.onBack,
                ),
                Expanded(
                  child: widget.detail.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Center(child: TaskLoadError(error, widget.onRetry)),
                    data: (task) => RefreshIndicator(
                      onRefresh: widget.onRefresh,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _TaskHeading(task, now: DateTime.now()),
                          const SizedBox(height: 10),
                          _TaskAssignment(task, now: DateTime.now()),
                          const SizedBox(height: 10),
                          TaskTimeline(task),
                          if (task.status == TaskStatus.cancelled) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: taskRed,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0x26D43B57),
                                  width: 8 / 9,
                                ),
                              ),
                              child: Text(
                                'Lý do hủy: ${task.cancellationReason ?? 'Không có thông tin'}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
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
        ),
      );
    },
  );
}

class _TaskHeading extends StatelessWidget {
  const _TaskHeading(this.task, {required this.now});
  final TaskItem task;
  final DateTime now;
  @override
  Widget build(BuildContext context) => TaskDetailPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.375,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            TaskBadge(
              taskPriorityLabel(task.priority),
              task.priority == TaskPriority.normal
                  ? (taskBlue, AppColors.ocean)
                  : priorityColors(task.priority),
              fontSize: 12,
            ),
            TaskBadge(
              taskStatusLabel(task.status),
              statusColors(task.status),
              dot: true,
              fontSize: 12,
            ),
            if (task.overdueAt(now))
              const TaskBadge('Quá hạn', (
                taskRed,
                AppColors.error,
              ), fontSize: 12),
          ],
        ),
        if (task.description?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Text(
            task.description!,
            style: const TextStyle(
              fontSize: 13,
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
  Widget build(BuildContext context) => TaskDetailPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TaskFact('Người giao', task.assigner?.name ?? '—'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TaskFact('KTV phụ trách', task.assignee?.name ?? '—'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _TaskFact('Trang trại', task.farm?.name ?? '—')),
            const SizedBox(width: 12),
            Expanded(
              child: _TaskFact(
                'Hạn hoàn thành',
                taskTimestamp(task.dueAt, empty: 'Không đặt hạn'),
                valueColor: task.canEdit && task.overdueAt(now)
                    ? AppColors.error
                    : AppColors.ink,
              ),
            ),
          ],
        ),
        if (task.season != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _TaskFact(
              'Ao · Vụ nuôi',
              [
                if (task.pond != null) task.pond!.name,
                task.season!.name,
              ].join(' · '),
            ),
          ),
        ],
      ],
    ),
  );
}

class _TaskFact extends StatelessWidget {
  const _TaskFact(this.label, this.value, {this.valueColor = AppColors.ink});
  final String label, value;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          height: 1.5,
          color: AppColors.inkMuted,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: TextStyle(
          fontSize: 13,
          height: 1.625,
          fontWeight: FontWeight.w600,
          color: valueColor,
        ),
      ),
    ],
  );
}

class TaskTimeline extends StatelessWidget {
  const TaskTimeline(this.task, {super.key});
  final TaskItem task;
  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1D7AD6);
    const muted = Color(0xFFCAD5E2);
    const green = Color(0xFF009966);
    final cancelled = task.status == TaskStatus.cancelled;
    final completed = task.status == TaskStatus.completed;
    final started = task.startedAt != null;
    final connectors = [
      cancelled
          ? muted
          : started
          ? blue
          : AppColors.line,
      cancelled
          ? muted
          : completed
          ? blue
          : AppColors.line,
    ];
    return TaskDetailPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiến trình thực hiện',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var index = 0; index < 3; index++)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index == 0
                              ? Colors.transparent
                              : connectors[index - 1],
                        ),
                      ),
                      const SizedBox(width: 3),
                      _MilestoneCircle(
                        color: index == 2 && cancelled
                            ? AppColors.error
                            : index == 2 && completed
                            ? green
                            : cancelled
                            ? const Color(0xFF90A1B9)
                            : blue,
                        filled:
                            index == 0 && (started || cancelled || completed) ||
                            index == 1 && (completed || cancelled && started),
                        current:
                            !cancelled &&
                            (index == 0 && task.status == TaskStatus.pending ||
                                index == 1 &&
                                    task.status == TaskStatus.inProgress),
                        finalState: index == 2 && (cancelled || completed),
                        cancelled: index == 2 && cancelled,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index == 2
                              ? Colors.transparent
                              : connectors[index],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            children: [
              TableRow(
                children: [
                  _MilestoneLabel(
                    'Được giao',
                    active: task.status == TaskStatus.pending,
                  ),
                  _MilestoneLabel(
                    'Đang làm',
                    active: task.status == TaskStatus.inProgress,
                  ),
                  _MilestoneLabel(
                    cancelled ? 'Đã hủy' : 'Hoàn thành',
                    color: cancelled
                        ? AppColors.error
                        : completed
                        ? green
                        : null,
                  ),
                ],
              ),
              TableRow(
                children: [
                  _MilestoneTimestamp(task.createdAt),
                  _MilestoneTimestamp(
                    task.startedAt,
                    empty: cancelled ? 'Chưa bắt đầu' : 'Chưa ghi nhận',
                  ),
                  _MilestoneTimestamp(
                    cancelled ? task.cancelledAt : task.completedAt,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MilestoneCircle extends StatelessWidget {
  const _MilestoneCircle({
    required this.color,
    required this.filled,
    required this.current,
    required this.finalState,
    required this.cancelled,
  });
  final Color color;
  final bool filled, current, finalState, cancelled;
  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: filled
          ? color
          : finalState
          ? (cancelled ? taskRed : const Color(0xFFECFDF5))
          : current
          ? taskBlue
          : taskGray,
      border: Border.all(
        color: current
            ? color
            : finalState || filled
            ? Colors.transparent
            : AppColors.line,
        width: 8 / 9,
      ),
    ),
    child: filled || finalState
        ? Center(
            child: AppSvgIcon(
              cancelled ? AppSvgIconName.close : AppSvgIconName.checkSmall,
              size: cancelled ? 15 : 12,
              color: filled ? Colors.white : color,
            ),
          )
        : Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current ? color : const Color(0xFFCAD5E2),
              ),
            ),
          ),
  );
}

class _MilestoneLabel extends StatelessWidget {
  const _MilestoneLabel(this.label, {this.active = false, this.color});
  final String label;
  final bool active;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w700,
        color: color ?? (active ? AppColors.ocean : AppColors.inkSoft),
      ),
    ),
  );
}

class _MilestoneTimestamp extends StatelessWidget {
  const _MilestoneTimestamp(this.value, {this.empty = 'Chưa ghi nhận'});
  final DateTime? value;
  final String empty;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        const style = TextStyle(
          fontSize: 11,
          height: 1.625,
          color: AppColors.inkMuted,
        );
        final timestamp = taskTimestamp(value, empty: empty);
        var display = timestamp;
        if (value != null) {
          final effectiveStyle = DefaultTextStyle.of(
            context,
          ).style.merge(style);
          final painter = TextPainter(
            text: TextSpan(text: timestamp, style: effectiveStyle),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout();
          if (painter.width > constraints.maxWidth) {
            final parts = timestamp.split(' ');
            var date = parts[1];
            painter.text = TextSpan(text: date, style: effectiveStyle);
            painter.layout();
            // Keep date groups intact when a narrow column needs another line.
            if (painter.width > constraints.maxWidth) {
              final yearSeparator = date.lastIndexOf('/');
              date = date.replaceRange(yearSeparator, yearSeparator + 1, '\n');
            }
            display = '${parts[0]}\n$date';
          }
          painter.dispose();
        }
        return Semantics(
          label: timestamp,
          excludeSemantics: true,
          child: Text(display, textAlign: TextAlign.center, style: style),
        );
      },
    ),
  );
}
