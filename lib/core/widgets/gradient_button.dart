import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: enabled
              ? const <Color>[
                  AppColors.oceanLight,
                  AppColors.tealLight,
                  AppColors.oceanLight,
                ]
              : const <Color>[Color(0xFFBAC6D1), Color(0xFFBAC6D1)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x3377A1D3),
                  blurRadius: 14,
                  offset: Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 58,
            child: Center(
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.check, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
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
