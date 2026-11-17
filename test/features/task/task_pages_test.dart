import 'dart:async';

import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/app_select_field.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/pages/task_detail_page.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_detail_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_evidence_panel.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_list_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../../support/load_app_fonts.dart';
import 'task_fixtures.dart';
import '../../support/disabled_push_repository.dart';

class _DelayedTaskListRepository extends TaskFixtureRepository {
  final progressReady = Completer<void>();

  @override
  Future<TaskPage> list(TaskStatus tab, {int page = 1}) async {
    if (tab == TaskStatus.inProgress) await progressReady.future;
    return super.list(tab, page: page);
  }
}

class _LongTaskOptionsRepository extends TaskFixtureRepository {
  @override
  Future<TaskOptions> options(String? farmId) async =>
      (await super.options(farmId)).copyWith(
        farms: [
          taskFarm,
          for (var index = 0; index < 30; index++)
            TaskChoice(
              id: 'long-$index',
              name: 'Trang trại số $index có tên dài để kiểm tra lựa chọn',
            ),
        ],
      );
}

class _UnassignedSeasonRepository extends TaskFixtureRepository {
  @override
  Future<TaskOptions> options(String? farmId) async {
    final options = await super.options(farmId);
    return options.copyWith(
      seasons: [
        for (final season in options.seasons) season.copyWith(technician: null),
      ],
    );
  }
}

class _UrgentAlertDashboardRepository extends DashboardFixtureRepository {
  _UrgentAlertDashboardRepository(this.count, {required this.withSeason});
  final int count;
  final bool withSeason;

  @override
  Future<OwnerDashboard> getOverview() async {
    final alert = overviewFixture.alerts.firstWhere(
      (alert) => alert.kind == DashboardAlertKind.urgentTask,
    );
    return overviewFixture.copyWith(
      alerts: [
        alert.copyWith(
          count: count,
          preview: alert.preview.copyWith(
            seasonId: withSeason ? alert.preview.seasonId : null,
            seasonName: withSeason ? alert.preview.seasonName : null,
            pondId: withSeason ? alert.preview.pondId : null,
            pondName: withSeason ? alert.preview.pondName : null,
          ),
        ),
      ],
    );
  }
}

Future<ProviderContainer> openTasks(
  WidgetTester tester,
  TaskFixtureRepository repo, {
  String path = '/tasks',
  double width = 402,
  DashboardFixtureRepository? dashboard,
}) async {
  await loadAppFonts();
  tester.view.physicalSize = Size(width, 874);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  final container = ProviderContainer(
    overrides: [
      pushRepositoryProvider.overrideWithValue(const DisabledPushRepository()),
      authRepositoryProvider.overrideWithValue(DashboardFixtureAuth()),
      ownerDashboardRepositoryProvider.overrideWithValue(
        dashboard ?? DashboardFixtureRepository(),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
      taskRepositoryProvider.overrideWithValue(repo),
    ],
  );
  await container.read(authControllerProvider.future);
  container.read(appRouterProvider).go(path);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const SmartShrimpApp(),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.resetPadding();
  });
  return container;
}

