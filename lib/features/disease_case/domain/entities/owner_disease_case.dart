import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'case_care_action.dart';

part 'owner_disease_case.freezed.dart';
part 'owner_disease_case.g.dart';

enum DiseaseCaseStatus {
  @JsonValue('OPEN')
  open,
  @JsonValue('WAITING_FOR_INFO')
  waitingForInfo,
  @JsonValue('MONITORING')
  monitoring,
  @JsonValue('IN_TREATMENT')
  inTreatment,
  @JsonValue('RESOLVED')
  resolved,
  unknown,
}

enum DiseaseCaseSeverity {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
  @JsonValue('CRITICAL')
  critical,
  unknown,
}

enum DiseaseCaseResponseType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('REQUEST_INFO')
  requestInfo,
  @JsonValue('PROVIDE_INFO')
  provideInfo,
  @JsonValue('MONITORING_RESULT')
  monitoringResult,
  @JsonValue('TREATMENT_RESULT')
  treatmentResult,
  @JsonValue('EMERGENCY_ALERT')
  emergencyAlert,
  @JsonValue('EXPERT_ASSESSMENT')
  expertAssessment,
  @JsonValue('EXPERT_INSTRUCTION')
  expertInstruction,
  @JsonValue('RESOLUTION')
  resolution,
  unknown,
}

enum OpeningHealthStatus {
  @JsonValue('EXCELLENT')
  excellent,
  @JsonValue('GOOD')
  good,
  @JsonValue('WARNING')
  warning,
  @JsonValue('CRITICAL')
  critical,
}

@freezed
abstract class DiseaseCaseCard with _$DiseaseCaseCard {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseCard({
    @JsonKey(fromJson: _requiredText) required String id,
    @JsonKey(fromJson: _requiredText) required String title,
    @JsonKey(fromJson: _requiredText) required String description,
    @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)
    required DiseaseCaseStatus status,
    @JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown)
    required DiseaseCaseSeverity severity,
    @JsonKey(fromJson: _requiredText) required String expertName,
    @JsonKey(fromJson: _count) required int responseCount,
    String? aiDiagnosis,
  }) = _DiseaseCaseCard;

  factory DiseaseCaseCard.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseCardFromJson(json);
}

@freezed
abstract class DiseaseCasePage with _$DiseaseCasePage {
  @JsonSerializable(checked: true)
  const factory DiseaseCasePage({
    required List<DiseaseCaseCard> items,
    @JsonKey(fromJson: _requiredText) required String seasonName,
    @JsonKey(fromJson: _requiredText) required String pondName,
    @JsonKey(fromJson: _positiveInt) required int page,
    required bool hasNextPage,
    @JsonKey(fromJson: _count) required int activeCount,
    @JsonKey(fromJson: _count) required int resolvedCount,
  }) = _DiseaseCasePage;

  factory DiseaseCasePage.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCasePageFromJson(json);

  static DiseaseCasePage parse(
    List<Object?> items,
    Map<String, dynamic>? meta,
  ) => _parse(() => DiseaseCasePage.fromJson({...?meta, 'items': items}));
}

/// Owner-visible case history and submitted treatment versions from one detail response.
@freezed
abstract class DiseaseCaseDetail with _$DiseaseCaseDetail {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseDetail({
    required DiseaseCaseCard card,
    @JsonKey(fromJson: _requiredText) required String seasonName,
    @JsonKey(fromJson: _requiredText) required String pondName,
    @JsonKey(fromJson: _requiredText) required String farmName,
    @JsonKey(fromJson: _requiredText) required String reporterName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<DiseaseCaseAttachment> attachments,
    required List<DiseaseCaseProtocol> protocols,
    required List<DiseaseCaseEvent> timeline,
    DiseaseCaseSnapshot? snapshot,
    DiseaseCaseAiAssessment? aiAssessment,
    String? resolutionSummary,
    @Default(false) bool productionPaused,
  }) = _DiseaseCaseDetail;

  factory DiseaseCaseDetail.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseDetailFromJson(json);

