import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

class OperationStatsBar extends StatelessWidget {
  const OperationStatsBar({
    required this.summary,
    super.key,
  });

  final OperationSummary summary;

  Widget _buildStatBox({
    required String title,
    required int count,
    Color? countColor,
  }) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
              width: 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: TextStyle(
                  color: countColor ?? AppColors.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
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
        title: 'CHỜ THỰC HIỆN',
        count: summary.planned,
        countColor: AppColors.ink,
      ),
      const SizedBox(width: 8),
      _buildStatBox(
        title: 'HOÀN THÀNH',
        count: summary.completed,
        countColor: const Color(0xFF0D9488),
      ),
      const SizedBox(width: 8),
      _buildStatBox(
        title: 'ĐÃ HỦY',
        count: summary.cancelled,
        countColor: AppColors.inkSoft,
      ),
    ],
  );
}
