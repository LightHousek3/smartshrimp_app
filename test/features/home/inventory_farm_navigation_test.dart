import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import '../../support/farm_context_repository.dart';
import '../../support/load_app_fonts.dart';
import '../inventory/inventory_test_data.dart';
import 'owner_dashboard_fixtures.dart';

const _names = {'farm1': 'Trang trại Cửa Lấp', 'farm2': 'Trang trại Đông Hải'};

Future<ProviderContainer> _open(
  WidgetTester tester, {
  String route = '/',
  FarmContextRepository? farms,
}) async {
  await loadAppFonts();
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    retry: (count, error) => null,
    overrides: [
      authRepositoryProvider.overrideWithValue(const DashboardFixtureAuth()),
      farmRepositoryProvider.overrideWithValue(
        farms ?? FarmContextRepository(names: _names),
      ),
      inventoryRepositoryProvider.overrideWithValue(_InventoryRepository()),
      ownerDashboardRepositoryProvider.overrideWithValue(
        DashboardFixtureRepository(),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  container.read(appRouterProvider).go(route);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const SmartShrimpApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void _expectFarm(WidgetTester tester, String name) {
  final page = find.byType(InventoryPage);
  expect(page, findsOneWidget);
  expect(find.descendant(of: page, matching: find.text(name)), findsOneWidget);
  expect(find.text('Trang trại đang chọn'), findsNothing);
  expect(tester.takeException(), isNull);
}

void main() {
  for (final inventory in overviewFixture.inventories) {
    testWidgets(
      'warehouse shortcut shows ${inventory.farmName} through the real router',
      (tester) async {
        await _open(tester);
        final card = find.byWidgetPredicate(
          (widget) =>
              widget is DashboardInventoryCard &&
              widget.inventory.farmId == inventory.farmId,
        );
        await tester.scrollUntilVisible(
          card,
          400,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(card);
        await tester.pumpAndSettle();
        _expectFarm(tester, inventory.farmName);
      },
    );
  }

  testWidgets('low-stock shortcut carries its own farm name', (tester) async {
    await _open(tester);
    final card = find.byWidgetPredicate(
      (widget) =>
          widget is DashboardAlertCard &&
          widget.alert.kind == DashboardAlertKind.lowStock,
    );
    await tester.scrollUntilVisible(
      card,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
    _expectFarm(tester, _names['farm1']!);
  });

  testWidgets(
    'direct links resolve and switch names by farm ID without route extras',
    (tester) async {
      final farms = FarmContextRepository(names: _names);
      final container = await _open(
        tester,
        route: '/farms/farm1/inventory',
        farms: farms,
      );
      _expectFarm(tester, _names['farm1']!);
      container.read(appRouterProvider).go('/farms/farm2/inventory');
      await tester.pumpAndSettle();
      _expectFarm(tester, _names['farm2']!);
      expect(farms.requestedIds, containsAll(['farm1', 'farm2']));
    },
  );

  testWidgets('farm context failure has a retry instead of a misleading name', (
    tester,
  ) async {
    final farms = FarmContextRepository(names: _names)
      ..error = const ApiException(
        'Không thể tải tên trang trại.',
        statusCode: 500,
      );
    await _open(tester, route: '/farms/farm1/inventory', farms: farms);
    expect(find.byTooltip('Tải lại tên trang trại'), findsOneWidget);
    expect(find.text('Trang trại đang chọn'), findsNothing);
    farms.error = null;
    await tester.tap(find.byTooltip('Tải lại tên trang trại'));
    await tester.pumpAndSettle();
    _expectFarm(tester, _names['farm1']!);
  });
}

class _InventoryRepository implements InventoryRepository {
  @override
  Future<InventoryProductPage> getProducts({
    required String farmId,
    int page = 1,
    int limit = 100,
    String? search,
    InventoryProductCategory? category,
    bool lowStockOnly = false,
    InventoryArchiveStatus archiveStatus = InventoryArchiveStatus.active,
  }) async => InventoryProductPage(
    items: [inventoryTestProduct.copyWith(farmId: farmId)],
    page: 1,
    limit: limit,
    totalResults: 1,
    totalPages: 1,
    hasNextPage: false,
    summary: const InventorySummary(
      totalProducts: 1,
      lowStockCount: 1,
      inventoryValue: 2800000,
    ),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
