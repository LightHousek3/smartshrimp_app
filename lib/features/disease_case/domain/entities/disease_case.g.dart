// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CaseCreationOptions _$CaseCreationOptionsFromJson(Map<String, dynamic> json) =>
    _CaseCreationOptions(
      relatedCases:
          (json['relatedCases'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      aiDiagnoses:
          (json['aiDiagnoses'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CaseCreationOptionsToJson(
  _CaseCreationOptions instance,
) => <String, dynamic>{
  'relatedCases': instance.relatedCases,
  'aiDiagnoses': instance.aiDiagnoses,
};

_CaseResponse _$CaseResponseFromJson(Map<String, dynamic> json) =>
    _CaseResponse(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      responseType: $enumDecode(
        _$CaseResponseTypeEnumMap,
        json['responseType'],
        unknownValue: CaseResponseType.unknown,
      ),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: json['author'] as Map<String, dynamic>?,
      attachments: json['attachments'] == null
          ? const []
          : _responseAttachmentUrls(json['attachments']),
    );

Map<String, dynamic> _$CaseResponseToJson(_CaseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'responseType': _$CaseResponseTypeEnumMap[instance.responseType]!,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'author': instance.author,
      'attachments': instance.attachments,
    };

const _$CaseResponseTypeEnumMap = {
  CaseResponseType.provideInfo: 'PROVIDE_INFO',
  CaseResponseType.monitoringResult: 'MONITORING_RESULT',
  CaseResponseType.treatmentResult: 'TREATMENT_RESULT',
  CaseResponseType.emergencyAlert: 'EMERGENCY_ALERT',
  CaseResponseType.requestInfo: 'REQUEST_INFO',
  CaseResponseType.assessment: 'EXPERT_ASSESSMENT',
  CaseResponseType.instruction: 'EXPERT_INSTRUCTION',
  CaseResponseType.resolution: 'RESOLUTION',
  CaseResponseType.unknown: 'unknown',
};

_DiseaseCase _$DiseaseCaseFromJson(Map<String, dynamic> json) => _DiseaseCase(
  id: json['id'] as String,
  seasonId: json['seasonId'] as String,
  title: json['title'] as String,
  status: $enumDecode(
    _$DiseaseCaseStatusEnumMap,
    json['status'],
    unknownValue: DiseaseCaseStatus.unknown,
  ),
  severity: $enumDecode(
    _$CaseSeverityEnumMap,
    json['severity'],
    unknownValue: CaseSeverity.unknown,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  description: json['description'] as String?,
  resolutionSummary: json['resolutionSummary'] as String?,
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  reportedBy: json['reportedBy'] as String?,
  expertId: json['expertId'] as String?,
  relatedCaseId: json['relatedCaseId'] as String?,
  expert: json['expert'] as Map<String, dynamic>?,
  reporter: json['reporter'] as Map<String, dynamic>?,
  counts: json['_count'] as Map<String, dynamic>? ?? const {},
  canRespond: json['canRespond'] as bool? ?? false,
  caseSnapshot: json['caseSnapshot'] as Map<String, dynamic>? ?? const {},
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  responses:
      (json['responses'] as List<dynamic>?)
          ?.map((e) => CaseResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  statusHistory:
      (json['statusHistory'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
);

Map<String, dynamic> _$DiseaseCaseToJson(_DiseaseCase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'title': instance.title,
      'status': _$DiseaseCaseStatusEnumMap[instance.status]!,
      'severity': _$CaseSeverityEnumMap[instance.severity]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'resolutionSummary': instance.resolutionSummary,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'reportedBy': instance.reportedBy,
      'expertId': instance.expertId,
      'relatedCaseId': instance.relatedCaseId,
      'expert': instance.expert,
      'reporter': instance.reporter,
      '_count': instance.counts,
      'canRespond': instance.canRespond,
      'caseSnapshot': instance.caseSnapshot,
      'attachments': instance.attachments,
      'responses': instance.responses,
      'statusHistory': instance.statusHistory,
    };

const _$DiseaseCaseStatusEnumMap = {
  DiseaseCaseStatus.open: 'OPEN',
  DiseaseCaseStatus.waitingForInfo: 'WAITING_FOR_INFO',
  DiseaseCaseStatus.monitoring: 'MONITORING',
  DiseaseCaseStatus.inTreatment: 'IN_TREATMENT',
  DiseaseCaseStatus.resolved: 'RESOLVED',
  DiseaseCaseStatus.unknown: 'unknown',
};

const _$CaseSeverityEnumMap = {
  CaseSeverity.low: 'LOW',
  CaseSeverity.medium: 'MEDIUM',
  CaseSeverity.high: 'HIGH',
  CaseSeverity.critical: 'CRITICAL',
  CaseSeverity.unknown: 'unknown',
};

_DiseaseCasePage _$DiseaseCasePageFromJson(Map<String, dynamic> json) =>
    _DiseaseCasePage(
      items: (json['items'] as List<dynamic>)
          .map((e) => DiseaseCase.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      totalResults: (json['totalResults'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      canCreate: json['canCreate'] as bool,
      existingCaseId: json['existingCaseId'] as String?,
      ongoingCount: (json['ongoingCount'] as num?)?.toInt() ?? 0,
      resolvedCount: (json['resolvedCount'] as num?)?.toInt() ?? 0,
      season: json['season'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$DiseaseCasePageToJson(_DiseaseCasePage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'page': instance.page,
      'totalResults': instance.totalResults,
      'hasNextPage': instance.hasNextPage,
      'canCreate': instance.canCreate,
      'existingCaseId': instance.existingCaseId,
      'ongoingCount': instance.ongoingCount,
      'resolvedCount': instance.resolvedCount,
      'season': instance.season,
    };
