import '../entities/disease_case.dart';

abstract interface class DiseaseCaseRepository {
  Future<CaseCreationOptions> creationOptions(String seasonId);
  Future<DiseaseCasePage> list(
    String seasonId, {
    int page = 1,
    DiseaseCaseStatus? status,
    bool? resolved,
  });
  Future<DiseaseCase> detail(String seasonId, String id);
  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  });
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase item,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
  });
}
