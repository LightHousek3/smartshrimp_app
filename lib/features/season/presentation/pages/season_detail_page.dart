import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_progress.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_material_cost_card.dart';

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
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          StickyPageHeader(
            title: season.name,
            subtitle:
                '${season.pond.name} · ${season.pond.farm?.name ?? 'Trang trại'}',
            onBack: mutation.isLoading ? null : context.pop,
            trailing: season.canUpdate
                ? AppCircleButton(
                    icon: Icons.edit_rounded,
                    tooltip: 'Cập nhật vụ nuôi',
                    size: 36,
                    iconSize: 17,
                    onPressed: mutation.isLoading
                        ? null
                        : () => context.push(
                            '/farms/$farmId/ponds/$pondId/seasons/${season.id}/edit',
                            extra: season,
                          ),
                  )
                : null,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList.list(
              children: <Widget>[
                _overview(),
                const SizedBox(height: 16),
                SeasonSectionCard(
                  child: SeasonProgress(
                    status: season.status,
                    stockingDate: season.stockingDate,
                    expectedEndDate: season.expectedEndDate,
                    dayOfCulture: season.dayOfCulture,
                  ),
                ),
                if (season.status == SeasonStatus.active) ...<Widget>[
                  const SizedBox(height: 16),
                  _historyShortcuts(context),
                ],
                // Completed seasons retain their immutable harvest history.
                if (season.status == SeasonStatus.completed ||
                    season.status == SeasonStatus.cancelled) ...<Widget>[
                  const SizedBox(height: 16),
                  _harvestShortcut(context),
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
          ),
        ],
      ),
    );
  }

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
    final activatedAt = season.activatedAt;
    final metrics = <({String label, String value, bool highlighted})>[
      (
        label: season.status == SeasonStatus.planning
            ? 'NGÀY THẢ DỰ KIẾN'
            : 'NGÀY THẢ THỰC TẾ',
        value: seasonDateLabel(
          season.status == SeasonStatus.planning
              ? season.plannedStockingDate ?? season.stockingDate
              : season.stockingDate,
        ),
        highlighted: false,
      ),
      (
        label: 'DỰ KIẾN KẾT THÚC',
        value: seasonDateLabel(season.expectedEndDate),
        highlighted: false,
      ),
      if (activatedAt != null)
        (
          label: 'NGÀY KÍCH HOẠT',
          value: seasonDateLabel(SeasonRules.vietnamCalendarDate(activatedAt)),
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
            if (season.activationDelayReason case final reason?)
              SizedBox(
                width: constraints.maxWidth,
                child: _DetailMetric(
                  label: 'LÝ DO KÍCH HOẠT MUỘN',
                  value: reason,
                  maxLines: null,
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
          onTap: () => context.push(
            '/farms/$farmId/ponds/$pondId/seasons/${season.id}/water-logs',
            extra: <String, String>{
              'pondName': season.pond.name,
              'seasonName': season.name,
            },
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _HistoryShortcut(
          icon: Icons.favorite_border_rounded,
          label: 'Sức khỏe',
          background: const Color(0xFFFBE6EA),
          foreground: AppColors.error,
          onTap: () => context.push(
            '/farms/$farmId/ponds/$pondId/seasons/${season.id}/shrimp-health',
            extra: <String, String>{
              'seasonName': season.name,
              'pondName': season.pond.name,
            },
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _HistoryShortcut(
          svgIcon: AppSvgIconName.harvest,
          label: 'Thu hoạch',
          background: const Color(0xFFE2F6F3),
          foreground: const Color(0xFF0F9B8E),
          onTap: () => _openHarvests(context),
        ),
      ),
    ],
  );

  void _openHarvests(BuildContext context) => context.push(
    '/farms/$farmId/ponds/$pondId/seasons/${season.id}/harvests',
  );

  Widget _harvestShortcut(BuildContext context) => _HistoryShortcut(
    svgIcon: AppSvgIconName.harvest,
    label: 'Lịch sử thu hoạch',
    background: const Color(0xFFE2F6F3),
    foreground: const Color(0xFF0F9B8E),
    onTap: () => _openHarvests(context),
  );

  Widget _costCard() => SeasonMaterialCostCard(costs: season.materialCosts);

  Widget _diseaseCard(BuildContext context) {
    final activeCount = season.activeDiseaseCasesCount ?? 0;
    final hasActive = activeCount > 0;
    return _FeatureCard(
      icon: Icons.health_and_safety_rounded,
      iconBackground: hasActive
          ? const Color(0xFFFBE6EA)
          : const Color(0xFFEEF1F6),
      iconForeground: hasActive ? AppColors.error : const Color(0xFF64748B),
      title: 'Ca bệnh',
      subtitle: 'Theo dõi chẩn đoán và diễn tiến xử lý',
      badges: <Widget>[
        if (hasActive)
          _FeatureBadge(
            dot: true,
            label: '$activeCount đang xử lý',
            background: const Color(0xFFFBE6EA),
            foreground: AppColors.error,
          )
        else
          const _FeatureBadge(
            dot: false,
            label: 'Không có ca mở',
            background: Color(0xFFE2F6F3),
            foreground: Color(0xFF0F9B8E),
          ),
      ],
      onTap: () => context.push(
        Uri(
          path: AppRoutes.diseaseCases,
          queryParameters: {'seasonId': season.id},
        ).toString(),
        extra: '${season.pond.name} · ${season.name}',
      ),
    );
  }

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
    AppNoticeService.success(context, message);
    await ref
        .read(seasonDetailControllerProvider(season.id).notifier)
        .refresh();
  }

  Widget _protocol(BuildContext context) {
    final prodCount =
        season.productionProtocolsCount ??
        (season.approvedProductionProtocol != null ? 1 : 0);
    final treatCount = season.treatmentProtocolsCount ?? 0;
    return _FeatureCard(
      icon: Icons.assignment_rounded,
      iconBackground: const Color(0xFFEAF4FF),
      iconForeground: AppColors.ocean,
      title: 'Phác đồ',
      subtitle: 'Xem kế hoạch nuôi, điều trị và từng cử thực hiện',
      badges: <Widget>[
        _FeatureBadge(
          label: '$prodCount nuôi',
          background: const Color(0xFFEAF4FF),
          foreground: const Color(0xFF0C4E8F),
        ),
        _FeatureBadge(
          label: '$treatCount điều trị',
          background: const Color(0xFFFBE6EA),
          foreground: AppColors.error,
        ),
      ],
      onTap: () => context.push(
        '/protocols?seasonId=${Uri.encodeQueryComponent(season.id)}',
        extra: '${season.pond.name} · ${season.name}',
      ),
    );
  }

  Widget _activationChecklist() {
    final missing = season.activationEligibility?.missingConditions ?? const [];
    final items = <({bool ok, String label})>[
      (
        ok:
            !missing.contains('INITIAL_QUANTITY_REQUIRED') &&
            !missing.contains('INITIAL_DENSITY_REQUIRED'),
        label: 'Số lượng giống và mật độ ban đầu',
      ),
      (
        ok: !missing.contains('ACTIVE_TECHNICIAN_REQUIRED'),
        label:
            'Kỹ thuật viên phụ trách: ${season.personnel?.technician?.account.fullName ?? 'Chưa phân công'}',
      ),
      (
        ok: !missing.contains('ACTIVE_EXPERT_REQUIRED'),
        label:
            'Chuyên gia: ${season.personnel?.expert?.account.fullName ?? 'Chưa phân công'}',
      ),
      (
        ok: !missing.contains('APPROVED_PRODUCTION_PROTOCOL_REQUIRED'),
        label: 'Phác đồ nuôi đã được duyệt',
      ),
      for (final code in missing.where(
        (code) => code.startsWith('FARM_') || code.startsWith('POND_'),
      ))
        (ok: false, label: activationConditionLabel(code)),
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
        GradientButton(
          label: 'Kích hoạt vụ nuôi',
          icon: Icons.check_rounded,
          compact: true,
          isLoading: loading,
          onPressed: loading ? null : () => _activate(context, ref),
        ),
      if (season.canCancel) ...<Widget>[
        if (season.status == SeasonStatus.planning && season.canActivate)
          const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              backgroundColor: Colors.white,
              disabledForegroundColor: AppColors.inkMuted,
              disabledBackgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFE4E7EE)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            onPressed: loading ? null : () => _cancel(context, ref),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Hủy vụ nuôi'),
          ),
        ),
      ],
    ],
  );

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<({DateTime date, String? reason})>(
      context: context,
      builder: (_) => _ActivationDialog(season: season),
    );
    if (confirmed == null || !context.mounted) return;
    try {
      await ref
          .read(seasonMutationControllerProvider.notifier)
          .activate(
            farmId: farmId,
            current: season,
            actualStockingDate: confirmed.date,
            activationDelayReason: confirmed.reason,
          );
      if (!context.mounted) return;
      AppNoticeService.success(
        context,
        'Vụ nuôi đã được kích hoạt và chuyển sang trạng thái đang nuôi.',
      );
    } on Object catch (error) {
      if (context.mounted) {
        if (error is AppException && error.statusCode == 409) {
          ref.invalidate(seasonDetailControllerProvider(season.id));
        }
        AppNoticeService.danger(
          context,
          ErrorMapper.displayMessage(error),
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
    } on Object catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(
          context,
          ErrorMapper.displayMessage(error),
          title: 'Không thể hủy vụ nuôi',
        );
      }
    }
  }
}

