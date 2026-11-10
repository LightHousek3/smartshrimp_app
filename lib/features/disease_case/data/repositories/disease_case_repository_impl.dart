import 'package:smartshrimp_app/core/errors/app_exception.dart';
import '../../domain/domain.dart';
import '../services/disease_case_api_service.dart';

class DiseaseCaseRepositoryImpl implements DiseaseCaseRepository {
  DiseaseCaseRepositoryImpl(this._api);
  final DiseaseCaseApiService _api;
  @override
  Future<CaseCreationOptions> creationOptions(String seasonId) =>
      _api.creationOptions(seasonId);
  @override
  Future<DiseaseCasePage> list(
    String seasonId, {
    int page = 1,
    DiseaseCaseStatus? status,
    bool? resolved,
  }) => _api.list(seasonId, page, status, resolved: resolved);
  @override
  Future<DiseaseCase> detail(String seasonId, String id) =>
      _api.detail(seasonId, id);
  void _validate(String value, int limit) {
    final error = DiseaseCaseRules.textError(value, limit);
    if (error != null) throw ApiException(error, statusCode: 400);
  }

  @override
  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  }) {
    _validate(title, DiseaseCaseRules.titleLimit);
    _validate(description, DiseaseCaseRules.textLimit);
    DiseaseCaseRules.validateAttachments(attachments);
    if (severity == CaseSeverity.unknown) {
      throw const ApiException('Mức độ không hợp lệ.', statusCode: 400);
    }
    return _api.create(seasonId, {
      'title': title.trim(),
      'description': description.trim(),
      'severity': severity.name.toUpperCase(),
      if (attachments.isNotEmpty) 'attachments': attachments,
      'aiDiagnosisId': ?aiDiagnosisId,
      'relatedCaseId': ?relatedCaseId,
    });
  }

  @override
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase item,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
  }) {
    _validate(message, DiseaseCaseRules.textLimit);
    DiseaseCaseRules.validateAttachments(attachments);
    if (!item.allowsResponse ||
        !CaseResponseType.technicianTypes.contains(type)) {
      throw const ApiException(
        'Không thể phản hồi ca bệnh này.',
        statusCode: 403,
      );
    }
    return _api.respond(seasonId, item.id, {
      'responseType': type.apiValue,
      'message': message.trim(),
      'expectedUpdatedAt': item.updatedAt.toUtc().toIso8601String(),
      if (attachments.isNotEmpty) 'attachments': attachments,
    });
  }
}
