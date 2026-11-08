import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/data/repositories/verification_repository_impl.dart';
import 'package:smartshrimp_app/features/auth/data/services/verification_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/verification_state.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/verification_repository.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

final verificationRemoteDataSourceProvider =
    Provider<VerificationRemoteDataSource>(
      (ref) => VerificationApiService(ref.watch(apiClientProvider)),
    );
final verificationRepositoryProvider = Provider<VerificationRepository>(
  (ref) => VerificationRepositoryImpl(
    ref.watch(verificationRemoteDataSourceProvider),
  ),
);
typedef VerificationContext = ({
  VerificationPurpose purpose,
  String initialEmail,
});

final verificationControllerProvider = NotifierProvider.autoDispose
    .family<VerificationController, VerificationState, VerificationContext>(
      VerificationController.new,
    );

final class VerificationController extends Notifier<VerificationState> {
  VerificationController(this.context);
  final VerificationContext context;
  VerificationPurpose get purpose => context.purpose;
  final Map<String, DateTime> _cooldowns = {};

  @override
  VerificationState build() => const VerificationState();

  Future<void> requestOtp(String email) async {
    if (state.isLoading) return;
    final normalized = email.trim().toLowerCase();
    final existing = _cooldowns[normalized];
    state = state.copyWith(
      isLoading: true,
      error: null,
      errorCode: null,
      actionToken: null,
    );
    try {
      if (existing == null || !existing.isAfter(DateTime.now())) {
        await ref
            .read(verificationRepositoryProvider)
            .requestOtp(normalized, purpose);
        _cooldowns[normalized] = DateTime.now().add(
          const Duration(seconds: 60),
        );
      }
      if (!ref.mounted) return;
      state = VerificationState(
        step: VerificationStep.otp,
        email: normalized,
        resendAvailableAt: _cooldowns[normalized],
      );
    } catch (error) {
      _fail(error);
    }
  }

  Future<void> verifyOtp(String code) async {
    if (state.isLoading || state.step != VerificationStep.otp) return;
    state = state.copyWith(isLoading: true, error: null, errorCode: null);
    try {
      final token = await ref
          .read(verificationRepositoryProvider)
          .verifyOtp(state.email, code, purpose);
      if (!ref.mounted) return;
      state = state.copyWith(
        step: VerificationStep.details,
        actionToken: token,
        isLoading: false,
      );
    } catch (error) {
      _fail(error);
    }
  }

  Future<void> complete({
    required String password,
    String? fullName,
    String? phone,
  }) async {
    if (state.isLoading ||
        state.step != VerificationStep.details ||
        state.actionToken == null) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null, errorCode: null);
    try {
      final repository = ref.read(verificationRepositoryProvider);
      if (purpose == VerificationPurpose.activation) {
        await repository.activate(
          actionToken: state.actionToken!,
          fullName: fullName!,
          phone: phone,
          password: password,
        );
      } else {
        await repository.resetPassword(
          actionToken: state.actionToken!,
          password: password,
        );
        if (!ref.mounted) return;
        final current = ref.read(authControllerProvider).value;
        if (current?.email.toLowerCase() == state.email) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
      }
      if (!ref.mounted) return;
      state = state.copyWith(
        step: VerificationStep.success,
        isLoading: false,
        actionToken: null,
      );
    } catch (error) {
      _fail(error);
    }
  }

  void backToEmail() {
    if (state.isLoading) return;
    state = VerificationState(
      email: state.email,
      resendAvailableAt: state.resendAvailableAt,
    );
  }

  void clearError() {
    if (state.isLoading || state.error == null) return;
    state = state.copyWith(error: null, errorCode: null);
  }

  void _fail(Object error) {
    if (!ref.mounted) return;
    final exception = error is AppException
        ? error
        : const ApiException('Đã xảy ra lỗi. Vui lòng thử lại.');
    final details = exception.details;
    final code = details is Map ? details['code'] as String? : null;
    final expired =
        code == 'AUTH_INVALID_ACTION_TOKEN' || exception.statusCode == 403;
    state = state.copyWith(
      isLoading: false,
      error: exception.message,
      errorCode: code,
      step: expired ? VerificationStep.otp : state.step,
      actionToken: expired ? null : state.actionToken,
    );
  }
}
