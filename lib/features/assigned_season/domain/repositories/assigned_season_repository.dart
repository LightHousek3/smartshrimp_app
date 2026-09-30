import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';

abstract interface class AssignedSeasonRepository {
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = 20,
  });
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId);
}
