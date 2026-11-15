import '../entities/disease_case.dart';

/// Read and record cases within the authenticated technician's season scope.
abstract interface class DiseaseCaseRepository {
  Future<CaseCreationOptions> creationOptions(String seasonId);
  Future<DiseaseCasePage> list(
    String seasonId, {
    int page = 1,
    DiseaseCaseStatus? status,
    bool? resolved,
  });
  Future<DiseaseCase> detail(String seasonId, String id);

  /// Report observations for a new case without assigning a diagnosis or treatment state.
  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  });

  /// Send ordinary observations or an emergency alert without making a clinical decision.
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase item,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
    String? replyToResponseId,
  });
}
