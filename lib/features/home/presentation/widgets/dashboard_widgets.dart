import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';

const dashboardTeal = Color(0xFF0D9D92);
const dashboardRed = Color(0xFFFF587C);
const dashboardPurple = Color(0xFF7C20FF);
const dashboardPanel = Color(0xFFEDF1F7);

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({
    required this.title,
    required this.hint,
    super.key,
  });

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 202,
    child: CustomPaint(
      foregroundPainter: const _EmptyStateBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EmptyStateBorder extends CustomPainter {
  const _EmptyStateBorder();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.55),
          const Radius.circular(16),
        ),
      );
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 9) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EmptyStateBorder oldDelegate) => false;
}

TextStyle dashboardDisplay({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) => AppTypography.display(
  fontSize: fontSize,
  fontWeight: fontWeight,
  color: color,
  height: height,
).copyWith(fontFamilyFallback: const ['PlusJakartaSans_regular']);

String dashboardMoney(double value, {bool signed = false}) {
  final absolute = value.abs();
  final divisor = absolute >= 1e9
      ? 1e9
      : absolute >= 1e6
      ? 1e6
      : absolute >= 1e3
      ? 1e3
      : 1;
  final suffix = divisor == 1e9
      ? ' tỷ'
      : divisor == 1e6
      ? ' tr'
      : divisor == 1e3
      ? ' nghìn'
      : ' đ';
  final digits = divisor == 1e9
      ? 2
      : divisor == 1
      ? 0
      : 1;
  final number = (absolute / divisor)
      .toStringAsFixed(digits)
      .replaceAll('.', ',');
  return '${value < 0
      ? '−'
      : signed && value > 0
      ? '+'
      : ''}$number$suffix';
}

String dashboardDate(String date) {
  final parsed = DateTime.parse(date);
  return '${parsed.day}/${parsed.month}/${parsed.year}';
}

String dashboardQuantity(double? value) => value == null
    ? '—'
    : value
          .toStringAsFixed(3)
          .replaceFirst(RegExp(r'\.?0+$'), '')
          .replaceAll('.', ',');

class DashboardSectionTitle extends StatelessWidget {
  const DashboardSectionTitle(this.title, {this.trailing, super.key});
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: dashboardDisplay(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.3,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x090F1C2E),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class DashboardIconTile extends StatelessWidget {
  const DashboardIconTile(
    this.icon, {
    this.color = AppColors.ocean,
    this.background = const Color(0xFFE8F2FF),
    super.key,
  });
  final AppSvgIconName icon;
  final Color color;
  final Color background;
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(child: AppSvgIcon(icon, color: color, size: 20)),
  );
}

class DashboardFailure extends StatelessWidget {
  const DashboardFailure({
    required this.error,
    required this.onRetry,
    super.key,
  });
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          error is AppException
              ? (error as AppException).message
              : 'Không thể tải dữ liệu. Vui lòng thử lại.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
        ),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}
