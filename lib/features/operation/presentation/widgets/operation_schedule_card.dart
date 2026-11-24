import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

class OperationScheduleCard extends StatelessWidget {
  const OperationScheduleCard({
    required this.schedule,
    required this.onTap,
    this.decoration,
    super.key,
  });

  final OperationSchedule schedule;
  final VoidCallback onTap;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final visuals = OperationTypeVisuals.of(schedule.operationType);

    final timeStr = schedule.timeRangeText;
    final isOverdue = schedule.isOverdue;

    final quantityStr =
        '${schedule.plannedQuantity} ${schedule.unit.toLowerCase()}';
    final mealStr = schedule.protocolItem?.mealNumber != null
        ? 'Cữ ${schedule.protocolItem!.mealNumber}'
        : null;

    final baseDecoration =
        decoration ??
        BoxDecoration(
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
        );
    // Keep overdue warnings visible even when the parent customizes the card.
    final cardDecoration = decoration != null && isOverdue
        ? baseDecoration.copyWith(
            color: OperationOverdueBadge.cardSurface,
            border: Border.all(
              color: OperationOverdueBadge.cardBorder.withValues(alpha: 0.85),
            ),
          )
        : baseDecoration;
    final borderRadius =
        cardDecoration.borderRadius?.resolve(Directionality.of(context)) ??
        BorderRadius.circular(20);
    return Container(
      decoration: cardDecoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
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
                          Flexible(
                            child: Text(
                              timeStr,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
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
                          Flexible(
                            child: Text(
                              quantityStr,
                              style: const TextStyle(
                                color: AppColors.inkSoft,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      OperationStatusLine(
                        badge: OperationStatusBadge(status: schedule.status),
                        label: isOverdue
                            ? const OperationOverdueBadge(compact: true)
                            : null,
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
