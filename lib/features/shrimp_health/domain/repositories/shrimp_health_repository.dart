import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';

abstract interface class ShrimpHealthRepository {
  Future<ShrimpHealthListResult> listLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    String? healthStatus,
    String? filter,
    int? limit,
    String? cursor,
    bool includeCounts = true,
  });

  Future<ShrimpHealthLog> getLogDetail(String seasonId, String logId);

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
  });

  Future<ShrimpHealthLog> voidLog(
    String seasonId,
    String logId,
    String voidReason,
  );

  Future<ShrimpHealthStatsResult> getStatistics(
    String seasonId, {
    required DateTime from,
    required DateTime to,
    String granularity = 'day',
  });
}
