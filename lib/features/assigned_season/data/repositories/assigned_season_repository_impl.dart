import 'package:smartshrimp_app/features/assigned_season/data/services/assigned_season_api_service.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';

final class AssignedSeasonRepositoryImpl implements AssignedSeasonRepository {
  AssignedSeasonRepositoryImpl(this._api);
  final AssignedSeasonApiService _api;

  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = 20,
  }) {
    final query = <String, dynamic>{'limit': limit};
    if (status != null) query['status'] = status.name;
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (farmId != null) query['farmId'] = farmId;
    if (cursor != null) query['cursor'] = cursor;
    return _api.getAssignedSeasons(query);
  }

  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) =>
      _api.getAssignedSeason(seasonId);
}
