// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProtocolCardData _$ProtocolCardDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProtocolCardData', json, ($checkedConvert) {
      final val = _ProtocolCardData(
        id: $checkedConvert('id', (v) => v as String),
        seasonId: $checkedConvert('seasonId', (v) => v as String),
        protocolType: $checkedConvert(
          'protocolType',
          (v) => $enumDecode(
            _$ProtocolTypeEnumMap,
            v,
            unknownValue: ProtocolType.unknown,
          ),
        ),
        title: $checkedConvert('title', (v) => v as String),
        summary: $checkedConvert('summary', (v) => v as String?),
        versionNo: $checkedConvert('versionNo', (v) => (v as num).toInt()),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$ProtocolStatusEnumMap,
            v,
            unknownValue: ProtocolStatus.unknown,
          ),
        ),
        authorName: $checkedConvert('authorName', (v) => v as String),
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        diseaseCaseId: $checkedConvert('diseaseCaseId', (v) => v as String?),
        diseaseCaseTitle: $checkedConvert(
          'diseaseCaseTitle',
          (v) => v as String?,
        ),
        seasonName: $checkedConvert('seasonName', (v) => v as String),
        pondName: $checkedConvert('pondName', (v) => v as String),
        farmName: $checkedConvert('farmName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ProtocolCardDataToJson(_ProtocolCardData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'protocolType': _$ProtocolTypeEnumMap[instance.protocolType]!,
      'title': instance.title,
      'summary': instance.summary,
      'versionNo': instance.versionNo,
      'status': _$ProtocolStatusEnumMap[instance.status]!,
      'authorName': instance.authorName,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'diseaseCaseId': instance.diseaseCaseId,
      'diseaseCaseTitle': instance.diseaseCaseTitle,
      'seasonName': instance.seasonName,
      'pondName': instance.pondName,
      'farmName': instance.farmName,
    };

const _$ProtocolTypeEnumMap = {
  ProtocolType.production: 'PRODUCTION',
  ProtocolType.treatment: 'TREATMENT',
  ProtocolType.unknown: 'UNKNOWN',
};

const _$ProtocolStatusEnumMap = {
  ProtocolStatus.draft: 'DRAFT',
  ProtocolStatus.pendingApproval: 'PENDING_APPROVAL',
  ProtocolStatus.approved: 'APPROVED',
  ProtocolStatus.rejected: 'REJECTED',
  ProtocolStatus.superseded: 'SUPERSEDED',
  ProtocolStatus.cancelled: 'CANCELLED',
  ProtocolStatus.aborted: 'ABORTED',
  ProtocolStatus.unknown: 'UNKNOWN',
};

