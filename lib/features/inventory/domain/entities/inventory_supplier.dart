import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'inventory_supplier.freezed.dart';
part 'inventory_supplier.g.dart';

@freezed
abstract class InventorySupplier with _$InventorySupplier {
  const factory InventorySupplier({
    required String id,
    required String farmId,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? note,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InventorySupplier;

  factory InventorySupplier.fromJson(Map<String, dynamic> json) =>
      _$InventorySupplierFromJson(json);

  static InventorySupplier parse(Map<String, dynamic> json) {
    if (json.containsKey('isActive') && json['isActive'] is! bool) {
      throw const InvalidResponseException();
    }
    for (final field in ['id', 'farmId', 'name', 'createdAt', 'updatedAt']) {
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
