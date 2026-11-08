import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

/// Owner presentation shares metric formatting and warning policy with technician views.
class OwnerWaterLogCard extends StatelessWidget {
  const OwnerWaterLogCard({
    required this.log,
    this.metadata,
    this.onTap,
    this.showAudit = false,
    super.key,
  });

  final WaterLog log;
  final WaterLogMetadata? metadata;
  final VoidCallback? onTap;
  final bool showAudit;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: log.isVoided ? .65 : 1,
    child: Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x330F1C2E),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: AppColors.ocean,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatWaterTime(log.recordedAt)} · ${formatWaterDay(log.recordedAt)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          log.recordedByName?.trim().isNotEmpty == true
                              ? log.recordedByName!
                              : 'Chưa cập nhật tên',
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: WaterLogStatusBadge(log: log),
              ),
              const SizedBox(height: 12),
              WaterParamTiles(
                log: log,
                metadata: metadata,
                boxed: true,
                includeH2s: true,
              ),
              if (log.note?.trim().isNotEmpty == true) ...[
                const SizedBox(height: 12),
                _Note(title: 'GHI CHÚ', text: log.note!),
              ],
              if (showAudit && log.isVoided) ...[
                const SizedBox(height: 12),
                _Note(title: 'Lý do hủy hiệu lực', text: log.voidReason ?? '—'),
                if (log.voidedAt != null)
                  Text(
                    '${formatWaterTime(log.voidedAt!)} · ${formatWaterDay(log.voidedAt!)}',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _Note extends StatelessWidget {
  const _Note({required this.title, required this.text});
  final String title, text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF1F6),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
        ),
      ],
    ),
  );
}
