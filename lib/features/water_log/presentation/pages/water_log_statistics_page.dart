import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

class WaterLogStatisticsPage extends ConsumerStatefulWidget {
  const WaterLogStatisticsPage({
    required this.seasonId,
    this.pondName,
    super.key,
  });

  final String seasonId;
  final String? pondName;

  @override
  ConsumerState<WaterLogStatisticsPage> createState() =>
      _WaterLogStatisticsPageState();
}

class _StatsQuery {
  const _StatsQuery(this.seasonId, this.days, this.granularity);

  final String seasonId;
  final int days;
  final String granularity;

  @override
  bool operator ==(Object other) =>
      other is _StatsQuery &&
      other.seasonId == seasonId &&
      other.days == days &&
      other.granularity == granularity;

  @override
  int get hashCode => Object.hash(seasonId, days, granularity);
}

final _waterLogStatsProvider = FutureProvider.autoDispose
    .family<WaterLogStatistics, _StatsQuery>((ref, query) async {
      final repository = ref.watch(waterLogRepositoryProvider);
      final to = DateTime.now();
      final from = to.subtract(Duration(days: query.days));
      try {
        return await repository.getStatistics(
          seasonId: query.seasonId,
          from: from,
          to: to,
          granularity: query.granularity,
        );
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

class _WaterLogStatisticsPageState
    extends ConsumerState<WaterLogStatisticsPage> {
  int _days = 30;
  String _granularity = 'day';
  String? _selectedParam;

  @override
  Widget build(BuildContext context) {
    final query = _StatsQuery(widget.seasonId, _days, _granularity);
    final state = ref.watch(_waterLogStatsProvider(query));

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              StickyPageHeader(
                title: 'Thống kê chất lượng nước',
                subtitle: widget.pondName,
                onBack: context.pop,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _RangeChips(
                        days: _days,
                        onChanged: (value) => setState(() => _days = value),
                      ),
                      const SizedBox(height: 10),
                      _GranularityToggle(
                        granularity: _granularity,
                        onChanged: (value) =>
                            setState(() => _granularity = value),
                      ),
                      const SizedBox(height: 16),
                      state.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.ocean,
                            ),
                          ),
                        ),
                        error: (error, _) => _Failure(
                          error: error,
                          onRetry: () =>
                              ref.invalidate(_waterLogStatsProvider(query)),
                        ),
                        data: (stats) => _StatisticsBody(
                          stats: stats,
                          selectedParam: _selectedParam,
                          onSelectParam: (field) =>
                              setState(() => _selectedParam = field),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeChips extends StatelessWidget {
  const _RangeChips({required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    children: <Widget>[
      for (final option in const <int>[7, 30, 90])
        ChoiceChip(
          label: Text('$option ngày'),
          selected: days == option,
          onSelected: (_) => onChanged(option),
        ),
    ],
  );
}

class _GranularityToggle extends StatelessWidget {
  const _GranularityToggle({
    required this.granularity,
    required this.onChanged,
  });

  final String granularity;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<String>(
    segments: const <ButtonSegment<String>>[
      ButtonSegment(value: 'day', label: Text('Ngày')),
      ButtonSegment(value: 'week', label: Text('Tuần')),
    ],
    selected: <String>{granularity},
    onSelectionChanged: (selection) => onChanged(selection.first),
  );
}

class _StatisticsBody extends StatelessWidget {
  const _StatisticsBody({
    required this.stats,
    required this.selectedParam,
    required this.onSelectParam,
  });

  final WaterLogStatistics stats;
  final String? selectedParam;
  final ValueChanged<String> onSelectParam;

  @override
  Widget build(BuildContext context) {
    final ordered = <String>[
      for (final param in waterLogFormParams)
        if ((stats.parameters[param.field]?.count ?? 0) > 0) param.field,
    ];
    if (ordered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'Chưa có dữ liệu thống kê trong khoảng thời gian này.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.inkMuted, fontSize: 13),
          ),
        ),
      );
    }
    final active = selectedParam != null && ordered.contains(selectedParam)
        ? selectedParam!
        : ordered.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SummaryLine(stats: stats),
        const SizedBox(height: 14),
        const Text(
          'Chỉ số trung bình',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 118,
          ),
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            final field = ordered[index];
            return _ParamSummaryCard(
              field: field,
              stat: stats.parameters[field]!,
            );
          },
        ),
        const SizedBox(height: 18),
        const Text(
          'Biểu đồ theo thời gian',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final field in ordered)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(waterLogParamLabel(field)),
                    selected: active == field,
                    onSelected: (_) => onSelectParam(field),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _TrendChart(stats: stats, field: active),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.stats});

  final WaterLogStatistics stats;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xB3E6F4FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      '${stats.validRecords} mẫu hợp lệ · ${stats.voidedRecords} mẫu đã hủy',
      style: const TextStyle(
        color: AppColors.ocean,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ParamSummaryCard extends StatelessWidget {
  const _ParamSummaryCard({required this.field, required this.stat});

  final String field;
  final WaterLogParamStat stat;

  @override
  Widget build(BuildContext context) {
    final label = waterLogParamLabel(field);
    final unit = waterLogFormParams.firstWhere((p) => p.field == field).unit;
    final exceedance = stat.exceedanceRate == null
        ? '—'
        : '${(stat.exceedanceRate! * 100).toStringAsFixed(0)}% vượt ngưỡng';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xF7FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            unit.isEmpty ? label : '$label ($unit)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatWaterValue(stat.avg),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            'Min ${formatWaterValue(stat.min)} · Max ${formatWaterValue(stat.max)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
          ),
          const SizedBox(height: 2),
          Text(
            exceedance,
            style: TextStyle(
              color: (stat.exceedanceRate ?? 0) > 0
                  ? AppColors.error
                  : const Color(0xFF1E9E5A),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.stats, required this.field});

  final WaterLogStatistics stats;
  final String field;

  @override
  Widget build(BuildContext context) {
    final points = <_ChartPoint>[];
    for (final entry in stats.series) {
      final value = entry.values[field]?.avg;
      if (value != null) {
        points.add(_ChartPoint(entry.bucket, value));
      }
    }
    if (points.length < 2) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Chưa đủ dữ liệu để vẽ biểu đồ.',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xF7FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: CustomPaint(
        painter: _LineChartPainter(points: points),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ChartPoint {
  const _ChartPoint(this.label, this.value);

  final String label;
  final double value;
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.points});

  final List<_ChartPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 36.0;
    const rightPad = 8.0;
    const topPad = 8.0;
    const bottomPad = 26.0;
    final plotWidth = size.width - leftPad - rightPad;
    final plotHeight = size.height - topPad - bottomPad;
    if (plotWidth <= 0 || plotHeight <= 0) return;

    var min = points.first.value;
    var max = points.first.value;
    for (final point in points) {
      if (point.value < min) min = point.value;
      if (point.value > max) max = point.value;
    }
    if ((max - min).abs() < 1e-9) {
      min -= 1;
      max += 1;
    }
    final span = max - min;

    Offset toOffset(int index, double value) {
      final x =
          leftPad +
          (points.length == 1 ? 0.5 : index / (points.length - 1)) * plotWidth;
      final y = topPad + (1 - (value - min) / span) * plotHeight;
      return Offset(x, y);
    }

    // Lưới ngang.
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E8F0)
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(color: AppColors.inkMuted, fontSize: 9);
    for (var i = 0; i <= 3; i++) {
      final value = min + span * i / 3;
      final y = topPad + (1 - i / 3) * plotHeight;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + plotWidth, y),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: formatWaterValue(value), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - tp.height / 2));
    }

    // Đường avg.
    final linePaint = Paint()
      ..color = AppColors.ocean
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final offset = toOffset(i, points[i].value);
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(path, linePaint);

    // Điểm + nhãn trục X (tối đa 5 nhãn).
    final dotPaint = Paint()..color = AppColors.ocean;
    final labelCount = points.length <= 5 ? points.length : 5;
    for (var i = 0; i < points.length; i++) {
      final offset = toOffset(i, points[i].value);
      canvas.drawCircle(offset, 3, dotPaint);
      final showLabel =
          labelCount == points.length ||
          i == 0 ||
          i == points.length - 1 ||
          i % (points.length ~/ (labelCount - 1)) == 0;
      if (showLabel) {
        final rawLabel = points[i].label;
        final shortLabel = rawLabel.length > 10
            ? rawLabel.substring(5)
            : rawLabel;
        final tp = TextPainter(
          text: TextSpan(text: shortLabel, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            (offset.dx - tp.width / 2)
                .clamp(leftPad - 10, size.width - tp.width)
                .toDouble(),
            topPad + plotHeight + 6,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Column(
      children: <Widget>[
        Text(
          error is AppException
              ? (error as AppException).message
              : 'Đã xảy ra lỗi. Vui lòng thử lại.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}
