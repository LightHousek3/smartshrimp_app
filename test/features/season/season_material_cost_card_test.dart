import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_material_cost_card.dart';

void main() {
  Widget app(SeasonMaterialCosts? costs, {double width = 390}) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: SeasonMaterialCostCard(costs: costs),
        ),
      ),
    ),
  );

  testWidgets(
    'renders actual costs and proportions, and updates after refresh',
    (tester) async {
      await tester.pumpWidget(app(_costs()));
      expect(find.text('2.000.000 ₫'), findsOneWidget);
      expect(find.text('1.500.000 ₫'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('10%'), findsOneWidget);
      expect(find.text('15%'), findsOneWidget);
      expect(
        tester
            .widgetList<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .map((w) => w.value),
        [0.75, 0.1, 0.15],
      );
      await tester.pumpWidget(
        app(_costs().copyWith(feed: '3500000.00', total: '4000000.00')),
      );
      expect(find.text('4.000.000 ₫'), findsOneWidget);
      expect(find.text('2.000.000 ₫'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('distinguishes zero spending from an unavailable summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        _costs().copyWith(
          feed: '0.00',
          medicine: '0.00',
          environment: '0.00',
          total: '0.00',
        ),
      ),
    );
    expect(find.text('0 ₫'), findsNWidgets(4));
    expect(find.text('0%'), findsNWidgets(3));
    await tester.pumpWidget(app(null));
    expect(find.text('Chưa có dữ liệu chi phí'), findsOneWidget);
    expect(find.text('0 ₫'), findsNothing);
  });

  testWidgets('handles one category, large amounts and narrow layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        _costs().copyWith(
          feed: '9007199254740993.01',
          medicine: '0.00',
          environment: '0.00',
          total: '9007199254740993.01',
        ),
        width: 280,
      ),
    );
    expect(find.text('9.007.199.254.740.993,01 ₫'), findsNWidgets(2));
    expect(find.text('100%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

SeasonMaterialCosts _costs() => SeasonMaterialCosts.fromJson({
  'currency': 'VND',
  'feed': '1500000.00',
  'medicine': '200000.00',
  'environment': '300000.00',
  'total': '2000000.00',
});
