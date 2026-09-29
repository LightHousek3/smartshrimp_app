import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

void main() {
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
        find.text('Chỉ số NO2 đã vượt ngưỡng cho phép, cần xử lý sớm.'),
        findsOneWidget,
      );
      expect(find.text('Đã đọc lúc'), findsOneWidget);
      expect(repository.detailCalls, 1);
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
  _NotificationRepository({this.failMarkAll = false});

  final bool failMarkAll;
  int detailCalls = 0;
  int markAllCalls = 0;
  bool _allRead = false;

  final AppNotification _warning = AppNotification(
    id: 'notification-1',
    title: 'Cảnh báo: NO2 vượt ngưỡng — Ao A3',
    type: NotificationType.waterThresholdExceeded,
    createdAt: DateTime(2026, 9, 27, 6, 15),
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
    String? cursor,
  }) async {
    final warning = _allRead
        ? _warning.copyWith(readAt: DateTime(2026, 9, 27, 7))
        : _warning;
    final items = switch (readStatus) {
      NotificationReadStatus.all => <AppNotification>[warning, _completedTask],
      NotificationReadStatus.unread => <AppNotification>[
        if (!_allRead) warning,
      ],
      NotificationReadStatus.read => <AppNotification>[
        if (_allRead) warning,
        _completedTask,
      ],
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
