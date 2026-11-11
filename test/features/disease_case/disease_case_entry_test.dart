import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/presentation.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_page.dart'
    as ai_pages;
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_detail_page.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/view_models/ai_diagnosis_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../home/technician_dashboard_fixtures.dart';
import 'disease_case_test.dart' show CaseFixtureRepository;
import '../ai_diagnosis/ai_diagnosis_fixtures.dart'
    show DiagnosisFixtureRepository, summaryJson;
import '../../support/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);
  for (final status in [
    AssignedSeasonStatus.active,
    AssignedSeasonStatus.completed,
  ]) {
    testWidgets(
      'KTV opens case list from $status season through the application router',
      (tester) async {
        GoogleFonts.config.allowRuntimeFetching = false;
        tester.view.physicalSize = const Size(420, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final cases = CaseFixtureRepository()
          ..canCreate = status == AssignedSeasonStatus.active
          ..options = CaseCreationOptions(aiDiagnoses: [summaryJson()]);
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const DashboardFixtureAuth(role: AccountRole.technician),
            ),
            assignedSeasonRepositoryProvider.overrideWithValue(
              _Seasons(status),
            ),
            assignedSeasonTodayOperationsProvider(
              'season',
            ).overrideWith((ref) async => []),
            diseaseCaseRepositoryProvider.overrideWithValue(cases),
            aiDiagnosisRepositoryProvider.overrideWithValue(
              DiagnosisFixtureRepository(),
            ),
            technicianDashboardRepositoryProvider.overrideWithValue(
              TechnicianFixtureRepository(),
            ),
            notificationRepositoryProvider.overrideWithValue(
              DashboardFixtureNotifications(),
            ),
            notificationSocketProvider.overrideWith((ref) => null),
            latestWaterLogProvider('season').overrideWith((ref) async => null),
            waterLogMetadataProvider('season').overrideWith(
              (ref) async => WaterLogMetadata.legacy(ShrimpType.whiteleg),
            ),
          ],
        );
        addTearDown(container.dispose);
        await container.read(authControllerProvider.future);
        container.read(appRouterProvider).go('/seasons/season');
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const SmartShrimpApp(),
          ),
        );
        await tester.pumpAndSettle();
        final entry = find.text(
          status == AssignedSeasonStatus.active ? 'Ca bệnh' : 'Xem ca bệnh',
        );
        await tester.scrollUntilVisible(
          entry,
          240,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(entry);
        await tester.pumpAndSettle();
        expect(
          GoRouterState.of(
            tester.element(find.byType(DiseaseCaseListPage)),
          ).uri.path,
          '/seasons/season/disease-cases',
        );
        expect(find.byType(DiseaseCaseListPage), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);
        expect(find.text('Tôm giảm ăn'), findsOneWidget);
        expect(cases.lists, 1);
        expect(find.text('Ca bệnh đang được phát triển.'), findsNothing);
        if (status == AssignedSeasonStatus.active) {
          await tester.tap(find.text('Tạo ca bệnh'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseFormPage), findsOneWidget);
          expect(
            GoRouterState.of(
              tester.element(find.byType(DiseaseCaseFormPage)),
            ).uri.path,
            '/seasons/season/disease-cases/create',
          );
          await tester.enterText(
            find.byType(TextFormField).first,
            'Ca đang soạn',
          );
          await tester.enterText(
            find.byType(TextFormField).last,
            'Tôm giảm ăn',
          );
          await tester.scrollUntilVisible(
            find.text('Đốm trắng'),
            200,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Đốm trắng'));
          await tester.ensureVisible(find.text('Xem lịch sử AI'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Xem lịch sử AI'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byType(ai_pages.AiDiagnosisPage), findsOneWidget);
          expect(find.byType(NavigationBar), findsNothing);
          await tester.scrollUntilVisible(
            find.byKey(const ValueKey('ai-diagnosis-diagnosis')),
            200,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find.byKey(const ValueKey('ai-diagnosis-diagnosis')),
          );
          await tester.pumpAndSettle();
          expect(find.byType(AiDiagnosisDetailPage), findsOneWidget);
          await tester.tap(find.byTooltip('Quay lại'));
          await tester.pumpAndSettle();
          expect(find.byType(ai_pages.AiDiagnosisPage), findsOneWidget);
          await tester.tap(find.byTooltip('Quay lại'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseFormPage), findsOneWidget);
          expect(find.text('Ca đang soạn'), findsOneWidget);
          expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

          await tester.ensureVisible(find.byTooltip('Xem chi tiết kết quả AI'));
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Xem chi tiết kết quả AI'));
          await tester.pumpAndSettle();
          expect(find.byType(AiDiagnosisDetailPage), findsOneWidget);
          expect(find.byType(NavigationBar), findsNothing);
          await tester.tap(find.byTooltip('Quay lại'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseFormPage), findsOneWidget);
          expect(find.text('Ca đang soạn'), findsOneWidget);
          expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
          await tester.tap(find.byTooltip('Quay lại'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseListPage), findsOneWidget);
          await tester.tap(find.text('Tôm giảm ăn'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseDetailPage), findsOneWidget);
          expect(find.byType(NavigationBar), findsNothing);
          await tester.tap(find.byTooltip('Quay lại'));
          await tester.pumpAndSettle();
          expect(find.byType(DiseaseCaseListPage), findsOneWidget);
        } else {
          expect(find.text('Tạo ca bệnh'), findsNothing);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}

class _Seasons implements AssignedSeasonRepository {
  _Seasons(this.status);
  final AssignedSeasonStatus status;
  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async =>
      AssignedSeasonDetail(
        id: seasonId,
        name: 'Vụ kiểm thử',
        status: status,
        shrimpType: ShrimpType.whiteleg,
        pondId: 'pond',
        pondName: 'Ao kiểm thử',
        pondType: 'LINED',
        pondStatus: 'ACTIVE',
        farmId: 'farm',
        farmName: 'Trại kiểm thử',
        personnel: [],
        otherAssignedSeasons: [],
        assignedAt: DateTime(2026),
      );
  @override
  Future<List<AssignedSeasonFarm>> getAssignedSeasonFarms() async => [];
  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = AssignedSeasonRules.pageSize,
  }) async => const AssignedSeasonPage(
    items: [],
    totalResults: 0,
    activeResults: 0,
    allResults: 0,
    hasNextPage: false,
  );
}
