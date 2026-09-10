sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException()
    : super(
        'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng và thử lại.',
      );
}

final class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode});
}

final class InvalidResponseException extends AppException {
  const InvalidResponseException()
    : super('Dữ liệu phản hồi từ máy chủ không hợp lệ.');
}

final class UnsupportedRoleException extends AppException {
  const UnsupportedRoleException()
    : super(
        'Ứng dụng này chỉ dành cho Kỹ thuật viên và Chủ trang trại.',
        statusCode: 403,
      );
}
