import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Prefer the product photo and keep its category icon while loading or unavailable.
class InventoryProductImage extends StatelessWidget {
  const InventoryProductImage({
    this.url,
    this.size = 48,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.category = InventoryProductCategory.other,
    this.isArchived = false,
    this.isLowStock = false,
    super.key,
  });
  final String? url;
  final double size;
  final double? width;
  final double? height;
  final BoxFit fit;
  final InventoryProductCategory category;
  final bool isArchived;
  final bool isLowStock;

  String get _iconAsset => switch (category) {
    InventoryProductCategory.feed => InventoryAssets.catalogFeed,
    InventoryProductCategory.mineral => InventoryAssets.catalogMineral,
    InventoryProductCategory.medicine =>
      isLowStock
          ? InventoryAssets.catalogMedicineLow
          : InventoryAssets.catalogMedicine,
    InventoryProductCategory.chemical =>
      isArchived
          ? InventoryAssets.catalogChemicalInactive
          : InventoryAssets.catalogChemical,
    _ => InventoryAssets.inventoryBox,
  };

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: url == null || url!.trim().isEmpty
          ? _placeholder()
          : Image.network(
              url!.trim(),
              fit: fit,
              semanticLabel: 'Ảnh vật tư',
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : _placeholder(),
              errorBuilder: (_, error, stackTrace) => _placeholder(),
            ),
    ),
  );

  Widget _placeholder() => ColoredBox(
    color: isArchived
        ? const Color(0xFFF1F5F9)
        : category == InventoryProductCategory.medicine && isLowStock
        ? const Color(0xFFFBE6EA)
        : const Color(0xFFEAF4FF),
    child: Center(
      child: InventorySvgIcon(
        _iconAsset,
        size: (height ?? size) > 80 ? 44 : 20,
      ),
    ),
  );
}
