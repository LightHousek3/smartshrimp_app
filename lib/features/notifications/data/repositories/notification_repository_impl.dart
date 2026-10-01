import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    NotificationCategory category = NotificationCategory.all,
    String? cursor,
    int limit = 10,
  }) {
    final query = <String, dynamic>{
      'readStatus': readStatus.name,
      'limit': limit,
      if (category != NotificationCategory.all) 'category': category.name,
    };
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
