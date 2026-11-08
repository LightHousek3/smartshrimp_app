import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/pages/protocol_detail_page.dart';
import 'package:smartshrimp_app/features/protocol/presentation/pages/protocol_list_page.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_empty_state.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'protocol_fixtures.dart';

Future<ProviderContainer> open(
  WidgetTester tester, {
  ProtocolFixtureRepository? repository,
  Widget? page,
  bool shell = false,
  bool settle = true,
  String route = '/protocols/protocol-1',
  Object? routeExtra,
  Size size = const Size(402, 874),
  AccountRole role = AccountRole.farmOwner,
  double topInset = 0,
  DateTime? now,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  for (final (family, file) in [
    ('Sora', 'Sora-Bold.ttf'),
    ('Sora_700', 'Sora-Bold.ttf'),
    ('Sora_800', 'Sora-ExtraBold.ttf'),
    ('PlusJakartaSans', 'PlusJakartaSans-Regular.ttf'),
    ('PlusJakartaSans_regular', 'PlusJakartaSans-Regular.ttf'),
    ('PlusJakartaSans_500', 'PlusJakartaSans-Medium.ttf'),
    ('PlusJakartaSans_600', 'PlusJakartaSans-SemiBold.ttf'),
    ('PlusJakartaSans_700', 'PlusJakartaSans-Bold.ttf'),
    ('PlusJakartaSans_800', 'PlusJakartaSans-ExtraBold.ttf'),
    ('JetBrainsMono_700', 'JetBrainsMono-Bold.ttf'),
    ('JetBrainsMono_800', 'JetBrainsMono-ExtraBold.ttf'),
  ]) {
    await (FontLoader(
      family,
    )..addFont(rootBundle.load('assets/fonts/google_fonts/$file'))).load();
  }
  for (final (family, files) in [
    (
      'PlusJakartaSans',
      [
        'PlusJakartaSans-Regular.ttf',
        'PlusJakartaSans-Medium.ttf',
        'PlusJakartaSans-SemiBold.ttf',
        'PlusJakartaSans-Bold.ttf',
        'PlusJakartaSans-ExtraBold.ttf',
      ],
    ),
    ('Sora', ['Sora-Bold.ttf', 'Sora-ExtraBold.ttf']),
    (
      'JetBrainsMono',
      [
        'JetBrainsMono-Regular.ttf',
        'JetBrainsMono-SemiBold.ttf',
        'JetBrainsMono-Bold.ttf',
        'JetBrainsMono-ExtraBold.ttf',
      ],
    ),
  ]) {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load('assets/fonts/google_fonts/$file'));
    }
    await loader.load();
  }
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.padding = FakeViewPadding(top: topInset);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      protocolClockProvider.overrideWithValue(
        () => now ?? DateTime.parse('2026-06-28T03:00:00Z'),
      ),
      authRepositoryProvider.overrideWithValue(
        DashboardFixtureAuth(role: role),
      ),
      protocolRepositoryProvider.overrideWithValue(
        repository ?? ProtocolFixtureRepository(),
      ),
      ownerDashboardRepositoryProvider.overrideWithValue(
        DashboardFixtureRepository(),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  if (shell) {
    container.read(appRouterProvider).go(route, extra: routeExtra);
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: shell
          ? const SmartShrimpApp()
          : MaterialApp(
              theme: AppTheme.light,
              home: page ?? const ProtocolDetailPage(protocolId: 'protocol-1'),
            ),
    ),
  );
  await tester.pump();
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await GoogleFonts.pendingFonts();
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
  return container;
}

