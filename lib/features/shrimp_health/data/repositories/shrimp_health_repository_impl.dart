import 'package:smartshrimp_app/features/shrimp_health/data/services/shrimp_health_api_service.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/repositories/shrimp_health_repository.dart';

final class ShrimpHealthRepositoryImpl implements ShrimpHealthRepository {
  ShrimpHealthRepositoryImpl(this._apiService);
  final ShrimpHealthApiService _apiService;

  @override
  Future<ShrimpHealthListResult> listLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    String? healthStatus,
    String? filter,
    int? limit,
    String? cursor,
    bool includeCounts = true,
  }) => _apiService.listLogs(
    seasonId,
    from: from,
    to: to,
    healthStatus: healthStatus,
    filter: filter,
    limit: limit,
    cursor: cursor,
    includeCounts: includeCounts,
  );

  @override
  Future<ShrimpHealthLog> getLogDetail(String seasonId, String logId) =>
      _apiService.getLogDetail(seasonId, logId);

  @override
  Future<ShrimpHealthLog> createLog(
    String seasonId, {
    required DateTime recordedAt,
    int? sampleSize,
    double? avgWeightG,
    double? avgLengthCm,
    int? mortalityCount,
    int? estimatedPopulation,
    double? estimatedBiomassKg,
    HealthStatus healthStatus = HealthStatus.good,
    String? note,
    String? idempotencyKey,
  }) => _apiService.createLog(
    seasonId,
    recordedAt: recordedAt,
    sampleSize: sampleSize,
    avgWeightG: avgWeightG,
    avgLengthCm: avgLengthCm,
    mortalityCount: mortalityCount,
    estimatedPopulation: estimatedPopulation,
    estimatedBiomassKg: estimatedBiomassKg,
    healthStatus: healthStatus,
    note: note,
    idempotencyKey: idempotencyKey,
  );

  @override
  Future<ShrimpHealthLog> voidLog(
    String seasonId,
    String logId,
    String voidReason,
  ) => _apiService.voidLog(seasonId, logId, voidReason);

  @override
  Future<ShrimpHealthStatsResult> getStatistics(
    String seasonId, {
    required DateTime from,
    required DateTime to,
    String granularity = 'day',
  }) => _apiService.getStatistics(
    seasonId,
    from: from,
    to: to,
    granularity: granularity,
  );
}
