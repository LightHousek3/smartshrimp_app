import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'owner_dashboard_fixtures.dart';

void main() {
  test(
    'N/A: case alerts preserve the case target and reject grouped or contextless episodes',
    () {
      Map<String, dynamic> wire() => {
        ...overviewFixture.toJson(),
        'summary': overviewFixture.summary.toJson(),
        'personnel': overviewFixture.personnel.toJson(),
        'financeFarms': overviewFixture.financeFarms
            .map((farm) => farm.toJson())
            .toList(),
        'seasons': [],
        'inventories': [],
        'alerts': [
          {
            'kind': 'CASE_OPEN',
            'count': 1,
            'preview': overviewFixture.alerts.last.preview.toJson(),
          },
        ],
      };
      expect(
        OwnerDashboard.parse(wire()).alerts.single.kind,
        DashboardAlertKind.caseOpen,
      );
      final grouped = wire();
      (grouped['alerts'] as List).first['count'] = 2;
      expect(
        () => OwnerDashboard.parse(grouped),
        throwsA(isA<InvalidResponseException>()),
      );
      final missing = wire();
      (missing['alerts'] as List).first['preview']['seasonId'] = null;
      expect(
        () => OwnerDashboard.parse(missing),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );

  test(
    'N/B: revenue unknown and partial data remain distinguishable from true zero',
    () {
      for (final (income, unpriced, profit) in [
        (null, 2, null),
        (100.0, 1, 60.0),
        (0.0, 0, -40.0),
      ]) {
        final finance = OwnerFinance.parse({
          'from': '2026-11-01',
          'to': '2026-11-19',
          'months': [
            {
              'month': '2026-11',
              'income': income,
              'cost': 40,
              'unpricedHarvests': unpriced,
            },
          ],
          'totals': {
            'income': income,
            'cost': 40,
            'profit': profit,
            'unpricedHarvests': unpriced,
          },
        });
        expect(finance.totals.income, income);
        expect(finance.totals.unpricedHarvests, unpriced);
        expect(finance.totals.profit, profit);
      }
    },
  );
  test('B: custom range accepts 60 calendar months and rejects 61', () {
    expect(
      FinanceFilter(
        period: FinancePeriod.custom,
        from: DateTime(2021, 11, 1),
        to: DateTime(2026, 10, 13),
      ).toQuery()['from'],
      '2021-11-01',
    );
    expect(
      () => FinanceFilter(
        period: FinancePeriod.custom,
        from: DateTime(2021, 10, 1),
        to: DateTime(2026, 10, 13),
      ).toQuery(),
      throwsA(isA<ApiException>()),
    );
  });
  test('N: overview parses generated JSON and unknown alerts safely', () {
    final json = overviewFixture.toJson();
    // Explicitly serialize nested values, as the network does.
    json['summary'] = overviewFixture.summary.toJson();
    json['personnel'] = overviewFixture.personnel.toJson();
    json['financeFarms'] = [
      for (final farm in overviewFixture.financeFarms) farm.toJson(),
    ];
    json['alerts'] = [
      for (final alert in overviewFixture.alerts)
        {...alert.toJson(), 'preview': alert.preview.toJson()},
    ];
    json['seasons'] = [
      for (final season in overviewFixture.seasons) season.toJson(),
    ];
    json['inventories'] = [
      for (final inventory in overviewFixture.inventories) inventory.toJson(),
    ];
    expect(OwnerDashboard.parse(json), overviewFixture);
    (json['alerts'] as List).first['kind'] = 'NEW_KIND';
    expect(
      OwnerDashboard.parse(json).alerts.first.kind,
      DashboardAlertKind.unknown,
    );
  });
  test(
    'N/A: protocol and disease previews accept omitted pondName but require navigation IDs',
    () {
      final json = {
        ...overviewFixture.toJson(),
        'summary': overviewFixture.summary.toJson(),
        'personnel': overviewFixture.personnel.toJson(),
        'financeFarms': [
          for (final farm in overviewFixture.financeFarms) farm.toJson(),
        ],
        'seasons': [
          for (final season in overviewFixture.seasons) season.toJson(),
        ],
        'inventories': [
          for (final inventory in overviewFixture.inventories)
            inventory.toJson(),
        ],
        'alerts': [
          for (final alert in overviewFixture.alerts.where(
            (alert) => [
              DashboardAlertKind.pendingProduction,
              DashboardAlertKind.pendingTreatment,
              DashboardAlertKind.inTreatment,
              DashboardAlertKind.monitoring,
            ].contains(alert.kind),
          ))
            {
              ...alert.toJson(),
              'preview': Map<String, dynamic>.from(alert.preview.toJson())
                ..remove('pondName'),
            },
        ],
      };
      final parsed = OwnerDashboard.parse(json);
      expect(parsed.alerts.length, 4);
      expect(
        parsed.alerts.every((alert) => alert.preview.pondName == null),
        isTrue,
      );
      expect(
        parsed.alerts.every((alert) => alert.preview.pondId != null),
        isTrue,
      );
      expect(
        parsed.seasons.first.pondName,
        overviewFixture.seasons.first.pondName,
      );
      final preview = ((json['alerts'] as List).first as Map)['preview'] as Map;
      preview.remove('pondId');
      expect(
        () => OwnerDashboard.parse(json),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );

  test(
    'A: financial farm choices reject empty identifiers and duplicated IDs',
    () {
      for (final choices in [
        [
          {'id': '', 'name': 'Farm'},
        ],
        [
          {'id': 'one', 'name': 'Farm'},
          {'id': 'one', 'name': 'Farm 2'},
        ],
      ]) {
        final json = overviewFixture.toJson();
        json['summary'] = overviewFixture.summary.toJson();
        json['personnel'] = overviewFixture.personnel.toJson();
        json['alerts'] = [];
        json['seasons'] = [];
        json['inventories'] = [];
        json['financeFarms'] = choices;
        expect(
          () => OwnerDashboard.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  for (final change in <String, dynamic>{
    'date': '2026-02-30',
    'summary': {'farms': -1, 'ponds': 0, 'activeSeasons': 0},
    'seasons': null,
    'personnel': null,
  }.entries) {
    test(
      'A: invalid overview ${change.key} maps to InvalidResponseException',
      () {
        final json = overviewFixture.toJson();
        json['summary'] = overviewFixture.summary.toJson();
        json['personnel'] = overviewFixture.personnel.toJson();
        json['financeFarms'] = [
          for (final farm in overviewFixture.financeFarms) farm.toJson(),
        ];
        json['alerts'] = [];
        json['seasons'] = [];
        json['inventories'] = [];
        json[change.key] = change.value;
        expect(
          () => OwnerDashboard.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      },
    );
  }
  test('N/B: finance parsing accepts zero income and negative profit', () {
    final json = {
      'from': '2026-10-01',
      'to': '2026-10-13',
      'months': [
        {'month': '2026-10', 'income': 0, 'cost': 10},
      ],
      'totals': {'income': 0, 'cost': 10, 'profit': -10},
    };
    expect(OwnerFinance.parse(json).totals.profit, -10);
  });
  test(
    'A: finance rejects inconsistent totals, negative values and duplicated months',
    () {
      for (final json in [
        {
          'from': '2026-10-01',
          'to': '2026-10-13',
          'months': [
            {'month': '2026-10', 'income': -1, 'cost': 0},
          ],
          'totals': {'income': 0, 'cost': 0, 'profit': 0},
        },
        {
          'from': '2026-10-01',
          'to': '2026-10-13',
          'months': [
            {'month': '2026-10', 'income': 1, 'cost': 0},
          ],
          'totals': {'income': 1, 'cost': 0, 'profit': 2},
        },
        {
          'from': '2026-10-01',
          'to': '2026-10-13',
          'months': [
            for (var i = 0; i < 2; i++)
              {'month': '2026-10', 'income': 1, 'cost': 0},
          ],
          'totals': {'income': 2, 'cost': 0, 'profit': 2},
        },
      ]) {
        expect(
          () => OwnerFinance.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  test('N: default and custom filter send only fields required by the API', () {
    expect(const FinanceFilter().toQuery(), {'period': 'THIS_MONTH'});
    expect(
      FinanceFilter(
        farmId: 'farm',
        period: FinancePeriod.custom,
        from: DateTime(2026, 7, 1),
        to: DateTime(2026, 8, 9),
      ).toQuery(),
      {
        'farmId': 'farm',
        'period': 'CUSTOM',
        'from': '2026-07-01',
        'to': '2026-08-09',
      },
    );
  });
  test('A: incomplete/reversed custom range fails before networking', () {
    expect(
      () => const FinanceFilter(period: FinancePeriod.custom).toQuery(),
      throwsA(isA<ApiException>()),
    );
    expect(
      () => FinanceFilter(
        period: FinancePeriod.custom,
        from: DateTime(2026, 8, 10),
        to: DateTime(2026, 8, 9),
      ).toQuery(),
      throwsA(isA<ApiException>()),
    );
  });
}
