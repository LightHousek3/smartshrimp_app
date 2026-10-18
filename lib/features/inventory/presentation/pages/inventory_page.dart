import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({required this.farmId, this.farmName, super.key});

  final String farmId;
  final String? farmName;

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  static const _searchDelay = Duration(milliseconds: 350);

  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  var _searchQuery = '';
  var _showLowStockOnly = false;
  var _showArchived = false;
  InventoryCategory? _categoryFilter; // null = Tất cả

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    final query = _searchController.text.trim().toLowerCase();
    if (query == _searchQuery) return;
    _searchDebounce = Timer(_searchDelay, () {
      if (!mounted) return;
      setState(() => _searchQuery = query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(
      inventoryListControllerProvider(widget.farmId),
    );
    final page = inventoryState.value;
    if (page == null) {
      return InventoryPageFrame(
        title: 'Kho vật tư',
        trailing: _supplierButton(context),
        onBack: context.pop,
        child: Center(
          child: inventoryState.hasError
              ? _InventoryLoadError(
                  message: _errorMessage(inventoryState.error),
                  onRetry: () => ref
                      .read(
                        inventoryListControllerProvider(widget.farmId).notifier,
                      )
                      .refresh(),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }
    final query = _searchQuery;
    final sourceProducts = page.items
        .where((product) => product.isArchived == _showArchived)
        .toList(growable: false);
    final lowStockCount = sourceProducts
        .where((product) => product.isLowStock)
        .length;
    final inventoryValue = sourceProducts.fold<double>(
      0,
      (total, product) => total + product.inventoryValue,
    );
    final products = sourceProducts
        .where((product) {
          final matchesSearch =
              query.isEmpty ||
              product.name.toLowerCase().contains(query) ||
              product.category.label.toLowerCase().contains(query);
          final matchesCategory =
              _categoryFilter == null || product.category == _categoryFilter;
          return matchesSearch &&
              (!_showLowStockOnly || product.isLowStock) &&
              matchesCategory;
        })
        .toList(growable: false);

    return InventoryPageFrame(
      title: 'Kho vật tư',
      trailing: _supplierButton(context),
      onBack: context.pop,
      stackChildren: <Widget>[
        Positioned(
          right: 16,
          bottom: 30,
          child: _HistoryButton(
            onPressed: () =>
                context.push('/farms/${widget.farmId}/inventory/history'),
          ),
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () => ref
            .read(inventoryListControllerProvider(widget.farmId).notifier)
            .refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          children: <Widget>[
            _FarmContext(farmId: widget.farmId, farmName: widget.farmName),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _InventoryStat(
                    value: '${sourceProducts.length}',
                    label: 'Vật tư',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InventoryStat(
                    value: '$lowStockCount',
                    label: 'Sắp hết',
                    alert: lowStockCount > 0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InventoryStat(
                    value: formatInventoryMoney(inventoryValue),
                    label: 'Giá trị tồn',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InventorySearch(controller: _searchController),
            const SizedBox(height: 10),
            _CategoryFilterBar(
              selected: _categoryFilter,
              onChanged: (cat) => setState(() => _categoryFilter = cat),
            ),
            const SizedBox(height: 10),
            _ArchiveToggle(
              showArchived: _showArchived,
              onChanged: (value) => setState(() {
                _showArchived = value;
                if (value) _showLowStockOnly = false;
              }),
            ),
            const SizedBox(height: 10),
            _StockSegmentedControl(
              totalCount: sourceProducts.length,
              lowStockCount: lowStockCount,
              showLowStockOnly: _showLowStockOnly,
              enabled: !_showArchived,
              onChanged: (value) => setState(() => _showLowStockOnly = value),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${products.length} sản phẩm',
                      style: AppTypography.display(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  _AddProductButton(
                    onPressed: () =>
                        context.push('/farms/${widget.farmId}/inventory/new'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (products.isEmpty)
              const _EmptyProducts()
            else
              ...products.indexed.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.$1 == products.length - 1 ? 0 : 10,
                  ),
                  child: _ProductCard(
                    product: entry.$2,
                    onTap: () => context.push(
                      '/farms/${widget.farmId}/inventory/${entry.$2.id}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _supplierButton(BuildContext context) => TextButton.icon(
    onPressed: () =>
        context.push('/farms/${widget.farmId}/inventory/suppliers'),
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      minimumSize: const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    icon: const Icon(Icons.storefront_outlined, size: 18),
    label: const Text(
      'Nhà cung cấp',
      style: TextStyle(fontSize: 12, color: Colors.black),
    ),
  );
}

// ---------------------------------------------------------------------------
// Current farm context
// ---------------------------------------------------------------------------

class _FarmContext extends ConsumerWidget {
  const _FarmContext({required this.farmId, required this.farmName});

  final String farmId;
  final String? farmName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliedName = farmName?.trim();
    // Route extras are optional (for example on a direct link or app restore).
    // Resolve missing names by this farm's ID, never from a global selection.
    final nameState = suppliedName != null && suppliedName.isNotEmpty
        ? AsyncData(suppliedName)
        : ref
              .watch(farmDetailControllerProvider(farmId))
              .whenData((farm) => farm.name);
    return Semantics(
      label: 'Trang trại hiện tại',
      child: Container(
        height: 41,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: <Widget>[
              const InventorySvgIcon(InventoryAssets.building, size: 15),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  nameState.when(
                    data: (name) => name,
                    loading: () => 'Đang tải tên trang trại...',
                    error: (error, _) => error is AppException
                        ? error.message
                        : 'Không thể tải tên trang trại.',
                  ),
                  style: AppTypography.display(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (nameState.hasError)
                IconButton(
                  tooltip: 'Tải lại tên trang trại',
                  onPressed: () =>
                      ref.invalidate(farmDetailControllerProvider(farmId)),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat Card
// ---------------------------------------------------------------------------

class _InventoryStat extends StatelessWidget {
  const _InventoryStat({
    required this.value,
    required this.label,
    this.alert = false,
  });

  final String value;
  final String label;
  final bool alert;

  @override
  Widget build(BuildContext context) => Container(
    height: 61,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xCCFFFFFF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.display(
              color: alert ? AppColors.error : AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label.toUpperCase(),
          maxLines: 1,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: .22,
            height: 1.2,
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Search Bar
// ---------------------------------------------------------------------------

class _InventorySearch extends StatelessWidget {
  const _InventorySearch({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: TextField(
      controller: controller,
      style: inventoryInputTextStyle,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.search,
      decoration:
          inventoryInputDecoration(
            hintText: 'Tìm theo tên vật tư…',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ).copyWith(
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            prefixIcon: const SizedBox.square(
              dimension: 48,
              child: Center(
                child: InventorySvgIcon(InventoryAssets.search, size: 18),
              ),
            ),
          ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Category filter horizontal tabs
// ---------------------------------------------------------------------------

class _CategoryFilterBar extends StatefulWidget {
  const _CategoryFilterBar({required this.selected, required this.onChanged});

  final InventoryCategory? selected;
  final ValueChanged<InventoryCategory?> onChanged;

  @override
  State<_CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<_CategoryFilterBar> {
  final _scrollController = ScrollController();
  var _canScrollBack = false;
  var _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() => _updateAvailability(_scrollController.position);

  void _updateAvailability(ScrollMetrics metrics) {
    final back = metrics.extentBefore > 1;
    final forward = metrics.extentAfter > 1;
    if (back == _canScrollBack && forward == _canScrollForward) return;
    setState(() {
      _canScrollBack = back;
      _canScrollForward = forward;
    });
  }

  void _scroll(int direction) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    unawaited(
      _scrollController.animateTo(
        (position.pixels + direction * position.viewportDimension * 0.75).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: Row(
      children: [
        SizedBox(
          width: 28,
          child: IconButton(
            tooltip: 'Danh mục trước',
            padding: EdgeInsets.zero,
            iconSize: 20,
            color: AppColors.ocean,
            onPressed: _canScrollBack ? () => _scroll(-1) : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollMetricsNotification>(
            onNotification: (notification) {
              _updateAvailability(notification.metrics);
              return false;
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  ...ScrollConfiguration.of(context).dragDevices,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView(
                key: const ValueKey('inventory-category-filters'),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: <Widget>[
                  _CategoryChip(
                    label: 'Tất cả',
                    selected: widget.selected == null,
                    foreground: AppColors.ocean,
                    background: const Color(0xFFEAF4FF),
                    onTap: () => widget.onChanged(null),
                  ),
                  ...InventoryCategory.values
                      .where(
                        (category) => category != InventoryCategory.unknown,
                      )
                      .map(
                        (cat) => Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: _CategoryChip(
                            label: cat.label,
                            selected: widget.selected == cat,
                            foreground: cat.foreground,
                            background: cat.background,
                            onTap: () => widget.onChanged(cat),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 28,
          child: IconButton(
            tooltip: 'Danh mục tiếp theo',
            padding: EdgeInsets.zero,
            iconSize: 20,
            color: AppColors.ocean,
            onPressed: _canScrollForward ? () => _scroll(1) : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ),
      ],
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? background : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? foreground.withValues(alpha: 0.5) : AppColors.line,
          width: selected ? 1.2 : 1,
        ),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? foreground : AppColors.inkMuted,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    ),
  );
}

class _ArchiveToggle extends StatelessWidget {
  const _ArchiveToggle({required this.showArchived, required this.onChanged});

  final bool showArchived;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Trạng thái vật tư',
        style: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: <Widget>[
          InventoryFilterChip(
            label: 'Đang dùng',
            selected: !showArchived,
            onSelected: (_) => onChanged(false),
          ),
          InventoryFilterChip(
            label: 'Đã lưu trữ',
            selected: showArchived,
            onSelected: (_) => onChanged(true),
          ),
        ],
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Segmented Control (Tất cả / Sắp hết)
// ---------------------------------------------------------------------------

class _StockSegmentedControl extends StatelessWidget {
  const _StockSegmentedControl({
    required this.totalCount,
    required this.lowStockCount,
    required this.showLowStockOnly,
    required this.enabled,
    required this.onChanged,
  });

  final int totalCount;
  final int lowStockCount;
  final bool showLowStockOnly;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xB3D3E8FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: _SegmentButton(
            label: 'Tất cả ($totalCount)',
            selected: !showLowStockOnly,
            onTap: enabled ? () => onChanged(false) : () {},
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _SegmentButton(
            label: 'Sắp hết ($lowStockCount)',
            selected: showLowStockOnly,
            onTap: enabled ? () => onChanged(true) : () {},
          ),
        ),
      ],
    ),
  );
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFF1D7AD6) : const Color(0x8CFFFFFF),
    borderRadius: BorderRadius.circular(12),
    elevation: selected ? 1 : 0,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.inkSoft,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Add Product Button
// ---------------------------------------------------------------------------

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Thêm vật tư mới',
    child: Material(
      color: const Color(0xFFEAF4FF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          height: 36,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: <Widget>[
                InventorySvgIcon(InventoryAssets.add, size: 13),
                SizedBox(width: 4),
                Text(
                  'Thêm vật tư',
                  style: TextStyle(
                    color: Color(0xFF0C4E8F),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Product Card
// ---------------------------------------------------------------------------

String _categoryIconAsset(InventoryCategory cat) => switch (cat) {
  InventoryCategory.medicine => InventoryAssets.medicine,
  _ => InventoryAssets.inventoryBox,
};

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final InventoryProductViewData product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: product.name,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: const Color(0x16000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              // Product photos take the place of the category icon when present.
              if (product.effectiveImageUrls.isNotEmpty)
                InventoryProductImage(
                  url: product.effectiveImageUrls.first,
                  size: 48,
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: product.category.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: InventorySvgIcon(
                      _categoryIconAsset(product.category),
                      size: 18,
                      colorFilter: ColorFilter.mode(
                        product.category.foreground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.display(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: <Widget>[
                        InventoryCategoryBadge(category: product.category),
                        if (product.isLowStock) const LowStockBadge(),
                        if (product.isArchived)
                          const Chip(label: Text('Đã lưu trữ')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text:
                                '${formatInventoryQuantity(product.currentStock)} ${product.unit.label}',
                            style: TextStyle(
                              color: product.isLowStock
                                  ? AppColors.error
                                  : const Color(0xFF0F9B8E),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' / ngưỡng ${formatInventoryQuantity(product.minAlertQuantity)} ${product.alertUnitLabel}',
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${product.activeLotCount} lô còn hàng · Giá trị tồn ${formatInventoryMoney(product.inventoryValue)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const InventorySvgIcon(InventoryAssets.chevronRight, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// History FAB
// ---------------------------------------------------------------------------

class _HistoryButton extends StatelessWidget {
  const _HistoryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Lịch sử giao dịch kho',
    child: Material(
      color: const Color(0xFF1D7AD6),
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: const Color(0x330F62B4),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox.square(
          dimension: 52,
          child: Center(
            child: InventorySvgIcon(InventoryAssets.history, size: 21),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) => const InventorySurface(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          InventorySvgIcon(InventoryAssets.inventoryBox, size: 30),
          SizedBox(height: 10),
          Text(
            'Không tìm thấy vật tư',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Hãy thử tên hoặc bộ lọc khác.',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _InventoryLoadError extends StatelessWidget {
  const _InventoryLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.error_outline, color: AppColors.error, size: 36),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

String _errorMessage(Object? error) => error is AppException
    ? error.message
    : 'Không thể tải dữ liệu kho. Vui lòng thử lại.';