Future<void> _chooseFutureDeadline(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('task_deadline')));
  await tester.tap(find.byKey(const Key('task_deadline')));
  await tester.pumpAndSettle();
  tester
      .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
      .onDateChanged(DateTime(2099, 1, 1));
  await tester.pump();
  await tester.tap(find.text('OK').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.keyboard_outlined));
  await tester.pumpAndSettle();
  final timeFields = find.descendant(
    of: find.byType(TimePickerDialog),
    matching: find.byType(TextField),
  );
  await tester.enterText(timeFields.at(0), '08');
  await tester.enterText(timeFields.at(1), '00');
  await tester.tap(find.text('AM'));
  await tester.pump();
  await tester.tap(find.text('OK').last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('B: owner detail wraps long content at 320px and 150% text', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final repo = TaskFixtureRepository();
    repo.tasks['progress'] = progressTask.copyWith(
      title: 'Kiểm tra và xử lý chất lượng nước tại ao nuôi trong ca chiều',
      assigner: const TaskChoice(
        id: 'owner1',
        name: 'Nguyễn Hoàng Minh Phương',
      ),
      assignee: const TaskChoice(id: 'tech1', name: 'Trần Nguyễn Hoàng Anh'),
      farm: const TaskChoice(id: 'farm1', name: 'Trang trại nuôi tôm Đông Hải'),
      season: const TaskChoice(id: 'season1', name: 'Vụ nuôi Đông Xuân 2026'),
    );
    final container = await openTasks(
      tester,
      repo,
      path: '/tasks/progress',
      width: 320,
    );
    expect(
      tester.widget<Text>(find.text(repo.tasks['progress']!.title)).maxLines,
      isNull,
    );
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView).first, const Offset(0, -2500));
    await tester.pumpAndSettle();
    expect(find.text('Hủy nhiệm vụ').hitTestable(), findsOneWidget);
    expect(
      tester
          .getTopLeft(
            find.bySemanticsLabel(taskTimestamp(progressTask.createdAt)),
          )
          .dy,
      tester
          .getTopLeft(
            find.bySemanticsLabel(taskTimestamp(progressTask.startedAt)),
          )
          .dy,
    );
    expect(tester.takeException(), isNull);

    repo.tasks['cancelled'] = cancelledTask.copyWith(
      cancellationReason:
          'Chủ trại thay đổi kế hoạch kiểm tra chất lượng nước '
          'sau khi đã trao đổi lại với kỹ thuật viên phụ trách.',
    );
    container.read(appRouterProvider).go('/tasks/cancelled');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.textContaining('Lý do hủy:'), 150);
    expect(tester.takeException(), isNull);
  });

  for (final task in [
    pendingTask,
    progressTask,
    completedTask,
    cancelledTask,
  ]) {
    testWidgets(
      'N: ${task.status.name} detail restores the round status badge and assignment milestone',
      (tester) async {
        await openTasks(
          tester,
          TaskFixtureRepository(),
          path: '/tasks/${task.id}',
        );
        final statusBadge = find.widgetWithText(
          TaskBadge,
          taskStatusLabel(task.status),
        );
        final badge = tester.widget<TaskBadge>(statusBadge);
        expect(badge.label, taskStatusLabel(task.status));
        expect(badge.dot, isTrue);
        expect(badge.colors, statusColors(task.status));
        final statusHeight = tester.getSize(statusBadge).height;
        for (final element in find.byType(TaskBadge).evaluate()) {
          expect(
            tester.getSize(find.byWidget(element.widget)).height,
            statusHeight,
          );
        }
        expect(
          find.descendant(
            of: find.byType(TaskTimeline),
            matching: find.text('Được giao'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(TaskTimeline),
            matching: find.text('Chờ làm'),
          ),
          findsNothing,
        );
        if (task.status == TaskStatus.cancelled) {
          expect(
            find.bySemanticsLabel(taskTimestamp(task.cancelledAt)),
            findsOneWidget,
          );
          expect(find.text('Nguyễn Văn Đạt'), findsOneWidget);
          expect(find.textContaining('Nguyễn Văn Đạt ·'), findsNothing);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Visual: Figma 376:2071 owner detail', (tester) async {
    final repo = TaskFixtureRepository();
    repo.tasks['progress'] = progressTask.copyWith(
      title: 'Kiểm tra quạt nước Ao B1 — KTV khác phụ trách',
      description:
          'Dữ liệu mẫu để kiểm tra trạng thái, hạn xử lý và tiến trình nhiệm vụ. Đối chiếu các mốc thời gian trong phần chi tiết.',
      priority: TaskPriority.normal,
      assignee: taskSecondTechnician,
      pond: const TaskChoice(id: 'pond', name: 'Ao B1'),
      season: const TaskChoice(id: 'season', name: 'Vụ Thu 2025'),
      createdAt: DateTime(2026, 11, 14, 0, 48),
      startedAt: DateTime(2026, 11, 16, 12, 48),
      // Keep this fixture open and not overdue independently of the test date.
      dueAt: DateTime(2099, 11, 17, 6, 48),
    );
    await openTasks(tester, repo, path: '/tasks/progress');
    expect(tester.takeException(), isNull);
  });
  testWidgets('N: owner sees saved evidence and cannot add or remove photos', (
    tester,
  ) async {
    final repo = TaskFixtureRepository();
    repo.tasks['completed'] = completedTask.copyWith(
      evidenceUrls: ['https://images.test/evidence.jpg'],
    );
    await openTasks(tester, repo, path: '/tasks/completed');
    await tester.scrollUntilVisible(find.byType(TaskEvidencePanel), 100);
    expect(find.text('1/5 ảnh'), findsOneWidget);
    expect(find.text('Minh chứng 1'), findsOneWidget);
    expect(find.text('Chụp ảnh'), findsNothing);
    expect(find.text('Chọn từ thư viện'), findsNothing);
    expect(find.byTooltip('Bỏ ảnh minh chứng 1'), findsNothing);
    expect(find.text('Đánh dấu hoàn thành'), findsNothing);
    await tester.tap(find.text('Minh chứng 1'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byType(AppImageViewer), findsOneWidget);
    expect(find.text('Ảnh 1/1'), findsOneWidget);
    await tester.tap(find.byTooltip('Đóng'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('N: owner sees the completed-without-evidence message', (
    tester,
  ) async {
    await openTasks(tester, TaskFixtureRepository(), path: '/tasks/completed');
    await tester.scrollUntilVisible(find.byType(TaskEvidencePanel), 100);
    expect(find.text('0/5 ảnh'), findsOneWidget);
    expect(
      find.text('Nhiệm vụ đã hoàn thành không kèm ảnh minh chứng.'),
      findsOneWidget,
    );
    expect(find.text('Chụp ảnh'), findsNothing);
  });
  testWidgets('N/B: owner overdue deadline is red and retains assignee', (
    tester,
  ) async {
    final repo = TaskFixtureRepository();
    final container = await openTasks(tester, repo);
    for (final deadline in [
      taskNow.subtract(const Duration(minutes: 1)),
      taskNow.add(const Duration(minutes: 1)),
      null,
    ]) {
      repo.tasks['pending'] = pendingTask.copyWith(dueAt: deadline);
      container.invalidate(taskListProvider(TaskStatus.pending));
      await tester.pumpAndSettle();
      final metadata = tester.widget<Text>(
        find.textContaining('${taskTechnician.name} · Hạn'),
      );
      final spans = (metadata.textSpan! as TextSpan).children!;
      expect((spans.first as TextSpan).text, '${taskTechnician.name} · ');
      expect((spans.last as TextSpan).text, 'Hạn: ${taskTimestamp(deadline)}');
      expect(metadata.style!.color, AppColors.inkMuted);
      expect(metadata.style!.fontSize, 12);
      final overdue = deadline != null && deadline.isBefore(taskNow);
      expect(
        (spans.last as TextSpan).style!.color,
        overdue ? AppColors.error : AppColors.inkMuted,
      );
      expect(find.text('Quá hạn'), overdue ? findsOneWidget : findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'N: dashboard urgent alert opens task detail and returns to dashboard',
    (tester) async {
      final repo = TaskFixtureRepository();
      final alert = overviewFixture.alerts.firstWhere(
        (alert) => alert.kind == DashboardAlertKind.urgentTask,
      );
      repo.tasks[alert.preview.id] = progressTask.copyWith(
        id: alert.preview.id,
      );
      final container = await openTasks(tester, repo, path: '/');
      final card = find.byWidgetPredicate(
        (widget) => widget is DashboardAlertCard && widget.alert == alert,
      );
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();

      expect(
        tester.widget<TaskDetailPage>(find.byType(TaskDetailPage)).taskId,
        alert.preview.id,
      );
      expect(
        container.read(taskDetailProvider(alert.preview.id)).value?.id,
        alert.preview.id,
      );
      expect(find.text('Chi tiết nhiệm vụ'), findsOneWidget);
      expect(find.text(progressTask.title), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskDetailPage), findsNothing);
      expect(card, findsOneWidget);
      expect(find.text('Cảnh báo quan trọng'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final count in [2, 3]) {
    for (final withSeason in [false, true]) {
      testWidgets(
        'N/B: urgent group ($count, season: $withSeason) opens pending tab after another tab was selected',
        (tester) async {
          final container = await openTasks(
            tester,
            TaskFixtureRepository(),
            dashboard: _UrgentAlertDashboardRepository(
              count,
              withSeason: withSeason,
            ),
          );
          await tester.tap(find.text('Đang làm (1)'));
          await tester.pumpAndSettle();
          expect(find.text(progressTask.title), findsOneWidget);

          container.read(appRouterProvider).go('/');
          await tester.pumpAndSettle();
          final card = find.byType(DashboardAlertCard);
          await tester.ensureVisible(card);
          await tester.tap(card);
          await tester.pumpAndSettle();

          expect(container.read(appRouterProvider).state.uri.path, '/tasks');
          final list = tester.widget<TaskListView>(find.byType(TaskListView));
          expect(list.selectedTab, 0);
          expect(list.tabs.first, 'Chờ làm (1)');
          expect(find.text(pendingTask.title), findsOneWidget);
          expect(find.text(progressTask.title), findsNothing);
          expect(find.byType(TaskDetailPage), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final directLink in [false, true]) {
    testWidgets('N: task back returns to list (direct link: $directLink)', (
      tester,
    ) async {
      await openTasks(
        tester,
        TaskFixtureRepository(),
        path: directLink ? '/tasks/pending' : '/tasks',
      );
      if (!directLink) {
        await tester.tap(find.text(pendingTask.title));
        await tester.pumpAndSettle();
      }
      expect(find.byType(TaskDetailPage), findsOneWidget);
      await tester.tap(find.byTooltip('Quay lại'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskDetailPage), findsNothing);
      expect(find.text('Chờ làm (1)'), findsOneWidget);
      expect(find.text(pendingTask.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'N/B: create and edit controls follow Figma input/select dimensions and priority border colors',
    (tester) async {
      final container = await openTasks(
        tester,
        TaskFixtureRepository(),
        path: '/tasks/create',
      );
      for (final path in [
        '/tasks/create',
        '/tasks/pending/edit',
        '/tasks/progress/edit',
      ]) {
        container.read(appRouterProvider).go(path);
        await tester.pumpAndSettle();
        final title = find.descendant(
          of: find.byKey(const Key('task_title')),
          matching: find.byType(InputDecorator),
        );
        final width = tester.getSize(title).width;
        expect(tester.getSize(title).height, closeTo(43.373, .001));
        for (final key in ['task_title', 'task_deadline']) {
          final input = find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(EditableText),
          );
          expect(
            InputDecorator.containerOf(tester.element(input))!.size.height,
            closeTo(43.373, .001),
          );
        }
        for (final select in find.byType(AppSelectField<String>).evaluate()) {
          final dropdown = find.descendant(
            of: find.byWidget(select.widget),
            matching: find.byType(DropdownButton<String>),
          );
          expect(
            InputDecorator.containerOf(tester.element(dropdown))!.size.height,
            closeTo(AppFormMetrics.selectHeight, .001),
          );
          expect(
            tester.getSize(find.byWidget(select.widget)).height,
            closeTo(AppFormMetrics.selectHeight, .001),
          );
          expect(tester.getSize(find.byWidget(select.widget)).width, width);
        }
        final priorities = find.byType(OutlinedButton);
        final widths = <double>[];
        for (final priority in priorities.evaluate()) {
          final size = tester.getSize(find.byWidget(priority.widget));
          expect(size.height, AppFormMetrics.controlHeight);
          widths.add(size.width);
        }
        expect(widths.toSet().length, 1);
        for (final label in ['Thấp', 'Cao']) {
          await tester.ensureVisible(find.text(label));
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          final button = tester.widget<OutlinedButton>(
            find.ancestor(of: find.text(label), matching: priorities),
          );
          expect(
            button.style!.side!.resolve({})!.color,
            button.style!.foregroundColor!.resolve({}),
          );
          expect(
            (button.style!.shape!.resolve({})! as RoundedRectangleBorder)
                .borderRadius,
            BorderRadius.circular(AppFormMetrics.radius),
          );
        }
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A: picker OK shows the deadline error beneath its field and a valid choice clears it',
    (tester) async {
      await openTasks(tester, TaskFixtureRepository(), path: '/tasks/create');
      final deadline = find.byKey(const Key('task_deadline'));
      await tester.ensureVisible(deadline);
      await tester.tap(deadline);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Switch to text input mode'));
      await tester.pumpAndSettle();
      final clockFields = find.descendant(
        of: find.byType(TimePickerDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(clockFields.first, '12');
      await tester.enterText(clockFields.last, '00');
      await tester.tap(find.text('AM').last);
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: deadline,
          matching: find.text(TaskRules.deadlineMessage),
        ),
        findsOneWidget,
      );
      expect(find.text('Không thể thực hiện'), findsNothing);
      await tester.tap(deadline);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      expect(find.text(TaskRules.deadlineMessage), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A: submit validates all fields and aligns inline errors with input content',
    (tester) async {
      final repo = TaskFixtureRepository();
      await openTasks(tester, repo, path: '/tasks/create');
      await tester.ensureVisible(find.text('Tạo & giao nhiệm vụ').last);
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      expect(repo.saved, isNull);
      expect(find.text('Vui lòng nhập tiêu đề nhiệm vụ.'), findsOneWidget);
      expect(find.text('Vui lòng chọn hạn hoàn thành.'), findsOneWidget);
      expect(find.text('Vui lòng chọn nhân sự.'), findsOneWidget);
      final titleError = tester.getTopLeft(
        find.text('Vui lòng nhập tiêu đề nhiệm vụ.'),
      );
      final deadlineError = tester.getTopLeft(
        find.text('Vui lòng chọn hạn hoàn thành.'),
      );
      final technicianError = tester.getTopLeft(
        find.text('Vui lòng chọn nhân sự.'),
      );
      expect(titleError.dx, deadlineError.dx);
      expect(titleError.dx, technicianError.dx);
      for (final key in ['task_title', 'task_deadline']) {
        final input = find.descendant(
          of: find.byKey(Key(key)),
          matching: find.byType(EditableText),
        );
        expect(
          InputDecorator.containerOf(tester.element(input))!.size.height,
          closeTo(43.373, .001),
        );
      }
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 2000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N/B: compact farm menu scrolls and keeps the Figma chevron geometry',
    (tester) async {
      await openTasks(
        tester,
        _LongTaskOptionsRepository(),
        path: '/tasks/create',
      );
      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>).first,
      );
      expect(dropdown.menuMaxHeight, 320);
      final chevron = find
          .byWidgetPredicate(
            (widget) =>
                widget is AppSvgIcon &&
                widget.icon == AppSvgIconName.dropdownChevron,
          )
          .first;
      expect(tester.getSize(chevron), const Size(10, 6));
      final fieldDecoration = tester
          .widget<InputDecorator>(
            find.descendant(
              of: find.byType(AppTextField).first,
              matching: find.byType(InputDecorator),
            ),
          )
          .decoration;
      expect(
        (fieldDecoration.enabledBorder! as OutlineInputBorder).borderRadius,
        BorderRadius.circular(12),
      );
      expect(
        (fieldDecoration.focusedBorder! as OutlineInputBorder).borderRadius,
        BorderRadius.circular(12),
      );
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -1800));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('N: header stays pinned and tab changes show list loading', (
    tester,
  ) async {
    final repo = _DelayedTaskListRepository();
    for (var index = 0; index < 24; index++) {
      final task = pendingTask.copyWith(id: 'pending-$index');
      repo.tasks[task.id] = task;
    }
    await openTasks(tester, repo);
    final heading = find.text('Nhiệm vụ').first;
    final tabs = [
      find.text('Chờ làm (25)'),
      find.text('Đang làm (1)'),
      find.text('Hoàn thành (1)'),
      find.text('Đã hủy (1)'),
    ];
    final headingPosition = tester.getTopLeft(heading);
    final tabPositions = tabs.map(tester.getTopLeft).toList();
    await tester.drag(find.byKey(const ValueKey(0)), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(heading), headingPosition);
    for (var index = 0; index < tabs.length; index++) {
      expect(tester.getTopLeft(tabs[index]), tabPositions[index]);
    }

    await tester.tap(tabs[1]);
    await tester.pump();
    final spinner = find.byType(CircularProgressIndicator);
    final list = find.byKey(const ValueKey(1));
    expect(spinner, findsOneWidget);
    expect(tester.getCenter(spinner), tester.getCenter(list));
    for (final status in TaskStatus.values.where(
      (status) => status != TaskStatus.unknown,
    )) {
      expect(find.text(taskStatusLabel(status)), findsOneWidget);
    }
    expect(find.textContaining('(…)'), findsNothing);
    expect(find.textContaining('(...)'), findsNothing);
    expect(find.text(pendingTask.title), findsNothing);

    repo.progressReady.complete();
    await tester.pumpAndSettle();
    expect(spinner, findsNothing);
    expect(find.text('Đang làm (1)'), findsOneWidget);
    expect(find.text(progressTask.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('N: owner tabs and all detail states match the design', (
    tester,
  ) async {
    final repo = TaskFixtureRepository();
    final container = await openTasks(tester, repo);
    expect(find.text('Chờ làm (1)'), findsOneWidget);
    expect(find.text('Đang làm (1)'), findsOneWidget);
    expect(find.text('Hoàn thành (1)'), findsOneWidget);
    expect(find.text('Đã hủy (1)'), findsOneWidget);
    expect(find.textContaining('${taskTechnician.name} · Hạn'), findsOneWidget);
    await tester.tap(find.text('Đang làm (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Vệ sinh, hiệu chuẩn máy đo DO'), findsNothing);
    await tester.tap(find.text('Hoàn thành (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đã hủy (1)'));
    await tester.pumpAndSettle();
    repo.emptyCancelled = true;
    container.invalidate(taskListProvider);
    await tester.pumpAndSettle();
    expect(find.text('Không có nhiệm vụ'), findsOneWidget);
    for (final id in ['pending', 'progress', 'completed', 'cancelled']) {
      container.read(appRouterProvider).go('/tasks/$id');
      await tester.pumpAndSettle();
      final mutable = id == 'pending' || id == 'progress';
      expect(find.byType(TaskDetailView), findsOneWidget);
      final header = find.byType(PageHeaderBar);
      final headerCenter = tester.getCenter(header).dy;
      expect(tester.getSize(header).height, 76);
      expect(tester.getCenter(find.text('Chi tiết nhiệm vụ')).dy, headerCenter);
      expect(tester.getCenter(find.byTooltip('Quay lại')).dy, headerCenter);
      if (mutable) {
        expect(
          tester.getCenter(find.byTooltip('Chỉnh sửa nhiệm vụ')).dy,
          headerCenter,
        );
      }
      expect(find.text('Người giao'), findsOneWidget);
      expect(
        find.byTooltip('Chỉnh sửa nhiệm vụ'),
        mutable ? findsOneWidget : findsNothing,
      );
      await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(find.text('Tiến trình thực hiện'), findsOneWidget);
      expect(
        find.text('Hủy nhiệm vụ'),
        mutable ? findsOneWidget : findsNothing,
      );
    }
    expect(tester.takeException(), isNull);
  });

  for (final id in ['pending', 'progress']) {
    testWidgets(
      'N/A: $id cancellation requires a reason and preserves execution timestamps',
      (tester) async {
        final repo = TaskFixtureRepository();
        await openTasks(tester, repo, path: '/tasks/$id');
        await tester.scrollUntilVisible(find.text('Hủy nhiệm vụ'), 200);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hủy nhiệm vụ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xác nhận hủy'));
        await tester.pumpAndSettle();
        expect(find.text('Vui lòng nhập lý do hủy.'), findsOneWidget);
        expect(repo.cancelledReason, isNull);
        await tester.enterText(
          find.byType(AppTextField),
          'Không cần thực hiện',
        );
        await tester.tap(find.text('Xác nhận hủy'));
        await tester.pumpAndSettle();
        expect(repo.cancelledReason, 'Không cần thực hiện');
        expect(find.text('Lý do hủy: Không cần thực hiện'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(TaskTimeline),
            matching: find.text('Đã hủy'),
          ),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel(taskTimestamp(cancelledTask.cancelledAt)),
          findsOneWidget,
        );
        expect(find.text('Hủy nhiệm vụ'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'A/N: an unassigned season blocks creation without asking for manual staff selection',
    (tester) async {
      final repo = _UnassignedSeasonRepository();
      final container = await openTasks(tester, repo, path: '/tasks/create');
      await tester.enterText(
        find.byKey(const Key('task_title')),
        'Kiểm tra ao chưa có KTV',
      );
      await _chooseFutureDeadline(tester);
      await tester.ensureVisible(find.text('Vụ nuôi liên quan'));
      await tester.tap(find.byType(DropdownButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ao A3 · ${taskSeason.name}').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Tạo & giao nhiệm vụ').last);
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      const warning =
          'Vụ nuôi chưa có kỹ thuật viên đang phụ trách. Vui lòng phân công trước khi giao nhiệm vụ.';
      expect(find.text(warning), findsOneWidget);
      expect(find.text('Vui lòng chọn nhân sự.'), findsNothing);
      expect(find.text('Vui lòng nhập tiêu đề nhiệm vụ.'), findsNothing);
      expect(find.text('Vui lòng chọn hạn hoàn thành.'), findsNothing);
      expect(repo.saved, isNull);
      expect(
        container
            .read(appRouterProvider)
            .routeInformationProvider
            .value
            .uri
            .path,
        '/tasks/create',
      );

      await tester.ensureVisible(find.text('Vụ nuôi liên quan'));
      await tester.tap(find.byType(DropdownButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('— Không gắn với vụ nuôi —').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Tạo & giao nhiệm vụ').last);
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng chọn nhân sự.'), findsOneWidget);
      expect(find.text(warning), findsNothing);
      expect(repo.saved, isNull);

      await tester.ensureVisible(find.text(taskTechnician.name));
      await tester.tap(find.text(taskTechnician.name));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Tạo & giao nhiệm vụ').last);
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      expect(repo.saved?.assignedTo, taskTechnician.id);
      expect(repo.saved?.seasonId, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N/A: create validates, auto-selects season KTV and returns to refreshed list',
    (tester) async {
      final repo = TaskFixtureRepository();
      final container = await openTasks(tester, repo, path: '/tasks/create');
      await tester.enterText(find.byType(AppTextField).first, 'Nhiệm vụ mới');
      await _chooseFutureDeadline(tester);
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(taskFarm.name).last);
      await tester.pumpAndSettle();
      expect(repo.optionFarms, contains(taskFarm.id));
      await tester.ensureVisible(find.text('Vụ nuôi liên quan'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ao A3 · ${taskSeason.name}').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Giao cho Kỹ thuật viên *'));
      await tester.pumpAndSettle();
      expect(find.text(taskSecondTechnician.name), findsNothing);
      await tester.ensureVisible(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      expect(repo.saved?.assignedTo, taskTechnician.id);
      expect(repo.saved?.seasonId, taskSeason.id);
      expect(
        container
            .read(appRouterProvider)
            .routeInformationProvider
            .value
            .uri
            .path,
        '/tasks',
      );
      expect(find.text('Chờ làm (1)'), findsOneWidget);
      expect(find.text('Chi tiết nhiệm vụ'), findsNothing);
      expect(
        find.text('Nhiệm vụ đã được tạo và giao thành công.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N: in-progress edit locks title and assignment but saves editable fields',
    (tester) async {
      final repo = TaskFixtureRepository();
      await openTasks(tester, repo, path: '/tasks/progress/edit');
      expect(
        tester.widget<AppTextField>(find.byType(AppTextField).first).enabled,
        isFalse,
      );
      expect(find.byType(DropdownButton<String>), findsNothing);
      await tester.enterText(
        find.byType(AppTextField).at(1),
        'Theo dõi sau 4 giờ',
      );
      await tester.scrollUntilVisible(
        find.text('Lưu thay đổi'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu thay đổi'));
      await tester.pumpAndSettle();
      expect(repo.saved?.description, 'Theo dõi sau 4 giờ');
      expect(repo.saved?.title, progressTask.title);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('A: backend message and retry are visible without data loss', (
    tester,
  ) async {
    final repo = TaskFixtureRepository()
      ..failure = const ApiException('Không thể tải dữ liệu.');
    final container = await openTasks(tester, repo);
    expect(find.text('Không thể tải dữ liệu.'), findsOneWidget);
    repo.failure = null;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(
      container.read(taskListProvider(TaskStatus.pending)).value?.items.length,
      1,
    );
    expect(tester.takeException(), isNull);
  });
}
