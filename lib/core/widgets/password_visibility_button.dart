import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

/// Show the action available to the user, rather than the current password state.
class PasswordVisibilityButton extends StatelessWidget {
  const PasswordVisibilityButton({
    required this.obscureText,
    required this.onPressed,
    super.key,
  });

  final bool obscureText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: obscureText ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
    onPressed: onPressed,
    padding: EdgeInsets.zero,
    style: IconButton.styleFrom(
      minimumSize: const Size(44, 44),
      fixedSize: const Size(44, 44),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    icon: obscureText
        ? SvgPicture.asset(
            'assets/icons/auth/eye.svg',
            width: 17,
            height: 17,
            excludeFromSemantics: true,
          )
        : const Icon(
            Icons.visibility_off_outlined,
            size: 17,
            color: AppColors.inkMuted,
          ),
  );
}
