import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'ai_diagnosis.freezed.dart';
part 'ai_diagnosis.g.dart';

enum AiRunStatus {
  @JsonValue('SUCCESS')
  success,
  @JsonValue('ERROR')
  error,
  unknown,
}

enum AiDiseaseLabel {
  @JsonValue('Khỏe mạnh')
  healthy,
  @JsonValue('Mang đen')
  bg,
  @JsonValue('Đốm trắng')
  wssv,
  @JsonValue('Đốm trắng và mang đen')
  wssvBg,
  unknown,
}

enum AiRecognitionStatus {
  @JsonValue('RECOGNIZED')
  recognized,
  @JsonValue('UNRECOGNIZED')
  unrecognized,
  unknown,
}

/// Keep parser failures inside the app's shared invalid-response contract.
T _checked<T>(T Function() parse) {
  try {
    return parse();
  } on Object catch (_, stack) {
    Error.throwWithStackTrace(const InvalidResponseException(), stack);
  }
}

void _require(bool condition) {
  if (!condition) throw const InvalidResponseException();
}

bool _probability(double? value) =>
    value != null && value.isFinite && value >= 0 && value <= 1;

@freezed
abstract class AiDiagnosisSummary with _$AiDiagnosisSummary {
  const AiDiagnosisSummary._();
  const factory AiDiagnosisSummary({
    required String id,
    required DateTime createdAt,
    @JsonKey(unknownEnumValue: AiRunStatus.unknown)
    required AiRunStatus runStatus,
    required int imageCount,
    @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)
    AiRecognitionStatus? recognitionStatus,
    @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)
    AiDiseaseLabel? predictedLabel,
    double? confidence,
  }) = _AiDiagnosisSummary;

  factory AiDiagnosisSummary.fromJson(Map<String, dynamic> json) =>
      _$AiDiagnosisSummaryFromJson(json);

  bool get isRecognized => recognitionStatus == AiRecognitionStatus.recognized;

  static AiDiagnosisSummary parse(Object? raw) => _checked(() {
    _require(raw is Map<String, dynamic>);
    final json = raw as Map<String, dynamic>;
    final value = AiDiagnosisSummary.fromJson(json);
    _require(
      value.id.trim().isNotEmpty && value.runStatus != AiRunStatus.unknown,
    );
    _require(
      json['imageCount'] is int &&
          value.imageCount >= 1 &&
          value.imageCount <= 5,
    );
    if (value.runStatus == AiRunStatus.success) {
      _require(
        value.recognitionStatus != null &&
            value.recognitionStatus != AiRecognitionStatus.unknown &&
            _probability(value.confidence),
      );
      _require(
        value.isRecognized
            ? value.predictedLabel != null &&
                  value.predictedLabel != AiDiseaseLabel.unknown
            : value.predictedLabel == null,
      );
    } else {
      _require(
        value.recognitionStatus == null &&
            value.predictedLabel == null &&
            value.confidence == null,
      );
    }
    return value;
  });
}

@freezed
abstract class AiPrediction with _$AiPrediction {
  const factory AiPrediction({
    @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)
    required AiDiseaseLabel label,
    required double probability,
  }) = _AiPrediction;
  factory AiPrediction.fromJson(Map<String, dynamic> json) =>
      _$AiPredictionFromJson(json);
}

@freezed
abstract class AiDiagnosisError with _$AiDiagnosisError {
  const factory AiDiagnosisError({required String message, String? code}) =
      _AiDiagnosisError;
  factory AiDiagnosisError.fromJson(Map<String, dynamic> json) =>
      _$AiDiagnosisErrorFromJson(json);
}

