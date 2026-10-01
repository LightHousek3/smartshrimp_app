import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

enum NotificationReadStatus { all, unread, read }

enum NotificationCategory { all, action, warning }

abstract interface class NotificationRepository {
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    NotificationCategory category = NotificationCategory.all,
    String? cursor,
    int limit = 10,
  });

  /// The backend records the first read time when this detail request succeeds.
  Future<AppNotification> getNotification(String id);

  /// Marks every currently unread notification and returns the affected count.
  Future<int> markAllAsRead();
}
