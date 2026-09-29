import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

void main() {
  test(
    'maps list filters, detail id, and markAllAsRead to remote data source',
    () async {
      final remote = _FakeNotificationRemoteDataSource();
      final repository = NotificationRepositoryImpl(remote);

      await repository.getNotifications(
        readStatus: NotificationReadStatus.unread,
        cursor: 'cursor-1',
      );
      await repository.getNotification('notification-1');
      final updatedCount = await repository.markAllAsRead();

      expect(remote.lastQuery, <String, dynamic>{
        'readStatus': 'unread',
        'limit': 20,
        'cursor': 'cursor-1',
      });
      expect(remote.lastId, 'notification-1');
      expect(remote.markAllCalls, 1);
      expect(updatedCount, 2);
    },
  );
}

final _notification = AppNotification(
  id: 'notification-1',
  title: 'Cảnh báo môi trường',
  type: NotificationType.waterThresholdExceeded,
  createdAt: DateTime(2026, 9, 27, 6, 15),
);

final class _FakeNotificationRemoteDataSource
    implements NotificationRemoteDataSource {
  Map<String, dynamic>? lastQuery;
  String? lastId;
  int markAllCalls = 0;

  @override
  Future<NotificationPage> getNotifications(Map<String, dynamic> query) async {
    lastQuery = query;
    return NotificationPage(
      items: <AppNotification>[_notification],
      totalResults: 1,
      hasNextPage: false,
    );
  }

  @override
  Future<AppNotification> getNotification(String id) async {
    lastId = id;
    return _notification;
  }

  @override
  Future<int> markAllAsRead() async {
    markAllCalls++;
    return 2;
  }
}
