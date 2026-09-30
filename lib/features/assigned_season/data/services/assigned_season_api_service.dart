import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';

final class AssignedSeasonApiService {
  AssignedSeasonApiService(this._client);
  final ApiClient _client;

  Future<AssignedSeasonPage> getAssignedSeasons(
    Map<String, dynamic> query,
  ) async {
    final response = await _client.get(
      '/me/seasons',
      authenticated: true,
      queryParameters: query,
    );
    final meta = response.meta;
    if (meta == null ||
        meta['totalResults'] is! int ||
        meta['activeResults'] is! int ||
        meta['allResults'] is! int ||
        meta['hasNextPage'] is! bool) {
      throw const InvalidResponseException();
    }
    return AssignedSeasonPage(
      items: response
          .requireListData()
          .map((raw) {
            if (raw is! Map<String, dynamic>) {
              throw const InvalidResponseException();
            }
            return AssignedSeason.parse(raw);
          })
          .toList(growable: false),
      totalResults: meta['totalResults'] as int,
      activeResults: meta['activeResults'] as int,
      allResults: meta['allResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
    );
  }

  Future<AssignedSeasonDetail> getAssignedSeason(String id) async {
    final response = await _client.get(
      '/me/seasons/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return AssignedSeasonDetail.parse(response.requireMapData());
  }
}
