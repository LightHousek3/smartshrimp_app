import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_exceedance.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_summary.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_threshold_summary.dart';

WaterLog _log(String field, double? value, {bool voided = false}) =>
    WaterLog.parse({
      'id': '$field-$value-$voided',
      'seasonId': 'season',
      'recordedAt': '2026-10-15T00:00:00Z',
      'createdAt': '2026-10-15T00:00:00Z',
      'isVoided': voided,
      field: value,
    });

void main() {
  test(
    'averages use only measured valid values, retaining zero and precision',
    () {
      final metric = WaterLogMetadata.legacy(
        ShrimpType.whiteleg,
      ).metrics.firstWhere((metric) => metric.field == 'h2sMgL');
      final summary = summarizeWaterMetric([
        _log('h2sMgL', 0),
        _log('h2sMgL', 0.00002),
        _log('h2sMgL', null),
        _log('h2sMgL', 1, voided: true),
      ], metric);
      expect(summary.measured, 2);
      expect(summary.average, closeTo(0.00001, 1e-12));
      expect(summary.within, 2);
      expect(summarizeWaterMetric([], metric).average, isNull);
    },
  );
  for (final species in [ShrimpType.whiteleg, ShrimpType.blackTiger]) {
    final metadata = WaterLogMetadata.legacy(species);
    for (final metric in metadata.metrics) {
      test(
        '${species.name} ${metric.field} counts above/below with inclusive bounds and skips missing/voided',
        () {
          final values = [
            if (metric.warningMin != null) metric.warningMin!,
            if (metric.warningMax != null) metric.warningMax!,
            if (metric.warningMin != null) metric.warningMin! - .001,
            if (metric.warningMax != null) metric.warningMax! + .001,
          ];
          final counts = summarizeWaterMetric([
            ...values.map((value) => _log(metric.field, value)),
            _log(metric.field, null),
            _log(metric.field, 999, voided: true),
          ], metric);
          expect(counts.measured, values.length);
          expect(counts.above, metric.warningMax == null ? 0 : 1);
          expect(counts.below, metric.warningMin == null ? 0 : 1);
          expect(counts.within, values.length ~/ 2);
          expect(counts.above + counts.below + counts.within, counts.measured);
        },
      );
    }
  }
  test(
    'uses server directions when available; unknown directions use metadata',
    () {
      final metric = WaterLogMetadata.legacy(
        ShrimpType.whiteleg,
      ).metrics.firstWhere((metric) => metric.field == 'dissolvedOxygenMgL');
      const detail = WaterLogExceedance(
        field: 'dissolvedOxygenMgL',
        direction: WaterLogWarningDirection.belowMin,
        value: 3.5,
        min: 4,
        max: null,
        unit: 'mg/L',
      );
      final raw = <String, dynamic>{
        'id': 'log',
        'seasonId': 'season',
        'recordedAt': '2026-10-15T00:00:00Z',
        'createdAt': '2026-10-15T00:00:00Z',
        'isVoided': false,
        'dissolvedOxygenMgL': 3.5,
        'exceededParameterDetails': [detail.toJson()],
      };
      final server = WaterLog.parse(raw);
      expect(
        summarizeWaterMetric([server], metric.copyWith(warningMin: 3)).below,
        1,
      );
      final unknown = WaterLog.parse({
        ...raw,
        'exceededParameterDetails': [
          detail.copyWith(direction: WaterLogWarningDirection.unknown).toJson(),
        ],
      });
      expect(summarizeWaterMetric([unknown], metric).below, 1);
    },
  );
  testWidgets(
    'eight average cards show control thresholds and separate rates at 320px',
    (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: WaterThresholdSummary(
                metadata: WaterLogMetadata.legacy(ShrimpType.whiteleg),
                logs: [
                  _log('ph', 7),
                  _log('ph', 9),
                  _log('ph', 7.5),
                  _log('ph', 8.5),
                  _log('ph', null),
                  _log('ph', 9, voided: true),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      List<String?> row(String field) => tester
          .widgetList<Text>(
            find.descendant(
              of: find.byKey(Key('water_summary_$field')),
              matching: find.byType(Text),
            ),
          )
          .map((widget) => widget.data)
          .toList();
      expect(row('ph'), [
        'pH',
        '8',
        'Ngưỡng: 7,5–8,5 pH',
        'Trong ngưỡng',
        '2/4',
        'Thấp hơn',
        '1 · 25%',
        'Cao hơn',
        '1 · 25%',
      ]);
      expect(
        find.text('5 nhật ký hợp lệ · 2/4 phép đo ngoài ngưỡng'),
        findsOneWidget,
      );
      for (final param in waterLogFormParams) {
        expect(find.byKey(Key('water_summary_${param.field}')), findsOneWidget);
      }
      expect(row('h2sMgL'), [
        'H2S (mg/L)',
        '—',
        'Ngưỡng: không quá 0,05 mg/L',
        'Trong ngưỡng',
        '—',
        'Thấp hơn',
        '—',
        'Cao hơn',
        '—',
      ]);
      expect(tester.takeException(), isNull);
      expect(
        tester
            .getTopLeft(
              find.byKey(const Key('water_summary_dissolvedOxygenMgL')),
            )
            .dy,
        lessThan(
          tester
              .getTopLeft(find.byKey(const Key('water_summary_temperatureC')))
              .dy,
        ),
      );
    },
  );
}
