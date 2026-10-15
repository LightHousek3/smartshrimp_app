import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_exceedance.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';

Map<String, dynamic> _fixture() =>
    jsonDecode(
          File(
            'test/fixtures/water-warning-directions.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;

void main() {
  test('parses the shared BE wire fixture with high and low directions', () {
    final log = WaterLog.parse(_fixture());
    expect(log.exceededParameters, ['ph', 'dissolvedOxygenMgL']);
    expect(log.exceededParameterDetails, hasLength(2));
    final high = log.exceededParameterDetails.first;
    expect(high.direction, WaterLogWarningDirection.aboveMax);
    expect(high.value, 9);
    expect(high.min, 7.5);
    expect(high.max, 8.5);
    final low = log.exceededParameterDetails.last;
    expect(low.direction, WaterLogWarningDirection.belowMin);
    expect(low.min, 4);
    expect(low.max, isNull);
    expect(low.unit, 'mg/L');
  });

  test('legacy consumer fields are unchanged by additive response data', () {
    final current = _fixture();
    final legacy = Map<String, dynamic>.of(current)
      ..remove('exceededParameterDetails');
    final newLog = WaterLog.parse(current);
    final oldLog = WaterLog.parse(legacy);
    expect(newLog.exceededParameters, oldLog.exceededParameters);
    expect(newLog.ph, oldLog.ph);
    expect(newLog.dissolvedOxygenMgL, oldLog.dissolvedOxygenMgL);
    expect(oldLog.exceededParameterDetails, isEmpty);
    expect(
      WaterLog.parse({
        ...legacy,
        'exceededParameterDetails': null,
      }).exceededParameterDetails,
      isEmpty,
    );
  });

  for (final invalid in <Object?>[
    'invalid',
    [null],
    [{}],
    [
      {
        'field': 'ph',
        'direction': 'above_max',
        'value': 9,
        'max': 8.5,
        'unit': 'pH',
      },
    ],
    [
      {
        'field': 'ph',
        'direction': 'above_max',
        'value': 8.5,
        'min': 7.5,
        'max': 8.5,
        'unit': 'pH',
      },
    ],
    [
      {
        'field': 'ph',
        'direction': 'below_min',
        'value': 7,
        'min': null,
        'max': 8.5,
        'unit': 'pH',
      },
    ],
  ]) {
    test('rejects malformed warning details $invalid', () {
      expect(
        () => WaterLog.parse({
          ..._fixture(),
          'exceededParameterDetails': invalid,
        }),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }

  final scenarios =
      <
        ({
          String name,
          String expected,
          void Function(Map<String, dynamic>) edit,
        })
      >[
        (
          name: 'mixed high and low',
          expected: '2 chỉ số bất thường',
          edit: (_) {},
        ),
        (
          name: 'legacy response',
          expected: '2 chỉ số bất thường',
          edit: (raw) => raw.remove('exceededParameterDetails'),
        ),
        (
          name: 'unknown direction',
          expected: '2 chỉ số bất thường',
          edit: (raw) =>
              (raw['exceededParameterDetails'] as List).first['direction'] =
                  'future_direction',
        ),
        (
          name: 'missing detail for a field',
          expected: '2 chỉ số bất thường',
          edit: (raw) => (raw['exceededParameterDetails'] as List).removeAt(0),
        ),
        (
          name: 'voided log',
          expected: 'Đã hủy hiệu lực',
          edit: (raw) => raw['isVoided'] = true,
        ),
        (
          name: 'no warnings',
          expected: 'Trong ngưỡng',
          edit: (raw) {
            raw['exceededParameters'] = <String>[];
            raw['exceededParameterDetails'] = <Object>[];
          },
        ),
      ];
  for (final scenario in scenarios) {
    testWidgets('badge handles ${scenario.name}', (tester) async {
      final raw = _fixture();
      scenario.edit(raw);
      final log = WaterLog.parse(raw);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WaterLogStatusBadge(log: log)),
        ),
      );
      expect(find.text(scenario.expected), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
