// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechnicianSummary _$TechnicianSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TechnicianSummary', json, ($checkedConvert) {
      final val = _TechnicianSummary(
        activeSeasonCount: $checkedConvert(
          'activeSeasonCount',
          (v) => (v as num).toInt(),
        ),
        openTaskCount: $checkedConvert(
          'openTaskCount',
          (v) => (v as num).toInt(),
        ),
        unresolvedActiveSeasonCaseCount: $checkedConvert(
          'unresolvedActiveSeasonCaseCount',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TechnicianSummaryToJson(
  _TechnicianSummary instance,
) => <String, dynamic>{
  'activeSeasonCount': instance.activeSeasonCount,
  'openTaskCount': instance.openTaskCount,
  'unresolvedActiveSeasonCaseCount': instance.unresolvedActiveSeasonCaseCount,
};

_TechnicianWaterMetric _$TechnicianWaterMetricFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TechnicianWaterMetric', json, ($checkedConvert) {
  final val = _TechnicianWaterMetric(
    field: $checkedConvert('field', (v) => v as String),
    value: $checkedConvert('value', (v) => (v as num).toDouble()),
    unit: $checkedConvert('unit', (v) => v as String),
    recordedAt: $checkedConvert(
      'recordedAt',
      (v) => DateTime.parse(v as String),
    ),
    min: $checkedConvert('min', (v) => (v as num?)?.toDouble()),
    max: $checkedConvert('max', (v) => (v as num?)?.toDouble()),
  );
  return val;
});

Map<String, dynamic> _$TechnicianWaterMetricToJson(
  _TechnicianWaterMetric instance,
) => <String, dynamic>{
  'field': instance.field,
  'value': instance.value,
  'unit': instance.unit,
  'recordedAt': instance.recordedAt.toIso8601String(),
  'min': instance.min,
  'max': instance.max,
};

