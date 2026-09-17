import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/features/profile/presentation/widgets/profile_screen_header.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  String? _currentServerError;
  String? _newServerError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const ProfileScreenHeader(title: 'Đổi mật khẩu'),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _PasswordField(
                        fieldKey: const Key('current_password_field'),
                        label: 'Mật khẩu hiện tại',
                        controller: _currentController,
                        obscureText: _obscureCurrent,
                        enabled: !_isSaving,
                        autoFocus: true,
                        validator: (value) =>
                            _currentServerError ??
                            ProfileFormUtils.validateCurrentPassword(value),
                        onChanged: (_) =>
                            setState(() => _currentServerError = null),
                        onToggle: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      const SizedBox(height: 15),
                      _PasswordField(
                        fieldKey: const Key('new_password_field'),
                        label: 'Mật khẩu mới',
                        hint: 'Tối thiểu 6 ký tự.',
                        controller: _newController,
                        obscureText: _obscureNew,
                        enabled: !_isSaving,
                        validator: (value) =>
                            _newServerError ??
                            ProfileFormUtils.validateNewPassword(
                              value,
                              _currentController.text,
                            ),
                        onChanged: (_) =>
                            setState(() => _newServerError = null),
                        onToggle: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      AnimatedBuilder(
                        animation: _newController,
                        builder: (_, _) =>
                            _PasswordStrength(password: _newController.text),
                      ),
                      const SizedBox(height: 15),
                      _PasswordField(
                        fieldKey: const Key('confirm_password_field'),
                        label: 'Xác nhận mật khẩu mới',
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        enabled: !_isSaving,
                        validator: (value) =>
                            ProfileFormUtils.validatePasswordConfirmation(
                              value,
                              _newController.text,
                            ),
                        onChanged: (_) {},
                        onToggle: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        label: 'Xác nhận đổi mật khẩu',
                        icon: Icons.shield_outlined,
                        isLoading: _isSaving,
                        onPressed: _isSaving ? null : _submit,
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

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(profileControllerProvider.notifier)
          .changePassword(
            currentPassword: _currentController.text,
            newPassword: _newController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu đã thay đổi thành công')),
      );
      context.go(AppRoutes.account);
    } on AppException catch (error) {
      if (!mounted) return;
      final message = error.message.toLowerCase();
      if (message.contains('hiện tại') && message.contains('không chính xác')) {
        setState(() => _currentServerError = error.message);
        _formKey.currentState?.validate();
      } else if (message.contains('không được trùng') ||
          message.contains('phải khác')) {
        setState(() => _newServerError = error.message);
        _formKey.currentState?.validate();
      } else {
        _showError(error.message);
      }
    } on Object {
      if (mounted) {
        _showError('Không thể đổi mật khẩu. Vui lòng thử lại.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.enabled,
    required this.validator,
    required this.onChanged,
    required this.onToggle,
    this.hint,
    this.autoFocus = false,
    this.onSubmitted,
  });

  final Key fieldKey;
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final bool autoFocus;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggle;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkSoft,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          key: fieldKey,
          controller: controller,
          enabled: enabled,
          autofocus: autoFocus,
          obscureText: obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: onSubmitted == null
              ? TextInputAction.next
              : TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: '••••••••',
            helperText: hint,
            suffixIcon: IconButton(
              tooltip: obscureText ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              onPressed: enabled ? onToggle : null,
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.inkMuted,
                size: 20,
              ),
            ),
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final strength = ProfileFormUtils.passwordStrength(password);
    final color = switch (strength) {
      PasswordStrength.tooShort => AppColors.error,
      PasswordStrength.medium => const Color(0xFFE0A000),
      PasswordStrength.fairlyStrong => const Color(0xFF0F9B8E),
      PasswordStrength.strong => const Color(0xFF15945D),
    };
    final label = switch (strength) {
      PasswordStrength.tooShort => 'Quá ngắn',
      PasswordStrength.medium => 'Trung bình',
      PasswordStrength.fairlyStrong => 'Khá mạnh',
      PasswordStrength.strong => 'Mạnh',
    };
    final strengthLevel = strength.index + 1;

    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: List<Widget>.generate(
              4,
              (index) => Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index < strengthLevel
                        ? color
                        : const Color(0xDDECF0F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
