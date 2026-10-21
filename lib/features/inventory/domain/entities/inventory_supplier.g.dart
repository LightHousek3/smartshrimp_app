// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventorySupplier _$InventorySupplierFromJson(Map<String, dynamic> json) =>
    _InventorySupplier(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      readOnly: json['readOnly'] as bool? ?? false,
      contactName: json['contactName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      note: json['note'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      supplierType: json['supplierType'] as String? ?? 'MANUFACTURER',
      canDelete: json['canDelete'] as bool? ?? false,
      manufacturedProductCount: (json['manufacturedProductCount'] as num?)
          ?.toInt(),
      receiptCount: (json['receiptCount'] as num?)?.toInt(),
      manufacturedProducts: (json['manufacturedProducts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      receipts: (json['receipts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventorySupplierToJson(_InventorySupplier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'readOnly': instance.readOnly,
      'contactName': instance.contactName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'note': instance.note,
      'status': instance.status,
      'supplierType': instance.supplierType,
      'canDelete': instance.canDelete,
      'manufacturedProductCount': instance.manufacturedProductCount,
      'receiptCount': instance.receiptCount,
      'manufacturedProducts': instance.manufacturedProducts,
      'receipts': instance.receipts,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
