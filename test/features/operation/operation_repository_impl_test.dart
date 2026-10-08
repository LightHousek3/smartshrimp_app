import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/operation/data/repositories/operation_repository_impl.dart';
import 'package:smartshrimp_app/features/operation/data/services/operation_api_service.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

void main() {
  group('OperationRepositoryImpl', () {
    late _FakeOperationApiService fakeApi;
    late OperationRepositoryImpl repository;

    setUp(() {
      fakeApi = _FakeOperationApiService();
      repository = OperationRepositoryImpl(fakeApi);
    });

    test('delegates getSchedules to api service with arguments', () async {
      final result = await repository.getSchedules(
        'season-1',
        status: 'PLANNED',
        operationType: 'FEEDING',
        date: '2026-10-08',
      );

      expect(fakeApi.lastSeasonId, 'season-1');
      expect(fakeApi.lastStatus, 'PLANNED');
      expect(fakeApi.lastType, 'FEEDING');
      expect(fakeApi.lastDate, '2026-10-08');
      expect(result.summary.total, 1);
    });

    test('delegates getSchedule to api service', () async {
      final schedule = await repository.getSchedule('sched-1');

      expect(fakeApi.lastScheduleId, 'sched-1');
      expect(schedule.id, 'sched-1');
    });

    test('delegates executeSchedule to api service', () async {
      final exec = await repository.executeSchedule(
        'sched-1',
        actualQuantity: 45.0,
        idempotencyKey: 'idem-1',
        varianceReason: 'Giảm lượng ăn do mưa',
        note: 'Đã hoàn thành',
      );

      expect(fakeApi.lastExecuteScheduleId, 'sched-1');
      expect(fakeApi.lastActualQuantity, 45.0);
      expect(fakeApi.lastIdempotencyKey, 'idem-1');
      expect(exec.id, 'exec-1');
    });

    test('delegates getSeasonStats to api service', () async {
      final stats = await repository.getSeasonStats('season-1');

      expect(fakeApi.lastStatsSeasonId, 'season-1');
      expect(stats.total, 10);
    });
  });
}

final class _FakeOperationApiService implements OperationApiService {
  String? lastSeasonId;
  String? lastStatus;
  String? lastType;
  String? lastDate;

  String? lastScheduleId;

  String? lastExecuteScheduleId;
  double? lastActualQuantity;
  String? lastIdempotencyKey;

  String? lastStatsSeasonId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async {
    lastSeasonId = seasonId;
    lastStatus = status;
    lastType = operationType;
    lastDate = date;

    return const OperationListResult(
      summary: OperationSummary(
        planned: 1,
        completed: 0,
        cancelled: 0,
        total: 1,
      ),
      banner: OperationBanner(hasBiomassWarning: false),
      schedules: <OperationSchedule>[],
    );
  }

  @override
  Future<OperationSchedule> getSchedule(String scheduleId) async {
    lastScheduleId = scheduleId;
    return OperationSchedule(
      id: scheduleId,
      seasonId: 'season-1',
      protocolItemId: 'item-1',
      operationType: OperationType.feeding,
      scheduledAt: DateTime.parse('2026-10-08T07:00:00Z'),
      plannedQuantity: 50.0,
      unit: 'kg',
      doseBasisSnapshot: 'PERCENT_BIOMASS',
      doseValueSnapshot: 3.5,
      calculationVersion: 'v1',
      status: OperationStatus.planned,
    );
  }

  @override
  Future<OperationExecution> executeSchedule(
    String scheduleId, {
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
  }) async {
    lastExecuteScheduleId = scheduleId;
    lastActualQuantity = actualQuantity;
    lastIdempotencyKey = idempotencyKey;

    return OperationExecution(
      id: 'exec-1',
      actualQuantity: actualQuantity,
      executedAt: executedAt ?? DateTime.now(),
      varianceReason: varianceReason,
      note: note,
    );
  }

  @override
  Future<OperationStats> getSeasonStats(String seasonId) async {
    lastStatsSeasonId = seasonId;
    return const OperationStats(
      total: 10,
      planned: 3,
      completed: 6,
      cancelled: 1,
      overdue: 0,
      completionRate: 60.0,
      byType: <String, OperationTypeStats>{},
    );
  }
}
