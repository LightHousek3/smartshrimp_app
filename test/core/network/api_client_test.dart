import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';

void main() {
  group('ApiClient', () {
    test(
      'sends a public request without authorization and parses data',
      () async {
        final store = _FakeSessionStore();
        late RequestOptions capturedRequest;
        final client = ApiClient(
          _dioWithHandler((request, handler) {
            capturedRequest = request;
            handler.resolve(
              _success(request, data: <String, dynamic>{'ok': true}),
            );
          }),
          store,
        );

        final response = await client.post(
          '/auth/login',
          authenticated: false,
          data: <String, dynamic>{'email': 'owner@example.com'},
        );

        expect(capturedRequest.headers['Authorization'], isNull);
        expect(response.requireMapData()['ok'], isTrue);
        expect(store.initializeCalls, 0);
      },
    );

    test('accepts a no-content response without an envelope', () async {
      final client = ApiClient(
        _dioWithHandler((request, handler) {
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: request,
              statusCode: 204,
            ),
          );
        }),
        _FakeSessionStore(),
      );

      final response = await client.patch('/resource', authenticated: false);

      expect(response.data, isNull);
    });

    test(
      'attaches the current access token to authenticated requests',
      () async {
        final store = _FakeSessionStore(accessToken: 'access-token');
        late RequestOptions capturedRequest;
        final client = ApiClient(
          _dioWithHandler((request, handler) {
            capturedRequest = request;
            handler.resolve(
              _success(request, data: <String, dynamic>{'id': 'account-1'}),
            );
          }),
          store,
        );

        await client.get('/profile', authenticated: true);

        expect(capturedRequest.headers['Authorization'], 'Bearer access-token');
        expect(store.initializeCalls, 1);
      },
    );

    test('refreshes once and retries a request rejected with 401', () async {
      final store = _FakeSessionStore(
        accessToken: 'expired-access-token',
        refreshToken: 'refresh-token',
      );
      var profileCalls = 0;
      var refreshCalls = 0;
      final client = ApiClient(
        _dioWithHandler((request, handler) {
          if (request.path.endsWith('/auth/refresh-token')) {
            refreshCalls++;
            handler.resolve(_refreshSuccess(request));
            return;
          }

          profileCalls++;
          if (profileCalls == 1) {
            handler.reject(_httpError(request, 401, 'Expired access token'));
            return;
          }
          handler.resolve(
            _success(request, data: <String, dynamic>{'id': 'account-1'}),
          );
        }),
        store,
      );

      final response = await client.get('/profile', authenticated: true);

      expect(response.requireMapData()['id'], 'account-1');
      expect(profileCalls, 2);
      expect(refreshCalls, 1);
      expect(store.accessToken, 'new-access-token');
      expect(store.refreshToken, 'new-refresh-token');
    });

    test(
      'shares one refresh across concurrent authenticated requests',
      () async {
        final store = _FakeSessionStore(refreshToken: 'refresh-token');
        var refreshCalls = 0;
        final client = ApiClient(
          _dioWithHandler((request, handler) async {
            if (request.path.endsWith('/auth/refresh-token')) {
              refreshCalls++;
              await Future<void>.delayed(const Duration(milliseconds: 10));
              handler.resolve(_refreshSuccess(request));
              return;
            }
            handler.resolve(
              _success(request, data: <String, dynamic>{'id': 'account-1'}),
            );
          }),
          store,
        );

        await Future.wait(<Future<Object?>>[
          client.get('/profile', authenticated: true),
          client.get('/profile', authenticated: true),
        ]);

        expect(refreshCalls, 1);
      },
    );

    test('does not rotate tokens twice for concurrent 401 responses', () async {
      final store = _FakeSessionStore(
        accessToken: 'expired-access-token',
        refreshToken: 'refresh-token',
      );
      var refreshCalls = 0;
      final client = ApiClient(
        _dioWithHandler((request, handler) async {
          if (request.path.endsWith('/auth/refresh-token')) {
            refreshCalls++;
            await Future<void>.delayed(const Duration(milliseconds: 10));
            handler.resolve(_refreshSuccess(request));
            return;
          }
          if (request.headers['Authorization'] ==
              'Bearer expired-access-token') {
            handler.reject(_httpError(request, 401, 'Expired access token'));
            return;
          }
          handler.resolve(
            _success(request, data: <String, dynamic>{'id': 'account-1'}),
          );
        }),
        store,
      );

      await Future.wait(<Future<Object?>>[
        client.get('/profile', authenticated: true),
        client.get('/profile', authenticated: true),
      ]);

      expect(refreshCalls, 1);
    });

    test(
      'clears an invalid refresh session and reports session expiry',
      () async {
        final store = _FakeSessionStore(refreshToken: 'invalid-refresh-token');
        final client = ApiClient(
          _dioWithHandler((request, handler) {
            handler.reject(_httpError(request, 401, 'Invalid refresh token'));
          }),
          store,
        );

        await expectLater(
          client.get('/profile', authenticated: true),
          throwsA(
            isA<SessionExpiredException>().having(
              (error) => error.message,
              'message',
              'Invalid refresh token',
            ),
          ),
        );
        expect(store.clearCalls, 1);
        expect(store.refreshToken, isNull);
      },
    );

    test('clears a refresh session with a malformed token payload', () async {
      final store = _FakeSessionStore(refreshToken: 'refresh-token');
      final client = ApiClient(
        _dioWithHandler((request, handler) {
          handler.resolve(
            _success(
              request,
              data: <String, dynamic>{'accessToken': 'access-token-only'},
            ),
          );
        }),
        store,
      );

      await expectLater(
        client.get('/profile', authenticated: true),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(store.clearCalls, 1);
      expect(store.refreshToken, isNull);
    });

    test(
      'stops after one retry when the renewed access token is rejected',
      () async {
        final store = _FakeSessionStore(
          accessToken: 'expired-access-token',
          refreshToken: 'refresh-token',
        );
        var profileCalls = 0;
        var refreshCalls = 0;
        final client = ApiClient(
          _dioWithHandler((request, handler) {
            if (request.path.endsWith('/auth/refresh-token')) {
              refreshCalls++;
              handler.resolve(_refreshSuccess(request));
              return;
            }
            profileCalls++;
            handler.reject(_httpError(request, 401, 'Account is unauthorized'));
          }),
          store,
        );

        await expectLater(
          client.get('/profile', authenticated: true),
          throwsA(isA<SessionExpiredException>()),
        );
        expect(profileCalls, 2);
        expect(refreshCalls, 1);
        expect(store.clearCalls, 1);
      },
    );
  });
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
  Object? data,
}) {
  return Response<Map<String, dynamic>>(
    requestOptions: request,
    statusCode: 200,
    data: <String, dynamic>{
      'success': true,
      'message': 'Success',
      'data': data,
    },
  );
}

Response<Map<String, dynamic>> _refreshSuccess(RequestOptions request) {
  return _success(
    request,
    data: <String, dynamic>{
      'account': <String, dynamic>{'id': 'account-1'},
      'accessToken': 'new-access-token',
      'refreshToken': 'new-refresh-token',
    },
  );
}

DioException _httpError(
  RequestOptions request,
  int statusCode,
  String message,
) {
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: request,
      statusCode: statusCode,
      data: <String, dynamic>{
        'success': false,
        'statusCode': statusCode,
        'message': message,
      },
    ),
  );
}

final class _FakeSessionStore implements SessionStore {
  _FakeSessionStore({this.accessToken, this.refreshToken});

  @override
  String? accessToken;

  @override
  String? refreshToken;

  int initializeCalls = 0;
  int clearCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }

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
    clearCalls++;
    accessToken = null;
    refreshToken = null;
  }
}
