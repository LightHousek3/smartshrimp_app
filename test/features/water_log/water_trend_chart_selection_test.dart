import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_trend_chart.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_metric_trend.dart';

void main() {
  testWidgets(
    'selected duplicate reading is identified even when values are identical',
    (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      final logs = [
        for (var i = 0; i < 3; i++)
          WaterLog(
            id: 'log-$i',
            seasonId: 'season',
            recordedAt: DateTime(2026, 10, 15, i < 2 ? 6 : 7),
            createdAt: DateTime(2026),
            isVoided: false,
            exceededParameters: [],
            dissolvedOxygenMgL: 5,
          ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WaterMetricTrend(
              logs: logs,
              field: 'dissolvedOxygenMgL',
              metric: WaterLogMetadata.legacy(ShrimpType.whiteleg).metrics
                  .firstWhere((metric) => metric.field == 'dissolvedOxygenMgL'),
            ),
          ),
        ),
      );
      var chart = tester.getRect(find.byKey(const Key('water_trend_chart')));
      await tester.tapAt(Offset(chart.left + 12, chart.center.dy));
      await tester.pump();
      expect(
        find.text('Lần đo 1/2 cùng thời điểm · Chạm lại để đổi'),
        findsOneWidget,
      );
      chart = tester.getRect(find.byKey(const Key('water_trend_chart')));
      await tester.tapAt(Offset(chart.left + 12, chart.center.dy));
      await tester.pump();
      expect(
        find.text('Lần đo 2/2 cùng thời điểm · Chạm lại để đổi'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
  for (final sameValue in [false, true]) {
    testWidgets(
      'tap cycles overlapping time samples, same value=$sameValue; drag preserves selection',
      (tester) async {
        GoogleFonts.config.allowRuntimeFetching = false;
        var selected = 3;
        final logs = [
          for (var i = 0; i < 4; i++)
            WaterLog(
              id: 'log-$i',
              seasonId: 'season',
              recordedAt: DateTime(2026, 10, 15, i < 3 ? 6 : 7),
              createdAt: DateTime(2026),
              isVoided: false,
              exceededParameters: [],
              dissolvedOxygenMgL: sameValue ? 5 : 5.0 + i,
            ),
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  width: 320,
                  child: WaterTrendChart(
                    logs: logs,
                    field: 'dissolvedOxygenMgL',
                    metric: WaterLogMetadata.legacy(ShrimpType.whiteleg).metrics
                        .firstWhere(
                          (metric) => metric.field == 'dissolvedOxygenMgL',
                        ),
                    selectedIndex: selected,
                    onSelect: (index) => setState(() => selected = index),
                  ),
                ),
              ),
            ),
          ),
        );
        final origin = tester.getTopLeft(
          find.byKey(const Key('water_trend_chart')),
        );
        for (final expected in [0, 1, 2, 0, 1]) {
          await tester.tapAt(origin + const Offset(12, 80));
          await tester.pump();
          expect(selected, expected);
        }
        final drag = await tester.startGesture(origin + const Offset(12, 80));
        await drag.moveBy(const Offset(25, 0));
        await tester.pump();
        expect(selected, 1);
        await drag.moveBy(const Offset(-10, 0));
        await tester.pump();
        expect(selected, 1);
        await drag.up();
        await tester.pump();
        expect(selected, 1);
        await tester.tapAt(origin + const Offset(308, 80));
        await tester.pump();
        expect(selected, 3);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
