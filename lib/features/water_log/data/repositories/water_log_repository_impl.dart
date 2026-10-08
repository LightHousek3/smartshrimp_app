import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';

final class WaterLogRepositoryImpl implements WaterLogRepository {
  WaterLogRepositoryImpl(this._apiService);

  final WaterLogApiService _apiService;

  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    int limit = 20,
    String? cursor,
  }) => _apiService.getWaterLogs(
    seasonId,
    from: from,
    to: to,
    includeVoided: includeVoided,
    limit: limit,
    cursor: cursor,
  );

  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) => _apiService.createWaterLog(seasonId, payload, idempotencyKey);

  @override
  Future<WaterLog> voidWaterLog({
    required String seasonId,
    required String logId,
    required String voidReason,
  }) => _apiService.voidWaterLog(seasonId, logId, voidReason);

  @override
  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) => _apiService.getStatistics(
    seasonId,
    from: from,
    to: to,
    granularity: granularity,
  );
}
