import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    String? cursor,
  }) {
    final query = <String, dynamic>{'readStatus': readStatus.name, 'limit': 20};
    if (cursor != null) {
      query['cursor'] = cursor;
    }
    return _remoteDataSource.getNotifications(query);
  }

  @override
  Future<AppNotification> getNotification(String id) =>
      _remoteDataSource.getNotification(id);

  @override
  Future<int> markAllAsRead() => _remoteDataSource.markAllAsRead();
}
