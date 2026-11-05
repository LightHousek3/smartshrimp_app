import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis_image.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/repositories/ai_diagnosis_repository.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_page.dart'
    as pages;
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/pages/ai_diagnosis_detail_page.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/view_models/ai_diagnosis_controller.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/widgets/ai_diagnosis_photos.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import '../../support/load_app_fonts.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'ai_diagnosis_fixtures.dart';

class FailedHistory extends DiagnosisFixtureRepository {
  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async =>
      throw const ApiException('Không được phép xem lịch sử.', statusCode: 403);
}

class ClassificationFixtureRepository extends DiagnosisFixtureRepository {
  ClassificationFixtureRepository(String label) {
    result = AiDiagnosisDetail.parse(diagnosisJson(predictedLabel: label));
  }

  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async =>
      (await super.list(seasonId, cursor: cursor)).copyWith(
        items: [
          AiDiagnosisSummary.parse({
            ...summaryJson(),
            'predictedLabel': result.toJson()['predictedLabel'],
          }),
        ],
      );
}

class PendingDiagnosis extends DiagnosisFixtureRepository {
  final completion = Completer<AiDiagnosisDetail>();
  @override
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) {
    creates++;
    return completion.future;
  }
}

Future<ProviderContainer> mount(
  WidgetTester tester, {
  bool detail = false,
  DiagnosisFixtureRepository? repository,
  DiagnosisFixturePicker? picker,
  double width = 402,
  double textScale = 1,
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
}) async {
  tester.view.physicalSize = Size(width, 875);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final c = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const DashboardFixtureAuth(role: AccountRole.technician),
      ),
      assignedSeasonRepositoryProvider.overrideWithValue(
        DiagnosisFixtureSeasons()..status = status,
      ),
      aiDiagnosisRepositoryProvider.overrideWithValue(
        repository ?? DiagnosisFixtureRepository(),
      ),
      aiDiagnosisImagePickerProvider.overrideWithValue(
        picker ?? DiagnosisFixturePicker(),
      ),
    ],
  );
  addTearDown(c.dispose);
  await c.read(authControllerProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: AppTheme.light,
        builder: (_, child) => MediaQuery(
          data: MediaQueryData(
            size: Size(width, 875),
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: Scaffold(
          body: RepaintBoundary(
            key: const Key('ai-snapshot'),
            child: detail
                ? const AiDiagnosisDetailPage(
                    seasonId: 'season',
                    diagnosisId: 'diagnosis',
                  )
                : const pages.AiDiagnosisPage(seasonId: 'season'),
          ),
        ),
      ),
    ),
  );
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  await tester.pumpAndSettle();
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  await tester.pumpAndSettle();
  return c;
}

