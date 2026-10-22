// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_compliance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryCompliance _$InventoryComplianceFromJson(Map<String, dynamic> json) =>
    _InventoryCompliance(
      regulatoryType: json['regulatoryType'] as String? ?? 'unclassified',
      registrationNumber: json['registrationNumber'] as String?,
      ingredientsText: json['ingredientsText'] as String?,
      containsAntibiotic: json['containsAntibiotic'] as bool?,
      usageInstructions: json['usageInstructions'] as String?,
      withdrawalDays: (json['withdrawalDays'] as num?)?.toDouble(),
      evidenceUrls:
          (json['evidenceUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      complianceStatus: json['complianceStatus'] as String? ?? 'draft',
      checkedBy: json['checkedBy'] as String?,
      checkedAt: json['checkedAt'] == null
          ? null
          : DateTime.parse(json['checkedAt'] as String),
      reviewNote: json['reviewNote'] as String?,
    );

Map<String, dynamic> _$InventoryComplianceToJson(
  _InventoryCompliance instance,
) => <String, dynamic>{
  'regulatoryType': instance.regulatoryType,
  'registrationNumber': instance.registrationNumber,
  'ingredientsText': instance.ingredientsText,
  'containsAntibiotic': instance.containsAntibiotic,
  'usageInstructions': instance.usageInstructions,
  'withdrawalDays': instance.withdrawalDays,
  'evidenceUrls': instance.evidenceUrls,
  'complianceStatus': instance.complianceStatus,
  'checkedBy': instance.checkedBy,
  'checkedAt': instance.checkedAt?.toIso8601String(),
  'reviewNote': instance.reviewNote,
};
