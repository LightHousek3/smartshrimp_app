import 'package:smartshrimp_app/features/inventory/data/services/supplier_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/supplier_repository.dart';

/// Collect the owner directory across pages and normalize supplier form values.
/// Existing records carry their version token when saved from another farm.
final class SupplierRepositoryImpl implements SupplierRepository {
  SupplierRepositoryImpl(this._api);
  final SupplierApiService _api;

  @override
  Future<List<InventorySupplier>> getSuppliers(String farmId) async {
    final suppliers = <InventorySupplier>[];
    var page = 1;
    while (true) {
      final result = await _api.getPage(farmId, page++);
      suppliers.addAll(result.items);
      if (!result.hasNextPage) return suppliers;
    }
  }

  @override
  Future<InventorySupplier> getSupplier(String farmId, String supplierId) =>
      _api.getSupplier(farmId, supplierId);

  @override
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
  }) => _api.save(farmId, existing?.id, {
    'name': InventoryRules.normalizeText(name),
    'contactName': _text(contactName),
    'phone': _text(phone),
    'email': _text(email)?.toLowerCase(),
    'address': _text(address),
    'note': _text(note),
    if (existing != null) 'status': isActive ? 'ACTIVE' : 'INACTIVE',
    'supplierType': supplierType,
    if (existing != null)
      'expectedUpdatedAt': existing.updatedAt.toUtc().toIso8601String(),
  });

  @override
  Future<void> deleteSupplier(String farmId, String supplierId) =>
      _api.delete(farmId, supplierId);

  static String? _text(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? null : normalized;
  }
}
