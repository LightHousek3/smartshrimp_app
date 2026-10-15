import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_trend_chart.dart';

class WaterMetricTrend extends StatefulWidget {
  const WaterMetricTrend({
    required this.logs,
    required this.metric,
    required this.field,
    super.key,
  });
  final List<WaterLog> logs;
  final WaterMetricMetadata metric;
  final String field;
  @override
  State<WaterMetricTrend> createState() => _WaterMetricTrendState();
}

class _WaterMetricTrendState extends State<WaterMetricTrend> {
  int? _selected;
  String _day(DateTime value) {
    final date = value.toLocal();
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}';
  }

  String _number(double value) => formatWaterValue(value).replaceAll('.', ',');
  @override
  Widget build(BuildContext context) {
    final logs = widget.logs
        .where((log) => log.valueOf(widget.field) != null)
        .toList(growable: false);
    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Text(
          'Chưa có dữ liệu cho chỉ số này trong khoảng thời gian đã chọn.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
        ),
      );
    }
    final index = _selected ?? logs.length - 1;
    final log = logs[index];
    final sameTime = logs
        .where((entry) => entry.recordedAt == log.recordedAt)
        .toList(growable: false);
    final value = log.valueOf(widget.field)!;
    final warning = log.exceededParameters.contains(widget.field);
    final previous = index == 0 ? null : logs[index - 1].valueOf(widget.field);
    final delta = previous == null ? null : value - previous;
    final unit = widget.metric.unit;
    final safeCount = logs
        .where((log) => !log.exceededParameters.contains(widget.field))
        .length;
    final min = widget.metric.warningMin;
    final max = widget.metric.warningMax;
    final threshold = min != null && max != null
        ? '${_number(min)} – ${_number(max)}'
        : min != null
        ? 'từ ${_number(min)}'
        : max != null
        ? 'đến ${_number(max)}'
        : 'Chưa có ngưỡng';
    final label = widget.field == 'dissolvedOxygenMgL'
        ? 'Oxy hòa tan'
        : waterLogParamLabel(widget.field);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$label · ${_day(log.recordedAt)}'.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 6,
                      children: [
                        Text(
                          _number(value),
                          key: const Key('water_trend_selected_value'),
                          style: AppTypography.display(
                            color: AppColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        Text(
                          unit,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: warning
                          ? const Color(0xFFFBE6EA)
                          : const Color(0xFFE2F6F3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: warning
                                ? AppColors.error
                                : const Color(0xFF0F9B8E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          warning ? 'Ngoài ngưỡng' : 'An toàn',
                          style: TextStyle(
                            color: warning
                                ? AppColors.error
                                : const Color(0xFF0F9B8E),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    delta == null
                        ? 'Chưa có lần đo trước'
                        : delta == 0
                        ? 'Không đổi'
                        : '${delta > 0 ? 'Tăng' : 'Giảm'} ${_number(delta.abs())} $unit',
                    style: const TextStyle(
                      color: Color(0xFFD98314),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (sameTime.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Lần đo ${sameTime.indexOf(log) + 1}/${sameTime.length} cùng thời điểm · Chạm lại để đổi',
              key: const Key('water_trend_overlapping_selection'),
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: WaterTrendChart(
            logs: logs,
            field: widget.field,
            metric: widget.metric,
            selectedIndex: index,
            onSelect: (index) => setState(() => _selected = index),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0x99EEF1F6),
          child: Row(
            children: [
              Expanded(
                child: _FooterStat(
                  label: 'TRONG NGƯỠNG',
                  value: '$safeCount/${logs.length} lần đo',
                  accent: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FooterStat(
                  label: 'NGƯỠNG KIỂM SOÁT',
                  value:
                      '$threshold${min != null || max != null ? ' $unit' : ''}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterStat extends StatelessWidget {
  const _FooterStat({
    required this.label,
    required this.value,
    this.accent = false,
  });
  final String label, value;
  final bool accent;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 52),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: accent ? const Color(0xFF0F9B8E) : AppColors.ink,
            fontSize: accent ? 14 : 11,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
