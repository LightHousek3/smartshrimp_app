import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_chart.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_totals.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';
import '../../support/load_app_fonts.dart';
import 'owner_dashboard_fixtures.dart';

void main() {
  setUpAll(loadAppFonts);
  for (final unknown in [true, false]) {
    testWidgets(
      'N/B: finance flags ${unknown ? 'unknown' : 'partial'} revenue without reporting false zero',
      (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: RepaintBoundary(
                key: const Key('finance-preview'),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FinanceChart(
                        months: [
                          FinanceMonth(
                            month: '2026-11',
                            income: unknown ? null : 1000000,
                            cost: 400000,
                            unpricedHarvests: 1,
                          ),
                        ],
                      ),
                      FinanceTotalsView(
                        totals: FinanceTotals(
                          income: unknown ? null : 1000000,
                          cost: 400000,
                          profit: unknown ? null : 600000,
                          unpricedHarvests: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('finance-month-2026-11')));
        await tester.pumpAndSettle();
        expect(find.text('Chênh lệch sau vật tư'), findsOneWidget);
        expect(
          find.textContaining(
            unknown ? 'Thu Chưa xác định' : 'Thu 1,0 tr (chưa đầy đủ)',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('1 lần thu hoạch chưa có giá.'),
          findsOneWidget,
        );
        expect(
          find.text('Chưa có thu chi trong khoảng thời gian này.'),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('N: current case states have distinct single-case cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: RepaintBoundary(
            key: const Key('case-preview'),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final kind in [
                    DashboardAlertKind.caseOpen,
                    DashboardAlertKind.inTreatment,
                    DashboardAlertKind.monitoring,
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DashboardAlertCard(
                        overviewFixture.alerts.last.copyWith(kind: kind),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DashboardAlertCard), findsNWidgets(3));
    expect(find.textContaining('ca bệnh đang mở'), findsOneWidget);
    expect(find.textContaining('ca bệnh đang điều trị'), findsOneWidget);
    expect(find.textContaining('ca bệnh đang theo dõi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
