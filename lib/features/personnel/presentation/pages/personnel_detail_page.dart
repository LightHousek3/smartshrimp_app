import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
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
          data: (detail) => RefreshIndicator(
            color: AppColors.ocean,
            onRefresh: ref.read(provider.notifier).refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                StickyPageHeader(
                  title: detail.personnel.displayName,
                  titleSize: 20,
                  height: 64,
                  onBack: context.pop,
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _ContactCard(personnel: detail.personnel),
                            const SizedBox(height: 16),
                            _KpiCard(
                              personnel: detail.personnel,
                              kpi: detail.kpi,
                            ),
                            const SizedBox(height: 16),
                            _CurrentAssignmentsSection(
                              assignments: detail.currentAssignments,
                            ),
                            const SizedBox(height: 16),
                            _AssignmentHistorySection(
                              assignments: detail.assignmentHistory,
                            ),
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.personnel});

  final ManagedPersonnel personnel;

  @override
  Widget build(BuildContext context) => _SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PersonnelAvatar(personnel: personnel, radius: 25),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    personnel.displayName,
                    key: const Key('personnel_detail_name'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: <Widget>[
                      PersonnelPill(
                        label: PersonnelVisuals.roleLabel(personnel.role),
                        foreground: PersonnelVisuals.roleForeground(
                          personnel.role,
                        ),
                        background: PersonnelVisuals.roleBackground(
                          personnel.role,
                        ),
                      ),
                      PersonnelPill(
                        label: PersonnelVisuals.statusLabel(personnel.status),
                        foreground: PersonnelVisuals.statusForeground(
                          personnel.status,
                        ),
                        background: PersonnelVisuals.statusBackground(
                          personnel.status,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Divider(height: 1, color: AppColors.line),
        ),
        _InfoRow(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: personnel.email,
        ),
        const SizedBox(height: 13),
        _InfoRow(
          icon: Icons.phone_rounded,
          label: 'Điện thoại',
          value: personnel.phone?.trim().isNotEmpty == true
              ? personnel.phone!
              : 'Chưa cập nhật',
        ),
        const SizedBox(height: 13),
        _InfoRow(
          icon: Icons.calendar_month_rounded,
          label: 'Tham gia hệ thống từ',
          value: PersonnelVisuals.formatDate(
            personnel.activatedAt ?? personnel.createdAt,
          ),
        ),
      ],
    ),
  );
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.personnel, required this.kpi});

  final ManagedPersonnel personnel;
  final PersonnelKpi kpi;

  @override
  Widget build(BuildContext context) {
    final technician = personnel.role == AccountRole.technician;
    final metrics = technician
        ? <_KpiMetric>[
            _KpiMetric(
              icon: Icons.layers_rounded,
              label: 'Vụ đã tham gia',
              value: '${kpi.seasonsParticipated}',
              hint: 'Bao gồm lịch sử phân công',
              background: const Color(0xFFEAF4FF),
              foreground: const Color(0xFF0C4E8F),
            ),
            _KpiMetric(
              icon: Icons.checklist_rounded,
              label: 'Nhiệm vụ hoàn thành',
              value: '${kpi.completedTasks ?? 0}',
              hint: 'Trạng thái đã hoàn thành',
              background: const Color(0xFFE2F6F3),
              foreground: const Color(0xFF087F6B),
            ),
            _KpiMetric(
              icon: Icons.alarm_on_rounded,
              label: 'Hoàn thành đúng hạn',
              value: '${kpi.onTimeCompletedTasks ?? 0}',
              hint: 'Không trễ hạn giao',
              background: const Color(0xFFE2F6F3),
              foreground: const Color(0xFF087F6B),
            ),
            _KpiMetric(
              icon: Icons.timer_rounded,
              label: 'Tỷ lệ đúng hạn',
              value: _metricLabel(kpi.onTimeCompletionRatePct, suffix: '%'),
              hint: 'Đúng hạn / đã hoàn thành',
              background: const Color(0xFFFBF0DC),
              foreground: const Color(0xFFB86808),
            ),
          ]
        : <_KpiMetric>[
            _KpiMetric(
              icon: Icons.layers_rounded,
              label: 'Vụ đã tham gia',
              value: '${kpi.seasonsParticipated}',
              hint: 'Bao gồm lịch sử phân công',
              background: const Color(0xFFEAF4FF),
              foreground: const Color(0xFF0C4E8F),
            ),
            _KpiMetric(
              icon: Icons.health_and_safety_rounded,
              label: 'Ca bệnh xử lý',
              value: '${kpi.diseaseCasesHandled ?? 0}',
              hint: 'Tất cả ca được phân công',
              background: const Color(0xFFFBE6EA),
              foreground: const Color(0xFFB4233E),
            ),
            _KpiMetric(
              icon: Icons.check_circle_rounded,
              label: 'Ca đã giải quyết',
              value: '${kpi.diseaseCasesResolved ?? 0}',
              hint: 'Trạng thái đã giải quyết',
              background: const Color(0xFFE2F6F3),
              foreground: const Color(0xFF087F6B),
            ),
            _KpiMetric(
              icon: Icons.schedule_rounded,
              label: 'Thời gian xử lý TB',
              value: _metricLabel(kpi.avgResolutionHours, suffix: ' giờ'),
              hint: 'Từ lúc mở đến khi giải quyết',
              background: const Color(0xFFFBF0DC),
              foreground: const Color(0xFFB86808),
            ),
          ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: const Color(0xFFF7F9FC),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'KPI vận hành',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Tổng hợp từ dữ liệu đã ghi nhận trong hệ thống',
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: technician
                        ? const Color(0xFFEAF4FF)
                        : const Color(0xFFE2F6F3),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    technician ? 'Theo nhiệm vụ' : 'Theo ca bệnh',
                    style: TextStyle(
                      color: technician
                          ? const Color(0xFF0C4E8F)
                          : const Color(0xFF087F6B),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 8) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: metrics
                      .map(
                        (metric) => SizedBox(
                          width: width,
                          child: _KpiMetricCard(metric: metric),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiMetric {
  const _KpiMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;
  final Color background;
  final Color foreground;
}

class _KpiMetricCard extends StatelessWidget {
  const _KpiMetricCard({required this.metric});

  final _KpiMetric metric;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 104),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: metric.background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(metric.icon, size: 13, color: metric.foreground),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                metric.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: metric.foreground,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          metric.value,
          style: TextStyle(
            color: metric.foreground,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          metric.hint,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: metric.foreground.withValues(alpha: 0.7),
            fontSize: 9,
            height: 1.25,
          ),
        ),
      ],
    ),
  );
}

