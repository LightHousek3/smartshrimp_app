import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/home/data/owner_dashboard_api_service.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';

void main() {
  test(
    'N: finance GET uses Bearer and date-only filter query through ApiClient',
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
                  'data': {
                    'from': '2026-07-01',
                    'to': '2026-08-09',
                    'months': [
                      {'month': '2026-07', 'income': 1, 'cost': 0},
                      {'month': '2026-08', 'income': 0, 'cost': 0},
                    ],
                    'totals': {'income': 1, 'cost': 0, 'profit': 1},
                  },
                },
              ),
            );
          },
        ),
      );
      final api = OwnerDashboardApiService(ApiClient(dio, _Store()));
      final result = await api.getFinance(
        FinanceFilter(
          farmId: 'farm',
          period: FinancePeriod.custom,
          from: DateTime(2026, 7, 1),
          to: DateTime(2026, 8, 9),
        ),
      );
      expect(result.totals.income, 1);
      expect(captured.method, 'GET');
      expect(captured.path, '/owner/dashboard/finance');
      expect(captured.headers['Authorization'], 'Bearer access');
      expect(captured.queryParameters, {
        'farmId': 'farm',
        'period': 'CUSTOM',
        'from': '2026-07-01',
        'to': '2026-08-09',
      });
      expect(captured.data, isNull);
    },
  );
  test(
    'A: malformed overview/finance maps to InvalidResponseException',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) => handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: {'success': true, 'message': 'Đã tải', 'data': {}},
            ),
          ),
        ),
      );
      final api = OwnerDashboardApiService(ApiClient(dio, _Store()));
      await expectLater(
        api.getOverview(),
        throwsA(isA<InvalidResponseException>()),
      );
      await expectLater(
        api.getFinance(const FinanceFilter()),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
}

class _Store implements SessionStore {
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
