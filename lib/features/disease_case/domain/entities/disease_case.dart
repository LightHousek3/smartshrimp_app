import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'disease_case.freezed.dart';
part 'disease_case.g.dart';

@freezed
abstract class CaseCreationOptions with _$CaseCreationOptions {
  const factory CaseCreationOptions({
    @Default([]) List<Map<String, dynamic>> relatedCases,
    @Default([]) List<Map<String, dynamic>> aiDiagnoses,
  }) = _CaseCreationOptions;
  factory CaseCreationOptions.fromJson(Map<String, dynamic> json) => _parse(() {
    final value = _$CaseCreationOptionsFromJson(json);
    for (final entry in [...value.relatedCases, ...value.aiDiagnoses]) {
      if (entry['id'] is! String || (entry['id'] as String).isEmpty) {
        throw const InvalidResponseException();
      }
    }
    for (final entry in value.relatedCases) {
      if (entry['title'] is! String) throw const InvalidResponseException();
    }
    for (final entry in value.aiDiagnoses) {
      if (entry['createdAt'] is! String ||
          DateTime.tryParse(entry['createdAt'] as String) == null) {
        throw const InvalidResponseException();
      }
    }
    return value;
  });
}

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
  unknown;

  String get label => switch (this) {
    open => 'Mới mở',
    waitingForInfo => 'Chờ bổ sung thông tin',
    monitoring => 'Đang theo dõi',
    inTreatment => 'Đang điều trị',
    resolved => 'Đã giải quyết',
    unknown => 'Chưa xác định',
  };
}

enum CaseSeverity {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
  @JsonValue('CRITICAL')
  critical,
  unknown;

  String get label => switch (this) {
    low => 'Nhẹ',
    medium => 'Trung bình',
    high => 'Cao',
    critical => 'Nguy cấp',
    unknown => 'Chưa xác định',
  };
}

enum CaseResponseType {
  @JsonValue('PROVIDE_INFO')
  provideInfo,
  @JsonValue('MONITORING_RESULT')
  monitoringResult,
  @JsonValue('TREATMENT_RESULT')
  treatmentResult,
  @JsonValue('EMERGENCY_ALERT')
  emergencyAlert,
  @JsonValue('REQUEST_INFO')
  requestInfo,
  @JsonValue('EXPERT_ASSESSMENT')
  assessment,
  @JsonValue('EXPERT_INSTRUCTION')
  instruction,
  @JsonValue('RESOLUTION')
  resolution,
  unknown;

  String get apiValue => switch (this) {
    provideInfo => 'PROVIDE_INFO',
    monitoringResult => 'MONITORING_RESULT',
    treatmentResult => 'TREATMENT_RESULT',
    emergencyAlert => 'EMERGENCY_ALERT',
    requestInfo => 'REQUEST_INFO',
    assessment => 'EXPERT_ASSESSMENT',
    instruction => 'EXPERT_INSTRUCTION',
    resolution => 'RESOLUTION',
    unknown => 'UNKNOWN',
  };
  String get label => switch (this) {
    provideInfo => 'Cung cấp thông tin',
    monitoringResult => 'Kết quả theo dõi',
    treatmentResult => 'Kết quả điều trị',
    emergencyAlert => 'Cảnh báo khẩn cấp',
    requestInfo => 'Yêu cầu thông tin',
    assessment => 'Đánh giá chuyên gia',
    instruction => 'Hướng dẫn chuyên gia',
    resolution => 'Kết luận',
    unknown => 'Phản hồi',
  };
  static const technicianTypes = [
    provideInfo,
    monitoringResult,
    treatmentResult,
    emergencyAlert,
  ];
}

T _parse<T>(T Function() decode) {
  try {
    return decode();
  } catch (_) {
    throw const InvalidResponseException();
  }
}

// Expert replies store attachment objects; older technician replies store URLs.
List<String> _responseAttachmentUrls(Object? value) {
  if (value == null) return const [];
  if (value is! List) throw const InvalidResponseException();
  return value.map((entry) {
    final url = entry is Map ? entry['fileUrl'] : entry;
    if (url is! String || url.trim().isEmpty) {
      throw const InvalidResponseException();
    }
    return url;
  }).toList();
}

@freezed
abstract class CaseResponse with _$CaseResponse {
  const factory CaseResponse({
    required String id,
    required String authorId,
    @JsonKey(unknownEnumValue: CaseResponseType.unknown)
    required CaseResponseType responseType,
    required String message,
    required DateTime createdAt,
    Map<String, dynamic>? author,
    @JsonKey(fromJson: _responseAttachmentUrls)
    @Default([])
    List<String> attachments,
  }) = _CaseResponse;
  factory CaseResponse.fromJson(Map<String, dynamic> json) => _parse(() {
    for (final key in ['id', 'authorId', 'message', 'responseType']) {
      if (json[key] is! String || (json[key] as String).isEmpty) {
        throw const InvalidResponseException();
      }
    }
    return _$CaseResponseFromJson(json);
  });
}

@freezed
abstract class DiseaseCase with _$DiseaseCase {
  const DiseaseCase._();
  const factory DiseaseCase({
    required String id,
    required String seasonId,
    required String title,
    @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)
    required DiseaseCaseStatus status,
    @JsonKey(unknownEnumValue: CaseSeverity.unknown)
    required CaseSeverity severity,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? resolutionSummary,
    DateTime? resolvedAt,
    String? reportedBy,
    String? expertId,
    String? relatedCaseId,
    Map<String, dynamic>? expert,
    Map<String, dynamic>? reporter,
    @JsonKey(name: '_count') @Default({}) Map<String, dynamic> counts,
    @Default(false) bool canRespond,
    @Default({}) Map<String, dynamic> caseSnapshot,
    @Default([]) List<Map<String, dynamic>> attachments,
    @Default([]) List<CaseResponse> responses,
    @Default([]) List<Map<String, dynamic>> statusHistory,
  }) = _DiseaseCase;
  factory DiseaseCase.fromJson(Map<String, dynamic> json) => _parse(() {
    for (final key in ['id', 'seasonId', 'title', 'status', 'severity']) {
      if (json[key] is! String || (json[key] as String).isEmpty) {
        throw const InvalidResponseException();
      }
    }
    return _$DiseaseCaseFromJson(json);
  });
  bool get allowsResponse =>
      canRespond &&
      status != DiseaseCaseStatus.resolved &&
      status != DiseaseCaseStatus.unknown;
  int get responseCount => counts['responses'] is num
      ? (counts['responses'] as num).toInt()
      : responses.length;
}

@freezed
abstract class DiseaseCasePage with _$DiseaseCasePage {
  const factory DiseaseCasePage({
    required List<DiseaseCase> items,
    required int page,
    required int totalResults,
    required bool hasNextPage,
    required bool canCreate,
    String? existingCaseId,
    @Default(0) int ongoingCount,
    @Default(0) int resolvedCount,
    @Default({}) Map<String, dynamic> season,
  }) = _DiseaseCasePage;
  factory DiseaseCasePage.fromJson(Map<String, dynamic> json) => _parse(() {
    final page = _$DiseaseCasePageFromJson(json);
    if (page.page < 1 || page.totalResults < 0) {
      throw const InvalidResponseException();
    }
    return page;
  });
}
