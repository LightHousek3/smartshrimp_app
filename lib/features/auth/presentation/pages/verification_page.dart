import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/features/auth/domain/auth_form_rules.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/verification_state.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/verification_controller.dart';
import 'package:smartshrimp_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:smartshrimp_app/features/auth/presentation/widgets/otp_input.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

const _verificationGap = 16.0;
final _verificationLinkStyle = TextButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  minimumSize: const Size.fromHeight(32),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  foregroundColor: AppColors.ocean,
  disabledForegroundColor: AppColors.inkMuted,
  textStyle: const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12.5,
    height: 1.5,
    fontWeight: FontWeight.w600,
  ),
);

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({
    required this.purpose,
    this.initialEmail = '',
    super.key,
  });
  final VerificationPurpose purpose;
  final String initialEmail;
  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _email;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  Timer? _timer;
  String _code = '';
  int _otpVersion = 0;

  NotifierProvider<VerificationController, VerificationState> get _provider =>
      verificationControllerProvider((
        purpose: widget.purpose,
        initialEmail: widget.initialEmail.trim().toLowerCase(),
      ));

  bool get _activation => widget.purpose == VerificationPurpose.activation;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController(
      text: widget.initialEmail.trim().toLowerCase(),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in [
      _email,
      _name,
      _phone,
      _password,
      _confirmation,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = _provider;
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    ref.listen(provider, (previous, next) {
      if (previous?.step != VerificationStep.success &&
          next.step == VerificationStep.success) {
        context.go(
          Uri(
            path: '/login',
            queryParameters: {'email': next.email},
          ).toString(),
          extra: widget.purpose.name,
        );
        return;
      }
      if (previous?.step == VerificationStep.details &&
          next.step != VerificationStep.details) {
        _password.clear();
        _confirmation.clear();
      }
      if (previous?.step != next.step) _form.currentState?.reset();
    });
    if (state.step == VerificationStep.success) return const SizedBox.shrink();
    final seconds = state.resendAvailableAt == null
        ? 0
        : ((state.resendAvailableAt!.difference(DateTime.now()).inMilliseconds +
                      999) ~/
                  1000)
              .clamp(0, 60);
    final title = switch (state.step) {
      VerificationStep.email =>
        _activation ? 'Kích hoạt tài khoản' : 'Quên mật khẩu',
      VerificationStep.otp => 'Xác thực email',
      VerificationStep.details =>
        _activation ? 'Hoàn tất hồ sơ' : 'Đặt mật khẩu mới',
      VerificationStep.success =>
        _activation ? 'Kích hoạt thành công' : 'Đặt lại mật khẩu thành công',
    };
    final description = switch (state.step) {
      VerificationStep.email => Text(
        _activation
            ? 'Nhập email đã được quản trị viên cấp. Chúng tôi sẽ gửi mã xác thực gồm 6 chữ số tới hộp thư của bạn.'
            : 'Nhập địa chỉ email đã đăng ký. Hệ thống sẽ gửi mã xác thực 6 chữ số để bạn đặt lại mật khẩu.',
      ),
      VerificationStep.otp => Text(
        'Nhập mã 6 chữ số vừa được gửi tới ${state.email}.',
      ),
      VerificationStep.details when _activation => Text.rich(
        TextSpan(
          text: 'Email ',
          children: [
            TextSpan(
              text: state.email,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const TextSpan(
              text:
                  ' đã xác thực. Bổ sung thông tin và đặt mật khẩu để hoàn tất.',
            ),
          ],
        ),
      ),
      VerificationStep.details => const Text(
        'Tạo mật khẩu mới tối thiểu 6 ký tự cho tài khoản của bạn.',
      ),
      VerificationStep.success => const Text(
        'Bạn có thể đăng nhập bằng email và mật khẩu vừa thiết lập.',
      ),
    };
    return AuthShell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              title: title,
              description: description,
              completed:
                  state.step == VerificationStep.success ||
                  (_activation && state.step == VerificationStep.details),
              onBack: state.isLoading
                  ? null
                  : () {
                      if (state.step == VerificationStep.email ||
                          state.step == VerificationStep.success) {
                        authBackToLogin(context);
                      } else {
                        controller.backToEmail();
                      }
                    },
            ),
            AuthCard(
              child: AutofillGroup(
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.step == VerificationStep.email) ...[
                        AuthField(
                          label: _activation
                              ? 'Email tài khoản'
                              : 'Địa chỉ email',
                          child: AppTextField(
                            key: const Key('verification_email'),
                            controller: _email,
                            enabled: !state.isLoading,
                            style: const TextStyle(fontFamily: 'JetBrainsMono'),
                            decoration: const InputDecoration(
                              hintText: 'ban@trangtrai.vn',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.email],
                            validator: AuthFormRules.email,
                            onSubmitted: (_) => _request(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AuthSubmitButton(
                          label: _activation
                              ? 'Gửi mã kích hoạt'
                              : 'Gửi mã xác thực',
                          send: true,
                          loading: state.isLoading,
                          onPressed: state.isLoading ? null : _request,
                        ),
                      ],
                      if (state.step == VerificationStep.otp) ...[
                        FormField<String>(
                          key: ValueKey('otp_form_$_otpVersion'),
                          validator: (_) => RegExp(r'^\d{6}$').hasMatch(_code)
                              ? null
                              : 'Vui lòng nhập đủ 6 chữ số.',
                          builder: (field) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: _verificationGap,
                            children: [
                              OtpInput(
                                key: ValueKey(_otpVersion),
                                enabled: !state.isLoading,
                                onChanged: (value) {
                                  _code = value;
                                  field.didChange(value);
                                  if (field.hasError) field.validate();
                                  controller.clearError();
                                },
                              ),
                              if (field.errorText != null ||
                                  state.error != null)
                                _VerificationError(
                                  message: field.errorText ?? state.error!,
                                  errorCode: field.errorText == null
                                      ? state.errorCode
                                      : null,
                                  email: state.email,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _verificationGap),
                        AuthSubmitButton(
                          label: 'Xác nhận mã',
                          loading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_form.currentState?.validate() ?? false) {
                                    controller.verifyOtp(_code);
                                  }
                                },
                        ),
                        const SizedBox(height: _verificationGap),
                        TextButton(
                          key: const Key('verification_resend'),
                          style: _verificationLinkStyle,
                          onPressed: seconds > 0 || state.isLoading
                              ? null
                              : () async {
                                  await controller.requestOtp(state.email);
                                  if (mounted) {
                                    setState(() {
                                      _code = '';
                                      _otpVersion++;
                                    });
                                  }
                                },
                          child: Text(
                            seconds > 0
                                ? 'Gửi lại mã sau ${seconds}s'
                                : 'Không nhận được mã? Gửi lại',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      if (state.step == VerificationStep.details) ...[
                        if (_activation) ...[
                          AuthField(
                            label: 'Họ và tên',
                            requiredField: true,
                            child: AppTextField(
                              key: const Key('activation_name'),
                              controller: _name,
                              enabled: !state.isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                              ),
                              decoration: const InputDecoration(
                                hintText: 'VD: Trần Quốc Bảo',
                              ),
                              validator: AuthFormRules.fullName,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AuthField(
                            label: 'Số điện thoại',
                            child: AppTextField(
                              key: const Key('activation_phone'),
                              controller: _phone,
                              enabled: !state.isLoading,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              decoration: const InputDecoration(
                                hintText: '09xx xxx xxx',
                              ),
                              validator: ProfileRules.validatePhone,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        AuthPasswordField(
                          label: _activation ? 'Mật khẩu' : 'Mật khẩu mới',
                          controller: _password,
                          fieldKey: const Key('verification_password'),
                          enabled: !state.isLoading,
                          helper: true,
                          validator: AuthFormRules.password,
                        ),
                        const SizedBox(height: 16),
                        AuthPasswordField(
                          label: _activation
                              ? 'Xác nhận mật khẩu'
                              : 'Xác nhận mật khẩu mới',
                          controller: _confirmation,
                          fieldKey: const Key('verification_confirmation'),
                          enabled: !state.isLoading,
                          validator: (value) =>
                              AuthFormRules.confirmation(value, _password.text),
                          onSubmitted: _complete,
                        ),
                        AuthPasswordStrength(controller: _password),
                        AuthSubmitButton(
                          label: _activation
                              ? 'Hoàn tất & kích hoạt'
                              : 'Xác nhận mật khẩu mới',
                          shield: !_activation,
                          loading: state.isLoading,
                          onPressed: state.isLoading ? null : _complete,
                        ),
                      ],
                      if (state.step != VerificationStep.otp &&
                          state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: _verificationGap),
                          child: _VerificationError(
                            message: state.error!,
                            errorCode: state.errorCode,
                            email: state.email,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _request() async {
    final controller = ref.read(_provider.notifier);
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _code = '';
    _otpVersion++;
    await controller.requestOtp(_email.text);
  }

  void _complete() {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    ref
        .read(_provider.notifier)
        .complete(
          password: _password.text,
          fullName: _name.text,
          phone: _phone.text,
        );
  }
}

class _VerificationError extends StatelessWidget {
  const _VerificationError({
    required this.message,
    required this.email,
    this.errorCode,
  });
  final String message;
  final String email;
  final String? errorCode;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: _verificationGap,
    children: [
      Semantics(
        liveRegion: true,
        child: Text(
          message,
          key: const Key('verification_error'),
          style: AppFormMetrics.errorStyle,
        ),
      ),
      if (errorCode == 'AUTH_PENDING_ACTIVATION')
        TextButton(
          key: const Key('verification_guidance'),
          style: _verificationLinkStyle,
          onPressed: () => context.go(
            Uri(
              path: '/activate-account',
              queryParameters: {'email': email},
            ).toString(),
          ),
          child: const Text('Kích hoạt tài khoản', textAlign: TextAlign.center),
        ),
      if (errorCode == 'AUTH_ACCOUNT_ALREADY_ACTIVATED')
        TextButton(
          key: const Key('verification_guidance'),
          style: _verificationLinkStyle,
          onPressed: () => context.go(
            Uri(path: '/login', queryParameters: {'email': email}).toString(),
          ),
          child: const Text('Đăng nhập', textAlign: TextAlign.center),
        ),
    ],
  );
}
