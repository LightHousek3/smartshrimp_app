import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'inventory_supplier.freezed.dart';
part 'inventory_supplier.g.dart';

/// Keep explicit owner identity, supply role and version for shared directory edits.
@freezed
abstract class InventorySupplier with _$InventorySupplier {
  const InventorySupplier._();

  bool get isActive => status == 'ACTIVE';
  bool get isManufacturer =>
      supplierType == 'MANUFACTURER' || supplierType == 'BOTH';

  const factory InventorySupplier({
    required String id,
    required String ownerId,
    required String name,
    @Default(false) bool readOnly,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? note,
    @Default('ACTIVE') String status,
    @Default('MANUFACTURER') String supplierType,
    @Default(false) bool canDelete,
    @Default(false) bool metadataLocked,
    int? manufacturedProductCount,
    int? receiptCount,
    List<Map<String, dynamic>>? manufacturedProducts,
    List<Map<String, dynamic>>? receipts,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InventorySupplier;

  factory InventorySupplier.fromJson(Map<String, dynamic> json) =>
      _$InventorySupplierFromJson(json);

  /// Reject malformed required fields before generated JSON conversion.
  static InventorySupplier parse(Map<String, dynamic> json) {
    final legacyRead =
        json['schemaVersion'] == 1 &&
        json['readOnly'] == true &&
        json['supplierType'] == 'UNKNOWN';
    final pendingRole =
        json['schemaVersion'] == 2 &&
        json['requiresSupplierType'] == true &&
        json['supplierType'] == 'UNKNOWN';
    if (!['ACTIVE', 'INACTIVE'].contains(json['status']) ||
        (!legacyRead &&
            !pendingRole &&
            ![
              'MANUFACTURER',
              'DISTRIBUTOR',
              'BOTH',
            ].contains(json['supplierType']))) {
      throw const InvalidResponseException();
    }
    for (final field in ['id', 'ownerId', 'name', 'createdAt', 'updatedAt']) {
      if (json[field] is! String || (json[field] as String).trim().isEmpty) {
        throw const InvalidResponseException();
      }
    }
    try {
      return InventorySupplier.fromJson(json);
    } on Object {
      throw const InvalidResponseException();
    }
  }
}
