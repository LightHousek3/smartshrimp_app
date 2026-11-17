import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_evidence_panel.dart';
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
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../../support/load_app_fonts.dart';
import 'assigned_task_test.dart' show AssignedTaskFixtureRepository;
import 'task_fixtures.dart';
import '../../support/disabled_push_repository.dart';

Future<ProviderContainer> openAssignedTasks(
  WidgetTester tester,
  AssignedTaskFixtureRepository repo, {
  String path = '/tasks',
  double width = 402.4,
  ImagePicker? picker,
}) async {
  await loadAppFonts();
  tester.view.physicalSize = Size(width, 874.4);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  final c = ProviderContainer(
    overrides: [
      pushRepositoryProvider.overrideWithValue(const DisabledPushRepository()),
      authRepositoryProvider.overrideWithValue(
        const DashboardFixtureAuth(role: AccountRole.technician),
      ),
      notificationRepositoryProvider.overrideWithValue(
        DashboardFixtureNotifications(),
      ),
      notificationSocketProvider.overrideWith((ref) => null),
      assignedTaskRepositoryProvider.overrideWithValue(repo),
      if (picker != null) taskImagePickerProvider.overrideWithValue(picker),
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

class _TaskImagePicker extends ImagePicker {
  XFile? image = XFile.fromData(
    Uint8List.fromList([0xff, 0xd8, 0xff, 0]),
    name: 'evidence.jpg',
  );
  Object? failure;
  final sources = <ImageSource>[];
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    sources.add(source);
    if (failure != null) throw failure!;
    return image;
  }
}

void main() {
  testWidgets('B: technician evidence remains usable at 320px and 150% text', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final picker = _TaskImagePicker();
    await openAssignedTasks(
      tester,
      AssignedTaskFixtureRepository(),
      path: '/tasks/progress',
      width: 320,
      picker: picker,
    );
    await tester.scrollUntilVisible(find.text('Chụp ảnh'), 150);
    await tester.pumpAndSettle();
    expect(find.text('Chọn từ thư viện').hitTestable(), findsOneWidget);
    final cameraButton = find.widgetWithText(FilledButton, 'Chụp ảnh');
    final libraryButton = find.widgetWithText(
      OutlinedButton,
      'Chọn từ thư viện',
    );
    expect(
      tester.getSize(cameraButton).height,
      tester.getSize(libraryButton).height,
    );
    expect(
      tester.getCenter(cameraButton).dy,
      tester.getCenter(libraryButton).dy,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Chụp ảnh'));
    await tester.pumpAndSettle();
    expect(find.text('1/5 ảnh'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -2500));
    await tester.pumpAndSettle();
    expect(find.text('Đánh dấu hoàn thành').hitTestable(), findsOneWidget);
    expect(find.text('Mở ao liên quan').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Visual: pending detail uses the standard centered header', (
    tester,
  ) async {
    final repo = AssignedTaskFixtureRepository();
    repo.tasks['pending'] = pendingTask.copyWith(
      createdAt: DateTime(2026, 9, 8, 14, 10),
      dueAt: DateTime(2026, 9, 9),
      pond: const TaskChoice(id: 'pond', name: 'Ao A5'),
      canOpenRelatedSeason: true,
    );
    await openAssignedTasks(
      tester,
      repo,
      path: '/tasks/pending',
      width: 402.6667,
    );
    final panels = find.byType(TaskDetailPanel);
    final header = find.byType(PageHeaderBar);
    expect(tester.getSize(header).height, 76);
    expect(
      tester.getCenter(find.text('Chi tiết nhiệm vụ')).dy,
      tester.getCenter(header).dy,
    );
    expect(
      tester.getCenter(find.byTooltip('Quay lại')).dy,
      tester.getCenter(header).dy,
    );
    expect(tester.getTopLeft(panels.at(0)), const Offset(16, 100));
    // Larger text keeps the panel widths and lets content determine their height.
    expect(tester.getSize(panels.at(0)).width, closeTo(370.6667, .1));
    expect(tester.getSize(panels.at(1)).width, closeTo(370.6667, .1));
    expect(tester.getSize(panels.at(2)).width, closeTo(370.6667, .1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'N: camera and library evidence can be previewed, removed and completed',
    (tester) async {
      final repo = AssignedTaskFixtureRepository();
      final picker = _TaskImagePicker();
      await openAssignedTasks(
        tester,
        repo,
        path: '/tasks/progress',
        picker: picker,
      );
      expect(find.byType(TaskEvidencePanel), findsOneWidget);
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(picker.sources, [ImageSource.camera]);
      expect(find.text('1/5 ảnh'), findsOneWidget);
      await tester.tap(find.text('Chọn từ thư viện'));
      await tester.pumpAndSettle();
      expect(picker.sources.last, ImageSource.gallery);
      expect(find.text('2/5 ảnh'), findsOneWidget);
      await tester.tap(find.text('Minh chứng 1'));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(AppImageViewer), findsOneWidget);
      expect(find.text('Ảnh 1/2'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Xem ảnh 2 trong thư viện'));
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 2/2'), findsOneWidget);
      await tester.tap(find.text('Tải lại ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 2/2'), findsOneWidget);
      await tester.tap(find.byTooltip('Đóng'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Bỏ ảnh minh chứng 1'));
      await tester.pumpAndSettle();
      expect(find.text('1/5 ảnh'), findsOneWidget);
      await tester.ensureVisible(find.text('Đánh dấu hoàn thành'));
      await tester.tap(find.text('Đánh dấu hoàn thành'));
      await tester.pumpAndSettle();
      expect(
        find.text('Hoàn thành nhiệm vụ với 1 ảnh minh chứng?'),
        findsOneWidget,
      );
      await tester.tap(find.text('Quay lại'));
      await tester.pumpAndSettle();
      expect(repo.advances, 0);
      expect(find.text('1/5 ảnh'), findsOneWidget);
      await tester.tap(find.text('Đánh dấu hoàn thành'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.tasks['progress']!.evidenceUrls, [
        'https://images.test/evidence-2.jpg',
      ]);
      expect(find.byTooltip('Bỏ ảnh minh chứng 1'), findsNothing);
      expect(find.text('Chụp ảnh'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Visual: Figma 376:712 evidence layout', (tester) async {
    final repo = AssignedTaskFixtureRepository();
    repo.tasks['progress'] = progressTask.copyWith(
      createdAt: DateTime(2026, 9, 8, 13, 25),
      startedAt: DateTime(2026, 9, 8, 13, 40),
      dueAt: DateTime(2026, 9, 8, 19),
      canOpenRelatedSeason: true,
    );
    await openAssignedTasks(
      tester,
      repo,
      path: '/tasks/progress',
      width: 402.6667,
      picker: _TaskImagePicker(),
    );
    for (var index = 0; index < 2; index++) {
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
    }
    await tester.drag(find.byType(ListView).first, const Offset(0, 1500));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(TaskEvidencePanel)).width,
      closeTo(370.6667, .1),
    );
    expect(
      tester.getSize(find.byTooltip('Bỏ ảnh minh chứng 1')),
      const Size(28, 28),
    );
    // Photos are runtime data; the network fixture deliberately uses the error placeholder.
    expect(tester.takeException(), isNull);
  });

  for (final id in ['1105', '1421']) {
    testWidgets('Visual: Figma 376:$id terminal detail', (tester) async {
      final cancelled = id == '1105';
      final repo = AssignedTaskFixtureRepository();
      final task = cancelled
          ? cancelledTask.copyWith(
              title: 'Đo độ mặn Ao A5 — hủy sau hạn, chưa bắt đầu',
              description:
                  'Dữ liệu mẫu để kiểm tra trạng thái, hạn xử lý và tiến trình nhiệm vụ. Đối chiếu các mốc thời gian trong phần chi tiết.',
              assignee: taskTechnician,
              createdAt: DateTime(2026, 11, 14, 0, 48),
              dueAt: DateTime(2026, 11, 16, 0, 48),
              cancelledAt: DateTime(2026, 11, 16, 2, 48),
              startedAt: null,
              cancellationReason:
                  'Chủ trại thay đổi kế hoạch sau khi quá thời hạn đo.',
              season: taskSeason,
              pond: const TaskChoice(id: 'pond', name: 'Ao A5'),
              canOpenRelatedSeason: true,
            )
          : completedTask.copyWith(
              title: 'Kiểm tra quạt nước trước ca chiều — nhiệm vụ demo',
              description:
                  'Đã cập nhật: kiểm tra quạt nước, vệ sinh lưới chắn và báo lại Chủ trại trước ca chiều.',
              dueAt: null,
              season: null,
              pond: null,
              createdAt: DateTime(2026, 11, 17, 0, 52),
              startedAt: DateTime(2026, 11, 17, 0, 52),
              completedAt: DateTime(2026, 11, 17, 0, 52),
            );
      repo.tasks[task.id] = task;
      await openAssignedTasks(
        tester,
        repo,
        path: '/tasks/${task.id}',
        width: 402.6667,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'A: cancelled picker, unsupported bytes and denied camera never upload',
    (tester) async {
      final repo = AssignedTaskFixtureRepository();
      final picker = _TaskImagePicker()..image = null;
      await openAssignedTasks(
        tester,
        repo,
        path: '/tasks/progress',
        picker: picker,
      );
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(repo.uploads, 0);
      picker.image = XFile.fromData(
        Uint8List.fromList([1, 2, 3]),
        name: 'fake.jpg',
      );
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('Chọn ảnh JPG, PNG hoặc WebP.'), findsOneWidget);
      expect(repo.uploads, 0);
      picker.failure = PlatformException(code: 'camera_access_denied');
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(
        find.text('Vui lòng cho phép truy cập camera trong cài đặt thiết bị.'),
        findsOneWidget,
      );
      expect(repo.uploads, 0);
      expect(find.text('0/5 ảnh'), findsOneWidget);
    },
  );

  testWidgets(
    'A/B: upload locks completion; failure preserves the task and retry succeeds',
    (tester) async {
      final repo = AssignedTaskFixtureRepository()
        ..pendingUpload = Completer<String>();
      await openAssignedTasks(
        tester,
        repo,
        path: '/tasks/progress',
        picker: _TaskImagePicker(),
      );
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pump();
      await tester.pump();
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      repo.pendingUpload!.completeError(
        const NetworkException('Không tải được ảnh'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Không tải được ảnh'), findsOneWidget);
      AppNoticeService.hide();
      await tester.pumpAndSettle();
      expect(repo.tasks['progress']!.status, TaskStatus.inProgress);
      expect(repo.advances, 0);
      repo.pendingUpload = null;
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('1/5 ảnh'), findsOneWidget);
      repo.failure = const ApiException(
        'Không thể hoàn thành nhiệm vụ',
        statusCode: 500,
      );
      await tester.ensureVisible(find.text('Đánh dấu hoàn thành'));
      await tester.tap(find.text('Đánh dấu hoàn thành'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(find.text('Không thể hoàn thành nhiệm vụ'), findsOneWidget);
      expect(find.text('1/5 ảnh'), findsOneWidget);
      expect(repo.tasks['progress']!.status, TaskStatus.inProgress);
      repo.failure = null;
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('B: five photos disable both sources until a photo is removed', (
    tester,
  ) async {
    final repo = AssignedTaskFixtureRepository();
    final picker = _TaskImagePicker();
    await openAssignedTasks(
      tester,
      repo,
      path: '/tasks/progress',
      picker: picker,
    );
    for (var index = 0; index < 5; index++) {
      await tester.ensureVisible(find.text('Chụp ảnh'));
      await tester.tap(find.text('Chụp ảnh'));
      await tester.pumpAndSettle();
    }
    expect(find.text('5/5 ảnh'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Chụp ảnh'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Chọn từ thư viện'),
          )
          .onPressed,
      isNull,
    );
    await tester.ensureVisible(find.byTooltip('Bỏ ảnh minh chứng 1'));
    await tester.tap(find.byTooltip('Bỏ ảnh minh chứng 1'));
    await tester.pumpAndSettle();
    expect(find.text('4/5 ảnh'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Chụp ảnh'))
          .onPressed,
      isNotNull,
    );
    expect(repo.uploads, 5);
  });

  testWidgets('B: late upload does not update a disposed page', (tester) async {
    final repo = AssignedTaskFixtureRepository()
      ..pendingUpload = Completer<String>();
    await openAssignedTasks(
      tester,
      repo,
      path: '/tasks/progress',
      picker: _TaskImagePicker(),
    );
    await tester.ensureVisible(find.text('Chụp ảnh'));
    await tester.tap(find.text('Chụp ảnh'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.byTooltip('Quay lại'));
    await tester.pumpAndSettle();
    repo.pendingUpload!.complete('https://images.test/late.jpg');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
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
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đánh dấu hoàn thành'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận'));
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
      expect(find.text('Bắt đầu làm'), findsOneWidget);
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
          find.bySemanticsLabel(
            taskTimestamp(repo.tasks['cancelled']!.cancelledAt),
          ),
          findsOneWidget,
        );
        expect(find.text('Nguyễn Văn Đạt'), findsOneWidget);
        expect(find.textContaining('Nguyễn Văn Đạt ·'), findsNothing);
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
            matching: find.bySemanticsLabel(
              taskTimestamp(repo.tasks['cancelled']!.cancelledAt),
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(TaskTimeline),
            matching: find.text('Đã hủy'),
          ),
          findsOneWidget,
        );
        expect(find.text('Bắt đầu làm'), findsNothing);
        expect(find.text('Đánh dấu hoàn thành'), findsNothing);
        if (!started) {
          expect(find.text('Chưa bắt đầu'), findsOneWidget);
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
      await tester.scrollUntilVisible(find.text('Không đặt hạn'), 150);
      expect(find.text('Không đặt hạn'), findsOneWidget);
      expect(find.text('Mở ao liên quan'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('N: technician can navigate task tabs and detail states', (
    tester,
  ) async {
    final repo = AssignedTaskFixtureRepository();
    final c = await openAssignedTasks(tester, repo);
    await tester.tap(find.text('Đã kết thúc (2)'));
    await tester.pumpAndSettle();
    expect(find.text(repo.tasks['completed']!.title), findsOneWidget);
    expect(find.text(repo.tasks['cancelled']!.title), findsOneWidget);
    for (final id in ['pending', 'progress', 'completed', 'cancelled']) {
      c.read(appRouterProvider).go('/tasks/$id');
      await tester.pumpAndSettle();
      expect(find.byType(AssignedTaskDetailPage), findsOneWidget);
      expect(find.text(repo.tasks[id]!.title), findsOneWidget);
      await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
