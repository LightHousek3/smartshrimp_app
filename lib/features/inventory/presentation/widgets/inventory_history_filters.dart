import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

class InventoryHistoryFilterPanel extends StatelessWidget {
  const InventoryHistoryFilterPanel({
    required this.filters,
    required this.products,
    required this.seasons,
    required this.expanded,
    required this.loading,
    required this.hasPendingChanges,
    required this.onToggle,
    required this.onChanged,
    required this.onApply,
    required this.onReset,
    this.errorMessage,
    super.key,
  });

  final InventoryHistoryFilters filters;
  final List<InventoryTransactionProduct> products;
  final List<InventoryTransactionSeason> seasons;
  final bool expanded;
  final bool loading;
  final bool hasPendingChanges;
  final VoidCallback onToggle;
  final ValueChanged<InventoryHistoryFilters> onChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7EAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: AppColors.ocean,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Bộ lọc truy vết',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasPendingChanges
                            ? 'Có thay đổi chưa áp dụng'
                            : 'Thời gian · hình thức · vật tư · vụ nuôi',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
      if (expanded) ...<Widget>[
        const SizedBox(height: 10),
        InventorySurface(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _HistoryDateField(
                      label: 'Từ ngày',
                      value: filters.fromDate,
                      onChanged: (date) =>
                          onChanged(filters.copyWith(fromDate: date)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HistoryDateField(
                      label: 'Đến ngày',
                      value: filters.toDate,
                      onChanged: (date) =>
                          onChanged(filters.copyWith(toDate: date)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _HistoryDropdown(
                      label: 'Hình thức',
                      value: filters.transactionType?.name,
                      allLabel: 'Tất cả',
                      options: <String, String>{
                        for (final type in <InventoryTransactionType>[
                          InventoryTransactionType.stockIn,
                          InventoryTransactionType.stockOut,
                          InventoryTransactionType.adjustmentIn,
                          InventoryTransactionType.adjustmentOut,
                        ])
                          type.name: type.label,
                      },
                      onChanged: (value) => onChanged(
                        filters.copyWith(
                          transactionType: value == null
                              ? null
                              : InventoryTransactionType.values.byName(value),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HistoryDropdown(
                      label: 'Vật tư',
                      value: filters.productId,
                      allLabel: 'Tất cả vật tư',
                      options: <String, String>{
                        for (final product in products)
                          product.id: product.isDeleted
                              ? '${product.name} (đã xóa)'
                              : product.name,
                      },
                      onChanged: (value) =>
                          onChanged(filters.copyWith(productId: value)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _HistoryDropdown(
                label: 'Vụ nuôi liên quan',
                value: filters.seasonId,
                allLabel: 'Tất cả, kể cả không gắn vụ',
                options: <String, String>{
                  for (final season in seasons) season.id: season.label,
                },
                onChanged: (value) =>
                    onChanged(filters.copyWith(seasonId: value)),
              ),
              if (errorMessage != null) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ],
              const SizedBox(height: 10),
              const Divider(color: AppColors.line, height: 16),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: onReset,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.inkSoft,
                          side: const BorderSide(color: AppColors.line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text('Đặt lại'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InventoryGradientButton(
                      label: 'Xem kết quả',
                      radius: 22,
                      iconAsset: InventoryAssets.search,
                      height: 44,
                      onPressed: loading ? null : onApply,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

class _HistoryDateField extends StatelessWidget {
  const _HistoryDateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: label,
    );
    if (date != null && context.mounted) onChanged(date);
  }

  @override
  Widget build(BuildContext context) => InventoryField(
    label: label,
    child: TextFormField(
      key: ValueKey(value),
      initialValue: value == null
          ? ''
          : formatInventoryDate(value!).replaceAll('-', '/'),
      readOnly: true,
      style: inventoryInputTextStyle.copyWith(fontSize: 12),
      textAlignVertical: TextAlignVertical.center,
      onTap: () => _pickDate(context),
      decoration:
          inventoryInputDecoration(
            hintText: 'dd/mm/yyyy',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            suffixIcon: value == null
                ? const Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: AppColors.inkSoft,
                  )
                : IconButton(
                    tooltip: 'Xóa $label',
                    onPressed: () => onChanged(null),
                    icon: const Icon(Icons.close, size: 17),
                  ),
          ).copyWith(
            hintStyle: inventoryInputTextStyle.copyWith(
              color: AppColors.inkMuted,
              fontSize: 12,
            ),
          ),
    ),
  );
}

class _HistoryDropdown extends StatelessWidget {
  const _HistoryDropdown({
    required this.label,
    required this.value,
    required this.allLabel,
    required this.options,
    required this.onChanged,
  });

  static const _all = '__all__';
  final String label;
  final String? value;
  final String allLabel;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = <String, String>{
      _all: allLabel,
      ...options,
      if (value != null && !options.containsKey(value))
        value!: '$label đã chọn',
    };
    return InventoryField(
      label: label,
      child: DropdownButtonFormField<String>(
        key: ValueKey(value),
        initialValue: value ?? _all,
        isExpanded: true,
        style: inventoryInputTextStyle.copyWith(fontSize: 12),
        icon: const Icon(Icons.expand_more, color: AppColors.inkSoft),
        decoration: inventoryInputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
        ),
        items: entries.entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(growable: false),
        onChanged: (selected) => onChanged(selected == _all ? null : selected),
      ),
    );
  }
}
