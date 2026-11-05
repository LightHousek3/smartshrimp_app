// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_diagnosis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiDiagnosisSummary _$AiDiagnosisSummaryFromJson(Map<String, dynamic> json) =>
    _AiDiagnosisSummary(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      runStatus: $enumDecode(
        _$AiRunStatusEnumMap,
        json['runStatus'],
        unknownValue: AiRunStatus.unknown,
      ),
      imageCount: (json['imageCount'] as num).toInt(),
      predictedLabel: $enumDecodeNullable(
        _$AiDiseaseLabelEnumMap,
        json['predictedLabel'],
        unknownValue: AiDiseaseLabel.unknown,
      ),
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AiDiagnosisSummaryToJson(_AiDiagnosisSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'runStatus': _$AiRunStatusEnumMap[instance.runStatus]!,
      'imageCount': instance.imageCount,
      'predictedLabel': _$AiDiseaseLabelEnumMap[instance.predictedLabel],
      'confidence': instance.confidence,
    };

const _$AiRunStatusEnumMap = {
  AiRunStatus.success: 'SUCCESS',
  AiRunStatus.error: 'ERROR',
  AiRunStatus.unknown: 'unknown',
};

const _$AiDiseaseLabelEnumMap = {
  AiDiseaseLabel.healthy: 'Khỏe mạnh',
  AiDiseaseLabel.bg: 'Mang đen',
  AiDiseaseLabel.wssv: 'Đốm trắng',
  AiDiseaseLabel.wssvBg: 'Đốm trắng và mang đen',
  AiDiseaseLabel.unknown: 'unknown',
};

_AiPrediction _$AiPredictionFromJson(Map<String, dynamic> json) =>
    _AiPrediction(
      label: $enumDecode(
        _$AiDiseaseLabelEnumMap,
        json['label'],
        unknownValue: AiDiseaseLabel.unknown,
      ),
      probability: (json['probability'] as num).toDouble(),
    );

Map<String, dynamic> _$AiPredictionToJson(_AiPrediction instance) =>
    <String, dynamic>{
      'label': _$AiDiseaseLabelEnumMap[instance.label]!,
      'probability': instance.probability,
    };

_AiDiagnosisError _$AiDiagnosisErrorFromJson(Map<String, dynamic> json) =>
    _AiDiagnosisError(
      message: json['message'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$AiDiagnosisErrorToJson(_AiDiagnosisError instance) =>
    <String, dynamic>{'message': instance.message, 'code': instance.code};

_AiDiagnosisDetail _$AiDiagnosisDetailFromJson(Map<String, dynamic> json) =>
    _AiDiagnosisDetail(
      id: json['id'] as String,
      seasonId: json['seasonId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      runStatus: $enumDecode(
        _$AiRunStatusEnumMap,
        json['runStatus'],
        unknownValue: AiRunStatus.unknown,
      ),
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrlsExpireAt: json['imageUrlsExpireAt'] == null
          ? null
          : DateTime.parse(json['imageUrlsExpireAt'] as String),
      modelVersion: json['modelVersion'] as String?,
      processingTimeMs: (json['processingTimeMs'] as num?)?.toInt(),
      predictedLabel: $enumDecodeNullable(
        _$AiDiseaseLabelEnumMap,
        json['predictedLabel'],
        unknownValue: AiDiseaseLabel.unknown,
      ),
      confidence: (json['confidence'] as num?)?.toDouble(),
      predictions:
          (json['predictions'] as List<dynamic>?)
              ?.map((e) => AiPrediction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recommendation: json['recommendation'] as String?,
      error: json['error'] == null
          ? null
          : AiDiagnosisError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AiDiagnosisDetailToJson(_AiDiagnosisDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonId': instance.seasonId,
      'createdAt': instance.createdAt.toIso8601String(),
      'runStatus': _$AiRunStatusEnumMap[instance.runStatus]!,
      'imageUrls': instance.imageUrls,
      'imageUrlsExpireAt': instance.imageUrlsExpireAt?.toIso8601String(),
      'modelVersion': instance.modelVersion,
      'processingTimeMs': instance.processingTimeMs,
      'predictedLabel': _$AiDiseaseLabelEnumMap[instance.predictedLabel],
      'confidence': instance.confidence,
      'predictions': instance.predictions,
      'recommendation': instance.recommendation,
      'error': instance.error,
    };

_AiDiagnosisPagination _$AiDiagnosisPaginationFromJson(
  Map<String, dynamic> json,
) => _AiDiagnosisPagination(
  totalResults: (json['totalResults'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$AiDiagnosisPaginationToJson(
  _AiDiagnosisPagination instance,
) => <String, dynamic>{
  'totalResults': instance.totalResults,
  'hasNextPage': instance.hasNextPage,
  'nextCursor': instance.nextCursor,
};
