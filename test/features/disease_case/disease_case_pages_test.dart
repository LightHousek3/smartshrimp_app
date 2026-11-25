import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/disease_case/domain/entities/owner_disease_case.dart';
import 'package:smartshrimp_app/features/disease_case/domain/repositories/owner_disease_case_repository.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/view_models/owner_disease_case_controller.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/disease_case_detail_sections.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/disease_case_ui.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart'
    as dashboard;
import 'package:smartshrimp_app/features/home/domain/repositories/owner_dashboard_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';

import '../home/owner_dashboard_fixtures.dart';
import '../../support/disabled_push_repository.dart';

const _case = DiseaseCaseCard(
  id: 'case-a3',
  title: 'Nghi phân trắng & mềm vỏ — Ao A3',
  description:
      'Quan sát phân trắng rải rác ở nhá, một số tôm mềm vỏ, giảm bắt mồi nhẹ ở cữ chiều. Kèm ảnh nhá và mẫu tôm.',
  status: DiseaseCaseStatus.inTreatment,
  severity: DiseaseCaseSeverity.high,
  expertName: 'TS. Phạm Hải Đăng',
  responseCount: 1,
  aiDiagnosis: 'White Feces Syndrome (nghi ngờ)',
);

DiseaseCasePage _page({
  List<DiseaseCaseCard> items = const [],
  int resolvedCount = 0,
  bool hasNextPage = false,
  int page = 1,
}) => DiseaseCasePage(
  items: items,
  seasonName: 'Vụ Đông Xuân 2025',
  pondName: 'Ao A3',
  activeCount: 1,
  resolvedCount: resolvedCount,
  page: page,
  hasNextPage: hasNextPage,
);

DiseaseCaseDetail _detail() {
  final openedAt = DateTime.utc(2026, 9, 5, 10, 20);
  return DiseaseCaseDetail(
    card: _case,
    seasonName: 'Vụ Đông Xuân 2025',
    pondName: 'Ao A3',
    farmName: 'Trang trại Cửa Lấp',
    reporterName: 'Cô Thái Bảo',
    createdAt: openedAt,
    updatedAt: openedAt.add(const Duration(hours: 1)),
    snapshot: DiseaseCaseSnapshot(
      exceededWaterMetrics: const ['no2MgL', 'nh3MgL'],
      capturedAt: openedAt.subtract(const Duration(minutes: 10)),
      healthRecordedAt: openedAt.subtract(const Duration(minutes: 20)),
      healthStatus: OpeningHealthStatus.warning,
      avgWeightG: 11.9,
      mortalityCount: 38,
      ph: 8.4,
      no2MgL: 1.7,
      nh3MgL: .24,
    ),
    attachments: [
      DiseaseCaseAttachment(
        fileUrl: 'https://example.com/photo.jpg',
        uploaderName: 'Cô Thái Bảo',
        createdAt: openedAt,
        mediaType: 'image/jpeg',
        caption: 'Ảnh nhá có phân trắng',
      ),
    ],
    protocols: const [
      DiseaseCaseProtocol(
        id: 'protocol-a3',
        title: 'Phác đồ điều trị Phân trắng — Ao A3 v2',
        versionNo: 2,
        status: ProtocolStatus.pendingApproval,
      ),
    ],
    timeline: [
      DiseaseCaseEvent.status(
        at: openedAt,
        authorName: 'Cô Thái Bảo',
        toStatus: DiseaseCaseStatus.open,
      ),
      DiseaseCaseEvent.response(
        at: openedAt.add(const Duration(hours: 1)),
        authorName: 'TS. Phạm Hải Đăng',
        authorRole: AccountRole.expert,
        responseType: DiseaseCaseResponseType.expertInstruction,
        message: 'Theo dõi diễn tiến của ca bệnh.',
      ),
    ],
  );
}

class _Cases implements DiseaseCaseRepository {
  Future<DiseaseCasePage>? active;
  Future<DiseaseCasePage>? resolved;
  Future<DiseaseCaseDetail>? detailResponse;
  final requests = <(String, bool, int)>[];
  final detailIds = <String>[];

  @override
  Future<DiseaseCasePage> list({
    required String seasonId,
    required bool resolved,
    required int page,
  }) async {
    requests.add((seasonId, resolved, page));
    return resolved
        ? this.resolved ?? _page()
        : active ?? _page(items: [_case]);
  }

  @override
  Future<DiseaseCaseDetail> detail(String caseId) async {
    detailIds.add(caseId);
    return detailResponse ?? _detail();
  }
}

