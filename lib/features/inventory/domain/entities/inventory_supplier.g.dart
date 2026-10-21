// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventorySupplier _$InventorySupplierFromJson(Map<String, dynamic> json) =>
    _InventorySupplier(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      contactName: json['contactName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      note: json['note'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventorySupplierToJson(_InventorySupplier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmId': instance.farmId,
      'name': instance.name,
      'contactName': instance.contactName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'note': instance.note,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
