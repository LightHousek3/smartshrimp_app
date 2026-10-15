import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';

void main() {
  for (final species in [ShrimpType.whiteleg, ShrimpType.blackTiger]) {
    testWidgets(
      'list card shows all warning bounds for $species at narrow width',
      (tester) async {
        GoogleFonts.config.allowRuntimeFetching = false;
        final metadata = WaterLogMetadata.legacy(species);
        // Custom server bounds prove the UI reads metadata, not pinned constants.
        final custom = metadata.copyWith(
          metrics: [
            for (final metric in metadata.metrics)
              metric.field == 'h2sMgL'
                  ? metric.copyWith(warningMin: 0, warningMax: 0.00001)
                  : metric,
          ],
        );
        final log = WaterLog(
          isVoided: false,
          exceededParameters: const [],
          id: 'log',
          seasonId: 'season',
          recordedAt: DateTime(2026, 10, 15),
          createdAt: DateTime(2026, 10, 15),
          ph: 8,
          h2sMgL: 0.00001,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 320,
                  child: WaterLogCard(log: log, metadata: custom),
                ),
              ),
            ),
          ),
        );
        for (final metric in custom.metrics) {
          for (final bound in [
            (name: 'min', label: 'Min', value: metric.warningMin),
            (name: 'max', label: 'Max', value: metric.warningMax),
          ]) {
            final text = tester.widget<Text>(
              find.byKey(Key('water_threshold_${metric.field}_${bound.name}')),
            );
            final value =
                bound.value?.toString().replaceFirst(RegExp(r'\.0$'), '') ??
                '—';
            expect(text.data, '${bound.label}: $value');
          }
        }
        expect(tester.takeException(), isNull);
        expect(find.byType(Tooltip), findsNothing);
        final value = find.text('0.00001');
        expect(value, findsOneWidget);
        expect(
          tester.renderObject<RenderParagraph>(value).didExceedMaxLines,
          isFalse,
        );
        expect(
          find.ancestor(of: value, matching: find.byType(FittedBox)),
          findsOneWidget,
        );
      },
    );
  }
}
