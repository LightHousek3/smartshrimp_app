import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';

void main() {
  group('ErrorMapper', () {
    test('maps connectivity failures to NetworkException', () {
      final request = RequestOptions(path: '/profile');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      );

      expect(ErrorMapper.fromDio(error), isA<NetworkException>());
    });

    test('preserves backend status, message and validation details', () {
      final request = RequestOptions(path: '/profile');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: request,
          statusCode: 400,
          data: <String, dynamic>{
            'success': false,
            'statusCode': 400,
            'message': 'Invalid phone',
            'errors': <String, dynamic>{'phone': 'invalid'},
          },
        ),
      );

      final mapped = ErrorMapper.fromDio(error);

      expect(mapped, isA<ApiException>());
      expect(mapped.statusCode, 400);
      expect(mapped.message, 'Invalid phone');
      expect(mapped.details, <String, dynamic>{'phone': 'invalid'});
    });

    test('uses a status-specific fallback for malformed error bodies', () {
      final request = RequestOptions(path: '/profile');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<void>(requestOptions: request, statusCode: 429),
      );

      final mapped = ErrorMapper.fromDio(error);

      expect(mapped.statusCode, 429);
      expect(mapped.message, 'Bạn thao tác quá nhanh. Vui lòng thử lại sau.');
    });
  });
}
