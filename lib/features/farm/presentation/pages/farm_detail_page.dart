import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_feedback.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_map_page.dart';
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
          loading: () => _FarmDetailStatePage(
            title: 'Trang trại',
            onBack: context.pop,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
          ),
          error: (error, _) => _FarmDetailStatePage(
            title: 'Trang trại',
            onBack: context.pop,
            child: _DetailError(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải thông tin trang trại.',
              onRetry: ref
                  .read(farmDetailControllerProvider(farmId).notifier)
                  .refresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _FarmDetailStatePage extends StatelessWidget {
  const _FarmDetailStatePage({
    required this.title,
    required this.onBack,
    required this.child,
  });

  final String title;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      StickyPageHeader(title: title, onBack: onBack),
      SliverFillRemaining(hasScrollBody: false, child: child),
    ],
  );
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
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          StickyPageHeader(
            title: farm.name,
            subtitle: farm.address?.trim().isNotEmpty == true
                ? farm.address
                : 'Chưa cập nhật địa chỉ',
            onBack: context.pop,
            trailing: FarmCircleButton(
              icon: Icons.edit_outlined,
              tooltip: 'Chỉnh sửa trang trại',
              size: 36,
              iconSize: 17,
              onPressed: mutation.isLoading
                  ? null
                  : () => context.push('/farms/${farm.id}/edit', extra: farm),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            sliver: SliverList.list(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _MetricCard(
                        value: formatCompactNumber(farm.totalAreaHectares),
                        label: 'Diện tích',
                        unit: 'ha',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricCard(
                        value: '${farm.pondCount}',
                        label: 'Số ao',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricCard(
                        value: '${farm.activeSeasonCount}',
                        label: 'Đang nuôi',
                      ),
                    ),
                  ],
                ),
                if (farm.address?.trim().isNotEmpty == true ||
                    (farm.latitude != null &&
                        farm.longitude != null)) ...<Widget>[
                  const SizedBox(height: 16),
                  _FarmLocationCard(
                    farm: farm,
                    onOpenMap: farm.latitude == null || farm.longitude == null
                        ? null
                        : () => _openMap(context),
                  ),
                ],
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Kho',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.display(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _InventoryCard(
                  onTap: () => _notInScope(context, 'Chức năng quản lý kho'),
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
                      onPressed: () =>
                          context.push('/farms/${farm.id}/ponds/create'),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Thêm ao',
                        style: TextStyle(fontSize: 12.5),
                      ),
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
                const SizedBox(height: 21),
                FarmActionButton(
                  label: 'Xóa trang trại',
                  icon: Icons.delete_outline_rounded,
                  destructive: true,
                  enabled: !mutation.isLoading,
                  onPressed: () => _deleteFarm(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openMap(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => FarmMapPage(
          latitude: farm.latitude!,
          longitude: farm.longitude!,
          farmName: farm.name,
        ),
      ),
    );
  }

  Future<void> _deleteFarm(BuildContext context, WidgetRef ref) async {
    final confirmed = await showAppConfirmDialog(
      context,
      entityLabel: 'trang trại',
      entityName: farm.name,
      retentionMessage:
          'Trang trại sẽ không còn xuất hiện trong vận hành. Dữ liệu lịch sử vẫn được giữ lại để truy vết.',
      blockers: farm.canDelete
          ? const <String>[]
          : <String>[
              '${farm.activeSeasonCount} vụ nuôi đang ở trạng thái chuẩn bị hoặc đang nuôi.',
            ],
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref
          .read(farmMutationControllerProvider.notifier)
          .deleteFarm(farm.id);
      if (!context.mounted) return;
      AppFeedback.success(context, 'Đã xóa trang trại.');
      context.pop();
    } on AppException catch (error) {
      if (!context.mounted) return;
      AppFeedback.danger(context, error.message);
    }
  }

  static void _notInScope(BuildContext context, String feature) {
    AppFeedback.info(
      context,
      '$feature sẽ được hoàn thiện ở hạng mục tương ứng.',
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label, this.unit});
  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) => Container(
    height: 72,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xCCFFFFFF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
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
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.display(
                  color: label == 'Đang nuôi'
                      ? const Color(0xFF0B9A8A)
                      : AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit ?? '',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _FarmLocationCard extends StatelessWidget {
  const _FarmLocationCard({required this.farm, required this.onOpenMap});

  final Farm farm;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x16000000),
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Vị trí trang trại',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.display(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (farm.address?.trim().isNotEmpty == true) ...<Widget>[
          const SizedBox(height: 12),
          _LocationInfoRow(
            icon: Icons.location_on_outlined,
            color: const Color(0xFF1D7AD6),
            label: 'Địa chỉ',
            value: farm.address!,
          ),
        ],
        if (farm.latitude != null && farm.longitude != null) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _LocationInfoRow(
                  icon: Icons.location_on_outlined,
                  color: const Color(0xFF0B9A8A),
                  label: 'Tọa độ GPS',
                  value:
                      '${farm.latitude!.toStringAsFixed(4)}, ${farm.longitude!.toStringAsFixed(4)}',
                  monospaced: true,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: onOpenMap,
                  style: FilledButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    backgroundColor: const Color(0xFFEAF4FF),
                    foregroundColor: const Color(0xFF0C4E8F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Mở bản đồ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _LocationInfoRow extends StatelessWidget {
  const _LocationInfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.monospaced = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool monospaced;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, size: 15, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: monospaced
                  ? AppTypography.mono(
                      color: AppColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  : const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ],
        ),
      ),
    ],
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
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF2EDFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF7455D9),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Kho vật tư',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
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
  const _DetailError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(21),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
