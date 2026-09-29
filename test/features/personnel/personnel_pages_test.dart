import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/presentation/pages/personnel_list_page.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:smartshrimp_app/features/profile/presentation/pages/account_page.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/features/shell/presentation/pages/empty_tab_page.dart';

void main() {
  testWidgets('owner can filter personnel and open details', (tester) async {
    tester.view.physicalSize = const Size(1245, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final repository = _FakePersonnelRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          personnelRepositoryProvider.overrideWithValue(repository),
          profileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(AccountRole.farmOwner),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nhân sự'), findsNothing);
    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    expect(find.text('1 đang hoạt động'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('account_personnel_entry')),
        matching: find.byIcon(Icons.groups_outlined),
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('account_personnel_entry')));
    await tester.pumpAndSettle();

    expect(find.byType(PersonnelListPage), findsOneWidget);
    expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    expect(find.text('KTV'), findsWidgets);
    expect(find.text('Chuyên gia'), findsOneWidget);
    expect(find.text('Mọi trạng thái'), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextField).first).width,
      greaterThan(1000),
    );
    expect(
      tester.getSize(find.byKey(const Key('personnel_role_filters'))).width,
      300,
    );
    expect(
      tester.getSize(find.byKey(const Key('personnel_status_filter'))).width,
      124,
    );
    expect(
      tester.getSize(find.byKey(const Key('personnel_status_filter'))).height,
      48,
    );
    final statusMenu = tester.widget<PopupMenuButton<PersonnelStatusFilter>>(
      find.byType(PopupMenuButton<PersonnelStatusFilter>),
    );
    expect(statusMenu.color, Colors.white);
    expect(statusMenu.surfaceTintColor, Colors.transparent);
    expect(statusMenu.position, PopupMenuPosition.under);

    await tester.tap(find.byKey(const Key('personnel_status_filter')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    await tester.tap(find.text('Mọi trạng thái').last);
    await tester.pumpAndSettle();
    expect(find.text('Nguyễn Văn Kỹ Thuật'), findsOneWidget);
    expect(find.text('Đang phụ trách 2 vụ nuôi'), findsOneWidget);
    final avatar = tester.widget<CircleAvatar>(
      find.byKey(const Key('personnel_avatar_personnel-1')),
    );
    expect(avatar.backgroundColor, const Color(0xFF1D7AD6));

    await tester.enterText(find.byType(TextField).first, '  kỹ thuật  ');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(repository.lastSearch, '  kỹ thuật  ');

    await tester.tap(find.text('Nguyễn Văn Kỹ Thuật'));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết nhân sự'), findsOneWidget);
    expect(find.text('Thông tin liên hệ'), findsOneWidget);
    expect(find.text('VỤ ĐANG PHỤ TRÁCH'), findsOneWidget);
    expect(find.text('0912345678'), findsOneWidget);
    expect(repository.detailCalls, 1);
  });

  testWidgets('technician does not receive the owner personnel tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_TechnicianAuthRepository()),
          profileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(AccountRole.technician),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nhân sự'), findsNothing);
    expect(find.text('Nhiệm vụ'), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('account_personnel_entry')), findsNothing);
  });

  testWidgets('owner bottom tabs show notifications and omit personnel', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          personnelRepositoryProvider.overrideWithValue(
            _FakePersonnelRepository(),
          ),
          profileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(AccountRole.farmOwner),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nhân sự'), findsNothing);
    expect(find.text('Thông báo'), findsOneWidget);

    await tester.tap(find.text('Nhiệm vụ'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EmptyTabPage>(find.byType(EmptyTabPage)).semanticLabel,
      'Nhiệm vụ',
    );

    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountPage), findsOneWidget);
    expect(find.byKey(const Key('account_personnel_entry')), findsOneWidget);
  });
}

const _owner = AuthAccount(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  role: AccountRole.farmOwner,
  status: AccountStatus.active,
);

const _technicianAccount = AuthAccount(
  id: 'personnel-1',
  email: 'technician@smartshrimp.vn',
  role: AccountRole.technician,
  status: AccountStatus.active,
  managedByOwnerId: 'owner-1',
);

final _personnel = ManagedPersonnel(
  id: 'personnel-1',
  email: 'technician@smartshrimp.vn',
  phone: '0912345678',
  fullName: 'Nguyễn Văn Kỹ Thuật',
  role: AccountRole.technician,
  status: AccountStatus.active,
  currentSeasonAssignments: 2,
  createdAt: _createdAt,
  updatedAt: _updatedAt,
);
final _createdAt = DateTime(2026, 9, 1);
final _updatedAt = DateTime(2026, 9, 22);

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

final class _TechnicianAuthRepository implements AuthRepository {
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => _technicianAccount;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => _technicianAccount;
}

final class _FakePersonnelRepository implements PersonnelRepository {
  String? lastSearch;
  int detailCalls = 0;

  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) async {
    lastSearch = search;
    return ManagedPersonnelPage(
      items: <ManagedPersonnel>[_personnel],
      limit: 20,
      totalResults: 1,
      hasNextPage: false,
    );
  }

  @override
  Future<ManagedPersonnel> getPersonnelById(String personnelId) async {
    detailCalls++;
    return _personnel;
  }
}

final class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository(this.role);

  final AccountRole role;

  AccountProfile get _profile => AccountProfile(
    id: 'owner-1',
    email: 'test@smartshrimp.vn',
    role: role,
    status: AccountStatus.active,
  );

  @override
  Future<AccountProfile> getProfile() async => _profile;

  @override
  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phone,
  }) async => _profile;

  @override
  Future<AccountProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async => _profile;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}
}
