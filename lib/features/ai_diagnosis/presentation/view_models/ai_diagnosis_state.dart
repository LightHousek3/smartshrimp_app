import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../../domain/entities/ai_diagnosis_image.dart';

part 'ai_diagnosis_state.freezed.dart';

@freezed
abstract class AiDiagnosisDraft with _$AiDiagnosisDraft {
  const factory AiDiagnosisDraft({
    @Default([]) List<AiDiagnosisImage> images,
    @Default(false) bool picking,
    @Default(false) bool submitting,
    @Default(false) bool submissionFailed,
    Object? error,
  }) = _AiDiagnosisDraft;
}

@freezed
abstract class AiDiagnosisHistory with _$AiDiagnosisHistory {
  const factory AiDiagnosisHistory({
    required AiDiagnosisPage page,
    @Default(false) bool loadingMore,
    Object? paginationError,
  }) = _AiDiagnosisHistory;
}
