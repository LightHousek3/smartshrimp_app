import 'dart:async';
import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/owner_dashboard_repository.dart';
import 'package:smartshrimp_app/features/home/presentation/pages/home_page.dart';
import 'package:smartshrimp_app/features/home/presentation/pages/owner_home_page.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_panel.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_chart.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'owner_dashboard_fixtures.dart';

Future<ProviderContainer> open(
  WidgetTester tester,
  Widget page, {
  OwnerDashboardRepository? repository,
  FarmRepository? farmRepository,
  AccountRole role = AccountRole.farmOwner,
  Size size = const Size(402, 874),
  bool custom = false,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  for (final (family, file) in [
    ('Sora', 'Sora-Bold.ttf'),
    ('Sora_700', 'Sora-Bold.ttf'),
    ('Sora_800', 'Sora-ExtraBold.ttf'),
    ('PlusJakartaSans', 'PlusJakartaSans-Regular.ttf'),
    ('PlusJakartaSans_regular', 'PlusJakartaSans-Regular.ttf'),
    ('PlusJakartaSans_500', 'PlusJakartaSans-Medium.ttf'),
    ('PlusJakartaSans_600', 'PlusJakartaSans-SemiBold.ttf'),
    ('PlusJakartaSans_700', 'PlusJakartaSans-Bold.ttf'),
  ]) {
    await (FontLoader(
      family,
    )..addFont(rootBundle.load('assets/fonts/google_fonts/$file'))).load();
  }
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        DashboardFixtureAuth(role: role),
      ),
      ownerDashboardRepositoryProvider.overrideWithValue(
        repository ?? DashboardFixtureRepository(),
      ),
      if (farmRepository != null)
        farmRepositoryProvider.overrideWithValue(farmRepository),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  if (custom) {
    final subscription = container.listen(financeFilterProvider, (_, _) {});
    addTearDown(subscription.close);
    container
        .read(financeFilterProvider.notifier)
        .selectPeriod(FinancePeriod.custom, DateTime(2026, 10, 13));
    container
        .read(financeFilterProvider.notifier)
        .selectDates(DateTime(2026, 7, 1), DateTime(2026, 9, 8));
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const Key('preview'),
          child: Scaffold(backgroundColor: AppColors.backgroundTop, body: page),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pumpAndSettle();
  await GoogleFonts.pendingFonts();
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets(
    'N: scrolling and fullscreen reuse the dashboard and finance responses',
    (tester) async {
      final repository = _MutableDashboardRepository();
      final container = await open(
        tester,
        const OwnerHomePage(),
        repository: repository,
      );
      expect(repository.overviewCalls, 1);
      expect(repository.calls, [const FinanceFilter()]);
      for (var round = 0; round < 3; round++) {
        await tester.scrollUntilVisible(
          find.text('Toàn màn hình'),
          300,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        expect(find.byType(FinancePanel), findsOneWidget);
        final scroll = tester.state<ScrollableState>(
          find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        scroll.position.jumpTo(0);
        await tester.pumpAndSettle();
        expect(find.byType(FinancePanel), findsNothing);
      }
      await tester.scrollUntilVisible(
        find.text('Toàn màn hình'),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toàn màn hình'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(repository.overviewCalls, 1);
      expect(repository.calls, [const FinanceFilter()]);
      container
          .read(authControllerProvider.notifier)
          .updateAccountDetails(
            fullName: 'Owner Mới',
            phone: null,
            avatarUrl: null,
          );
      await tester.pumpAndSettle();
      expect(repository.overviewCalls, 1);
      expect(repository.calls, [const FinanceFilter()]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('N: an explicit refresh reloads dashboard and finance once', (
    tester,
  ) async {
    final repository = _MutableDashboardRepository();
    await open(tester, const OwnerHomePage(), repository: repository);
    expect(repository.overviewCalls, 1);
    expect(repository.calls.length, 1);
    await tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pumpAndSettle();
    expect(repository.overviewCalls, 2);
    expect(repository.calls.length, 2);
    expect(tester.takeException(), isNull);
  });

  for (final fullscreen in [false, true]) {
    testWidgets(
      'B: long farm names keep their font and wrap in the menu (fullscreen=$fullscreen)',
      (tester) async {
        const longName =
            'Trang trại Bảo Cần Thơ – Khu nuôi tôm công nghệ cao tại huyện Đầm Dơi, tỉnh Cà Mau';
        const farms = [DashboardFarm(id: 'long', name: longName)];
        final container = await open(
          tester,
          fullscreen
              ? FinanceFullscreen(farms: farms, today: DateTime(2026, 10, 13))
              : FinancePanel(farms: farms, today: DateTime(2026, 10, 13)),
          size: fullscreen ? const Size(780, 390) : const Size(320, 650),
        );
        await tester.tap(
          find.byKey(const ValueKey('finance-filter-Trang trại')),
        );
        await tester.pumpAndSettle();
        final menuLabel = find.text(longName).last;
        final menuText = tester.widget<Text>(menuLabel);
        expect(menuText.maxLines, isNull);
        expect(menuText.overflow, isNot(TextOverflow.ellipsis));
        expect(tester.getSize(menuLabel).height, greaterThan(24));
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/finance_long_farm_menu_${fullscreen ? 'fullscreen' : 'normal'}.png',
          ),
        );
        await tester.tap(menuLabel);
        await tester.pumpAndSettle();
        expect(container.read(financeFilterProvider).farmId, 'long');
        final selected = find.text(longName);
        final selectedText = tester.widget<Text>(selected);
        expect(selectedText.maxLines, 1);
        expect(selectedText.overflow, TextOverflow.ellipsis);
        expect(
          DefaultTextStyle.of(tester.element(selected)).style.fontSize,
          12,
        );
        expect(
          find.ancestor(of: selected, matching: find.byType(FittedBox)),
          findsNothing,
        );
        expect(find.byTooltip(longName), findsOneWidget);
        await expectLater(
          find.byKey(const Key('preview')),
          matchesGoldenFile(
            'goldens/finance_long_farm_selected_${fullscreen ? 'fullscreen' : 'normal'}.png',
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'N/A: successful farm deletion refreshes home and resets only the removed farm filter',
    (tester) async {
      final repository = _MutableDashboardRepository();
      final container = await open(
        tester,
        const OwnerHomePage(),
        repository: repository,
        farmRepository: repository,
        custom: true,
      );
      expect(repository.overviewCalls, 1);
      container.read(financeFilterProvider.notifier).selectFarm('farm1');
      await tester.pumpAndSettle();
      final mutation = container.read(farmMutationControllerProvider.notifier);
      repository.failDelete = true;
      await expectLater(
        mutation.deleteFarm('farm1'),
        throwsA(isA<ApiException>()),
      );
      await tester.pumpAndSettle();
      expect(repository.overviewCalls, 1);
      expect(container.read(financeFilterProvider).farmId, 'farm1');
      repository.failDelete = false;
      await mutation.deleteFarm('farm1');
      await tester.pumpAndSettle();
      expect(repository.overviewCalls, 2);
      final dashboard = container.read(ownerDashboardProvider).requireValue;
      expect(
        dashboard.inventories.any((farm) => farm.farmId == 'farm1'),
        isFalse,
      );
      expect(dashboard.financeFarms.any((farm) => farm.id == 'farm1'), isFalse);
      final filter = container.read(financeFilterProvider);
      expect(filter.farmId, isNull);
      expect(filter.period, FinancePeriod.custom);
      expect(filter.from, DateTime(2026, 7, 1));
      expect(filter.to, DateTime(2026, 9, 8));
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('finance-filter-Trang trại')),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Trang trại Cửa Lấp'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('finance-filter-Trang trại')));
      await tester.pumpAndSettle();
      expect(find.text('Trang trại Cửa Lấp'), findsNothing);
      expect(find.text('Trang trại Đông Hải'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N: refresh retains an inactive farm selection for historical finances',
    (tester) async {
      final repository = _MutableDashboardRepository();
      final container = await open(
        tester,
        const OwnerHomePage(),
        repository: repository,
        custom: true,
      );
      container.read(financeFilterProvider.notifier).selectFarm('farm1');
      repository.inactive = true;
      container.invalidate(ownerDashboardProvider);
      await tester.pumpAndSettle();
      final dashboard = container.read(ownerDashboardProvider).requireValue;
      expect(
        dashboard.inventories.any((farm) => farm.farmId == 'farm1'),
        isFalse,
      );
      expect(dashboard.financeFarms.any((farm) => farm.id == 'farm1'), isTrue);
      expect(container.read(financeFilterProvider).farmId, 'farm1');
      expect(
        container.read(financeFilterProvider).period,
        FinancePeriod.custom,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final fullscreen in [false, true]) {
    testWidgets(
      'N: hover detail shares the legend row (fullscreen=$fullscreen)',
      (tester) async {
        final page = fullscreen
            ? FinanceFullscreen(
                farms: overviewFixture.financeFarms,
                today: DateTime(2026, 10, 13),
              )
            : FinancePanel(
                farms: overviewFixture.financeFarms,
                today: DateTime(2026, 10, 13),
              );
        await open(
          tester,
          page,
          size: fullscreen ? const Size(780, 390) : const Size(320, 650),
        );
        final month = find.byKey(const ValueKey('finance-month-2026-10'));
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(month));
        await tester.pumpAndSettle();
        final detail = find.byKey(const Key('finance-month-detail'));
        final legend = find.byType(FinanceLegend);
        expect(detail, findsOneWidget);
        expect(
          find.text('Tháng 10/2026 · Thu 117,8 tr · Chi 52,7 tr'),
          findsOneWidget,
        );
        expect(
          tester.getCenter(detail).dy,
          closeTo(tester.getCenter(legend).dy, 1),
        );
        expect(
          tester.getTopLeft(detail).dx,
          greaterThan(tester.getTopRight(legend).dx),
        );
        expect(
          tester.getBottomLeft(detail).dy,
          lessThan(tester.getTopLeft(month).dy),
        );
        await expectLater(
          find.byKey(const Key('preview')),
          matchesGoldenFile(
            'goldens/finance_hover_${fullscreen ? 'fullscreen' : 'normal'}.png',
          ),
        );
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();
        expect(detail, findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final size in [const Size(780, 390), const Size(390, 780)]) {
    testWidgets(
      'N: fullscreen menus and both date pickers rotate with the page $size',
      (tester) async {
        final repository = DashboardFixtureRepository();
        final container = await open(
          tester,
          FinanceFullscreen(
            farms: overviewFixture.financeFarms,
            today: DateTime(2026, 10, 13),
          ),
          size: size,
          repository: repository,
          custom: true,
        );
        final rotated = size.height > size.width;
        await tester.tap(
          find.byKey(const ValueKey('finance-filter-Trang trại')),
        );
        await tester.pumpAndSettle();
        _expectLandscapeOverlay(
          tester,
          find.text('Trang trại Đông Hải').last,
          rotated: rotated,
        );
        await tester.tap(find.text('Trang trại Đông Hải').last);
        await tester.pumpAndSettle();
        expect(container.read(financeFilterProvider).farmId, 'farm2');

        await tester.tap(
          find.byKey(const ValueKey('finance-filter-Khoảng thời gian')),
        );
        await tester.pumpAndSettle();
        _expectLandscapeOverlay(
          tester,
          find.text('Tháng trước').last,
          rotated: rotated,
        );
        await expectLater(
          find.byKey(const Key('preview')),
          matchesGoldenFile('goldens/finance_menu_${size.width.toInt()}.png'),
        );
        await tester.tap(find.text('Tùy chỉnh…').last);
        await tester.pumpAndSettle();

        for (final (field, day) in [('from', '2'), ('to', '7')]) {
          await tester.tap(find.byKey(Key('finance-date-$field')));
          await tester.pumpAndSettle();
          expect(find.byType(DatePickerDialog), findsOneWidget);
          _expectLandscapeOverlay(
            tester,
            find.byType(DatePickerDialog),
            rotated: rotated,
          );
          await expectLater(
            find.byKey(const Key('preview')),
            matchesGoldenFile(
              'goldens/finance_date_${field}_${size.width.toInt()}.png',
            ),
          );
          await tester.tap(find.text(day).first);
          await tester.tap(find.text('Chọn'));
          await tester.pumpAndSettle();
        }
        expect(
          container.read(financeFilterProvider).from,
          DateTime(2026, 7, 2),
        );
        expect(container.read(financeFilterProvider).to, DateTime(2026, 9, 7));
        expect(repository.calls.last.farmId, 'farm2');
        await tester.tap(find.byTooltip('Cách tính Tổng chi'));
        await tester.pumpAndSettle();
        _expectLandscapeOverlay(
          tester,
          find.byType(AlertDialog),
          rotated: rotated,
        );
        await tester.tap(find.text('Đã hiểu'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('N: fullscreen keeps an open date picker after device rotation', (
    tester,
  ) async {
    await open(
      tester,
      FinanceFullscreen(
        farms: overviewFixture.financeFarms,
        today: DateTime(2026, 10, 13),
      ),
      size: const Size(390, 780),
      custom: true,
    );
    await tester.tap(find.byKey(const Key('finance-date-from')));
    await tester.pumpAndSettle();
    _expectLandscapeOverlay(
      tester,
      find.byType(DatePickerDialog),
      rotated: true,
    );
    tester.view.physicalSize = const Size(780, 390);
    await tester.pumpAndSettle();
    _expectLandscapeOverlay(
      tester,
      find.byType(DatePickerDialog),
      rotated: false,
    );
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(find.byType(FinanceFullscreen), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'N: fullscreen system back dismisses a popup before closing the page',
    (tester) async {
      await open(
        tester,
        SingleChildScrollView(
          child: FinancePanel(
            farms: overviewFixture.financeFarms,
            today: DateTime(2026, 10, 13),
          ),
        ),
      );
      await tester.tap(find.text('Toàn màn hình'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('finance-filter-Khoảng thời gian')).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Tháng trước'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Tháng trước'), findsNothing);
      expect(find.byType(FinanceFullscreen), findsOneWidget);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.byType(FinanceFullscreen), findsNothing);
      expect(find.text('Toàn màn hình'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('N: empty alerts use the centered dashed empty-state design', (
    tester,
  ) async {
    await open(
      tester,
      const OwnerHomePage(),
      repository: _EmptyAlertsRepository(),
      size: const Size(320, 700),
    );
    final empty = find.byKey(const Key('owner-alerts-empty'));
    expect(find.text('Không có cảnh báo quan trọng'), findsOneWidget);
    expect(
      find.text('Các cảnh báo cần chú ý sẽ xuất hiện ở đây.'),
      findsOneWidget,
    );
    expect(
      find.descendant(of: empty, matching: find.byType(CustomPaint)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: empty, matching: find.byType(DashboardCard)),
      findsNothing,
    );
    expect(tester.getSize(empty).height, 202);
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('goldens/owner_alerts_empty.png'),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'N: retained farm is selectable for history without an operating inventory card',
    (tester) async {
      final repository = DashboardFixtureRepository();
      await open(
        tester,
        SingleChildScrollView(
          child: FinancePanel(
            farms: [
              ...overviewFixture.financeFarms,
              const DashboardFarm(
                id: 'historical',
                name: 'Trang trại ngừng hoạt động',
              ),
            ],
            today: DateTime(2026, 10, 13),
          ),
        ),
        repository: repository,
      );
      await tester.tap(find.byKey(const ValueKey('finance-filter-Trang trại')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trang trại ngừng hoạt động').last);
      await tester.pumpAndSettle();
      expect(repository.calls.last.farmId, 'historical');
      expect(
        overviewFixture.inventories.any((item) => item.farmId == 'historical'),
        isFalse,
      );
    },
  );
  testWidgets('B: a month with zero income and cost is still tappable', (
    tester,
  ) async {
    await open(
      tester,
      const FinanceChart(
        months: [FinanceMonth(month: '2026-10', income: 0, cost: 0)],
      ),
    );
    await tester.tap(find.byKey(const ValueKey('finance-month-2026-10')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('finance-month-detail')), findsOneWidget);
    expect(find.textContaining('Thu 0 đ'), findsOneWidget);
  });
  testWidgets(
    'N: shell uses SVG navigation and fullscreen covers the bottom tabs',
    (tester) async {
      await open(tester, const SmartShrimpApp());
      expect(find.text('Trang chủ'), findsOneWidget);
      expect(find.text('Tài khoản'), findsOneWidget);
      await expectLater(
        find.byKey(const Key('preview')),
        matchesGoldenFile('goldens/owner_shell.png'),
      );
      await tester.scrollUntilVisible(
        find.text('Toàn màn hình'),
        350,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toàn màn hình'));
      await tester.pumpAndSettle();
      expect(find.byType(FinanceFullscreen), findsOneWidget);
      expect(find.text('Tài khoản'), findsNothing);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.text('Tài khoản'), findsOneWidget);
    },
  );
  testWidgets(
    'N: owner sees real KPIs and six alert categories; header stays pinned',
    (tester) async {
      await open(tester, const OwnerHomePage());
      expect(find.text('Xin chào, Đạt'), findsOneWidget);
      expect(find.text('Thứ Ba, 13/10/2026'), findsOneWidget);
      expect(find.text('1 nhiệm vụ khẩn cấp'), findsOneWidget);
      await expectLater(
        find.byKey(const Key('preview')),
        matchesGoldenFile('goldens/owner_home.png'),
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -650));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Xin chào, Đạt')).dy, lessThan(110));
      await tester.ensureVisible(find.text('Ao A3').last);
      expect(find.text('●  DOC 72'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('N: dropdown defaults, month tap and explanation work', (
    tester,
  ) async {
    final repository = DashboardFixtureRepository();
    await open(
      tester,
      SingleChildScrollView(
        child: FinancePanel(
          farms: overviewFixture.financeFarms,
          today: DateTime(2026, 10, 13),
        ),
      ),
      repository: repository,
    );
    expect(find.text('Tháng này'), findsOneWidget);
    expect(find.text('Tất cả trang trại'), findsOneWidget);
    expect(repository.calls.single, const FinanceFilter());
    await tester.tap(find.byKey(const ValueKey('finance-month-2026-10')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('finance-month-detail')), findsOneWidget);
    await tester.tap(find.byTooltip('Cách tính Tổng chi'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Không tính tiền nhập kho'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('finance-filter-Trang trại')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trang trại Đông Hải').last);
    await tester.pumpAndSettle();
    expect(repository.calls.last.farmId, 'farm2');
    await tester.tap(
      find.byKey(const ValueKey('finance-filter-Khoảng thời gian')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tùy chỉnh…').last);
    await tester.pumpAndSettle();
    expect(find.text('01/10/2026'), findsOneWidget);
    expect(find.text('13/10/2026'), findsOneWidget);
    expect(repository.calls.last.period, FinancePeriod.custom);
    expect(tester.takeException(), isNull);
  });
  testWidgets('N: custom dates and totals render at narrow width', (
    tester,
  ) async {
    await open(
      tester,
      SingleChildScrollView(
        child: FinancePanel(
          farms: overviewFixture.financeFarms,
          today: DateTime(2026, 10, 13),
        ),
      ),
      size: const Size(320, 650),
      custom: true,
    );
    expect(find.text('01/07/2026'), findsOneWidget);
    expect(find.text('08/09/2026'), findsOneWidget);
    expect(find.text('+170,2 tr'), findsOneWidget);
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('goldens/finance_custom.png'),
    );
    await tester.tap(find.text('01/07/2026'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  for (final size in [const Size(780, 390), const Size(390, 780)]) {
    testWidgets('N: fullscreen landscape and local rotation $size', (
      tester,
    ) async {
      await open(
        tester,
        FinanceFullscreen(
          farms: overviewFixture.financeFarms,
          today: DateTime(2026, 10, 13),
        ),
        size: size,
        custom: true,
      );
      expect(find.text('Tổng thu'), findsOneWidget);
      expect(find.text('Tổng chi'), findsOneWidget);
      expect(find.text('Lợi nhuận'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('finance-month-2026-07')),
        findsOneWidget,
      );
      await expectLater(
        find.byKey(const Key('preview')),
        matchesGoldenFile(
          'goldens/finance_fullscreen_${size.width.toInt()}.png',
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('A: overview failure displays backend message and can retry', (
    tester,
  ) async {
    final repository = _FailureRepository();
    await open(tester, const OwnerHomePage(), repository: repository);
    expect(find.text('Máy chủ đang bảo trì.'), findsOneWidget);
    repository.fail = false;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Cảnh báo quan trọng'), findsOneWidget);
  });
  testWidgets('N: technician home does not fetch owner-only data', (
    tester,
  ) async {
    final repository = _FailureRepository();
    await open(
      tester,
      const HomePage(),
      repository: repository,
      role: AccountRole.technician,
    );
    expect(repository.calls, 0);
    expect(find.byType(OwnerHomePage), findsNothing);
  });
  testWidgets('A: finance refresh hides old totals while new filter loads', (
    tester,
  ) async {
    final repository = _PendingFinanceRepository();
    final container = await open(
      tester,
      FinancePanel(
        farms: overviewFixture.financeFarms,
        today: DateTime(2026, 10, 13),
      ),
      repository: repository,
    );
    expect(find.text('117,8 tr'), findsOneWidget);
    repository.pending = Completer<OwnerFinance>();
    container.read(financeFilterProvider.notifier).selectFarm('farm2');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('117,8 tr'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.pending!.complete(customFinanceFixture);
    await tester.pumpAndSettle();
    expect(find.text('416,9 tr'), findsOneWidget);
  });
}

void _expectLandscapeOverlay(
  WidgetTester tester,
  Finder finder, {
  required bool rotated,
}) {
  expect(
    MediaQuery.of(tester.element(finder)).orientation,
    Orientation.landscape,
  );
  final box = tester.renderObject<RenderBox>(finder);
  final direction =
      box.localToGlobal(const Offset(20, 0)) - box.localToGlobal(Offset.zero);
  expect(direction.dx, closeTo(rotated ? 0 : 20, 0.1));
  expect(direction.dy, closeTo(rotated ? 20 : 0, 0.1));
}

class _EmptyAlertsRepository extends DashboardFixtureRepository {
  @override
  Future<OwnerDashboard> getOverview() async =>
      overviewFixture.copyWith(alerts: []);
}

class _MutableDashboardRepository extends DashboardFixtureRepository
    implements FarmRepository {
  int overviewCalls = 0;
  bool removed = false;
  bool inactive = false;
  bool failDelete = false;
  static const farm = Farm(
    id: 'farm1',
    ownerId: 'owner',
    name: 'Trang trại Cửa Lấp',
  );

  @override
  Future<OwnerDashboard> getOverview() async {
    overviewCalls++;
    return removed || inactive
        ? overviewFixture.copyWith(
            financeFarms: overviewFixture.financeFarms
                .where((farm) => !removed || farm.id != 'farm1')
                .toList(),
            inventories: overviewFixture.inventories
                .where((farm) => farm.farmId != 'farm1')
                .toList(),
          )
        : overviewFixture;
  }

  @override
  Future<Farm> deleteFarm(String farmId) async {
    if (failDelete) throw const ApiException('Không thể xóa trang trại.');
    removed = true;
    return farm;
  }

  @override
  Future<List<Farm>> getFarms() async => removed ? [] : [farm];
  @override
  Future<Farm> getFarm(String farmId) async => farm;
  @override
  Future<Farm> createFarm({
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) async => farm;
  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) async => farm;
}

class _FailureRepository implements OwnerDashboardRepository {
  bool fail = true;
  int calls = 0;
  @override
  Future<OwnerDashboard> getOverview() async {
    calls++;
    if (fail) {
      throw const ApiException('Máy chủ đang bảo trì.', statusCode: 503);
    }
    return overviewFixture;
  }

  @override
  Future<OwnerFinance> getFinance(FinanceFilter filter) async => financeFixture;
}

class _PendingFinanceRepository extends DashboardFixtureRepository {
  Completer<OwnerFinance>? pending;
  @override
  Future<OwnerFinance> getFinance(FinanceFilter filter) =>
      pending?.future ?? super.getFinance(filter);
}
