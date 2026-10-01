import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';
import 'package:smartshrimp_app/features/season/presentation/pages/season_detail_page.dart';
import 'package:smartshrimp_app/features/season/presentation/pages/season_personnel_assignment_page.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

void main() {
  testWidgets('assignment button opens the matching personnel UI', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/farms/farm-1/ponds/pond-1/seasons/season-1',
      routes: <RouteBase>[
        GoRoute(
          path: '/farms/:farmId/ponds/:pondId/seasons/:seasonId',
          builder: (_, state) => SeasonDetailPage(
            farmId: state.pathParameters['farmId']!,
            pondId: state.pathParameters['pondId']!,
            seasonId: state.pathParameters['seasonId']!,
          ),
          routes: <RouteBase>[
            GoRoute(
              path: 'personnel-assignments',
              builder: (_, state) => SeasonPersonnelAssignmentPage(
                farmId: state.pathParameters['farmId']!,
                seasonId: state.pathParameters['seasonId']!,
              ),
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
          seasonRepositoryProvider.overrideWithValue(_SeasonRepository()),
          personnelRepositoryProvider.overrideWithValue(_PersonnelRepository()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.byKey(const Key('open_personnel_assignment'));
    expect(button, findsOneWidget);
    expect(find.text('Phân công'), findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(SeasonPersonnelAssignmentPage), findsOneWidget);
    expect(find.text('Phân công nhân sự'), findsOneWidget);
    expect(find.byKey(const Key('assignment_role_technician')), findsOneWidget);
    expect(find.byIcon(Icons.engineering_rounded), findsNothing);
    expect(find.byIcon(Icons.health_and_safety_rounded), findsNothing);
    expect(find.byIcon(Icons.waves_rounded), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('Nguyễn Văn Kỹ Thuật'), findsOneWidget);
  });
}

const _owner = AuthAccount(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  role: AccountRole.farmOwner,
  status: AccountStatus.active,
);

final _season = AquacultureSeason(
  id: 'season-1',
  pondId: 'pond-1',
  name: 'Vụ nuôi tháng 9',
  shrimpType: ShrimpType.whiteleg,
  status: SeasonStatus.planning,
  createdBy: 'owner-1',
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 30),
  pond: const Pond(
    id: 'pond-1',
    farmId: 'farm-1',
    name: 'Ao A1',
    areaM2: 1200,
    type: PondType.aquaculture,
    status: PondStatus.available,
    farm: PondFarm(id: 'farm-1', name: 'Trại Cà Mau'),
  ),
);

final _technician = ManagedPersonnel(
  id: 'personnel-1',
  email: 'technician@smartshrimp.vn',
  fullName: 'Nguyễn Văn Kỹ Thuật',
  role: AccountRole.technician,
  status: AccountStatus.active,
  currentSeasonAssignments: 1,
  createdAt: DateTime.utc(2026, 9, 1),
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

final class _SeasonRepository implements SeasonRepository {
  @override
  Future<AquacultureSeason> getSeason(String seasonId) async => _season;

  @override
  Future<SeasonAssignment> assignPersonnel({
    required String seasonId,
    required String accountId,
    required AccountRole role,
  }) => throw UnimplementedError();

  @override
  Future<AquacultureSeason> activateSeason(AquacultureSeason current) =>
      throw UnimplementedError();

  @override
  Future<SeasonCancellationResult> cancelSeason({
    required AquacultureSeason current,
    required String reason,
  }) => throw UnimplementedError();

  @override
  Future<AquacultureSeason> createSeason({
    required String pondId,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
  }) => throw UnimplementedError();

  @override
  Future<SeasonPage> getSeasons({
    String? farmId,
    String? pondId,
    SeasonStatus? status,
    String search = '',
    String? cursor,
    int limit = 20,
  }) => throw UnimplementedError();

  @override
  Future<SeasonPersonnelReplacementResult> replacePersonnel({
    required String seasonId,
    required String accountId,
    required AccountRole role,
    required String expectedAssignmentId,
    required String reason,
  }) => throw UnimplementedError();

  @override
  Future<AquacultureSeason> updateSeason({
    required AquacultureSeason current,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
  }) => throw UnimplementedError();
}

final class _PersonnelRepository implements PersonnelRepository {
  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) async => ManagedPersonnelPage(
    items: role == AccountRole.technician
        ? <ManagedPersonnel>[_technician]
        : <ManagedPersonnel>[],
    limit: limit,
    totalResults: role == AccountRole.technician ? 1 : 0,
    hasNextPage: false,
  );

  @override
  Future<ManagedPersonnelDetail> getPersonnelById(String personnelId) =>
      throw UnimplementedError();
}
