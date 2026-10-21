import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';

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
  });
  Future<void> deleteSupplier(String farmId, String supplierId);
}
