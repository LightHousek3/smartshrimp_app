import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/pages/notification_list_page.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';

void main() {
  for (final role in <AccountRole>[
    AccountRole.farmOwner,
    AccountRole.technician,
  ]) {
    testWidgets('home bell opens notifications for ${role.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1533, 728);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_AuthRepository(role)),
            notificationRepositoryProvider.overrideWithValue(
              const _NotificationRepository(unreadCount: 25),
            ),
          ],
          child: const SmartShrimpApp(),
        ),
      );
      await tester.pumpAndSettle();

      final bell = find.byTooltip('Mở thông báo');
      expect(bell, findsOneWidget);
      expect(
        find.byKey(const Key('home_unread_notification_badge')),
        findsOneWidget,
      );
      expect(find.text('25'), findsOneWidget);
      expect(find.text('Thông báo'), findsNothing);
      expect(find.text('Nhân sự'), findsNothing);
      expect(tester.getTopRight(bell).dx, greaterThan(1450));
      expect(tester.getTopRight(bell).dy, lessThan(100));

      await tester.tap(bell);
      await tester.pumpAndSettle();
      expect(find.byType(NotificationListPage), findsOneWidget);
      expect(find.byTooltip('Mở thông báo'), findsNothing);
      await tester.tap(find.byTooltip('Về Trang chủ'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Mở thông báo'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });
  }

  testWidgets('home bell shows zero when there are no unread items', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _AuthRepository(AccountRole.farmOwner),
          ),
          notificationRepositoryProvider.overrideWithValue(
            const _NotificationRepository(unreadCount: 0),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Mở thông báo'), findsOneWidget);
    expect(
      find.byKey(const Key('home_unread_notification_badge')),
      findsOneWidget,
    );
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('home bell shows an error marker when unread count fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _AuthRepository(AccountRole.farmOwner),
          ),
          notificationRepositoryProvider.overrideWithValue(
            const _NotificationRepository(unreadCount: 0, fail: true),
          ),
        ],
        child: const SmartShrimpApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Mở thông báo'), findsOneWidget);
    expect(find.text('!'), findsOneWidget);
  });
}

final class _AuthRepository implements AuthRepository {
  const _AuthRepository(this.role);

  final AccountRole role;

  AuthAccount get _account => AuthAccount(
    id: 'c1f4050f-95ea-4bf4-897f-808000000001',
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
  const _NotificationRepository({required this.unreadCount, this.fail = false});

  final int unreadCount;
  final bool fail;

  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    String? cursor,
  }) async {
    if (fail) throw StateError('Notification API unavailable');
    return NotificationPage(
      items: <AppNotification>[],
      totalResults: readStatus == NotificationReadStatus.unread
          ? unreadCount
          : 0,
      hasNextPage: false,
    );
  }

  @override
  Future<AppNotification> getNotification(String id) =>
      throw UnimplementedError();
}
