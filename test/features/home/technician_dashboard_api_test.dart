import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/home/data/technician_dashboard_api_service.dart';
import 'technician_dashboard_fixtures.dart';

void main() {
  test(
    'N: overview uses authenticated GET with no account, farm or date filter',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
      late RequestOptions captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            captured = request;
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'success': true,
                  'message': 'Đã tải',
                  'data': technicianDashboardJson(),
                },
              ),
            );
          },
        ),
      );
      final result = await TechnicianDashboardApiService(
        ApiClient(dio, _Store()),
      ).getOverview();
      expect(captured.method, 'GET');
      expect(captured.path, '/technician/dashboard');
      expect(captured.headers['Authorization'], 'Bearer access');
      expect(captured.queryParameters, isEmpty);
      expect(result.operationGroups.length, 4);
    },
  );

  test(
    'A: malformed overview data stays an error on the new endpoint',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {'success': true, 'message': 'Đã tải', 'data': []},
              ),
            );
          },
        ),
      );
      await expectLater(
        TechnicianDashboardApiService(ApiClient(dio, _Store())).getOverview(),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
}

final class _Store implements SessionStore {
  @override
  String? accessToken = 'access';
  @override
  String? refreshToken = 'refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
