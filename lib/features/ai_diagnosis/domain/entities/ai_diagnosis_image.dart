import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_diagnosis_image.freezed.dart';

@freezed
abstract class AiDiagnosisImage with _$AiDiagnosisImage {
  const factory AiDiagnosisImage({
    required Uint8List bytes,
    required String mimeType,
    required String fileName,
  }) = _AiDiagnosisImage;
}
