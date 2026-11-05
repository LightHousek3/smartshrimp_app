import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({required this.child, this.centered = false, super.key});
  final Widget child;
  final bool centered;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppGradientBackground(
      colors: const [AppColors.backgroundTop, AppColors.backgroundBottom],
      stops: const [0, 1],
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = centered && constraints.maxHeight < 700
                ? (constraints.maxHeight < 600 ? 12.0 : 16.0)
                : 32.0;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - padding * 2).clamp(
                    0,
                    double.infinity,
                  ),
                ),
                child: Align(
                  alignment: centered ? Alignment.center : Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: child,
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

class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.line, width: .8),
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Color(0x590F1C2E),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: child,
  );
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.title,
    required this.description,
    this.onBack,
    this.completed = false,
    super.key,
  });
  final String title;
  final Widget description;
  final VoidCallback? onBack;
  final bool completed;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (completed) ...[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE2F6F3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: AuthIcon('success', size: 22)),
        ),
        const SizedBox(height: 12),
      ] else ...[
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: .7),
              padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.inkSoft,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthIcon('back', size: 16),
                SizedBox(width: 6),
                Text(
                  'Quay lại',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
      Text(
        title,
        style: AppTypography.display(
          fontSize: 22,
          height: 1.5,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -.55,
        ),
      ),
      const SizedBox(height: 4),
      DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 13,
          height: 1.625,
          color: AppColors.inkSoft,
        ),
        child: description,
      ),
      const SizedBox(height: 20),
    ],
  );
}

class AuthField extends StatelessWidget {
  const AuthField({
    required this.label,
    required this.child,
    this.requiredField = false,
    super.key,
  });
  final String label;
  final Widget child;
  final bool requiredField;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        label: requiredField ? '$label, bắt buộc' : label,
        excludeSemantics: true,
        child: Text.rich(
          TextSpan(
            text: label,
            children: [
              if (requiredField)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
          style: AppFormMetrics.labelStyle,
        ),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    required this.label,
    required this.controller,
    required this.validator,
    this.enabled = true,
    this.helper = false,
    this.fieldKey,
    this.onSubmitted,
    super.key,
  });
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final bool helper;
  final Key? fieldKey;
  final VoidCallback? onSubmitted;
  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) => AuthField(
    label: widget.label,
    requiredField: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          key: widget.fieldKey,
          controller: widget.controller,
          enabled: widget.enabled,
          validator: widget.validator,
          obscureText: _obscure,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.newPassword],
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.onSubmitted == null
              ? TextInputAction.next
              : TextInputAction.done,
          onSubmitted: (_) => widget.onSubmitted?.call(),
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              onPressed: widget.enabled
                  ? () => setState(() => _obscure = !_obscure)
                  : null,
              icon: _obscure
                  ? const AuthIcon('eye', size: 17)
                  : const Icon(Icons.visibility_off_outlined, size: 17),
            ),
          ),
        ),
        if (widget.helper)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Tối thiểu 6 ký tự.',
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: AppColors.inkMuted,
              ),
            ),
          ),
      ],
    ),
  );
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.send = false,
    this.shield = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool send;
  final bool shield;
  @override
  Widget build(BuildContext context) => GradientButton(
    label: label,
    onPressed: onPressed,
    isLoading: loading,
    compact: true,
    height: 45,
    borderRadius: 12,
    leading: send
        ? SvgPicture.asset('assets/icons/auth/send.svg', width: 18, height: 18)
        : AuthIcon(shield ? 'shield' : 'check', size: 18),
    boxShadow: const [
      BoxShadow(color: Color(0x1A000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
  );
}

class AuthPasswordStrength extends StatelessWidget {
  const AuthPasswordStrength({required this.controller, super.key});
  final TextEditingController controller;
  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: controller,
    builder: (context, value, _) {
      if (value.text.isEmpty) return const SizedBox(height: 16);
      final strength = ProfileRules.passwordStrength(value.text);
      final (level, label, color) = switch (strength) {
        PasswordStrength.tooShort => (1, 'Quá ngắn', AppColors.error),
        PasswordStrength.medium => (2, 'Trung bình', const Color(0xFFFFB900)),
        PasswordStrength.fairlyStrong => (3, 'Khá mạnh', AppColors.ocean),
        PasswordStrength.strong => (4, 'Mạnh', const Color(0xFF009F91)),
      };
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: index < level ? color : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: strength == PasswordStrength.medium
                    ? const Color(0xFFD98314)
                    : color,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void authBackToLogin(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/login');
  }
}

class AuthIcon extends StatelessWidget {
  const AuthIcon(this.name, {this.size = 18, super.key});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/auth/$name.svg',
    width: size,
    height: size,
    excludeFromSemantics: true,
  );
}
