import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_page.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart'
    show AiDiagnosisDetail;
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_detail_page.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/view_models/ai_diagnosis_controller.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/pages/disease_case_form_page.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/view_models/disease_case_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import '../../support/load_app_fonts.dart';
import '../disease_case/disease_case_test.dart' show CaseFixtureRepository;
import '../home/owner_dashboard_fixtures.dart';
import 'ai_diagnosis_fixtures.dart';

Future<GoRouter> mountFlow(
  WidgetTester tester,
  CaseFixtureRepository cases, {
  String location = '/seasons/season/ai-diagnoses/diagnosis',
  DiagnosisFixtureRepository? diagnoses,
}) async {
  tester.view.physicalSize = const Size(390, 875);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const DashboardFixtureAuth(role: AccountRole.technician),
      ),
      assignedSeasonRepositoryProvider.overrideWithValue(
        DiagnosisFixtureSeasons(),
      ),
      aiDiagnosisRepositoryProvider.overrideWithValue(
        diagnoses ?? DiagnosisFixtureRepository(),
      ),
      diseaseCaseRepositoryProvider.overrideWithValue(cases),
      notificationSocketProvider.overrideWithValue(null),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  final rootNavigator = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: location,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => Scaffold(body: shell),
        branches: [
          StatefulShellBranch(
            initialLocation: '/seasons/season',
            routes: [
              GoRoute(
                path: '/seasons/:seasonId',
                builder: (_, _) => const Scaffold(body: Text('Vụ nuôi')),
                routes: [
                  GoRoute(
                    path: 'ai-diagnoses',
                    parentNavigatorKey: rootNavigator,
                    builder: (_, state) => AiDiagnosisPage(
                      seasonId: 'season',
                      selectForCase:
                          state.uri.queryParameters['selectForCase'] == '1',
                    ),
                    routes: [
                      GoRoute(
                        path: ':diagnosisId',
                        parentNavigatorKey: rootNavigator,
                        builder: (_, state) => AiDiagnosisDetailPage(
                          seasonId: 'season',
                          diagnosisId: state.pathParameters['diagnosisId']!,
                          selectForCase:
                              state.uri.queryParameters['selectForCase'] == '1',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'disease-cases',
                    builder: (_, _) =>
                        const Scaffold(body: Text('Danh sách ca bệnh')),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, state) => DiseaseCaseFormPage(
                          seasonId: 'season',
                          initialAiDiagnosisId:
                              state.uri.queryParameters['aiDiagnosisId'],
                        ),
                      ),
                      GoRoute(
                        path: 'create-from-ai',
                        parentNavigatorKey: rootNavigator,
                        builder: (_, state) => DiseaseCaseFormPage(
                          seasonId: 'season',
                          initialAiDiagnosisId:
                              state.uri.queryParameters['aiDiagnosisId'],
                        ),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, _) =>
                            const Scaffold(body: Text('Ca đã tạo')),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

Future<void> press(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);
  tearDown(AppNoticeService.hide);

  testWidgets(
    'opens the case form from pushed AI overlays above the season tab',
    (tester) async {
      final cases = CaseFixtureRepository()..empty = true;
      final router = await mountFlow(
        tester,
        cases,
        location: '/seasons/season',
      );
      router.push('/seasons/season/ai-diagnoses');
      await tester.pumpAndSettle();
      await press(tester, 'Đốm trắng');
      await press(tester, 'Tạo ca bệnh từ kết quả này');
      expect(tester.takeException(), isNull);
      expect(find.byType(DiseaseCaseFormPage), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.byType(AiDiagnosisDetailPage), findsOneWidget);

      await press(tester, 'Tạo ca bệnh từ kết quả này');
      await tester.enterText(find.byType(TextFormField).first, 'Tôm giảm ăn');
      await tester.enterText(find.byType(TextFormField).last, 'Quan sát nhá');
      await press(tester, 'Gửi cho chuyên gia');
      expect(tester.takeException(), isNull);
      expect(cases.selectedAi, 'diagnosis');
      expect(cases.mutations, 1);
      expect(find.text('Ca đã tạo'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Danh sách ca bệnh'), findsOneWidget);
    },
  );

  for (final recognized in [true, false]) {
    testWidgets(
      'a successful advisory result remains linkable (recognized: $recognized)',
      (tester) async {
        final cases = CaseFixtureRepository()..empty = true;
        final diagnoses = DiagnosisFixtureRepository()
          ..result = AiDiagnosisDetail.parse(
            diagnosisJson(
              predictedLabel: 'Khỏe mạnh',
              recognized: recognized,
              confidence: recognized ? 0.9 : 0.6,
            ),
          );
        await mountFlow(tester, cases, diagnoses: diagnoses);
        await press(tester, 'Tạo ca bệnh từ kết quả này');
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
        expect(cases.mutations, 0);
      },
    );
  }

  testWidgets(
    'an inaccessible or foreign AI link can be removed without blocking a manual case',
    (tester) async {
      final cases = CaseFixtureRepository()..empty = true;
      final diagnoses = DiagnosisFixtureRepository();
      diagnoses.result = diagnoses.result.copyWith(seasonId: 'another-season');
      await mountFlow(
        tester,
        cases,
        diagnoses: diagnoses,
        location:
            '/seasons/season/disease-cases/create?aiDiagnosisId=diagnosis',
      );
      await tester.enterText(
        find.byType(TextFormField).first,
        'Ca không có AI',
      );
      await tester.enterText(find.byType(TextFormField).last, 'Tôm giảm ăn');
      await press(tester, 'Bỏ liên kết này');
      await press(tester, 'Gửi cho chuyên gia');
      expect(cases.selectedAi, isNull);
      expect(cases.mutations, 1);
      expect(find.text('Ca đã tạo'), findsOneWidget);
    },
  );

  testWidgets(
    'a failed eligibility request is shown without guessing that a case can be created',
    (tester) async {
      final cases = CaseFixtureRepository()
        ..failure = const NetworkException('Không thể kiểm tra ca bệnh.');
      await mountFlow(tester, cases);
      await press(tester, 'Tạo ca bệnh từ kết quả này');
      expect(find.text('Không thể kiểm tra ca bệnh.'), findsOneWidget);
      expect(find.byType(DiseaseCaseFormPage), findsNothing);
      expect(cases.mutations, 0);
    },
  );

  testWidgets(
    'AI links its exact result even outside the latest options and requires manual submission',
    (tester) async {
      final cases = CaseFixtureRepository()..empty = true;
      await mountFlow(tester, cases);
      await press(tester, 'Tạo ca bệnh từ kết quả này');
      expect(cases.mutations, 0);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).first)
            .controller!
            .text,
        isEmpty,
      );
      await tester.enterText(find.byType(TextFormField).first, 'Tôm giảm ăn');
      await tester.enterText(
        find.byType(TextFormField).last,
        'Quan sát phân và nhá',
      );
      await press(tester, 'Gửi cho chuyên gia');
      expect(cases.selectedAi, 'diagnosis');
      expect(cases.mutations, 1);
      expect(find.text('Ca đã tạo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an unresolved case blocks the AI shortcut before a new form opens',
    (tester) async {
      final cases = CaseFixtureRepository()
        ..canCreate = false
        ..existingCaseId = 'case';
      await mountFlow(tester, cases);
      await press(tester, 'Tạo ca bệnh từ kết quả này');
      expect(find.text(DiseaseCaseRules.existingCaseMessage), findsOneWidget);
      expect(find.byType(DiseaseCaseFormPage), findsNothing);
      expect(cases.mutations, 0);
    },
  );

  testWidgets('a direct create route also refuses an unresolved case', (
    tester,
  ) async {
    final cases = CaseFixtureRepository()
      ..canCreate = false
      ..existingCaseId = 'case';
    await mountFlow(
      tester,
      cases,
      location: '/seasons/season/disease-cases/create',
    );
    expect(find.text(DiseaseCaseRules.existingCaseMessage), findsOneWidget);
    expect(find.text('Mở ca hiện tại'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
  });

  testWidgets(
    'a case created after preflight still reports the server conflict without submitting twice',
    (tester) async {
      final cases = CaseFixtureRepository()..empty = true;
      await mountFlow(tester, cases);
      await press(tester, 'Tạo ca bệnh từ kết quả này');
      await tester.enterText(find.byType(TextFormField).first, 'Tôm giảm ăn');
      await tester.enterText(find.byType(TextFormField).last, 'Tôm nổi đầu');
      cases.failure = const ApiException(
        DiseaseCaseRules.existingCaseMessage,
        statusCode: 409,
      );
      await press(tester, 'Gửi cho chuyên gia');
      expect(find.text(DiseaseCaseRules.existingCaseMessage), findsWidgets);
      expect(find.text('Ca đã tạo'), findsNothing);
      expect(cases.mutations, 1);
    },
  );

  testWidgets(
    'choosing AI from a draft returns to that draft instead of creating another form',
    (tester) async {
      final cases = CaseFixtureRepository()..empty = true;
      await mountFlow(
        tester,
        cases,
        location: '/seasons/season/disease-cases/create',
      );
      await tester.enterText(find.byType(TextFormField).first, 'Ca đang soạn');
      await tester.enterText(
        find.byType(TextFormField).last,
        'Nội dung đang nhập',
      );
      await press(tester, 'Xem lịch sử AI');
      await press(tester, 'Đốm trắng');
      await press(tester, 'Dùng kết quả này cho ca bệnh');
      expect(find.text('Ca đang soạn'), findsOneWidget);
      expect(find.text('Nội dung đang nhập'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(cases.mutations, 0);
    },
  );
}
