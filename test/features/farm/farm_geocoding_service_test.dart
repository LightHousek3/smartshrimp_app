import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/farm/data/services/farm_geocoding_service.dart';

void main() {
  test(
    'sends an authenticated address lookup and caches normalized input',
    () async {
      var requests = 0;
      late RequestOptions captured;
      final service = _service((request, handler) {
        requests++;
        captured = request;
        handler.resolve(
          _response(request, <String, dynamic>{
            'location': <String, dynamic>{
              'latitude': 10.4892,
              'longitude': 107.1647,
              'displayAddress': 'Bà Rịa - Vũng Tàu',
            },
          }),
        );
      });

      final first = await service.findByAddress('  Bà   Rịa  ');
      final cached = await service.findByAddress('bà rịa');

      expect(requests, 1);
      expect(captured.path, '/owner/farms/geocode');
      expect(captured.queryParameters, <String, dynamic>{'address': 'Bà Rịa'});
      expect(captured.headers['Authorization'], 'Bearer access-token');
      expect(first, cached);
      expect(first?.latitude, 10.4892);
      expect(first?.longitude, 107.1647);
    },
  );

  test('reverse lookup returns null when Goong finds no address', () async {
    final service = _service((request, handler) {
      expect(request.queryParameters, <String, dynamic>{
        'latitude': 10.4892,
        'longitude': 107.1647,
      });
      handler.resolve(_response(request, <String, dynamic>{'location': null}));
    });

    expect(
      await service.findByCoordinates(latitude: 10.4892, longitude: 107.1647),
      isNull,
    );
  });

  test('rejects invalid coordinates from the backend', () async {
    final service = _service((request, handler) {
      handler.resolve(
        _response(request, <String, dynamic>{
          'location': <String, dynamic>{'latitude': 100, 'longitude': 107},
        }),
      );
    });

    await expectLater(
      service.findByAddress('Cà Mau'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}

GoongFarmGeocodingService _service(
  FutureOr<void> Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return GoongFarmGeocodingService(ApiClient(dio, _Session()));
}

Response<Map<String, dynamic>> _response(
  RequestOptions request,
  Map<String, dynamic> data,
) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{'success': true, 'message': 'OK', 'data': data},
);

final class _Session implements SessionStore {
  @override
  String? get accessToken => 'access-token';

  @override
  String? get refreshToken => null;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}
