import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';

void main() {
  test(
    'markAllAsRead sends authenticated PATCH /notifications/read-all and returns updatedCount',
    () async {
      RequestOptions? capturedRequest;
      final client = ApiClient(
        _dioWithHandler((request, handler) {
          capturedRequest = request;
          handler.resolve(
            _success(
              request,
              data: <String, dynamic>{
                'updatedCount': 3,
                'readAt': '2026-09-27T07:00:00.000Z',
              },
            ),
          );
        }),
        _FakeSessionStore(),
      );
      final service = NotificationApiService(client);

      final count = await service.markAllAsRead();

      expect(count, 3);
      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.method, 'PATCH');
      expect(capturedRequest!.uri.path, '/notifications/read-all');
      expect(capturedRequest!.headers['Authorization'], 'Bearer access-token');
    },
  );

  test('markAllAsRead supports zero unread notifications boundary', () async {
    final client = ApiClient(
      _dioWithHandler((request, handler) {
        handler.resolve(
          _success(
            request,
            data: <String, dynamic>{
              'updatedCount': 0,
              'readAt': '2026-09-27T07:00:00.000Z',
            },
          ),
        );
      }),
      _FakeSessionStore(),
    );
    final service = NotificationApiService(client);

    final count = await service.markAllAsRead();

    expect(count, 0);
  });

  for (final invalidData in <Map<String, dynamic>>[
    <String, dynamic>{'updatedCount': -1, 'readAt': '2026-09-27T07:00:00.000Z'},
    <String, dynamic>{
      'updatedCount': '3',
      'readAt': '2026-09-27T07:00:00.000Z',
    },
    <String, dynamic>{'updatedCount': 2, 'readAt': 'not-a-date'},
    <String, dynamic>{'updatedCount': 2},
  ]) {
    test(
      'markAllAsRead throws InvalidResponseException for invalid payload $invalidData',
      () async {
        final client = ApiClient(
          _dioWithHandler((request, handler) {
            handler.resolve(_success(request, data: invalidData));
          }),
          _FakeSessionStore(),
        );
        final service = NotificationApiService(client);

        await expectLater(
          service.markAllAsRead(),
          throwsA(isA<InvalidResponseException>()),
        );
      },
    );
  }
}

Dio _dioWithHandler(
  FutureOr<void> Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}

Response<Map<String, dynamic>> _success(
  RequestOptions request, {
  required Object data,
  Map<String, dynamic>? meta,
}) {
  return Response<Map<String, dynamic>>(
    requestOptions: request,
    statusCode: 200,
    data: <String, dynamic>{
      'success': true,
      'message': 'Success',
      'data': data,
      'meta': ?meta,
    },
  );
}

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';

  @override
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

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
}
