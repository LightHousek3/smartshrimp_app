import 'package:smartshrimp_app/features/operation/data/services/operation_api_service.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';

final class OperationRepositoryImpl implements OperationRepository {
  OperationRepositoryImpl(this._apiService);
  final OperationApiService _apiService;

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) => _apiService.getSchedules(
    seasonId,
    status: status,
    operationType: operationType,
    date: date,
    page: page,
    limit: limit,
  );

  @override
  Future<OperationSchedule> getSchedule(String scheduleId) =>
      _apiService.getSchedule(scheduleId);

  @override
  Future<OperationExecution> executeSchedule(
    String scheduleId, {
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
  }) => _apiService.executeSchedule(
    scheduleId,
    actualQuantity: actualQuantity,
    idempotencyKey: idempotencyKey,
    actualProductId: actualProductId,
    note: note,
    varianceReason: varianceReason,
    executedAt: executedAt,
  );

  @override
  Future<OperationStats> getSeasonStats(String seasonId) =>
      _apiService.getSeasonStats(seasonId);
}
