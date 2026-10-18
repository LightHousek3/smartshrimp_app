import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/features/profile/presentation/pages/account_page.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import '../../support/load_app_fonts.dart';

void main() {
  for (final (route, title, golden) in [
    (AppRoutes.profileEdit, 'Cập nhật thông tin', 'profile_edit'),
    (AppRoutes.changePassword, 'Đổi mật khẩu', 'change_password'),
  ]) {
    testWidgets('$title follows the Figma form layout and shared icons', (
      tester,
    ) async {
      await loadAppFonts();
      tester.view.physicalSize = const Size(402, 874);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 24);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(
        _testApp(
          _FakeAuthRepository(account: _authAccountFor(AccountRole.farmOwner)),
          _FakeProfileRepository(profile: _profileFor(AccountRole.farmOwner)),
        ),
      );
      await tester.pumpAndSettle();
      ProviderScope.containerOf(
        tester.element(find.byType(SmartShrimpApp)),
      ).read(appRouterProvider).go(route);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      expect(find.byType(PageHeaderBar), findsOneWidget);
      expect(find.byType(StickyPageHeader), findsNothing);
      expect(find.text('Trang trại'), findsOneWidget);
      final field = tester.getSize(find.byType(TextFormField).first);
      expect(field.width, 370);
      expect(field.height, closeTo(44, 3));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$golden.png'),
      );
      if (route == AppRoutes.changePassword) {
        expect(tester.testTextInput.isVisible, isFalse);
        final current = find.byKey(const Key('current_password_field'));
        final currentInput = find.descendant(
          of: current,
          matching: find.byType(TextField),
        );
        expect(tester.widget<TextField>(currentInput).obscureText, isTrue);
        await tester.tap(find.byTooltip('Hiện mật khẩu').first);
        await tester.pumpAndSettle();
        expect(tester.widget<TextField>(currentInput).obscureText, isFalse);
        await tester.tap(find.byTooltip('Ẩn mật khẩu'));
        await tester.pumpAndSettle();
        expect(tester.widget<TextField>(currentInput).obscureText, isTrue);
      }
      expect(tester.takeException(), isNull);
    });
  }
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
    await loadAppFonts();
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
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
    expect(find.text('TRANG TRẠI'), findsNothing);
    expect(find.text('AO NUÔI'), findsNothing);
    expect(find.text('VỤ NUÔI'), findsNothing);
    expect(find.text('Đang sở hữu'), findsNothing);
    expect(find.text('Đang quản lý'), findsNothing);
    expect(find.text('Đang hoạt động'), findsNothing);
    for (final value in ['2', '8', '3']) {
      expect(
        find.descendant(
          of: find.byType(AccountPage),
          matching: find.text(value),
        ),
        findsNothing,
      );
    }
    expect(find.byKey(const Key('account_personnel_entry')), findsOneWidget);
    expect(find.text('3 KTV · 2 Chuyên gia'), findsOneWidget);
    expect(find.text('5 đang hoạt động'), findsOneWidget);
    expect(find.text('Quản lý hồ sơ & nhân sự'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/owner_account.png'),
    );
    final header = find.text('Quản lý hồ sơ & nhân sự');
    final topBefore = tester.getTopLeft(header).dy;
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(header).dy, topBefore);
    expect(tester.takeException(), isNull);
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
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
      ownerDashboardRepositoryProvider.overrideWithValue(
        DashboardFixtureRepository(),
      ),
      authRepositoryProvider.overrideWithValue(authRepository),
      profileRepositoryProvider.overrideWithValue(profileRepository),
      personnelRepositoryProvider.overrideWithValue(_FakePersonnelRepository()),
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
      updatedAt: DateTime.utc(2026, 9, 17, 0, 0, updateProfileCalls),
    );
    return current;
  }
}

final class _FakePersonnelRepository implements PersonnelRepository {
  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) async => ManagedPersonnelPage(
    items: const <ManagedPersonnel>[],
    limit: limit,
    totalResults: status != AccountStatus.active
        ? 0
        : role == AccountRole.technician
        ? 3
        : role == AccountRole.expert
        ? 2
        : 5,
    hasNextPage: false,
  );

  @override
  Future<ManagedPersonnelDetail> getPersonnelById(String personnelId) =>
      throw UnimplementedError();
}
