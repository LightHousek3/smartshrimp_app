import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';

/// Manage the owner directory through a farm the current owner may access.
/// Saving an existing supplier preserves its identity and version token.
abstract interface class SupplierRepository {
  Future<List<InventorySupplier>> getSuppliers(String farmId);
  Future<InventorySupplier> getSupplier(String farmId, String supplierId);
  Future<InventorySupplier> saveSupplier({
    required String farmId,
    InventorySupplier? existing,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? note,
    bool isActive = true,
    String supplierType = 'MANUFACTURER',
  });
  Future<void> deleteSupplier(String farmId, String supplierId);
}