_ProtocolHistory _$ProtocolHistoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProtocolHistory', json, ($checkedConvert) {
      final val = _ProtocolHistory(
        id: $checkedConvert('id', (v) => v as String),
        fromStatus: $checkedConvert(
          'fromStatus',
          (v) => $enumDecodeNullable(
            _$ProtocolStatusEnumMap,
            v,
            unknownValue: ProtocolStatus.unknown,
          ),
        ),
        toStatus: $checkedConvert(
          'toStatus',
          (v) => $enumDecode(
            _$ProtocolStatusEnumMap,
            v,
            unknownValue: ProtocolStatus.unknown,
          ),
        ),
        changedByName: $checkedConvert('changedByName', (v) => v as String),
        changedAt: $checkedConvert(
          'changedAt',
          (v) => DateTime.parse(v as String),
        ),
        reason: $checkedConvert('reason', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ProtocolHistoryToJson(_ProtocolHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromStatus': _$ProtocolStatusEnumMap[instance.fromStatus],
      'toStatus': _$ProtocolStatusEnumMap[instance.toStatus]!,
      'changedByName': instance.changedByName,
      'changedAt': instance.changedAt.toIso8601String(),
      'reason': instance.reason,
    };

_ProtocolDayMarker _$ProtocolDayMarkerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProtocolDayMarker', json, ($checkedConvert) {
      final val = _ProtocolDayMarker(
        day: $checkedConvert('day', (v) => (v as num).toInt()),
        completed: $checkedConvert('completed', (v) => (v as num).toInt()),
        planned: $checkedConvert('planned', (v) => (v as num).toInt()),
        cancelled: $checkedConvert('cancelled', (v) => (v as num).toInt()),
        issues: $checkedConvert('issues', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ProtocolDayMarkerToJson(_ProtocolDayMarker instance) =>
    <String, dynamic>{
      'day': instance.day,
      'completed': instance.completed,
      'planned': instance.planned,
      'cancelled': instance.cancelled,
      'issues': instance.issues,
    };

_ProtocolDetail _$ProtocolDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ProtocolDetail', json, ($checkedConvert) {
  final val = _ProtocolDetail(
    card: $checkedConvert(
      'card',
      (v) => ProtocolCardData.fromJson(v as Map<String, dynamic>),
    ),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    anchorDate: $checkedConvert('anchorDate', (v) => v as String?),
    durationDays: $checkedConvert('durationDays', (v) => (v as num).toInt()),
    reviewedAt: $checkedConvert(
      'reviewedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    reviewerName: $checkedConvert('reviewerName', (v) => v as String?),
    rejectionReason: $checkedConvert('rejectionReason', (v) => v as String?),
    supersededAt: $checkedConvert(
      'supersededAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    dayMarkers: $checkedConvert(
      'dayMarkers',
      (v) => (v as List<dynamic>)
          .map((e) => ProtocolDayMarker.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    history: $checkedConvert(
      'history',
      (v) => (v as List<dynamic>)
          .map((e) => ProtocolHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    canReview: $checkedConvert('canReview', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$ProtocolDetailToJson(_ProtocolDetail instance) =>
    <String, dynamic>{
      'card': instance.card,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'anchorDate': instance.anchorDate,
      'durationDays': instance.durationDays,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewerName': instance.reviewerName,
      'rejectionReason': instance.rejectionReason,
      'supersededAt': instance.supersededAt?.toIso8601String(),
      'dayMarkers': instance.dayMarkers,
      'history': instance.history,
      'canReview': instance.canReview,
    };

_ProtocolDayRow _$ProtocolDayRowFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProtocolDayRow', json, ($checkedConvert) {
      final val = _ProtocolDayRow(
        itemId: $checkedConvert('itemId', (v) => v as String),
        operationType: $checkedConvert('operationType', (v) => v as String),
        productName: $checkedConvert('productName', (v) => v as String),
        time: $checkedConvert('time', (v) => v as String?),
        doseBasis: $checkedConvert('doseBasis', (v) => v as String),
        doseValue: $checkedConvert('doseValue', (v) => (v as num).toDouble()),
        doseUnit: $checkedConvert('doseUnit', (v) => v as String),
        instructions: $checkedConvert('instructions', (v) => v as String?),
        scheduleId: $checkedConvert('scheduleId', (v) => v as String?),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$ProtocolOperationStatusEnumMap,
            v,
            unknownValue: ProtocolOperationStatus.unknown,
          ),
        ),
        plannedQuantity: $checkedConvert(
          'plannedQuantity',
          (v) => (v as num?)?.toDouble(),
        ),
        unit: $checkedConvert('unit', (v) => v as String),
        basisQuantity: $checkedConvert(
          'basisQuantity',
          (v) => (v as num?)?.toDouble(),
        ),
        basisUnit: $checkedConvert('basisUnit', (v) => v as String?),
        actualQuantity: $checkedConvert(
          'actualQuantity',
          (v) => (v as num?)?.toDouble(),
        ),
        actualProductName: $checkedConvert(
          'actualProductName',
          (v) => v as String?,
        ),
        actualUnit: $checkedConvert('actualUnit', (v) => v as String?),
        varianceReason: $checkedConvert('varianceReason', (v) => v as String?),
        executorName: $checkedConvert('executorName', (v) => v as String?),
        executedAt: $checkedConvert(
          'executedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        cancellationReason: $checkedConvert(
          'cancellationReason',
          (v) => v as String?,
        ),
        cancelledAt: $checkedConvert(
          'cancelledAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProtocolDayRowToJson(_ProtocolDayRow instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'operationType': instance.operationType,
      'productName': instance.productName,
      'time': instance.time,
      'doseBasis': instance.doseBasis,
      'doseValue': instance.doseValue,
      'doseUnit': instance.doseUnit,
      'instructions': instance.instructions,
      'scheduleId': instance.scheduleId,
      'status': _$ProtocolOperationStatusEnumMap[instance.status]!,
      'plannedQuantity': instance.plannedQuantity,
      'unit': instance.unit,
      'basisQuantity': instance.basisQuantity,
      'basisUnit': instance.basisUnit,
      'actualQuantity': instance.actualQuantity,
      'actualProductName': instance.actualProductName,
      'actualUnit': instance.actualUnit,
      'varianceReason': instance.varianceReason,
      'executorName': instance.executorName,
      'executedAt': instance.executedAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
    };

const _$ProtocolOperationStatusEnumMap = {
  ProtocolOperationStatus.completed: 'COMPLETED',
  ProtocolOperationStatus.planned: 'PLANNED',
  ProtocolOperationStatus.cancelled: 'CANCELLED',
  ProtocolOperationStatus.pendingApproval: 'PENDING_APPROVAL',
  ProtocolOperationStatus.notGenerated: 'NOT_GENERATED',
  ProtocolOperationStatus.unknown: 'UNKNOWN',
};

_ProtocolDay _$ProtocolDayFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProtocolDay', json, ($checkedConvert) {
      final val = _ProtocolDay(
        day: $checkedConvert('day', (v) => (v as num).toInt()),
        date: $checkedConvert('date', (v) => v as String?),
        rows: $checkedConvert(
          'rows',
          (v) => (v as List<dynamic>)
              .map((e) => ProtocolDayRow.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProtocolDayToJson(_ProtocolDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'rows': instance.rows,
    };

_ProtocolInventoryEntry _$ProtocolInventoryEntryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ProtocolInventoryEntry', json, ($checkedConvert) {
  final val = _ProtocolInventoryEntry(
    id: $checkedConvert('id', (v) => v as String),
    productName: $checkedConvert('productName', (v) => v as String),
    lotNumber: $checkedConvert('lotNumber', (v) => v as String),
    quantity: $checkedConvert('quantity', (v) => (v as num).toDouble()),
    unit: $checkedConvert('unit', (v) => v as String),
    performedByName: $checkedConvert('performedByName', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    reason: $checkedConvert('reason', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ProtocolInventoryEntryToJson(
  _ProtocolInventoryEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'productName': instance.productName,
  'lotNumber': instance.lotNumber,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'performedByName': instance.performedByName,
  'createdAt': instance.createdAt.toIso8601String(),
  'reason': instance.reason,
};
