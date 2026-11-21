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
    final message =
        statusCode != null &&
            statusCode >= 400 &&
            statusCode < 500 &&
            body is Map<String, dynamic>
        ? _businessMessage(body['message'])
        : null;
    final details = body is Map<String, dynamic>
        ? body['errors'] ??
              (body['errorCode'] is String ? {'code': body['errorCode']} : null)
        : null;

    return ApiException(
      message ?? _fallbackMessage(statusCode),
      statusCode: statusCode,
      details: details,
    );
  }

  /// Keep localized business guidance and use app copy for technical failures.
  static String displayMessage(Object? error, {String? fallback}) {
    if (error is AppException) {
      final statusCode = error.statusCode;
      if (statusCode != null && statusCode >= 500) {
        return _fallbackMessage(statusCode);
      }
      return _businessMessage(error.message) ??
          (statusCode == null ? _businessMessage(fallback) : null) ??
          _fallbackMessage(statusCode);
    }
    return _businessMessage(fallback) ?? _fallbackMessage(null);
  }

  static final _localized = RegExp(
    r'[àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵđ]',
    caseSensitive: false,
  );
  static final _diagnostic = RegExp(
    r'\b(?:prismaclient\w*|sqlstate|stack trace|traceback|typeerror|syntaxerror|dioexception|socketexception|econn\w+|p20\d{2}|backend|api key|[a-z]+_[a-z_]+_key)\b|[<>{}\x00-\x1f]',
    caseSensitive: false,
  );

  static String? _businessMessage(Object? value) {
    if (value is! String) return null;
    final message = value.trim();
    if (message.length > 500 ||
        !_localized.hasMatch(message) ||
        _diagnostic.hasMatch(message)) {
      return null;
    }
    return message;
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
