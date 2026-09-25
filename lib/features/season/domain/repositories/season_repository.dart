import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

abstract interface class SeasonRepository {
  Future<SeasonPage> getSeasons({
    String? farmId,
    String? pondId,
    SeasonStatus? status,
    String search = '',
    String? cursor,
    int limit = 20,
  });

  Future<AquacultureSeason> getSeason(String seasonId);

  Future<AquacultureSeason> createSeason({
    required String pondId,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  });

  Future<AquacultureSeason> updateSeason({
    required AquacultureSeason current,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  });

  Future<AquacultureSeason> activateSeason(AquacultureSeason current);

  Future<SeasonCancellationResult> cancelSeason({
    required AquacultureSeason current,
    required String reason,
  });
}
