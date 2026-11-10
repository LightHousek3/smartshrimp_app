// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryLabelResult _$InventoryLabelResultFromJson(
  Map<String, dynamic> json,
) => _InventoryLabelResult(
  name: json['name'] as String?,
  manufacturerName: json['manufacturerName'] as String?,
  regulatoryType: json['regulatoryType'] as String?,
  registrationNumber: json['registrationNumber'] as String?,
  ingredientsText: json['ingredientsText'] as String?,
  usageInstructions: json['usageInstructions'] as String?,
  containsAntibiotic: json['containsAntibiotic'] as bool?,
  withdrawalDays: (json['withdrawalDays'] as num?)?.toDouble(),
  substanceCheck: json['substanceCheck'] == null
      ? null
      : InventorySubstanceCheck.fromJson(
          json['substanceCheck'] as Map<String, dynamic>,
        ),
  evidence:
      (json['evidence'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$InventoryLabelResultToJson(
  _InventoryLabelResult instance,
) => <String, dynamic>{
  'name': instance.name,
  'manufacturerName': instance.manufacturerName,
  'regulatoryType': instance.regulatoryType,
  'registrationNumber': instance.registrationNumber,
  'ingredientsText': instance.ingredientsText,
  'usageInstructions': instance.usageInstructions,
  'containsAntibiotic': instance.containsAntibiotic,
  'withdrawalDays': instance.withdrawalDays,
  'substanceCheck': instance.substanceCheck,
  'evidence': instance.evidence,
  'warnings': instance.warnings,
};
