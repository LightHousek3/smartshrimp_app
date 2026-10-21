import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

/// Share the dashed empty-state layout across catalog, lots and history.
class InventoryEmptyState extends StatelessWidget {
  const InventoryEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inventory_2_outlined,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: const _EmptyBorder(),
    child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .65),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 22, color: AppColors.inkMuted),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                fontFamily: 'Sora',
                fontFamilyFallback: ['PlusJakartaSans'],
              ),
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EmptyBorder extends CustomPainter {
  const _EmptyBorder();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(.63),
          const Radius.circular(16),
        ),
      );
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.26;
    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 4) {
        canvas.drawPath(metric.extractPath(offset, offset + 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EmptyBorder oldDelegate) => false;
}
