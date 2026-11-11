// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_disease_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiseaseCaseCard _$DiseaseCaseCardFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DiseaseCaseCard', json, ($checkedConvert) {
      final val = _DiseaseCaseCard(
        id: $checkedConvert('id', (v) => _requiredText(v)),
        title: $checkedConvert('title', (v) => _requiredText(v)),
        description: $checkedConvert('description', (v) => _requiredText(v)),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$DiseaseCaseStatusEnumMap,
            v,
            unknownValue: DiseaseCaseStatus.unknown,
          ),
        ),
        severity: $checkedConvert(
          'severity',
          (v) => $enumDecode(
            _$DiseaseCaseSeverityEnumMap,
            v,
            unknownValue: DiseaseCaseSeverity.unknown,
          ),
        ),
        expertName: $checkedConvert('expertName', (v) => _requiredText(v)),
        responseCount: $checkedConvert('responseCount', (v) => _count(v)),
        aiDiagnosis: $checkedConvert('aiDiagnosis', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DiseaseCaseCardToJson(_DiseaseCaseCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$DiseaseCaseStatusEnumMap[instance.status]!,
      'severity': _$DiseaseCaseSeverityEnumMap[instance.severity]!,
      'expertName': instance.expertName,
      'responseCount': instance.responseCount,
      'aiDiagnosis': instance.aiDiagnosis,
    };

const _$DiseaseCaseStatusEnumMap = {
  DiseaseCaseStatus.open: 'OPEN',
  DiseaseCaseStatus.waitingForInfo: 'WAITING_FOR_INFO',
  DiseaseCaseStatus.monitoring: 'MONITORING',
  DiseaseCaseStatus.inTreatment: 'IN_TREATMENT',
  DiseaseCaseStatus.resolved: 'RESOLVED',
  DiseaseCaseStatus.unknown: 'unknown',
};

const _$DiseaseCaseSeverityEnumMap = {
  DiseaseCaseSeverity.low: 'LOW',
  DiseaseCaseSeverity.medium: 'MEDIUM',
  DiseaseCaseSeverity.high: 'HIGH',
  DiseaseCaseSeverity.critical: 'CRITICAL',
  DiseaseCaseSeverity.unknown: 'unknown',
};

_DiseaseCasePage _$DiseaseCasePageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DiseaseCasePage', json, ($checkedConvert) {
      final val = _DiseaseCasePage(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => DiseaseCaseCard.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        seasonName: $checkedConvert('seasonName', (v) => _requiredText(v)),
        pondName: $checkedConvert('pondName', (v) => _requiredText(v)),
        page: $checkedConvert('page', (v) => _positiveInt(v)),
        hasNextPage: $checkedConvert('hasNextPage', (v) => v as bool),
        activeCount: $checkedConvert('activeCount', (v) => _count(v)),
        resolvedCount: $checkedConvert('resolvedCount', (v) => _count(v)),
      );
      return val;
    });

Map<String, dynamic> _$DiseaseCasePageToJson(_DiseaseCasePage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'seasonName': instance.seasonName,
      'pondName': instance.pondName,
      'page': instance.page,
      'hasNextPage': instance.hasNextPage,
      'activeCount': instance.activeCount,
      'resolvedCount': instance.resolvedCount,
    };

