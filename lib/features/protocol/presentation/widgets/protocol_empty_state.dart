import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolEmptyState extends StatelessWidget {
  const ProtocolEmptyState({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: const _EmptyBorder(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: protocolPanel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const AppSvgIcon(AppSvgIconName.document, size: 22),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chưa có phác đồ',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              fontFamily: 'Sora',
              fontFamilyFallback: ['PlusJakartaSans'],
            ),
          ),
          const SizedBox(height: 4),
          const SizedBox(
            width: 220,
            child: Text(
              'Chuyên gia sẽ soạn và gửi phác đồ để Chủ trại xem.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
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
