import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

const _buttonRadius = 16.0;

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon = Icons.check_rounded,
    this.compact = false,
    this.leading,
    this.borderRadius,
    this.gradientColors,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData icon;
  final bool compact;
  final Widget? leading;
  final double? borderRadius;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final radius = borderRadius ?? (compact ? 11.0 : _buttonRadius);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: enabled
              ? gradientColors ??
                    const <Color>[
                      AppColors.oceanLight,
                      AppColors.tealLight,
                      AppColors.oceanLight,
                    ]
              : const <Color>[Color(0xFFBAC6D1), Color(0xFFBAC6D1)],
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: enabled
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0x3377A1D3),
                  blurRadius: compact ? 8 : 14,
                  offset: Offset(0, compact ? 4 : 7),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            width: double.infinity,
            height: compact ? 44 : 58,
            child: Center(
              child: isLoading
                  ? SizedBox.square(
                      dimension: compact ? 18 : 22,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        leading ??
                            Icon(
                              icon,
                              color: Colors.white,
                              size: compact ? 18 : 22,
                            ),
                        SizedBox(width: compact ? 8 : 10),
                        Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 14 : 17,
                            height: 1,
                            fontWeight: compact
                                ? FontWeight.w600
                                : FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
