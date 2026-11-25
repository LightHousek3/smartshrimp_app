import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/services/app_image_picker.dart';
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
    final files = await pickAppImages(
      _picker,
      source: source == AiImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      limit: limit,
    );
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
