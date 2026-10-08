import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

class OperationStatsBar extends StatelessWidget {
  const OperationStatsBar({required this.summary, super.key});

  final OperationSummary summary;

  Widget _buildStatBox({
    required String title,
    required int count,
    Color? countColor,
  }) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              color: countColor ?? AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _buildStatBox(
        title: 'CHỜ THỰC\nHIỆN',
        count: summary.planned,
        countColor: AppColors.ink,
      ),
      const SizedBox(width: 10),
      _buildStatBox(
        title: 'HOÀN THÀNH\n ',
        count: summary.completed,
        countColor: const Color(0xFF0F9B8E),
      ),
      const SizedBox(width: 10),
      _buildStatBox(
        title: 'ĐÃ HỦY\n ',
        count: summary.cancelled,
        countColor: AppColors.inkMuted,
      ),
    ],
  );
}
