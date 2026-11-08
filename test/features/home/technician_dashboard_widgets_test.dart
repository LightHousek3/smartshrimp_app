import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/pages/technician_home_page.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/technician_overview_cards.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';
import 'owner_dashboard_fixtures.dart';
import 'technician_dashboard_fixtures.dart';

void main() {
  testWidgets(
    'N/B: every alert has exactly three single-line ellipsized rows and full details on long-press',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final alerts = _alerts();
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final alert in alerts) TechnicianAlertCard(alert),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TechnicianAlertCard), findsNWidgets(4));
      for (final card in find.byType(TechnicianAlertCard).evaluate()) {
        final rows = find.descendant(
          of: find.byWidget(card.widget),
          matching: find.byType(Text),
        );
        expect(rows, findsNWidgets(3));
        for (final row in tester.widgetList<Text>(rows)) {
          expect(row.maxLines, 1);
          expect(row.softWrap, false);
          expect(row.overflow, TextOverflow.ellipsis);
          expect(row.data, isNot(contains('\n')));
        }
      }
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip).first);
      expect(tooltip.message, contains('NO₂: 1,2 mg/L'));
      expect(tooltip.message, contains('NH₃: 0,18 mg/L'));
      expect(tooltip.message, contains('13:00 08/11/2026'));
      await tester.longPress(find.byType(TechnicianAlertCard).first);
      await tester.pumpAndSettle();
      expect(find.text(tooltip.message!), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N/B: task icons, clock and stacked overdue badges reuse task-list colors',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: TechnicianTaskPreview(
                tasks: [
                  TaskItem(
                    id: 'task-overdue',
                    title: 'Kiểm tra hệ thống quạt nước và theo dõi ao',
                    priority: TaskPriority.urgent,
                    status: TaskStatus.pending,
                    dueAt: DateTime.utc(2026, 11, 8, 7),
                  ),
                ],
                now: DateTime.utc(2026, 11, 8, 8),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final icons = tester.widgetList<AppSvgIcon>(find.byType(AppSvgIcon));
      expect(
        icons.map((icon) => icon.icon),
        containsAll([AppSvgIconName.tasks, AppSvgIconName.clock]),
      );
      expect(
        icons.firstWhere((icon) => icon.icon == AppSvgIconName.clock).color,
        AppColors.error,
      );
      expect(find.byType(TaskBadge), findsNWidgets(2));
      final badges = tester
          .widgetList<TaskBadge>(find.byType(TaskBadge))
          .toList();
      expect(badges.map((badge) => badge.label), ['Khẩn', 'Quá hạn']);
      expect(badges[0].colors, priorityColors(TaskPriority.urgent));
      expect(badges[1].colors, (taskRed, AppColors.error));
      expect(
        tester.getTopLeft(find.text('Quá hạn')).dy,
        greaterThan(tester.getBottomLeft(find.text('Khẩn')).dy),
      );
      expect(find.text('Hạn 14:00'), findsOneWidget);
      expect(find.textContaining('Quá hạn ·'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N: dashboard shows all alerts without a list link or update footer',
    (tester) async {
      final json = technicianDashboardJson();
      json['alerts'] = _alerts()
          .map(
            (alert) => {
              ...alert.toJson(),
              'metrics': alert.metrics
                  .map((metric) => metric.toJson())
                  .toList(),
            },
          )
          .toList();
      json['operationGroups'] = [];
      json['seasons'] = [];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const DashboardFixtureAuth(role: AccountRole.technician),
            ),
            technicianDashboardProvider.overrideWith(
              (ref) async => TechnicianDashboard.parse(json),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: TechnicianHomePage())),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Vấn đề vận hành'), 150);
      expect(find.text('Vấn đề vận hành'), findsOneWidget);
      expect(find.textContaining('Tất cả ('), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Chưa có vụ đang nuôi được phân công.'),
        200,
      );
      expect(find.textContaining('Cập nhật '), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N: seasons form separate vertical rows and every daily card remains reachable horizontally',
    (tester) async {
      tester.view.physicalSize = const Size(402, 875);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final groups = TechnicianDashboard.parse(
        technicianDashboardJson(),
      ).operationGroups;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (final group in groups) TechnicianOperationRow(group),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('daily-operations-a')), findsOneWidget);
      expect(find.byKey(const Key('daily-operations-b')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const Key('daily-operations-a'))).height,
        132,
      );
      expect(
        tester.getTopLeft(find.byKey(const Key('daily-operations-b'))).dy,
        greaterThan(
          tester.getBottomLeft(find.byKey(const Key('daily-operations-a'))).dy,
        ),
      );
      await tester.drag(
        find.byKey(const Key('daily-operations-a')),
        const Offset(-1600, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Thức ăn 7'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'B: summary, tiny doses and separate season rows tolerate large text without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final data = TechnicianDashboard.parse(technicianDashboardJson());
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TechnicianSummaryRow(
                        data.summary.copyWith(
                          activeSeasonCount: 1234,
                          openTaskCount: 12345,
                        ),
                      ),
                      TechnicianOperationRow(data.operationGroups.first),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('0,00001 kg'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N: zero active seasons still shows an open task and truthful empty daily schedules',
    (tester) async {
      final json = technicianDashboardJson();
      json['summary']['activeSeasonCount'] = 0;
      json['summary']['unresolvedActiveSeasonCaseCount'] = 0;
      json['seasons'] = [];
      json['operationGroups'] = [];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const DashboardFixtureAuth(role: AccountRole.technician),
            ),
            technicianDashboardProvider.overrideWith(
              (ref) async => TechnicianDashboard.parse(json),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: TechnicianHomePage())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kiểm tra quạt nước'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Không còn cữ đã lên lịch trong hôm nay.'),
        180,
      );
      expect(
        find.text('Không còn cữ đã lên lịch trong hôm nay.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A: initial loading stays centered and failures do not render zero-valued KPIs',
    (tester) async {
      final loading = Completer<TechnicianDashboard>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const DashboardFixtureAuth(role: AccountRole.technician),
            ),
            technicianDashboardProvider.overrideWith((ref) => loading.future),
          ],
          child: const MaterialApp(home: Scaffold(body: TechnicianHomePage())),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.getCenter(find.byType(CircularProgressIndicator)).dx,
        closeTo(400, 1),
      );
      loading.completeError(StateError('offline'));
      await tester.pumpAndSettle();
      expect(find.text('Thử lại'), findsOneWidget);
      expect(find.text('Vụ đang nuôi'), findsNothing);
    },
  );
}

