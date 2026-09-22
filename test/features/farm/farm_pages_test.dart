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
    expect(repository.getCalls, 1);

    await tester.enterText(find.byType(TextField).first, 'không tồn tại');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Trại Cà Mau'), findsNothing);
    expect(repository.getCalls, 1);

    await tester.tap(find.byTooltip('Xóa tìm kiếm'));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byTooltip('Tạo trang trại'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Tạo trang trại'));
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
    expect(find.text('Không thể xóa khi có vụ đang mở'), findsOneWidget);
    expect(find.text('Lưu trữ trang trại'), findsNothing);
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
  int createCalls = 0;
  int getCalls = 0;

  @override
  Future<Farm> deleteFarm(String farmId) async => _farm;

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
    return const <Farm>[_farm];
  }

  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? totalAreaHectares,
  }) async => _farm;
}
