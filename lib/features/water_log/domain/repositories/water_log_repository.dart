import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

abstract class WaterLogRepository {
  Future<WaterLogMetadata> getMetadata({required String seasonId});
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    WaterLogFilter? filter,
    bool includeCounts = false,
    int limit = 20,
    String? cursor,
  });

  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  });

  Future<WaterLog> voidWaterLog({
    required String seasonId,
    required String logId,
    required String voidReason,
  });

  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    required DateTime from,
    required DateTime to,
    required String granularity,
  });
}
