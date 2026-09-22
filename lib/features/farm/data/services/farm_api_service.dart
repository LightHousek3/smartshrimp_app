import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';

abstract interface class FarmRemoteDataSource {
  Future<List<Farm>> getFarms();
  Future<Farm> getFarm(String farmId);
  Future<Farm> createFarm(Map<String, dynamic> data);
  Future<Farm> updateFarm(String farmId, Map<String, dynamic> data);
  Future<Farm> deleteFarm(String farmId);
}

final class FarmApiService implements FarmRemoteDataSource {
  FarmApiService(this._client);

  final ApiClient _client;
  static const _basePath = '/owner/farms';

  @override
  Future<List<Farm>> getFarms() async {
    final response = await _client.get(_basePath, authenticated: true);
    try {
      return response
          .requireListData()
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const InvalidResponseException();
            }
            return Farm.parse(item);
          })
          .toList(growable: false);
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  @override
  Future<Farm> getFarm(String farmId) async {
    final response = await _client.get(
      '$_basePath/$farmId',
      authenticated: true,
    );
    return Farm.parse(response.requireMapData());
  }

  @override
  Future<Farm> createFarm(Map<String, dynamic> data) async {
    final response = await _client.post(
      _basePath,
      authenticated: true,
      data: data,
    );
    return Farm.parse(response.requireMapData());
  }

  @override
  Future<Farm> updateFarm(String farmId, Map<String, dynamic> data) async {
    final response = await _client.patch(
      '$_basePath/$farmId',
      authenticated: true,
      data: data,
    );
    return Farm.parse(response.requireMapData());
  }

  @override
  Future<Farm> deleteFarm(String farmId) async {
    final response = await _client.delete(
      '$_basePath/$farmId',
      authenticated: true,
    );
    return Farm.parse(response.requireMapData());
  }
}
