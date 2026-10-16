import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/protocol_calendar.dart';
import 'protocol_fixtures.dart';

void main() {
  final production = ProtocolDetail.parse({
    ...detailJson(),
    'anchorDate': '2026-10-01',
  });
  test(
    'DOC changes at Vietnam midnight, not UTC midnight or device timezone',
    () {
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-10-15T16:59:59Z')),
        15,
      );
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-10-15T17:00:00Z')),
        16,
      );
      expect(
        protocolInitialDay(
          production,
          DateTime.parse('2026-10-16T02:00:00+07:00'),
        ),
        16,
      );
    },
  );
  test(
    'stocking day is DOC 1 and dates outside the protocol have no current badge',
    () {
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-09-30T17:00:00Z')),
        1,
      );
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-09-29T17:00:00Z')),
        isNull,
      );
      expect(
        protocolInitialDay(production, DateTime.parse('2026-09-29T17:00:00Z')),
        1,
      );
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-12-29T16:59:59Z')),
        90,
      );
      expect(
        protocolCurrentDoc(production, DateTime.parse('2026-12-29T17:00:00Z')),
        isNull,
      );
      expect(
        protocolInitialDay(production, DateTime.parse('2026-12-29T17:00:00Z')),
        90,
      );
    },
  );
  test(
    'treatment keeps its own relative-day navigation and no production DOC badge',
    () {
      final treatment = ProtocolDetail.parse(detailJson(type: 'TREATMENT'));
      expect(
        protocolCurrentDoc(treatment, DateTime.parse('2026-10-16T00:00Z')),
        isNull,
      );
      expect(
        protocolInitialDay(treatment, DateTime.parse('2026-10-16T00:00Z')),
        1,
      );
    },
  );
}
