import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';

final class AuthenticatedApiClient {
  AuthenticatedApiClient(this._dio, this._sessionStore);

  final Dio _dio;
  final SessionStore _sessionStore;
  Future<String>? _refreshingAccessToken;

  Future<Response<Map<String, dynamic>>> get(String path) {
    return _request(path: path, method: 'GET');
  }

  Future<Response<Map<String, dynamic>>> patch(String path, {Object? data}) {
    return _request(path: path, method: 'PATCH', data: data);
  }

  Future<Response<Map<String, dynamic>>> _request({
    required String path,
    required String method,
    Object? data,
  }) async {
    await _sessionStore.initialize();
    var accessToken = _sessionStore.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      accessToken = await _refreshAccessToken();
    }

    try {
      return await _send(
        path: path,
        method: method,
        data: data,
        accessToken: accessToken,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) {
        throw mapDioException(error);
      }

      try {
        accessToken = await _refreshAccessToken();
        return await _send(
          path: path,
          method: method,
          data: data,
          accessToken: accessToken,
        );
      } on DioException catch (retryError) {
        final mapped = mapDioException(retryError);
        if (retryError.response?.statusCode == 401) {
          await _sessionStore.clear();
          throw SessionExpiredException(message: mapped.message);
        }
        throw mapped;
      }
    }
  }

  Future<Response<Map<String, dynamic>>> _send({
    required String path,
    required String method,
    required String accessToken,
    Object? data,
  }) {
    return _dio.request<Map<String, dynamic>>(
      path,
      data: data,
      options: Options(
        method: method,
        headers: <String, Object>{'Authorization': 'Bearer $accessToken'},
      ),
    );
  }

  Future<String> _refreshAccessToken() {
    final inProgress = _refreshingAccessToken;
    if (inProgress != null) return inProgress;

    final refresh = _performRefresh();
    _refreshingAccessToken = refresh;
    return refresh.whenComplete(() => _refreshingAccessToken = null);
  }

  Future<String> _performRefresh() async {
    final refreshToken = _sessionStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const SessionExpiredException();
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
      final body = response.data;
      final data = body?['data'];
      final accessToken = data is Map<String, dynamic>
          ? data['accessToken']
          : null;
      final nextRefreshToken = data is Map<String, dynamic>
          ? data['refreshToken']
          : null;
      if (body?['success'] != true ||
          accessToken is! String ||
          accessToken.isEmpty ||
          nextRefreshToken is! String ||
          nextRefreshToken.isEmpty) {
        throw const InvalidResponseException();
      }

      await _sessionStore.saveTokens(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
      );
      return accessToken;
    } on DioException catch (error) {
      final mapped = mapDioException(error);
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        await _sessionStore.clear();
        throw SessionExpiredException(message: mapped.message);
      }
      throw mapped;
    }
  }
}

AppException mapDioException(DioException error) {
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const NetworkException();
  }

  final responseData = error.response?.data;
  final message =
      responseData is Map<String, dynamic> && responseData['message'] is String
      ? responseData['message']! as String
      : 'Yêu cầu không thể hoàn tất. Vui lòng thử lại.';
  return ApiException(message, statusCode: error.response?.statusCode);
}
