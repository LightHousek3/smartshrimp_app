import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';

final class SupplierApiService {
  SupplierApiService(this._client);
  final ApiClient _client;

  String _path(String farmId) =>
      '/owner/farms/${Uri.encodeComponent(farmId)}/suppliers';

  Future<({List<InventorySupplier> items, bool hasNextPage})> getPage(
    String farmId,
    int page,
  ) async {
    final response = await _client.get(
      _path(farmId),
      authenticated: true,
      queryParameters: {'page': page, 'limit': 100},
    );
    final data = response.data;
    final hasNextPage = response.meta?['hasNextPage'];
    if (data is! List || hasNextPage is! bool) {
      throw const InvalidResponseException();
    }
    final items = data
        .map((row) {
          if (row is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return InventorySupplier.parse(row);
        })
        .toList(growable: false);
    if (hasNextPage && items.isEmpty) throw const InvalidResponseException();
    return (items: items, hasNextPage: hasNextPage);
  }

  Future<InventorySupplier> getSupplier(
    String farmId,
    String supplierId,
  ) async {
    final response = await _client.get(
      '${_path(farmId)}/${Uri.encodeComponent(supplierId)}',
      authenticated: true,
    );
    return InventorySupplier.parse(response.requireMapData());
  }

  Future<InventorySupplier> save(
    String farmId,
    String? supplierId,
    Map<String, dynamic> data,
  ) async {
    final response = supplierId == null
        ? await _client.post(_path(farmId), data: data, authenticated: true)
        : await _client.patch(
            '${_path(farmId)}/${Uri.encodeComponent(supplierId)}',
            data: data,
            authenticated: true,
          );
    return InventorySupplier.parse(response.requireMapData());
  }

  Future<void> delete(String farmId, String supplierId) async {
    await _client.delete(
      '${_path(farmId)}/${Uri.encodeComponent(supplierId)}',
      authenticated: true,
    );
  }
}
