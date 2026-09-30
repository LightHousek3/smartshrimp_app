import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/data/services/farm_geocoding_service.dart';

void main() {
  test('geocodes a normalized address and caches equivalent lookups', () async {
    var requests = 0;
    late RequestOptions capturedRequest;
    final dio = _dioWithHandler((request, handler) {
      requests++;
      capturedRequest = request;
      handler.resolve(
        Response<List<dynamic>>(
          requestOptions: request,
          statusCode: 200,
          data: <dynamic>[
            <String, dynamic>{
              'lat': '10.4892',
              'lon': '107.1647',
              'display_name': 'Bà Rịa - Vũng Tàu, Việt Nam',
            },
          ],
        ),
      );
    });
    final service = NominatimFarmGeocodingService(dio);

    final first = await service.findByAddress('  Bà   Rịa  ');
    final cached = await service.findByAddress('bà rịa');

    expect(requests, 1);
    expect(capturedRequest.path, '/search');
    expect(capturedRequest.queryParameters['q'], 'Bà Rịa');
    expect(capturedRequest.queryParameters['countrycodes'], 'vn');
    expect(first, cached);
    expect(first?.latitude, 10.4892);
    expect(first?.longitude, 107.1647);
    expect(first?.displayAddress, 'Bà Rịa - Vũng Tàu, Việt Nam');
  });

  test('maps connection failures to a user-facing network error', () async {
    final dio = _dioWithHandler((request, handler) {
      handler.reject(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionError,
        ),
      );
    });
    final service = NominatimFarmGeocodingService(dio);

    await expectLater(
      service.findByAddress('Cà Mau'),
      throwsA(isA<NetworkException>()),
    );
  });
}

Dio _dioWithHandler(
  FutureOr<void> Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://nominatim.openstreetmap.org'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}
