import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';

const taskBlue = Color(0xFFEAF4FF);
const taskRed = Color(0xFFFBE6EA);
const taskAmber = Color(0xFFFBF0DC);
const taskGray = Color(0xFFEEF1F6);
const taskGreen = Color(0xFFE2F6F3);

TextStyle taskHeadingStyle({
  double size = 16,
  FontWeight weight = FontWeight.w700,
}) => AppTypography.display(
  fontSize: size,
  fontWeight: weight,
  color: AppColors.ink,
  height: 1.25,
).copyWith(fontFamilyFallback: const ['PlusJakartaSans']);

class TaskHeader extends StatelessWidget {
  const TaskHeader({
    required this.title,
    required this.onBack,
    this.trailing,
    super.key,
  });
  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) =>
      PageHeaderBar(title: title, trailing: trailing, onBack: onBack);
}

String taskError(Object error) => error is AppException
    ? error.message
    : 'Không thể tải nhiệm vụ. Vui lòng thử lại.';
String taskTimestamp(DateTime? value, {String empty = 'Chưa đặt hạn'}) {
  if (value == null) return empty;
  final local = value.toLocal();
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(local.hour)}:${pad(local.minute)} ${pad(local.day)}/${pad(local.month)}/${local.year}';
}

String taskDeadlineInput(DateTime value) {
  final local = value.toLocal();
  String pad(int n) => n.toString().padLeft(2, '0');
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  return '${pad(local.day)}/${pad(local.month)}/${local.year} ${pad(hour)}:${pad(local.minute)} ${local.hour < 12 ? 'AM' : 'PM'}';
}

(Color, Color) priorityColors(TaskPriority p) => switch (p) {
  TaskPriority.urgent => (taskRed, AppColors.error),
  TaskPriority.high => (taskAmber, const Color(0xFFD98314)),
  TaskPriority.low => (taskGray, const Color(0xFF64748B)),
  _ => (taskBlue, const Color(0xFF0C4E8F)),
};
(Color, Color) statusColors(TaskStatus s) => switch (s) {
  TaskStatus.inProgress => (taskBlue, const Color(0xFF0C4E8F)),
  TaskStatus.completed => (taskGreen, const Color(0xFF0F9B8E)),
  TaskStatus.cancelled => (taskRed, AppColors.error),
  _ => (taskGray, const Color(0xFF64748B)),
};

class TaskBadge extends StatelessWidget {
  const TaskBadge(
    this.label,
    this.colors, {
    this.dot = false,
    this.fontSize = 11,
    super.key,
  });
  final String label;
  final (Color, Color) colors;
  final bool dot;
  final double fontSize;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: colors.$1,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: colors.$2, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: colors.$2,
            fontSize: fontSize,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class TaskBadges extends StatelessWidget {
  const TaskBadges(
    this.task, {
    this.detail = false,
    required this.now,
    super.key,
  });
  final TaskItem task;
  final bool detail;
  final DateTime now;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 4,
    children: [
      TaskBadge(
        taskPriorityLabel(task.priority),
        priorityColors(task.priority),
      ),
      TaskBadge(
        taskStatusLabel(task.status),
        statusColors(task.status),
        dot: detail,
      ),
      if (task.overdueAt(now))
        const TaskBadge('Quá hạn', (taskRed, AppColors.error)),
    ],
  );
}

class TaskPanel extends StatelessWidget {
  const TaskPanel({required this.child, this.elevated = false, super.key});
  final Widget child;
  final bool elevated;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(elevated ? 18 : 16),
      border: elevated ? Border.all(color: AppColors.line, width: .8) : null,
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: Color(0x590F1C2E),
                blurRadius: 24,
                offset: Offset(0, 16),
              ),
              BoxShadow(
                color: Color(0x0A0F1C2E),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ]
          : const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
    ),
    child: child,
  );
}

/// Flat card used by the task detail design; list and form cards keep their styling.
class TaskDetailPanel extends StatelessWidget {
  const TaskDetailPanel({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.line, width: 8 / 9),
    ),
    child: child,
  );
}

class TaskEmpty extends StatelessWidget {
  const TaskEmpty({this.canCreate = false, super.key});
  final bool canCreate;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const TaskDashedBorder(),
    child: SizedBox(
      width: double.infinity,
      height: 184,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: taskGray,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const AppSvgIcon(
              AppSvgIconName.tasks,
              size: 22,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Không có nhiệm vụ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          if (canCreate) ...[
            const SizedBox(height: 6),
            const Text(
              "Nhấn '+' để tạo và giao nhiệm vụ mới.",
              style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
            ),
          ],
        ],
      ),
    ),
  );
}

class TaskDashedBorder extends CustomPainter {
  const TaskDashedBorder({this.radius = 16, this.strokeWidth = 1.2});
  final double radius;
  final double strokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      for (double start = 0; start < metric.length; start += 5) {
        canvas.drawPath(metric.extractPath(start, start + 3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TaskDashedBorder oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.strokeWidth != strokeWidth;
}
