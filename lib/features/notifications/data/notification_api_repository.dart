import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

final class NotificationApiRepository implements NotificationRepository {
  NotificationApiRepository(this._client);

  final ApiClient _client;

  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    String? cursor,
  }) async {
    final query = <String, dynamic>{'readStatus': readStatus.name, 'limit': 20};
    if (cursor != null) {
      query['cursor'] = cursor;
    }
    final response = await _client.get(
      '/notifications',
      authenticated: true,
      queryParameters: query,
    );
    return NotificationPage.parse(response.data, response.meta);
  }

  @override
  Future<AppNotification> getNotification(String id) async {
    final response = await _client.get(
      '/notifications/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return AppNotification.parse(response.requireMapData(), detail: true);
  }
}
