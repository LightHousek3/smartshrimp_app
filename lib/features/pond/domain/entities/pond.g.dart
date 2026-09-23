// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pond.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PondFarm _$PondFarmFromJson(Map<String, dynamic> json) => _PondFarm(
  id: json['id'] as String,
  name: json['name'] as String,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$PondFarmToJson(_PondFarm instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

_PondCurrentSeason _$PondCurrentSeasonFromJson(Map<String, dynamic> json) =>
    _PondCurrentSeason(
      id: json['id'] as String,
      status: $enumDecode(
        _$PondSeasonStatusEnumMap,
        json['status'],
        unknownValue: PondSeasonStatus.unknown,
      ),
      stockingDate: json['stockingDate'] == null
          ? null
          : DateTime.parse(json['stockingDate'] as String),
    );

Map<String, dynamic> _$PondCurrentSeasonToJson(_PondCurrentSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$PondSeasonStatusEnumMap[instance.status]!,
      'stockingDate': instance.stockingDate?.toIso8601String(),
    };

const _$PondSeasonStatusEnumMap = {
  PondSeasonStatus.planning: 'PLANNING',
  PondSeasonStatus.active: 'ACTIVE',
  PondSeasonStatus.unknown: 'unknown',
};

_Pond _$PondFromJson(Map<String, dynamic> json) => _Pond(
  id: json['id'] as String,
  farmId: json['farmId'] as String,
  name: json['name'] as String,
  areaM2: (json['areaM2'] as num?)?.toDouble(),
  depthM: (json['depthM'] as num?)?.toDouble(),
  volumeM3: (json['volumeM3'] as num?)?.toDouble(),
  type: $enumDecode(
    _$PondTypeEnumMap,
    json['type'],
    unknownValue: PondType.unknown,
  ),
  status: $enumDecode(
    _$PondStatusEnumMap,
    json['status'],
    unknownValue: PondStatus.unknown,
  ),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  farm: json['farm'] == null
      ? null
      : PondFarm.fromJson(json['farm'] as Map<String, dynamic>),
  currentSeason: json['currentSeason'] == null
      ? null
      : PondCurrentSeason.fromJson(
          json['currentSeason'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PondToJson(_Pond instance) => <String, dynamic>{
  'id': instance.id,
  'farmId': instance.farmId,
  'name': instance.name,
  'areaM2': instance.areaM2,
  'depthM': instance.depthM,
  'volumeM3': instance.volumeM3,
  'type': _$PondTypeEnumMap[instance.type]!,
  'status': _$PondStatusEnumMap[instance.status]!,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'farm': instance.farm,
  'currentSeason': instance.currentSeason,
};

const _$PondTypeEnumMap = {
  PondType.aquaculture: 'AQUACULTURE',
  PondType.waterTreatment: 'WATER_TREATMENT',
  PondType.unknown: 'unknown',
};

const _$PondStatusEnumMap = {
  PondStatus.available: 'AVAILABLE',
  PondStatus.maintenance: 'MAINTENANCE',
  PondStatus.inactive: 'INACTIVE',
  PondStatus.unknown: 'unknown',
};
