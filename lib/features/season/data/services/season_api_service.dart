import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

abstract interface class SeasonRemoteDataSource {
  Future<SeasonPage> getSeasons(Map<String, dynamic> query);
  Future<AquacultureSeason> getSeason(String seasonId);
  Future<AquacultureSeason> createSeason(Map<String, dynamic> data);
  Future<AquacultureSeason> updateSeason(
    String seasonId,
    Map<String, dynamic> data,
  );
  Future<AquacultureSeason> activateSeason(
    String seasonId,
    Map<String, dynamic> data,
  );
  Future<SeasonCancellationResult> cancelSeason(
    String seasonId,
    Map<String, dynamic> data,
  );
}

final class SeasonApiService implements SeasonRemoteDataSource {
  SeasonApiService(this._client);

  final ApiClient _client;
  static const _basePath = '/owner/seasons';

  @override
  Future<SeasonPage> getSeasons(Map<String, dynamic> query) async {
    final response = await _client.get(
      _basePath,
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
            return AquacultureSeason.fromJson(item);
          })
          .toList(growable: false);
      final meta = response.meta;
      if (meta == null ||
          meta['limit'] is! int ||
          meta['totalResults'] is! int ||
          meta['hasNextPage'] is! bool ||
          (meta['nextCursor'] != null && meta['nextCursor'] is! String)) {
        throw const InvalidResponseException();
      }
      return SeasonPage(
        items: items,
        limit: meta['limit']! as int,
        totalResults: meta['totalResults']! as int,
        hasNextPage: meta['hasNextPage']! as bool,
        nextCursor: meta['nextCursor'] as String?,
      );
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  @override
  Future<AquacultureSeason> getSeason(String seasonId) async {
    final response = await _client.get(
      '$_basePath/$seasonId',
      authenticated: true,
    );
    return AquacultureSeason.fromJson(response.requireMapData());
  }

  @override
  Future<AquacultureSeason> createSeason(Map<String, dynamic> data) async {
    final response = await _client.post(
      _basePath,
      data: data,
      authenticated: true,
    );
    return AquacultureSeason.fromJson(response.requireMapData());
  }

  @override
  Future<AquacultureSeason> updateSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.patch(
      '$_basePath/$seasonId',
      data: data,
      authenticated: true,
    );
    return AquacultureSeason.fromJson(response.requireMapData());
  }

  @override
  Future<AquacultureSeason> activateSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.patch(
      '$_basePath/$seasonId/activate',
      data: data,
      authenticated: true,
    );
    return AquacultureSeason.fromJson(response.requireMapData());
  }

  @override
  Future<SeasonCancellationResult> cancelSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.patch(
      '$_basePath/$seasonId/cancel',
      data: data,
      authenticated: true,
    );
    return SeasonCancellationResult.fromJson(response.requireMapData());
  }
}
