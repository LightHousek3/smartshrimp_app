import 'package:smartshrimp_app/core/network/api_client.dart';

import '../domain/entities/owner_disease_case.dart';
import '../domain/repositories/owner_disease_case_repository.dart';

final class DiseaseCaseApiService implements DiseaseCaseRepository {
  DiseaseCaseApiService(this._client);

  static const _path = '/owner/disease-cases';
  final ApiClient _client;

  @override
  Future<DiseaseCasePage> list({
    required String seasonId,
    required bool resolved,
    required int page,
  }) async {
    final response = await _client.get(
      _path,
      authenticated: true,
      queryParameters: {
        'seasonId': seasonId,
        'resolved': resolved,
        'page': page,
      },
    );
    return DiseaseCasePage.parse(response.requireListData(), response.meta);
  }

  @override
  Future<DiseaseCaseDetail> detail(String caseId) async {
    final response = await _client.get(
      '$_path/${Uri.encodeComponent(caseId)}',
      authenticated: true,
    );
    return DiseaseCaseDetail.parse(response.requireMapData());
  }
}
