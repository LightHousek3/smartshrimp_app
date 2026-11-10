import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_metric_trend.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_trend_chart.dart';
import 'water_statistics_fixtures.dart';

class _Canvas implements Canvas {
  final lines = <({Offset a, Offset b, double width, Color color})>[];
  final circles = <({Offset point, double radius, Color color})>[];
  @override
  void drawLine(Offset p1, Offset p2, Paint paint) =>
      lines.add((a: p1, b: p2, width: paint.strokeWidth, color: paint.color));
  @override
  void drawCircle(Offset c, double radius, Paint paint) =>
      circles.add((point: c, radius: radius, color: paint.color));
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  testWidgets(
    'three daily averages have exact min-max whiskers and a threshold line',
    (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      final statistics = sampleStatistics();
      final metric = WaterLogMetadata.legacy(
        ShrimpType.whiteleg,
      ).metrics.firstWhere((m) => m.field == 'dissolvedOxygenMgL');
      final canvas = _Canvas();
      WaterTrendPainter(
        statistics.series,
        'dissolvedOxygenMgL',
        metric,
        2,
      ).paint(canvas, const Size(320, 176));
      // Global range is 3..9, padded by 18% on both sides.
      double y(double value) => 24 + (10.08 - value) / 8.16 * 121;
      final ranges = canvas.lines
          .where((l) => l.width == 2 && l.a.dx == l.b.dx)
          .toList();
      expect(ranges, hasLength(3));
      final points = canvas.circles
          .where((c) => c.color != Colors.white)
          .toList();
      expect(points, hasLength(3));
      for (var i = 0; i < 3; i++) {
        expect(ranges[i].a.dx, closeTo(12 + i * 148, .001));
        expect(ranges[i].a.dy, closeTo(y(3.0 + i), .001));
        expect(ranges[i].b.dy, closeTo(y(7.0 + i), .001));
        expect(points[i].point.dy, closeTo(y(5.0 + i), .001));
      }
      // Average 5 is safe, but the first bucket contains a reading at 3.
      expect(points.first.color.toARGB32(), AppColors.error.toARGB32());
      final threshold = canvas.lines.singleWhere(
        (l) => l.color.toARGB32() == 0xFF0F9B8E,
      );
      expect(threshold.a.dy, closeTo(y(4), .001));
      expect(threshold.b.dy, closeTo(y(4), .001));
    },
  );

  testWidgets('selection uses bucket average and warns from the full range', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WaterMetricTrend(
            statistics: sampleStatistics(),
            field: 'dissolvedOxygenMgL',
            metric: WaterLogMetadata.legacy(
              ShrimpType.whiteleg,
            ).metrics.firstWhere((m) => m.field == 'dissolvedOxygenMgL'),
          ),
        ),
      ),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('water_trend_selected_value')))
          .data,
      '7',
    );
    final chart = tester.getRect(find.byKey(const Key('water_trend_chart')));
    await tester.tapAt(Offset(chart.left + 12, chart.center.dy));
    await tester.pump();
    expect(
      tester
          .widget<Text>(find.byKey(const Key('water_trend_selected_value')))
          .data,
      '5',
    );
    expect(find.text('Ngoài ngưỡng'), findsOneWidget);
    expect(find.textContaining('01-01'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
