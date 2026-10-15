import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

/// The Figma chart is rendered from API samples, never from a static chart asset.
class WaterTrendChart extends StatelessWidget {
  const WaterTrendChart({
    required this.logs,
    required this.field,
    required this.metric,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });
  final List<WaterLog> logs;
  final String field;
  final WaterMetricMetadata metric;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      void select(double dx, {bool cycleOverlapping = false}) {
        if (logs.isEmpty) return;
        var nearest = 0;
        var distance = double.infinity;
        for (var i = 0; i < logs.length; i++) {
          final x = _x(logs, i, constraints.maxWidth);
          if ((x - dx).abs() < distance) {
            nearest = i;
            distance = (x - dx).abs();
          }
        }
        // Keep real time positions. Repeated taps visit all readings at one X.
        final nearestX = _x(logs, nearest, constraints.maxWidth);
        final overlapping = [
          for (var i = 0; i < logs.length; i++)
            if (_x(logs, i, constraints.maxWidth) == nearestX) i,
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
            'Biểu đồ ${waterLogParamLabel(field)}, ${logs.length} lần đo. Vuốt để chọn lần đo. Chạm lại vào điểm trùng thời gian để chọn lần đo khác.',
        onIncrease: selectedIndex < logs.length - 1
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
              painter: _TrendPainter(logs, field, metric, selectedIndex),
            ),
          ),
        ),
      );
    },
  );
}

double _x(List<WaterLog> logs, int index, double width) {
  final span = logs.last.recordedAt
      .difference(logs.first.recordedAt)
      .inMicroseconds;
  final ratio = span == 0
      ? (logs.length == 1 ? .5 : index / (logs.length - 1))
      : logs[index].recordedAt
                .difference(logs.first.recordedAt)
                .inMicroseconds /
            span;
  return 12 + ratio * math.max(0, width - 24);
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.logs, this.field, this.metric, this.selectedIndex);
  final List<WaterLog> logs;
  final String field;
  final WaterMetricMetadata metric;
  final int selectedIndex;
  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty || size.width <= 24) return;
    final values = logs.map((log) => log.valueOf(field)!).toList();
    var min = values.reduce(math.min);
    var max = values.reduce(math.max);
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
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(_x(logs, i, size.width), y(values[i])),
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
          ..color = logs[i].exceededParameters.contains(field)
              ? AppColors.error
              : const Color(0xFF2184E9),
      );
    }
    String day(DateTime value) {
      final local = value.toLocal();
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

    label(day(logs.first.recordedAt), plot.left, false);
    if (logs.length > 1) label(day(logs.last.recordedAt), plot.right, true);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.logs != logs ||
      oldDelegate.field != field ||
      oldDelegate.metric != metric ||
      oldDelegate.selectedIndex != selectedIndex;
}
