import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// 'HH:mm' theo giờ địa phương.
String formatWaterTime(DateTime value) {
  final local = value.toLocal();
  return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
}

/// 'dd-MM' theo giờ địa phương.
String formatWaterDay(DateTime value) {
  final local = value.toLocal();
  return '${_twoDigits(local.day)}-${_twoDigits(local.month)}';
}

/// Badge trạng thái trên card theo Figma.
class WaterLogStatusBadge extends StatelessWidget {
  const WaterLogStatusBadge({required this.log, super.key});

  final WaterLog log;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color background;
    final Color foreground;
    if (log.isVoided) {
      label = 'Đã hủy hiệu lực';
      background = const Color(0xFFEEF1F6);
      foreground = AppColors.inkMuted;
    } else if (log.exceededParameters.isEmpty) {
      label = 'Trong ngưỡng';
      background = const Color(0xFFE2F6F3);
      foreground = const Color(0xFF0F9B8E);
    } else {
      label =
          '${log.exceededParameters.map(waterLogParamLabel).join(' · ')} cao';
      background = const Color(0xFFFBE6EA);
      foreground = AppColors.error;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card nhật ký đo nước theo Figma (trang danh sách).
class WaterLogCard extends StatelessWidget {
  const WaterLogCard({required this.log, this.onTap, super.key});

  final WaterLog log;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0A0F1C2E),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: Color(0x590F1C2E),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line, width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/water_log_drop.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          formatWaterTime(log.recordedAt),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          formatWaterDay(log.recordedAt),
                          style: AppTypography.mono(
                            color: AppColors.inkMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ).copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(child: WaterLogStatusBadge(log: log)),
                ],
              ),
              const SizedBox(height: 12),
              WaterParamTiles(
                log: log,
                boxed: true,
                includeH2s: true,
                roomy: true,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
