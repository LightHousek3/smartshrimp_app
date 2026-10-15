import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_summary.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

String _number(double? value) => formatWaterValue(value).replaceAll('.', ',');

class WaterThresholdSummary extends StatelessWidget {
  const WaterThresholdSummary({
    required this.logs,
    required this.metadata,
    super.key,
  });
  final List<WaterLog> logs;
  final WaterLogMetadata metadata;

  @override
  Widget build(BuildContext context) {
    final params = [
      waterLogFormParams[2],
      waterLogFormParams[1],
      waterLogFormParams[0],
      ...waterLogFormParams.skip(3),
    ];
    final rows = [
      for (final param in params)
        (
          param: param,
          metric: metadata.metrics.firstWhere(
            (metric) => metric.field == param.field,
          ),
          counts: summarizeWaterMetric(
            logs,
            metadata.metrics.firstWhere(
              (metric) => metric.field == param.field,
            ),
          ),
        ),
    ];
    final measured = rows.fold(0, (sum, row) => sum + row.counts.measured);
    final outside = rows.fold(
      0,
      (sum, row) => sum + row.counts.above + row.counts.below,
    );
    final validLogs = logs.where((log) => !log.isVoided).length;
    return Container(
      key: const Key('water_average_summary'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F8FF),
              border: Border(bottom: BorderSide(color: Color(0xFFEEF1F7))),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x180F1C2E),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/water-log/water_statistics.svg',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chỉ số trung bình',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$validLogs nhật ký hợp lệ · $outside/$measured phép đo ngoài ngưỡng',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 10,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (var row = 0; row < 4; row++) ...[
                  if (row > 0) const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var column = 0; column < 2; column++) ...[
                          if (column > 0) const SizedBox(width: 10),
                          Expanded(
                            child: _MetricCard(
                              key: Key(
                                'water_summary_${rows[row * 2 + column].param.field}',
                              ),
                              param: rows[row * 2 + column].param,
                              metric: rows[row * 2 + column].metric,
                              counts: rows[row * 2 + column].counts,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.param,
    required this.metric,
    required this.counts,
    super.key,
  });
  final WaterLogParam param;
  final WaterMetricMetadata metric;
  final WaterMetricSummary counts;

  String get unit => param.unit;
  String get threshold {
    final min = metric.warningMin, max = metric.warningMax;
    final bounds = min != null && max != null
        ? '${_number(min)}–${_number(max)}'
        : min != null
        ? 'từ ${_number(min)}'
        : max != null
        ? 'không quá ${_number(max)}'
        : 'không giới hạn';
    final suffix = param.field == 'ph' ? 'pH' : unit;
    return 'Ngưỡng: $bounds${(min != null || max != null) && suffix.isNotEmpty ? ' $suffix' : ''}';
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE9EDF3)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A0F1C2E),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${param.label}${unit.isEmpty ? '' : ' ($unit)'}',
          style: const TextStyle(
            color: AppColors.inkSoft,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            _number(counts.average),
            key: Key('water_average_${param.field}'),
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            threshold,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ),
        const Divider(height: 16, color: Color(0xFFEDF1F7)),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Trong ngưỡng',
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                counts.measured == 0
                    ? '—'
                    : '${counts.within}/${counts.measured}',
                style: const TextStyle(
                  color: Color(0xFF00A496),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _RateTile(
                label: 'Thấp hơn',
                count: counts.below,
                measured: counts.measured,
                high: false,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _RateTile(
                label: 'Cao hơn',
                count: counts.above,
                measured: counts.measured,
                high: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _RateTile extends StatelessWidget {
  const _RateTile({
    required this.label,
    required this.count,
    required this.measured,
    required this.high,
  });
  final String label;
  final int count, measured;
  final bool high;
  String get rate {
    if (measured == 0) return '—';
    final value = count * 100 / measured;
    final percentage = value > 0 && value < .1
        ? '<0,1'
        : value
              .toStringAsFixed(1)
              .replaceFirst(RegExp(r'\.0$'), '')
              .replaceAll('.', ',');
    return '$count · $percentage%';
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: count == 0
          ? const Color(0xFFEEF1F6)
          : high
          ? const Color(0xFFFBE6EA)
          : const Color(0xFFFCF0DA),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 9,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            rate,
            style: TextStyle(
              color: count == 0
                  ? AppColors.inkMuted
                  : high
                  ? AppColors.error
                  : const Color(0xFFE28A00),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
