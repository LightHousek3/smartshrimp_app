import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'dart:async';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_catalog_filters.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_empty_state.dart';

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

/// Show the selected farm catalog with combined filters and stock summaries.
/// Resolve farm context by route ID, including direct links without extras.
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
  var _statusFilter = InventoryArchiveStatus.all;
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
    final suppliedName = widget.farmName?.trim();
    final farmName = suppliedName != null && suppliedName.isNotEmpty
        ? suppliedName
        : ref
              .watch(farmDetailControllerProvider(widget.farmId))
              .when(
                data: (farm) => farm.name,
                loading: () => 'Đang tải tên trang trại…',
                error: (_, _) => 'Không thể tải tên trang trại',
              );
    final page = inventoryState.value;
    if (page == null) {
      return InventoryPageFrame(
        title: 'Kho vật tư',
        subtitle: farmName,
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
    final readOnly =
        page.readOnly || page.items.any((product) => product.readOnly);
    final query = _searchQuery;
    final sourceProducts = page.items
        .where(
          (product) =>
              _statusFilter == InventoryArchiveStatus.all ||
              product.isArchived ==
                  (_statusFilter == InventoryArchiveStatus.archived),
        )
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
      subtitle: farmName,
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
            if (readOnly) const InventoryReadOnlyNotice(),
            Row(
              children: <Widget>[
                Expanded(
                  child: InventorySummaryCard(
                    value: '${sourceProducts.length}',
                    label: 'Vật tư',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InventorySummaryCard(
                    value: '$lowStockCount',
                    label: 'Sắp hết',
                    alert: lowStockCount > 0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InventorySummaryCard(
                    value: formatInventoryCompactMoney(inventoryValue),
                    label: 'Giá trị tồn',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InventoryDirectorySearch(
              hint: 'Tìm tên vật tư…',
              controller: _searchController,
            ),
            const SizedBox(height: 10),
            InventoryCatalogFilters(
              status: _statusFilter,
              category: _categoryFilter,
              lowStockOnly: _showLowStockOnly,
              lowStockCount: lowStockCount,
              onStatusChanged: (value) => setState(() => _statusFilter = value),
              onCategoryChanged: (value) =>
                  setState(() => _categoryFilter = value),
              onLowStockChanged: (value) =>
                  setState(() => _showLowStockOnly = value),
              onReset: () => setState(() {
                _statusFilter = InventoryArchiveStatus.all;
                _categoryFilter = null;
                _showLowStockOnly = false;
              }),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${products.length} vật tư',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  InventorySoftButton(
                    label: 'Thêm vật tư',
                    asset: InventoryAssets.catalogAdd,
                    onPressed: readOnly
                        ? null
                        : () => context.push(
                            '/farms/${widget.farmId}/inventory/new',
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (products.isEmpty)
              InventoryEmptyState(
                title: page.items.isEmpty
                    ? 'Chưa có vật tư'
                    : 'Không tìm thấy vật tư',
                message: page.items.isEmpty
                    ? 'Thêm vật tư để bắt đầu quản lý kho của trang trại.'
                    : 'Hãy thử tên hoặc bộ lọc khác.',
              )
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

  Widget _supplierButton(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360
      ? IconButton(
          tooltip: 'Nhà cung cấp',
          onPressed: () =>
              context.push('/farms/${widget.farmId}/inventory/suppliers'),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.ink,
            minimumSize: const Size(40, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const InventorySvgIcon(
            InventoryAssets.catalogSupplier,
            size: 17,
          ),
        )
      : TextButton.icon(
          onPressed: () =>
              context.push('/farms/${widget.farmId}/inventory/suppliers'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.ocean,
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.ocean),
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const InventorySvgIcon(
            InventoryAssets.catalogSupplier,
            size: 17,
          ),
          label: const Text(
            'Nhà cung cấp',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: AppColors.ocean,
            ),
          ),
        );
}

// ---------------------------------------------------------------------------
// Product Card
// ---------------------------------------------------------------------------

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
              InventoryProductImage(
                url: product.effectiveImageUrls.firstOrNull,
                size: product.effectiveImageUrls.isEmpty ? 40 : 48,
                category: product.category,
                isArchived: product.isArchived,
                isLowStock: product.isLowStock,
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
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: AppColors.ink,
                        fontSize: 13,
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
                          const InventoryLabelBadge(label: 'Ngừng sử dụng'),
                        if (product.compliance?.complianceStatus != 'reviewed')
                          InventoryLabelBadge(
                            label: product.readOnly
                                ? 'Chưa đối chiếu hồ sơ'
                                : product.compliance?.complianceStatus ==
                                      'blocked'
                                ? 'Hồ sơ bị chặn'
                                : 'Hồ sơ nháp',
                            foreground:
                                product.compliance?.complianceStatus ==
                                    'blocked'
                                ? AppColors.error
                                : const Color(0xFFD97706),
                            background:
                                product.compliance?.complianceStatus ==
                                    'blocked'
                                ? const Color(0xFFFBE6EA)
                                : const Color(0xFFFFF1DC),
                          ),
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
                      '${product.activeLotCount} lô còn hàng · Giá trị tồn ${formatInventoryCompactMoney(product.inventoryValue)}',
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
              const InventorySvgIcon(InventoryAssets.catalogChevron, size: 16),
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
            child: InventorySvgIcon(InventoryAssets.catalogHistory, size: 21),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

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
