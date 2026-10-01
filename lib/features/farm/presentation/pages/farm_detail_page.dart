import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/destructive_action_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_map_page.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';

const _allPondFilter = Object();

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
            trailing: AppCircleButton(
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
                const SizedBox(height: 16),
                _PondSection(
                  ponds: farm.ponds,
                  onAdd: () => context.push('/farms/${farm.id}/ponds/create'),
                  onOpen: (pond) =>
                      context.push('/farms/${farm.id}/ponds/${pond.id}'),
                ),
                const SizedBox(height: 16),
                DestructiveActionButton(
                  label: 'Xóa trang trại',
                  loading: mutation.isLoading,
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
      AppNoticeService.success(context, 'Đã xóa trang trại.');
      context.pop();
    } on AppException catch (error) {
      if (!context.mounted) return;
      AppNoticeService.danger(context, error.message);
    }
  }

  static void _notInScope(BuildContext context, String feature) {
    AppNoticeService.info(
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

class _PondSection extends StatefulWidget {
  const _PondSection({
    required this.ponds,
    required this.onAdd,
    required this.onOpen,
  });

  final List<FarmPond> ponds;
  final VoidCallback onAdd;
  final ValueChanged<FarmPond> onOpen;

  @override
  State<_PondSection> createState() => _PondSectionState();
}

class _PondSectionState extends State<_PondSection> {
  final _searchController = TextEditingController();
  PondStatus? _status;
  PondType? _type;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final ponds = widget.ponds.where((pond) {
      final matchesName =
          query.isEmpty || pond.name.toLowerCase().contains(query);
      final matchesStatus = _status == null || pond.status == _status;
      final matchesType = _type == null || pond.type == _type;
      return matchesName && matchesStatus && matchesType;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Danh sách ao',
                  style: AppTypography.display(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 36,
                child: TextButton.icon(
                  onPressed: widget.onAdd,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0C4E8F),
                    backgroundColor: const Color(0xFFEAF4FF),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 13),
                  label: const Text(
                    'Thêm ao',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: AppColors.ink, fontSize: 11),
                  decoration: InputDecoration(
                    hintText: 'Tìm ao...',
                    hintStyle: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.inkMuted,
                      size: 14,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 36,
                    ),
                    contentPadding: const EdgeInsets.only(right: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.ocean),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 104,
              child: _PondFilter<PondStatus>(
                label: 'Trạng thái',
                value: _status,
                values: const <PondStatus>[
                  PondStatus.available,
                  PondStatus.maintenance,
                  PondStatus.inactive,
                ],
                text: _pondStatusLabel,
                onChanged: (value) => setState(() => _status = value),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 87,
              child: _PondFilter<PondType>(
                label: 'Loại ao',
                value: _type,
                values: const <PondType>[
                  PondType.aquaculture,
                  PondType.waterTreatment,
                ],
                text: _pondTypeLabel,
                onChanged: (value) => setState(() => _type = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (ponds.isEmpty)
          _EmptyPonds(
            filtered: query.isNotEmpty || _status != null || _type != null,
          )
        else
          ...ponds.map(
            (pond) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PondCard(pond: pond, onTap: () => widget.onOpen(pond)),
            ),
          ),
      ],
    );
  }
}

class _PondFilter<T> extends StatelessWidget {
  const _PondFilter({
    required this.label,
    required this.value,
    required this.values,
    required this.text,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> values;
  final String Function(T) text;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<Object>(
    initialValue: value,
    onSelected: (selected) =>
        onChanged(identical(selected, _allPondFilter) ? null : selected as T),
    itemBuilder: (_) => <PopupMenuEntry<Object>>[
      PopupMenuItem<Object>(
        value: _allPondFilter,
        child: Text('Tất cả $label'),
      ),
      ...values.map(
        (item) => PopupMenuItem<Object>(value: item, child: Text(text(item))),
      ),
    ],
    child: Container(
      key: ValueKey<String>('pond-filter-$label'),
      height: 36,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              value == null ? label : text(value as T),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.inkSoft,
            size: 17,
          ),
        ],
      ),
    ),
  );
}

String _pondStatusLabel(PondStatus status) => switch (status) {
  PondStatus.available => 'Sẵn sàng',
  PondStatus.maintenance => 'Đang bảo trì',
  PondStatus.inactive => 'Ngừng hoạt động',
  PondStatus.unknown => 'Không xác định',
};

String _pondTypeLabel(PondType type) => switch (type) {
  PondType.aquaculture => 'Ao nuôi',
  PondType.waterTreatment => 'Ao xử lý nước',
  PondType.unknown => 'Không xác định',
};

class _PondCard extends StatelessWidget {
  const _PondCard({required this.pond, required this.onTap});
  final FarmPond pond;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = switch (pond.status) {
      PondStatus.available => (
        'Sẵn sàng',
        const Color(0xFFE2F6F3),
        const Color(0xFF0F9B8E),
      ),
      PondStatus.maintenance => (
        'Đang bảo trì',
        const Color(0xFFFBF0DC),
        const Color(0xFFD98314),
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
    final type = _pondTypeLabel(pond.type);
    final isTreatmentPond = pond.type == PondType.waterTreatment;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isTreatmentPond
                      ? const Color(0xFFE2F6F3)
                      : const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  size: 16,
                  color: isTreatmentPond
                      ? const Color(0xFF0F9B8E)
                      : AppColors.ocean,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            pond.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: status.$2,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            status.$1,
                            style: TextStyle(
                              color: status.$3,
                              fontSize: 11,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      <String>[
                        type,
                        if (pond.areaM2 != null)
                          '${formatCompactNumber(pond.areaM2)} m²',
                        if (pond.currentSeason?.dayOfCulture != null)
                          'DOC ${pond.currentSeason!.dayOfCulture}',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
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
  const _EmptyPonds({this.filtered = false});

  final bool filtered;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey<String>('pond-empty-state'),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 180),
    padding: const EdgeInsets.symmetric(vertical: 31, horizontal: 22),
    decoration: BoxDecoration(
      color: const Color(0x66FFFFFF),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFB8C4D3)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.water_drop_outlined,
          color: AppColors.inkMuted,
          size: 30,
        ),
        const SizedBox(height: 10),
        Text(
          filtered ? 'Không tìm thấy ao' : 'Chưa có ao nuôi',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          filtered
              ? 'Hãy thử từ khóa hoặc bộ lọc khác.'
              : 'Thêm ao để bắt đầu quản lý vụ nuôi.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
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
