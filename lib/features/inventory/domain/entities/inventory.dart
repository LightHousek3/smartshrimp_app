import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

enum InventoryProductCategory {
  @JsonValue('FEED')
  feed,
  @JsonValue('MEDICINE')
  medicine,
  @JsonValue('MINERAL')
  mineral,
  @JsonValue('CHEMICAL')
  chemical,
  @JsonValue('OTHER')
  other,
  unknown,
}

enum InventoryProductUnit {
  @JsonValue('KG')
  kg,
  @JsonValue('G')
  g,
  @JsonValue('L')
  l,
  @JsonValue('ML')
  ml,
  @JsonValue('PACK')
  pack,
  @JsonValue('BOTTLE')
  bottle,
  @JsonValue('PCS')
  pcs,
  unknown,
}

enum InventoryConversionUnit {
  @JsonValue('MG')
  mg,
  @JsonValue('G')
  g,
  @JsonValue('KG')
  kg,
  @JsonValue('ML')
  ml,
  @JsonValue('L')
  l,
  unknown,
}

enum InventoryTransactionType {
  @JsonValue('STOCK_IN')
  stockIn,
  @JsonValue('ADJUSTMENT_IN')
  adjustmentIn,
  @JsonValue('ADJUSTMENT_OUT')
  adjustmentOut,
  @JsonValue('STOCK_OUT')
  stockOut,
  unknown,
}

enum InventoryArchiveStatus { active, archived, all }

@freezed
abstract class InventoryHistoryFilters with _$InventoryHistoryFilters {
  const InventoryHistoryFilters._();

  const factory InventoryHistoryFilters({
    DateTime? fromDate,
    DateTime? toDate,
    InventoryTransactionType? transactionType,
    String? productId,
    String? seasonId,
  }) = _InventoryHistoryFilters;

  bool get isEmpty =>
      fromDate == null &&
      toDate == null &&
      transactionType == null &&
      productId == null &&
      seasonId == null;

  bool get isValidDateRange =>
      fromDate == null ||
      toDate == null ||
      !_startOfDay(fromDate!).isAfter(_startOfDay(toDate!));

  DateTime? get createdFrom => fromDate == null ? null : _startOfDay(fromDate!);

  DateTime? get createdTo => toDate == null
      ? null
      : DateTime(
          toDate!.year,
          toDate!.month,
          toDate!.day + 1,
        ).subtract(const Duration(milliseconds: 1));

  static DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

@freezed
abstract class InventoryLot with _$InventoryLot {
  const InventoryLot._();
  double? get usageRatio {
    final received = receivedQuantity;
    return received == null || received <= 0
        ? null
        : ((received - quantity) / received).clamp(0.0, 1.0);
  }

  const factory InventoryLot({
    required String id,
    required String productId,
    required String lotNumber,
    required DateTime receivedAt,
    required double quantity,
    double? receivedQuantity,
    required double unitPrice,
    required String supplierName,
    String? supplierId,
    required double inventoryValue,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InventoryLot;

  factory InventoryLot.fromJson(Map<String, dynamic> json) =>
      _$InventoryLotFromJson(json);

  static InventoryLot parse(Map<String, dynamic> json) {
    if (!_hasString(json, 'id') ||
        !_hasString(json, 'productId') ||
        !_hasString(json, 'lotNumber') ||
        !_hasString(json, 'supplierName') ||
        json['receivedAt'] is! String ||
        json['quantity'] is! num ||
        json['unitPrice'] is! num ||
        json['inventoryValue'] is! num ||
        json['createdAt'] is! String ||
        json['updatedAt'] is! String) {
      throw const InvalidResponseException();
    }
    return _parse(() => InventoryLot.fromJson(json));
  }
}

@freezed
abstract class InventoryProduct with _$InventoryProduct {
  const InventoryProduct._();

  List<String> get effectiveImageUrls => imageUrls.isNotEmpty
      ? imageUrls
      : imageUrl == null
      ? const []
      : [imageUrl!];

  const factory InventoryProduct({
    required String id,
    required String farmId,
    required String name,
    @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)
    required InventoryProductCategory category,
    @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)
    required InventoryProductUnit unit,
    double? conversionQuantity,
    @JsonKey(unknownEnumValue: InventoryConversionUnit.unknown)
    InventoryConversionUnit? conversionUnit,
    // In conversionUnit for PACK/BOTTLE; otherwise in unit.
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    @Default(<String>[]) List<String> imageUrls,
    DateTime? archivedAt,
    required bool isArchived,
    required bool isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required double currentStock,
    required double inventoryValue,
    required int activeLotCount,
    required bool isLowStock,
    @Default(<InventoryLot>[]) List<InventoryLot> lots,
    int? plannedUseCount,
    bool? canArchive,
  }) = _InventoryProduct;

