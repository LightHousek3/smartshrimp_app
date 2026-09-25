import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

class SeasonStatusBadge extends StatelessWidget {
  const SeasonStatusBadge({required this.status, super.key});

  final SeasonStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = seasonStatusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        seasonStatusLabel(status),
        style: TextStyle(
          color: colors.foreground,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SeasonSectionCard extends StatelessWidget {
  const SeasonSectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: const Color(0xF7FFFFFF),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x100F1C2E),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

({Color background, Color foreground}) seasonStatusColors(
  SeasonStatus status,
) => switch (status) {
  SeasonStatus.planning => (
    background: const Color(0xFFFFF1D8),
    foreground: const Color(0xFF9A5B00),
  ),
  SeasonStatus.active => (
    background: const Color(0xFFE1F7F1),
    foreground: const Color(0xFF087C65),
  ),
  SeasonStatus.completed => (
    background: const Color(0xFFE8F1FF),
    foreground: const Color(0xFF245DA5),
  ),
  SeasonStatus.cancelled => (
    background: const Color(0xFFFFE8EC),
    foreground: AppColors.error,
  ),
  SeasonStatus.unknown => (
    background: const Color(0xFFEEF0F4),
    foreground: AppColors.inkMuted,
  ),
};

String seasonDateLabel(DateTime? value) {
  if (value == null) return '—';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String seasonIntegerLabel(int? value) {
  if (value == null) return '—';
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < raw.length; index++) {
    if (index > 0 && (raw.length - index) % 3 == 0) buffer.write('.');
    buffer.write(raw[index]);
  }
  return buffer.toString();
}

String seasonDecimalLabel(double? value, {int digits = 2}) {
  if (value == null) return '—';
  return value.toStringAsFixed(digits).replaceFirst(RegExp(r'\.?0+$'), '');
}

String activationConditionLabel(String code) => switch (code) {
  'SEASON_NOT_PLANNING' => 'Vụ nuôi phải ở trạng thái đang chuẩn bị',
  'FARM_ARCHIVED' => 'Trang trại không được lưu trữ',
  'POND_ARCHIVED' => 'Ao không được lưu trữ',
  'POND_NOT_AVAILABLE' => 'Ao phải ở trạng thái sẵn sàng',
  'POND_NOT_AQUACULTURE' => 'Ao phải là ao nuôi',
  'STOCKING_DATE_REQUIRED' => 'Cần ngày thả giống',
  'INITIAL_QUANTITY_REQUIRED' => 'Cần số lượng thả ban đầu',
  'INITIAL_AVG_WEIGHT_REQUIRED' => 'Cần khối lượng trung bình ban đầu',
  'INITIAL_BIOMASS_REQUIRED' => 'Chưa tính được sinh khối ban đầu',
  'INITIAL_DENSITY_REQUIRED' => 'Chưa tính được mật độ thả',
  'ACTIVE_TECHNICIAN_REQUIRED' => 'Cần đúng một Kỹ thuật viên đang hoạt động',
  'ACTIVE_EXPERT_REQUIRED' => 'Cần đúng một Chuyên gia đang hoạt động',
  'APPROVED_PRODUCTION_PROTOCOL_REQUIRED' =>
    'Cần đúng một quy trình nuôi đã được phê duyệt',
  _ => code,
};
