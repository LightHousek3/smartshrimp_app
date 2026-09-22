import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

const farmCardShadow = <BoxShadow>[
  BoxShadow(color: Color(0x160F1C2E), blurRadius: 22, offset: Offset(0, 8)),
];

class FarmCircleButton extends StatelessWidget {
  const FarmCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.filled = false,
    this.size = 42,
    this.iconSize = 21,
    this.borderRadius,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;
  final double size;
  final double iconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final borderShape = borderRadius != null
        ? RoundedRectangleBorder(borderRadius: borderRadius!)
        : const CircleBorder() as ShapeBorder;
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: filled ? const Color(0xFF1D7AD6) : Colors.white,
          shape: borderShape,
          elevation: filled ? 3 : 0,
          shadowColor: const Color(0x330F62B4),
          child: InkWell(
            customBorder: borderShape,
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
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

class FarmActionButton extends StatelessWidget {
  const FarmActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
    this.destructive = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final foreground = !enabled
        ? AppColors.inkMuted
        : destructive
        ? const Color(0xFFB42318)
        : AppColors.inkSoft;
    final background = !enabled
        ? const Color(0xFFE7E9EE)
        : destructive
        ? const Color(0xFFFFF1F0)
        : Colors.white;
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: background,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: enabled && destructive
                ? const Color(0xFFF7B4AD)
                : AppColors.line,
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

String formatCompactNumber(double? value, {int fractionDigits = 2}) {
  if (value == null) return '—';
  final fixed = value.toStringAsFixed(fractionDigits);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
