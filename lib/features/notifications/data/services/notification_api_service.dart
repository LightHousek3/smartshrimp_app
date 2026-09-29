import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

abstract interface class NotificationRemoteDataSource {
  Future<NotificationPage> getNotifications(Map<String, dynamic> query);

  Future<AppNotification> getNotification(String id);

  Future<int> markAllAsRead();
}

final class NotificationApiService implements NotificationRemoteDataSource {
  NotificationApiService(this._client);

  final ApiClient _client;
  static const _basePath = '/notifications';

  @override
  Future<NotificationPage> getNotifications(Map<String, dynamic> query) async {
    final response = await _client.get(
      _basePath,
      authenticated: true,
      queryParameters: query,
    );
    return NotificationPage.parse(response.data, response.meta);
  }

  @override
  Future<AppNotification> getNotification(String id) async {
    final response = await _client.get(
      '$_basePath/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return AppNotification.parse(response.requireMapData(), detail: true);
  }

  @override
  Future<int> markAllAsRead() async {
    final response = await _client.patch(
      '$_basePath/read-all',
      authenticated: true,
    );
    final data = response.requireMapData();
    final updatedCount = data['updatedCount'];
    final readAt = data['readAt'];
    if (updatedCount is! int ||
        updatedCount < 0 ||
        readAt is! String ||
        DateTime.tryParse(readAt) == null) {
      throw const InvalidResponseException();
    }
    return updatedCount;
  }
}
