import 'package:smartshrimp_app/features/auth/data/services/verification_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/verification_repository.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

final class VerificationRepositoryImpl implements VerificationRepository {
  VerificationRepositoryImpl(this._remote);
  final VerificationRemoteDataSource _remote;

  String _email(String email) => email.trim().toLowerCase();

  @override
  Future<void> requestOtp(String email, VerificationPurpose purpose) =>
      _remote.requestOtp(_email(email), purpose);

  @override
  Future<String> verifyOtp(
    String email,
    String code,
    VerificationPurpose purpose,
  ) => _remote.verifyOtp(_email(email), code, purpose);

  @override
  Future<void> activate({
    required String actionToken,
    required String fullName,
    String? phone,
    required String password,
  }) {
    final normalizedPhone = ProfileRules.normalizePhone(phone ?? '');
    return _remote.activate({
      'actionToken': actionToken,
      'fullName': ProfileRules.normalizeFullName(fullName),
      'phone': normalizedPhone.isEmpty ? null : normalizedPhone,
      'password': password,
    });
  }

  @override
  Future<void> resetPassword({
    required String actionToken,
    required String password,
  }) =>
      _remote.resetPassword({'actionToken': actionToken, 'password': password});
}
