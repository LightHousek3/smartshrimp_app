import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_list_page.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';

class PondDetailPage extends ConsumerWidget {
  const PondDetailPage({required this.farmId, required this.pondId, super.key});
  final String farmId;
  final String pondId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = (farmId: farmId, pondId: pondId);
    final state = ref.watch(pondDetailControllerProvider(ids));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: state.when(
            data: (pond) => _PondDetailContent(pond: pond),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (error, _) => _DetailError(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải chi tiết ao.',
              onRetry: ref
                  .read(pondDetailControllerProvider(ids).notifier)
                  .refresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _PondDetailContent extends ConsumerWidget {
  const _PondDetailContent({required this.pond});
  final Pond pond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = ref.watch(pondMutationControllerProvider(pond.farmId));
    final ids = (farmId: pond.farmId, pondId: pond.id);
    return RefreshIndicator(
      color: AppColors.ocean,
      onRefresh: ref.read(pondDetailControllerProvider(ids).notifier).refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        children: <Widget>[
          Row(
            children: <Widget>[
              FarmCircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                tooltip: 'Quay lại',
                onPressed: context.pop,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pond.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pond.farm?.name ?? 'Trang trại',
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              FarmCircleButton(
                icon: Icons.edit_outlined,
                tooltip: 'Chỉnh sửa ao',
                onPressed: mutation.isLoading
                    ? null
                    : () => context.push(
                        '/farms/${pond.farmId}/ponds/${pond.id}/edit',
                        extra: pond,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _PondSummaryCard(pond: pond),
          const SizedBox(height: 18),
          _SeasonManagementCard(pond: pond),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: mutation.isLoading || pond.hasOpenSeason
                  ? null
                  : () => _delete(context, ref),
              child: Text(
                pond.hasOpenSeason
                    ? 'Không thể xóa khi có vụ đang mở'
                    : 'Xóa ao',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa ao?'),
        content: const Text(
          'Ao sẽ bị xóa khỏi hệ thống và không thể khôi phục. Dữ liệu lịch sử vẫn được giữ nguyên.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final notifier = ref.read(
        pondMutationControllerProvider(pond.farmId).notifier,
      );
      await notifier.delete(pond.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã xóa ao.')));
        context.go('/farms/${pond.farmId}/ponds');
      }
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
}

class _SeasonManagementCard extends StatelessWidget {
  const _SeasonManagementCard({required this.pond});

  final Pond pond;

  @override
  Widget build(BuildContext context) {
    final current = pond.currentSeason;
    final canCreate =
        !pond.isArchived &&
        !pond.hasOpenSeason &&
        pond.type == PondType.aquaculture &&
        pond.status == PondStatus.available;
    final basePath = '/farms/${pond.farmId}/ponds/${pond.id}/seasons';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xF8FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
        boxShadow: farmCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.waves_rounded, color: AppColors.ocean, size: 20),
              SizedBox(width: 8),
              Text(
                'Vụ nuôi',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (current == null)
            const Text(
              'Ao chưa có vụ nuôi đang mở.',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
            )
          else
            Material(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => context.push('$basePath/${current.id}'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              current.status == PondSeasonStatus.active
                                  ? 'Vụ nuôi đang hoạt động'
                                  : 'Vụ nuôi đang chuẩn bị',
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              current.stockingDate == null
                                  ? 'Chưa cập nhật ngày thả giống'
                                  : 'Ngày thả: ${_formatDate(current.stockingDate!)}',
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.ocean,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(basePath),
                  icon: const Icon(Icons.history_rounded, size: 18),
                  label: const Text('Lịch sử'),
                ),
              ),
              if (canCreate) ...<Widget>[
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.push('$basePath/create', extra: pond),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tạo vụ'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

class _PondSummaryCard extends StatelessWidget {
  const _PondSummaryCard({required this.pond});
  final Pond pond;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xF8FFFFFF),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white),
      boxShadow: farmCardShadow,
    ),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _metric('DIỆN TÍCH', pond.areaM2, 'm²')),
            Expanded(child: _metric('ĐỘ SÂU', pond.depthM, 'm')),
          ],
        ),
        const SizedBox(height: 17),
        Row(
          children: <Widget>[
            Expanded(child: _metric('THỂ TÍCH', pond.volumeM3, 'm³')),
            Expanded(child: _textMetric('LOẠI AO', pondTypeLabel(pond.type))),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            const Text(
              'Trạng thái:',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F7F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pondStatusLabel(pond.status),
                style: const TextStyle(
                  color: Color(0xFF07866C),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _metric(String label, double? value, String unit) =>
      _textMetric(label, '${formatCompactNumber(value)} $unit');

  Widget _textMetric(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9,
          letterSpacing: .2,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
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
                Text(message, textAlign: TextAlign.center),
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
