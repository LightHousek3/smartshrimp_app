import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';

abstract interface class InventoryLabelRepository {
  Future<InventoryLabelResult> scan({
    required String farmId,
    required List<InventoryLabelImage> images,
  });
}
