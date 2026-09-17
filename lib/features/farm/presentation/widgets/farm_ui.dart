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
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: filled ? const Color(0xFF1D7AD6) : Colors.white,
          shape: const CircleBorder(),
          elevation: filled ? 3 : 0,
          shadowColor: const Color(0x330F62B4),
          child: InkWell(
            customBorder: const CircleBorder(),
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
    this.restore = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool restore;

  @override
  Widget build(BuildContext context) {
    final foreground = restore
        ? const Color(0xFF079455)
        : enabled
        ? AppColors.inkSoft
        : AppColors.inkMuted;
    final background = restore
        ? const Color(0xFFE7F8EF)
        : enabled
        ? Colors.white
        : const Color(0xFFE7E9EE);
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
            color: restore ? const Color(0xFFA7E5C4) : AppColors.line,
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
