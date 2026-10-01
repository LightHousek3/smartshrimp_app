import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';

void main() {
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
    expect(find.text('4 ao'), findsOneWidget);
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

  testWidgets('farm list no longer exposes archive status filters', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(_FakeFarmRepository()),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trang trại'));
    await tester.pumpAndSettle();
    expect(find.text('Đang hoạt động'), findsNothing);
    expect(find.text('Đã lưu trữ'), findsNothing);

    await tester.tap(find.text('Trại Cà Mau'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(CustomScrollView).last,
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa trang trại'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa thể xóa trang trại'), findsOneWidget);
    expect(
      find.text('3 vụ nuôi đang ở trạng thái chuẩn bị hoặc đang nuôi.'),
      findsOneWidget,
    );
    expect(find.text('Xác nhận xóa'), findsNothing);
    expect(find.text('Lưu trữ trang trại'), findsNothing);
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

final class _FakeFarmRepository implements FarmRepository {
  _FakeFarmRepository({this.farm = _farm});

  final Farm farm;
  int createCalls = 0;
  int getCalls = 0;

  @override
  Future<Farm> deleteFarm(String farmId) async => farm;

  @override
  Future<Farm> createFarm({
    required String name,
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
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) async => farm;
}
