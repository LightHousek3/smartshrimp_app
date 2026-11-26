// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HarvestPlace _$HarvestPlaceFromJson(Map<String, dynamic> json) =>
    _HarvestPlace(
      id: json['id'] as String,
      name: json['name'] as String,
      farm: json['farm'] == null
          ? null
          : HarvestPlace.fromJson(json['farm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HarvestPlaceToJson(_HarvestPlace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'farm': instance.farm,
    };

_HarvestSeason _$HarvestSeasonFromJson(Map<String, dynamic> json) =>
    _HarvestSeason(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      pond: HarvestPlace.fromJson(json['pond'] as Map<String, dynamic>),
      shrimpType: json['shrimpType'] as String?,
    );

Map<String, dynamic> _$HarvestSeasonToJson(_HarvestSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'pond': instance.pond,
      'shrimpType': instance.shrimpType,
    };

_HarvestEvent _$HarvestEventFromJson(
  Map<String, dynamic> json,
) => _HarvestEvent(
  id: json['id'] as String,
  seasonId: json['seasonId'] as String,
  harvestType: $enumDecode(
    _$HarvestTypeEnumMap,
    json['harvestType'],
    unknownValue: HarvestType.unknown,
  ),
  harvestedAt: DateTime.parse(json['harvestedAt'] as String),
  totalWeightKg: (json['totalWeightKg'] as num).toDouble(),
  recordedBy: json['recordedBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  season: HarvestSeason.fromJson(json['season'] as Map<String, dynamic>),
  quantityCount: json['quantityCount'] as String?,
  avgSizePerKg: (json['avgSizePerKg'] as num?)?.toDouble(),
  pricePerKg: (json['pricePerKg'] as num?)?.toDouble(),
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
  estimatedRemainingCount: json['estimatedRemainingCount'] as String?,
  buyerName: json['buyerName'] as String?,
  buyerContact: json['buyerContact'] as String?,
  note: json['note'] as String?,
  recorderName: json['recorderName'] as String?,
  varianceReason: json['varianceReason'] as String?,
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  canConfirmPrice: json['canConfirmPrice'] as bool? ?? false,
  speciesThresholdsEnabled: json['speciesThresholdsEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$HarvestEventToJson(_HarvestEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'harvestType': _$HarvestTypeEnumMap[instance.harvestType]!,
      'harvestedAt': instance.harvestedAt.toIso8601String(),
      'totalWeightKg': instance.totalWeightKg,
      'recordedBy': instance.recordedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'season': instance.season,
      'quantityCount': instance.quantityCount,
      'avgSizePerKg': instance.avgSizePerKg,
      'pricePerKg': instance.pricePerKg,
      'totalRevenue': instance.totalRevenue,
      'estimatedRemainingCount': instance.estimatedRemainingCount,
      'buyerName': instance.buyerName,
      'buyerContact': instance.buyerContact,
      'note': instance.note,
      'recorderName': instance.recorderName,
      'varianceReason': instance.varianceReason,
      'warnings': instance.warnings,
      'canConfirmPrice': instance.canConfirmPrice,
      'speciesThresholdsEnabled': instance.speciesThresholdsEnabled,
    };

const _$HarvestTypeEnumMap = {
  HarvestType.partial: 'PARTIAL',
  HarvestType.finalHarvest: 'FINAL',
  HarvestType.unknown: 'unknown',
};

_HarvestWithdrawal _$HarvestWithdrawalFromJson(Map<String, dynamic> json) =>
    _HarvestWithdrawal(
      verified: json['verified'] as bool,
      unknown: json['unknown'] as bool,
      blocked: json['blocked'] as bool? ?? false,
      latestEndAt: json['latestEndAt'] == null
          ? null
          : DateTime.parse(json['latestEndAt'] as String),
      warning: json['warning'] as String?,
    );

Map<String, dynamic> _$HarvestWithdrawalToJson(_HarvestWithdrawal instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'unknown': instance.unknown,
      'blocked': instance.blocked,
      'latestEndAt': instance.latestEndAt?.toIso8601String(),
      'warning': instance.warning,
    };

_PendingHarvestSubmission _$PendingHarvestSubmissionFromJson(
  Map<String, dynamic> json,
) => _PendingHarvestSubmission(
  key: json['key'] as String,
  body: json['body'] as Map<String, dynamic>,
);

Map<String, dynamic> _$PendingHarvestSubmissionToJson(
  _PendingHarvestSubmission instance,
) => <String, dynamic>{'key': instance.key, 'body': instance.body};
