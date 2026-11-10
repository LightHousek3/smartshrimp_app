import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import '../../domain/domain.dart';

class DiseaseCaseApiService {
  DiseaseCaseApiService(this._client);
  final ApiClient _client;
  Future<CaseCreationOptions> creationOptions(String seasonId) async {
    final responses = await Future.wait([
      _client.get(
        _path(seasonId),
        authenticated: true,
        queryParameters: {'status': 'RESOLVED', 'limit': 20},
      ),
      _client.get(
        '/technician/seasons/${Uri.encodeComponent(seasonId)}/ai-diagnoses',
        authenticated: true,
        queryParameters: {'runStatus': 'SUCCESS', 'limit': 20},
      ),
    ]);
    return CaseCreationOptions.fromJson({
      'relatedCases': responses[0].requireListData(),
      'aiDiagnoses': responses[1].requireListData(),
    });
  }

  String _path(String seasonId) =>
      '/me/seasons/${Uri.encodeComponent(seasonId)}/disease-cases';
  Future<DiseaseCasePage> list(
    String seasonId,
    int page,
    DiseaseCaseStatus? status, {
    bool? resolved,
  }) async {
    final response = await _client.get(
      _path(seasonId),
      authenticated: true,
      queryParameters: {
        'page': page,
        'limit': 20,
        'resolved': ?resolved,
        if (status != null)
          'status': switch (status) {
            DiseaseCaseStatus.open => 'OPEN',
            DiseaseCaseStatus.waitingForInfo => 'WAITING_FOR_INFO',
            DiseaseCaseStatus.monitoring => 'MONITORING',
            DiseaseCaseStatus.inTreatment => 'IN_TREATMENT',
            DiseaseCaseStatus.resolved => 'RESOLVED',
            DiseaseCaseStatus.unknown => 'UNKNOWN',
          },
      },
    );
    if (response.meta == null) throw const InvalidResponseException();
    return DiseaseCasePage.fromJson({
      ...response.meta!,
      'items': response.requireListData(),
    });
  }

  DiseaseCase _detail(Map<String, dynamic> json) {
    if (json['description'] is! String ||
        (json['description'] as String).trim().isEmpty ||
        json['caseSnapshot'] is! Map ||
        json['responses'] is! List ||
        json['canRespond'] is! bool) {
      throw const InvalidResponseException();
    }
    return DiseaseCase.fromJson(json);
  }

  Future<DiseaseCase> detail(String seasonId, String id) async => _detail(
    (await _client.get(
      '${_path(seasonId)}/${Uri.encodeComponent(id)}',
      authenticated: true,
    )).requireMapData(),
  );
  Future<DiseaseCase> create(
    String seasonId,
    Map<String, dynamic> body,
  ) async => _detail(
    (await _client.post(
      _path(seasonId),
      authenticated: true,
      data: body,
    )).requireMapData(),
  );
  Future<DiseaseCase> respond(
    String seasonId,
    String id,
    Map<String, dynamic> body,
  ) async => _detail(
    (await _client.post(
      '${_path(seasonId)}/${Uri.encodeComponent(id)}/responses',
      authenticated: true,
      data: body,
    )).requireMapData(),
  );
}