class _ActivationDialog extends StatefulWidget {
  const _ActivationDialog({required this.season});

  final AquacultureSeason season;

  @override
  State<_ActivationDialog> createState() => _ActivationDialogState();
}

class _ActivationDialogState extends State<_ActivationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();
  DateTime? _actualDate;
  String? _dateError;

  DateTime? get _plannedDate =>
      widget.season.plannedStockingDate ?? widget.season.stockingDate;

  @override
  void initState() {
    super.initState();
    final today = SeasonRules.vietnamCalendarDate(DateTime.now());
    if (DateUtils.isSameDay(_plannedDate, today)) _actualDate = today;
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _select(DateTime date) => setState(() {
    _actualDate = date;
    _dateError = null;
  });

  Future<void> _selectEarlier(DateTime today) async {
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final candidate = _actualDate ?? _plannedDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: candidate != null && candidate.isBefore(today)
          ? candidate
          : yesterday,
      firstDate: DateTime(1),
      lastDate: yesterday,
      currentDate: today,
      helpText: 'Chọn ngày đã thả thực tế',
    );
    if (selected != null && mounted) _select(selected);
  }

  @override
  Widget build(BuildContext context) {
    final today = SeasonRules.vietnamCalendarDate(DateTime.now());
    final date = _actualDate;
    final delayed = date != null && date.isBefore(today);
    return AppConfirmDialog(
      title: 'Kích hoạt vụ nuôi?',
      description: 'Xác nhận ngày đã thả và kiểm tra số lượng giống.',
      confirmLabel: 'Kích hoạt',
      cancelLabel: 'Chưa thả',
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        final actual = _actualDate;
        final nowDay = SeasonRules.vietnamCalendarDate(DateTime.now());
        if (!DateUtils.isSameDay(today, nowDay)) {
          setState(
            () => _dateError =
                'Đã sang ngày mới. Vui lòng kiểm tra lại ngày thả.',
          );
          return;
        }
        if (actual == null) {
          setState(() => _dateError = 'Vui lòng xác nhận ngày thả thực tế.');
          return;
        }
        final dateError = SeasonRules.validateDateRange(
          actual,
          widget.season.expectedEndDate,
        );
        if (dateError != null) {
          setState(() => _dateError = dateError);
          return;
        }
        if (!_formKey.currentState!.validate()) return;
        Navigator.of(
          context,
        ).pop((date: actual, reason: delayed ? _reason.text.trim() : null));
      },
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F7FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.season.pond.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${seasonIntegerLabel(widget.season.initialQuantity)} con · Dự kiến ${seasonDateLabel(_plannedDate)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ngày thả thực tế',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  selected: date != null && !delayed,
                  onSelected: (_) => _select(today),
                  label: const Text('Thả hôm nay'),
                ),
                ChoiceChip(
                  selected: delayed,
                  onSelected: (_) => _selectEarlier(today),
                  label: const Text('Đã thả ngày trước'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (date != null)
              Text(
                'Đã chọn: ${seasonDateLabel(date)} · DOC ${SeasonRules.cultureDay(date, today)}',
              ),
            if (_dateError != null)
              Text(_dateError!, style: const TextStyle(color: AppColors.error)),
            if (delayed) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _reason,
                maxLength: SeasonRules.activationReasonMaxLength,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Lý do kích hoạt muộn *',
                ),
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Vui lòng nhập lý do kích hoạt muộn.'
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
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
    this.maxLines = 2,
  });
  final String label;
  final String value;
  final bool highlighted;
  final int? maxLines;

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
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
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
    this.icon,
    this.svgIcon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  }) : assert((icon == null) != (svgIcon == null));

  final IconData? icon;
  final AppSvgIconName? svgIcon;
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
              child: Center(
                child: svgIcon != null
                    ? AppSvgIcon(svgIcon!, color: foreground, size: 18)
                    : Icon(icon, color: foreground, size: 18),
              ),
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
  Widget build(BuildContext context) => AppConfirmDialog(
    title: 'Hủy vụ nuôi?',
    description:
        'Vụ nuôi sẽ chuyển sang trạng thái Đã hủy và được giữ lại trong lịch sử. Đây không phải thao tác xóa dữ liệu.',
    confirmLabel: 'Xác nhận hủy',
    level: AppNoticeLevel.danger,
    destructive: true,
    icon: Icons.close_rounded,
    verticalHeader: true,
    separatedActions: true,
    onCancel: () => context.pop(),
    content: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Lý do hủy *',
            style: TextStyle(
              color: AppColors.inkSoft,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _reason,
            autofocus: true,
            minLines: 3,
            maxLines: 4,
            validator: SeasonRules.validateCancellationReason,
            decoration: const InputDecoration(
              hintText: 'Nhập lý do hủy vụ nuôi…',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    ),
    onConfirm: () {
      if (_formKey.currentState!.validate()) {
        context.pop(SeasonRules.normalizeText(_reason.text));
      }
    },
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
          child: AppCircleButton(
            icon: Icons.adaptive.arrow_back,
            tooltip: 'Quay lại',
            onPressed: context.pop,
          ),
        ),
        Expanded(
          child: AppErrorState(message: message, onRetry: onRetry),
        ),
      ],
    ),
  );
}
