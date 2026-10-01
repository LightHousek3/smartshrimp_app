import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/pages/assigned_season_detail_page.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';
import 'package:smartshrimp_app/features/personnel/presentation/pages/personnel_detail_page.dart';
import 'package:smartshrimp_app/features/personnel/presentation/pages/personnel_list_page.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';

void main() {
  for (final hasReference in [true, false]) {
    testWidgets(
      'owner opens activated personnel with reference=$hasReference',
      (tester) async {
        final personnel = _PersonnelRepository();
        final notification = AppNotification(
          id: 'activation-notification',
          title: 'Nhân sự đã kích hoạt tài khoản',
          type: NotificationType.managedAccountActivated,
          referenceType: hasReference ? 'account' : null,
          referenceId: hasReference ? 'staff-id' : null,
          createdAt: DateTime(2026, 10, 2),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(
                const _AuthRepository(AccountRole.farmOwner),
              ),
              notificationRepositoryProvider.overrideWithValue(
                _NotificationRepository(assignment: notification),
              ),
              personnelRepositoryProvider.overrideWithValue(personnel),
            ],
            child: const SmartShrimpApp(),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Thông báo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(notification.title));
        await tester.pumpAndSettle();
        expect(find.text('Xem nhân sự'), findsOneWidget);
        await tester.tap(find.byKey(const Key('notification_action_button')));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('notification_detail_sheet')),
          findsNothing,
        );
        if (hasReference) {
          expect(
            tester
                .widget<PersonnelDetailPage>(find.byType(PersonnelDetailPage))
                .personnelId,
            'staff-id',
          );
          expect(personnel.requestedPersonnelId, 'staff-id');
          expect(find.text('Nhân sự không còn khả dụng.'), findsOneWidget);
        } else {
          expect(find.byType(PersonnelListPage), findsOneWidget);
          expect(personnel.requestedPersonnelId, isNull);
        }
      },
    );
  }
  for (final type in <NotificationType>[
    NotificationType.seasonAssignmentCreated,
    NotificationType.seasonAssignmentReplaced,
  ]) {
    testWidgets('technician opens assigned season from ${type.name}', (
      tester,
    ) async {
      final seasons = _AssignedSeasonRepository();
      final notification = AppNotification(
        id: 'assignment-notification',
        title: 'Bạn được phân công vào vụ nuôi',
        type: type,
        referenceType: 'aquaculture_season',
        referenceId: 'assigned-season-1',
        createdAt: DateTime(2026, 10, 2),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              const _AuthRepository(AccountRole.technician),
            ),
            notificationRepositoryProvider.overrideWithValue(
              _NotificationRepository(assignment: notification),
            ),
            assignedSeasonRepositoryProvider.overrideWithValue(seasons),
          ],
          child: const SmartShrimpApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thông báo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(notification.title));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('notification_detail_sheet')), findsNothing);
      expect(
        tester
            .widget<AssignedSeasonDetailPage>(
              find.byType(AssignedSeasonDetailPage),
            )
            .seasonId,
        'assigned-season-1',
      );
      expect(seasons.requestedSeasonId, 'assigned-season-1');
      expect(find.text('Ao thử nghiệm'), findsNWidgets(2));

      ProviderScope.containerOf(
        tester.element(find.byType(AssignedSeasonDetailPage)),
      ).read(appRouterProvider).pop();
      await tester.pumpAndSettle();
      expect(find.text(notification.title), findsOneWidget);
    });
  }
  test('notification categories use the rounded icons from the UI sample', () {
    expect(
      NotificationVisuals.icon(NotificationType.waterThresholdExceeded),
      Icons.warning_amber_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.operationDue),
      Icons.settings_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.diseaseCaseCreated),
      Icons.health_and_safety_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.taskAssigned),
      Icons.checklist_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.productionProtocolPending),
      Icons.assignment_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.inventoryLow),
      Icons.inventory_2_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.seasonStatusChanged),
      Icons.layers_rounded,
    );
    expect(
      NotificationVisuals.icon(NotificationType.managedAccountActivated),
      Icons.groups_rounded,
    );
  });

  test('notification task and season colors match the UI sample', () {
    expect(
      NotificationVisuals.color(NotificationType.taskCompleted),
      const Color(0xFF0F62B4),
    );
    expect(
      NotificationVisuals.badgeTextColor(NotificationType.taskCompleted),
      const Color(0xFF0C4E8F),
    );
    expect(
      NotificationVisuals.backgroundColor(NotificationType.taskCompleted),
      const Color(0xFFEAF4FF),
    );
    expect(
      NotificationVisuals.color(NotificationType.seasonStatusChanged),
      const Color(0xFF64748B),
    );
    expect(
      NotificationVisuals.backgroundColor(NotificationType.seasonStatusChanged),
      const Color(0xFFEEF1F6),
    );
  });

  test('notification action labels depend on the notification type', () {
    expect(
      NotificationVisuals.actionLabel(
        NotificationType.treatmentProtocolPending,
      ),
      'Xem và duyệt',
    );
    expect(
      NotificationVisuals.actionLabel(NotificationType.taskCompleted),
      'Xem nhiệm vụ',
    );
    expect(
      NotificationVisuals.actionLabel(NotificationType.inventoryLow),
      'Xem kho',
    );
    expect(
      NotificationVisuals.actionLabel(NotificationType.waterThresholdExceeded),
      'Xem vụ nuôi',
    );
  });

  for (final role in <AccountRole>[
    AccountRole.farmOwner,
    AccountRole.technician,
  ]) {
    testWidgets('notification UI works for ${role.name}', (tester) async {
      tester.view.physicalSize = role == AccountRole.farmOwner
          ? const Size(1245, 844)
          : const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final repository = _NotificationRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_AuthRepository(role)),
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
          child: const SmartShrimpApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thông báo'));
      await tester.pumpAndSettle();

      expect(find.text('1 thông báo chưa đọc'), findsOneWidget);
      expect(find.text('Tất cả'), findsOneWidget);
      expect(find.text('Chưa đọc'), findsOneWidget);
      expect(find.text('Cần xử lý'), findsOneWidget);
      expect(find.text('Cảnh báo'), findsOneWidget);
      expect(find.text('Cảnh báo sớm'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      if (role == AccountRole.farmOwner) {
        expect(
          tester.getSize(find.byKey(const Key('notification_filters'))).width,
          greaterThan(1000),
        );
      }
      final warningSurface = tester.widget<Container>(
        find.byKey(const Key('notification_surface_notification-1')),
      );
      expect((warningSurface.decoration! as BoxDecoration).color, Colors.white);
      expect(find.text('Nhiệm vụ đã hoàn thành'), findsOneWidget);
      expect(find.text('Đọc tất cả'), findsOneWidget);

      final markAllButton = find.byKey(
        const Key('mark_all_notifications_read'),
      );
      expect(
        tester.widget<ButtonStyleButton>(markAllButton).onPressed,
        isNotNull,
      );

      await tester.tap(markAllButton);
      await tester.pumpAndSettle();

      expect(repository.markAllCalls, 1);
      expect(find.text('Bạn đã đọc hết'), findsOneWidget);
      expect(
        find.text('Đã đánh dấu tất cả thông báo là đã đọc.'),
        findsOneWidget,
      );
      expect(tester.widget<ButtonStyleButton>(markAllButton).onPressed, isNull);

      await tester.tap(find.text('Chưa đọc'));
      await tester.pumpAndSettle();

      expect(find.text('Bạn đã xem hết thông báo'), findsOneWidget);
      expect(find.text('Nhiệm vụ đã hoàn thành'), findsNothing);

      await tester.tap(find.text('Tất cả'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cảnh báo: NO2 vượt ngưỡng — Ao A3'));
      await tester.pumpAndSettle();

      expect(find.text('Chi tiết thông báo'), findsOneWidget);
      expect(
        find.byKey(const Key('notification_detail_sheet')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('notification_detail_sheet')),
          matching: find.text(
            'Chỉ số NO2 đã vượt ngưỡng cho phép, cần xử lý sớm.',
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('Xem vụ nuôi'), findsOneWidget);
      expect(find.text('Đã đọc lúc'), findsNothing);
      expect(repository.detailCalls, 0);
      expect(
        tester
            .widget<InkWell>(
              find.byKey(const Key('notification_action_button')),
            )
            .onTap,
        isNull,
      );

      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('notification_detail_sheet')),
        findsOneWidget,
      );
    });

    testWidgets(
      'mark all as read shows error snackbar when BE fails for ${role.name}',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final repository = _NotificationRepository(failMarkAll: true);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(_AuthRepository(role)),
              notificationRepositoryProvider.overrideWithValue(repository),
            ],
            child: const SmartShrimpApp(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Thông báo'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('mark_all_notifications_read')));
        await tester.pumpAndSettle();

        expect(repository.markAllCalls, 1);
        expect(
          find.text('Không thể đánh dấu tất cả là đã đọc.'),
          findsOneWidget,
        );
        expect(find.text('1 thông báo chưa đọc'), findsOneWidget);
      },
    );
  }
}

