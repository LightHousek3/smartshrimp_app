import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

abstract interface class InventoryRemoteDataSource {
  Future<InventoryProductPage> getProducts(
    String farmId,
    Map<String, dynamic> query,
  );

  Future<InventoryProduct> getProduct(String farmId, String productId);

  Future<InventoryProduct> createProduct(
    String farmId,
    Map<String, dynamic> data,
  );

  Future<InventoryProduct> updateProduct(
    String farmId,
    String productId,
    Map<String, dynamic> data,
  );

  Future<InventoryProduct> archiveProduct(String farmId, String productId);

  Future<void> deleteProduct(String farmId, String productId);

  Future<InventoryProduct> restoreProduct(String farmId, String productId);

  Future<InventoryStockResult> recordStockTransaction(
    String farmId,
    String productId,
    Map<String, dynamic> data,
    String idempotencyKey,
  );

  Future<InventoryHistoryPage> getHistory(
    String farmId,
    Map<String, dynamic> query,
  );
}

final class InventoryApiService implements InventoryRemoteDataSource {
  InventoryApiService(this._client);

  final ApiClient _client;

  String _basePath(String farmId) =>
      '/owner/farms/${Uri.encodeComponent(farmId)}';

  @override
  Future<InventoryProductPage> getProducts(
    String farmId,
    Map<String, dynamic> query,
  ) async {
    final response = await _client.get(
      '${_basePath(farmId)}/products',
      queryParameters: query,
      authenticated: true,
    );
    return InventoryProductPage.parse(response.data, response.meta);
  }

  @override
  Future<InventoryProduct> getProduct(String farmId, String productId) async {
    final response = await _client.get(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}',
      authenticated: true,
    );
    return InventoryProduct.parse(response.requireMapData());
  }

  @override
  Future<InventoryProduct> createProduct(
    String farmId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.post(
      '${_basePath(farmId)}/products',
      data: data,
      authenticated: true,
    );
    return InventoryProduct.parse(response.requireMapData());
  }

  @override
  Future<InventoryProduct> updateProduct(
    String farmId,
    String productId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.patch(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}',
      data: data,
      authenticated: true,
    );
    return InventoryProduct.parse(response.requireMapData());
  }

  @override
  Future<InventoryProduct> archiveProduct(
    String farmId,
    String productId,
  ) async {
    final response = await _client.post(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}/archive',
      authenticated: true,
    );
    return InventoryProduct.parse(response.requireMapData());
  }

  @override
  Future<void> deleteProduct(String farmId, String productId) async {
    await _client.delete(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}',
      authenticated: true,
    );
  }

  @override
  Future<InventoryProduct> restoreProduct(
    String farmId,
    String productId,
  ) async {
    final response = await _client.post(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}/restore',
      authenticated: true,
    );
    return InventoryProduct.parse(response.requireMapData());
  }

  @override
  Future<InventoryStockResult> recordStockTransaction(
    String farmId,
    String productId,
    Map<String, dynamic> data,
    String idempotencyKey,
  ) async {
    final response = await _client.post(
      '${_basePath(farmId)}/products/${Uri.encodeComponent(productId)}/stock-transactions',
      data: data,
      authenticated: true,
      headers: <String, Object>{'Idempotency-Key': idempotencyKey},
    );
    return InventoryStockResult.parse(response.requireMapData());
  }

  @override
  Future<InventoryHistoryPage> getHistory(
    String farmId,
    Map<String, dynamic> query,
  ) async {
    final response = await _client.get(
      '${_basePath(farmId)}/inventory-transactions',
      queryParameters: query,
      authenticated: true,
    );
    return InventoryHistoryPage.parse(response.data, response.meta);
  }
}
