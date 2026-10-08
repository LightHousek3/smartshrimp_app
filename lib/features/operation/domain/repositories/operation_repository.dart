import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

abstract interface class OperationRepository {
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  });

  Future<OperationSchedule> getSchedule(String scheduleId);

  Future<OperationExecution> executeSchedule(
    String scheduleId, {
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
  });

  Future<OperationStats> getSeasonStats(String seasonId);
}
