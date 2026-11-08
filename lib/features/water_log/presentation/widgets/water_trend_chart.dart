import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

/// The Figma chart is rendered from API samples, never from a static chart asset.
class WaterTrendChart extends StatelessWidget {
  const WaterTrendChart({
    required this.series,
    required this.field,
    required this.metric,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });
  final List<WaterLogStatPoint> series;
  final String field;
  final WaterMetricMetadata metric;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      void select(double dx, {bool cycleOverlapping = false}) {
        if (series.isEmpty) return;
        var nearest = 0;
        var distance = double.infinity;
        for (var i = 0; i < series.length; i++) {
          final x = _x(series, i, constraints.maxWidth);
          if ((x - dx).abs() < distance) {
            nearest = i;
            distance = (x - dx).abs();
          }
        }
        // Keep real time positions. Repeated taps visit all readings at one X.
        final nearestX = _x(series, nearest, constraints.maxWidth);
        final overlapping = [
          for (var i = 0; i < series.length; i++)
            if (_x(series, i, constraints.maxWidth) == nearestX) i,
        ];
        final selectedPosition = overlapping.indexOf(selectedIndex);
        if (cycleOverlapping &&
            overlapping.length > 1 &&
            selectedPosition >= 0) {
          nearest = overlapping[(selectedPosition + 1) % overlapping.length];
        } else if (!cycleOverlapping && selectedPosition >= 0) {
          // A drag must not cycle repeatedly within an overlapping group.
          nearest = selectedIndex;
        }
        onSelect(nearest);
      }

      return Semantics(
        label:
            'Biểu đồ ${waterLogParamLabel(field)}, ${series.length} lần đo. Vuốt để chọn lần đo. Chạm lại vào điểm trùng thời gian để chọn lần đo khác.',
        onIncrease: selectedIndex < series.length - 1
            ? () => onSelect(selectedIndex + 1)
            : null,
        onDecrease: selectedIndex > 0
            ? () => onSelect(selectedIndex - 1)
            : null,
        child: GestureDetector(
          key: const Key('water_trend_chart'),
          onTapUp: (details) =>
              select(details.localPosition.dx, cycleOverlapping: true),
          onHorizontalDragUpdate: (details) => select(details.localPosition.dx),
          child: SizedBox(
            height: 176,
            width: double.infinity,
            child: CustomPaint(
              painter: WaterTrendPainter(series, field, metric, selectedIndex),
            ),
          ),
        ),
      );
    },
  );
}

double _x(List<WaterLogStatPoint> series, int index, double width) {
  final span = DateTime.parse(
    series.last.bucket,
  ).difference(DateTime.parse(series.first.bucket)).inMicroseconds;
  final ratio = span == 0
      ? (series.length == 1 ? .5 : index / (series.length - 1))
      : DateTime.parse(
              series[index].bucket,
            ).difference(DateTime.parse(series.first.bucket)).inMicroseconds /
            span;
  return 12 + ratio * math.max(0, width - 24);
}

