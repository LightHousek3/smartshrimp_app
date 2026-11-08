import '../../domain/ai_diagnosis_rules.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../../domain/entities/ai_diagnosis_image.dart';
import '../../domain/repositories/ai_diagnosis_repository.dart';
import '../services/ai_diagnosis_api_service.dart';

class AiDiagnosisRepositoryImpl implements AiDiagnosisRepository {
  AiDiagnosisRepositoryImpl(this._api);
  final AiDiagnosisApiService _api;
  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) =>
      _api.list(seasonId, cursor: cursor);
  @override
  Future<AiDiagnosisDetail> detail(String seasonId, String diagnosisId) =>
      _api.detail(seasonId, diagnosisId);
  @override
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) {
    AiDiagnosisRules.validate(images);
    return _api.create(seasonId, images);
  }
}
