import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_state.freezed.dart';

enum VerificationStep { email, otp, details, success }

@freezed
abstract class VerificationState with _$VerificationState {
  const factory VerificationState({
    @Default(VerificationStep.email) VerificationStep step,
    @Default('') String email,
    @Default(false) bool isLoading,
    DateTime? resendAvailableAt,
    String? actionToken,
    String? error,
    String? errorCode,
  }) = _VerificationState;
}
