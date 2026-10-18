import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/profile/presentation/widgets/profile_form_field.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';

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
            PageHeaderBar(
              title: 'Đổi mật khẩu',
              onBack: context.pop,
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              titleStyle: AppTypography.display(
                fontSize: 16,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
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
                        validator: (value) =>
                            _currentServerError ??
                            ProfileFormUtils.validateCurrentPassword(value),
                        onChanged: (_) =>
                            setState(() => _currentServerError = null),
                        onToggle: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 28),
                      GradientButton(
                        label: 'Xác nhận đổi mật khẩu',
                        compact: true,
                        height: 45,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: 12,
                        leading: const AppSvgIcon(
                          AppSvgIconName.shieldOutline,
                          size: 18,
                          color: Colors.white,
                        ),
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
      AppNoticeService.success(context, 'Mật khẩu đã thay đổi thành công');
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
    AppNoticeService.danger(context, message);
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
    this.onSubmitted,
  });

  final Key fieldKey;
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggle;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ProfileFormField(
      label: label,
      helpText: hint,
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: onSubmitted == null
            ? TextInputAction.next
            : TextInputAction.done,
        autocorrect: false,
        enableSuggestions: false,
        style: profileInputStyle,
        decoration: profileInputDecoration(
          hintText: '••••••••',
          suffixIcon: IconButton(
            style: IconButton.styleFrom(
              minimumSize: const Size(40, 40),
              fixedSize: const Size(40, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            tooltip: obscureText ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
            onPressed: enabled ? onToggle : null,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: const EdgeInsets.all(10),
            icon: const AppSvgIcon(AppSvgIconName.eye, size: 17),
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
