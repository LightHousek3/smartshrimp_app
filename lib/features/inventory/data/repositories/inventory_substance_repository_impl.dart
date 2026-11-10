import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_substance_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_substance_repository.dart';

final class InventorySubstanceRepositoryImpl
    implements InventorySubstanceRepository {
  InventorySubstanceRepositoryImpl(this._api);
  final InventorySubstanceApiService _api;

  @override
  Future<InventorySubstancePage> search({
    required String farmId,
    required String query,
    String? cursor,
  }) {
    if (query.trim().length > 150) {
      throw const ApiException('Tìm thành phần tối đa 150 ký tự.');
    }
    return _api.search(farmId, query.trim(), cursor);
  }

  @override
  Future<InventorySubstanceCheck> check({
    required String farmId,
    required String ingredientsText,
  }) {
    if (ingredientsText.trim().length > 50000) {
      throw const ApiException('Nội dung thành phần tối đa 50.000 ký tự.');
    }
    return _api.check(farmId, ingredientsText.trim());
  }
}
