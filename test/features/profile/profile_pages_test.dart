import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';

void main() {
  testWidgets('account tab shows the authenticated technician profile', (
    tester,
  ) async {
    final authRepository = _FakeAuthRepository();
    final profileRepository = _FakeProfileRepository();
    await tester.pumpWidget(_testApp(authRepository, profileRepository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();

    expect(find.text('Trần Quốc Bảo'), findsOneWidget);
    expect(find.text('Kỹ thuật viên'), findsOneWidget);
    expect(find.text('bao@smartshrimp.vn'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('148'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);
    expect(find.text('Nguyễn Văn Chủ'), findsOneWidget);
    expect(find.byKey(const Key('profile_avatar_button')), findsOneWidget);
    expect(profileRepository.getCalls, 1);
  });

  testWidgets('account tab adapts account details for a farm owner', (
    tester,
  ) async {
    final ownerAccount = _authAccountFor(AccountRole.farmOwner);
    final ownerProfile = _profileFor(AccountRole.farmOwner);
    await tester.pumpWidget(
      _testApp(
        _FakeAuthRepository(account: ownerAccount),
        _FakeProfileRepository(profile: ownerProfile),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();

    expect(find.text('Chủ trang trại'), findsNWidgets(2));
    expect(find.text('Vai trò hệ thống'), findsOneWidget);
    expect(find.text('Chủ trang trại phụ trách'), findsNothing);
    expect(find.text('TRANG TRẠI'), findsOneWidget);
    expect(find.text('AO NUÔI'), findsOneWidget);
    expect(find.text('VỤ NUÔI'), findsOneWidget);
    expect(find.text('Đang sở hữu'), findsOneWidget);
    expect(find.text('Đang quản lý'), findsOneWidget);
    expect(find.text('Đang hoạt động'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('profile edit validates and sends normalized values', (
    tester,
  ) async {
    final profileRepository = _FakeProfileRepository();
    await tester.pumpWidget(_testApp(_FakeAuthRepository(), profileRepository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Cập nhật thông tin cá nhân'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Cập nhật thông tin cá nhân'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('profile_name_field')),
      '  Nguyễn Văn An  ',
    );
    await tester.enterText(
      find.byKey(const Key('profile_phone_field')),
      '0912 345 678',
    );
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(Scrollable).last,
      const Offset(0, 1000),
      1500,
    );
    await tester.pumpAndSettle();

    expect(profileRepository.lastFullName, 'Nguyễn Văn An');
    expect(profileRepository.lastPhone, '0912345678');
    expect(find.text('Cập nhật thông tin'), findsNothing);
    expect(find.text('Thông tin tài khoản'), findsOneWidget);
    expect(find.text('Nguyễn Văn An'), findsOneWidget);
  });

  testWidgets('farm owner returns to account page after profile edit', (
    tester,
  ) async {
    final ownerAccount = _authAccountFor(AccountRole.farmOwner);
    final ownerProfile = _profileFor(AccountRole.farmOwner);
    final profileRepository = _FakeProfileRepository(profile: ownerProfile);
    await tester.pumpWidget(
      _testApp(_FakeAuthRepository(account: ownerAccount), profileRepository),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Cập nhật thông tin cá nhân'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Cập nhật thông tin cá nhân'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('profile_name_field')),
      '  Nguyễn Văn Chủ Mới  ',
    );
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pumpAndSettle();

    expect(profileRepository.lastFullName, 'Nguyễn Văn Chủ Mới');
    expect(find.text('Cập nhật thông tin'), findsNothing);
    expect(find.text('Thông tin tài khoản'), findsOneWidget);
    await tester.fling(
      find.byType(Scrollable).last,
      const Offset(0, 1000),
      1500,
    );
    await tester.pumpAndSettle();
    expect(find.text('Nguyễn Văn Chủ Mới'), findsOneWidget);
  });

  testWidgets('password change keeps the renewed current session signed in', (
    tester,
  ) async {
    final authRepository = _FakeAuthRepository();
    final profileRepository = _FakeProfileRepository();
    await tester.pumpWidget(_testApp(authRepository, profileRepository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tài khoản'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Đổi mật khẩu'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đổi mật khẩu'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('current_password_field')),
      'old-password',
    );
    await tester.enterText(
      find.byKey(const Key('new_password_field')),
      'new-password',
    );
    await tester.enterText(
      find.byKey(const Key('confirm_password_field')),
      'new-password',
    );
    await tester.tap(find.text('Xác nhận đổi mật khẩu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Mật khẩu đã thay đổi thành công'), findsOneWidget);
    expect(profileRepository.changePasswordCalls, 1);
    await tester.pumpAndSettle();

    expect(authRepository.logoutCalls, 0);
    expect(find.byKey(const Key('login_email_field')), findsNothing);
    expect(find.text('Thông tin tài khoản'), findsOneWidget);
  });
}

Widget _testApp(
  AuthRepository authRepository,
  ProfileRepository profileRepository,
) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      profileRepositoryProvider.overrideWithValue(profileRepository),
    ],
    child: const SmartShrimpApp(),
  );
}

const _authAccount = AuthAccount(
  id: 'account-1',
  email: 'bao@smartshrimp.vn',
  fullName: 'Trần Quốc Bảo',
  role: AccountRole.technician,
  status: AccountStatus.active,
);

const _profile = AccountProfile(
  id: 'account-1',
  email: 'bao@smartshrimp.vn',
  fullName: 'Trần Quốc Bảo',
  phone: '0912345678',
  role: AccountRole.technician,
  status: AccountStatus.active,
  managedByOwnerId: 'owner-1',
  managedByOwner: ManagedOwner(
    id: 'owner-1',
    email: 'owner@smartshrimp.vn',
    fullName: 'Nguyễn Văn Chủ',
  ),
  technicianKpi: TechnicianKpi(
    seasonsParticipated: 6,
    completedTasks: 148,
    onTimeCompletedTasks: 139,
    onTimeCompletionRatePct: 93.92,
  ),
);

AuthAccount _authAccountFor(AccountRole role) => AuthAccount(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  fullName: 'Nguyễn Văn Chủ',
  role: role,
  status: AccountStatus.active,
);

AccountProfile _profileFor(AccountRole role) => AccountProfile(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  fullName: 'Nguyễn Văn Chủ',
  phone: '0987654321',
  role: role,
  status: AccountStatus.active,
  farmOwnerKpi: role == AccountRole.farmOwner
      ? const FarmOwnerKpi(farmsOwned: 2, pondsManaged: 8, activeSeasons: 3)
      : null,
);

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.account = _authAccount});

  final AuthAccount account;
  int logoutCalls = 0;

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => account;

  @override
  Future<void> logout() async {
    logoutCalls++;
  }

  @override
  Future<AuthAccount?> restoreSession() async => account;
}

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({AccountProfile? profile})
    : current = profile ?? _profile;

  int getCalls = 0;
  int changePasswordCalls = 0;
  int updateProfileCalls = 0;
  String? lastFullName;
  String? lastPhone;
  AccountProfile current;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    changePasswordCalls++;
  }

  @override
  Future<AccountProfile> getProfile() async {
    getCalls++;
    return current;
  }

  @override
  Future<AccountProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async => current;

  @override
  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    updateProfileCalls++;
    lastFullName = fullName;
    lastPhone = phone;
    current = AccountProfile(
      id: current.id,
      email: current.email,
      fullName: fullName.trim(),
      phone: phone,
      role: current.role,
      status: current.status,
      managedByOwnerId: current.managedByOwnerId,
      managedByOwner: current.managedByOwner,
      technicianKpi: current.technicianKpi,
      expertKpi: current.expertKpi,
      farmOwnerKpi: current.farmOwnerKpi,
      updatedAt: DateTime.utc(2026, 9, 17, 0, 0, updateProfileCalls),
    );
    return current;
  }
}