List<TechnicianAlert> _alerts() => [
  for (final kind in [
    'WATER',
    'OVERDUE_OPERATIONS',
    'SCHEDULE_BLOCKED',
    'NEW_KIND',
  ])
    TechnicianAlert.fromJson({
      'id': '$kind:a',
      'kind': kind,
      'seasonId': 'a',
      'seasonName': 'Vụ thẻ 09/2026',
      'pondName': 'Ao kiểm tra chất lượng nước',
      'farmName': 'Trang trại Đầm Dơi Cà Mau với tên dài để kiểm tra hiển thị',
      'count': kind == 'WATER' ? 2 : 1,
      'observedAt': '2026-11-08T06:00:00Z',
      if (kind == 'SCHEDULE_BLOCKED')
        'reasonCodes': ['BIOMASS_MISSING_OR_STALE', 'VOLUME_MISSING'],
      if (kind == 'WATER')
        'metrics': [
          {
            'field': 'no2MgL',
            'value': 1.2,
            'unit': 'mg/L',
            'max': .5,
            'recordedAt': '2026-11-08T06:00:00Z',
          },
          {
            'field': 'nh3MgL',
            'value': .18,
            'unit': 'mg/L',
            'max': .1,
            'recordedAt': '2026-11-08T05:00:00Z',
          },
        ],
    }),
];
