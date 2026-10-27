import 'dart:convert';

import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:uuid/uuid.dart';

/// Normalize inventory payloads and retain movement keys for safe retries.
/// A retry after an uncertain response must reuse the original idempotency key.
final class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._remoteDataSource, {Uuid uuid = const Uuid()})
    : _uuid = uuid;

  final InventoryRemoteDataSource _remoteDataSource;
  final Uuid _uuid;
  final Map<String, String> _pendingStockKeys = <String, String>{};

  @override
  Future<InventoryProductPage> getProducts({
    required String farmId,
    int page = 1,
    int limit = 100,
    String? search,
    InventoryProductCategory? category,
    bool lowStockOnly = false,
    InventoryArchiveStatus archiveStatus = InventoryArchiveStatus.active,
  }) {
    final normalizedSearch = InventoryRules.normalizeText(search ?? '');
    return _remoteDataSource.getProducts(farmId, <String, dynamic>{
      'page': page,
      'limit': limit,
      if (normalizedSearch.isNotEmpty) 'search': normalizedSearch,
      if (category != null) 'category': _categoryValue(category),
      'stockStatus': lowStockOnly ? 'LOW' : 'ALL',
      'archiveStatus': _archiveStatusValue(archiveStatus),
    });
  }

  @override
  Future<InventoryProduct> getProduct({
    required String farmId,
    required String productId,
  }) => _remoteDataSource.getProduct(farmId, productId);

  @override
  Future<InventoryProduct> createProduct({
    required String farmId,
    required String name,
    required InventoryProductCategory category,
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) {
    InventoryRules.validateConversion(
      unit: unit,
      conversionQuantity: conversionQuantity,
      conversionUnit: conversionUnit,
    );
    return _remoteDataSource.createProduct(
      farmId,
      _productData(
        name: name,
        category: category,
        manufacturerId: manufacturerId,
        compliance: compliance,
        unit: unit,
        conversionQuantity: conversionQuantity,
        conversionUnit: conversionUnit,
        minAlertQuantity: minAlertQuantity,
        description: description,
        imageUrl: imageUrl,
        imageUrls: imageUrls,
      ),
    );
  }

  @override
  Future<InventoryProduct> updateProduct({
    required String farmId,
    required InventoryProduct product,
    required String name,
    required InventoryProductCategory category,
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) {
    InventoryRules.validateConversion(
      unit: unit,
      conversionQuantity: conversionQuantity,
      conversionUnit: conversionUnit,
    );
    return _remoteDataSource
        .updateProduct(farmId, product.id, <String, dynamic>{
          if (!product.metadataLocked)
            ..._productData(
              name: name,
              category: category,
              manufacturerId: manufacturerId.isEmpty
                  ? product.manufacturerId
                  : manufacturerId,
              compliance: compliance,
              unit: unit,
              conversionQuantity: conversionQuantity,
              conversionUnit: conversionUnit,
              minAlertQuantity: minAlertQuantity,
              description: description,
              imageUrl: imageUrl,
              imageUrls: imageUrls,
            ),
          'minAlertQuantity': minAlertQuantity,
          if (product.metadataLocked) 'description': _nullableText(description),
          'expectedUpdatedAt': product.updatedAt.toUtc().toIso8601String(),
        });
  }

  @override
  Future<InventoryProduct> archiveProduct({
    required String farmId,
    required String productId,
  }) => _remoteDataSource.archiveProduct(farmId, productId);

  @override
  Future<InventoryStockResult> recordStockOut({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required double quantity,
    String? quantityExact,
    String? reason,
  }) => _recordStockTransaction(farmId, productId, <String, dynamic>{
    'transactionType': 'STOCK_OUT',
    'inventoryBalanceId': inventoryBalanceId,
    'quantity':
        quantityExact ??
        InventoryRules.normalizedQuantity(quantity.toStringAsFixed(9)),
    'reason': _nullableText(reason),
  });

  @override
  Future<void> deleteProduct({
    required String farmId,
    required String productId,
  }) => _remoteDataSource.deleteProduct(farmId, productId);

  @override
  Future<InventoryLot> updateLotExpiry({
    required String farmId,
    required String productId,
    required InventoryLot lot,
    required DateTime expiryDate,
  }) => _remoteDataSource.updateLotExpiry(farmId, productId, lot.id, {
    'expiryDate': InventoryRules.dateText(expiryDate),
    'expectedUpdatedAt': lot.updatedAt.toUtc().toIso8601String(),
  });

  @override
  Future<InventoryProduct> restoreProduct({
    required String farmId,
    required String productId,
  }) => _remoteDataSource.restoreProduct(farmId, productId);

  @override
  Future<InventoryStockResult> recordStockIn({
    required String farmId,
    required String productId,
    required String lotNumber,
    required DateTime receivedAt,
    DateTime? expiryDate,
    required double quantity,
    String? quantityExact,
    required double unitPrice,
    required String supplierName,
    String? supplierId,
    String? reason,
  }) => _recordStockTransaction(farmId, productId, <String, dynamic>{
    'transactionType': 'STOCK_IN',
    'lotNumber': InventoryRules.normalizeText(lotNumber),
    'receivedAt': receivedAt.toUtc().toIso8601String(),
    'expiryDate': expiryDate == null
        ? null
        : InventoryRules.dateText(expiryDate),
    'quantity':
        quantityExact ??
        InventoryRules.normalizedQuantity(quantity.toStringAsFixed(9)),
    'unitPrice': unitPrice,
    'supplierId': ?supplierId,
    if (supplierName.trim().isNotEmpty)
      'supplierName': InventoryRules.normalizeText(supplierName),
    'reason': _nullableText(reason),
  });

  @override
  Future<InventoryStockResult> recordAdjustment({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required bool increase,
    required double quantity,
    String? quantityExact,
    required String reason,
  }) => _recordStockTransaction(farmId, productId, <String, dynamic>{
    'transactionType': increase ? 'ADJUSTMENT_IN' : 'ADJUSTMENT_OUT',
    'inventoryBalanceId': inventoryBalanceId,
    'quantity':
        quantityExact ??
        InventoryRules.normalizedQuantity(quantity.toStringAsFixed(9)),
    'reason': InventoryRules.normalizeText(reason),
  });

  Future<InventoryStockResult> _recordStockTransaction(
    String farmId,
    String productId,
    Map<String, dynamic> data,
  ) async {
    final signature = jsonEncode(<Object>[farmId, productId, data]);
    final key = _pendingStockKeys.putIfAbsent(signature, _uuid.v4);
    try {
      final result = await _remoteDataSource.recordStockTransaction(
        farmId,
        productId,
        data,
        key,
      );
      _pendingStockKeys.remove(signature);
      return result;
    } on ApiException catch (error) {
      final status = error.statusCode;
      if (status != null && status >= 400 && status < 500) {
        _pendingStockKeys.remove(signature);
      }
      rethrow;
    }
    // A lost or malformed response may follow a committed movement. Retain the
    // key so retrying the same payload replays that movement instead of adding it.
  }

  @override
  Future<InventoryHistoryPage> getHistory({
    required String farmId,
    String? search,
    String? cursor,
    int limit = 10,
    String? productId,
    InventoryTransactionType? transactionType,
    String? seasonId,
    DateTime? createdFrom,
    DateTime? createdTo,
  }) => _remoteDataSource.getHistory(farmId, <String, dynamic>{
    'limit': limit,
    'cursor': ?cursor,
    if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    'productId': ?productId,
    'seasonId': ?seasonId,
    if (transactionType != null)
      'transactionType': _transactionTypeValue(transactionType),
    if (createdFrom != null)
      'createdFrom': createdFrom.toUtc().toIso8601String(),
    if (createdTo != null) 'createdTo': createdTo.toUtc().toIso8601String(),
  });

  static Map<String, dynamic> _productData({
    required String name,
    required InventoryProductCategory category,
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required InventoryProductUnit unit,
    required double? conversionQuantity,
    required InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    required String? description,
    required String? imageUrl,
    required List<String>? imageUrls,
  }) {
    final photos = imageUrls ?? (imageUrl == null ? <String>[] : [imageUrl]);
    return <String, dynamic>{
      'name': InventoryRules.normalizeText(name),
      'category': _categoryValue(category),
      'manufacturerId': manufacturerId,
      if (compliance != null)
        'compliance': {
          ...compliance,
          if ((compliance['evidenceUrls'] as List?)?.isNotEmpty != true &&
              photos.isNotEmpty)
            'evidenceUrls': photos,
        },
      'unit': _unitValue(unit),
      'conversionQuantity': conversionQuantity,
      'conversionUnit': conversionUnit == null
          ? null
          : _conversionUnitValue(conversionUnit),
      'minAlertQuantity': minAlertQuantity,
      'description': _nullableText(description),
      if (imageUrls != null) 'imageUrls': imageUrls else 'imageUrl': imageUrl,
    };
  }

  static String? _nullableText(String? value) {
    final normalized = InventoryRules.normalizeText(value ?? '');
    return normalized.isEmpty ? null : normalized;
  }

  static String _categoryValue(InventoryProductCategory value) =>
      switch (value) {
        InventoryProductCategory.feed => 'FEED',
        InventoryProductCategory.medicine => 'MEDICINE',
        InventoryProductCategory.mineral => 'MINERAL',
        InventoryProductCategory.chemical => 'CHEMICAL',
        InventoryProductCategory.other => 'OTHER',
        InventoryProductCategory.unknown => throw ArgumentError.value(value),
      };

  static String _unitValue(InventoryProductUnit value) => switch (value) {
    InventoryProductUnit.kg => 'KG',
    InventoryProductUnit.g => 'G',
    InventoryProductUnit.l => 'L',
    InventoryProductUnit.ml => 'ML',
    InventoryProductUnit.pack => 'PACK',
    InventoryProductUnit.bottle => 'BOTTLE',
    InventoryProductUnit.pcs => 'PCS',
    InventoryProductUnit.unknown => throw ArgumentError.value(value),
  };

  static String _conversionUnitValue(InventoryConversionUnit value) =>
      switch (value) {
        InventoryConversionUnit.mg => 'MG',
        InventoryConversionUnit.g => 'G',
        InventoryConversionUnit.kg => 'KG',
        InventoryConversionUnit.ml => 'ML',
        InventoryConversionUnit.l => 'L',
        InventoryConversionUnit.unknown => throw ArgumentError.value(value),
      };

  static String _archiveStatusValue(InventoryArchiveStatus value) =>
      switch (value) {
        InventoryArchiveStatus.active => 'ACTIVE',
        InventoryArchiveStatus.archived => 'ARCHIVED',
        InventoryArchiveStatus.all => 'ALL',
      };

  static String _transactionTypeValue(InventoryTransactionType value) =>
      switch (value) {
        InventoryTransactionType.stockIn => 'STOCK_IN',
        InventoryTransactionType.adjustmentIn => 'ADJUSTMENT_IN',
        InventoryTransactionType.adjustmentOut => 'ADJUSTMENT_OUT',
        InventoryTransactionType.stockOut => 'STOCK_OUT',
        InventoryTransactionType.unknown => throw ArgumentError.value(value),
      };
}
