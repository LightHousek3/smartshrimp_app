import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

/// Bộ màu pastel dịu + chấm tròn & chữ đồng bộ phong cách pill "● Đã lên lịch"
/// cho từng loại hoạt động vận hành.
class OperationTypeVisuals {
  const OperationTypeVisuals({
    required this.bg,
    required this.fg,
    required this.icon,
  });

  final Color bg;
  final Color fg;
  final IconData icon;

  static OperationTypeVisuals of(OperationType type) => switch (type) {
    OperationType.feeding => const OperationTypeVisuals(
      bg: Color(0xFFDCF5F0),
      fg: Color(0xFF0C857A),
      icon: Icons.restaurant_rounded,
    ),
    OperationType.medicine => const OperationTypeVisuals(
      bg: Color(0xFFEFE9FE),
      fg: Color(0xFF6D3AD6),
      icon: Icons.medical_services_rounded,
    ),
    OperationType.mineral => const OperationTypeVisuals(
      bg: Color(0xFFE0F4FE),
      fg: Color(0xFF0377B5),
      icon: Icons.grain_rounded,
    ),
    OperationType.chemical => const OperationTypeVisuals(
      bg: Color(0xFFFEF0D6),
      fg: Color(0xFFC86A08),
      icon: Icons.science_rounded,
    ),
    OperationType.other => const OperationTypeVisuals(
      bg: Color(0xFFEDF1F7),
      fg: Color(0xFF4F5E73),
      icon: Icons.tune_rounded,
    ),
  };
}

/// Pill badge dạng `● Cho ăn`, `● Thuốc điều trị`, `● Bổ sung khoáng`, `● Hóa chất`
/// đồng bộ thiết kế với badge trạng thái `● Đã lên lịch`.
class OperationTypeBadge extends StatelessWidget {
  const OperationTypeBadge({
    required this.type,
    this.compact = false,
    super.key,
  });

  final OperationType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final visuals = OperationTypeVisuals.of(type);
    final dotSize = compact ? 5.5 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7.5 : 8.5,
        vertical: compact ? 2.5 : 3.5,
      ),
      decoration: BoxDecoration(
        color: visuals.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: visuals.fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            type.displayName,
            style: TextStyle(
              color: visuals.fg,
              fontSize: compact ? 10.5 : 11,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill badge `● Quá hạn` đồng bộ với badge `Quá hạn` của Task Chủ giao
/// và phong cách pill của màn Vận hành.
class OperationOverdueBadge extends StatelessWidget {
  const OperationOverdueBadge({this.compact = false, super.key});

  final bool compact;

  static const Color bg = Color(0xFFFBE6EA);
  static const Color fg = Color(0xFFDC2626);
  static const Color cardSurface = Color(0xFFFFF5F6);
  static const Color cardBorder = Color(0xFFFECDD3);

  @override
  Widget build(BuildContext context) {
    final dotSize = compact ? 5.5 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7.5 : 8.5,
        vertical: compact ? 2.5 : 3.5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: dotSize,
            height: dotSize,
            decoration: const BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Quá hạn',
            style: TextStyle(
              color: fg,
              fontSize: compact ? 10.5 : 11,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