Future<void> scrollTo(WidgetTester tester, String label) async {
  await tester.scrollUntilVisible(
    find.text(label),
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  _ProtocolTestBinding();
  for (final (kind, type) in [
    (DashboardAlertKind.pendingProduction, 'PRODUCTION'),
    (DashboardAlertKind.pendingTreatment, 'TREATMENT'),
  ]) {
    testWidgets(
      'N: dashboard pending $type alert opens its protocol detail and returns home',
      (tester) async {
        final repository = ProtocolFixtureRepository(type: type);
        final container = await open(
          tester,
          shell: true,
          route: '/',
          repository: repository,
        );
        final alert = overviewFixture.alerts.firstWhere(
          (item) => item.kind == kind,
        );
        final card = find.byWidgetPredicate(
          (widget) => widget is DashboardAlertCard && widget.alert == alert,
        );
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<ProtocolDetailPage>(find.byType(ProtocolDetailPage))
              .protocolId,
          alert.preview.id,
        );
        expect(repository.detailCalls, 1);
        expect(
          find.text(cardJson(type: type)['title'] as String),
          findsOneWidget,
        );
        container.read(appRouterProvider).pop();
        await tester.pumpAndSettle();
        expect(card, findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('N: rejection reason precedes status history in the audit card', (
    tester,
  ) async {
    final repo = ProtocolFixtureRepository(status: 'REJECTED')
      ..rejectionReason = 'Cần làm rõ liều lượng và thời điểm sử dụng.';
    await open(tester, repository: repo);
    await scrollTo(tester, 'Lý do từ chối');
    expect(find.text(repo.rejectionReason!), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Lý do từ chối')).dy,
      lessThan(tester.getTopLeft(find.text('LỊCH SỬ TRẠNG THÁI')).dy),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rejected_audit.png'),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'N: production opens at current Vietnam DOC and preserves manual day selection',
    (tester) async {
      final repo = ProtocolFixtureRepository(anchorDate: '2026-10-01');
      final container = await open(
        tester,
        repository: repo,
        now: DateTime.parse('2026-10-15T17:01:00Z'),
        shell: true,
      );
      expect(repo.days, [16]);
      expect(find.text('13–18'), findsOneWidget);
      expect(
        find.byKey(const Key('protocol_current_range_badge')),
        findsOneWidget,
      );
      await tester.tap(find.text('15').last);
      await tester.pumpAndSettle();
      expect(repo.days.last, 15);
      container.invalidate(protocolDetailProvider('protocol-1'));
      await tester.pumpAndSettle();
      expect(repo.days.last, 15);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/current_doc.png'),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: late DOC range and its circular current badge are visible on open',
    (tester) async {
      final repo = ProtocolFixtureRepository();
      await open(
        tester,
        repository: repo,
        now: DateTime.parse('2026-09-08T00:00:00Z'),
        shell: true,
      );
      expect(repo.days, [73]);
      final pill = tester.getRect(find.text('73–78'));
      final badge = tester.getRect(
        find.byKey(const Key('protocol_current_range_badge')),
      );
      expect(pill.left, greaterThan(0));
      expect(pill.right, lessThan(402));
      for (final label in ['61–66', '67–72', '73–78', '79–84', '85–90']) {
        final bounds = tester.getRect(find.text(label));
        expect(bounds.left, greaterThan(16));
        expect(bounds.right, lessThan(386));
      }
      expect(badge.width, badge.height);
      expect(badge.top, greaterThan(0));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/late_doc_badge.png'),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: empty list matches Figma 207:2 using the common document icon',
    (tester) async {
      await open(
        tester,
        repository: ProtocolFixtureRepository(empty: true),
        shell: true,
        route: '/protocols?seasonId=season-1',
        routeExtra: 'Ao B1 · Vụ Thu 2025',
      );
      expect(find.text('Phác đồ nuôi (0)'), findsOneWidget);
      expect(find.text('Điều trị (0)'), findsOneWidget);
      expect(find.byType(ProtocolEmptyState), findsOneWidget);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/empty_list.png'),
      );
      await tester.tap(find.text('Điều trị (0)'));
      await tester.pumpAndSettle();
      expect(find.byType(ProtocolEmptyState), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: swiping ranges and crossing a page with day navigation keeps selection visible',
    (tester) async {
      final repo = ProtocolFixtureRepository();
      await open(tester, repository: repo);
      await tester.drag(find.byType(PageView), const Offset(-340, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('31–36'));
      await tester.pumpAndSettle();
      expect(repo.days.last, 31);
      await scrollTo(tester, 'DOC 31');
      await tester.tap(find.byTooltip('Ngày trước'));
      await tester.pumpAndSettle();
      expect(repo.days.last, 30);
      expect(find.text('25–30'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: header respects the safe area once and keeps filters pinned during scrolling',
    (tester) async {
      await open(
        tester,
        repository: ProtocolFixtureRepository(itemCount: 15),
        page: const ProtocolListPage(seasonId: 'season-1'),
        topInset: 24,
      );
      final header = tester.getRect(find.byType(PageHeaderBar));
      expect(header.top, 24);
      expect(header.height, 76);
      final before = tester.getRect(find.text('Điều trị (15)'));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -450));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.text('Điều trị (15)')), before);
      expect(
        tester
            .widget<PageHeaderBar>(find.byType(PageHeaderBar))
            .backgroundColor,
        Colors.transparent,
      );
      await tester.tap(find.text('Điều trị (15)'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: detail uses the shared header height without extra top spacing',
    (tester) async {
      await open(tester, topInset: 24);
      final header = tester.getRect(find.byType(PageHeaderBar));
      expect(header.top, 24);
      expect(header.height, 76);
      expect(
        tester
            .widget<PageHeaderBar>(find.byType(PageHeaderBar))
            .backgroundColor,
        Colors.transparent,
      );
      await tester.drag(find.byType(ListView).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(PageHeaderBar)), header);
    },
  );
  testWidgets('A: switching days ignores a late response for the previous day', (
    tester,
  ) async {
    final gate = Completer<ProtocolDay>();
    final repo = ProtocolFixtureRepository()..firstDay = gate;
    // Keep the first response pending while the separate day-2 provider resolves.
    await open(tester, repository: repo, settle: false);
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    gate.complete(
      ProtocolDay.parse({
        'day': 1,
        'rows': [dayRowJson()],
      }),
    );
    await tester.pumpAndSettle();
    await scrollTo(tester, 'DOC 2');
    expect(find.text('DOC 1'), findsNothing);
    expect(repo.days, [1, 2]);
  });
  testWidgets(
    'N: list tabs and counts render the matching type, then open detail',
    (tester) async {
      final repo = ProtocolFixtureRepository();
      await open(
        tester,
        repository: repo,
        shell: true,
        route: '/protocols?seasonId=season-1',
      );
      expect(find.text('Phác đồ nuôi (1)'), findsOneWidget);
      expect(find.text('Điều trị (2)'), findsOneWidget);
      await tester.tap(find.text('Điều trị (2)'));
      await tester.pumpAndSettle();
      expect(
        find.text('Phác đồ điều trị Phân trắng — Ao A3 v2'),
        findsOneWidget,
      );
      await tester.tap(find.text('Phác đồ điều trị Phân trắng — Ao A3 v2'));
      await tester.pumpAndSettle();
      expect(find.text('Chi tiết phác đồ'), findsOneWidget);
      expect(repo.detailCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: selecting a range fetches only its first day, then previous/next',
    (tester) async {
      final repo = ProtocolFixtureRepository();
      await open(tester, repository: repo);
      await tester.tap(find.text('7–12'));
      await tester.pumpAndSettle();
      expect(repo.days, [1, 7]);
      await scrollTo(tester, 'DOC 7');
      await tester.tap(find.byTooltip('Ngày tiếp theo'));
      await tester.pumpAndSettle();
      expect(repo.days.last, 8);
      expect(find.text('DOC 8'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N/A/B: rejection requires a reason, sends normalized text and blocks duplicate submit',
    (tester) async {
      final repo = ProtocolFixtureRepository()..reviewGate = Completer<void>();
      await open(tester, repository: repo);
      await scrollTo(tester, 'Từ chối và nêu lý do');
      await tester.tap(find.text('Từ chối và nêu lý do'));
      await tester.pumpAndSettle();
      await scrollTo(tester, 'Xác nhận từ chối');
      await tester.tap(find.text('Xác nhận từ chối'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập lý do từ chối.'), findsOneWidget);
      expect(repo.reviewCalls, 0);
      await tester.enterText(
        find.byKey(const Key('protocol_rejection_reason')),
        '  Cần làm rõ liều  ',
      );
      await tester.ensureVisible(find.text('Xác nhận từ chối'));
      await tester.tap(find.text('Xác nhận từ chối'));
      await tester.pump();
      expect(repo.reviewCalls, 1);
      final detail = ProtocolDetail.parse(detailJson());
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ProtocolDetailPage)),
      );
      expect(
        await container
            .read(protocolReviewProvider('protocol-1').notifier)
            .submit(detail, approve: false, reason: 'duplicate'),
        isFalse,
      );
      repo.reviewGate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Thành công'), findsOneWidget);
      expect(find.text('Đã từ chối phác đồ.'), findsOneWidget);
      expect(repo.approved, isFalse);
      expect(repo.rejectionReason?.trim(), 'Cần làm rõ liều');
      expect(find.text('Quyết định của Chủ trại'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'N: approval requires inline confirmation and reloads the reviewed version',
    (tester) async {
      final repo = ProtocolFixtureRepository();
      await open(tester, repository: repo);
      await scrollTo(tester, 'Phê duyệt phác đồ');
      await tester.tap(find.text('Phê duyệt phác đồ'));
      await tester.pumpAndSettle();
      expect(repo.reviewCalls, 0);
      expect(find.text('Xác nhận phê duyệt phiên bản 1'), findsOneWidget);
      await scrollTo(tester, 'Xác nhận duyệt');
      await tester.tap(find.text('Xác nhận duyệt'));
      await tester.pumpAndSettle();
      expect(find.text('Thành công'), findsOneWidget);
      expect(
        find.text('Đã phê duyệt. Hệ thống sẽ sinh lịch vận hành gần nhất.'),
        findsOneWidget,
      );
      expect(repo.approved, isTrue);
      expect(repo.version, DateTime.parse('2026-06-20T02:00:00Z'));
      expect(repo.detailCalls, 2);
      expect(find.text('Quyết định của Chủ trại'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('A: backend read error has a retry and keeps its message', (
    tester,
  ) async {
    final repo = ProtocolFixtureRepository()
      ..readError = const ApiException(
        'Không tìm thấy phác đồ.',
        statusCode: 404,
      );
    await open(tester, repository: repo);
    expect(find.text('Không tìm thấy phác đồ.'), findsOneWidget);
    repo.readError = null;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Lịch theo từng cữ'), findsOneWidget);
  });
  testWidgets(
    'A: rejected review preserves the reason and server error for correction',
    (tester) async {
      final repo = ProtocolFixtureRepository()
        ..reviewError = const ApiException(
          'Ca bệnh đã được giải quyết.',
          statusCode: 403,
        );
      await open(tester, repository: repo);
      await scrollTo(tester, 'Từ chối và nêu lý do');
      await tester.tap(find.text('Từ chối và nêu lý do'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('protocol_rejection_reason')),
        'Cần điều chỉnh',
      );
      await scrollTo(tester, 'Xác nhận từ chối');
      await tester.tap(find.text('Xác nhận từ chối'));
      await tester.pumpAndSettle();
      expect(find.text('Ca bệnh đã được giải quyết.'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('protocol_rejection_reason')),
            )
            .controller!
            .text,
        'Cần điều chỉnh',
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('A: Technician cannot load owner protocol data', (tester) async {
    final repo = ProtocolFixtureRepository();
    await open(tester, repository: repo, role: AccountRole.technician);
    expect(repo.detailCalls, 0);
    expect(find.text('Thử lại'), findsOneWidget);
  });
  for (final type in ['PRODUCTION', 'TREATMENT']) {
    testWidgets('N: Figma $type detail golden and common SVG assets', (
      tester,
    ) async {
      await open(
        tester,
        repository: ProtocolFixtureRepository(
          type: type,
          status: type == 'PRODUCTION' ? 'APPROVED' : 'PENDING_APPROVAL',
        ),
        shell: true,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${type.toLowerCase()}_detail.png'),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('N: Figma list golden', (tester) async {
    await open(
      tester,
      repository: ProtocolFixtureRepository(status: 'APPROVED'),
      shell: true,
      route: '/protocols?seasonId=season-1',
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/production_list.png'),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('N: inline approval and rejection match their Figma states', (
    tester,
  ) async {
    await open(tester, shell: true);
    await scrollTo(tester, 'Phê duyệt phác đồ');
    await tester.tap(find.text('Phê duyệt phác đồ'));
    await tester.pumpAndSettle();
    await scrollTo(tester, 'Xác nhận duyệt');
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/approval_confirmation.png'),
    );
    await tester.tap(find.text('Xem lại'));
    await tester.pumpAndSettle();
    await scrollTo(tester, 'Từ chối và nêu lý do');
    await tester.tap(find.text('Từ chối và nêu lý do'));
    await tester.pumpAndSettle();
    await scrollTo(tester, 'Xác nhận từ chối');
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rejection_reason.png'),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'N: completed cữ and adjustment reason match Figma audit layout',
    (tester) async {
      await open(
        tester,
        repository: ProtocolFixtureRepository(status: 'APPROVED'),
        shell: true,
      );
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(630);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/completed_day_audit.png'),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('B: narrow detail remains usable without overflow', (
    tester,
  ) async {
    await open(
      tester,
      repository: ProtocolFixtureRepository(type: 'TREATMENT'),
      size: const Size(320, 800),
    );
    await scrollTo(tester, 'Phê duyệt phác đồ');
    await tester.tap(find.text('Phê duyệt phác đồ'));
    await tester.pumpAndSettle();
    await scrollTo(tester, 'Xác nhận duyệt');
    expect(tester.takeException(), isNull);
  });
}

class _ProtocolTestBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get disableShadows => false;
}