_TechnicianAlert _$TechnicianAlertFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TechnicianAlert', json, ($checkedConvert) {
  final val = _TechnicianAlert(
    id: $checkedConvert('id', (v) => v as String),
    kind: $checkedConvert(
      'kind',
      (v) => $enumDecode(
        _$TechnicianAlertKindEnumMap,
        v,
        unknownValue: TechnicianAlertKind.unknown,
      ),
    ),
    seasonId: $checkedConvert('seasonId', (v) => v as String),
    seasonName: $checkedConvert('seasonName', (v) => v as String),
    pondName: $checkedConvert('pondName', (v) => v as String),
    farmName: $checkedConvert('farmName', (v) => v as String),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    observedAt: $checkedConvert(
      'observedAt',
      (v) => DateTime.parse(v as String),
    ),
    metrics: $checkedConvert(
      'metrics',
      (v) =>
          (v as List<dynamic>?)
              ?.map(
                (e) =>
                    TechnicianWaterMetric.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    ),
    reasonCodes: $checkedConvert(
      'reasonCodes',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$TechnicianAlertToJson(_TechnicianAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$TechnicianAlertKindEnumMap[instance.kind]!,
      'seasonId': instance.seasonId,
      'seasonName': instance.seasonName,
      'pondName': instance.pondName,
      'farmName': instance.farmName,
      'count': instance.count,
      'observedAt': instance.observedAt.toIso8601String(),
      'metrics': instance.metrics,
      'reasonCodes': instance.reasonCodes,
    };

const _$TechnicianAlertKindEnumMap = {
  TechnicianAlertKind.water: 'WATER',
  TechnicianAlertKind.overdueOperations: 'OVERDUE_OPERATIONS',
  TechnicianAlertKind.scheduleBlocked: 'SCHEDULE_BLOCKED',
  TechnicianAlertKind.unknown: 'unknown',
};

_TechnicianOperation _$TechnicianOperationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TechnicianOperation', json, ($checkedConvert) {
      final val = _TechnicianOperation(
        id: $checkedConvert('id', (v) => v as String),
        operationType: $checkedConvert('operationType', (v) => v as String),
        scheduledAt: $checkedConvert(
          'scheduledAt',
          (v) => DateTime.parse(v as String),
        ),
        plannedQuantity: $checkedConvert(
          'plannedQuantity',
          (v) => (v as num).toDouble(),
        ),
        unit: $checkedConvert('unit', (v) => v as String),
        productName: $checkedConvert('productName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$TechnicianOperationToJson(
  _TechnicianOperation instance,
) => <String, dynamic>{
  'id': instance.id,
  'operationType': instance.operationType,
  'scheduledAt': instance.scheduledAt.toIso8601String(),
  'plannedQuantity': instance.plannedQuantity,
  'unit': instance.unit,
  'productName': instance.productName,
};

_TechnicianOperationGroup _$TechnicianOperationGroupFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TechnicianOperationGroup', json, ($checkedConvert) {
  final val = _TechnicianOperationGroup(
    seasonId: $checkedConvert('seasonId', (v) => v as String),
    seasonName: $checkedConvert('seasonName', (v) => v as String),
    pondName: $checkedConvert('pondName', (v) => v as String),
    farmName: $checkedConvert('farmName', (v) => v as String),
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => TechnicianOperation.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TechnicianOperationGroupToJson(
  _TechnicianOperationGroup instance,
) => <String, dynamic>{
  'seasonId': instance.seasonId,
  'seasonName': instance.seasonName,
  'pondName': instance.pondName,
  'farmName': instance.farmName,
  'items': instance.items,
};

_TechnicianSeasonSnapshot _$TechnicianSeasonSnapshotFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TechnicianSeasonSnapshot', json, ($checkedConvert) {
  final val = _TechnicianSeasonSnapshot(
    seasonId: $checkedConvert('seasonId', (v) => v as String),
    seasonName: $checkedConvert('seasonName', (v) => v as String),
    pondName: $checkedConvert('pondName', (v) => v as String),
    farmName: $checkedConvert('farmName', (v) => v as String),
    biomassState: $checkedConvert(
      'biomassState',
      (v) => $enumDecode(
        _$BiomassSnapshotStateEnumMap,
        v,
        unknownValue: BiomassSnapshotState.unknown,
      ),
    ),
    cultureDay: $checkedConvert('cultureDay', (v) => (v as num?)?.toInt()),
    biomassKg: $checkedConvert('biomassKg', (v) => (v as num?)?.toDouble()),
    biomassRecordedAt: $checkedConvert(
      'biomassRecordedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$TechnicianSeasonSnapshotToJson(
  _TechnicianSeasonSnapshot instance,
) => <String, dynamic>{
  'seasonId': instance.seasonId,
  'seasonName': instance.seasonName,
  'pondName': instance.pondName,
  'farmName': instance.farmName,
  'biomassState': _$BiomassSnapshotStateEnumMap[instance.biomassState]!,
  'cultureDay': instance.cultureDay,
  'biomassKg': instance.biomassKg,
  'biomassRecordedAt': instance.biomassRecordedAt?.toIso8601String(),
};

const _$BiomassSnapshotStateEnumMap = {
  BiomassSnapshotState.missing: 'MISSING',
  BiomassSnapshotState.recorded: 'RECORDED',
  BiomassSnapshotState.stale: 'STALE',
  BiomassSnapshotState.afterHarvest: 'AFTER_HARVEST',
  BiomassSnapshotState.populationChanged: 'POPULATION_CHANGED',
  BiomassSnapshotState.unknown: 'unknown',
};

_TechnicianDashboard _$TechnicianDashboardFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TechnicianDashboard', json, ($checkedConvert) {
  final val = _TechnicianDashboard(
    date: $checkedConvert('date', (v) => v as String),
    serverNow: $checkedConvert('serverNow', (v) => DateTime.parse(v as String)),
    dayEndExclusive: $checkedConvert(
      'dayEndExclusive',
      (v) => DateTime.parse(v as String),
    ),
    summary: $checkedConvert(
      'summary',
      (v) => TechnicianSummary.fromJson(v as Map<String, dynamic>),
    ),
    alerts: $checkedConvert(
      'alerts',
      (v) => (v as List<dynamic>)
          .map((e) => TechnicianAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    tasks: $checkedConvert(
      'tasks',
      (v) => (v as List<dynamic>)
          .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    operationGroups: $checkedConvert(
      'operationGroups',
      (v) => (v as List<dynamic>)
          .map(
            (e) => TechnicianOperationGroup.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    seasons: $checkedConvert(
      'seasons',
      (v) => (v as List<dynamic>)
          .map(
            (e) => TechnicianSeasonSnapshot.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TechnicianDashboardToJson(
  _TechnicianDashboard instance,
) => <String, dynamic>{
  'date': instance.date,
  'serverNow': instance.serverNow.toIso8601String(),
  'dayEndExclusive': instance.dayEndExclusive.toIso8601String(),
  'summary': instance.summary,
  'alerts': instance.alerts,
  'tasks': instance.tasks,
  'operationGroups': instance.operationGroups,
  'seasons': instance.seasons,
};
