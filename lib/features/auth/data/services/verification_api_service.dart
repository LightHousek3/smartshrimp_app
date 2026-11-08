import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';

abstract interface class VerificationRemoteDataSource {
  Future<void> requestOtp(String email, VerificationPurpose purpose);
  Future<String> verifyOtp(
    String email,
    String code,
    VerificationPurpose purpose,
  );
  Future<void> activate(Map<String, dynamic> payload);
  Future<void> resetPassword(Map<String, dynamic> payload);
}

final class VerificationApiService implements VerificationRemoteDataSource {
  VerificationApiService(this._client);
  final ApiClient _client;

  @override
  Future<void> requestOtp(String email, VerificationPurpose purpose) async {
    await _client.post(
      '/auth/${purpose.apiPath}/request-otp',
      authenticated: false,
      data: {'email': email},
    );
  }

  @override
  Future<String> verifyOtp(
    String email,
    String code,
    VerificationPurpose purpose,
  ) async {
    final response = await _client.post(
      '/auth/${purpose.apiPath}/verify-otp',
      authenticated: false,
      data: {'email': email, 'code': code},
    );
    final token = response.requireMapData()['actionToken'];
    if (token is! String ||
        !RegExp(r'^[A-Za-z0-9_-]{32,128}$').hasMatch(token)) {
      throw const InvalidResponseException();
    }
    return token;
  }

  @override
  Future<void> activate(Map<String, dynamic> payload) async {
    await _client.post(
      '/auth/activation/complete',
      authenticated: false,
      data: payload,
    );
  }

  @override
  Future<void> resetPassword(Map<String, dynamic> payload) async {
    await _client.post(
      '/auth/forgot-password/reset',
      authenticated: false,
      data: payload,
    );
  }
}
