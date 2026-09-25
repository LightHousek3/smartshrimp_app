import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
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
        padding: const EdgeInsets.fromLTRB(19, 14, 19, 30),
        children: <Widget>[
          _header(context, mutation.isLoading),
          const SizedBox(height: 18),
          _overview(),
          const SizedBox(height: 13),
          _stockingInformation(),
          const SizedBox(height: 13),
          _personnel(),
          const SizedBox(height: 13),
          _protocol(),
          if (season.status == SeasonStatus.planning) ...<Widget>[
            const SizedBox(height: 13),
            _activationChecklist(),
          ],
          if (season.status == SeasonStatus.cancelled &&
              season.cancellationReason != null) ...<Widget>[
            const SizedBox(height: 13),
            _cancelledReason(),
          ],
          const SizedBox(height: 20),
          _actions(context, ref, mutation.isLoading),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, bool loading) => Row(
    children: <Widget>[
      FarmCircleButton(
        icon: Icons.arrow_back_ios_new_rounded,
        tooltip: 'Quay lại',
        onPressed: loading ? null : context.pop,
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: Text(
          'Chi tiết vụ nuôi',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      if (season.canUpdate)
        FarmCircleButton(
          icon: Icons.edit_outlined,
          tooltip: 'Cập nhật vụ nuôi',
          onPressed: loading
              ? null
              : () => context.push(
                  '/farms/$farmId/ponds/$pondId/seasons/${season.id}/edit',
                  extra: season,
                ),
        ),
    ],
  );

  Widget _overview() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F4FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.waves_rounded, color: AppColors.ocean),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    season.name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${season.pond.farm?.name ?? 'Trang trại'} • ${season.pond.name}',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            SeasonStatusBadge(status: season.status),
          ],
        ),
        if (season.status == SeasonStatus.active &&
            season.dayOfCulture != null) ...<Widget>[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7F4),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              'Ngày nuôi thứ ${season.dayOfCulture}',
              style: const TextStyle(
                color: Color(0xFF087C65),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
        const SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: _DetailMetric(
                label: 'LOẠI TÔM',
                value: shrimpTypeLabel(season.shrimpType),
              ),
            ),
            Expanded(
              child: _DetailMetric(
                label: 'DIỆN TÍCH AO',
                value: '${seasonDecimalLabel(season.pond.areaM2)} m²',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: _DetailMetric(
                label: 'NGÀY THẢ',
                value: seasonDateLabel(season.stockingDate),
              ),
            ),
            Expanded(
              child: _DetailMetric(
                label: 'DỰ KIẾN KẾT THÚC',
                value: seasonDateLabel(season.expectedEndDate),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _stockingInformation() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionTitle(
          icon: Icons.scatter_plot_outlined,
          title: 'Thông tin thả giống',
        ),
        const SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: _DetailMetric(
                label: 'SỐ LƯỢNG',
                value: '${seasonIntegerLabel(season.initialQuantity)} con',
              ),
            ),
            Expanded(
              child: _DetailMetric(
                label: 'KHỐI LƯỢNG TB',
                value:
                    '${seasonDecimalLabel(season.initialAvgWeightG, digits: 3)} g/con',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: _DetailMetric(
                label: 'SINH KHỐI',
                value:
                    '${seasonDecimalLabel(season.initialBiomassKg, digits: 3)} kg',
              ),
            ),
            Expanded(
              child: _DetailMetric(
                label: 'MẬT ĐỘ',
                value:
                    '${seasonDecimalLabel(season.initialDensityPerM2)} con/m²',
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _personnel() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionTitle(
          icon: Icons.groups_2_outlined,
          title: 'Nhân sự phụ trách',
        ),
        const SizedBox(height: 13),
        _PersonRow(
          role: 'Kỹ thuật viên',
          assignment: season.personnel?.technician,
        ),
        const Divider(height: 22),
        _PersonRow(role: 'Chuyên gia', assignment: season.personnel?.expert),
      ],
    ),
  );

  Widget _protocol() {
    final protocol = season.approvedProductionProtocol;
    return SeasonSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(
            icon: Icons.description_outlined,
            title: 'Quy trình nuôi',
          ),
          const SizedBox(height: 12),
          if (protocol == null)
            const Text(
              'Chưa có quy trình nuôi được phê duyệt.',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
            )
          else
            Row(
              children: <Widget>[
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF087C65),
                  size: 20,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        protocol.title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Phiên bản ${protocol.versionNo} • Đã phê duyệt',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _activationChecklist() {
    final eligibility = season.activationEligibility;
    final missing = eligibility?.missingConditions ?? const <String>[];
    return SeasonSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(
            icon: eligibility?.canActivate == true
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            title: eligibility?.canActivate == true
                ? 'Đủ điều kiện kích hoạt'
                : 'Chưa đủ điều kiện kích hoạt',
          ),
          if (missing.isNotEmpty) ...<Widget>[
            const SizedBox(height: 11),
            for (final condition in missing)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        activationConditionLabel(condition),
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _cancelledReason() => SeasonSectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionTitle(icon: Icons.cancel_outlined, title: 'Lý do hủy'),
        const SizedBox(height: 10),
        Text(
          season.cancellationReason!,
          style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
        ),
      ],
    ),
  );

  Widget _actions(BuildContext context, WidgetRef ref, bool loading) => Column(
    children: <Widget>[
      if (season.status == SeasonStatus.planning)
        SizedBox(
          width: double.infinity,
          height: 49,
          child: FilledButton.icon(
            onPressed: !loading && season.canActivate
                ? () => _activate(context, ref)
                : null,
            icon: loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              season.canActivate
                  ? 'Kích hoạt vụ nuôi'
                  : 'Chưa đủ điều kiện kích hoạt',
            ),
          ),
        ),
      if (season.canCancel) ...<Widget>[
        if (season.status == SeasonStatus.planning) const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 47,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: loading ? null : () => _cancel(context, ref),
            icon: const Icon(Icons.cancel_outlined, size: 19),
            label: const Text('Hủy vụ nuôi'),
          ),
        ),
      ],
    ],
  );

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kích hoạt vụ nuôi?'),
        content: const Text(
          'Sau khi kích hoạt, thông tin khởi tạo không thể chỉnh sửa.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Để sau'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            child: const Text('Kích hoạt'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(seasonMutationControllerProvider.notifier)
          .activate(farmId: farmId, current: season);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã kích hoạt vụ nuôi.')));
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
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
          ? ' Đã hủy ${result.cancelledScheduleCount} lịch vận hành.'
          : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã hủy vụ nuôi.$scheduleMessage')),
      );
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(icon, size: 19, color: AppColors.ocean),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.role, required this.assignment});
  final String role;
  final SeasonAssignment? assignment;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE7F4FF),
        child: Icon(
          assignment == null ? Icons.person_add_alt_1 : Icons.person,
          size: 18,
          color: AppColors.ocean,
        ),
      ),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              role,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
            ),
            const SizedBox(height: 2),
            Text(
              assignment?.account.fullName ?? 'Chưa phân công',
              style: TextStyle(
                color: assignment == null ? AppColors.error : AppColors.ink,
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
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Hủy vụ nuôi?'),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Thao tác này không thể hoàn tác. Các lịch vận hành đang chờ sẽ bị hủy.',
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _reason,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            validator: SeasonRules.validateCancellationReason,
            decoration: const InputDecoration(labelText: 'Lý do hủy *'),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(onPressed: context.pop, child: const Text('Quay lại')),
      FilledButton(
        style: FilledButton.styleFrom(backgroundColor: AppColors.error),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.pop(SeasonRules.normalizeText(_reason.text));
          }
        },
        child: const Text('Xác nhận hủy'),
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
            icon: Icons.arrow_back_rounded,
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
