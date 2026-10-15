// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterMetricMetadata _$WaterMetricMetadataFromJson(Map<String, dynamic> json) =>
    _WaterMetricMetadata(
      field: json['field'] as String,
      unit: json['unit'] as String,
      inputMin: (json['inputMin'] as num).toDouble(),
      inputMax: (json['inputMax'] as num?)?.toDouble(),
      scale: (json['scale'] as num).toInt(),
      warningMin: (json['warningMin'] as num?)?.toDouble(),
      warningMax: (json['warningMax'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WaterMetricMetadataToJson(
  _WaterMetricMetadata instance,
) => <String, dynamic>{
  'field': instance.field,
  'unit': instance.unit,
  'inputMin': instance.inputMin,
  'inputMax': instance.inputMax,
  'scale': instance.scale,
  'warningMin': instance.warningMin,
  'warningMax': instance.warningMax,
};

_WaterLogMetadata _$WaterLogMetadataFromJson(Map<String, dynamic> json) =>
    _WaterLogMetadata(
      schemaVersion: (json['schemaVersion'] as num).toInt(),
      policyVersion: json['policyVersion'] as String,
      shrimpType: json['shrimpType'] as String,
      recordedAtFutureToleranceSeconds:
          (json['recordedAtFutureToleranceSeconds'] as num).toInt(),
      noteMaxLength: (json['noteMaxLength'] as num).toInt(),
      metrics: (json['metrics'] as List<dynamic>)
          .map((e) => WaterMetricMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterLogMetadataToJson(
  _WaterLogMetadata instance,
) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'policyVersion': instance.policyVersion,
  'shrimpType': instance.shrimpType,
  'recordedAtFutureToleranceSeconds': instance.recordedAtFutureToleranceSeconds,
  'noteMaxLength': instance.noteMaxLength,
  'metrics': instance.metrics,
};
