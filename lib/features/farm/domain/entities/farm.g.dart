// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmCurrentSeason _$FarmCurrentSeasonFromJson(Map<String, dynamic> json) =>
    _FarmCurrentSeason(
      id: json['id'] as String,
      status: $enumDecode(
        _$FarmSeasonStatusEnumMap,
        json['status'],
        unknownValue: FarmSeasonStatus.unknown,
      ),
      stockingDate: json['stockingDate'] == null
          ? null
          : DateTime.parse(json['stockingDate'] as String),
      dayOfCulture: (json['dayOfCulture'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FarmCurrentSeasonToJson(_FarmCurrentSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$FarmSeasonStatusEnumMap[instance.status]!,
      'stockingDate': instance.stockingDate?.toIso8601String(),
      'dayOfCulture': instance.dayOfCulture,
    };

const _$FarmSeasonStatusEnumMap = {
  FarmSeasonStatus.planning: 'PLANNING',
  FarmSeasonStatus.active: 'ACTIVE',
  FarmSeasonStatus.unknown: 'unknown',
};

_FarmPond _$FarmPondFromJson(Map<String, dynamic> json) => _FarmPond(
  id: json['id'] as String,
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
  currentSeason: json['currentSeason'] == null
      ? null
      : FarmCurrentSeason.fromJson(
          json['currentSeason'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FarmPondToJson(_FarmPond instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'areaM2': instance.areaM2,
  'depthM': instance.depthM,
  'volumeM3': instance.volumeM3,
  'type': _$PondTypeEnumMap[instance.type]!,
  'status': _$PondStatusEnumMap[instance.status]!,
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

_Farm _$FarmFromJson(Map<String, dynamic> json) => _Farm(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  totalAreaHectares: (json['totalAreaHectares'] as num?)?.toDouble(),
  pondCount: (json['pondCount'] as num?)?.toInt() ?? 0,
  activeSeasonCount: (json['activeSeasonCount'] as num?)?.toInt() ?? 0,
  canDelete: json['canDelete'] as bool? ?? true,
  ponds:
      (json['ponds'] as List<dynamic>?)
          ?.map((e) => FarmPond.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FarmPond>[],
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FarmToJson(_Farm instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'totalAreaHectares': instance.totalAreaHectares,
  'pondCount': instance.pondCount,
  'activeSeasonCount': instance.activeSeasonCount,
  'canDelete': instance.canDelete,
  'ponds': instance.ponds,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
