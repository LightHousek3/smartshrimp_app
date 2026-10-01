import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';

abstract final class PersonnelVisuals {
  static String roleLabel(AccountRole role) => switch (role) {
    AccountRole.technician => 'Kỹ thuật viên',
    AccountRole.expert => 'Chuyên gia thủy sản',
    _ => 'Nhân sự',
  };

  static String roleBadgeLabel(AccountRole role) => switch (role) {
    AccountRole.technician => 'KTV',
    AccountRole.expert => 'Expert',
    _ => 'Nhân sự',
  };

  static String statusLabel(AccountStatus status) => switch (status) {
    AccountStatus.active => 'Đang hoạt động',
    AccountStatus.pendingActivation => 'Chờ kích hoạt',
    AccountStatus.inactive => 'Tạm ngưng',
    AccountStatus.blocked => 'Đã khóa',
    AccountStatus.unknown => 'Không xác định',
  };

  static Color statusForeground(AccountStatus status) => switch (status) {
    AccountStatus.active => const Color(0xFF087F6B),
    AccountStatus.pendingActivation => const Color(0xFF9A6500),
    AccountStatus.inactive => const Color(0xFF5E6E87),
    AccountStatus.blocked => const Color(0xFFB4233E),
    AccountStatus.unknown => AppColors.inkMuted,
  };

  static Color statusBackground(AccountStatus status) => switch (status) {
    AccountStatus.active => const Color(0xFFE0F7F1),
    AccountStatus.pendingActivation => const Color(0xFFFFF2CE),
    AccountStatus.inactive => const Color(0xFFEEF1F6),
    AccountStatus.blocked => const Color(0xFFFFE8ED),
    AccountStatus.unknown => const Color(0xFFEEF1F6),
  };

  static Color roleForeground(AccountRole role) => switch (role) {
    AccountRole.technician => const Color(0xFF0C4E8F),
    AccountRole.expert => const Color(0xFF0F9B8E),
    _ => AppColors.inkMuted,
  };

  static Color roleBackground(AccountRole role) => switch (role) {
    AccountRole.technician => const Color(0xFFEAF4FF),
    AccountRole.expert => const Color(0xFFE2F6F3),
    _ => const Color(0xFFEEF1F6),
  };

  static Color avatarBackground(AccountRole role) => switch (role) {
    AccountRole.technician => const Color(0xFF1D7AD6),
    AccountRole.expert => const Color(0xFF0F9B8E),
    _ => const Color(0xFF64748B),
  };

  static String formatDate(DateTime? value) {
    if (value == null) return 'Chưa có dữ liệu';
    final local = value.toLocal();
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(local.day)}/${twoDigits(local.month)}/${local.year}';
  }

  static String formatDateTime(DateTime? value) {
    if (value == null) return 'Chưa có dữ liệu';
    final local = value.toLocal();
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(local.hour)}:${twoDigits(local.minute)} '
        '${twoDigits(local.day)}/${twoDigits(local.month)}/${local.year}';
  }
}

class PersonnelAvatar extends StatelessWidget {
  const PersonnelAvatar({required this.personnel, this.radius = 24, super.key});

  final ManagedPersonnel personnel;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = personnel.avatarUrl?.trim();
    return Semantics(
      image: true,
      label: 'Ảnh đại diện của ${personnel.displayName}',
      child: CircleAvatar(
        radius: radius,
        key: Key('personnel_avatar_${personnel.id}'),
        backgroundColor: PersonnelVisuals.avatarBackground(personnel.role),
        child: ClipOval(
          child: avatarUrl == null || avatarUrl.isEmpty
              ? _Initials(personnel: personnel, radius: radius)
              : Image.network(
                  avatarUrl,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      _Initials(personnel: personnel, radius: radius),
                ),
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.personnel, required this.radius});

  final ManagedPersonnel personnel;
  final double radius;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: radius * 2,
    child: Center(
      child: Text(
        personnel.displayName
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .last
            .substring(0, 1)
            .toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class PersonnelPill extends StatelessWidget {
  const PersonnelPill({
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
    super.key,
  });

  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, color: foreground, size: 13),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            height: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