Future<void> _open(
  WidgetTester tester,
  _Cases repository,
  String route, {
  OwnerDashboardRepository? dashboardRepository,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = const Size(403, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      pushRepositoryProvider.overrideWithValue(const DisabledPushRepository()),
      authRepositoryProvider.overrideWithValue(DashboardFixtureAuth()),
      diseaseCaseRepositoryProvider.overrideWithValue(repository),
      ownerDashboardRepositoryProvider.overrideWithValue(
        dashboardRepository ?? DashboardFixtureRepository(),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  container.read(appRouterProvider).go(route);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const SmartShrimpApp(),
    ),
  );
  await tester.pump();
}

void main() {
  for (final (kind, label) in [
    (dashboard.DashboardAlertKind.caseOpen, 'ca bệnh đang mở'),
    (dashboard.DashboardAlertKind.inTreatment, 'ca bệnh đang điều trị'),
    (dashboard.DashboardAlertKind.monitoring, 'ca bệnh đang theo dõi'),
  ]) {
    testWidgets(
      'Owner dashboard $kind opens the real authorized case detail page',
      (tester) async {
        final repository = _Cases();
        await _open(
          tester,
          repository,
          '/',
          dashboardRepository: _DashboardCases(kind),
        );
        await tester.pumpAndSettle();
        final alert = find.text('1 $label');
        await tester.ensureVisible(alert);
        await tester.pumpAndSettle();
        await tester.tap(alert);
        await tester.pumpAndSettle();
        expect(find.text('Chi tiết ca bệnh'), findsOneWidget);
        expect(repository.detailIds, ['case-a3']);
        expect(repository.requests, isEmpty);
        expect(find.byType(BottomSheet), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'list keeps both tabs pinned, loads real counts and opens detail',
    (tester) async {
      final repository = _Cases()
        ..resolved = Future.value(
          _page(
            resolvedCount: 16,
            items: List.generate(
              16,
              (index) => _case.copyWith(
                id: 'resolved-$index',
                status: DiseaseCaseStatus.resolved,
                title: 'Ca đã đóng $index',
              ),
            ),
          ),
        );
      await _open(tester, repository, '/disease-cases?seasonId=season-a3');
      await tester.pumpAndSettle();
      expect(find.text('Đang xử lý (1)'), findsOneWidget);
      expect(find.text('Đã giải quyết (0)'), findsOneWidget);
      expect(find.text('Ao A3 · Vụ Đông Xuân 2025'), findsOneWidget);

      await tester.tap(find.text('Đã giải quyết (0)'));
      await tester.pumpAndSettle();
      expect(repository.requests, [
        ('season-a3', false, 1),
        ('season-a3', true, 1),
      ]);
      final tabs = find.text('Đã giải quyết (16)');
      final position = tester.getTopLeft(tabs);
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(tabs), position);
      expect(find.byType(StickyPageHeader), findsOneWidget);

      await tester.tap(find.text('Đang xử lý (1)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_case.title));
      await tester.pumpAndSettle();
      expect(repository.detailIds, ['case-a3']);
      expect(find.text('Chi tiết ca bệnh'), findsOneWidget);
      expect(find.text('Trang trại'), findsOneWidget);
      expect(find.text('Mở ca: 17:20 05/09/2026'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Chẩn đoán AI'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(_case.aiDiagnosis!), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'switching tabs during the first load ignores the older response',
    (tester) async {
      final initial = Completer<DiseaseCasePage>();
      final repository = _Cases()..active = initial.future;
      await _open(tester, repository, '/disease-cases?seasonId=season-a3');
      final progress = find.byType(CircularProgressIndicator);
      expect(progress, findsOneWidget);
      expect(tester.getCenter(progress).dx, closeTo(201.5, 1));
      expect(tester.getCenter(progress).dy, greaterThan(400));

      await tester.tap(find.text('Đã giải quyết'));
      await tester.pumpAndSettle();
      initial.complete(_page(items: [_case]));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có ca bệnh đã giải quyết'), findsOneWidget);
      expect(find.text('Đã giải quyết (0)'), findsOneWidget);
      expect(find.text(_case.title), findsNothing);
    },
  );

  testWidgets(
    'resolved pagination appends unique cases and keeps both counts',
    (tester) async {
      final first = _case.copyWith(
        id: 'resolved-1',
        title: 'Ca đã đóng 1',
        status: DiseaseCaseStatus.resolved,
      );
      final repository = _Cases()
        ..resolved = Future.value(
          _page(items: [first], resolvedCount: 2, hasNextPage: true),
        );
      await _open(tester, repository, '/disease-cases?seasonId=season-a3');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đã giải quyết (0)'));
      await tester.pumpAndSettle();
      repository.resolved = Future.value(
        _page(
          items: [
            first,
            first.copyWith(id: 'resolved-2', title: 'Ca đã đóng 2'),
          ],
          resolvedCount: 2,
          page: 2,
        ),
      );
      await tester.tap(find.text('Xem thêm'));
      await tester.pumpAndSettle();
      expect(repository.requests.last, ('season-a3', true, 2));
      expect(find.text('Ca đã đóng 1'), findsOneWidget);
      expect(find.text('Ca đã đóng 2'), findsOneWidget);
      expect(find.text('Đang xử lý (1)'), findsOneWidget);
      expect(find.text('Đã giải quyết (2)'), findsOneWidget);
      expect(find.text('Xem thêm'), findsNothing);
    },
  );

  testWidgets(
    'detail deep link loads directly and retries using the shared error state',
    (tester) async {
      final initial = Completer<DiseaseCaseDetail>();
      final repository = _Cases()..detailResponse = initial.future;
      await _open(tester, repository, '/disease-cases/case-a3');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      initial.completeError(
        const ApiException('Không tìm thấy ca bệnh', statusCode: 404),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.text('Không tìm thấy ca bệnh'), findsOneWidget);

      repository.detailResponse = null;
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      expect(repository.detailIds, ['case-a3', 'case-a3']);
      expect(repository.requests, isEmpty);
      final header = find.text('Chi tiết ca bệnh');
      final position = tester.getTopLeft(header);
      final scrollable = find.byType(Scrollable).first;
      for (final label in [
        'Hiện trạng khi mở ca',
        'Phác đồ điều trị',
        'Chỉ dẫn chuyên gia',
      ]) {
        await tester.scrollUntilVisible(
          find.text(label),
          150,
          scrollable: scrollable,
        );
      }
      await tester.pumpAndSettle();
      expect(find.text('Diễn biến và trách nhiệm'), findsOneWidget);
      expect(header.hitTestable(), findsOneWidget);
      expect(tester.getTopLeft(header).dx, position.dx);
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'list decoder rejects missing fields and tolerates future enum values',
    () {
      final meta = {
        'seasonName': 'Vụ A',
        'pondName': 'Ao A',
        'page': 1,
        'hasNextPage': false,
        'activeCount': 1,
        'resolvedCount': 0,
      };
      final card = _case.toJson()..['status'] = 'FUTURE_STATUS';
      expect(
        DiseaseCasePage.parse([card], meta).items.single.status,
        DiseaseCaseStatus.unknown,
      );
      expect(
        () => DiseaseCasePage.parse([card], {...meta, 'activeCount': -1}),
        throwsA(isA<InvalidResponseException>()),
      );
      card.remove('title');
      expect(
        () => DiseaseCasePage.parse([card], meta),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );

  test('detail decoder maps the opening snapshot and both timeline events', () {
    final wire = jsonDecode(jsonEncode(_detail())) as Map<String, dynamic>;
    final detail = DiseaseCaseDetail.parse(wire);
    expect(detail.snapshot?.no2MgL, 1.7);
    expect(detail.snapshot?.healthRecordedAt, DateTime.utc(2026, 9, 5, 10));
    expect(detail.snapshot?.temperatureC, isNull);
    expect(detail.aiAssessment, isNull);
    expect(detail.attachments.single.caption, 'Ảnh nhá có phân trắng');
    expect(detail.protocols.single.status, ProtocolStatus.pendingApproval);
    expect(detail.timeline.first, isA<DiseaseCaseStatusChange>());
    expect(detail.timeline.last, isA<DiseaseCaseResponse>());
  });

  testWidgets(
    'owner detail shows AI, all water measurements and the full technician role',
    (tester) async {
      final base = _detail();
      final detail = base.copyWith(
        aiAssessment: DiseaseCaseAiAssessment(
          predictedLabel: 'Mang đen',
          recognitionStatus: AiRecognitionStatus.recognized,
          confidence: .92,
          recommendation: 'Đối chiếu dấu hiệu với chuyên gia.',
          createdAt: base.createdAt,
          processingTimeMs: 1200,
        ),
        snapshot: base.snapshot!.copyWith(
          temperatureC: 29.5,
          dissolvedOxygenMgL: 5.8,
          salinityPpt: 15,
          alkalinityMgLCaCO3: 120,
          h2sMgL: .002,
          waterRecordedAt: base.createdAt.subtract(const Duration(minutes: 15)),
          waterRecordedByName: 'Người ghi nhật ký',
          waterNote: 'Mẫu nước lấy trước khi báo ca.',
        ),
        timeline: [
          ...base.timeline,
          DiseaseCaseEvent.response(
            at: base.updatedAt,
            authorName: 'Cô Thái Bảo',
            authorRole: AccountRole.technician,
            responseType: DiseaseCaseResponseType.monitoringResult,
            message: 'Đã ghi nhận mẫu sáng.',
          ),
        ],
      );
      final wire = jsonDecode(jsonEncode(detail)) as Map<String, dynamic>;
      final repository = _Cases()
        ..detailResponse = Future.value(DiseaseCaseDetail.parse(wire));
      await _open(tester, repository, '/disease-cases/case-a3');
      await tester.pumpAndSettle();
      final scrollable = find.byType(Scrollable).first;

      await tester.scrollUntilVisible(
        find.text('Độ tin cậy'),
        120,
        scrollable: scrollable,
      );
      expect(find.text('Mang đen'), findsOneWidget);
      expect(find.text('92%'), findsOneWidget);
      expect(find.text('Khuyến nghị từ AI'), findsOneWidget);
      expect(find.text('Thời gian xử lý'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('H2S'),
        120,
        scrollable: scrollable,
      );
      for (final label in [
        'Nhiệt độ',
        'pH',
        'DO',
        'Độ mặn',
        'NH3',
        'NO2',
        'Kiềm',
        'H2S',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('2 chỉ số bất thường'), findsOneWidget);
      expect(find.text('Sức khỏe'), findsOneWidget);
      final healthBadge = find.widgetWithText(DiseaseCaseBadge, 'Cần chú ý');
      final waterBadge = find.widgetWithText(
        WaterLogStatusBadge,
        '2 chỉ số bất thường',
      );
      final healthTitle = find.text('Sức khỏe');
      final waterTitle = find.text('Nhật ký đo nước');
      for (final (title, badge) in [
        (healthTitle, healthBadge),
        (waterTitle, waterBadge),
      ]) {
        expect(
          tester.getCenter(badge).dy,
          closeTo(tester.getCenter(title).dy, 1),
        );
        expect(
          tester.getTopLeft(badge).dx,
          greaterThan(tester.getTopLeft(title).dx),
        );
      }
      expect(
        tester.getTopRight(healthBadge).dx,
        tester.getTopRight(waterBadge).dx,
      );
      expect(find.text('Ghi nhận lúc 17:00 05/09/2026'), findsOneWidget);
      expect(find.text('Đo lúc 17:05 05/09/2026'), findsOneWidget);
      expect(find.text('Người ghi nhật ký'), findsNothing);
      expect(find.text('Chưa cập nhật tên'), findsNothing);
      expect(find.byIcon(Icons.water_drop_outlined), findsNothing);
      expect(find.text('Mẫu nước lấy trước khi báo ca.'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Kỹ thuật viên'),
        120,
        scrollable: scrollable,
      );
      expect(find.text('Đổi trạng thái'), findsNothing);
      expect(find.text('KTV'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('opening snapshot shows only the notice without a reading', (
    tester,
  ) async {
    for (final snapshot in [
      null,
      DiseaseCaseSnapshot(
        capturedAt: DateTime.utc(2026, 9, 5),
        note: 'Ghi chú của ca, chưa có nhật ký.',
        exceededWaterMetrics: const [],
      ),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CaseOpeningSnapshot(snapshot: snapshot)),
        ),
      );

      expect(find.text('Hiện trạng khi mở ca'), findsOneWidget);
      expect(
        find.text('Chưa có thông tin ghi nhận khi mở ca.'),
        findsOneWidget,
      );
      expect(find.text('Sức khỏe'), findsNothing);
      expect(find.text('Nhật ký đo nước'), findsNothing);
      expect(find.text('Ghi chú của ca, chưa có nhật ký.'), findsNothing);
    }
  });

  testWidgets(
    'opening snapshot shows only the available group for older cases',
    (tester) async {
      const healthOnly = DiseaseCaseSnapshot(
        mortalityCount: 0,
        exceededWaterMetrics: [],
      );
      const waterOnly = DiseaseCaseSnapshot(ph: 7.8, exceededWaterMetrics: []);
      for (final (snapshot, visible, hidden) in [
        (healthOnly, 'Sức khỏe', 'Nhật ký đo nước'),
        (waterOnly, 'Nhật ký đo nước', 'Sức khỏe'),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: CaseOpeningSnapshot(snapshot: snapshot)),
          ),
        );

        expect(find.text(visible), findsOneWidget);
        expect(find.text(hidden), findsNothing);
        expect(find.text('Chưa lưu thời điểm ghi nhận'), findsOneWidget);
        expect(
          find.text('Chưa có thông tin ghi nhận khi mở ca.'),
          findsNothing,
        );
      }
    },
  );
}

class _DashboardCases extends DashboardFixtureRepository {
  _DashboardCases(this.kind);
  final dashboard.DashboardAlertKind kind;
  @override
  Future<dashboard.OwnerDashboard> getOverview() async =>
      overviewFixture.copyWith(
        alerts: [
          overviewFixture.alerts.last.copyWith(
            kind: kind,
            preview: overviewFixture.alerts.last.preview.copyWith(
              id: 'case-a3',
            ),
          ),
        ],
      );
}
