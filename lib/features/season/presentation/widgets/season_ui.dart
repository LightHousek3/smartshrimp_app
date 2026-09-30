import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

double seasonScreenTopPadding(BuildContext context) {
  final safeTop = MediaQuery.paddingOf(context).top;
  return safeTop + 4 > 52 ? safeTop + 4 : 52;
}

class SeasonStatusBadge extends StatelessWidget {
  const SeasonStatusBadge({required this.status, super.key});

  final SeasonStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = seasonStatusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            seasonStatusLabel(status),
            style: TextStyle(
              color: colors.foreground,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class SeasonScreenHeader extends StatelessWidget {
  const SeasonScreenHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.actionIcon,
    this.actionTooltip,
    this.onAction,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final IconData? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _SeasonHeaderButton(
        icon: Icons.adaptive.arrow_back,
        tooltip: 'Quay lại',
        onPressed: onBack,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      if (actionIcon != null)
        _SeasonHeaderButton(
          icon: actionIcon!,
          tooltip: actionTooltip ?? 'Thao tác',
          onPressed: onAction,
          filled: true,
        ),
    ],
  );
}

class _SeasonHeaderButton extends StatelessWidget {
  const _SeasonHeaderButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: filled ? const Color(0xFFEEF1F6) : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 36,
          child: Icon(icon, size: filled ? 17 : 20, color: AppColors.inkSoft),
        ),
      ),
    ),
  );
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class SeasonPrimaryButton extends StatelessWidget {
  const SeasonPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.check_rounded,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return AnimatedOpacity(
      opacity: enabled || loading ? 1 : 0.48,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              AppColors.oceanLight,
              AppColors.tealLight,
              AppColors.oceanLight,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x2477A1D3),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: Center(
                child: loading
                    ? const SizedBox.square(
                        dimension: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(icon, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SeasonEmptyState extends StatelessWidget {
  const SeasonEmptyState({
    required this.title,
    required this.hint,
    this.icon = Icons.layers_rounded,
    this.compact = false,
    super.key,
  });

  final String title;
  final String hint;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconExtent = compact ? 40.0 : 48.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: compact ? 22 : 38,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
        color: const Color(0x4DFFFFFF),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: iconExtent,
            height: iconExtent,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1F6),
              borderRadius: BorderRadius.circular(compact ? 14 : 16),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF64748B),
              size: compact ? 19 : 23,
            ),
          ),
          SizedBox(height: compact ? 10 : 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

({Color background, Color foreground}) seasonStatusColors(
  SeasonStatus status,
) => switch (status) {
  SeasonStatus.planning => (
    background: const Color(0xFFEFEAFC),
    foreground: const Color(0xFF7B5BD6),
  ),
  SeasonStatus.active => (
    background: const Color(0xFFE2F6F3),
    foreground: const Color(0xFF0F9B8E),
  ),
  SeasonStatus.completed => (
    background: const Color(0xFFEEF1F6),
    foreground: const Color(0xFF64748B),
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
