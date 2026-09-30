import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class SeasonDetailPage extends ConsumerWidget {
  const SeasonDetailPage({
    required this.farmId,
    required this.pondId,
    required this.seasonId,
    super.key,
  });

  final String farmId;
  final String pondId;
  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seasonDetailControllerProvider(seasonId));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: state.when(
            data: (season) => _SeasonDetailContent(
              farmId: farmId,
              pondId: pondId,
              season: season,
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (error, _) => _DetailError(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải chi tiết vụ nuôi.',
              onRetry: ref
                  .read(seasonDetailControllerProvider(seasonId).notifier)
                  .refresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _SeasonDetailContent extends ConsumerWidget {
  const _SeasonDetailContent({
    required this.farmId,
    required this.pondId,
    required this.season,
  });

  final String farmId;
  final String pondId;
  final AquacultureSeason season;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = ref.watch(seasonMutationControllerProvider);
    return RefreshIndicator(
      color: AppColors.ocean,
      onRefresh: ref
          .read(seasonDetailControllerProvider(season.id).notifier)
          .refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16,
          seasonScreenTopPadding(context),
          16,
          32,
        ),
        children: <Widget>[
          _header(context, mutation.isLoading),
          const SizedBox(height: 12),
          _overview(),
          if (season.status == SeasonStatus.active) ...<Widget>[
            const SizedBox(height: 16),
            _historyShortcuts(context),
          ],
          if (season.status == SeasonStatus.active ||
              season.status == SeasonStatus.completed) ...<Widget>[
            const SizedBox(height: 16),
            _costCard(),
          ],
          const SizedBox(height: 16),
          _protocol(context),
          if (season.status != SeasonStatus.planning) ...<Widget>[
            const SizedBox(height: 8),
            _diseaseCard(context),
          ],
          if (season.status == SeasonStatus.planning) ...<Widget>[
            const SizedBox(height: 16),
            _activationChecklist(),
          ],
          const SizedBox(height: 16),
          _personnel(context, ref, mutation.isLoading),
          const SizedBox(height: 16),
          _actions(context, ref, mutation.isLoading),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, bool loading) => SeasonScreenHeader(
    title: season.name,
    subtitle: '${season.pond.name} · ${season.pond.farm?.name ?? 'Trang trại'}',
    onBack: loading ? null : context.pop,
    actionIcon: season.canUpdate ? Icons.edit_rounded : null,
    actionTooltip: 'Cập nhật vụ nuôi',
    onAction: loading
        ? null
        : () => context.push(
            '/farms/$farmId/ponds/$pondId/seasons/${season.id}/edit',
            extra: season,
          ),
  );

  Widget _overview() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                shrimpTypeLabel(season.shrimpType),
                style: const TextStyle(
                  color: AppColors.ocean,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SeasonStatusBadge(status: season.status),
          ],
        ),
        const SizedBox(height: 16),
        _metricGrid(),
        if (season.status == SeasonStatus.cancelled &&
            season.cancellationReason != null) ...<Widget>[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBE6EA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF6CFD7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'LÝ DO HỦY VỤ',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  season.cancellationReason!,
                  style: const TextStyle(
                    color: Color(0xFF9F2440),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  Widget _metricGrid() {
    final metrics = <({String label, String value, bool highlighted})>[
      (
        label: 'NGÀY THẢ GIỐNG',
        value: seasonDateLabel(season.stockingDate),
        highlighted: false,
      ),
      (
        label: 'DỰ KIẾN KẾT THÚC',
        value: seasonDateLabel(season.expectedEndDate),
        highlighted: false,
      ),
      if (season.actualEndDate != null)
        (
          label: 'KẾT THÚC THỰC TẾ',
          value: seasonDateLabel(season.actualEndDate),
          highlighted: false,
        ),
      if (season.initialQuantity != null)
        (
          label: 'SỐ LƯỢNG THẢ',
          value: '${seasonIntegerLabel(season.initialQuantity)} con',
          highlighted: false,
        ),
      if (season.initialDensityPerM2 != null)
        (
          label: 'MẬT ĐỘ THẢ',
          value: '${seasonDecimalLabel(season.initialDensityPerM2)} con/m²',
          highlighted: false,
        ),
      if (season.status == SeasonStatus.active && season.dayOfCulture != null)
        (label: 'DOC', value: 'Ngày ${season.dayOfCulture}', highlighted: true),
      if (season.status == SeasonStatus.active ||
          season.status == SeasonStatus.completed)
        (label: 'FCR TẠM TÍNH', value: '—', highlighted: true),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: <Widget>[
            for (final metric in metrics)
              SizedBox(
                width: cellWidth,
                child: _DetailMetric(
                  label: metric.label,
                  value: metric.value,
                  highlighted: metric.highlighted,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _historyShortcuts(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        child: _HistoryShortcut(
          icon: Icons.water_drop_outlined,
          label: 'Đo nước',
          background: const Color(0xFFEAF4FF),
          foreground: const Color(0xFF1378D1),
          onTap: () => _comingSoon(context, 'Nhật ký đo nước'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _HistoryShortcut(
          icon: Icons.favorite_border_rounded,
          label: 'Sức khỏe',
          background: const Color(0xFFFBE6EA),
          foreground: AppColors.error,
          onTap: () => _comingSoon(context, 'Nhật ký sức khỏe'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _HistoryShortcut(
          icon: Icons.agriculture_rounded,
          label: 'Thu hoạch',
          background: const Color(0xFFE2F6F3),
          foreground: const Color(0xFF0F9B8E),
          onTap: () => _comingSoon(context, 'Lịch sử thu hoạch'),
        ),
      ),
    ],
  );

  Widget _costCard() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Chi phí vật tư',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        const Row(
          children: <Widget>[
            SizedBox.square(
              dimension: 128,
              child: CustomPaint(
                painter: _EmptyCostRingPainter(),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'TỔNG ĐÃ DÙNG',
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '0 ₫',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                children: <Widget>[
                  _CostRow(
                    label: 'Thức ăn',
                    value: '0 ₫',
                    percent: 0,
                    color: Color(0xFF0F9B8E),
                  ),
                  SizedBox(height: 9),
                  _CostRow(
                    label: 'Thuốc',
                    value: '0 ₫',
                    percent: 0,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 9),
                  _CostRow(
                    label: 'Môi trường',
                    value: '0 ₫',
                    percent: 0,
                    color: Color(0xFF7B5BD6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _diseaseCard(BuildContext context) => _FeatureCard(
    icon: Icons.health_and_safety_rounded,
    iconBackground: const Color(0xFFFBE6EA),
    iconForeground: AppColors.error,
    title: 'Ca bệnh',
    subtitle: 'Theo dõi chẩn đoán và diễn tiến xử lý',
    badges: const <Widget>[
      _FeatureBadge(
        label: 'Không có ca mở',
        background: Color(0xFFE2F6F3),
        foreground: Color(0xFF0F9B8E),
      ),
    ],
    onTap: () => _comingSoon(context, 'Ca bệnh'),
  );

  Widget _personnel(BuildContext context, WidgetRef ref, bool loading) {
    final personnel = season.personnelForDisplay;
    final historical =
        season.status == SeasonStatus.cancelled ||
        season.status == SeasonStatus.completed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Nhân sự phụ trách',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (season.status == SeasonStatus.planning ||
                  season.status == SeasonStatus.active)
                InkWell(
                  key: const Key('open_personnel_assignment'),
                  onTap: loading
                      ? null
                      : () => _openPersonnelAssignment(context, ref),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Phân công',
                      style: TextStyle(
                        color: AppColors.ocean,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _PersonRow(
          role: 'Kỹ thuật viên',
          assignment: personnel?.technician,
          historical: historical,
        ),
        const SizedBox(height: 8),
        _PersonRow(
          role: 'Chuyên gia thủy sản',
          assignment: personnel?.expert,
          historical: historical,
        ),
      ],
    );
  }

  Future<void> _openPersonnelAssignment(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final message = await context.push<String>(
      '/farms/$farmId/ponds/$pondId/seasons/${season.id}/personnel-assignments',
    );
    if (message == null || !context.mounted) return;
    await ref
        .read(seasonDetailControllerProvider(season.id).notifier)
        .refresh();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 9),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    AppNoticeService.info(
      context,
      'Dữ liệu cho mục này chưa được API vụ nuôi cung cấp.',
      title: feature,
    );
  }

  Widget _protocol(BuildContext context) {
    final protocol = season.approvedProductionProtocol;
    return _FeatureCard(
      icon: Icons.assignment_rounded,
      iconBackground: const Color(0xFFEAF4FF),
      iconForeground: AppColors.ocean,
      title: 'Phác đồ',
      subtitle: protocol == null
          ? 'Chưa có phác đồ nuôi được duyệt'
          : '${protocol.title} · Phiên bản ${protocol.versionNo}',
      badges: <Widget>[
        const _FeatureBadge(
          label: '0 chờ duyệt',
          background: Color(0xFFFBF0DC),
          foreground: Color(0xFFD98314),
          dot: true,
        ),
        _FeatureBadge(
          label: '${protocol == null ? 0 : 1} nuôi',
          background: const Color(0xFFEAF4FF),
          foreground: const Color(0xFF0C4E8F),
        ),
        const _FeatureBadge(
          label: '0 điều trị',
          background: Color(0xFFFBE6EA),
          foreground: AppColors.error,
        ),
      ],
      onTap: () => _comingSoon(context, 'Phác đồ'),
    );
  }

  Widget _activationChecklist() {
    final items = <({bool ok, String label})>[
      (ok: season.stockingDate != null, label: 'Ngày thả giống đã nhập'),
      (ok: season.initialQuantity != null, label: 'Số lượng giống ban đầu'),
      (
        ok: season.personnel?.technician != null,
        label:
            'KTV phụ trách: ${season.personnel?.technician?.account.fullName ?? 'Chưa phân công'}',
      ),
      (
        ok: season.personnel?.expert != null,
        label:
            'Chuyên gia: ${season.personnel?.expert?.account.fullName ?? 'Chưa phân công'}',
      ),
      (
        ok: season.approvedProductionProtocol != null,
        label: 'Phác đồ nuôi đã được duyệt',
      ),
    ];
    return SeasonSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Điều kiện kích hoạt vụ',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < items.length; index++) ...<Widget>[
            _ChecklistRow(ok: items[index].ok, label: items[index].label),
            if (index != items.length - 1) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }

  Widget _actions(BuildContext context, WidgetRef ref, bool loading) => Column(
    children: <Widget>[
      if (season.status == SeasonStatus.planning && season.canActivate)
        SeasonPrimaryButton(
          label: 'Kích hoạt vụ nuôi',
          icon: Icons.check_rounded,
          loading: loading,
          onPressed: loading ? null : () => _activate(context, ref),
        ),
      if (season.canCancel) ...<Widget>[
        if (season.status == SeasonStatus.planning && season.canActivate)
          const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 47,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.inkSoft,
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: loading ? null : () => _cancel(context, ref),
            icon: const Icon(Icons.cancel_rounded, size: 18),
            label: const Text('Hủy vụ nuôi'),
          ),
        ),
      ],
    ],
  );

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: 'Kích hoạt vụ nuôi?',
        description: 'Kiểm tra thông tin trước khi bắt đầu vận hành.',
        confirmLabel: 'Kích hoạt',
        cancelLabel: 'Để sau',
        level: AppNoticeLevel.warning,
        content: _ActivationDialogContent(season: season),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(seasonMutationControllerProvider.notifier)
          .activate(farmId: farmId, current: season);
      if (!context.mounted) return;
      AppNoticeService.success(
        context,
        'Vụ nuôi đã được kích hoạt và chuyển sang trạng thái đang nuôi.',
      );
    } on AppException catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(
          context,
          error.message,
          title: 'Không thể kích hoạt vụ nuôi',
        );
      }
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const _CancellationDialog(),
    );
    if (reason == null || !context.mounted) return;
    try {
      final result = await ref
          .read(seasonMutationControllerProvider.notifier)
          .cancel(farmId: farmId, current: season, reason: reason);
      if (!context.mounted) return;
      final scheduleMessage = result.cancelledScheduleCount > 0
          ? 'Vụ nuôi đã được hủy; ${result.cancelledScheduleCount} lịch vận hành đang chờ cũng đã được hủy.'
          : 'Vụ nuôi đã được hủy và giữ lại trong lịch sử.';
      AppNoticeService.success(context, scheduleMessage);
    } on AppException catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(
          context,
          error.message,
          title: 'Không thể hủy vụ nuôi',
        );
      }
    }
  }
}

class _ActivationDialogContent extends StatelessWidget {
  const _ActivationDialogContent({required this.season});

  final AquacultureSeason season;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDEAF4)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _ActivationDialogMetric(
                    label: 'Ao nuôi',
                    value: season.pond.name,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ActivationDialogMetric(
                    label: 'Ngày thả giống',
                    value: seasonDateLabel(season.stockingDate),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: AppColors.line),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _ActivationDialogMetric(
                    label: 'Số lượng thả',
                    value: '${seasonIntegerLabel(season.initialQuantity)} con',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ActivationDialogMetric(
                    label: 'Mật độ thả',
                    value:
                        '${seasonDecimalLabel(season.initialDensityPerM2)} con/m²',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1D8A9)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE8C5),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: Color(0xFFB86808),
              ),
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Text(
                'Thông tin khởi tạo sẽ được khóa sau khi kích hoạt và không thể chỉnh sửa.',
                style: TextStyle(
                  color: Color(0xFF8B540D),
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ActivationDialogMetric extends StatelessWidget {
  const _ActivationDialogMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.ok, required this.label});

  final bool ok;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: ok ? const Color(0xFFDCF4EC) : const Color(0xFFFBE6EA),
          shape: BoxShape.circle,
        ),
        child: Icon(
          ok ? Icons.check_rounded : Icons.close_rounded,
          size: 12,
          color: ok ? const Color(0xFF0F9B8E) : AppColors.error,
        ),
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: ok ? AppColors.ink : AppColors.error,
            fontSize: 12.5,
            height: 1.3,
          ),
        ),
      ),
    ],
  );
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.label,
    required this.value,
    this.highlighted = false,
  });
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 10,
          height: 1.5,
          letterSpacing: .25,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: highlighted ? AppColors.ocean : AppColors.ink,
          fontSize: 13,
          height: 1.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.role,
    required this.assignment,
    this.historical = false,
  });
  final String role;
  final SeasonAssignment? assignment;
  final bool historical;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: <Widget>[
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFEAF4FF),
          child: Icon(
            assignment == null
                ? Icons.person_outline_rounded
                : Icons.person_rounded,
            size: 15,
            color: const Color(0xFF1378D1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                role.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  letterSpacing: .25,
                  height: 1.5,
                ),
              ),
              Text(
                assignment?.account.fullName ?? 'Chưa phân công',
                style: TextStyle(
                  color: assignment == null
                      ? AppColors.inkMuted
                      : AppColors.ink,
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: assignment == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (historical && assignment != null)
                Text(
                  'Kết thúc phân công ${seasonDateLabel(assignment!.unassignedAt ?? assignment!.assignedAt)}',
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10,
                  ),
                ),
              if (!historical && assignment != null)
                Text(
                  'Phân công ${seasonDateLabel(assignment!.assignedAt)}',
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _HistoryShortcut extends StatelessWidget {
  const _HistoryShortcut({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xE6FFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.line),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: foreground, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 10,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    required this.title,
    required this.subtitle,
    required this.badges,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final String title;
  final String subtitle;
  final List<Widget> badges;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
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
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconForeground, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(spacing: 6, runSpacing: 4, children: badges),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({
    required this.label,
    required this.background,
    required this.foreground,
    this.dot = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool dot;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (dot) ...<Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
  });

  final String label;
  final String value;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 10),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: <Widget>[
          const SizedBox(width: 18),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 5,
                color: color,
                backgroundColor: const Color(0xFFEEF1F6),
              ),
            ),
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: 24,
            child: Text(
              '${(percent * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 9),
            ),
          ),
        ],
      ),
    ],
  );
}

