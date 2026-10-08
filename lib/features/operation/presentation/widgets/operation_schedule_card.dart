import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

class OperationScheduleCard extends StatelessWidget {
  const OperationScheduleCard({
    required this.schedule,
    required this.onTap,
    super.key,
  });

  final OperationSchedule schedule;
  final VoidCallback onTap;

  (Color bg, Color fg, IconData icon) _typeVisuals(OperationType type) =>
      switch (type) {
        OperationType.feeding => (
          const Color(0xFFE2F6F3),
          const Color(0xFF0F9B8E),
          Icons.settings_outlined,
        ),
        OperationType.mineral => (
          const Color(0xFFEAF4FF),
          const Color(0xFF1378D1),
          Icons.grain_rounded,
        ),
        OperationType.chemical => (
          const Color(0xFFF0E9FF),
          const Color(0xFF7B5BD6),
          Icons.biotech_rounded,
        ),
        OperationType.medicine => (
          const Color(0xFFFBE6EA),
          AppColors.error,
          Icons.medication_rounded,
        ),
        OperationType.other => (
          const Color(0xFFF5F5F5),
          AppColors.inkSoft,
          Icons.category_rounded,
        ),
      };

  (Color dot, Color text, Color bg) _statusVisuals(OperationStatus status) =>
      switch (status) {
        OperationStatus.planned => (
          const Color(0xFF1378D1),
          const Color(0xFF1378D1),
          const Color(0xFFEAF4FF),
        ),
        OperationStatus.completed => (
          const Color(0xFF0F9B8E),
          const Color(0xFF0F9B8E),
          const Color(0xFFE2F6F3),
        ),
        OperationStatus.cancelled => (
          AppColors.inkMuted,
          AppColors.inkMuted,
          const Color(0xFFF5F5F5),
        ),
      };

  @override
  Widget build(BuildContext context) {
    final (iconBg, iconFg, icon) = _typeVisuals(schedule.operationType);
    final (statusDot, statusText, statusBg) = _statusVisuals(schedule.status);

    final localTime = schedule.scheduledAt.toLocal();
    final timeStr =
        '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';

    final quantityStr =
        '${schedule.plannedQuantity} ${schedule.unit.toLowerCase()}';
    final mealStr = schedule.protocolItem?.mealNumber != null
        ? 'Cữ ${schedule.protocolItem!.mealNumber}'
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line.withValues(alpha: 0.6)),
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconFg, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              schedule.operationType.displayName,
                              style: TextStyle(
                                color: iconFg,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(10),
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
