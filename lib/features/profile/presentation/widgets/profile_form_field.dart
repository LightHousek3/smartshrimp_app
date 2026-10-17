import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

/// Shared field geometry for the two identity forms in the Figma design.
class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    required this.label,
    required this.child,
    this.helpText,
    super.key,
  });
  final String label;
  final Widget child;
  final String? helpText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: AppColors.inkSoft,
        ),
      ),
      const SizedBox(height: 6),
      child,
      if (helpText != null) ...[
        const SizedBox(height: 4),
        Text(
          helpText!,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            height: 1.5,
          ),
        ),
      ],
    ],
  );
}

const profileInputStyle = TextStyle(
  fontSize: 14,
  height: 1.5,
  color: AppColors.ink,
);
const profileIdentityInputStyle = TextStyle(
  fontFamily: 'JetBrainsMono',
  fontSize: 14,
  height: 1.5,
  color: AppColors.ink,
  fontFamilyFallback: ['PlusJakartaSans'],
);

InputDecoration profileInputDecoration({String? hintText, Widget? suffixIcon}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line, width: 1.25),
  );
  return InputDecoration(
    hintText: hintText,
    hintStyle: profileInputStyle.copyWith(color: AppColors.inkMuted),
    isDense: true,
    constraints: const BoxConstraints(minHeight: 44),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    counterText: '',
    border: border,
    enabledBorder: border,
    disabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.25),
    ),
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.error, width: 1.25),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.error, width: 1.25),
    ),
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
  );
}
