import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

abstract interface class PondRemoteDataSource {
  Future<PondPage> getPonds(String farmId, Map<String, dynamic> query);
  Future<Pond> getPond(String farmId, String pondId);
  Future<Pond> createPond(String farmId, Map<String, dynamic> data);
  Future<Pond> updatePond(
    String farmId,
    String pondId,
    Map<String, dynamic> data,
  );
  Future<Pond> archivePond(String farmId, String pondId);
  Future<Pond> restorePond(String farmId, String pondId);
}

final class PondApiService implements PondRemoteDataSource {
  PondApiService(this._client);
  final ApiClient _client;

  String _path(String farmId) => '/owner/farms/$farmId/ponds';

  @override
  Future<PondPage> getPonds(String farmId, Map<String, dynamic> query) async {
    final response = await _client.get(
      _path(farmId),
      queryParameters: query,
      authenticated: true,
    );
    try {
      final items = response
          .requireListData()
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const InvalidResponseException();
            }
            return Pond.parse(item);
          })
          .toList(growable: false);
      final meta = response.meta;
      if (meta == null ||
          meta['page'] is! int ||
          meta['limit'] is! int ||
          meta['totalResults'] is! int ||
          meta['totalPages'] is! int ||
          meta['hasNextPage'] is! bool) {
        throw const InvalidResponseException();
      }
      return PondPage(
        items: items,
        page: meta['page']! as int,
        limit: meta['limit']! as int,
        totalResults: meta['totalResults']! as int,
        totalPages: meta['totalPages']! as int,
        hasNextPage: meta['hasNextPage']! as bool,
      );
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  @override
  Future<Pond> getPond(String farmId, String pondId) async {
    final response = await _client.get(
      '${_path(farmId)}/$pondId',
      authenticated: true,
    );
    return Pond.parse(response.requireMapData());
  }

  @override
  Future<Pond> createPond(String farmId, Map<String, dynamic> data) async {
    final response = await _client.post(
      _path(farmId),
      data: data,
      authenticated: true,
    );
    return Pond.parse(response.requireMapData());
  }

  @override
  Future<Pond> updatePond(
    String farmId,
    String pondId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.patch(
      '${_path(farmId)}/$pondId',
      data: data,
      authenticated: true,
    );
    return Pond.parse(response.requireMapData());
  }

  @override
  Future<Pond> archivePond(String farmId, String pondId) =>
      _changeArchiveStatus(farmId, pondId, 'archive');

  @override
  Future<Pond> restorePond(String farmId, String pondId) =>
      _changeArchiveStatus(farmId, pondId, 'restore');

  Future<Pond> _changeArchiveStatus(
    String farmId,
    String pondId,
    String action,
  ) async {
    final response = await _client.patch(
      '${_path(farmId)}/$pondId/$action',
      authenticated: true,
    );
    return Pond.parse(response.requireMapData());
  }
}
