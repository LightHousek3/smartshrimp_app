import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/owner_water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

void main() {
  test('display retains five decimal places and trims trailing zeros', () {
    expect(formatWaterValue(null), '—');
    expect(formatWaterValue(0), '0');
    expect(formatWaterValue(28), '28');
    expect(formatWaterValue(29.4), '29,4');
    expect(formatWaterValue(0.00001), '0,00001');
    expect(formatWaterValue(0.05001), '0,05001');
    expect(formatWaterValue(0.12345), '0,12345');
  });

  for (final (width, textScale) in [(400.0, 1.0), (320.0, 1.5)]) {
    testWidgets('both cards center the right-aligned status at ${width}px', (
      tester,
    ) async {
      final recordedAt = DateTime(2026, 11, 26, 17, 50);
      final log = WaterLog(
        id: 'log',
        seasonId: 'season',
        recordedAt: recordedAt,
        createdAt: recordedAt,
        recordedByName: 'Pham Quoc Tu',
        isVoided: false,
        exceededParameters: const [],
        ph: 8,
      );
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final day = formatWaterDay(recordedAt);
      for (final (card, timeLabel, secondLine) in [
        (WaterLogCard(log: log), '17:50', day),
        (OwnerWaterLogCard(log: log), '17:50 · $day', log.recordedByName!),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(textScale)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: card,
                  ),
                ),
              ),
            ),
          ),
        );

        final status = find.byType(WaterLogStatusBadge);
        final detailsTop = tester.getTopLeft(find.text(timeLabel)).dy;
        final detailsBottom = tester.getBottomLeft(find.text(secondLine)).dy;
        expect(find.text('Trong ngưỡng'), findsOneWidget);
        expect(
          tester.getCenter(status).dy,
          closeTo((detailsTop + detailsBottom) / 2, 0.001),
        );
        expect(
          tester.getTopRight(status).dx,
          tester.getTopRight(find.byType(WaterParamTiles)).dx,
        );
        expect(tester.takeException(), isNull);
      }
    });
  }

  for (final sample in [
    (ph: 7.0, oxygen: 3.0, fields: ['ph', 'dissolvedOxygenMgL']),
    (ph: 9.0, oxygen: 5.0, fields: ['ph']),
    (ph: 9.0, oxygen: 3.0, fields: ['ph', 'dissolvedOxygenMgL']),
    (ph: 8.0, oxygen: 5.0, fields: <String>[]),
    (
      ph: 9.0,
      oxygen: 3.0,
      fields: waterLogFormParams.map((param) => param.field).toList(),
    ),
  ]) {
    for (final voided in [false, true]) {
      testWidgets(
        'badge for pH ${sample.ph}, DO ${sample.oxygen}, voided=$voided',
        (tester) async {
          final log = WaterLog(
            id: 'log',
            seasonId: 'season',
            recordedAt: DateTime(2026, 10, 14),
            createdAt: DateTime(2026, 10, 14),
            isVoided: voided,
            exceededParameters: sample.fields,
            ph: sample.ph,
            dissolvedOxygenMgL: sample.oxygen,
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: WaterLogStatusBadge(log: log)),
            ),
          );
          final expected = voided
              ? 'Đã hủy hiệu lực'
              : sample.fields.isEmpty
              ? 'Trong ngưỡng'
              : '${sample.fields.length} chỉ số bất thường';
          expect(find.text(expected), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
