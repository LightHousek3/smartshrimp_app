import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';

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
    String? resolutionSummary,
  }) = _DiseaseCaseDetail;

  factory DiseaseCaseDetail.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseDetailFromJson(json);

  static DiseaseCaseDetail parse(Map<String, dynamic> json) =>
      _parse(() => DiseaseCaseDetail.fromJson(json));
}

@freezed
abstract class DiseaseCaseSnapshot with _$DiseaseCaseSnapshot {
  @JsonSerializable(checked: true)
  const factory DiseaseCaseSnapshot({
    required List<String> exceededWaterMetrics,
    DateTime? capturedAt,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    OpeningHealthStatus? healthStatus,
    String? note,
    num? avgWeightG,
    num? mortalityCount,
    num? ph,
    num? no2MgL,
    num? nh3MgL,
  }) = _DiseaseCaseSnapshot;

  factory DiseaseCaseSnapshot.fromJson(Map<String, dynamic> json) =>
      _$DiseaseCaseSnapshotFromJson(json);
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
    @JsonKey(fromJson: _requiredText) required String message,
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
