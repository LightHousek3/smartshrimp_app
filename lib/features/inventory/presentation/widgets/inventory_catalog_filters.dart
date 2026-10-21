import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Controlled status/category selectors and a separate low-stock toggle.
class InventoryCatalogFilters extends StatelessWidget {
  const InventoryCatalogFilters({
    required this.status,
    required this.category,
    required this.lowStockOnly,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onLowStockChanged,
    required this.onReset,
    this.lowStockCount = 0,
    super.key,
  });
  final InventoryArchiveStatus status;
  final InventoryCategory? category;
  final bool lowStockOnly;
  final int lowStockCount;
  final ValueChanged<InventoryArchiveStatus> onStatusChanged;
  final ValueChanged<InventoryCategory?> onCategoryChanged;
  final ValueChanged<bool> onLowStockChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final narrow =
          constraints.maxWidth < 320 ||
          MediaQuery.textScalerOf(context).scale(11) > 15;
      final scaledHeight =
          MediaQuery.textScalerOf(context).scale(11) * 1.5 + 22;
      final controlHeight = scaledHeight > 40 ? scaledHeight : 40.0;
      final controlWidth =
          (constraints.maxWidth - (narrow ? 8 : 16)) / (narrow ? 2 : 3);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: controlWidth,
                height: controlHeight,
                child: InventoryDirectoryFilter<InventoryArchiveStatus>(
                  label: switch (status) {
                    InventoryArchiveStatus.all => 'Trạng thái',
                    InventoryArchiveStatus.active => 'Đang sử dụng',
                    InventoryArchiveStatus.archived => 'Ngừng sử dụng',
                  },
                  tooltip: 'Lọc trạng thái',
                  value: status,
                  active: status != InventoryArchiveStatus.all,
                  onSelected: onStatusChanged,
                  items: const [
                    PopupMenuItem(
                      value: InventoryArchiveStatus.all,
                      child: Text('Tất cả trạng thái'),
                    ),
                    PopupMenuItem(
                      value: InventoryArchiveStatus.active,
                      child: Text('Đang sử dụng'),
                    ),
                    PopupMenuItem(
                      value: InventoryArchiveStatus.archived,
                      child: Text('Ngừng sử dụng'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: controlWidth,
                height: controlHeight,
                child: InventoryDirectoryFilter<String>(
                  label: category?.label ?? 'Danh mục',
                  tooltip: 'Lọc loại vật tư',
                  value: category?.name ?? 'all',
                  active: category != null,
                  onSelected: (value) => onCategoryChanged(
                    value == 'all'
                        ? null
                        : InventoryCategory.values.byName(value),
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('Tất cả loại vật tư'),
                    ),
                    for (final item in InventoryCategory.values.where(
                      (c) => c != InventoryCategory.unknown,
                    ))
                      PopupMenuItem(value: item.name, child: Text(item.label)),
                  ],
                ),
              ),
              SizedBox(
                width: (narrow ? constraints.maxWidth : controlWidth),
                height: controlHeight,
                child: Semantics(
                  toggled: lowStockOnly,
                  child: OutlinedButton(
                    key: const ValueKey('inventory-low-stock-filter'),
                    onPressed: () => onLowStockChanged(!lowStockOnly),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: lowStockOnly
                          ? const Color(0xFFFBE6EA)
                          : Colors.white,
                      foregroundColor: lowStockOnly
                          ? AppColors.error
                          : AppColors.inkSoft,
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.standard,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      side: BorderSide(
                        color: lowStockOnly ? AppColors.error : AppColors.line,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const InventorySvgIcon(
                          InventoryAssets.catalogWarning,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Sắp hết ($lowStockCount)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (status != InventoryArchiveStatus.all ||
              category != null ||
              lowStockOnly)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onReset,
                child: const Text('Xóa bộ lọc'),
              ),
            ),
        ],
      );
    },
  );
}
