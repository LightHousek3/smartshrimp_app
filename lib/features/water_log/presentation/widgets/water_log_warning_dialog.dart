import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_threshold.dart';

Future<bool?> showWaterLogWarningDialog({
  required BuildContext context,
  required ShrimpType shrimpType,
  required List<WaterLogWarning> warnings,
}) => showGeneralDialog<bool>(
  context: context,
  useRootNavigator: true,
  barrierDismissible: true,
  barrierLabel: 'Đóng hộp thoại',
  barrierColor: const Color(0x590F1C2E),
  transitionDuration: const Duration(milliseconds: 180),
  pageBuilder: (context, _, _) => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: WaterLogWarningDialog(shrimpType: shrimpType, warnings: warnings),
  ),
);

class WaterLogWarningDialog extends StatelessWidget {
  const WaterLogWarningDialog({
    required this.shrimpType,
    required this.warnings,
    super.key,
  });

  final ShrimpType shrimpType;
  final List<WaterLogWarning> warnings;

  @override
  Widget build(BuildContext context) => Dialog(
    key: const Key('water_log_warning_dialog'),
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    constraints: const BoxConstraints(maxWidth: 380),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF0DC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/water-log/water_log_warning.svg',
                      width: 19.9898,
                      height: 19.9898,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Chỉ số nước ngoài ngưỡng',
                  style:
                      AppTypography.display(
                        color: AppColors.ink,
                        fontSize: 17,
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
                const SizedBox(height: 6),
                Text(
                  '${warnings.length} chỉ số không nằm trong ngưỡng khuyến nghị '
                  'cho ${shrimpTypeLabel(shrimpType)}. '
                  'Hãy kiểm tra lại kết quả đo trước khi lưu.',
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    height: 1.625,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 256),
                  child: SingleChildScrollView(
                    key: const Key('water_log_warnings_list'),
                    child: Column(
                      children: <Widget>[
                        for (var i = 0; i < warnings.length; i++) ...<Widget>[
                          if (i > 0) const SizedBox(height: 8),
                          _WarningTile(warning: warnings[i]),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Color(0xB3EEF1F6),
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  key: const Key('review_water_log'),
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.inkSoft,
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Kiểm tra lại'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: GradientButton(
                    key: const Key('confirm_water_log'),
                    label: 'Vẫn lưu',
                    compact: true,
                    borderRadius: 12,
                    leading: SvgPicture.asset(
                      'assets/icons/water-log/water_log_confirm.svg',
                      width: 17.9948,
                      height: 17.9948,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Preserve the entered precision so a small exceedance is visible.
String _number(double value) => value == value.truncateToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();

class _WarningTile extends StatelessWidget {
  const _WarningTile({required this.warning});

  final WaterLogWarning warning;

  @override
  Widget build(BuildContext context) {
    final threshold = warning.threshold;
    final param = threshold.param;
    final valueUnit = param.field == 'ph' ? '' : ' ${param.unit}';
    final range = threshold.min == null
        ? 'không quá ${_number(threshold.max!)}'
        : threshold.max == null
        ? 'từ ${_number(threshold.min!)}'
        : '${_number(threshold.min!)}–${_number(threshold.max!)}';
    return Container(
      key: ValueKey('water_warning_${param.field}'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF0DC),
        border: Border.all(color: const Color(0xFFFEE685), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  param.label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_number(warning.value)}$valueUnit',
                  textAlign: TextAlign.end,
                  style: AppTypography.mono(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ).copyWith(height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            warning.isBelowMinimum
                ? 'Thấp hơn mức tối thiểu'
                : 'Cao hơn mức tối đa',
            style: const TextStyle(
              color: Color(0xFFBB4D00),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Ngưỡng khuyến nghị: ${range.replaceAll('.', ',')} ${param.unit}',
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
