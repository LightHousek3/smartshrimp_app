import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';

final class WaterLogApiService {
  WaterLogApiService(this._client, this._basePath);

  final ApiClient _client;

  /// Base path theo role: '/me/seasons' | '/expert/seasons' | '/owner/seasons'.
  final String _basePath;

  String _path(String seasonId) =>
      '$_basePath/${Uri.encodeComponent(seasonId)}/water-logs';

  Future<WaterLogPage> getWaterLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    int limit = 20,
    String? cursor,
  }) async {
    final query = <String, dynamic>{
      'includeVoided': includeVoided,
      'limit': limit,
    };
    if (from != null) query['from'] = from.toUtc().toIso8601String();
    if (to != null) query['to'] = to.toUtc().toIso8601String();
    if (cursor != null) query['cursor'] = cursor;

    final response = await _client.get(
      _path(seasonId),
      authenticated: true,
      queryParameters: query,
    );
    final meta = response.meta;
    if (meta == null ||
        meta['totalResults'] is! int ||
        meta['hasNextPage'] is! bool) {
      throw const InvalidResponseException();
    }
    return WaterLogPage(
      items: response
          .requireListData()
          .map((raw) {
            if (raw is! Map<String, dynamic>) {
              throw const InvalidResponseException();
            }
            return WaterLog.parse(raw);
          })
          .toList(growable: false),
      totalResults: meta['totalResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
    );
  }

  Future<WaterLog> createWaterLog(
    String seasonId,
    Map<String, Object?> payload,
    String idempotencyKey,
  ) async {
    final response = await _client.post(
      _path(seasonId),
      authenticated: true,
      data: payload,
      headers: <String, String>{'Idempotency-Key': idempotencyKey},
    );
    return WaterLog.parse(response.requireMapData());
  }

  Future<WaterLog> voidWaterLog(
    String seasonId,
    String logId,
    String voidReason,
  ) async {
    final response = await _client.post(
      '${_path(seasonId)}/${Uri.encodeComponent(logId)}/void',
      authenticated: true,
      data: <String, Object?>{'voidReason': voidReason},
    );
    return WaterLog.parse(response.requireMapData());
  }

  Future<WaterLogStatistics> getStatistics(
    String seasonId, {
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) async {
    final response = await _client.get(
      '${_path(seasonId)}/statistics',
      authenticated: true,
      queryParameters: <String, dynamic>{
        'from': from.toUtc().toIso8601String(),
        'to': to.toUtc().toIso8601String(),
        'granularity': granularity,
      },
    );
    return WaterLogStatistics.parse(response.requireMapData());
  }
}