final class _PersonnelRepository implements PersonnelRepository {
  String? requestedPersonnelId;

  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) async => const ManagedPersonnelPage(
    items: [],
    limit: 20,
    totalResults: 0,
    hasNextPage: false,
  );

  @override
  Future<ManagedPersonnelDetail> getPersonnelById(String personnelId) async {
    requestedPersonnelId = personnelId;
    throw const ApiException('Nhân sự không còn khả dụng.', statusCode: 404);
  }
}

final class _AssignedSeasonRepository implements AssignedSeasonRepository {
  String? requestedSeasonId;

  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = 20,
  }) async => const AssignedSeasonPage(
    items: [],
    totalResults: 0,
    activeResults: 0,
    allResults: 0,
    hasNextPage: false,
  );

  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async {
    requestedSeasonId = seasonId;
    return AssignedSeasonDetail(
      id: seasonId,
      name: 'Vụ thử nghiệm',
      status: AssignedSeasonStatus.planning,
      shrimpType: 'WHITELEG',
      pondId: 'pond-1',
      pondName: 'Ao thử nghiệm',
      pondType: 'AQUACULTURE',
      pondStatus: 'AVAILABLE',
      farmId: 'farm-1',
      farmName: 'Trang trại thử nghiệm',
      personnel: [],
      otherAssignedSeasons: [],
      assignedAt: DateTime(2026, 10, 2),
    );
  }
}

