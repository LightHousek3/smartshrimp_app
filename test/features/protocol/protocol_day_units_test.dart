import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_day_audit.dart';
import 'protocol_fixtures.dart';
import 'protocol_pages_test.dart' as harness;

void main() {
  for (final (unit, stockLabel, actual, variance) in [
    ('G', 'gói', 25, '+25.0'),
    ('ML', 'chai', 15, '-25.0'),
    ('G', 'gói', 20, null),
  ]) {
    testWidgets('day audit displays $actual $unit and physical-unit variance', (
      tester,
    ) async {
      final row = dayRowJson(status: 'COMPLETED')
        ..addAll({
          'unit': unit,
          'doseUnit': unit,
          'plannedQuantity': 20,
          'actualQuantity': actual,
          'actualUnit': unit,
          'varianceReason': null,
        });
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(
            child: ProtocolDayAudit(
              protocolId: 'protocol-1',
              day: ProtocolDay.parse({
                'day': 31,
                'rows': [row],
              }),
            ),
          ),
        ),
      );
      expect(find.text('$actual ${unit.toLowerCase()}'), findsWidgets);
      expect(find.textContaining(stockLabel), findsNothing);
      if (variance == null) {
        expect(find.textContaining('Chênh lệch'), findsNothing);
      } else {
        expect(find.text('Chênh lệch $variance%'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
