import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

void main() {
  test(
    'owner notification contract preserves pending protocol content and read state',
    () async {
      final requests = <RequestOptions>[];
      final payload = <String, dynamic>{
        'id': 'notification-id',
        'title': 'Phác đồ nuôi đang chờ duyệt',
        'type': 'PRODUCTION_PROTOCOL_PENDING',
        'referenceType': 'protocol',
        'referenceId': 'protocol-id',
        'content': 'Phác đồ Feed (v2), vụ 1, ao A đang chờ chủ trại duyệt.',
        'readAt': null,
        'createdAt': '2026-10-16T07:00:00.000Z',
      };
      final client = ApiClient(
        _dioWithHandler((request, handler) {
          requests.add(request);
          final isList = request.uri.path == '/notifications';
          handler.resolve(
            _success(
              request,
              data: isList
                  ? <Object>[payload]
                  : <String, dynamic>{
                      ...payload,
                      'readAt': '2026-10-16T07:01:00.000Z',
                    },
              meta: isList
                  ? <String, dynamic>{
                      'limit': 20,
                      'totalResults': 1,
                      'hasNextPage': false,
                      'nextCursor': null,
                    }
                  : null,
            ),
          );
        }),
        _FakeSessionStore(),
      );
      final service = NotificationApiService(client);
      final page = await service.getNotifications(<String, dynamic>{
        'readStatus': 'unread',
      });
      final notification = page.items.single;
      expect(notification.type, NotificationType.productionProtocolPending);
      expect(notification.referenceType, 'protocol');
      expect(notification.referenceId, 'protocol-id');
      expect(notification.content, payload['content']);
      expect(notification.isUnread, isTrue);
      final detail = await service.getNotification(notification.id);
      expect(detail.isUnread, isFalse);
      expect(detail.content, notification.content);
      expect(requests.map((request) => request.method), everyElement('GET'));
      expect(
        requests.map((request) => request.headers['Authorization']),
        everyElement('Bearer access-token'),
      );
      expect(requests.last.uri.path, '/notifications/notification-id');
    },
  );
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
