import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class SeasonMaterialCostCard extends StatelessWidget {
  const SeasonMaterialCostCard({required this.costs, super.key});

  final SeasonMaterialCosts? costs;

  @override
  Widget build(BuildContext context) {
    final data = costs;
    return SeasonSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi phí vật tư',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (data == null)
            const Text(
              'Chưa có dữ liệu chi phí',
              style: TextStyle(color: AppColors.inkMuted),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final ring = SizedBox.square(
                  dimension: 128,
                  child: CustomPaint(
                    painter: _CostRingPainter(data),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TỔNG ĐÃ DÙNG',
                              style: TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                seasonCostMoneyLabel(data.total),
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                final rows = Column(
                  children: [
                    _CostRow(
                      label: 'Thức ăn',
                      amount: data.feed,
                      percent: data.proportion(data.feed),
                      color: const Color(0xFF0F9B8E),
                    ),
                    const SizedBox(height: 9),
                    _CostRow(
                      label: 'Thuốc',
                      amount: data.medicine,
                      percent: data.proportion(data.medicine),
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 9),
                    _CostRow(
                      label: 'Môi trường',
                      amount: data.environment,
                      percent: data.proportion(data.environment),
                      color: const Color(0xFF7B5BD6),
                    ),
                  ],
                );
                if (constraints.maxWidth < 340) {
                  return Column(
                    children: [
                      Center(child: ring),
                      const SizedBox(height: 16),
                      rows,
                    ],
                  );
                }
                return Row(
                  children: [
                    ring,
                    const SizedBox(width: 16),
                    Expanded(child: rows),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

// Format the validated decimal string directly so large amounts stay exact.
String seasonCostMoneyLabel(String amount) {
  final parts = amount.split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
    buffer.write(digits[index]);
  }
  if (parts[1] != '00') buffer.write(',${parts[1]}');
  return '$buffer ₫';
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
  });
  final String label;
  final String amount;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 10),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  seasonCostMoneyLabel(amount),
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 5,
                color: color,
                backgroundColor: const Color(0xFFEEF1F6),
              ),
            ),
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: 28,
            child: Text(
              '${(percent * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 9),
            ),
          ),
        ],
      ),
    ],
  );
}

class _CostRingPainter extends CustomPainter {
  const _CostRingPainter(this.costs);
  final SeasonMaterialCosts costs;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(7);
    final paint = Paint()
      ..color = const Color(0xFFEEF1F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, paint);
    var start = -math.pi / 2;
    final segments = [
      (costs.feed, const Color(0xFF0F9B8E)),
      (costs.medicine, AppColors.error),
      (costs.environment, const Color(0xFF7B5BD6)),
    ];
    for (final (amount, color) in segments) {
      final sweep = costs.proportion(amount) * math.pi * 2;
      if (sweep > 0) {
        canvas.drawArc(rect, start, sweep, false, paint..color = color);
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _CostRingPainter oldDelegate) =>
      oldDelegate.costs != costs;
}