_DiseaseCaseDetail _$DiseaseCaseDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DiseaseCaseDetail', json, ($checkedConvert) {
  final val = _DiseaseCaseDetail(
    card: $checkedConvert(
      'card',
      (v) => DiseaseCaseCard.fromJson(v as Map<String, dynamic>),
    ),
    seasonName: $checkedConvert('seasonName', (v) => _requiredText(v)),
    pondName: $checkedConvert('pondName', (v) => _requiredText(v)),
    farmName: $checkedConvert('farmName', (v) => _requiredText(v)),
    reporterName: $checkedConvert('reporterName', (v) => _requiredText(v)),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    attachments: $checkedConvert(
      'attachments',
      (v) => (v as List<dynamic>)
          .map((e) => DiseaseCaseAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    protocols: $checkedConvert(
      'protocols',
      (v) => (v as List<dynamic>)
          .map((e) => DiseaseCaseProtocol.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    timeline: $checkedConvert(
      'timeline',
      (v) => (v as List<dynamic>)
          .map((e) => DiseaseCaseEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    snapshot: $checkedConvert(
      'snapshot',
      (v) => v == null
          ? null
          : DiseaseCaseSnapshot.fromJson(v as Map<String, dynamic>),
    ),
    resolutionSummary: $checkedConvert(
      'resolutionSummary',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DiseaseCaseDetailToJson(_DiseaseCaseDetail instance) =>
    <String, dynamic>{
      'card': instance.card,
      'seasonName': instance.seasonName,
      'pondName': instance.pondName,
      'farmName': instance.farmName,
      'reporterName': instance.reporterName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'attachments': instance.attachments,
      'protocols': instance.protocols,
      'timeline': instance.timeline,
      'snapshot': instance.snapshot,
      'resolutionSummary': instance.resolutionSummary,
    };

_DiseaseCaseSnapshot _$DiseaseCaseSnapshotFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DiseaseCaseSnapshot', json, ($checkedConvert) {
      final val = _DiseaseCaseSnapshot(
        exceededWaterMetrics: $checkedConvert(
          'exceededWaterMetrics',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        capturedAt: $checkedConvert(
          'capturedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        healthStatus: $checkedConvert(
          'healthStatus',
          (v) => $enumDecodeNullable(
            _$OpeningHealthStatusEnumMap,
            v,
            unknownValue: JsonKey.nullForUndefinedEnumValue,
          ),
        ),
        note: $checkedConvert('note', (v) => v as String?),
        avgWeightG: $checkedConvert('avgWeightG', (v) => v as num?),
        mortalityCount: $checkedConvert('mortalityCount', (v) => v as num?),
        ph: $checkedConvert('ph', (v) => v as num?),
        no2MgL: $checkedConvert('no2MgL', (v) => v as num?),
        nh3MgL: $checkedConvert('nh3MgL', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$DiseaseCaseSnapshotToJson(
  _DiseaseCaseSnapshot instance,
) => <String, dynamic>{
  'exceededWaterMetrics': instance.exceededWaterMetrics,
  'capturedAt': instance.capturedAt?.toIso8601String(),
  'healthStatus': _$OpeningHealthStatusEnumMap[instance.healthStatus],
  'note': instance.note,
  'avgWeightG': instance.avgWeightG,
  'mortalityCount': instance.mortalityCount,
  'ph': instance.ph,
  'no2MgL': instance.no2MgL,
  'nh3MgL': instance.nh3MgL,
};

const _$OpeningHealthStatusEnumMap = {
  OpeningHealthStatus.excellent: 'EXCELLENT',
  OpeningHealthStatus.good: 'GOOD',
  OpeningHealthStatus.warning: 'WARNING',
  OpeningHealthStatus.critical: 'CRITICAL',
};

_DiseaseCaseAttachment _$DiseaseCaseAttachmentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DiseaseCaseAttachment', json, ($checkedConvert) {
  final val = _DiseaseCaseAttachment(
    fileUrl: $checkedConvert('fileUrl', (v) => _requiredText(v)),
    uploaderName: $checkedConvert('uploaderName', (v) => _requiredText(v)),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    mediaType: $checkedConvert('mediaType', (v) => v as String?),
    caption: $checkedConvert('caption', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DiseaseCaseAttachmentToJson(
  _DiseaseCaseAttachment instance,
) => <String, dynamic>{
  'fileUrl': instance.fileUrl,
  'uploaderName': instance.uploaderName,
  'createdAt': instance.createdAt.toIso8601String(),
  'mediaType': instance.mediaType,
  'caption': instance.caption,
};

_DiseaseCaseProtocol _$DiseaseCaseProtocolFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DiseaseCaseProtocol', json, ($checkedConvert) {
      final val = _DiseaseCaseProtocol(
        id: $checkedConvert('id', (v) => _requiredText(v)),
        title: $checkedConvert('title', (v) => _requiredText(v)),
        versionNo: $checkedConvert('versionNo', (v) => _positiveInt(v)),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$ProtocolStatusEnumMap,
            v,
            unknownValue: ProtocolStatus.unknown,
          ),
        ),
        summary: $checkedConvert('summary', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DiseaseCaseProtocolToJson(
  _DiseaseCaseProtocol instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'versionNo': instance.versionNo,
  'status': _$ProtocolStatusEnumMap[instance.status]!,
  'summary': instance.summary,
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

DiseaseCaseStatusChange _$DiseaseCaseStatusChangeFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DiseaseCaseStatusChange', json, ($checkedConvert) {
  final val = DiseaseCaseStatusChange(
    at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
    authorName: $checkedConvert('authorName', (v) => _requiredText(v)),
    toStatus: $checkedConvert(
      'toStatus',
      (v) => $enumDecode(
        _$DiseaseCaseStatusEnumMap,
        v,
        unknownValue: DiseaseCaseStatus.unknown,
      ),
    ),
    fromStatus: $checkedConvert(
      'fromStatus',
      (v) => $enumDecodeNullable(
        _$DiseaseCaseStatusEnumMap,
        v,
        unknownValue: DiseaseCaseStatus.unknown,
      ),
    ),
    message: $checkedConvert('message', (v) => v as String?),
    $type: $checkedConvert('kind', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$DiseaseCaseStatusChangeToJson(
  DiseaseCaseStatusChange instance,
) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'authorName': instance.authorName,
  'toStatus': _$DiseaseCaseStatusEnumMap[instance.toStatus]!,
  'fromStatus': _$DiseaseCaseStatusEnumMap[instance.fromStatus],
  'message': instance.message,
  'kind': instance.$type,
};

DiseaseCaseResponse _$DiseaseCaseResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiseaseCaseResponse', json, ($checkedConvert) {
      final val = DiseaseCaseResponse(
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        authorName: $checkedConvert('authorName', (v) => _requiredText(v)),
        authorRole: $checkedConvert(
          'authorRole',
          (v) => $enumDecode(
            _$AccountRoleEnumMap,
            v,
            unknownValue: AccountRole.unknown,
          ),
        ),
        responseType: $checkedConvert(
          'responseType',
          (v) => $enumDecode(
            _$DiseaseCaseResponseTypeEnumMap,
            v,
            unknownValue: DiseaseCaseResponseType.unknown,
          ),
        ),
        message: $checkedConvert('message', (v) => _requiredText(v)),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$DiseaseCaseResponseToJson(
  DiseaseCaseResponse instance,
) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'authorName': instance.authorName,
  'authorRole': _$AccountRoleEnumMap[instance.authorRole]!,
  'responseType': _$DiseaseCaseResponseTypeEnumMap[instance.responseType]!,
  'message': instance.message,
  'kind': instance.$type,
};

const _$AccountRoleEnumMap = {
  AccountRole.technician: 'TECHNICIAN',
  AccountRole.farmOwner: 'FARM_OWNER',
  AccountRole.expert: 'EXPERT',
  AccountRole.admin: 'ADMIN',
  AccountRole.unknown: 'UNKNOWN',
};

const _$DiseaseCaseResponseTypeEnumMap = {
  DiseaseCaseResponseType.requestInfo: 'REQUEST_INFO',
  DiseaseCaseResponseType.provideInfo: 'PROVIDE_INFO',
  DiseaseCaseResponseType.monitoringResult: 'MONITORING_RESULT',
  DiseaseCaseResponseType.treatmentResult: 'TREATMENT_RESULT',
  DiseaseCaseResponseType.emergencyAlert: 'EMERGENCY_ALERT',
  DiseaseCaseResponseType.expertAssessment: 'EXPERT_ASSESSMENT',
  DiseaseCaseResponseType.expertInstruction: 'EXPERT_INSTRUCTION',
  DiseaseCaseResponseType.resolution: 'RESOLUTION',
  DiseaseCaseResponseType.unknown: 'unknown',
};
