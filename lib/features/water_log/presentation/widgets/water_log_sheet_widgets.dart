import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class WaterLogSheetHeader extends StatelessWidget {
  const WaterLogSheetHeader({
    required this.title,
    required this.onClose,
    required this.closeKey,
    super.key,
  });

  final String title;
  final VoidCallback? onClose;
  final Key closeKey;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style:
                AppTypography.display(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ).copyWith(
                  fontFamilyFallback: <String>[
                    GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                    ).fontFamily!,
                  ],
                ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox.square(
          dimension: 32,
          child: IconButton(
            key: closeKey,
            tooltip: 'Đóng',
            onPressed: onClose,
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEEF1F6),
              foregroundColor: AppColors.inkMuted,
            ),
            icon: const Text('×', style: TextStyle(fontSize: 18, height: 1)),
          ),
        ),
      ],
    ),
  );
}

InputDecoration waterLogInputDecoration({
  required String hintText,
  String? errorText,
}) => InputDecoration(
  hintText: hintText,
  errorText: errorText,
  isDense: true,
  filled: true,
  fillColor: Colors.white,
  hintStyle: const TextStyle(
    color: AppColors.inkMuted,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line, width: 1.2),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line, width: 1.2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.error, width: 1.2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.error, width: 1.2),
  ),
);
