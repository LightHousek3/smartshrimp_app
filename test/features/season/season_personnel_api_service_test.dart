import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';

void main() {
  test('assigns personnel with the exact authenticated request', () async {
    late RequestOptions capturedRequest;
    final service = SeasonApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          capturedRequest = request;
          handler.resolve(_success(request, data: _assignmentJson()));
        }),
        _FakeSessionStore(),
      ),
    );

    final result = await service.assignPersonnel('season 1', <String, dynamic>{
      'accountId': 'account-1',
      'role': 'TECHNICIAN',
    });

    expect(capturedRequest.method, 'POST');
    expect(
      capturedRequest.path,
      '/owner/seasons/season%201/personnel-assignments',
    );
    expect(capturedRequest.headers['Authorization'], 'Bearer access-token');
    expect(capturedRequest.data, <String, dynamic>{
      'accountId': 'account-1',
      'role': 'TECHNICIAN',
    });
    expect(result.id, 'assignment-1');
  });

  test('replaces personnel and parses handover counts', () async {
    late RequestOptions capturedRequest;
    final service = SeasonApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          capturedRequest = request;
          handler.resolve(
            _success(
              request,
              data: <String, dynamic>{
                'assignment': _assignmentJson(role: 'EXPERT'),
                'replacedAssignment': _assignmentJson(),
                'transferredTaskCount': 0,
                'transferredDiseaseCaseCount': 2,
              },
            ),
          );
        }),
        _FakeSessionStore(),
      ),
    );

    final result = await service
        .replacePersonnel('season-1', 'EXPERT', <String, dynamic>{
          'accountId': 'account-2',
          'expectedAssignmentId': 'assignment-old',
          'reason': 'Điều chuyển công tác',
        });

    expect(capturedRequest.method, 'POST');
    expect(
      capturedRequest.path,
      '/owner/seasons/season-1/personnel-assignments/EXPERT/replace',
    );
    expect(result.assignment.role, 'EXPERT');
    expect(result.transferredTaskCount, 0);
    expect(result.transferredDiseaseCaseCount, 2);
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
}) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{'success': true, 'message': 'Success', 'data': data},
);

Map<String, dynamic> _assignmentJson({String role = 'TECHNICIAN'}) =>
    <String, dynamic>{
      'id': 'assignment-1',
      'seasonId': 'season-1',
      'role': role,
      'assignedAt': '2026-09-30T08:30:00.000Z',
      'account': <String, dynamic>{
        'id': 'account-1',
        'email': 'personnel@smartshrimp.vn',
        'fullName': 'Nguyễn Văn Nhân Sự',
        'phone': null,
        'status': 'ACTIVE',
      },
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
