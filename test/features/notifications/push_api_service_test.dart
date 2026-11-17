import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_api_service.dart';

final class _Store implements SessionStore {
  @override
  String? accessToken = 'access';
  @override
  String? refreshToken;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}

void main() {
  const serverSession = '80da4cc0-190c-46c1-90c9-2b38c925f076';
  String refresh(String id) =>
      'header.${base64Url.encode(utf8.encode(jsonEncode({'deviceId': id}))).replaceAll('=', '')}.signature';
  test(
    'N: register and unregister use the server-issued session, authenticated through ApiClient',
    () async {
      final store = _Store()..refreshToken = refresh(serverSession);
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: request.method == 'DELETE' ? 204 : 200,
                data: request.method == 'DELETE'
                    ? null
                    : {'success': true, 'message': 'Đã đăng ký'},
              ),
            );
          },
        ),
      );
      final api = PushApiService(ApiClient(dio, store), store);
      await api.register('installation-id', 'android');
      await api.unregister();
      expect(requests[0].data, {
        'deviceId': serverSession,
        'token': 'installation-id',
        'platform': 'android',
      });
      expect(requests[0].headers['Authorization'], 'Bearer access');
      expect(requests[1].method, 'DELETE');
      expect(requests[1].path, '/notifications/devices/$serverSession');
      expect(requests[0].data.toString(), isNot(contains(store.refreshToken)));
    },
  );
  for (final token in [
    null,
    'invalid',
    'header.***.signature',
    refresh('not-a-session'),
  ]) {
    test(
      'A: malformed or absent session is rejected before any device API call: $token',
      () async {
        final store = _Store()..refreshToken = token;
        var requests = 0;
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests++;
              handler.reject(DioException(requestOptions: request));
            },
          ),
        );
        final api = PushApiService(ApiClient(dio, store), store);
        await expectLater(
          api.register('installation-id', 'android'),
          throwsA(isA<SessionExpiredException>()),
        );
        expect(requests, 0);
      },
    );
  }
}
