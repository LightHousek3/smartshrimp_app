// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log_exceedance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterLogExceedance _$WaterLogExceedanceFromJson(Map<String, dynamic> json) =>
    _WaterLogExceedance(
      field: json['field'] as String,
      direction: $enumDecode(
        _$WaterLogWarningDirectionEnumMap,
        json['direction'],
        unknownValue: WaterLogWarningDirection.unknown,
      ),
      value: (json['value'] as num).toDouble(),
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$WaterLogExceedanceToJson(_WaterLogExceedance instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': _$WaterLogWarningDirectionEnumMap[instance.direction]!,
      'value': instance.value,
      'min': instance.min,
      'max': instance.max,
      'unit': instance.unit,
    };

const _$WaterLogWarningDirectionEnumMap = {
  WaterLogWarningDirection.belowMin: 'below_min',
  WaterLogWarningDirection.aboveMax: 'above_max',
  WaterLogWarningDirection.unknown: 'unknown',
};