  static DiseaseCaseDetail parse(Map<String, dynamic> json) =>
      _parse(() => DiseaseCaseDetail.fromJson(json));
}

@freezed
abstract class DiseaseCaseSnapshot
    with WaterMeasurements, _$DiseaseCaseSnapshot {
  const DiseaseCaseSnapshot._();

  @JsonSerializable(checked: true)
  const factory DiseaseCaseSnapshot({
    required List<String> exceededWaterMetrics,
    DateTime? capturedAt,
    DateTime? healthRecordedAt,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    OpeningHealthStatus? healthStatus,
    String? note,
    num? avgWeightG,
    num? mortalityCount,
    num? ph,
    num? no2MgL,
    num? nh3MgL,
    num? temperatureC,
    num? dissolvedOxygenMgL,
    num? salinityPpt,
    num? alkalinityMgLCaCO3,
    num? h2sMgL,
    DateTime? waterRecordedAt,
    String? waterRecordedByName,
    String? waterNote,
  }) = _DiseaseCaseSnapshot;

  factory DiseaseCaseSnapshot.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseSnapshotFromJson(json);

  /// Technician details store decimals as strings in the original case record.
  factory DiseaseCaseSnapshot.fromRecordedSnapshot(Map<String, dynamic> json) {
    Map<dynamic, dynamic> section(Object? value) => value is Map ? value : json;
    String? text(Object? value) =>
        value is String && value.trim().isNotEmpty ? value.trim() : null;
    num? number(Object? value) {
      final parsed = value is num ? value : num.tryParse(text(value) ?? '');
      return parsed?.isFinite == true ? parsed : null;
    }

    String? date(Object? value) =>
        DateTime.tryParse(text(value) ?? '')?.toIso8601String();
    final health = section(json['shrimpHealth'] ?? json['health']);
    final water = section(
      json['waterIndicators'] ?? json['waterQuality'] ?? json['water'],
    );
    return DiseaseCaseSnapshot.fromJson({
      'capturedAt': date(json['capturedAt'] ?? json['captured_at']),
      'healthRecordedAt':
          date(json['healthRecordedAt'] ?? json['health_recorded_at']) ??
          (identical(health, json)
              ? null
              : date(health['recordedAt'] ?? health['recorded_at'])),
      'waterRecordedAt':
          date(json['waterRecordedAt'] ?? json['water_recorded_at']) ??
          (identical(water, json)
              ? null
              : date(water['recordedAt'] ?? water['recorded_at'])),
      'healthStatus': text(
        health['healthStatus'] ?? health['health_status'],
      )?.toUpperCase(),
      'note': text(json['note']) ?? text(health['note']),
      'avgWeightG': number(health['avgWeightG'] ?? health['avg_weight_g']),
      'mortalityCount': number(
        health['mortalityCount'] ?? health['mortality_count'],
      ),
      'ph': number(water['ph']),
      'no2MgL': number(water['no2MgL'] ?? water['no2_mg_l']),
      'nh3MgL': number(water['nh3MgL'] ?? water['nh3_mg_l']),
      'temperatureC': number(water['temperatureC'] ?? water['temperature_c']),
      'dissolvedOxygenMgL': number(
        water['dissolvedOxygenMgL'] ??
            water['dissolved_oxygen_mg_l'] ??
            water['doMgL'],
      ),
      'salinityPpt': number(water['salinityPpt'] ?? water['salinity_ppt']),
      'alkalinityMgLCaCO3': number(
        water['alkalinityMgLCaCO3'] ?? water['alkalinity_mg_l_ca_co3'],
      ),
      'h2sMgL': number(water['h2sMgL'] ?? water['h2s_mg_l']),
      'waterRecordedByName':
          text(water['recordedByName'] ?? water['recorded_by_name']) ??
          text(json['waterRecordedByName']),
      'waterNote': text(
        identical(water, json) ? json['waterNote'] : water['note'],
      ),
      'exceededWaterMetrics': switch (json['exceededWaterMetrics']) {
        final List fields => fields.whereType<String>().toList(),
        _ => <String>[],
      },
    });
  }

  @override
  List<String> get exceededParameters => exceededWaterMetrics;

  @override
  bool get isVoided => false;
}

