import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

class OperationStatusBadge extends StatelessWidget {
  const OperationStatusBadge({required this.status, super.key});

  final OperationStatus status;

  @override
  Widget build(BuildContext context) {
    final (dot, text, background) = switch (status) {
      OperationStatus.planned => (
        const Color(0xFF1D7AD6),
        const Color(0xFF1D7AD6),
        const Color(0xFFDEEDFD),
      ),
      OperationStatus.completed => (
        const Color(0xFF10B981),
        const Color(0xFF047857),
        const Color(0xFFECFDF5),
      ),
      OperationStatus.cancelled => (
        AppColors.inkMuted,
        AppColors.inkMuted,
        const Color(0xFFF1F5F9),
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              status.displayName,
              style: TextStyle(
                color: text,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OperationUnrecordedBadge extends StatelessWidget {
  const OperationUnrecordedBadge({super.key});

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0xFFFFF3DC),
      borderRadius: BorderRadius.all(Radius.circular(99)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        'Chưa ghi nhận',
        style: TextStyle(
          color: Color(0xFF9A5800),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class OperationStatusLine extends StatelessWidget {
  const OperationStatusLine({required this.badge, this.label, super.key});

  final Widget badge;
  final Widget? label;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[label!, const SizedBox(width: 6)],
          badge,
        ],
      ),
    ),
  );
}

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

/// Display the material category on operational cards.
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
          Flexible(
            child: Text(
              materialCategoryLabel(type),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: visuals.fg,
                fontSize: compact ? 10.5 : 11,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String materialCategoryLabel(OperationType type) => switch (type) {
  OperationType.feeding => 'Thức ăn',
  OperationType.medicine => 'Thuốc',
  OperationType.mineral => 'Khoáng',
  OperationType.chemical => 'Hóa chất',
  OperationType.other => 'Vật tư khác',
};

class OperationOverdueBadge extends StatelessWidget {
  const OperationOverdueBadge({this.compact = false, super.key});

  final bool compact;

  static const Color bg = Color(0xFFFBE6EA);
  static const Color fg = Color(0xFFDC2626);
  static const Color cardSurface = Color(0xFFFFF5F6);
  static const Color cardBorder = Color(0xFFFECDD3);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 7.5 : 8.5,
      vertical: compact ? 2.5 : 3.5,
    ),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      'Quá hạn',
      style: TextStyle(
        color: fg,
        fontSize: compact ? 10.5 : 11,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
    ),
  );
}
