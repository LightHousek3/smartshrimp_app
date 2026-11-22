import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';

class ShrimpHealthApiService {
  ShrimpHealthApiService(this._client, {this.basePath = '/technician/seasons'});
  final ApiClient _client;
  final String basePath;

  Future<int?> getAvailablePopulation(String seasonId, DateTime at) async {
    final response = await _client.get(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs/population',
      authenticated: true,
      queryParameters: {'at': at.toUtc().toIso8601String()},
    );
    final data = response.requireMapData();
    if (!data.containsKey('availableQuantityCount')) {
      throw const InvalidResponseException();
    }
    final raw = data['availableQuantityCount'];
    if (raw == null) return null;
    if (raw is! String || !RegExp(r'^\d+$').hasMatch(raw)) {
      throw const InvalidResponseException();
    }
    final value = int.tryParse(raw);
    if (value == null || value > 9007199254740991) {
      throw const InvalidResponseException();
    }
    return value;
  }

  Future<ShrimpHealthListResult> listLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    String? healthStatus,
    String? filter,
    int? limit,
    String? cursor,
    bool includeCounts = true,
  }) async {
    final query = <String, dynamic>{
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
      if (healthStatus != null && healthStatus.isNotEmpty)
        'healthStatus': healthStatus,
      if (filter != null && filter.isNotEmpty) 'filter': filter,
      'limit': ?limit,
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      'includeCounts': includeCounts,
    };

    final response = await _client.get(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs',
      authenticated: true,
      queryParameters: query,
    );

    final rawData = response.data;
    final List<dynamic> logsList = rawData is List ? rawData : [];
    final meta = response.meta;

    return ShrimpHealthListResult.fromJson(logsList, meta);
  }

  Future<ShrimpHealthLog> getLogDetail(String seasonId, String logId) async {
    final response = await _client.get(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs/${Uri.encodeComponent(logId)}',
      authenticated: true,
    );

    return ShrimpHealthLog.fromJson(response.requireMapData());
  }

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
  }) async {
    final body = <String, dynamic>{
      'recordedAt': recordedAt.toIso8601String(),
      'sampleSize': ?sampleSize,
      'avgWeightG': ?avgWeightG,
      'avgLengthCm': ?avgLengthCm,
      'mortalityCount': ?mortalityCount,
      'estimatedPopulation': ?estimatedPopulation,
      'estimatedBiomassKg': ?estimatedBiomassKg,
      'healthStatus': healthStatus.toApiValue(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    };

    final headers = <String, Object>{
      if (idempotencyKey != null && idempotencyKey.isNotEmpty)
        'idempotency-key': idempotencyKey,
    };

    final response = await _client.post(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs',
      authenticated: true,
      data: body,
      headers: headers.isNotEmpty ? headers : null,
    );

    return ShrimpHealthLog.fromJson(response.requireMapData());
  }

  Future<ShrimpHealthLog> voidLog(
    String seasonId,
    String logId,
    String voidReason,
  ) async {
    final response = await _client.patch(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs/${Uri.encodeComponent(logId)}/void',
      authenticated: true,
      data: <String, dynamic>{'voidReason': voidReason.trim()},
    );

    return ShrimpHealthLog.fromJson(response.requireMapData());
  }

  Future<ShrimpHealthStatsResult> getStatistics(
    String seasonId, {
    required DateTime from,
    required DateTime to,
    String granularity = 'day',
  }) async {
    final query = <String, dynamic>{
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'granularity': granularity,
    };

    final response = await _client.get(
      '$basePath/${Uri.encodeComponent(seasonId)}/shrimp-health-logs/statistics',
      authenticated: true,
      queryParameters: query,
    );

    return ShrimpHealthStatsResult.fromJson(response.requireMapData());
  }
}
