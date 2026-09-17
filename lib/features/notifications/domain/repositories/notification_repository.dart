import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

enum NotificationReadStatus { all, unread, read }

abstract interface class NotificationRepository {
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    String? cursor,
  });

  /// The backend records the first read time when this detail request succeeds.
  Future<AppNotification> getNotification(String id);
}
