import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Shared catalog controls retain the app palette, typography and rounded surfaces.
class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({
    required this.value,
    required this.label,
    this.alert = false,
    this.minHeight = 60,
    super.key,
  });
  final String value;
  final String label;
  final bool alert;
  final double minHeight;

  @override
  Widget build(BuildContext context) => InventorySurface(
    radius: 18,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight - 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.display(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: alert ? AppColors.error : AppColors.ink,
              height: 1.5,
            ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: .225,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}

class InventoryDirectorySearch extends StatelessWidget {
  const InventoryDirectorySearch({
    required this.hint,
    this.controller,
    this.onChanged,
    super.key,
  });
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    style: const TextStyle(color: AppColors.ink, fontSize: 12),
    decoration:
        inventoryInputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ).copyWith(
          constraints: const BoxConstraints(minHeight: 40),
          hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 40,
          ),
          prefixIcon: const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: InventorySvgIcon(InventoryAssets.catalogSearch, size: 15),
          ),
        ),
  );
}

class InventoryDirectoryFilter<T> extends StatelessWidget {
  const InventoryDirectoryFilter({
    required this.label,
    required this.tooltip,
    required this.value,
    required this.items,
    required this.onSelected,
    this.active = false,
    super.key,
  });
  final String label;
  final String tooltip;
  final T value;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final bool active;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    tooltip: tooltip,
    initialValue: value,
    onSelected: onSelected,
    itemBuilder: (_) => items,
    color: Colors.white,
    child: Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEAF4FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? AppColors.oceanLight : AppColors.line,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          const InventorySvgIcon(InventoryAssets.catalogDropdown, size: 14),
        ],
      ),
    ),
  );
}

class InventorySoftButton extends StatelessWidget {
  const InventorySoftButton({
    required this.label,
    required this.asset,
    required this.onPressed,
    super.key,
  });
  final String label;
  final String asset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    icon: InventorySvgIcon(asset, size: 13),
    label: Text(label),
    style: TextButton.styleFrom(
      backgroundColor: const Color(0xFFEAF4FF),
      foregroundColor: const Color(0xFF0C4E8F),
      minimumSize: const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      textStyle: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class InventoryLabelBadge extends StatelessWidget {
  const InventoryLabelBadge({
    required this.label,
    this.foreground = AppColors.inkMuted,
    this.background = const Color(0xFFEEF1F6),
    super.key,
  });
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: foreground,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    ),
  );
}

extension InventorySupplierPresentation on InventorySupplier {
  String get roleLabel => switch (supplierType) {
    'MANUFACTURER' => 'Nhà sản xuất',
    'DISTRIBUTOR' => 'Nhà phân phối',
    'UNKNOWN' => 'Chưa xác định vai trò',
    _ => 'Sản xuất & phân phối',
  };
  Color get roleForeground => switch (supplierType) {
    'MANUFACTURER' => const Color(0xFF7B5BD6),
    'DISTRIBUTOR' => const Color(0xFF0C4E8F),
    'UNKNOWN' => AppColors.inkMuted,
    _ => const Color(0xFF0F9B8E),
  };
  Color get roleBackground => switch (supplierType) {
    'MANUFACTURER' => const Color(0xFFEFEAFC),
    'DISTRIBUTOR' => const Color(0xFFEAF4FF),
    'UNKNOWN' => const Color(0xFFEEF1F6),
    _ => const Color(0xFFE2F6F3),
  };
}

class InventoryReadOnlyNotice extends StatelessWidget {
  const InventoryReadOnlyNotice({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: InventorySurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: AppColors.ocean),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Kho tạm thời chỉ xem. Bạn vẫn có thể xem tồn kho, nhà cung cấp và lịch sử; dữ liệu cần được đồng bộ trước khi cập nhật.',
              style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
