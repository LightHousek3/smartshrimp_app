import '../entities/ai_diagnosis.dart';
import '../entities/ai_diagnosis_image.dart';

abstract interface class AiDiagnosisRepository {
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor});
  Future<AiDiagnosisDetail> detail(String seasonId, String diagnosisId);
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  );
}

enum AiImageSource { camera, gallery }

abstract interface class AiDiagnosisImagePicker {
  Future<List<AiDiagnosisImage>> pick(
    AiImageSource source, {
    required int limit,
  });
}
