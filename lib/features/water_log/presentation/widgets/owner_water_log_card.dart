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
              WaterLogObservation(
                measurements: log,
                recordedAt: log.recordedAt,
                recordedByName: log.recordedByName,
                note: log.note,
                metadata: metadata,
              ),
              if (showAudit && log.isVoided) ...[
                const SizedBox(height: 12),
                _Note(title: 'Lý do hủy hiệu lực', text: log.voidReason ?? '—'),
                if (log.voidedAt case final voidedAt?)
                  Text(
                    '${formatWaterTime(voidedAt)} · ${formatWaterDay(voidedAt)}',
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

/// Display the same water log content inside a log card or an opening snapshot.
class WaterLogObservation extends StatelessWidget {
  const WaterLogObservation({
    required this.measurements,
    this.recordedAt,
    this.recordedByName,
    this.note,
    this.metadata,
    this.showStatusBadge = true,
    super.key,
  });

  final WaterMeasurements measurements;
  final DateTime? recordedAt;
  final String? recordedByName;
  final String? note;
  final WaterLogMetadata? metadata;
  final bool showStatusBadge;

  @override
  Widget build(BuildContext context) {
    final hasName = recordedByName?.trim().isNotEmpty == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recordedAt != null || hasName) ...[
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
                  spacing: 4,
                  children: [
                    if (recordedAt case final at?)
                      Text(
                        '${formatWaterTime(at)} · ${formatWaterDay(at)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    Text(
                      hasName ? recordedByName! : 'Chưa cập nhật tên',
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
        ],
        if (showStatusBadge &&
            (measurements.hasMeasurements || measurements.isVoided)) ...[
          Align(
            alignment: Alignment.centerRight,
            child: WaterLogStatusBadge(log: measurements),
          ),
          const SizedBox(height: 12),
        ],
        WaterParamTiles(
          log: measurements,
          metadata: metadata,
          boxed: true,
          includeH2s: true,
        ),
        if (note?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 12),
          _Note(title: 'GHI CHÚ', text: note!),
        ],
      ],
    );
  }
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
