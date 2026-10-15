import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_counts.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

final class WaterLogApiService {
  WaterLogApiService(this._client, this._basePath);

  final ApiClient _client;

  /// Base path theo role: '/me/seasons' | '/expert/seasons' | '/owner/seasons'.
  final String _basePath;

  String _path(String seasonId) =>
      '$_basePath/${Uri.encodeComponent(seasonId)}/water-logs';

  Future<WaterLogMetadata> getMetadata(String seasonId) async {
    final response = await _client.get(
      '${_path(seasonId)}/metadata',
      authenticated: true,
    );
    return WaterLogMetadata.parse(response.requireMapData());
  }

  Future<WaterLogPage> getWaterLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    WaterLogFilter? filter,
    bool includeCounts = false,
    int limit = 20,
    String? cursor,
  }) async {
    final query = <String, dynamic>{
      if (filter == null) 'includeVoided': includeVoided,
      if (filter != null) 'filter': filter.name,
      if (includeCounts) 'includeCounts': true,
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
        meta['hasNextPage'] is! bool ||
        (meta['totalResults'] as int) < 0 ||
        (meta['nextCursor'] != null && meta['nextCursor'] is! String) ||
        (meta['hasNextPage'] == true &&
            (meta['nextCursor'] == null ||
                (meta['nextCursor'] as String).trim().isEmpty ||
                meta['nextCursor'] == cursor))) {
      throw const InvalidResponseException();
    }
    final data = response.requireListData();
    if (meta['hasNextPage'] == true && data.isEmpty) {
      throw const InvalidResponseException();
    }
    return WaterLogPage(
      items: data
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
      counts: includeCounts || meta.containsKey('counts')
          ? WaterLogCounts.parse(meta['counts'])
          : null,
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
