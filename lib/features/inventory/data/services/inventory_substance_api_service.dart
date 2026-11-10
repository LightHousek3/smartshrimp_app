import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';

class InventorySubstanceApiService {
  InventorySubstanceApiService(this._client);
  final ApiClient _client;
  String _path(String farmId) =>
      '/owner/farms/${Uri.encodeComponent(farmId)}/inventory-substances';

  Future<InventorySubstancePage> search(
    String farmId,
    String query,
    String? cursor,
  ) async {
    final response = await _client.get(
      _path(farmId),
      authenticated: true,
      queryParameters: {'q': query, 'cursor': ?cursor},
    );
    return InventorySubstancePage.parse(response.data, response.meta);
  }

  Future<InventorySubstanceCheck> check(String farmId, String text) async {
    final response = await _client.post(
      '${_path(farmId)}/check',
      authenticated: true,
      data: {'ingredientsText': text},
    );
    return InventorySubstanceCheck.parse(response.requireMapData());
  }
}
