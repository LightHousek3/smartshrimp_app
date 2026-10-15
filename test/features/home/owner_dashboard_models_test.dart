import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'owner_dashboard_fixtures.dart';

void main() {
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
