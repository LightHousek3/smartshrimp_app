// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterLogCounts _$WaterLogCountsFromJson(Map<String, dynamic> json) =>
    _WaterLogCounts(
      all: (json['all'] as num).toInt(),
      valid: (json['valid'] as num).toInt(),
      warning: (json['warning'] as num).toInt(),
      voided: (json['voided'] as num).toInt(),
    );

Map<String, dynamic> _$WaterLogCountsToJson(_WaterLogCounts instance) =>
    <String, dynamic>{
      'all': instance.all,
      'valid': instance.valid,
      'warning': instance.warning,
      'voided': instance.voided,
    };
