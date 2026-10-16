import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/protocol/data/protocol_api_service.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'protocol_fixtures.dart';

void main() {
  late List<RequestOptions> requests;
  late ProtocolApiService service;
  late Object data;
  late int status;
  setUp(() {
    requests = [];
    data = detailJson();
    status = 200;
    final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          if (status >= 400) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: request,
                  statusCode: status,
                  data: {
                    'success': false,
                    'statusCode': status,
                    'message': 'Thông báo nghiệp vụ',
                  },
                ),
              ),
            );
          } else {
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: status,
                data: {
                  'success': true,
                  'message': 'Thành công',
                  'data': data,
                  'meta': {
                    'page': 1,
                    'hasNextPage': false,
                    'productionCount': 1,
                    'treatmentCount': 2,
                  },
                },
              ),
            );
          }
        },
      ),
    );
    service = ProtocolApiService(ApiClient(dio, _Store()));
  });
  test(
    'N: list sends only filters consumed by the screen with Authorization',
    () async {
      data = [cardJson()];
      final page = await service.list(
        seasonId: 'season-1',
        type: ProtocolType.production,
        pendingOnly: true,
      );
      expect(page.items, hasLength(1));
      final request = requests.single;
      expect(request.method, 'GET');
      expect(request.path, '/owner/protocols');
      expect(request.headers['Authorization'], 'Bearer access');
      expect(request.queryParameters, {
        'seasonId': 'season-1',
        'protocolType': 'PRODUCTION',
        'status': 'PENDING_APPROVAL',
        'page': 1,
        'limit': 20,
      });
    },
  );
  test('N: detail and selected day use distinct, lean endpoints', () async {
    expect((await service.detail('p')).durationDays, 90);
    data = {
      'day': 2,
      'rows': [dayRowJson()],
    };
    expect((await service.day('p', 2)).day, 2);
    expect(requests.map((r) => r.path), [
      '/owner/protocols/p',
      '/owner/protocols/p/days/2',
    ]);
  });
  test(
    'N: approval and rejection send the version, never an ownerId or client status',
    () async {
      final stamp = DateTime.parse('2026-06-20T02:00:00Z');
      await service.review('p', updatedAt: stamp, approve: true);
      expect(requests.last.path, '/owner/protocols/p/review');
      expect(requests.last.method, 'POST');
      expect(requests.last.data, {
        'decision': 'APPROVE',
        'updatedAt': stamp.toIso8601String(),
      });
      await service.review(
        'p',
        updatedAt: stamp,
        approve: false,
        reason: '  Cần sửa liều  ',
      );
      expect(requests.last.path, '/owner/protocols/p/review');
      expect(requests.last.data, {
        'updatedAt': stamp.toIso8601String(),
        'reason': 'Cần sửa liều',
        'decision': 'REJECT',
      });
    },
  );
  test('N: inventory trace is fetched only on demand', () async {
    data = [];
    expect(await service.inventory('p', 's'), isEmpty);
    expect(
      requests.single.path,
      '/owner/protocols/p/schedules/s/inventory-transactions',
    );
  });
  test('A: malformed detail maps to InvalidResponseException', () async {
    data = {'id': 'p'};
    await expectLater(
      service.detail('p'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  for (final code in [400, 403, 404, 409, 429, 500]) {
    test('A: preserves $code and the backend message', () async {
      status = code;
      await expectLater(
        service.detail('p'),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'status', code)
              .having((e) => e.message, 'message', 'Thông báo nghiệp vụ'),
        ),
      );
      expect(requests, hasLength(1));
    });
  }
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