  factory InventoryProduct.fromJson(Map<String, dynamic> json) =>
      _$InventoryProductFromJson(json);

  static InventoryProduct parse(Map<String, dynamic> json) {
    if (!_hasString(json, 'id') ||
        !_hasString(json, 'farmId') ||
        !_hasString(json, 'name') ||
        json['category'] is! String ||
        json['unit'] is! String ||
        json['minAlertQuantity'] is! num ||
        json['isArchived'] is! bool ||
        json['isDeleted'] is! bool ||
        json['createdAt'] is! String ||
        json['updatedAt'] is! String ||
        json['currentStock'] is! num ||
        json['inventoryValue'] is! num ||
        json['activeLotCount'] is! int ||
        json['isLowStock'] is! bool ||
        (json['lots'] != null && json['lots'] is! List<dynamic>)) {
      throw const InvalidResponseException();
    }
    final rawLots = json['lots'];
    if (rawLots is List<dynamic>) {
      for (final rawLot in rawLots) {
        if (rawLot is! Map<String, dynamic>) {
          throw const InvalidResponseException();
        }
        InventoryLot.parse(rawLot);
      }
    }
    return _parse(() => InventoryProduct.fromJson(json));
  }
}

@freezed
abstract class InventorySummary with _$InventorySummary {
  const factory InventorySummary({
    required int totalProducts,
    required int lowStockCount,
    required double inventoryValue,
  }) = _InventorySummary;

  factory InventorySummary.fromJson(Map<String, dynamic> json) =>
      _$InventorySummaryFromJson(json);

  static InventorySummary parse(Map<String, dynamic> json) {
    if (json['totalProducts'] is! int ||
        json['lowStockCount'] is! int ||
        json['inventoryValue'] is! num) {
      throw const InvalidResponseException();
    }
    return _parse(() => InventorySummary.fromJson(json));
  }
}

@freezed
abstract class InventoryProductPage with _$InventoryProductPage {
  const factory InventoryProductPage({
    required List<InventoryProduct> items,
    required int page,
    required int limit,
    required int totalResults,
    required int totalPages,
    required bool hasNextPage,
    required InventorySummary summary,
  }) = _InventoryProductPage;

  static InventoryProductPage parse(Object? data, Map<String, dynamic>? meta) {
    if (data is! List<dynamic> ||
        meta == null ||
        meta['page'] is! int ||
        meta['limit'] is! int ||
        meta['totalResults'] is! int ||
        meta['totalPages'] is! int ||
        meta['hasNextPage'] is! bool ||
        meta['summary'] is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    final items = data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return InventoryProduct.parse(item);
        })
        .toList(growable: false);
    return InventoryProductPage(
      items: items,
      page: meta['page'] as int,
      limit: meta['limit'] as int,
      totalResults: meta['totalResults'] as int,
      totalPages: meta['totalPages'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      summary: InventorySummary.parse(meta['summary']! as Map<String, dynamic>),
    );
  }
}

@freezed
abstract class InventoryTransactionProduct with _$InventoryTransactionProduct {
  const factory InventoryTransactionProduct({
    required String id,
    required String name,
    @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)
    required InventoryProductCategory category,
    @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)
    required InventoryProductUnit unit,
    required bool isDeleted,
  }) = _InventoryTransactionProduct;

  factory InventoryTransactionProduct.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionProductFromJson(json);
}

@freezed
abstract class InventoryTransactionSeason with _$InventoryTransactionSeason {
  const factory InventoryTransactionSeason({
    required String id,
    required String name,
    String? pondName,
  }) = _InventoryTransactionSeason;

  factory InventoryTransactionSeason.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionSeasonFromJson(json);
}

@freezed
abstract class InventoryTransactionPerformer
    with _$InventoryTransactionPerformer {
  const factory InventoryTransactionPerformer({
    required String id,
    String? fullName,
    required String email,
  }) = _InventoryTransactionPerformer;

  factory InventoryTransactionPerformer.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionPerformerFromJson(json);
}

