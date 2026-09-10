import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_logo.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final errorMessage = authState.hasError
        ? _messageFor(authState.error!)
        : null;

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 44,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: AutofillGroup(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Center(child: AppLogo(width: 250)),
                              const SizedBox(height: 12),
                              const Text(
                                'Nền tảng vận hành & tư vấn kỹ thuật\nnuôi tôm thông minh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.inkSoft,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 28),
                              _LoginCard(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                passwordFocusNode: _passwordFocusNode,
                                obscurePassword: _obscurePassword,
                                isLoading: isLoading,
                                errorMessage: errorMessage,
                                onTogglePassword: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                onSubmit: _submit,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Dành cho Kỹ thuật viên & Chủ trang trại.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.inkMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (success) TextInput.finishAutofillContext();
  }

  String _messageFor(Object error) {
    if (error case AppException(:final message)) return message;
    return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorMessage,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line, width: 1.3),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x290F1C2E),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Đăng nhập', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          const _FieldLabel('Email'),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('login_email_field'),
            controller: emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.username],
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'ban@trangtrai.vn'),
            validator: _validateEmail,
            onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('Mật khẩu'),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('login_password_field'),
            controller: passwordController,
            focusNode: passwordFocusNode,
            enabled: !isLoading,
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.password],
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              hintText: '••••••••',
              suffixIcon: IconButton(
                key: const Key('toggle_password_visibility'),
                tooltip: obscurePassword ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                onPressed: isLoading ? null : onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) {
              if (!isLoading) onSubmit();
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: errorMessage == null
                ? const SizedBox(height: 24)
                : Padding(
                    key: ValueKey<String>(errorMessage!),
                    padding: const EdgeInsets.only(top: 14, bottom: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE6EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.error,
                              size: 19,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          GradientButton(
            label: 'Đăng nhập',
            onPressed: isLoading ? null : onSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.push(AppRoutes.activateAccount),
                  child: const Text('Kích hoạt tài khoản'),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.push(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.inkSoft,
                  ),
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (email.length > 320 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  static String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu.';
    if (utf8.encode(password).length > 72) {
      return 'Mật khẩu không được vượt quá 72 byte.';
    }
    return null;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.inkSoft,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
