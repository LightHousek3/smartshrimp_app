import 'dart:convert';

import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';

abstract interface class PushRemoteDataSource {
  Future<void> register(String token, String platform);
  Future<void> unregister();
}

final class PushApiService implements PushRemoteDataSource {
  PushApiService(this._client, this._session);

  final ApiClient _client;
  final SessionStore _session;

  /// This claim locates the server-issued session; only the backend establishes its ownership.
  String _sessionDeviceId() {
    try {
      final parts = (_session.refreshToken ?? '').split('.');
      if (parts.length == 3) {
        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        final id = payload is Map<String, dynamic> ? payload['deviceId'] : null;
        if (id is String &&
            RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
            ).hasMatch(id)) {
          return id;
        }
      }
    } on FormatException {
      throw const SessionExpiredException();
    }
    throw const SessionExpiredException();
  }

  /// The backend derives ownership from authentication and the live device session.
  @override
  Future<void> register(String token, String platform) async {
    await _client.put(
      '/notifications/devices',
      authenticated: true,
      data: <String, String>{
        'deviceId': _sessionDeviceId(),
        'token': token,
        'platform': platform,
      },
    );
  }

  @override
  Future<void> unregister() async {
    await _client.delete(
      '/notifications/devices/${Uri.encodeComponent(_sessionDeviceId())}',
      authenticated: true,
    );
  }
}
