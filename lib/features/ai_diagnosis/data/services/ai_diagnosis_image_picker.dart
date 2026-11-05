import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import '../../domain/ai_diagnosis_rules.dart';
import '../../domain/entities/ai_diagnosis_image.dart';
import '../../domain/repositories/ai_diagnosis_repository.dart';

class DeviceAiDiagnosisImagePicker implements AiDiagnosisImagePicker {
  DeviceAiDiagnosisImagePicker(this._picker);
  final ImagePicker _picker;
  @override
  Future<List<AiDiagnosisImage>> pick(
    AiImageSource source, {
    required int limit,
  }) async {
    if (limit < 1 || limit > AiDiagnosisRules.maxImages) return [];
    final List<XFile> files;
    if (source == AiImageSource.camera || limit == 1) {
      final file = await _picker.pickImage(
        source: source == AiImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        requestFullMetadata: false,
      );
      files = file == null ? [] : [file];
    } else {
      files = await _picker.pickMultiImage(
        limit: limit,
        requestFullMetadata: false,
      );
    }
    if (files.length > limit) {
      throw const ApiException('Tối đa 5 ảnh cho mỗi lần nhận diện.');
    }
    final result = <AiDiagnosisImage>[];
    for (final file in files) {
      AiDiagnosisRules.validateSize(await file.length());
      final bytes = await file.readAsBytes();
      AiDiagnosisRules.validateSize(bytes.length);
      final mime = AiDiagnosisRules.mimeType(bytes);
      final extension = switch (mime) {
        'image/png' => 'png',
        'image/webp' => 'webp',
        _ => 'jpg',
      };
      result.add(
        AiDiagnosisImage(
          bytes: bytes,
          mimeType: mime,
          fileName: 'shrimp-${result.length + 1}.$extension',
        ),
      );
    }
    return result;
  }
}