Future<void> capture(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('AI_UI_EVIDENCE')) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('ai-snapshot')),
  );
  debugDisableShadows = false;
  void repaint(RenderObject object) {
    object.markNeedsPaint();
    object.visitChildren(repaint);
  }

  repaint(boundary);
  await tester.pump();
  try {
    await tester.runAsync(() async {
      final image = await boundary.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('../.tmp/ai-app-ui-review');
      await dir.create(recursive: true);
      await File(
        '${dir.path}/$name.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  } finally {
    debugDisableShadows = true;
  }
}

void main() {
  setUpAll(loadAppFonts);
  testWidgets(
    'N: POST reloads history and opens detail, with no extra reload when returning',
    (tester) async {
      final repo = PersistedDiagnosisRepository();
      repo.result = repo.result.copyWith(id: 'created');
      final c = await mount(tester, repository: repo);
      final router = GoRouter(
        initialLocation: '/seasons/season/ai-diagnoses',
        routes: [
          GoRoute(
            path: '/seasons/:seasonId/ai-diagnoses',
            builder: (_, _) =>
                const Scaffold(body: pages.AiDiagnosisPage(seasonId: 'season')),
            routes: [
              GoRoute(
                path: ':diagnosisId',
                builder: (_, state) => Scaffold(
                  body: AiDiagnosisDetailPage(
                    seasonId: 'season',
                    diagnosisId: state.pathParameters['diagnosisId']!,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final initialLists = repo.lists;
      await c
          .read(aiDiagnosisDraftProvider('season').notifier)
          .pick(AiImageSource.gallery);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yêu cầu AI nhận diện'));
      await tester.pumpAndSettle();
      expect(find.text('Chi tiết nhận diện AI'), findsOneWidget);
      expect(repo.creates, 1);
      expect(repo.details, 1);
      expect(repo.lists, initialLists + 1);
      router.pop();
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('ai-diagnosis-created')),
        findsOneWidget,
      );
      expect(repo.lists, initialLists + 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N/B: scrolling loads 10 more rows, does not duplicate pending requests and stops at the end',
    (tester) async {
      final repo = PaginatedDiagnosisRepository()..secondPage = Completer();
      final c = await mount(tester, repository: repo);
      expect(repo.cursors, [null]);
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        10,
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1400));
      await tester.pump();
      expect(repo.cursors, [null, 'cursor-10']);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pump();
      expect(repo.lists, 2);
      repo.secondPage!.complete(paginatedDiagnosisPage(10));
      await tester.pumpAndSettle();
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        20,
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1600));
      await tester.pumpAndSettle();
      expect(repo.cursors, [null, 'cursor-10', 'cursor-20']);
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        25,
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1600));
      await tester.pumpAndSettle();
      expect(repo.lists, 3);
      expect(find.text('Xem thêm'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('A: scrolling does not automatically retry a failed page', (
    tester,
  ) async {
    final repo = PaginatedDiagnosisRepository()..failNextPage = true;
    await mount(tester, repository: repo);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1400));
    await tester.pumpAndSettle();
    expect(repo.lists, 2);
    expect(find.text('Không tải được trang tiếp theo.'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(repo.lists, 2);
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(repo.cursors, [null, 'cursor-10', 'cursor-10']);
    expect(tester.takeException(), isNull);
  });
  for (final entry in const {
    'Khỏe mạnh': 'Khỏe mạnh',
    'Mang đen': 'Mang đen',
    'Đốm trắng': 'Đốm trắng',
    'Đốm trắng và mang đen': 'Đốm trắng và mang đen',
  }.entries) {
    testWidgets('N: history displays the BE class ${entry.key}', (
      tester,
    ) async {
      await mount(
        tester,
        repository: ClassificationFixtureRepository(entry.key),
        width: 320,
        textScale: 1.5,
      );
      await tester.scrollUntilVisible(
        find.text(entry.value),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(entry.value), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('N: detail displays the BE class ${entry.key}', (tester) async {
      await mount(
        tester,
        detail: true,
        repository: ClassificationFixtureRepository(entry.key),
      );
      expect(find.text(entry.value), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
      final status = find.text('● Thành công');
      final header = find
          .ancestor(of: status, matching: find.byType(Row))
          .first;
      expect(
        tester.getRect(status).right,
        closeTo(tester.getRect(header).right - 10, 0.5),
      );
      expect(
        tester.getRect(find.text(entry.value)).right,
        lessThan(tester.getRect(status).left),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'B: five selected images cannot be edited or resubmitted while processing',
    (tester) async {
      final repo = PendingDiagnosis();
      final picker = DiagnosisFixturePicker()
        ..selection = List.filled(5, sampleImage());
      final c = await mount(tester, repository: repo, picker: picker);
      await c
          .read(aiDiagnosisDraftProvider('season').notifier)
          .pick(AiImageSource.gallery);
      await tester.pumpAndSettle();
      expect(find.text('5/5 ảnh'), findsOneWidget);
      expect(find.text('Thêm ảnh'), findsNothing);
      await capture(tester, 'five-images');
      await tester.tap(find.text('Yêu cầu AI nhận diện'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Đang phân tích ảnh…'), findsOneWidget);
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      expect(repo.creates, 1);
      await capture(tester, 'processing');
      repo.completion.completeError(const NetworkException());
      await tester.pumpAndSettle();
      expect(find.textContaining('Kiểm tra lịch sử nhận diện'), findsOneWidget);
      expect(find.text('5/5 ảnh'), findsOneWidget);
      expect(repo.creates, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('N: empty form, real history labels, and disabled submit', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('0/5 ảnh'), findsOneWidget);
    expect(
      tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
      isNull,
    );
    expect(find.text('Đốm trắng'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.textContaining('https://'), findsNothing);
    await capture(tester, 'empty');
    expect(tester.takeException(), isNull);
  });
  testWidgets('N: classification info describes the four supported groups', (
    tester,
  ) async {
    await mount(tester, width: 320, textScale: 1.5);
    final info = find.byKey(const Key('ai-classification-info'));
    expect(
      find.descendant(of: info, matching: find.text('Hỗ trợ dự đoán 4 nhóm')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: info,
        matching: find.text(
          'Khỏe mạnh · Mang đen · Đốm trắng · Đốm trắng và mang đen',
        ),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('N/B: selecting, viewing, and removing photos updates the form', (
    tester,
  ) async {
    final c = await mount(tester);
    await c
        .read(aiDiagnosisDraftProvider('season').notifier)
        .pick(AiImageSource.gallery);
    await tester.pumpAndSettle();
    expect(find.text('1/5 ảnh'), findsOneWidget);
    expect(
      tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
      isNotNull,
    );
    await capture(tester, 'selected');
    await tester.tap(find.bySemanticsLabel('Xem ảnh 1').first);
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byType(AiDiagnosisImageViewer), findsOneWidget);
    expect(find.text('Ảnh 1/1'), findsOneWidget);
    await tester.tap(find.byTooltip('Đóng'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Xóa ảnh 1'));
    await tester.pumpAndSettle();
    expect(find.text('0/5 ảnh'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'N: picker sheet offers camera and library, cancel does not mutate draft',
    (tester) async {
      await mount(tester);
      await tester.tap(find.text('Chọn ảnh mẫu tôm'));
      await tester.pumpAndSettle();
      expect(find.text('Chụp ảnh'), findsOneWidget);
      expect(find.text('Chọn từ thư viện'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('0/5 ảnh'), findsOneWidget);
    },
  );
  testWidgets('A: backend authorization error is readable and retryable', (
    tester,
  ) async {
    await mount(tester, repository: FailedHistory());
    expect(find.text('Không được phép xem lịch sử.'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });
  testWidgets('N: completed season retains history and hides the upload form', (
    tester,
  ) async {
    await mount(tester, status: AssignedSeasonStatus.completed);
    expect(find.text('Lịch sử nhận diện'), findsOneWidget);
    expect(find.byType(GradientButton), findsNothing);
  });
  testWidgets(
    'N: detail shows confidence, gallery and a disabled case action without exposing URLs',
    (tester) async {
      await mount(tester, detail: true);
      expect(find.text('Đốm trắng'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
      expect(find.text('1,406 s'), findsOneWidget);
      await capture(tester, 'detail');
      await tester.scrollUntilVisible(
        find.text('Tạo ca bệnh từ kết quả này'),
        150,
      );
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Tạo ca bệnh từ kết quả này'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
      expect(
        find.byTooltip('Chưa hỗ trợ tạo ca bệnh từ kết quả AI.'),
        findsOneWidget,
      );
      expect(find.textContaining('https://'), findsNothing);
      expect(find.textContaining('signature=private'), findsNothing);
      await capture(tester, 'detail-bottom');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'A: technical failure has no confidence, recommendation or case action',
    (tester) async {
      final repo = DiagnosisFixtureRepository()
        ..result = AiDiagnosisDetail.parse(diagnosisJson(error: true));
      await mount(tester, detail: true, repository: repo);
      expect(find.text('Nhận diện không thành công'), findsOneWidget);
      expect(find.text('Dịch vụ nhận diện chưa sẵn sàng.'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text('Tạo ca bệnh từ kết quả này'), findsNothing);
      await capture(tester, 'detail-error');
      expect(tester.takeException(), isNull);
    },
  );
  for (final detail in [false, true]) {
    testWidgets(
      'B: ${detail ? 'detail' : 'form'} fits a narrow screen with enlarged text',
      (tester) async {
        await mount(tester, detail: detail, width: 320, textScale: 1.5);
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
