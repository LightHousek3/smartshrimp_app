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
  final _scrollController = ScrollController();
  bool _loadingMore = false;
  Object? _loadMoreError;
  Timer? _searchDebounce;
  var _searchQuery = '';
  var _showLowStockOnly = false;
  var _statusFilter = InventoryArchiveStatus.all;
  InventoryCategory? _categoryFilter; // null = Tất cả

  InventoryCatalogKey get _catalogKey => (
    farmId: widget.farmId,
    search: _searchQuery,
    category: _categoryFilter,
    lowStockOnly: _showLowStockOnly,
    archiveStatus: _statusFilter,
  );

  void _changeFilters(VoidCallback change) {
    setState(() {
      change();
      _loadingMore = false;
      _loadMoreError = null;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 180 &&
        _loadMoreError == null) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final key = _catalogKey;
    final provider = filteredInventoryListControllerProvider(key);
    if (_loadingMore || ref.read(provider).value?.hasNextPage != true) return;
    setState(() {
      _loadingMore = true;
      _loadMoreError = null;
    });
    try {
      await ref.read(provider.notifier).loadMore();
    } on Object catch (error) {
      if (mounted && key == _catalogKey) setState(() => _loadMoreError = error);
    } finally {
      if (mounted && key == _catalogKey) setState(() => _loadingMore = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
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
      _changeFilters(() => _searchQuery = query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(
      filteredInventoryListControllerProvider(_catalogKey),
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
    final readOnly =
        page?.readOnly == true ||
        page?.items.any((product) => product.readOnly) == true;
    final lowStockCount = page?.summary.lowStockCount ?? 0;
    final inventoryValue = page?.summary.inventoryValue ?? 0;
    final products = page?.items ?? <InventoryProduct>[];

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
            .read(filteredInventoryListControllerProvider(_catalogKey).notifier)
            .refresh(),
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          children: <Widget>[
            if (readOnly) const InventoryReadOnlyNotice(),
            Row(
              children: <Widget>[
                Expanded(
                  child: InventorySummaryCard(
                    value: '${page?.summary.totalProducts ?? 0}',
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
              onStatusChanged: (value) =>
                  _changeFilters(() => _statusFilter = value),
              onCategoryChanged: (value) =>
                  _changeFilters(() => _categoryFilter = value),
              onLowStockChanged: (value) =>
                  _changeFilters(() => _showLowStockOnly = value),
              onReset: () => _changeFilters(() {
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
                      '${page?.totalResults ?? 0} vật tư',
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
                    onPressed: readOnly || page == null
                        ? null
                        : () => context.push(
                            '/farms/${widget.farmId}/inventory/new',
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (page == null)
              inventoryState.hasError
                  ? _InventoryLoadError(
                      message: _errorMessage(inventoryState.error),
                      onRetry: () => ref
                          .read(
                            filteredInventoryListControllerProvider(
                              _catalogKey,
                            ).notifier,
                          )
                          .refresh(),
                    )
                  : const Center(child: CircularProgressIndicator())
            else if (products.isEmpty)
              InventoryEmptyState(
                title:
                    _searchQuery.isEmpty &&
                        _categoryFilter == null &&
                        !_showLowStockOnly
                    ? 'Chưa có vật tư'
                    : 'Không tìm thấy vật tư',
                message:
                    _searchQuery.isEmpty &&
                        _categoryFilter == null &&
                        !_showLowStockOnly
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
            if (page?.hasNextPage == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _loadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: _loadMore,
                        child: Text(
                          _loadMoreError == null
                              ? 'Tải thêm vật tư'
                              : 'Không thể tải thêm. Nhấn để thử lại',
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
