import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/personnel/data/services/personnel_api_service.dart';

void main() {
  test(
    'requests the authenticated personnel list with exact filters',
    () async {
      late RequestOptions capturedRequest;
      final service = PersonnelApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            capturedRequest = request;
            handler.resolve(
              _success(
                request,
                data: <Object?>[_personnelJson()],
                meta: <String, dynamic>{
                  'limit': 20,
                  'totalResults': 1,
                  'hasNextPage': false,
                  'nextCursor': null,
                },
              ),
            );
          }),
          _FakeSessionStore(),
        ),
      );

      final page = await service.getPersonnel(<String, dynamic>{
        'limit': 20,
        'role': 'TECHNICIAN',
        'status': 'ACTIVE',
        'search': 'an',
      });

      expect(capturedRequest.method, 'GET');
      expect(capturedRequest.path, '/owner/personnel');
      expect(capturedRequest.headers['Authorization'], 'Bearer access-token');
      expect(capturedRequest.queryParameters, <String, dynamic>{
        'limit': 20,
        'role': 'TECHNICIAN',
        'status': 'ACTIVE',
        'search': 'an',
      });
      expect(page.items.single.id, 'personnel-1');
    },
  );

  test('requests and parses personnel detail', () async {
    late RequestOptions capturedRequest;
    final service = PersonnelApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          capturedRequest = request;
          handler.resolve(
            _success(
              request,
              data: _personnelJson(updatedAt: '2026-09-22T08:30:00.000Z'),
            ),
          );
        }),
        _FakeSessionStore(),
      ),
    );

    final personnel = await service.getPersonnelById('personnel 1');

    expect(capturedRequest.method, 'GET');
    expect(capturedRequest.path, '/owner/personnel/personnel%201');
    expect(personnel.updatedAt, DateTime.utc(2026, 9, 22, 8, 30));
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
  required Object? data,
  Map<String, dynamic>? meta,
}) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{
    'success': true,
    'message': 'Success',
    'data': data,
    'meta': ?meta,
  },
);

Map<String, dynamic> _personnelJson({String? updatedAt}) => <String, dynamic>{
  'id': 'personnel-1',
  'email': 'technician@smartshrimp.vn',
  'phone': null,
  'fullName': 'Nguyễn Văn Kỹ Thuật',
  'avatarUrl': null,
  'role': 'TECHNICIAN',
  'status': 'ACTIVE',
  'currentSeasonAssignments': 1,
  'createdAt': '2026-09-01T08:30:00.000Z',
  'activatedAt': null,
  'lastLoginAt': null,
  'updatedAt': ?updatedAt,
};

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';

  @override
  String? refreshToken = 'refresh-token';

  @override
  Future<void> clear() async {}

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
