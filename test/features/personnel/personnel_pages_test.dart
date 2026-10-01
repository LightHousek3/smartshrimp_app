import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
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
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';
import 'package:smartshrimp_app/features/season/presentation/pages/season_detail_page.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
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
    final seasonRepository = _UnavailableSeasonRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          personnelRepositoryProvider.overrideWithValue(repository),
          seasonRepositoryProvider.overrideWithValue(seasonRepository),
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
    expect(find.text('1 KTV · 0 Chuyên gia'), findsOneWidget);
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

    final callsBeforeSearch = repository.listCalls;
    await tester.enterText(find.byType(TextField).first, '  kỹ thuật  ');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(repository.listCalls, callsBeforeSearch);
    expect(repository.lastSearch, isNull);

    await tester.tap(find.text('Nguyễn Văn Kỹ Thuật'));
    await tester.pumpAndSettle();

    expect(find.text('Nguyễn Văn Kỹ Thuật'), findsNWidgets(2));
    expect(find.byKey(const Key('personnel_detail_name')), findsOneWidget);
    expect(find.text('technician@smartshrimp.vn'), findsOneWidget);
    expect(find.text('Kỹ thuật viên'), findsOneWidget);
    expect(find.text('Đang hoạt động'), findsOneWidget);
    expect(find.text('Điện thoại'), findsOneWidget);
    expect(find.text('Tham gia hệ thống từ'), findsOneWidget);
    expect(find.text('KPI vận hành'), findsOneWidget);
    expect(find.text('Theo nhiệm vụ'), findsOneWidget);
    expect(find.text('Vụ đã tham gia'), findsOneWidget);
    expect(find.text('Phân công hiện tại'), findsOneWidget);
    expect(find.text('Ao A5'), findsOneWidget);
    expect(find.text('Ao D2'), findsOneWidget);
    expect(find.text('Trang trại Của Lập · Vụ Đông Xuân 2025'), findsOneWidget);
    expect(find.text('Trang trại Đông Hải · Vụ Đông 2025'), findsOneWidget);
    expect(find.text('Lịch sử phân công'), findsOneWidget);
    expect(find.text('Ao A3'), findsOneWidget);
    expect(find.text('Vụ nuôi: Vụ Hè Thu 2026'), findsOneWidget);
    expect(find.text('25/06/2026-30/09/2026'), findsOneWidget);
    expect(find.text('Điều chuyển nhân sự'), findsOneWidget);
    expect(
      find.byKey(const Key('personnel_current_assignment_assignment-a5')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.layers_rounded), findsOneWidget);
    expect(find.text('0912345678'), findsOneWidget);
    expect(repository.detailCalls, 1);

    final historyCard = find.byKey(
      const Key('personnel_assignment_history_assignment-a3'),
    );
    await tester.ensureVisible(historyCard);
    await tester.pumpAndSettle();
    await tester.tap(historyCard);
    await tester.pumpAndSettle();

    final seasonPage = tester.widget<SeasonDetailPage>(
      find.byType(SeasonDetailPage),
    );
    expect(seasonPage.farmId, 'farm-1');
    expect(seasonPage.pondId, 'pond-a3');
    expect(seasonPage.seasonId, 'season-a3');
    expect(seasonRepository.requestedSeasonId, 'season-a3');
    expect(find.text('Không tìm thấy vụ nuôi thử nghiệm.'), findsOneWidget);

    final context = tester.element(find.byType(SeasonDetailPage));
    ProviderScope.containerOf(context).read(appRouterProvider).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('personnel_detail_name')), findsOneWidget);
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
  activatedAt: _activatedAt,
  updatedAt: _updatedAt,
);
final _createdAt = DateTime(2026, 9, 1);
final _activatedAt = DateTime(2024, 11, 15);
final _updatedAt = DateTime(2026, 9, 22);
final _personnelDetail = ManagedPersonnelDetail(
  personnel: _personnel,
  kpi: const PersonnelKpi(
    seasonsParticipated: 3,
    completedTasks: 3,
    onTimeCompletedTasks: 0,
    onTimeCompletionRatePct: 0,
  ),
  currentAssignments: <PersonnelSeasonAssignment>[
    PersonnelSeasonAssignment(
      id: 'assignment-a5',
      seasonId: 'season-a5',
      seasonName: 'Vụ Đông Xuân 2025',
      farmId: 'farm-1',
      farmName: 'Trang trại Của Lập',
      pondId: 'pond-a5',
      pondName: 'Ao A5',
      assignedAt: DateTime(2025, 1, 1),
    ),
    PersonnelSeasonAssignment(
      id: 'assignment-d2',
      seasonId: 'season-d2',
      seasonName: 'Vụ Đông 2025',
      farmId: 'farm-2',
      farmName: 'Trang trại Đông Hải',
      pondId: 'pond-d2',
      pondName: 'Ao D2',
      assignedAt: DateTime(2025, 2, 1),
    ),
  ],
  assignmentHistory: <PersonnelSeasonAssignment>[
    PersonnelSeasonAssignment(
      id: 'assignment-a3',
      seasonId: 'season-a3',
      seasonName: 'Vụ Hè Thu 2026',
      farmId: 'farm-1',
      farmName: 'Trang trại Của Lập',
      pondId: 'pond-a3',
      pondName: 'Ao A3',
      assignedAt: DateTime(2026, 6, 25),
      unassignedAt: DateTime(2026, 9, 30),
      replacementReason: 'Điều chuyển nhân sự',
    ),
  ],
);

final class _UnavailableSeasonRepository implements SeasonRepository {
  String? requestedSeasonId;

  @override
  Future<AquacultureSeason> getSeason(String seasonId) async {
    requestedSeasonId = seasonId;
    throw const ApiException(
      'Không tìm thấy vụ nuôi thử nghiệm.',
      statusCode: 404,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
  int listCalls = 0;
  int detailCalls = 0;

  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) async {
    listCalls++;
    lastSearch = search;
    return ManagedPersonnelPage(
      items: role == AccountRole.expert
          ? const <ManagedPersonnel>[]
          : <ManagedPersonnel>[_personnel],
      limit: 20,
      totalResults: role == AccountRole.expert ? 0 : 1,
      hasNextPage: false,
    );
  }

  @override
  Future<ManagedPersonnelDetail> getPersonnelById(String personnelId) async {
    detailCalls++;
    return _personnelDetail;
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
