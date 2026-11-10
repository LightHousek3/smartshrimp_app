import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/technician_overview_cards.dart';
import 'technician_dashboard_fixtures.dart';

void main() {
  test(
    'N: all seasons and their complete remaining-day card lists survive parsing',
    () {
      final result = TechnicianDashboard.parse(technicianDashboardJson());
      expect(result.operationGroups.length, 4);
      expect(result.operationGroups.first.items.length, 8);
      expect(result.tasks.single.dueAt, isNull);
      expect(result.seasons[1].biomassKg, isNull);
      expect(
        result.seasons.first.biomassRecordedAt,
        DateTime.utc(2026, 11, 7, 7),
      );
    },
  );

  test(
    'B: Vietnam date ignores the device timezone and normalizes explicit offsets',
    () {
      expect(vietnamDate(DateTime.parse('2026-11-08T17:00:00Z')), '2026-11-09');
      expect(technicianTime(DateTime.parse('2026-11-08T09:00:00Z')), '16:00');
    },
  );

  test(
    'B: display preserves tiny planned quantities rather than rounding a positive dose to zero',
    () {
      expect(technicianQuantity(.00001), '0,00001');
      expect(technicianQuantity(12.340000000), '12,34');
      expect(technicianQuantity(0), '0');
    },
  );

  test(
    'A: rejects missing required fields, malformed dates and tomorrow/overdue cards',
    () {
      for (final mutate in <void Function(Map<String, dynamic>)>[
        (json) => json.remove('summary'),
        (json) => json['date'] = '2026-02-30',
        (json) => json['summary']['openTaskCount'] = -1,
        (json) => json['summary']['activeSeasonCount'] = 0,
        (json) => json['operationGroups'][0]['items'][0]['scheduledAt'] =
            '2026-11-08T17:00:00Z',
        (json) => json['operationGroups'][0]['items'][0]['scheduledAt'] =
            '2026-11-08T07:59:59Z',
        (json) => json['operationGroups'][0]['items'][0]['plannedQuantity'] = 0,
        (json) =>
            json['operationGroups'][0]['items'][1]['id'] = 'operation-a-0',
        (json) => json['seasons'][0]['biomassRecordedAt'] = null,
      ]) {
        final json = technicianDashboardJson();
        mutate(json);
        expect(
          () => TechnicianDashboard.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );

  test(
    'A: unknown snapshot states stay unknown; unknown alerts never create a guessed navigation target',
    () {
      final json = technicianDashboardJson();
      json['seasons'][0]['biomassState'] = 'NEW_STATE';
      expect(
        TechnicianDashboard.parse(json).seasons.first.biomassState,
        BiomassSnapshotState.unknown,
      );
      final alert = TechnicianAlert.fromJson({
        'id': 'new:a',
        'kind': 'NEW_KIND',
        'seasonId': 'a',
        'seasonName': 'Vụ A',
        'pondName': 'Ao A',
        'farmName': 'Trại Cà Mau',
        'count': 1,
        'observedAt': '2026-11-08T08:00:00Z',
      });
      expect(alert.kind, TechnicianAlertKind.unknown);
      expect(technicianAlertLocation(alert), isNull);
    },
  );

  test('A: malformed water alerts are rejected', () {
    final dashboard = technicianDashboardJson();
    dashboard['alerts'] = [
      {
        'id': 'water:a',
        'kind': 'WATER',
        'seasonId': 'a',
        'seasonName': 'Vụ A',
        'pondName': 'Ao A',
        'farmName': 'Trại Cà Mau',
        'count': 1,
        'observedAt': '2026-11-08T08:00:00Z',
      },
    ];
    expect(
      () => TechnicianDashboard.parse(dashboard),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test(
    'N: every alert survives parsing without a preview limit or pagination',
    () {
      final json = technicianDashboardJson();
      json['alerts'] = [
        for (var i = 0; i < 7; i++)
          {
            'id': 'overdue:$i',
            'kind': 'OVERDUE_OPERATIONS',
            'seasonId': 'a',
            'seasonName': 'Vụ A',
            'pondName': 'Ao A',
            'farmName': 'Trại Cà Mau',
            'count': 1,
            'observedAt': '2026-11-08T07:00:00Z',
          },
      ];
      expect(TechnicianDashboard.parse(json).alerts, hasLength(7));
    },
  );
}
