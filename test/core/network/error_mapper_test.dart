import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';

void main() {
  group('ErrorMapper', () {
    test('preserves operational errorCode for harvest field errors', () {
      final request = RequestOptions(path: '/owner/seasons/season/harvests');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: request,
          statusCode: 400,
          data: {
            'message': 'Population changed',
            'errorCode': 'HARVEST_POPULATION_MISMATCH',
          },
        ),
      );
      expect(ErrorMapper.fromDio(error).details, {
        'code': 'HARVEST_POPULATION_MISMATCH',
      });
    });
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
            'message': 'Số điện thoại không hợp lệ.',
            'errors': <String, dynamic>{'phone': 'invalid'},
          },
        ),
      );

      final mapped = ErrorMapper.fromDio(error);

      expect(mapped, isA<ApiException>());
      expect(mapped.statusCode, 400);
      expect(mapped.message, 'Số điện thoại không hợp lệ.');
      expect(mapped.details, <String, dynamic>{'phone': 'invalid'});
    });

    test('server diagnostics and unlocalized validation are not displayed', () {
      final request = RequestOptions(path: '/profile');
      AppException map(int statusCode, String message) => ErrorMapper.fromDio(
        DioException.badResponse(
          statusCode: statusCode,
          requestOptions: request,
          response: Response(
            requestOptions: request,
            statusCode: statusCode,
            data: {'message': message},
          ),
        ),
      );

      expect(
        map(503, 'Lỗi dữ liệu tài khoản riêng tư').message,
        'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
      );
      expect(
        map(400, '"email" must be a valid email').message,
        'Dữ liệu yêu cầu không hợp lệ.',
      );
      expect(
        map(409, 'Lỗi PrismaClientKnownRequestError: P2028').message,
        'Dữ liệu đã thay đổi hoặc bị trùng lặp.',
      );
      expect(
        ErrorMapper.displayMessage(StateError('raw details')),
        'Yêu cầu không thể hoàn tất. Vui lòng thử lại.',
      );
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
