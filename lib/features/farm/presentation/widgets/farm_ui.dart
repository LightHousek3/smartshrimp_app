import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';

const farmCardShadow = <BoxShadow>[
  BoxShadow(color: Color(0x160F1C2E), blurRadius: 22, offset: Offset(0, 8)),
];

String formatCompactNumber(double? value, {int fractionDigits = 2}) {
  if (value == null) return '—';
  final fixed = value.toStringAsFixed(fractionDigits);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

String farmStatusLabel(FarmStatus status) => switch (status) {
  FarmStatus.active => 'Đang hoạt động',
  FarmStatus.inactive => 'Ngừng hoạt động',
  FarmStatus.unknown => 'Không xác định',
};

class FarmStatusBadge extends StatelessWidget {
  const FarmStatusBadge({required this.status, super.key});

  final FarmStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      FarmStatus.active => (const Color(0xFFE2F6F3), const Color(0xFF0F9B8E)),
      FarmStatus.inactive ||
      FarmStatus.unknown => (const Color(0xFFEEF1F6), const Color(0xFF64748B)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
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
          Text(
            farmStatusLabel(status),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
