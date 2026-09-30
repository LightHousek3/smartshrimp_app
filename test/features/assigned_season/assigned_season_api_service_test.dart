import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/assigned_season/data/services/assigned_season_api_service.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';

void main() {
  test('parses list counts and all season statuses', () async {
    final statuses = <String>['PLANNING', 'ACTIVE', 'COMPLETED', 'CANCELLED'];
    final service = AssignedSeasonApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          handler.resolve(
            _success(
              request,
              data: <Object?>[
                for (var i = 0; i < statuses.length; i++)
                  _seasonJson(id: 'season-$i', status: statuses[i]),
              ],
              meta: <String, dynamic>{
                'limit': 20,
                'totalResults': 4,
                'activeResults': 1,
                'allResults': 4,
                'hasNextPage': false,
                'nextCursor': null,
              },
            ),
          );
        }),
        _FakeSessionStore(),
      ),
    );

    final page = await service.getAssignedSeasons(<String, dynamic>{
      'limit': 20,
    });

    expect(page.activeResults, 1);
    expect(page.allResults, 4);
    expect(page.items.map((item) => item.status), <AssignedSeasonStatus>[
      AssignedSeasonStatus.planning,
      AssignedSeasonStatus.active,
      AssignedSeasonStatus.completed,
      AssignedSeasonStatus.cancelled,
    ]);
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
  required Map<String, dynamic> meta,
}) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{
    'success': true,
    'message': 'Success',
    'data': data,
    'meta': meta,
  },
);

Map<String, dynamic> _seasonJson({
  required String id,
  required String status,
}) => <String, dynamic>{
  'id': id,
  'name': 'Vụ $id',
  'status': status,
  'shrimpType': 'WHITELEG',
  'stockingDate': '2026-09-01',
  'expectedEndDate': null,
  'initialBiomassKg': 10,
  'pond': <String, dynamic>{
    'id': 'pond-$id',
    'name': 'Ao $id',
    'status': 'AVAILABLE',
  },
  'farm': <String, dynamic>{'id': 'farm-1', 'name': 'Trại 1'},
  'assignment': <String, dynamic>{'assignedAt': '2026-09-01T00:00:00.000Z'},
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
