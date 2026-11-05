import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_logo.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/auth/domain/auth_form_rules.dart';
import 'package:smartshrimp_app/features/auth/domain/verification_purpose.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({this.initialEmail = '', this.completedPurpose, super.key});
  final String initialEmail;
  final VerificationPurpose? completedPurpose;
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _email;
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;
  late bool _showCompletion;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
    _showCompletion = widget.completedPurpose != null;
  }

  @override
  void didUpdateWidget(covariant LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEmail != widget.initialEmail ||
        oldWidget.completedPurpose != widget.completedPurpose) {
      _email.text = widget.initialEmail;
      _password.clear();
      _error = null;
      _showCompletion = widget.completedPurpose != null;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final loading = auth.isLoading || _submitting;
    final error =
        _error ??
        (!_showCompletion && auth.hasError ? _message(auth.error!) : null);
    final availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).vertical;
    final compact = availableHeight < 700;
    final logoSize = compact
        ? (availableHeight - 480).clamp(56.0, 140.0)
        : 192.0;
    return AuthShell(
      centered: true,
      child: AutofillGroup(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox.square(
                  dimension: logoSize,
                  child: AppLogo(width: logoSize),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: SizedBox(
                  width: 260,
                  child: Text(
                    'Nền tảng vận hành & tư vấn kỹ thuật nuôi tôm thông minh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppColors.inkSoft,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: compact ? 16 : 24),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Đăng nhập',
                      style: AppTypography.display(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Email',
                      child: AppTextField(
                        key: const Key('login_email_field'),
                        controller: _email,
                        enabled: !loading,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        autocorrect: false,
                        validator: AuthFormRules.email,
                        decoration: const InputDecoration(
                          hintText: 'ban@trangtrai.vn',
                        ),
                        onSubmitted: (_) => _passwordFocus.requestFocus(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      label: 'Mật khẩu',
                      child: AppTextField(
                        key: const Key('login_password_field'),
                        controller: _password,
                        focusNode: _passwordFocus,
                        enabled: !loading,
                        obscureText: _obscure,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            key: const Key('toggle_password_visibility'),
                            tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                            onPressed: loading
                                ? null
                                : () => setState(() => _obscure = !_obscure),
                            icon: _obscure
                                ? const AuthIcon('eye', size: 17)
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    size: 17,
                                  ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Vui lòng nhập mật khẩu.';
                          }
                          if (utf8.encode(value!).length > 72) {
                            return 'Mật khẩu quá dài. Vui lòng sử dụng mật khẩu ngắn hơn.';
                          }
                          return null;
                        },
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (error != null || _showCompletion)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: error != null
                            ? AppFormErrorBanner(
                                title: _error == null
                                    ? 'Không thể khôi phục phiên'
                                    : 'Không thể đăng nhập',
                                message: error,
                              )
                            : AppFormMessageBanner(
                                title:
                                    widget.completedPurpose ==
                                        VerificationPurpose.activation
                                    ? 'Kích hoạt tài khoản thành công'
                                    : 'Đặt lại mật khẩu thành công',
                                message:
                                    widget.completedPurpose ==
                                        VerificationPurpose.activation
                                    ? 'Vui lòng đăng nhập bằng email và mật khẩu bạn vừa thiết lập.'
                                    : 'Vui lòng đăng nhập bằng mật khẩu mới của bạn.',
                              ),
                      ),
                    AuthSubmitButton(
                      label: 'Đăng nhập',
                      loading: loading,
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _link(
                            'Kích hoạt tài khoản',
                            '/activate-account',
                            loading,
                            false,
                          ),
                        ),
                        Flexible(
                          child: _link(
                            'Quên mật khẩu?',
                            '/forgot-password',
                            loading,
                            true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: compact ? 16 : 24),
              const Text(
                'Dành cho Kỹ thuật viên & Chủ trang trại.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.625,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _link(String label, String path, bool loading, bool muted) =>
      TextButton(
        onPressed: loading
            ? null
            : () => context.push(
                Uri(
                  path: path,
                  queryParameters: _email.text.trim().isEmpty
                      ? null
                      : {'email': _email.text.trim()},
                ).toString(),
              ),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: muted ? AppColors.inkSoft : AppColors.ocean,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            height: 1.5,
            fontWeight: muted ? FontWeight.w600 : FontWeight.w700,
          ),
        ),
      );

  Future<void> _submit() async {
    if (_submitting || ref.read(authControllerProvider).isLoading) {
      return;
    }
    if (_showCompletion) setState(() => _showCompletion = false);
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.text, password: _password.text);
      TextInput.finishAutofillContext();
      if (mounted) context.go('/');
    } catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'Đã xảy ra lỗi. Vui lòng thử lại.';
}
