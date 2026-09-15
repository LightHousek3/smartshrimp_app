import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

abstract final class ErrorMapper {
  static bool isNetworkFailure(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  static AppException fromDio(DioException error) {
    if (isNetworkFailure(error)) {
      return const NetworkException();
    }

    if (error.type == DioExceptionType.cancel) {
      return const ApiException('Yêu cầu đã bị hủy.');
    }

    final body = error.response?.data;
    final responseStatusCode = error.response?.statusCode;
    final bodyStatusCode = body is Map<String, dynamic>
        ? body['statusCode']
        : null;
    final statusCode =
        responseStatusCode ?? (bodyStatusCode is int ? bodyStatusCode : null);
    final message = body is Map<String, dynamic> && body['message'] is String
        ? body['message']! as String
        : _fallbackMessage(statusCode);
    final details = body is Map<String, dynamic> ? body['errors'] : null;

    return ApiException(message, statusCode: statusCode, details: details);
  }

  static String _fallbackMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'Dữ liệu yêu cầu không hợp lệ.',
      401 => 'Thông tin xác thực không hợp lệ.',
      403 => 'Bạn không có quyền thực hiện thao tác này.',
      404 => 'Không tìm thấy dữ liệu được yêu cầu.',
      409 => 'Dữ liệu đã thay đổi hoặc bị trùng lặp.',
      429 => 'Bạn thao tác quá nhanh. Vui lòng thử lại sau.',
      _ when statusCode != null && statusCode >= 500 =>
        'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
      _ => 'Yêu cầu không thể hoàn tất. Vui lòng thử lại.',
    };
  }
}
