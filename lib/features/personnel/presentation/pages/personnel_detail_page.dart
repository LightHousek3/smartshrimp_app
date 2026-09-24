import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/personnel/presentation/widgets/personnel_visuals.dart';

class PersonnelDetailPage extends ConsumerWidget {
  const PersonnelDetailPage({required this.personnelId, super.key});

  final String personnelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = personnelDetailControllerProvider(personnelId);
    final state = ref.watch(provider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: state.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => _DetailError(
            message: error is AppException
                ? error.message
                : 'Không thể tải chi tiết nhân sự.',
            onBack: context.pop,
            onRetry: ref.read(provider.notifier).refresh,
          ),
          data: (personnel) => RefreshIndicator(
            color: AppColors.ocean,
            onRefresh: ref.read(provider.notifier).refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _DetailHeader(onBack: context.pop),
                            const SizedBox(height: 16),
                            _IdentityCard(personnel: personnel),
                            const SizedBox(height: 14),
                            _AssignmentCard(personnel: personnel),
                            const SizedBox(height: 14),
                            _ContactCard(personnel: personnel),
                            const SizedBox(height: 14),
                            _ActivityCard(personnel: personnel),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      IconButton.filledTonal(
        tooltip: 'Quay lại',
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Chi tiết nhân sự',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Thông tin tài khoản và phân công hiện tại',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.personnel});

  final ManagedPersonnel personnel;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    child: Column(
      children: <Widget>[
        PersonnelAvatar(personnel: personnel, radius: 42),
        const SizedBox(height: 13),
        Text(
          personnel.displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 7,
          runSpacing: 7,
          children: <Widget>[
            PersonnelPill(
              label: PersonnelVisuals.roleLabel(personnel.role),
              foreground: PersonnelVisuals.roleForeground(personnel.role),
              background: PersonnelVisuals.roleBackground(personnel.role),
            ),
            PersonnelPill(
              label: PersonnelVisuals.statusLabel(personnel.status),
              foreground: PersonnelVisuals.statusForeground(personnel.status),
              background: PersonnelVisuals.statusBackground(personnel.status),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.personnel});

  final ManagedPersonnel personnel;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    child: Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F2FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.layers_rounded, color: AppColors.ocean),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'VỤ ĐANG PHỤ TRÁCH',
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${personnel.currentSeasonAssignments}',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Text(
          personnel.currentSeasonAssignments == 0
              ? 'Chưa được phân công'
              : 'Đang tham gia',
          style: TextStyle(
            color: personnel.currentSeasonAssignments == 0
                ? AppColors.inkMuted
                : const Color(0xFF087F6B),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.personnel});

  final ManagedPersonnel personnel;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    title: 'Thông tin liên hệ',
    child: Column(
      children: <Widget>[
        _InfoRow(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: personnel.email,
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'Số điện thoại',
          value: personnel.phone?.trim().isNotEmpty == true
              ? personnel.phone!
              : 'Chưa cập nhật',
        ),
      ],
    ),
  );
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.personnel});

  final ManagedPersonnel personnel;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    title: 'Hoạt động tài khoản',
    child: Column(
      children: <Widget>[
        _InfoRow(
          icon: Icons.verified_user_outlined,
          label: 'Kích hoạt lúc',
          value: PersonnelVisuals.formatDateTime(personnel.activatedAt),
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.login_rounded,
          label: 'Đăng nhập gần nhất',
          value: PersonnelVisuals.formatDateTime(personnel.lastLoginAt),
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Ngày tạo tài khoản',
          value: PersonnelVisuals.formatDateTime(personnel.createdAt),
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.update_rounded,
          label: 'Cập nhật gần nhất',
          value: PersonnelVisuals.formatDateTime(personnel.updatedAt),
        ),
      ],
    ),
  );
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: const Color(0xF8FFFFFF),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 9,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title != null) ...<Widget>[
          Text(
            title!,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
        ],
        child,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF4FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.ocean, size: 17),
      ),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
            ),
            const SizedBox(height: 2),
            SelectableText(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Divider(height: 1, color: AppColors.line),
  );
}

class _DetailError extends StatelessWidget {
  const _DetailError({
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onBack;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton.filledTonal(
          tooltip: 'Quay lại',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.person_off_outlined,
                  size: 46,
                  color: AppColors.inkMuted,
                ),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 13),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
