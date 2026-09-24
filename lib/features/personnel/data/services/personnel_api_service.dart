import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';

abstract interface class PersonnelRemoteDataSource {
  Future<ManagedPersonnelPage> getPersonnel(Map<String, dynamic> query);

  Future<ManagedPersonnel> getPersonnelById(String personnelId);
}

final class PersonnelApiService implements PersonnelRemoteDataSource {
  PersonnelApiService(this._client);

  final ApiClient _client;
  static const _basePath = '/owner/personnel';

  @override
  Future<ManagedPersonnelPage> getPersonnel(Map<String, dynamic> query) async {
    final response = await _client.get(
      _basePath,
      queryParameters: query,
      authenticated: true,
    );
    return ManagedPersonnelPage.parse(response.data, response.meta);
  }

  @override
  Future<ManagedPersonnel> getPersonnelById(String personnelId) async {
    final response = await _client.get(
      '$_basePath/${Uri.encodeComponent(personnelId)}',
      authenticated: true,
    );
    return ManagedPersonnel.parse(response.requireMapData(), detail: true);
  }
}
