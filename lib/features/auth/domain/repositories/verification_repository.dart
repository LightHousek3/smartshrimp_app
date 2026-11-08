import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';

abstract interface class VerificationRepository {
  Future<void> requestOtp(String email, VerificationPurpose purpose);
  Future<String> verifyOtp(
    String email,
    String code,
    VerificationPurpose purpose,
  );
  Future<void> activate({
    required String actionToken,
    required String fullName,
    String? phone,
    required String password,
  });
  Future<void> resetPassword({
    required String actionToken,
    required String password,
  });
}
