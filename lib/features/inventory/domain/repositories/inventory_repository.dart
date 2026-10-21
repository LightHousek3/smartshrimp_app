import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

abstract interface class InventoryRepository {
  Future<InventoryProductPage> getProducts({
    required String farmId,
    int page = 1,
    int limit = 100,
    String? search,
    InventoryProductCategory? category,
    bool lowStockOnly = false,
    InventoryArchiveStatus archiveStatus = InventoryArchiveStatus.active,
  });

  Future<InventoryProduct> getProduct({
    required String farmId,
    required String productId,
  });

  Future<InventoryProduct> createProduct({
    required String farmId,
    required String name,
    required InventoryProductCategory category,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  });

  Future<InventoryProduct> updateProduct({
    required String farmId,
    required InventoryProduct product,
    required String name,
    required InventoryProductCategory category,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  });

  Future<InventoryProduct> archiveProduct({
    required String farmId,
    required String productId,
  });

  Future<InventoryStockResult> recordStockOut({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required double quantity,
    String? reason,
  });

  Future<InventoryProduct> restoreProduct({
    required String farmId,
    required String productId,
  });

  Future<InventoryStockResult> recordStockIn({
    required String farmId,
    required String productId,
    required String lotNumber,
    required DateTime receivedAt,
    required double quantity,
    required double unitPrice,
    required String supplierName,
    String? supplierId,
    String? reason,
  });

  Future<InventoryStockResult> recordAdjustment({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required bool increase,
    required double quantity,
    required String reason,
  });

  Future<InventoryHistoryPage> getHistory({
    required String farmId,
    String? cursor,
    int limit = 100,
    String? productId,
    InventoryTransactionType? transactionType,
    String? seasonId,
    DateTime? createdFrom,
    DateTime? createdTo,
  });
}
