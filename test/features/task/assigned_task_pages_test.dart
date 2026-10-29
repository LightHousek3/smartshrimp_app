import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';
import 'package:smartshrimp_app/features/task/presentation/pages/assigned_task_detail_page.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_detail_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/assigned_task_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../../support/load_app_fonts.dart';
import 'assigned_task_test.dart' show AssignedTaskFixtureRepository;
import 'task_fixtures.dart';

Future<ProviderContainer> openAssignedTasks(
  WidgetTester tester,
  AssignedTaskFixtureRepository repo, {
  String path = '/tasks',
  double width = 402.4,
}) async {
  await loadAppFonts();
  tester.view.physicalSize = Size(width, 874.4);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  final c = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const DashboardFixtureAuth(role: AccountRole.technician),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
      assignedTaskRepositoryProvider.overrideWithValue(repo),
    ],
  );
  await c.read(authControllerProvider.future);
  c.read(appRouterProvider).go(path);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: c, child: const SmartShrimpApp()),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    c.dispose();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.resetPadding();
  });
  return c;
}

void main() {
  testWidgets(
    'N: two grouped tabs, no owner controls, detail and back navigation',
    (tester) async {
      final repo = AssignedTaskFixtureRepository();
      await openAssignedTasks(tester, repo);
      expect(
        find.text('Công việc Chủ trang trại giao cho bạn'),
        findsOneWidget,
      );
      expect(find.text('Cần làm (2)'), findsOneWidget);
      expect(find.text('Đã kết thúc (2)'), findsOneWidget);
      expect(find.byTooltip('Tạo và giao nhiệm vụ'), findsNothing);
      expect(find.text(pendingTask.title), findsOneWidget);
      expect(find.text(completedTask.title), findsNothing);
      await tester.tap(find.text(pendingTask.title));
      await tester.pumpAndSettle();
      expect(find.byType(AssignedTaskDetailPage), findsOneWidget);
      expect(find.byType(TaskDetailView), findsOneWidget);
      expect(find.text('Người giao'), findsOneWidget);
      expect(find.byTooltip('Chỉnh sửa nhiệm vụ'), findsNothing);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đã kết thúc (2)'));
      await tester.pumpAndSettle();
      expect(find.text(completedTask.title), findsOneWidget);
      expect(find.text(cancelledTask.title), findsOneWidget);
      expect(repo.lists, contains(TaskGroup.ended));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('N: start, complete, record timeline and update tab counts', (
    tester,
  ) async {
    final repo = AssignedTaskFixtureRepository();
    final c = await openAssignedTasks(tester, repo, path: '/tasks/pending');
    await tester.scrollUntilVisible(find.text('Bắt đầu làm').last, 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bắt đầu làm').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Đã bắt đầu nhiệm vụ và ghi nhận thời gian.'),
      findsOneWidget,
    );
    expect(repo.tasks['pending']!.startedAt, isNotNull);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Đánh dấu hoàn thành'), 100);
    await tester.tap(find.text('Đánh dấu hoàn thành'));
    await tester.pumpAndSettle();
    expect(
      find.text('Đã hoàn thành nhiệm vụ và ghi nhận thời gian.'),
      findsOneWidget,
    );
    expect(repo.tasks['pending']!.completedAt, isNotNull);
    expect(find.text('Đánh dấu hoàn thành'), findsNothing);
    c.read(appRouterProvider).go('/tasks');
    await tester.pumpAndSettle();
    expect(find.text('Cần làm (1)'), findsOneWidget);
    expect(find.text('Đã kết thúc (3)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'A: update error retains task and displays shared backend notice',
    (tester) async {
      final repo = AssignedTaskFixtureRepository();
      await openAssignedTasks(tester, repo, path: '/tasks/pending');
      repo.failure = const ApiException(
        'Không thể bắt đầu nhiệm vụ',
        statusCode: 500,
      );
      await tester.scrollUntilVisible(find.text('Bắt đầu làm').last, 200);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bắt đầu làm').last);
      await tester.pumpAndSettle();
      expect(find.text('Không thể bắt đầu nhiệm vụ'), findsOneWidget);
      expect(repo.tasks['pending']!.status, TaskStatus.pending);
      expect(find.text('Bắt đầu làm'), findsNWidgets(2));
    },
  );

  for (final started in [false, true]) {
    testWidgets(
      'N/B: cancelled task keeps cancellation facts and prior start ($started)',
      (tester) async {
        final repo = AssignedTaskFixtureRepository();
        repo.tasks['cancelled'] = repo.tasks['cancelled']!.copyWith(
          startedAt: started ? DateTime.parse('2026-10-27T07:00:00Z') : null,
        );
        await openAssignedTasks(tester, repo, path: '/tasks/cancelled');
        await tester.scrollUntilVisible(find.textContaining('Lý do hủy:'), 200);
        expect(find.textContaining('Lý do hủy:'), findsOneWidget);
        expect(
          find.text(taskTimestamp(repo.tasks['cancelled']!.cancelledAt)),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(TaskTimeline),
            matching: find.text('Đã hủy'),
          ),
          findsOneWidget,
        );
        expect(
          find.text('Bắt đầu làm'),
          findsOneWidget,
        ); // Timeline label only.
        expect(find.text('Đánh dấu hoàn thành'), findsNothing);
        if (!started) {
          expect(find.text('Đã hủy trước khi bắt đầu'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('A: empty and retry states are usable', (tester) async {
    final repo = AssignedTaskFixtureRepository()
      ..failure = const NetworkException('Mất kết nối');
    final c = await openAssignedTasks(tester, repo);
    expect(find.text('Mất kết nối'), findsOneWidget);
    repo.failure = null;
    repo.tasks.clear();
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Không có nhiệm vụ'), findsOneWidget);
    expect(
      c.read(assignedTaskListProvider(TaskGroup.todo)).value?.totalResults,
      0,
    );
  });

  testWidgets(
    'B: 320px screen supports long titles, no deadline and no season',
    (tester) async {
      final repo = AssignedTaskFixtureRepository();
      repo.tasks['pending'] = repo.tasks['pending']!.copyWith(
        title: 'Nhiệm vụ rất dài ' * 10,
        dueAt: null,
        season: null,
        seasonId: null,
      );
      await openAssignedTasks(tester, repo, width: 320);
      final title = tester.widget<Text>(
        find.text(repo.tasks['pending']!.title),
      );
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(repo.tasks['pending']!.title));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Chưa đặt hạn'), 150);
      expect(find.text('Chưa đặt hạn'), findsOneWidget);
      expect(find.text('Mở ao liên quan'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Visual: technician list and detail states', (tester) async {
    final oldShadows = debugDisableShadows;
    debugDisableShadows = false;
    try {
      final repo = AssignedTaskFixtureRepository();
      final c = await openAssignedTasks(tester, repo);
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/technician_task_todo.png'),
      );
      await tester.tap(find.text('Đã kết thúc (2)'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/technician_task_ended.png'),
      );
      for (final id in ['pending', 'progress', 'completed', 'cancelled']) {
        c.read(appRouterProvider).go('/tasks/$id');
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(SmartShrimpApp),
          matchesGoldenFile('goldens/technician_task_${id}_top.png'),
        );
        await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(SmartShrimpApp),
          matchesGoldenFile('goldens/technician_task_${id}_bottom.png'),
        );
      }
    } finally {
      debugDisableShadows = oldShadows;
    }
  });
}