@freezed
abstract class InventoryTransaction with _$InventoryTransaction {
  const factory InventoryTransaction({
    required String id,
    required String transactionGroupId,
    required String productId,
    required String inventoryBalanceId,
    String? seasonId,
    @JsonKey(unknownEnumValue: InventoryTransactionType.unknown)
    required InventoryTransactionType transactionType,
    required double quantity,
    @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)
    required InventoryProductUnit unitSnapshot,
    required double totalAmount,
    String? referenceType,
    String? referenceId,
    String? reason,
    required String performedBy,
    required DateTime createdAt,
    required InventoryTransactionProduct product,
    required InventoryLot inventoryBalance,
    InventoryTransactionSeason? season,
    required InventoryTransactionPerformer performer,
  }) = _InventoryTransaction;

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionFromJson(json);

  static InventoryTransaction parse(Map<String, dynamic> json) {
    if (!_hasString(json, 'id') ||
        !_hasString(json, 'transactionGroupId') ||
        !_hasString(json, 'productId') ||
        !_hasString(json, 'inventoryBalanceId') ||
        json['transactionType'] is! String ||
        json['quantity'] is! num ||
        json['unitSnapshot'] is! String ||
        json['totalAmount'] is! num ||
        !_hasString(json, 'performedBy') ||
        json['createdAt'] is! String ||
        json['product'] is! Map<String, dynamic> ||
        json['inventoryBalance'] is! Map<String, dynamic> ||
        json['performer'] is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    InventoryLot.parse(json['inventoryBalance']! as Map<String, dynamic>);
    return _parse(() => InventoryTransaction.fromJson(json));
  }
}

@freezed
abstract class InventoryHistorySummary with _$InventoryHistorySummary {
  const factory InventoryHistorySummary({
    required double totalInboundValue,
    required double totalOutboundValue,
  }) = _InventoryHistorySummary;

  factory InventoryHistorySummary.fromJson(Map<String, dynamic> json) =>
      _$InventoryHistorySummaryFromJson(json);

  static InventoryHistorySummary parse(Map<String, dynamic> json) {
    if (json['totalInboundValue'] is! num ||
        json['totalOutboundValue'] is! num) {
      throw const InvalidResponseException();
    }
    return _parse(() => InventoryHistorySummary.fromJson(json));
  }
}

@freezed
abstract class InventoryHistoryPage with _$InventoryHistoryPage {
  const factory InventoryHistoryPage({
    required List<InventoryTransaction> items,
    required int limit,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
    required InventoryHistorySummary summary,
  }) = _InventoryHistoryPage;

  static InventoryHistoryPage parse(Object? data, Map<String, dynamic>? meta) {
    if (data is! List<dynamic> ||
        meta == null ||
        meta['limit'] is! int ||
        meta['totalResults'] is! int ||
        meta['hasNextPage'] is! bool ||
        (meta['nextCursor'] != null && meta['nextCursor'] is! String) ||
        meta['summary'] is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    final items = data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return InventoryTransaction.parse(item);
        })
        .toList(growable: false);
    return InventoryHistoryPage(
      items: items,
      limit: meta['limit'] as int,
      totalResults: meta['totalResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
      summary: InventoryHistorySummary.parse(
        meta['summary']! as Map<String, dynamic>,
      ),
    );
  }
}

@freezed
abstract class InventoryStockResult with _$InventoryStockResult {
  const factory InventoryStockResult({
    required String transactionId,
    required InventoryLot balance,
    required double currentStock,
    required bool idempotentReplay,
  }) = _InventoryStockResult;

  static InventoryStockResult parse(Map<String, dynamic> json) {
    final transaction = json['transaction'];
    final balance = json['balance'];
    if (transaction is! Map<String, dynamic> ||
        !_hasString(transaction, 'id') ||
        balance is! Map<String, dynamic> ||
        json['currentStock'] is! num ||
        json['idempotentReplay'] is! bool) {
      throw const InvalidResponseException();
    }
    return InventoryStockResult(
      transactionId: transaction['id']! as String,
      balance: InventoryLot.parse(balance),
      currentStock: (json['currentStock']! as num).toDouble(),
      idempotentReplay: json['idempotentReplay']! as bool,
    );
  }
}

bool _hasString(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is String && value.trim().isNotEmpty;
}

T _parse<T>(T Function() parse) {
  try {
    return parse();
  } on InvalidResponseException {
    rethrow;
  } on Object catch (_, stackTrace) {
    Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
  }
}
