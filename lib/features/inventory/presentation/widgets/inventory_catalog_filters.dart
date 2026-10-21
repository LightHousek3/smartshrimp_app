import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';

class InventoryCatalogFilters extends StatelessWidget {
  const InventoryCatalogFilters({
    required this.status,
    required this.category,
    required this.lowStockOnly,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onLowStockChanged,
    required this.onReset,
    super.key,
  });

  final InventoryArchiveStatus status;
  final InventoryCategory? category;
  final bool lowStockOnly;
  final ValueChanged<InventoryArchiveStatus> onStatusChanged;
  final ValueChanged<InventoryCategory?> onCategoryChanged;
  final ValueChanged<bool> onLowStockChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onReset,
                borderRadius: BorderRadius.circular(12),
                child: _FilterLabel(
                  label: 'Tất cả',
                  active:
                      status == InventoryArchiveStatus.all &&
                      category == null &&
                      !lowStockOnly,
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => onLowStockChanged(!lowStockOnly),
                borderRadius: BorderRadius.circular(12),
                child: _FilterLabel(label: 'Sắp hết', active: lowStockOnly),
              ),
            ),
            Expanded(
              child: PopupMenuButton<InventoryArchiveStatus>(
                tooltip: 'Lọc trạng thái',
                initialValue: status,
                onSelected: onStatusChanged,
                color: Colors.white,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: InventoryArchiveStatus.all,
                    child: Text('Tất cả trạng thái'),
                  ),
                  const PopupMenuItem(
                    value: InventoryArchiveStatus.active,
                    child: Text('Đang sử dụng'),
                  ),
                  const PopupMenuItem(
                    value: InventoryArchiveStatus.archived,
                    child: Text('Tạm ngưng'),
                  ),
                ],
                child: _FilterLabel(
                  label: 'Trạng thái',
                  active: status != InventoryArchiveStatus.all,
                  dropdown: true,
                ),
              ),
            ),
            Expanded(
              child: PopupMenuButton<String>(
                tooltip: 'Lọc loại vật tư',
                initialValue: category?.name ?? 'all',
                onSelected: (value) => onCategoryChanged(
                  value == 'all'
                      ? null
                      : InventoryCategory.values.byName(value),
                ),
                color: Colors.white,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('Tất cả loại vật tư'),
                  ),
                  for (final item in InventoryCategory.values.where(
                    (c) => c != InventoryCategory.unknown,
                  ))
                    PopupMenuItem(value: item.name, child: Text(item.label)),
                ],
                child: _FilterLabel(
                  label: 'Loại',
                  active: category != null,
                  dropdown: true,
                ),
              ),
            ),
          ],
        ),
      ),
      if (status != InventoryArchiveStatus.all ||
          category != null ||
          lowStockOnly)
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 8),
          child: Text(
            [
              if (status == InventoryArchiveStatus.active) 'Đang sử dụng',
              if (status == InventoryArchiveStatus.archived) 'Tạm ngưng',
              if (category != null) category!.label,
              if (lowStockOnly) 'Sắp hết',
            ].join(' · '),
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
          ),
        ),
    ],
  );
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel({
    required this.label,
    required this.active,
    this.dropdown = false,
  });
  final String label;
  final bool active;
  final bool dropdown;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 44),
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
    decoration: BoxDecoration(
      color: active ? const Color(0xFFEAF4FF) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.ocean : AppColors.inkSoft,
            ),
          ),
          if (dropdown)
            Icon(
              Icons.expand_more_rounded,
              size: 15,
              color: active ? AppColors.ocean : AppColors.inkSoft,
            ),
        ],
      ),
    ),
  );
}
