import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';

class FarmDetailPage extends ConsumerWidget {
  const FarmDetailPage({required this.farmId, super.key});

  final String farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(farmDetailControllerProvider(farmId));
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: state.when(
          data: (farm) => _FarmDetailContent(farm: farm),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => _DetailError(
            message: error is AppException
                ? error.message
                : 'Không thể tải thông tin trang trại.',
            onBack: context.pop,
            onRetry: ref
                .read(farmDetailControllerProvider(farmId).notifier)
                .refresh,
          ),
        ),
      ),
    );
  }
}

class _FarmDetailContent extends ConsumerWidget {
  const _FarmDetailContent({required this.farm});
  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = ref.watch(farmMutationControllerProvider);
    return RefreshIndicator(
      color: AppColors.ocean,
      onRefresh: ref
          .read(farmDetailControllerProvider(farm.id).notifier)
          .refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(21, 18, 21, 28),
        children: <Widget>[
          Row(
            children: <Widget>[
              FarmCircleButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Quay lại',
                onPressed: context.pop,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      farm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      farm.address?.trim().isNotEmpty == true
                          ? farm.address!
                          : 'Chưa cập nhật địa chỉ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              FarmCircleButton(
                icon: Icons.edit_outlined,
                tooltip: 'Chỉnh sửa trang trại',
                onPressed: mutation.isLoading
                    ? null
                    : () => context.push('/farms/${farm.id}/edit', extra: farm),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  icon: Icons.straighten_rounded,
                  value: formatCompactNumber(farm.totalAreaHectares),
                  label: 'Tổng diện tích',
                  unit: 'ha',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.water_drop_outlined,
                  value: '${farm.pondCount}',
                  label: 'Số ao',
                  unit: 'ao',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.autorenew_rounded,
                  value: '${farm.activeSeasonCount}',
                  label: 'Đang nuôi',
                  unit: 'vụ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Danh sách ao (${farm.ponds.length})',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/farms/${farm.id}/ponds/create'),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Thêm ao', style: TextStyle(fontSize: 12.5)),
              ),
            ],
          ),
          const SizedBox(height: 9),
          if (farm.ponds.isEmpty)
            const _EmptyPonds()
          else
            ...farm.ponds.map(
              (pond) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: _PondCard(
                  pond: pond,
                  onTap: () =>
                      context.push('/farms/${farm.id}/ponds/${pond.id}'),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.push('/farms/${farm.id}/ponds'),
              icon: const Icon(Icons.manage_search_rounded),
              label: const Text('Tìm kiếm và lọc ao'),
            ),
          ),
          const SizedBox(height: 7),
          _InventoryCard(
            onTap: () => _notInScope(context, 'Chức năng quản lý kho'),
          ),
          const SizedBox(height: 21),
          if (farm.isArchived)
            FarmActionButton(
              label: 'Khôi phục trang trại',
              icon: Icons.restore_rounded,
              restore: true,
              enabled: !mutation.isLoading,
              onPressed: () =>
                  _changeArchiveStatus(context, ref, restore: true),
            )
          else
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
                onPressed: farm.canArchive && !mutation.isLoading
                    ? () => _changeArchiveStatus(context, ref, restore: false)
                    : null,
                child: Text(
                  farm.canArchive
                      ? 'Lưu trữ trang trại'
                      : 'Không thể lưu trữ khi có vụ đang mở',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _changeArchiveStatus(
    BuildContext context,
    WidgetRef ref, {
    required bool restore,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(restore ? 'Khôi phục trang trại?' : 'Lưu trữ trang trại?'),
        content: Text(
          restore
              ? 'Trang trại sẽ xuất hiện lại trong danh sách đang hoạt động.'
              : 'Bạn có thể khôi phục trang trại này bất cứ lúc nào.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            child: Text(restore ? 'Khôi phục' : 'Lưu trữ'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      if (restore) {
        await ref
            .read(farmMutationControllerProvider.notifier)
            .restore(farm.id);
      } else {
        await ref
            .read(farmMutationControllerProvider.notifier)
            .archive(farm.id);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            restore ? 'Đã khôi phục trang trại.' : 'Đã lưu trữ trang trại.',
          ),
        ),
      );
      context.pop();
    } on AppException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  static void _notInScope(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature sẽ được hoàn thiện ở hạng mục tương ứng.'),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.unit,
  });
  final IconData icon;
  final String value;
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) => Container(
    height: 93,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xF2FFFFFF),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: Colors.white),
      boxShadow: farmCardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(icon, size: 19, color: AppColors.ocean),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 9.5),
        ),
      ],
    ),
  );
}

class _PondCard extends StatelessWidget {
  const _PondCard({required this.pond, required this.onTap});
  final FarmPond pond;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = switch (pond.status) {
      PondStatus.available => (
        'Sẵn sàng',
        const Color(0xFFE8F7EF),
        const Color(0xFF07864B),
      ),
      PondStatus.maintenance => (
        'Đang bảo trì',
        const Color(0xFFFFF0D9),
        const Color(0xFFB66A00),
      ),
      PondStatus.inactive => (
        'Ngừng hoạt động',
        const Color(0xFFF0F1F4),
        AppColors.inkMuted,
      ),
      PondStatus.unknown => (
        'Không xác định',
        const Color(0xFFF0F1F4),
        AppColors.inkMuted,
      ),
    };
    final type = switch (pond.type) {
      PondType.aquaculture => 'Ao nuôi',
      PondType.waterTreatment => 'Ao xử lý nước',
      PondType.unknown => 'Loại ao chưa xác định',
    };
    return Material(
      color: const Color(0xF7FFFFFF),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 14, 13, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white),
            boxShadow: farmCardShadow,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  size: 21,
                  color: AppColors.ocean,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            pond.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: status.$2,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            status.$1,
                            style: TextStyle(
                              color: status.$3,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      children: <Widget>[
                        Text(
                          type,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 10.5,
                          ),
                        ),
                        if (pond.areaM2 != null)
                          Text(
                            '• ${formatCompactNumber(pond.areaM2)} m²',
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 10.5,
                            ),
                          ),
                        if (pond.currentSeason?.dayOfCulture != null)
                          Text(
                            'DOC ${pond.currentSeason!.dayOfCulture}',
                            style: const TextStyle(
                              color: AppColors.ocean,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPonds extends StatelessWidget {
  const _EmptyPonds();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 31, horizontal: 22),
    decoration: BoxDecoration(
      color: const Color(0x66FFFFFF),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFB8C4D3)),
    ),
    child: const Column(
      children: <Widget>[
        Icon(Icons.water_drop_outlined, color: AppColors.inkMuted, size: 30),
        SizedBox(height: 10),
        Text(
          'Chưa có ao nuôi',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Thêm ao để bắt đầu quản lý vụ nuôi.',
          style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
        ),
      ],
    ),
  );
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xF7FFFFFF),
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white),
          boxShadow: farmCardShadow,
        ),
        child: const Row(
          children: <Widget>[
            Icon(Icons.inventory_2_outlined, color: AppColors.ocean, size: 21),
            SizedBox(width: 11),
            Expanded(
              child: Text(
                'Quản lý kho',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.inkMuted,
              size: 20,
            ),
          ],
        ),
      ),
    ),
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
    padding: const EdgeInsets.all(21),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FarmCircleButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Quay lại',
          onPressed: onBack,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.inkMuted,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
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
