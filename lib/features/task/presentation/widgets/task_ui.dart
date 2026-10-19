import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
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
  Widget build(BuildContext context) => PageHeaderBar(
    title: title,
    height: 76,
    titleStyle: taskHeadingStyle(),
    trailing: trailing,
    backButton: AppCircleButton(
      icon: Icons.arrow_back,
      tooltip: 'Quay lại',
      onPressed: onBack,
      size: 36,
      backgroundColor: Colors.transparent,
      iconWidget: const Center(
        child: AppSvgIcon(
          AppSvgIconName.back,
          size: 20,
          color: AppColors.inkSoft,
        ),
      ),
    ),
  );
}

String taskError(Object error) => error is AppException
    ? error.message
    : 'Không thể tải nhiệm vụ. Vui lòng thử lại.';
String taskDate(DateTime? value) {
  if (value == null) return 'Chưa đặt hạn';
  final local = value.toLocal();
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(local.hour)}:${pad(local.minute)} ${pad(local.day)}–${pad(local.month)}';
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
  const TaskBadge(this.label, this.colors, {this.dot = false, super.key});
  final String label;
  final (Color, Color) colors;
  final bool dot;
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
            fontSize: 11,
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
  const TaskPanel({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
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

class TaskLoadError extends StatelessWidget {
  const TaskLoadError(this.error, this.retry, {super.key});
  final Object error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(taskError(error), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: retry, child: const Text('Thử lại')),
      ],
    ),
  );
}

class TaskEmpty extends StatelessWidget {
  const TaskEmpty({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _TaskDashedBorder(),
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
          const SizedBox(height: 6),
          const Text(
            "Nhấn '+' để tạo và giao nhiệm vụ mới.",
            style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
          ),
        ],
      ),
    ),
  );
}

class _TaskDashedBorder extends CustomPainter {
  const _TaskDashedBorder();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      );
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final metric in path.computeMetrics()) {
      for (double start = 0; start < metric.length; start += 5) {
        canvas.drawPath(metric.extractPath(start, start + 3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
