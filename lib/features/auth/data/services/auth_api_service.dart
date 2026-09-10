import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSession> login({
    required String email,
    required String password,
    required String deviceId,
  });

  Future<AuthSession> refresh(String refreshToken);

  Future<void> logout(String refreshToken);
}

final class AuthApiService implements AuthRemoteDataSource {
  AuthApiService(this._dio);

  final Dio _dio;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: <String, dynamic>{
          'email': email.trim().toLowerCase(),
          'password': password,
          'deviceId': deviceId,
        },
      ),
    );
    return AuthSession.fromLoginData(_dataFrom(response));
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: <String, dynamic>{'refreshToken': refreshToken},
      ),
    );
    return AuthSession.fromRefreshData(_dataFrom(response));
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/logout',
        data: <String, dynamic>{'refreshToken': refreshToken},
      ),
    );
  }

  Future<Response<Map<String, dynamic>>> _request(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
      }

      final responseData = error.response?.data;
      final message =
          responseData is Map<String, dynamic> &&
              responseData['message'] is String
          ? responseData['message']! as String
          : 'Yêu cầu không thể hoàn tất. Vui lòng thử lại.';
      throw ApiException(message, statusCode: error.response?.statusCode);
    }
  }

  Map<String, dynamic> _dataFrom(Response<Map<String, dynamic>> response) {
    final body = response.data;
    final data = body?['data'];
    if (body == null ||
        body['success'] != true ||
        data is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return data;
  }
}