class _CurrentAssignmentsSection extends StatelessWidget {
  const _CurrentAssignmentsSection({required this.assignments});

  final List<PersonnelSeasonAssignment> assignments;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _SectionHeading('Phân công hiện tại'),
      const SizedBox(height: 8),
      if (assignments.isEmpty)
        const _AssignmentEmpty('Chưa được phân công vào vụ nuôi nào.')
      else
        for (var index = 0; index < assignments.length; index++) ...<Widget>[
          _CurrentAssignmentCard(assignment: assignments[index]),
          if (index != assignments.length - 1) const SizedBox(height: 8),
        ],
    ],
  );
}

class _CurrentAssignmentCard extends StatelessWidget {
  const _CurrentAssignmentCard({required this.assignment});

  final PersonnelSeasonAssignment assignment;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      key: Key('personnel_current_assignment_${assignment.id}'),
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(
        '/farms/${assignment.farmId}/ponds/${assignment.pondId}/seasons/'
        '${assignment.seasonId}',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    assignment.pondName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${assignment.farmName} · ${assignment.seasonName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 17,
              color: AppColors.inkMuted,
            ),
          ],
        ),
      ),
    ),
  );
}

class _AssignmentHistorySection extends StatelessWidget {
  const _AssignmentHistorySection({required this.assignments});

  final List<PersonnelSeasonAssignment> assignments;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const _SectionHeading('Lịch sử phân công'),
      const SizedBox(height: 8),
      if (assignments.isEmpty)
        const _AssignmentEmpty('Chưa có lịch sử phân công.')
      else
        for (var index = 0; index < assignments.length; index++) ...<Widget>[
          _HistoryAssignmentCard(assignment: assignments[index]),
          if (index != assignments.length - 1) const SizedBox(height: 8),
        ],
    ],
  );
}

class _HistoryAssignmentCard extends StatelessWidget {
  const _HistoryAssignmentCard({required this.assignment});

  final PersonnelSeasonAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final reason = assignment.replacementReason?.trim();
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: Key('personnel_assignment_history_${assignment.id}'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          '/farms/${assignment.farmId}/ponds/${assignment.pondId}/seasons/'
          '${assignment.seasonId}',
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      assignment.pondName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Vụ nuôi: ${assignment.seasonName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${PersonnelVisuals.formatDate(assignment.assignedAt)}-'
                      '${PersonnelVisuals.formatDate(assignment.unassignedAt)}',
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                      ),
                    ),
                    if (reason != null && reason.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 7),
                      Text(
                        reason,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _AssignmentEmpty extends StatelessWidget {
  const _AssignmentEmpty(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.line),
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
    ),
  );
}

String _metricLabel(double? value, {required String suffix}) {
  if (value == null) return '—';
  final rounded = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
  return '$rounded$suffix';
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[child],
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
      Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Icon(icon, color: const Color(0xFF1D7AD6), size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
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
          icon: Icon(Icons.adaptive.arrow_back),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.person_off_rounded,
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
