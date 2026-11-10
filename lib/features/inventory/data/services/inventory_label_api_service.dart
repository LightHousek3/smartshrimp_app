import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';

class InventoryLabelApiService {
  InventoryLabelApiService(this._client);

  final ApiClient _client;

  Future<InventoryLabelResult> scan(
    String farmId,
    List<Map<String, String>> images,
  ) async {
    final response = await _client.post(
      '/owner/farms/${Uri.encodeComponent(farmId)}/products/scan-label',
      data: {'images': images},
      authenticated: true,
      // The server allows up to 10 seconds to fetch each saved image, then 60 seconds for AI.
      receiveTimeout: const Duration(seconds: 80),
    );
    return InventoryLabelResult.parse(response.requireMapData());
  }
}
