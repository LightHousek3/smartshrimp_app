import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class AppCircleButton extends StatelessWidget {
  const AppCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.filled = false,
    this.size = 42,
    this.iconSize = 21,
    this.borderRadius,
    this.iconWidget,
    this.backgroundColor,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;
  final double size;
  final double iconSize;
  final BorderRadius? borderRadius;
  final Widget? iconWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ShapeBorder shape = borderRadius == null
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: borderRadius!);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color:
              backgroundColor ??
              (filled ? const Color(0xFF1D7AD6) : Colors.white),
          shape: shape,
          elevation: filled ? 3 : 0,
          shadowColor: const Color(0x330F62B4),
          child: InkWell(
            customBorder: shape,
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child:
                  iconWidget ??
                  Icon(
                    icon,
                    size: iconSize,
                    color: filled ? Colors.white : AppColors.inkSoft,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