@freezed
abstract class DiseaseCaseAiAssessment with _$DiseaseCaseAiAssessment {
  const DiseaseCaseAiAssessment._();

  @JsonSerializable(checked: true)
  const factory DiseaseCaseAiAssessment({
    String? predictedLabel,
    @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)
    AiRecognitionStatus? recognitionStatus,
    @JsonKey(fromJson: _probability) double? confidence,
    String? recommendation,
    DateTime? createdAt,
    int? processingTimeMs,
    @Default([]) List<String> imageUrls,
    DateTime? imageUrlsExpireAt,
  }) = _DiseaseCaseAiAssessment;

  factory DiseaseCaseAiAssessment.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseAiAssessmentFromJson(json);

  bool imagesExpireBy(DateTime now) =>
      imageUrlsExpireAt?.isAfter(now.add(const Duration(seconds: 5))) == false;
}

@freezed
abstract class DiseaseCaseAttachment with _$DiseaseCaseAttachment {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseAttachment({
    @JsonKey(fromJson: _requiredText) required String fileUrl,
    @JsonKey(fromJson: _requiredText) required String uploaderName,
    required DateTime createdAt,
    String? mediaType,
    String? caption,
  }) = _DiseaseCaseAttachment;

  factory DiseaseCaseAttachment.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseAttachmentFromJson(json);
}

@freezed
abstract class DiseaseCaseProtocol with _$DiseaseCaseProtocol {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseProtocol({
    @JsonKey(fromJson: _requiredText) required String id,
    @JsonKey(fromJson: _requiredText) required String title,
    @JsonKey(fromJson: _positiveInt) required int versionNo,
    @JsonKey(unknownEnumValue: ProtocolStatus.unknown)
    required ProtocolStatus status,
    String? summary,
  }) = _DiseaseCaseProtocol;

  factory DiseaseCaseProtocol.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseProtocolFromJson(json);
}

/// Preserve the server's distinction between clinical state changes and conversation.
@Freezed(unionKey: 'kind')
sealed class DiseaseCaseEvent with _$DiseaseCaseEvent {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseEvent.status({
    required DateTime at,
    @JsonKey(fromJson: _requiredText) required String authorName,
    @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)
    required DiseaseCaseStatus toStatus,
    @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)
    DiseaseCaseStatus? fromStatus,
    String? message,
  }) = DiseaseCaseStatusChange;

  @JsonSerializable(checked: true)
  const factory DiseaseCaseEvent.response({
    required DateTime at,
    @JsonKey(fromJson: _requiredText) required String authorName,
    @JsonKey(unknownEnumValue: AccountRole.unknown)
    required AccountRole authorRole,
    @JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown)
    required DiseaseCaseResponseType responseType,
    @JsonKey(unknownEnumValue: CaseCareAction.unknown)
    CaseCareAction? careAction,
    @JsonKey(fromJson: _requiredText) required String message,
    @Default([]) List<String> attachments,
  }) = DiseaseCaseResponse;

  factory DiseaseCaseEvent.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseEventFromJson(json);
}

T _parse<T>(T Function() decode) {
  try {
    return decode();
  } on CheckedFromJsonException {
    throw const InvalidResponseException();
  }
}

String _requiredText(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    throw const InvalidResponseException();
  }
  return value.trim();
}

int _count(Object? value) {
  if (value is! int || value < 0) throw const InvalidResponseException();
  return value;
}

int _positiveInt(Object? value) {
  final number = _count(value);
  if (number == 0) throw const InvalidResponseException();
  return number;
}

double? _probability(Object? value) {
  if (value == null) return null;
  if (value is! num || !value.isFinite || value < 0 || value > 1) {
    throw const InvalidResponseException();
  }
  return value.toDouble();
}
