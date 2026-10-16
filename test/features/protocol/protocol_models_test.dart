import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'protocol_fixtures.dart';

void main() {
  test(
    'N: parses production and treatment, nullable anchors and status history',
    () {
      expect(
        ProtocolDetail.parse(detailJson()).card.protocolType,
        ProtocolType.production,
      );
      final treatment = ProtocolDetail.parse(detailJson(type: 'TREATMENT'));
      expect(treatment.anchorDate, isNull);
      expect(treatment.history.last.fromStatus, ProtocolStatus.draft);
      expect(treatment.card.versionNo, 2);
    },
  );
  test('A: unknown type/status remain safe and disable decisions', () {
    final detail = ProtocolDetail.parse({
      ...detailJson(),
      'protocolType': 'FUTURE',
      'status': 'FUTURE',
    });
    expect(detail.card.status, ProtocolStatus.unknown);
    expect(detail.card.protocolType, ProtocolType.unknown);
    expect(detail.canReview, isFalse);
  });
  for (final field in [
    'id',
    'title',
    'seasonId',
    'authorName',
    'pondName',
    'farmName',
  ]) {
    test(
      'A: missing/empty required $field becomes InvalidResponseException',
      () {
        expect(
          () => ProtocolCardData.parse({...cardJson(), field: null}),
          throwsA(isA<InvalidResponseException>()),
        );
        expect(
          () => ProtocolCardData.parse({...cardJson(), field: ' '}),
          throwsA(isA<InvalidResponseException>()),
        );
      },
    );
  }
  test(
    'A/B: malformed dates, negative duration and out of range markers are rejected',
    () {
      for (final json in [
        {...detailJson(), 'updatedAt': 'bad'},
        {...detailJson(), 'durationDays': -1},
        {...detailJson(), 'anchorDate': '2026-02-30'},
        {
          ...detailJson(),
          'dayMarkers': [
            {'day': 91, 'completed': 1, 'planned': 0, 'cancelled': 0},
          ],
        },
      ]) {
        expect(
          () => ProtocolDetail.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  test('N: actual facts keep quantities and the adjustment reason', () {
    final day = ProtocolDay.parse({
      'day': 1,
      'date': '2026-06-28',
      'rows': [dayRowJson(status: 'COMPLETED')],
    });
    expect(day.rows.single.actualQuantity, 1.35);
    expect(day.rows.single.varianceReason, isNotEmpty);
  });
  test('A/B: invalid day/time/dose/actual quantity are rejected', () {
    for (final row in [
      {...dayRowJson(), 'time': '24:00'},
      {...dayRowJson(), 'doseValue': 0},
      {...dayRowJson(), 'actualQuantity': -1},
      {...dayRowJson(), 'productName': ''},
    ]) {
      expect(
        () => ProtocolDay.parse({
          'day': 1,
          'rows': [row],
        }),
        throwsA(isA<InvalidResponseException>()),
      );
    }
    expect(
      () => ProtocolDay.parse({'day': 0, 'rows': []}),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('N/A: pagination must have valid metadata', () {
    final meta = {
      'page': 1,
      'hasNextPage': false,
      'productionCount': 1,
      'treatmentCount': 2,
    };
    expect(ProtocolPage.parse([cardJson()], meta).items, hasLength(1));
    expect(
      () => ProtocolPage.parse([], null),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => ProtocolPage.parse([], {...meta, 'page': 0}),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => ProtocolPage.parse([{}], meta),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}
