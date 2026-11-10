// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_substance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventorySubstance _$InventorySubstanceFromJson(Map<String, dynamic> json) =>
    _InventorySubstance(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      group: json['group'] as String,
      appendix: json['appendix'] as String,
      sourceRow: json['sourceRow'] as String,
      page: (json['page'] as num).toInt(),
      note: json['note'] as String,
      mention: json['mention'] as String?,
    );

Map<String, dynamic> _$InventorySubstanceToJson(_InventorySubstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'group': instance.group,
      'appendix': instance.appendix,
      'sourceRow': instance.sourceRow,
      'page': instance.page,
      'note': instance.note,
      'mention': instance.mention,
    };

_InventorySubstancePage _$InventorySubstancePageFromJson(
  Map<String, dynamic> json,
) => _InventorySubstancePage(
  items: (json['items'] as List<dynamic>)
      .map((e) => InventorySubstance.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasNextPage: json['hasNextPage'] as bool,
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$InventorySubstancePageToJson(
  _InventorySubstancePage instance,
) => <String, dynamic>{
  'items': instance.items,
  'hasNextPage': instance.hasNextPage,
  'nextCursor': instance.nextCursor,
};

_InventorySubstanceCheck _$InventorySubstanceCheckFromJson(
  Map<String, dynamic> json,
) => _InventorySubstanceCheck(
  status: json['status'] as String,
  message: json['message'] as String,
  matches:
      (json['matches'] as List<dynamic>?)
          ?.map((e) => InventorySubstance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <InventorySubstance>[],
);

Map<String, dynamic> _$InventorySubstanceCheckToJson(
  _InventorySubstanceCheck instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'matches': instance.matches,
};
