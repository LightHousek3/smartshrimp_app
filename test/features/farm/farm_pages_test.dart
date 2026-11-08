import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_list_page.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_detail_page.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart'
    as pond_domain;
import 'package:smartshrimp_app/features/pond/domain/repositories/pond_repository.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_detail_page.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_form_page.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

void main() {
  testWidgets(
    'pond volume autofills, follows dimensions and preserves manual input',
    (tester) async {
      await _pumpPondForm(tester);
      final fields = find.byType(TextFormField);
      String volume() =>
          tester.widget<TextFormField>(fields.at(3)).controller!.text;
      await tester.enterText(fields.at(1), '1000');
      await tester.enterText(fields.at(2), '1.5');
      await tester.pump();
      expect(volume(), '1500.00');
      await tester.enterText(fields.at(2), '2');
      await tester.pump();
      expect(volume(), '2000.00');
      await tester.enterText(fields.at(1), '');
      await tester.pump();
      expect(volume(), isEmpty);
      await tester.enterText(fields.at(1), '1000');
      await tester.enterText(fields.at(3), '1400');
      await tester.enterText(fields.at(2), '1.8');
      await tester.pump();
      expect(volume(), '1400');

      await tester.enterText(fields.at(3), '');
      await tester.pump();
      expect(volume(), isEmpty);
      await tester.tap(fields.at(0));
      await tester.pump();
      expect(volume(), '1800.00');
      await tester.enterText(fields.at(2), '2');
      await tester.pump();
      expect(volume(), '2000.00');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pond edit preserves stored volume and disables unchanged normalized values',
    (tester) async {
      await _pumpPondForm(tester, pond: _editablePond);
      final fields = find.byType(TextFormField);
      bool canSave() =>
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Lưu thay đổi'),
              )
              .onPressed !=
          null;
      expect(
        tester.widget<TextFormField>(fields.at(3)).controller!.text,
        '1400.0',
      );
      expect(canSave(), isFalse);
      expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).readOnly,
        isTrue,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).readOnly,
        isTrue,
      );
      await tester.enterText(fields.at(3), '1300');
      await tester.pump();
      expect(
        tester.widget<TextFormField>(fields.at(3)).controller!.text,
        '1300',
      );
      expect(canSave(), isTrue);
      await tester.enterText(fields.at(3), '1400.00');
      await tester.enterText(fields.at(0), '  Pond  ');
      await tester.pump();
      expect(canSave(), isFalse);
      await tester.enterText(fields.at(0), 'Renamed');
      await tester.pump();
      expect(canSave(), isTrue);
      await tester.enterText(fields.at(0), 'Pond');
      await tester.pump();
      expect(canSave(), isFalse);
    },
  );

  for (final status in pond_domain.PondSeasonStatus.values.where(
    (s) => s != pond_domain.PondSeasonStatus.unknown,
  )) {
    for (final volume in ['1300', '1500']) {
      testWidgets('edit submits volume $volume during $status', (tester) async {
        final repo = await _pumpPondForm(
          tester,
          pond: _editablePond.copyWith(
            currentSeason: pond_domain.PondCurrentSeason(
              id: 'season',
              name: 'Season',
              status: status,
            ),
          ),
        );
        expect(
          tester.widget<TextField>(find.byType(TextField).at(3)).readOnly,
          isFalse,
        );
        expect(
          find.text(
            'Ao có vụ nuôi mở: không thể đổi loại ao hoặc chuyển sang bảo trì.',
          ),
          findsOneWidget,
        );
        await tester.enterText(find.byType(TextFormField).at(3), volume);
        await tester.pump();
        final submit = find.widgetWithText(FilledButton, 'Lưu thay đổi');
        await tester.ensureVisible(submit);
        await tester.tap(submit);
        await tester.pumpAndSettle();
        expect(repo.updateCalls, 1);
        expect(repo.lastVolumeM3, double.parse(volume));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'blank edit volume preserves stored value and does not enable save alone',
    (tester) async {
      final repo = await _pumpPondForm(tester, pond: _editablePond);
      await tester.enterText(find.byType(TextFormField).at(3), '');
      await tester.tap(find.byType(TextFormField).at(0));
      await tester.pump();
      await tester.pump();
      final submit = find.widgetWithText(FilledButton, 'Lưu thay đổi');
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(3))
            .controller!
            .text,
        isEmpty,
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'Renamed');
      await tester.pump();
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(repo.updateCalls, 1);
      expect(repo.lastVolumeM3, isNull);
      expect(repo.lastName, 'Renamed');
      expect(tester.takeException(), isNull);
    },
  );

  for (final invalid in ['0', '1500.01']) {
    testWidgets('edit rejects volume $invalid without update request', (
      tester,
    ) async {
      final repo = await _pumpPondForm(tester, pond: _editablePond);
      await tester.enterText(find.byType(TextFormField).at(3), invalid);
      await tester.pump();
      final submit = find.widgetWithText(FilledButton, 'Lưu thay đổi');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(repo.updateCalls, 0);
      expect(find.byType(PondFormPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('legacy missing dimensions permits rename and locks volume', (
    tester,
  ) async {
    final repo = await _pumpPondForm(
      tester,
      pond: _editablePond.copyWith(areaM2: null, depthM: null),
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(3)).readOnly,
      isTrue,
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Legacy renamed');
    await tester.pump();
    final submit = find.widgetWithText(FilledButton, 'Lưu thay đổi');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(repo.updateCalls, 1);
    expect(repo.lastName, 'Legacy renamed');
    expect(repo.lastVolumeM3, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit displays backend errors and retains entered volume', (
    tester,
  ) async {
    final repo = await _pumpPondForm(
      tester,
      pond: _editablePond,
      updateError: const ApiException('Update rejected', statusCode: 409),
    );
    await tester.enterText(find.byType(TextFormField).at(3), '1300');
    await tester.pump();
    final submit = find.widgetWithText(FilledButton, 'Lưu thay đổi');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(repo.updateCalls, 1);
    expect(find.text('Update rejected'), findsWidgets);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(3))
          .controller!
          .text,
      '1300',
    );
    expect(tester.takeException(), isNull);
  });

  for (final status in [
    pond_domain.PondSeasonStatus.planning,
    pond_domain.PondSeasonStatus.active,
  ]) {
    testWidgets('pond type choices are disabled for an open $status season', (
      tester,
    ) async {
      await _pumpPondForm(
        tester,
        pond: _editablePond.copyWith(
          currentSeason: pond_domain.PondCurrentSeason(
            id: 'season-1',
            name: 'Season',
            status: status,
          ),
        ),
      );
      for (final label in ['Ao nuôi', 'Ao xử lý nước']) {
        expect(
          tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, label),
              )
              .onPressed,
          isNull,
        );
      }
    });
  }

  testWidgets(
    'manual volume above capacity is rejected without a create request',
    (tester) async {
      final repository = await _pumpPondForm(tester);
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Pond');
      await tester.enterText(fields.at(1), '1000');
      await tester.enterText(fields.at(2), '1.5');
      await tester.enterText(fields.at(3), '1600');
      await tester.pump();
      final submit = find.widgetWithText(FilledButton, 'Tạo ao');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Thể tích không được vượt quá'),
        findsOneWidget,
      );
      expect(repository.createCalls, 0);
    },
  );

  for (final hasOpenSeason in <bool>[false, true]) {
    testWidgets(
      'pond form has two states and gates maintenance: open=$hasOpenSeason',
      (tester) async {
        final pond = pond_domain.Pond(
          id: 'pond-1',
          farmId: 'farm-1',
          name: 'Pond',
          type: pond_domain.PondType.aquaculture,
          status: pond_domain.PondStatus.available,
          currentSeason: hasOpenSeason
              ? const pond_domain.PondCurrentSeason(
                  id: 'season-1',
                  name: 'Season',
                  status: pond_domain.PondSeasonStatus.active,
                )
              : null,
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
            ],
            child: MaterialApp(
              home: PondFormPage(farmId: 'farm-1', initialPond: pond),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final finder = find.byType(
          DropdownButtonFormField<pond_domain.PondStatus>,
        );
        await tester.ensureVisible(finder);
        final dropdown = tester
            .widget<DropdownButtonFormField<pond_domain.PondStatus>>(finder);
        // Read the public DropdownButton configuration built by the form field.
        final button = tester.widget<DropdownButton<pond_domain.PondStatus>>(
          find.descendant(
            of: finder,
            matching: find.byType(DropdownButton<pond_domain.PondStatus>),
          ),
        );
        expect(dropdown, isNotNull);
        expect(button.items!.map((item) => item.value), [
          pond_domain.PondStatus.available,
          pond_domain.PondStatus.maintenance,
        ]);
        expect(button.items!.last.enabled, !hasOpenSeason);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'creating a pond opens its detail and back returns to farm detail',
    (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final ponds = _FakePondRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ownerDashboardRepositoryProvider.overrideWithValue(
              DashboardFixtureRepository(),
            ),
            authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
            farmRepositoryProvider.overrideWithValue(_FakeFarmRepository()),
            pondRepositoryProvider.overrideWithValue(ponds),
            seasonRepositoryProvider.overrideWithValue(
              _EmptySeasonRepository(),
            ),
          ],
          child: const SmartShrimpApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trang trại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trại Cà Mau'));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(CustomScrollView).last,
        const Offset(0, -450),
      );
      await tester.pumpAndSettle();
      final add = find.text('Thêm ao');
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ao mới');
      await tester.enterText(find.byType(TextFormField).at(1), '1200');
      await tester.enterText(find.byType(TextFormField).at(2), '1.5');
      await tester.pump();
      final submit = find.widgetWithText(FilledButton, 'Tạo ao');
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(ponds.createCalls, 1);
      expect(ponds.lastVolumeM3, 1800);
      expect(find.byType(PondDetailPage), findsOneWidget);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(PondDetailPage)),
      ).read(appRouterProvider);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/farms/farm-1/ponds/new-pond',
      );
      await tester.tap(find.byTooltip('Quay lại').last);
      await tester.pumpAndSettle();
      expect(find.byType(FarmDetailPage), findsOneWidget);
      expect(find.byType(PondDetailPage), findsNothing);
      expect(router.routeInformationProvider.value.uri.path, '/farms/farm-1');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('owner can open the farm list and create form validates name', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeFarmRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ownerDashboardRepositoryProvider.overrideWithValue(
            DashboardFixtureRepository(),
          ),
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(repository),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trang trại'));
    await tester.pumpAndSettle();

    expect(find.text('Quản lý trại, ao và vụ nuôi'), findsOneWidget);
    expect(find.text('Trại Cà Mau'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(FarmListPage),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is AppSvgIcon && widget.icon == AppSvgIconName.farm,
        ),
      ),
      findsOneWidget,
    );
    expect(find.text('4 ao'), findsOneWidget);
    final farmIcon = find.descendant(
      of: find.byType(FarmListPage),
      matching: find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.icon == AppSvgIconName.farm,
      ),
    );
    expect(tester.getSize(farmIcon), const Size(24, 24));
    final iconTile = find
        .ancestor(of: farmIcon, matching: find.byType(Container))
        .first;
    expect(tester.getSize(iconTile), const Size(44, 44));
    expect(find.text('3 vụ nuôi'), findsOneWidget);
    expect(repository.getCalls, 1);

    await tester.enterText(find.byType(TextField).first, 'không tồn tại');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Trại Cà Mau'), findsNothing);
    expect(repository.getCalls, 1);

    await tester.tap(find.byTooltip('Xóa tìm kiếm'));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byTooltip('Tạo trang trại'));
    await tester.pumpAndSettle();
    final submitButton = find.widgetWithText(FilledButton, 'Tạo trang trại');
    await tester.ensureVisible(submitButton);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pump();

    expect(find.text('Vui lòng nhập tên trang trại.'), findsOneWidget);
    expect(repository.createCalls, 0);
  });

  testWidgets('farm detail hides delete when related data exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ownerDashboardRepositoryProvider.overrideWithValue(
            DashboardFixtureRepository(),
          ),
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(_FakeFarmRepository()),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trang trại'));
    await tester.pumpAndSettle();
    expect(find.text('Đang hoạt động'), findsWidgets);
    expect(find.text('Đã lưu trữ'), findsNothing);

    await tester.tap(find.text('Trại Cà Mau'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(CustomScrollView).last,
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xóa trang trại'), findsNothing);
    expect(find.text('Lưu trữ trang trại'), findsNothing);
  });

  testWidgets(
    'farm detail allows deletion with templates and explains deactivation',
    (tester) async {
      final repository = _FakeFarmRepository(
        farm: _farm.copyWith(
          pondCount: 0,
          activeSeasonCount: 0,
          canDelete: true,
          templateCount: 2,
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ownerDashboardRepositoryProvider.overrideWithValue(
              DashboardFixtureRepository(),
            ),
            authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
            farmRepositoryProvider.overrideWithValue(repository),
          ],
          child: const SmartShrimpApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trang trại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trại Cà Mau'));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(CustomScrollView).last,
        const Offset(0, -700),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Xóa trang trại'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận xóa'), findsOneWidget);
      expect(
        find.textContaining('2 phác đồ mẫu sẽ chuyển sang ngừng sử dụng'),
        findsOneWidget,
      );
      expect(repository.deleteCalls, 0);
      await tester.tap(find.text('Xác nhận xóa'));
      await tester.pumpAndSettle();
      expect(repository.deleteCalls, 1);
    },
  );

  testWidgets('inactive Farm route selects the local status filter', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _FakeFarmRepository(
      farm: _farm.copyWith(status: FarmStatus.inactive),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ownerDashboardRepositoryProvider.overrideWithValue(
            DashboardFixtureRepository(),
          ),
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(repository),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(SmartShrimpApp)),
    ).read(appRouterProvider);
    router.go('/farms?status=inactive');
    await tester.pumpAndSettle();

    expect(find.text('Trại Cà Mau'), findsOneWidget);
    expect(find.text('Ngừng hoạt động'), findsWidgets);
    expect(repository.getCalls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('farm detail pond section matches compact searchable layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ownerDashboardRepositoryProvider.overrideWithValue(
            DashboardFixtureRepository(),
          ),
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(
            _FakeFarmRepository(farm: _farmWithPonds),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trang trại'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trại Cà Mau'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(CustomScrollView).last,
      const Offset(0, -450),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thêm ao'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Tìm ao...'), findsOneWidget);
    expect(find.text('Trạng thái'), findsOneWidget);
    expect(find.text('Loại ao'), findsOneWidget);
    expect(find.text('Ao A3'), findsOneWidget);
    expect(find.text('Ao C2 (xử lý nước)'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('pond-filter-Trạng thái')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Không xác định'), findsNothing);
    await tester.tap(find.text('Đang bảo trì').last);
    await tester.pumpAndSettle();
    expect(find.text('Ao A3'), findsNothing);
    expect(find.text('Ao C2 (xử lý nước)'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('pond-filter-Trạng thái')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tất cả Trạng thái'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'C2');
    await tester.pump();
    expect(find.text('Ao A3'), findsNothing);
    expect(find.text('Ao C2 (xử lý nước)'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'không tồn tại');
    await tester.pump();
    expect(find.text('Không tìm thấy ao'), findsOneWidget);
    expect(find.text('Hãy thử từ khóa hoặc bộ lọc khác.'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey<String>('pond-empty-state'))),
      const Size(361, 180),
    );
    expect(tester.takeException(), isNull);
  });
}

const _owner = AuthAccount(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  fullName: 'Nguyễn Văn Chủ',
  role: AccountRole.farmOwner,
  status: AccountStatus.active,
);

Future<_FakePondRepository> _pumpPondForm(
  WidgetTester tester, {
  pond_domain.Pond? pond,
  AppException? updateError,
}) async {
  tester.view.physicalSize = const Size(500, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final repository = _FakePondRepository()..updateError = updateError;
  final router = GoRouter(
    initialLocation: '/form',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(),
        routes: [
          GoRoute(
            path: 'form',
            builder: (_, _) =>
                PondFormPage(farmId: 'farm-1', initialPond: pond),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
        pondRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

const _editablePond = pond_domain.Pond(
  id: 'pond-1',
  farmId: 'farm-1',
  name: 'Pond',
  areaM2: 1000,
  depthM: 1.5,
  volumeM3: 1400,
  type: pond_domain.PondType.aquaculture,
  status: pond_domain.PondStatus.available,
);

const _farm = Farm(
  id: 'farm-1',
  ownerId: 'owner-1',
  name: 'Trại Cà Mau',
  address: 'Cà Mau',
  totalAreaHectares: 3.5,
  pondCount: 4,
  activeSeasonCount: 3,
  canDelete: false,
);

const _farmWithPonds = Farm(
  id: 'farm-1',
  ownerId: 'owner-1',
  name: 'Trại Cà Mau',
  address: 'Cà Mau',
  totalAreaHectares: 3.5,
  pondCount: 4,
  activeSeasonCount: 3,
  canDelete: false,
  ponds: <FarmPond>[
    FarmPond(
      id: 'pond-1',
      name: 'Ao A3',
      areaM2: 3200,
      type: PondType.aquaculture,
      status: PondStatus.available,
      currentSeason: FarmCurrentSeason(
        id: 'season-1',
        status: FarmSeasonStatus.active,
        dayOfCulture: 72,
      ),
    ),
    FarmPond(
      id: 'pond-2',
      name: 'Ao C2 (xử lý nước)',
      areaM2: 2000,
      type: PondType.waterTreatment,
      status: PondStatus.maintenance,
    ),
  ],
);

final class _OwnerAuthRepository implements AuthRepository {
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => _owner;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => _owner;
}

final class _FakePondRepository implements PondRepository {
  int createCalls = 0;
  int updateCalls = 0;
  String? lastName;
  AppException? updateError;
  double? lastVolumeM3;
  final pond = const pond_domain.Pond(
    id: 'new-pond',
    farmId: 'farm-1',
    name: 'Ao mới',
    areaM2: 1200,
    depthM: 1.5,
    volumeM3: 1800,
    type: pond_domain.PondType.aquaculture,
    status: pond_domain.PondStatus.available,
  );
  @override
  Future<pond_domain.Pond> getPond(String farmId, String pondId) async => pond;
  @override
  Future<pond_domain.Pond> createPond({
    required String farmId,
    required String name,
    required double areaM2,
    required double depthM,
    double? volumeM3,
    required pond_domain.PondType type,
    required pond_domain.PondStatus status,
  }) async {
    createCalls++;
    lastVolumeM3 = volumeM3;
    return pond;
  }

  @override
  Future<pond_domain.Pond> updatePond({
    required String farmId,
    required String pondId,
    required String name,
    double? volumeM3,
    required pond_domain.PondType type,
    required pond_domain.PondStatus status,
  }) async {
    updateCalls++;
    lastName = name;
    lastVolumeM3 = volumeM3;
    if (updateError != null) throw updateError!;
    return pond.copyWith(
      id: pondId,
      name: name,
      volumeM3: volumeM3 ?? pond.volumeM3,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _EmptySeasonRepository implements SeasonRepository {
  @override
  Future<SeasonPage> getSeasons({
    String? farmId,
    String? pondId,
    SeasonStatus? status,
    String search = '',
    String? cursor,
    int limit = 20,
  }) async => const SeasonPage(
    items: [],
    limit: 20,
    totalResults: 0,
    hasNextPage: false,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeFarmRepository implements FarmRepository {
  _FakeFarmRepository({this.farm = _farm});

  final Farm farm;
  int createCalls = 0;
  int deleteCalls = 0;
  int getCalls = 0;

  @override
  Future<Farm> deleteFarm(String farmId) async {
    deleteCalls++;
    return farm;
  }

  @override
  Future<Farm> createFarm({
    required String name,
    required FarmStatus status,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) async {
    createCalls++;
    return farm;
  }

  @override
  Future<Farm> getFarm(String farmId) async => farm;

  @override
  Future<List<Farm>> getFarms() async {
    getCalls++;
    return <Farm>[farm];
  }

  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    required FarmStatus status,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) async => farm;
}
