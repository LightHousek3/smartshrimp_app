import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
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

  Future<SeasonAssignment> assignPersonnel({
    required String seasonId,
    required String accountId,
    required AccountRole role,
  });

  Future<SeasonPersonnelReplacementResult> replacePersonnel({
    required String seasonId,
    required String accountId,
    required AccountRole role,
    required String expectedAssignmentId,
    required String reason,
  });
}
