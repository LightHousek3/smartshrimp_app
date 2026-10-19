import 'dart:async';

import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/app_select_field.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/pages/task_detail_page.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../../support/load_app_fonts.dart';
import 'task_fixtures.dart';

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

Future<ProviderContainer> openTasks(
  WidgetTester tester,
  TaskFixtureRepository repo, {
  String path = '/tasks',
}) async {
  await loadAppFonts();
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(DashboardFixtureAuth()),
      ownerDashboardRepositoryProvider.overrideWithValue(
        DashboardFixtureRepository(),
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

void main() {
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
            closeTo(40.522, .001),
          );
          expect(
            tester.getSize(find.byWidget(select.widget)).height,
            closeTo(40.522, .001),
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_deadline_error.png'),
      );
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_required_errors.png'),
      );
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_farm_menu.png'),
      );
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
    await tester.drag(
      find.byKey(const ValueKey(TaskStatus.pending)),
      const Offset(0, -1000),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(heading), headingPosition);
    for (var index = 0; index < tabs.length; index++) {
      expect(tester.getTopLeft(tabs[index]), tabPositions[index]);
    }

    await tester.tap(tabs[1]);
    await tester.pump();
    final spinner = find.byType(CircularProgressIndicator);
    final list = find.byKey(const ValueKey(TaskStatus.inProgress));
    expect(spinner, findsOneWidget);
    expect(tester.getTopLeft(spinner).dy - tester.getTopLeft(list).dy, 40);
    expect(tester.getCenter(spinner).dx, tester.getCenter(list).dx);
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
    await expectLater(
      find.byType(SmartShrimpApp),
      matchesGoldenFile('goldens/task_todo.png'),
    );
    await tester.tap(find.text('Đang làm (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Vệ sinh, hiệu chuẩn máy đo DO'), findsNothing);
    await expectLater(
      find.byType(SmartShrimpApp),
      matchesGoldenFile('goldens/task_overdue.png'),
    );
    await tester.tap(find.text('Hoàn thành (1)'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(SmartShrimpApp),
      matchesGoldenFile('goldens/task_completed_list.png'),
    );
    await tester.tap(find.text('Đã hủy (1)'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(SmartShrimpApp),
      matchesGoldenFile('goldens/task_cancelled_list.png'),
    );
    repo.emptyCancelled = true;
    container.invalidate(taskListProvider);
    await tester.pumpAndSettle();
    expect(find.text('Không có nhiệm vụ'), findsOneWidget);
    await expectLater(
      find.byType(SmartShrimpApp),
      matchesGoldenFile('goldens/task_empty.png'),
    );
    for (final id in ['pending', 'progress', 'completed', 'cancelled']) {
      container.read(appRouterProvider).go('/tasks/$id');
      await tester.pumpAndSettle();
      final mutable = id == 'pending' || id == 'progress';
      expect(
        find.text('Hủy nhiệm vụ'),
        mutable ? findsOneWidget : findsNothing,
      );
      expect(
        find.byTooltip('Chỉnh sửa nhiệm vụ'),
        mutable ? findsOneWidget : findsNothing,
      );
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_${id}_detail.png'),
      );
    }
    expect(tester.takeException(), isNull);
  });

  for (final id in ['pending', 'progress']) {
    testWidgets(
      'N/A: $id cancellation requires a reason and preserves history',
      (tester) async {
        final repo = TaskFixtureRepository();
        await openTasks(tester, repo, path: '/tasks/$id');
        await tester.tap(find.text('Hủy nhiệm vụ'));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(SmartShrimpApp),
          matchesGoldenFile('goldens/task_${id}_cancel_dialog.png'),
        );
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
        expect(find.text('Hủy nhiệm vụ'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'N/A: create form validates, uses farm-specific season choices and auto-selects KTV',
    (tester) async {
      final repo = TaskFixtureRepository();
      await openTasks(tester, repo, path: '/tasks/create');
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_create.png'),
      );
      await tester.enterText(find.byType(AppTextField).first, 'Nhiệm vụ mới');
      await tester.tap(find.byKey(const Key('task_deadline')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_create_assigned.png'),
      );
      await tester.tap(find.text('Tạo & giao nhiệm vụ').last);
      await tester.pumpAndSettle();
      expect(repo.saved?.assignedTo, taskTechnician.id);
      expect(repo.saved?.seasonId, taskSeason.id);
      expect(find.text('Chi tiết nhiệm vụ'), findsOneWidget);
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_progress_edit.png'),
      );
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
      await expectLater(
        find.byType(SmartShrimpApp),
        matchesGoldenFile('goldens/task_progress_edit_bottom.png'),
      );
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
