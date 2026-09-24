import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/profile/data/services/cloudinary_avatar_storage.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _imagePicker = ImagePicker();
  bool _isUploadingAvatar = false;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: profileState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.ocean,
              strokeWidth: 2.5,
            ),
          ),
          error: (error, _) => _ProfileError(
            message: _messageFor(error),
            onRetry: () =>
                ref.read(profileControllerProvider.notifier).refresh(),
          ),
          data: (profile) => RefreshIndicator(
            color: AppColors.ocean,
            onRefresh: () async {
              if (profile.role == AccountRole.farmOwner) {
                ref.invalidate(activePersonnelCountProvider);
              }
              await ref.read(profileControllerProvider.notifier).refresh();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: <Widget>[
                const Text(
                  'Tài khoản',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),
                _ProfileHero(
                  profile: profile,
                  isUploading: _isUploadingAvatar,
                  onAvatarTap: _pickAndUploadAvatar,
                ),
                if (profile.role == AccountRole.technician) ...<Widget>[
                  const SizedBox(height: 14),
                  _TechnicianKpiRow(kpi: profile.technicianKpi),
                ] else if (profile.role == AccountRole.farmOwner) ...<Widget>[
                  const SizedBox(height: 14),
                  _FarmOwnerKpiRow(kpi: profile.farmOwnerKpi),
                ],
                if (profile.role == AccountRole.farmOwner) ...<Widget>[
                  const SizedBox(height: 14),
                  _ActionCard(
                    children: <Widget>[
                      _ActionRow(
                        key: const Key('account_personnel_entry'),
                        icon: Icons.person_outline,
                        label: 'Nhân sự',
                        subtitle: ref
                            .watch(activePersonnelCountProvider)
                            .when(
                              data: (count) => '$count đang hoạt động',
                              loading: () => 'Đang tải số nhân sự...',
                              error: (_, _) => 'Xem danh sách nhân sự',
                            ),
                        onTap: () => context.go(AppRoutes.personnel),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                const Text(
                  'Thông tin tài khoản',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                _AccountInfoCard(profile: profile),
                const SizedBox(height: 12),
                _ActionCard(
                  children: <Widget>[
                    _ActionRow(
                      icon: Icons.edit_outlined,
                      label: 'Cập nhật thông tin cá nhân',
                      onTap: () => context.push(AppRoutes.profileEdit),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _ActionRow(
                      icon: Icons.shield_outlined,
                      label: 'Đổi mật khẩu',
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('profile_logout_button'),
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout_rounded, size: 19),
                  label: const Text('Đăng xuất'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: AppColors.error,
                    backgroundColor: const Color(0xFFFFF1F3),
                    side: const BorderSide(color: Color(0xFFFFC7D0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'SmartShrimp Platform · v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    if (_isUploadingAvatar) return;

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      final Uint8List bytes = await image.readAsBytes();
      if (bytes.length > CloudinaryAvatarStorage.maxAvatarBytes) {
        throw const ApiException('Ảnh đại diện không được vượt quá 5 MB.');
      }

      setState(() => _isUploadingAvatar = true);
      await ref
          .read(profileControllerProvider.notifier)
          .updateAvatar(bytes: bytes, fileName: image.name);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật ảnh đại diện thành công.')),
      );
    } on AppException catch (error) {
      if (mounted) {
        _showError(error.message);
      }
    } on Object {
      if (mounted) {
        _showError('Không thể chọn hoặc tải ảnh lên. Vui lòng thử lại.');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  static String _messageFor(Object error) {
    if (error case AppException(:final message)) return message;
    return 'Không thể tải hồ sơ. Vui lòng thử lại.';
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.profile,
    required this.isUploading,
    required this.onAvatarTap,
  });

  final AccountProfile profile;
  final bool isUploading;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/profile_background.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33205080),
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: <Color>[Color(0xAA1467B5), Color(0x2212BDD0)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: <Widget>[
              Semantics(
                button: true,
                label: 'Chọn ảnh đại diện từ thư viện',
                child: GestureDetector(
                  key: const Key('profile_avatar_button'),
                  onTap: isUploading ? null : onAvatarTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      _Avatar(profile: profile, isUploading: isUploading),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: AppColors.ocean,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        shadows: <Shadow>[
                          Shadow(color: Color(0x44000000), blurRadius: 3),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xEEFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.person_rounded,
                              color: AppColors.ocean,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                profile.roleLabel,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ocean,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile, required this.isUploading});

  final AccountProfile profile;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x33000000), blurRadius: 12),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (avatarUrl != null && avatarUrl.isNotEmpty)
              Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initials(profile.initials),
              )
            else
              _Initials(profile.initials),
            if (isUploading)
              const ColoredBox(
                color: Color(0x77000000),
                child: Center(
                  child: SizedBox.square(
                    dimension: 23,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFEAF4FF),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: AppColors.ocean,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AccountInfoCard extends StatelessWidget {
  const _AccountInfoCard({required this.profile});

  final AccountProfile profile;

  @override
  Widget build(BuildContext context) {
    final rows = <_InfoData>[
      _InfoData(Icons.mail_outline_rounded, 'Email', profile.email),
      _InfoData(
        Icons.phone_outlined,
        'Số điện thoại',
        profile.phone?.isNotEmpty ?? false ? profile.phone! : 'Chưa cập nhật',
      ),
      if (profile.role == AccountRole.technician)
        _InfoData(
          Icons.business_outlined,
          'Chủ trang trại phụ trách',
          profile.managedByOwner?.displayName ?? 'Chưa phân công',
          accent: true,
        )
      else
        _InfoData(
          Icons.badge_outlined,
          'Vai trò hệ thống',
          profile.roleLabel,
          accent: true,
        ),
      _InfoData(
        Icons.schedule_outlined,
        'Tham gia hệ thống từ',
        _formatJoinedAt(profile.activatedAt ?? profile.createdAt),
      ),
    ];

    return _ActionCard(
      children: <Widget>[
        for (var index = 0; index < rows.length; index++) ...<Widget>[
          _InfoRow(data: rows[index]),
          if (index != rows.length - 1)
            const Divider(height: 1, color: AppColors.line),
        ],
      ],
    );
  }

  static String _formatJoinedAt(DateTime? date) {
    if (date == null) return 'Chưa có dữ liệu';
    final local = date.toLocal();
    return 'tháng ${local.month} năm ${local.year}';
  }
}

class _TechnicianKpiRow extends StatelessWidget {
  const _TechnicianKpiRow({required this.kpi});

  final TechnicianKpi? kpi;

  @override
  Widget build(BuildContext context) {
    final rate = kpi?.onTimeCompletionRatePct;
    return _KpiRow(
      items: <_KpiData>[
        _KpiData(
          label: 'Vụ tham gia',
          subtitle: 'Tích lũy',
          value: '${kpi?.seasonsParticipated ?? 0}',
        ),
        _KpiData(
          label: 'Nhiệm vụ',
          subtitle: 'Đã hoàn tất',
          value: '${kpi?.completedTasks ?? 0}',
        ),
        _KpiData(
          label: 'Đúng hạn',
          subtitle: 'Chỉ tiêu KPI',
          value: rate == null ? '—' : '${rate.round()}%',
          available: rate != null,
        ),
      ],
    );
  }
}

class _FarmOwnerKpiRow extends StatelessWidget {
  const _FarmOwnerKpiRow({required this.kpi});

  final FarmOwnerKpi? kpi;

  @override
  Widget build(BuildContext context) {
    return _KpiRow(
      items: <_KpiData>[
        _KpiData(
          label: 'Trang trại',
          subtitle: 'Đang sở hữu',
          value: '${kpi?.farmsOwned ?? 0}',
        ),
        _KpiData(
          label: 'Ao nuôi',
          subtitle: 'Đang quản lý',
          value: '${kpi?.pondsManaged ?? 0}',
        ),
        _KpiData(
          label: 'Vụ nuôi',
          subtitle: 'Đang hoạt động',
          value: '${kpi?.activeSeasons ?? 0}',
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.items});

  final List<_KpiData> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          if (index > 0) const SizedBox(width: 9),
          Expanded(
            child: _KpiCard(
              label: items[index].label,
              subtitle: items[index].subtitle,
              value: items[index].value,
              available: items[index].available,
            ),
          ),
        ],
      ],
    );
  }
}

class _KpiData {
  const _KpiData({
    required this.label,
    required this.subtitle,
    required this.value,
    this.available = true,
  });

  final String label;
  final String subtitle;
  final String value;
  final bool available;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.subtitle,
    required this.value,
    this.available = true,
  });

  final String label;
  final String subtitle;
  final String value;
  final bool available;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(11, 11, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x150F1C2E),
            blurRadius: 13,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 9),
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  color: available
                      ? const Color(0xFFDDF7EC)
                      : const Color(0xFFF0F2F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  available ? Icons.check_rounded : Icons.remove_rounded,
                  color: available
                      ? const Color(0xFF10A56F)
                      : AppColors.inkMuted,
                  size: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoData {
  const _InfoData(this.icon, this.label, this.value, {this.accent = false});

  final IconData icon;
  final String label;
  final String value;
  final bool accent;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data});

  final _InfoData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      child: Row(
        children: <Widget>[
          _SquareIcon(icon: data.icon),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.label,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: data.accent ? AppColors.ocean : AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x120F1C2E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: <Widget>[
              _SquareIcon(icon: icon),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  const _SquareIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: AppColors.ocean, size: 17),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.inkMuted,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