class _EmptyCostRingPainter extends CustomPainter {
  const _EmptyCostRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = const Color(0xFFEEF1F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    canvas.drawArc(rect.deflate(7), -math.pi / 2, math.pi * 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant _EmptyCostRingPainter oldDelegate) => false;
}

class _CancellationDialog extends StatefulWidget {
  const _CancellationDialog();

  @override
  State<_CancellationDialog> createState() => _CancellationDialogState();
}

class _CancellationDialogState extends State<_CancellationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: 'Hủy vụ nuôi?',
    description:
        'Vụ nuôi sẽ chuyển sang trạng thái Đã hủy và được giữ lại trong lịch sử. Đây không phải thao tác xóa dữ liệu.',
    level: AppNoticeLevel.danger,
    content: Form(
      key: _formKey,
      child: TextFormField(
        controller: _reason,
        autofocus: true,
        minLines: 3,
        maxLines: 4,
        validator: SeasonRules.validateCancellationReason,
        decoration: const InputDecoration(
          labelText: 'Lý do hủy *',
          hintText: 'Nhập lý do hủy vụ nuôi…',
        ),
      ),
    ),
    actions: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: context.pop,
              child: const Text('Quay lại'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.pop(SeasonRules.normalizeText(_reason.text));
                }
              },
              child: const Text('Xác nhận hủy'),
            ),
          ),
        ],
      ),
    ],
  );
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: FarmCircleButton(
            icon: Icons.adaptive.arrow_back,
            tooltip: 'Quay lại',
            onPressed: context.pop,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.error_outline_rounded, size: 44),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
