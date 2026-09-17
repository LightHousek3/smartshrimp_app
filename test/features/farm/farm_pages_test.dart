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
    expect(find.text('Trại đã lưu'), findsNothing);
    expect(repository.getCalls, 1);

    await tester.enterText(find.byType(TextField).first, 'không tồn tại');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Trại Cà Mau'), findsNothing);
    expect(repository.getCalls, 1);

    await tester.tap(find.byTooltip('Xóa tìm kiếm'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Đã lưu trữ'));
    await tester.pump();
    expect(find.text('Trại đã lưu'), findsOneWidget);
    expect(find.text('Trại Cà Mau'), findsNothing);
    expect(repository.getCalls, 1);

    await tester.tap(find.text('Đang hoạt động'));
    await tester.pump();

    await tester.tap(find.byTooltip('Tạo trang trại'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Tạo trang trại'));
    await tester.pump();

    expect(find.text('Vui lòng nhập tên trang trại.'), findsOneWidget);
    expect(repository.createCalls, 0);
  });

  testWidgets('archived tab matches the empty state from the design', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(
            _FakeFarmRepository(includeArchived: false),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trang trại'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đã lưu trữ'));
    await tester.pump();

    expect(find.text('Không có trang trại lưu trữ'), findsOneWidget);
    expect(
      find.text('Các trang trại bạn lưu trữ sẽ xuất hiện ở đây.'),
      findsOneWidget,
    );
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
  canArchive: false,
);

final _archivedFarm = Farm(
  id: 'farm-2',
  ownerId: 'owner-1',
  name: 'Trại đã lưu',
  archivedAt: DateTime.utc(2026, 9, 1),
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
  _FakeFarmRepository({this.includeArchived = true});

  final bool includeArchived;
  int createCalls = 0;
  int getCalls = 0;

  @override
  Future<Farm> archiveFarm(String farmId) async => _farm;

  @override
  Future<Farm> createFarm({
    required String name,
    String? address,
    double? totalAreaHectares,
  }) async {
    createCalls++;
    return _farm;
  }

  @override
  Future<Farm> getFarm(String farmId) async => _farm;

  @override
  Future<List<Farm>> getFarms() async {
    getCalls++;
    return <Farm>[_farm, if (includeArchived) _archivedFarm];
  }

  @override
  Future<Farm> restoreFarm(String farmId) async => _farm;

  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? totalAreaHectares,
  }) async => _farm;
}