class WaterTrendPainter extends CustomPainter {
  WaterTrendPainter(this.series, this.field, this.metric, this.selectedIndex);
  final List<WaterLogStatPoint> series;
  final String field;
  final WaterMetricMetadata metric;
  final int selectedIndex;
  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty || size.width <= 24) return;
    final values = series.map((point) => point.values[field]!.avg!).toList();
    final extrema = [
      for (final point in series) ...[
        point.values[field]!.min ?? point.values[field]!.avg!,
        point.values[field]!.max ?? point.values[field]!.avg!,
        point.values[field]!.avg!,
      ],
    ];
    var min = extrema.reduce(math.min);
    var max = extrema.reduce(math.max);
    if (metric.warningMin != null) {
      min = math.min(min, metric.warningMin!);
      max = math.max(max, metric.warningMin!);
    }
    if (metric.warningMax != null) {
      min = math.min(min, metric.warningMax!);
      max = math.max(max, metric.warningMax!);
    }
    final margin = max == min
        ? math.max(1.0, max.abs() * .1)
        : (max - min) * .18;
    min -= margin;
    max += margin;
    const top = 24.0, bottom = 145.0;
    double y(double value) =>
        top + (max - value) / (max - min) * (bottom - top);
    final plot = Rect.fromLTRB(12, top, size.width - 12, bottom);
    final safeTop = metric.warningMax == null
        ? top
        : y(metric.warningMax!).clamp(top, bottom).toDouble();
    final safeBottom = metric.warningMin == null
        ? bottom
        : y(metric.warningMin!).clamp(top, bottom).toDouble();
    if (metric.warningMin != null || metric.warningMax != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(plot.left, safeTop, plot.right, safeBottom),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFFE2F6F3),
      );
    }
    final grid = Paint()
      ..color = const Color(0xFFE5E8F0)
      ..strokeWidth = 1;
    for (final yy in [top, (top + bottom) / 2, bottom]) {
      for (var x = plot.left; x < plot.right; x += 8) {
        canvas.drawLine(
          Offset(x, yy),
          Offset(math.min(x + 3, plot.right), yy),
          grid,
        );
      }
    }
    for (final threshold in [
      metric.warningMin,
      metric.warningMax,
    ].whereType<double>()) {
      canvas.drawLine(
        Offset(plot.left, y(threshold)),
        Offset(plot.right, y(threshold)),
        Paint()
          ..color = const Color(0xFF0F9B8E)
          ..strokeWidth = 1,
      );
    }
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(_x(series, i, size.width), y(values[i])),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      final mid = (a.dx + b.dx) / 2;
      path.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    final area = Path.from(path)
      ..lineTo(points.last.dx, bottom)
      ..lineTo(points.first.dx, bottom)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x332184E9), Color(0x002184E9)],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2184E9)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    // Keep unsafe samples visible even when the bucket average is within range.
    for (var i = 0; i < series.length; i++) {
      final stat = series[i].values[field]!;
      final x = points[i].dx;
      final low = y(stat.min ?? stat.avg!);
      final high = y(stat.max ?? stat.avg!);
      final rangePaint = Paint()
        ..color = _outside(series[i], field, metric)
            ? AppColors.error
            : const Color(0xFF2184E9)
        ..strokeWidth = 2;
      canvas.drawLine(Offset(x, low), Offset(x, high), rangePaint);
      canvas.drawLine(Offset(x - 4, low), Offset(x + 4, low), rangePaint);
      canvas.drawLine(Offset(x - 4, high), Offset(x + 4, high), rangePaint);
    }
    final selected = points[selectedIndex];
    for (var yy = top; yy < bottom; yy += 7) {
      canvas.drawLine(
        Offset(selected.dx, yy),
        Offset(selected.dx, yy + 3),
        Paint()
          ..color = const Color(0xFF8ABAF0)
          ..strokeWidth = 1,
      );
    }
    for (var i = 0; i < points.length; i++) {
      final radius = i == selectedIndex ? 5.5 : 4.2;
      canvas.drawCircle(points[i], radius + 2, Paint()..color = Colors.white);
      canvas.drawCircle(
        points[i],
        radius,
        Paint()
          ..color = _outside(series[i], field, metric)
              ? AppColors.error
              : const Color(0xFF2184E9),
      );
    }
    String day(DateTime value) {
      final local = value;
      return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}';
    }

    void label(String text, double x, bool right) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.inkMuted,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(right ? x - painter.width : x, 156));
    }

    label(day(DateTime.parse(series.first.bucket)), plot.left, false);
    if (series.length > 1) {
      label(day(DateTime.parse(series.last.bucket)), plot.right, true);
    }
  }

  @override
  bool shouldRepaint(covariant WaterTrendPainter oldDelegate) =>
      oldDelegate.series != series ||
      oldDelegate.field != field ||
      oldDelegate.metric != metric ||
      oldDelegate.selectedIndex != selectedIndex;
}

bool _outside(
  WaterLogStatPoint point,
  String field,
  WaterMetricMetadata metric,
) {
  final stat = point.values[field]!;
  return (metric.warningMin != null &&
          (stat.min ?? stat.avg!) < metric.warningMin!) ||
      (metric.warningMax != null &&
          (stat.max ?? stat.avg!) > metric.warningMax!);
}