@freezed
abstract class AiDiagnosisDetail with _$AiDiagnosisDetail {
  const AiDiagnosisDetail._();
  const factory AiDiagnosisDetail({
    required String id,
    required String seasonId,
    required DateTime createdAt,
    @JsonKey(unknownEnumValue: AiRunStatus.unknown)
    required AiRunStatus runStatus,
    required List<String> imageUrls,
    DateTime? imageUrlsExpireAt,
    String? modelVersion,
    int? processingTimeMs,
    @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)
    AiRecognitionStatus? recognitionStatus,
    @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)
    AiDiseaseLabel? predictedLabel,
    double? confidence,
    @Default([]) List<AiPrediction> predictions,
    String? recommendation,
    AiDiagnosisError? error,
  }) = _AiDiagnosisDetail;
  factory AiDiagnosisDetail.fromJson(Map<String, dynamic> json) =>
      _$AiDiagnosisDetailFromJson(json);

  bool get isRecognized => recognitionStatus == AiRecognitionStatus.recognized;

  bool imageUrlsExpiredAt(DateTime now) =>
      imageUrlsExpireAt != null &&
      !imageUrlsExpireAt!.isAfter(now.add(const Duration(seconds: 5)));

  static AiDiagnosisDetail parse(Object? raw) => _checked(() {
    _require(raw is Map<String, dynamic>);
    final json = raw as Map<String, dynamic>;
    final value = AiDiagnosisDetail.fromJson(json);
    _require(
      value.id.trim().isNotEmpty &&
          value.seasonId.trim().isNotEmpty &&
          value.runStatus != AiRunStatus.unknown,
    );
    _require(value.imageUrls.isNotEmpty && value.imageUrls.length <= 5);
    _require(
      value.imageUrls.every((url) {
        final uri = Uri.tryParse(url);
        return uri != null &&
            uri.scheme == 'https' &&
            uri.host.isNotEmpty &&
            uri.userInfo.isEmpty;
      }),
    );
    _require(
      value.processingTimeMs == null ||
          (json['processingTimeMs'] is int && value.processingTimeMs! >= 0),
    );
    if (value.runStatus == AiRunStatus.success) {
      _require(
        value.recognitionStatus != null &&
            value.recognitionStatus != AiRecognitionStatus.unknown &&
            _probability(value.confidence),
      );
      _require(
        value.isRecognized
            ? value.predictedLabel != null &&
                  value.predictedLabel != AiDiseaseLabel.unknown
            : value.predictedLabel == null,
      );
      _require(value.error == null && value.predictions.length == 4);
      _require(value.predictions.map((p) => p.label).toSet().length == 4);
      _require(
        value.predictions.every(
          (p) =>
              p.label != AiDiseaseLabel.unknown && _probability(p.probability),
        ),
      );
      final total = value.predictions.fold<double>(
        0,
        (sum, p) => sum + p.probability,
      );
      _require((total - 1).abs() <= 0.000001);
      if (value.isRecognized) {
        _require(value.predictions.first.label == value.predictedLabel);
      }
      // SQL stores confidence with five decimals; prediction probabilities retain source precision.
      _require(
        (value.predictions.first.probability - value.confidence!).abs() <=
            0.00001,
      );
      for (var i = 1; i < value.predictions.length; i++) {
        _require(
          value.predictions[i].probability <=
              value.predictions[i - 1].probability,
        );
      }
    } else {
      _require(value.error != null && value.error!.message.trim().isNotEmpty);
      _require(
        value.recognitionStatus == null &&
            value.predictedLabel == null &&
            value.confidence == null &&
            value.predictions.isEmpty,
      );
    }
    return value;
  });
}

@freezed
abstract class AiDiagnosisPagination with _$AiDiagnosisPagination {
  const factory AiDiagnosisPagination({
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _AiDiagnosisPagination;
  factory AiDiagnosisPagination.fromJson(Map<String, dynamic> json) =>
      _$AiDiagnosisPaginationFromJson(json);
  static AiDiagnosisPagination parse(Object? raw) => _checked(() {
    _require(raw is Map<String, dynamic>);
    final json = raw as Map<String, dynamic>;
    final value = AiDiagnosisPagination.fromJson(json);
    _require(json['totalResults'] is int && value.totalResults >= 0);
    _require(
      value.hasNextPage
          ? value.nextCursor?.isNotEmpty == true
          : value.nextCursor == null,
    );
    return value;
  });
}

@freezed
abstract class AiDiagnosisPage with _$AiDiagnosisPage {
  const factory AiDiagnosisPage({
    required List<AiDiagnosisSummary> items,
    required AiDiagnosisPagination pagination,
  }) = _AiDiagnosisPage;
}
