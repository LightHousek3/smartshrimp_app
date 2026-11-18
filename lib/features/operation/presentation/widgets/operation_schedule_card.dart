import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

class OperationScheduleCard extends StatelessWidget {
  const OperationScheduleCard({
    required this.schedule,
    required this.onTap,
    super.key,
  });

  final OperationSchedule schedule;
  final VoidCallback onTap;

  static const Color _blueBg = Color(0xFFDEEDFD);
  static const Color _blueFg = Color(0xFF1D7AD6);

  (Color dot, Color text, Color bg) _statusVisuals(OperationStatus status) =>
      switch (status) {
        OperationStatus.planned => (
          _blueFg,
          _blueFg,
          _blueBg,
        ),
        OperationStatus.completed => (
          const Color(0xFF10B981),
          const Color(0xFF047857),
          const Color(0xFFECFDF5),
        ),
        OperationStatus.cancelled => (
          AppColors.inkMuted,
          AppColors.inkMuted,
          const Color(0xFFF1F5F9),
        ),
      };

  @override
  Widget build(BuildContext context) {
    final visuals = OperationTypeVisuals.of(schedule.operationType);
    final (statusDot, statusText, statusBg) = _statusVisuals(schedule.status);

    final timeStr = schedule.timeRangeText;
    final isOverdue = schedule.isOverdue;

    final quantityStr =
        '${schedule.plannedQuantity} ${schedule.unit.toLowerCase()}';
    final mealStr = schedule.protocolItem?.mealNumber != null
        ? 'Cữ ${schedule.protocolItem!.mealNumber}'
        : null;

    return Container(
      decoration: BoxDecoration(
        color: isOverdue ? OperationOverdueBadge.cardSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOverdue
              ? OperationOverdueBadge.cardBorder.withValues(alpha: 0.85)
              : AppColors.line.withValues(alpha: 0.6),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OperationProductThumbnail(
                  imageUrl: schedule.productImageUrl,
                  fallbackIcon: visuals.icon,
                  fallbackBg: visuals.bg,
                  fallbackFg: visuals.fg,
                  size: 44,
                  borderRadius: 14,
                  iconSize: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          OperationTypeBadge(type: schedule.operationType),
                          if (mealStr != null) ...<Widget>[
                            const SizedBox(width: 8),
                            Text(
                              mealStr,
                              style: const TextStyle(
                                color: AppColors.inkSoft,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.5,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusDot,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  schedule.status.displayName,
                                  style: TextStyle(
                                    color: statusText,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        schedule.productName,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeStr,
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '·',
                            style: TextStyle(
                              color: AppColors.inkMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            quantityStr,
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isOverdue) ...<Widget>[
                            const Spacer(),
                            const OperationOverdueBadge(compact: true),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
