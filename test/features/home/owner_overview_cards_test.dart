import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';

import 'owner_dashboard_fixtures.dart';
import '../../support/load_app_fonts.dart';

void main() {
  testWidgets('B: every alert stays within three rows on a narrow screen', (
    tester,
  ) async {
    await loadAppFonts();
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final longTitle = List.filled(
      8,
      'Tên nội dung cảnh báo rất dài',
    ).join(', ');
    final longFarm = List.filled(5, 'Trang trại có tên rất dài').join(' ');
    final longSeason = List.filled(5, 'Vụ nuôi mùa đông xuân').join(' ');
    for (final kind in DashboardAlertKind.values) {
      final alert = overviewFixture.alerts.first.copyWith(
        kind: kind,
        count: 999999999,
        preview: overviewFixture.alerts.first.preview.copyWith(
          title: longTitle,
          farmName: longFarm,
          seasonName: longSeason,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'PlusJakartaSans'),
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DashboardAlertCard(alert),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final rows = find.descendant(
        of: find.byType(DashboardAlertCard),
        matching: find.byType(Text),
      );
      expect(rows, findsNWidgets(3), reason: kind.name);
      for (var i = 0; i < 3; i++) {
        final paragraph = tester.renderObject<RenderParagraph>(rows.at(i));
        expect(paragraph.maxLines, 1, reason: '${kind.name}, row $i');
        expect(paragraph.overflow, TextOverflow.ellipsis);
        if (i > 0) expect(paragraph.didExceedMaxLines, isTrue);
      }
      expect(tester.takeException(), isNull, reason: kind.name);
    }
  });

  testWidgets('N: protocol and disease context omits the pond', (tester) async {
    for (final kind in [
      DashboardAlertKind.pendingProduction,
      DashboardAlertKind.pendingTreatment,
      DashboardAlertKind.inTreatment,
      DashboardAlertKind.monitoring,
      DashboardAlertKind.urgentTask,
    ]) {
      final alert = overviewFixture.alerts.first.copyWith(kind: kind);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DashboardAlertCard(alert))),
      );
      await tester.pumpAndSettle();
      final preview = alert.preview;
      final expectedContext = kind == DashboardAlertKind.urgentTask
          ? '${preview.farmName} · ${preview.pondName} · ${preview.seasonName}'
          : '${preview.farmName} · ${preview.seasonName}';
      expect(find.text(expectedContext), findsOneWidget, reason: kind.name);
    }
  });

  testWidgets(
    'N: low-stock caption truncates long product names without a tooltip',
    (tester) async {
      const names =
          'Vemedim LACTOZYME (tôm), Vôi nông nghiệp CaCO₃ — xử lý ao nuôi';
      final base = overviewFixture.alerts.firstWhere(
        (alert) => alert.kind == DashboardAlertKind.lowStock,
      );
      final alert = base.copyWith(
        count: 2,
        preview: base.preview.copyWith(title: names),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 280, child: DashboardAlertCard(alert)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('2 vật tư sắp hết'), findsOneWidget);
      expect(find.text(names), findsOneWidget);
      final caption = tester.renderObject<RenderParagraph>(find.text(names));
      expect(caption.didExceedMaxLines, isTrue);
      expect(find.byType(Tooltip), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final (farmId, farmName, count) in [
    ('dam-doi', 'Trang trại Đầm Dơi', 2),
    ('ca-mau', 'Trang trại Cà Mau', 1),
  ]) {
    testWidgets('N: farm-scoped low stock opens $farmName', (tester) async {
      final base = overviewFixture.alerts.firstWhere(
        (alert) => alert.kind == DashboardAlertKind.lowStock,
      );
      final alert = base.copyWith(
        count: count,
        preview: base.preview.copyWith(
          farmId: farmId,
          farmName: farmName,
          title: 'Khoáng gói',
          quantity: 100,
          minAlertQuantity: 500,
          unit: 'MG',
        ),
      );
      final router = _router(DashboardAlertCard(alert));
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(find.text('$count vật tư sắp hết'), findsOneWidget);
      expect(find.text(farmName), findsOneWidget);
      expect(find.text('Khoáng gói'), findsOneWidget);
      await tester.tap(find.byType(DashboardAlertCard));
      await tester.pumpAndSettle();
      expect(find.text('Kho $farmId'), findsOneWidget);
    });
  }

  testWidgets('N: alert backgrounds match the operational overview reference', (
    tester,
  ) async {
    await loadAppFonts();
    tester.view.physicalSize = const Size(402, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'PlusJakartaSans'),
        home: Scaffold(
          backgroundColor: const Color(0xFFD8EAF0),
          body: RepaintBoundary(
            key: const Key('alerts_preview'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final alert in overviewFixture.alerts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DashboardAlertCard(alert),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('alerts_preview')),
      matchesGoldenFile('goldens/owner_alert_icons.png'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('N: every alert category has a rounded icon background', (
    tester,
  ) async {
    final alerts = [
      ...overviewFixture.alerts,
      overviewFixture.alerts.first.copyWith(kind: DashboardAlertKind.unknown),
    ];
    for (final alert in alerts) {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DashboardAlertCard(alert))),
      );
      await tester.pumpAndSettle();
      final tile = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(AppSvgIcon).first,
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = tile.decoration! as BoxDecoration;
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(tile.constraints!.maxWidth, 36);
      expect(tile.constraints!.maxHeight, 36);
      expect(tester.takeException(), isNull);
    }
  });

  for (final inventory in overviewFixture.inventories) {
    testWidgets('N: inventory opens the warehouse of ${inventory.farmId}', (
      tester,
    ) async {
      final router = _router(DashboardInventoryCard(inventory));
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DashboardInventoryCard));
      await tester.pumpAndSettle();
      expect(find.text('Kho ${inventory.farmId}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('N: low-stock alert opens its farm warehouse directly', (
    tester,
  ) async {
    final alert = overviewFixture.alerts.firstWhere(
      (alert) => alert.kind == DashboardAlertKind.lowStock,
    );
    final router = _router(DashboardAlertCard(alert));
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DashboardAlertCard));
    await tester.pumpAndSettle();
    expect(find.text('Kho ${alert.preview.farmId}'), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

GoRouter _router(Widget card) => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => Scaffold(body: Center(child: card)),
    ),
    GoRoute(
      path: '/farms/:farmId/inventory',
      builder: (_, state) =>
          Scaffold(body: Text('Kho ${state.pathParameters['farmId']}')),
    ),
  ],
);
