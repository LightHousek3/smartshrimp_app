import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

class OperationApiService {
  OperationApiService(this._client);
  final ApiClient _client;

  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async {
    final query = <String, dynamic>{
      if (status != null && status.isNotEmpty) 'status': status,
      if (operationType != null && operationType.isNotEmpty)
        'operationType': operationType,
      if (date != null && date.isNotEmpty) 'date': date,
      'page': ?page,
      'limit': ?limit,
    };

    final response = await _client.get(
      '/operations/seasons/${Uri.encodeComponent(seasonId)}/schedules',
      authenticated: true,
      queryParameters: query,
    );

    return OperationListResult.fromJson(response.requireMapData());
  }

  Future<OperationSchedule> getSchedule(String scheduleId) async {
    final response = await _client.get(
      '/operations/schedules/${Uri.encodeComponent(scheduleId)}',
      authenticated: true,
    );

    return OperationSchedule.fromJson(response.requireMapData());
  }

  Future<OperationExecution> executeSchedule(
    String scheduleId, {
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
  }) async {
    final body = <String, dynamic>{
      'actualQuantity': actualQuantity,
      'idempotencyKey': idempotencyKey,
      'actualProductId': ?actualProductId,
      if (note != null && note.isNotEmpty) 'note': note,
      if (varianceReason != null && varianceReason.isNotEmpty)
        'varianceReason': varianceReason,
      if (executedAt != null) 'executedAt': executedAt.toIso8601String(),
    };

    final response = await _client.post(
      '/operations/schedules/${Uri.encodeComponent(scheduleId)}/execute',
      authenticated: true,
      data: body,
    );

    return OperationExecution.fromJson(response.requireMapData());
  }

  Future<OperationStats> getSeasonStats(String seasonId) async {
    final response = await _client.get(
      '/operations/seasons/${Uri.encodeComponent(seasonId)}/stats',
      authenticated: true,
    );

    return OperationStats.fromJson(response.requireMapData());
  }
}
