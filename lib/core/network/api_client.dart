import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/network/api_response.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';

/// Single gateway from the app to the SmartShrimp backend.
///
/// It owns the API envelope, authentication header, single-flight refresh,
/// one-time retry and Dio error mapping. Feature data sources only parse data
/// into domain entities.
final class ApiClient {
  ApiClient(this._dio, this._sessionStore);

  final Dio _dio;
  final SessionStore _sessionStore;
  Future<String>? _refreshingAccessToken;

  /// Socket.IO requests fresh credentials for each connection and reconnect.
  Future<String> accessTokenForRealtime() async {
    await _sessionStore.initialize();
    return _refreshAccessToken();
  }

  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    required bool authenticated,
  }) {
    return _request(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
      authenticated: authenticated,
    );
  }

  Future<ApiResponse> post(
    String path, {
    Object? data,
    required bool authenticated,
  }) {
    return _request(
      path: path,
      method: 'POST',
      data: data,
      authenticated: authenticated,
    );
  }

  Future<ApiResponse> patch(
    String path, {
    Object? data,
    required bool authenticated,
  }) {
    return _request(
      path: path,
      method: 'PATCH',
      data: data,
      authenticated: authenticated,
    );
  }

  Future<ApiResponse> delete(
    String path, {
    Object? data,
    required bool authenticated,
  }) {
    return _request(
      path: path,
      method: 'DELETE',
      data: data,
      authenticated: authenticated,
    );
  }

  Future<ApiResponse> _request({
    required String path,
    required String method,
    required bool authenticated,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    String? accessToken;
    if (authenticated) {
      await _sessionStore.initialize();
      accessToken = _sessionStore.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        accessToken = await _refreshAccessToken();
      }
    }

    try {
      return await _sendAndParse(
        path: path,
        method: method,
        queryParameters: queryParameters,
        data: data,
        accessToken: accessToken,
      );
    } on DioException catch (error) {
      if (!authenticated || error.response?.statusCode != 401) {
        throw ErrorMapper.fromDio(error);
      }
    }

    final currentAccessToken = _sessionStore.accessToken;
    final refreshedAccessToken =
        currentAccessToken != null &&
            currentAccessToken.isNotEmpty &&
            currentAccessToken != accessToken
        ? currentAccessToken
        : await _refreshAccessToken();
    try {
      return await _sendAndParse(
        path: path,
        method: method,
        queryParameters: queryParameters,
        data: data,
        accessToken: refreshedAccessToken,
      );
    } on DioException catch (error) {
      final mappedError = ErrorMapper.fromDio(error);
      if (error.response?.statusCode == 401) {
        await _sessionStore.clear();
        throw SessionExpiredException(message: mappedError.message);
      }
      throw mappedError;
    }
  }

  Future<ApiResponse> _sendAndParse({
    required String path,
    required String method,
    required String? accessToken,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    final response = await _dio.request<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(
        method: method,
        headers: accessToken == null
            ? null
            : <String, Object>{'Authorization': 'Bearer $accessToken'},
      ),
    );
    if (response.statusCode == 204) {
      return const ApiResponse(message: 'No content');
    }
    return ApiResponse.parse(response.data);
  }

  Future<String> _refreshAccessToken() {
    final inProgress = _refreshingAccessToken;
    if (inProgress != null) return inProgress;

    final refresh = _performRefresh();
    _refreshingAccessToken = refresh;
    return refresh.whenComplete(() {
      if (identical(_refreshingAccessToken, refresh)) {
        _refreshingAccessToken = null;
      }
    });
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
      final data = ApiResponse.parse(response.data).requireMapData();
      final accessToken = data['accessToken'];
      final nextRefreshToken = data['refreshToken'];
      if (accessToken is! String ||
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
      final mappedError = ErrorMapper.fromDio(error);
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        await _sessionStore.clear();
        throw SessionExpiredException(message: mappedError.message);
      }
      throw mappedError;
    } on InvalidResponseException catch (error) {
      await _sessionStore.clear();
      throw SessionExpiredException(message: error.message);
    }
  }
}
