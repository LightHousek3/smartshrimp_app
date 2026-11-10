import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';

abstract interface class InventorySubstanceRepository {
  Future<InventorySubstancePage> search({
    required String farmId,
    required String query,
    String? cursor,
  });
  Future<InventorySubstanceCheck> check({
    required String farmId,
    required String ingredientsText,
  });
}
