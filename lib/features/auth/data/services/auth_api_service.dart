import 'package:smartshrimp_app/core/network/api_client.dart';
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
  AuthApiService(this._client);

  final ApiClient _client;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final response = await _client.post(
      '/auth/login',
      authenticated: false,
      data: <String, dynamic>{
        'email': email.trim().toLowerCase(),
        'password': password,
        'deviceId': deviceId,
      },
    );
    return AuthSession.fromLoginData(response.requireMapData());
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    final response = await _client.post(
      '/auth/refresh-token',
      authenticated: false,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
    return AuthSession.fromRefreshData(response.requireMapData());
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _client.post(
      '/auth/logout',
      authenticated: false,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
  }
}