final class _AuthRepository implements AuthRepository {
  const _AuthRepository(this.role);

  final AccountRole role;

  AuthAccount get _account => AuthAccount(
    id: 'account-1',
    email: 'test@smartshrimp.vn',
    role: role,
    status: AccountStatus.active,
  );

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => _account;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => _account;
}

final class _NotificationRepository implements NotificationRepository {
  _NotificationRepository({this.failMarkAll = false, this.assignment});

  final bool failMarkAll;
  final AppNotification? assignment;
  int detailCalls = 0;
  int markAllCalls = 0;
  bool _allRead = false;

  final AppNotification _warning = AppNotification(
    id: 'notification-1',
    title: 'Cảnh báo: NO2 vượt ngưỡng — Ao A3',
    type: NotificationType.waterThresholdExceeded,
    createdAt: DateTime(2026, 9, 27, 6, 15),
    content: 'Chỉ số NO2 đã vượt ngưỡng cho phép, cần xử lý sớm.',
  );

  final AppNotification _completedTask = AppNotification(
    id: 'notification-2',
    title: 'Nhiệm vụ đã hoàn thành',
    type: NotificationType.taskCompleted,
    readAt: DateTime(2026, 9, 26, 15, 45),
    createdAt: DateTime(2026, 9, 26, 15, 40),
  );

  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    NotificationCategory category = NotificationCategory.all,
    String? cursor,
    int limit = 10,
  }) async {
    final source = assignment ?? _warning;
    final warning = _allRead
        ? source.copyWith(readAt: DateTime(2026, 9, 27, 7))
        : source;
    final readItems = switch (readStatus) {
      NotificationReadStatus.all => <AppNotification>[warning, _completedTask],
      NotificationReadStatus.unread => <AppNotification>[
        if (!_allRead) warning,
      ],
      NotificationReadStatus.read => <AppNotification>[
        if (_allRead) warning,
        _completedTask,
      ],
    };
    final items = switch (category) {
      NotificationCategory.all => readItems,
      NotificationCategory.action =>
        readItems
            .where(
              (notification) =>
                  notification.isUnread && notification.referenceId != null,
            )
            .toList(growable: false),
      NotificationCategory.warning =>
        readItems
            .where(
              (notification) =>
                  notification.type ==
                      NotificationType.waterThresholdExceeded ||
                  notification.type ==
                      NotificationType.scheduleGenerationFailed,
            )
            .toList(growable: false),
    };
    return NotificationPage(
      items: items,
      totalResults: items.length,
      hasNextPage: false,
    );
  }

  @override
  Future<AppNotification> getNotification(String id) async {
    detailCalls++;
    return _warning.copyWith(
      readAt: DateTime(2026, 9, 27, 7),
      content: 'Chỉ số NO2 đã vượt ngưỡng cho phép, cần xử lý sớm.',
    );
  }

  @override
  Future<int> markAllAsRead() async {
    markAllCalls++;
    if (failMarkAll) {
      throw const ApiException(
        'Không thể đánh dấu tất cả là đã đọc.',
        statusCode: 500,
      );
    }
    if (_allRead) return 0;
    _allRead = true;
    return 1;
  }
}
