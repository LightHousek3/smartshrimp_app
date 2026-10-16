// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryLot _$InventoryLotFromJson(Map<String, dynamic> json) =>
    _InventoryLot(
      id: json['id'] as String,
      productId: json['productId'] as String,
      lotNumber: json['lotNumber'] as String,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      quantity: (json['quantity'] as num).toDouble(),
      receivedQuantity: (json['receivedQuantity'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      supplierName: json['supplierName'] as String,
      supplierId: json['supplierId'] as String?,
      inventoryValue: (json['inventoryValue'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventoryLotToJson(_InventoryLot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'lotNumber': instance.lotNumber,
      'receivedAt': instance.receivedAt.toIso8601String(),
      'quantity': instance.quantity,
      'receivedQuantity': instance.receivedQuantity,
      'unitPrice': instance.unitPrice,
      'supplierName': instance.supplierName,
      'supplierId': instance.supplierId,
      'inventoryValue': instance.inventoryValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_InventoryProduct _$InventoryProductFromJson(Map<String, dynamic> json) =>
    _InventoryProduct(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      category: $enumDecode(
        _$InventoryProductCategoryEnumMap,
        json['category'],
        unknownValue: InventoryProductCategory.unknown,
      ),
      unit: $enumDecode(
        _$InventoryProductUnitEnumMap,
        json['unit'],
        unknownValue: InventoryProductUnit.unknown,
      ),
      conversionQuantity: (json['conversionQuantity'] as num?)?.toDouble(),
      conversionUnit: $enumDecodeNullable(
        _$InventoryConversionUnitEnumMap,
        json['conversionUnit'],
        unknownValue: InventoryConversionUnit.unknown,
      ),
      minAlertQuantity: (json['minAlertQuantity'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      isArchived: json['isArchived'] as bool,
      isDeleted: json['isDeleted'] as bool,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentStock: (json['currentStock'] as num).toDouble(),
      inventoryValue: (json['inventoryValue'] as num).toDouble(),
      activeLotCount: (json['activeLotCount'] as num).toInt(),
      isLowStock: json['isLowStock'] as bool,
      lots:
          (json['lots'] as List<dynamic>?)
              ?.map((e) => InventoryLot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <InventoryLot>[],
      plannedUseCount: (json['plannedUseCount'] as num?)?.toInt(),
      canArchive: json['canArchive'] as bool?,
    );

Map<String, dynamic> _$InventoryProductToJson(
  _InventoryProduct instance,
) => <String, dynamic>{
  'id': instance.id,
  'farmId': instance.farmId,
  'name': instance.name,
  'category': _$InventoryProductCategoryEnumMap[instance.category]!,
  'unit': _$InventoryProductUnitEnumMap[instance.unit]!,
  'conversionQuantity': instance.conversionQuantity,
  'conversionUnit': _$InventoryConversionUnitEnumMap[instance.conversionUnit],
  'minAlertQuantity': instance.minAlertQuantity,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'imageUrls': instance.imageUrls,
  'archivedAt': instance.archivedAt?.toIso8601String(),
  'isArchived': instance.isArchived,
  'isDeleted': instance.isDeleted,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'currentStock': instance.currentStock,
  'inventoryValue': instance.inventoryValue,
  'activeLotCount': instance.activeLotCount,
  'isLowStock': instance.isLowStock,
  'lots': instance.lots,
  'plannedUseCount': instance.plannedUseCount,
  'canArchive': instance.canArchive,
};

const _$InventoryProductCategoryEnumMap = {
  InventoryProductCategory.feed: 'FEED',
  InventoryProductCategory.medicine: 'MEDICINE',
  InventoryProductCategory.mineral: 'MINERAL',
  InventoryProductCategory.chemical: 'CHEMICAL',
  InventoryProductCategory.other: 'OTHER',
  InventoryProductCategory.unknown: 'unknown',
};

const _$InventoryProductUnitEnumMap = {
  InventoryProductUnit.kg: 'KG',
  InventoryProductUnit.g: 'G',
  InventoryProductUnit.l: 'L',
  InventoryProductUnit.ml: 'ML',
  InventoryProductUnit.pack: 'PACK',
  InventoryProductUnit.bottle: 'BOTTLE',
  InventoryProductUnit.pcs: 'PCS',
  InventoryProductUnit.unknown: 'unknown',
};

const _$InventoryConversionUnitEnumMap = {
  InventoryConversionUnit.mg: 'MG',
  InventoryConversionUnit.g: 'G',
  InventoryConversionUnit.kg: 'KG',
  InventoryConversionUnit.ml: 'ML',
  InventoryConversionUnit.l: 'L',
  InventoryConversionUnit.unknown: 'unknown',
};

_InventorySummary _$InventorySummaryFromJson(Map<String, dynamic> json) =>
    _InventorySummary(
      totalProducts: (json['totalProducts'] as num).toInt(),
      lowStockCount: (json['lowStockCount'] as num).toInt(),
      inventoryValue: (json['inventoryValue'] as num).toDouble(),
    );

Map<String, dynamic> _$InventorySummaryToJson(_InventorySummary instance) =>
    <String, dynamic>{
      'totalProducts': instance.totalProducts,
      'lowStockCount': instance.lowStockCount,
      'inventoryValue': instance.inventoryValue,
    };

_InventoryTransactionProduct _$InventoryTransactionProductFromJson(
  Map<String, dynamic> json,
) => _InventoryTransactionProduct(
  id: json['id'] as String,
  name: json['name'] as String,
  category: $enumDecode(
    _$InventoryProductCategoryEnumMap,
    json['category'],
    unknownValue: InventoryProductCategory.unknown,
  ),
  unit: $enumDecode(
    _$InventoryProductUnitEnumMap,
    json['unit'],
    unknownValue: InventoryProductUnit.unknown,
  ),
  isDeleted: json['isDeleted'] as bool,
);

Map<String, dynamic> _$InventoryTransactionProductToJson(
  _InventoryTransactionProduct instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': _$InventoryProductCategoryEnumMap[instance.category]!,
  'unit': _$InventoryProductUnitEnumMap[instance.unit]!,
  'isDeleted': instance.isDeleted,
};

_InventoryTransactionSeason _$InventoryTransactionSeasonFromJson(
  Map<String, dynamic> json,
) => _InventoryTransactionSeason(
  id: json['id'] as String,
  name: json['name'] as String,
  pondName: json['pondName'] as String?,
);

Map<String, dynamic> _$InventoryTransactionSeasonToJson(
  _InventoryTransactionSeason instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pondName': instance.pondName,
};

_InventoryTransactionPerformer _$InventoryTransactionPerformerFromJson(
  Map<String, dynamic> json,
) => _InventoryTransactionPerformer(
  id: json['id'] as String,
  fullName: json['fullName'] as String?,
  email: json['email'] as String,
);

Map<String, dynamic> _$InventoryTransactionPerformerToJson(
  _InventoryTransactionPerformer instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
};

_InventoryTransaction _$InventoryTransactionFromJson(
  Map<String, dynamic> json,
) => _InventoryTransaction(
  id: json['id'] as String,
  transactionGroupId: json['transactionGroupId'] as String,
  productId: json['productId'] as String,
  inventoryBalanceId: json['inventoryBalanceId'] as String,
  seasonId: json['seasonId'] as String?,
  transactionType: $enumDecode(
    _$InventoryTransactionTypeEnumMap,
    json['transactionType'],
    unknownValue: InventoryTransactionType.unknown,
  ),
  quantity: (json['quantity'] as num).toDouble(),
  unitSnapshot: $enumDecode(
    _$InventoryProductUnitEnumMap,
    json['unitSnapshot'],
    unknownValue: InventoryProductUnit.unknown,
  ),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  referenceType: json['referenceType'] as String?,
  referenceId: json['referenceId'] as String?,
  reason: json['reason'] as String?,
  performedBy: json['performedBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  product: InventoryTransactionProduct.fromJson(
    json['product'] as Map<String, dynamic>,
  ),
  inventoryBalance: InventoryLot.fromJson(
    json['inventoryBalance'] as Map<String, dynamic>,
  ),
  season: json['season'] == null
      ? null
      : InventoryTransactionSeason.fromJson(
          json['season'] as Map<String, dynamic>,
        ),
  performer: InventoryTransactionPerformer.fromJson(
    json['performer'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$InventoryTransactionToJson(
  _InventoryTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionGroupId': instance.transactionGroupId,
  'productId': instance.productId,
  'inventoryBalanceId': instance.inventoryBalanceId,
  'seasonId': instance.seasonId,
  'transactionType':
      _$InventoryTransactionTypeEnumMap[instance.transactionType]!,
  'quantity': instance.quantity,
  'unitSnapshot': _$InventoryProductUnitEnumMap[instance.unitSnapshot]!,
  'totalAmount': instance.totalAmount,
  'referenceType': instance.referenceType,
  'referenceId': instance.referenceId,
  'reason': instance.reason,
  'performedBy': instance.performedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'product': instance.product,
  'inventoryBalance': instance.inventoryBalance,
  'season': instance.season,
  'performer': instance.performer,
};

const _$InventoryTransactionTypeEnumMap = {
  InventoryTransactionType.stockIn: 'STOCK_IN',
  InventoryTransactionType.adjustmentIn: 'ADJUSTMENT_IN',
  InventoryTransactionType.adjustmentOut: 'ADJUSTMENT_OUT',
  InventoryTransactionType.stockOut: 'STOCK_OUT',
  InventoryTransactionType.unknown: 'unknown',
};

_InventoryHistorySummary _$InventoryHistorySummaryFromJson(
  Map<String, dynamic> json,
) => _InventoryHistorySummary(
  totalInboundValue: (json['totalInboundValue'] as num).toDouble(),
  totalOutboundValue: (json['totalOutboundValue'] as num).toDouble(),
);

Map<String, dynamic> _$InventoryHistorySummaryToJson(
  _InventoryHistorySummary instance,
) => <String, dynamic>{
  'totalInboundValue': instance.totalInboundValue,
  'totalOutboundValue': instance.totalOutboundValue,
};
