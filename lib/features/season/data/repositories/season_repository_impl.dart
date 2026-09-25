import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';

final class SeasonRepositoryImpl implements SeasonRepository {
  SeasonRepositoryImpl(this._remote);

  final SeasonRemoteDataSource _remote;

  @override
  Future<SeasonPage> getSeasons({
    String? farmId,
    String? pondId,
    SeasonStatus? status,
    String search = '',
    String? cursor,
    int limit = 20,
  }) => _remote.getSeasons(<String, dynamic>{
    'farmId': ?farmId,
    'pondId': ?pondId,
    if (status != null) 'status': seasonStatusApiValue(status),
    'search': SeasonRules.normalizeText(search),
    'cursor': ?cursor,
    'limit': limit,
  });

  @override
  Future<AquacultureSeason> getSeason(String seasonId) =>
      _remote.getSeason(seasonId);

  @override
  Future<AquacultureSeason> createSeason({
    required String pondId,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  }) => _remote.createSeason(
    _writeData(
      pondId: pondId,
      name: name,
      shrimpType: shrimpType,
      stockingDate: stockingDate,
      expectedEndDate: expectedEndDate,
      initialQuantity: initialQuantity,
      initialAvgWeightG: initialAvgWeightG,
    ),
  );

  @override
  Future<AquacultureSeason> updateSeason({
    required AquacultureSeason current,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  }) => _remote.updateSeason(current.id, <String, dynamic>{
    ..._writeData(
      name: name,
      shrimpType: shrimpType,
      stockingDate: stockingDate,
      expectedEndDate: expectedEndDate,
      initialQuantity: initialQuantity,
      initialAvgWeightG: initialAvgWeightG,
    ),
    'expectedUpdatedAt': current.updatedAt.toUtc().toIso8601String(),
  });

  @override
  Future<AquacultureSeason> activateSeason(AquacultureSeason current) =>
      _remote.activateSeason(current.id, <String, dynamic>{
        'expectedUpdatedAt': current.updatedAt.toUtc().toIso8601String(),
      });

  @override
  Future<SeasonCancellationResult> cancelSeason({
    required AquacultureSeason current,
    required String reason,
  }) => _remote.cancelSeason(current.id, <String, dynamic>{
    'reason': SeasonRules.normalizeText(reason),
    'expectedUpdatedAt': current.updatedAt.toUtc().toIso8601String(),
  });

  static Map<String, dynamic> _writeData({
    String? pondId,
    required String name,
    required ShrimpType shrimpType,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
  }) => <String, dynamic>{
    'pondId': ?pondId,
    'name': SeasonRules.normalizeText(name),
    'shrimpType': shrimpTypeApiValue(shrimpType),
    'stockingDate': stockingDate == null
        ? null
        : SeasonRules.dateOnly(stockingDate),
    'expectedEndDate': expectedEndDate == null
        ? null
        : SeasonRules.dateOnly(expectedEndDate),
    'initialQuantity': initialQuantity,
    'initialAvgWeightG': initialAvgWeightG,
  };
}
