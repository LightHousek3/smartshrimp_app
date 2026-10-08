import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/pages/operation_list_page.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_stats_bar.dart';

void main() {
  group('OperationScheduleCard Widget', () {
    testWidgets('renders planned schedule card correctly', (tester) async {
      final schedule = OperationSchedule(
        id: 'sched-1',
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
        product: const OperationProduct(id: 'p1', name: 'Thức ăn CP 01'),
        protocolItem: const OperationProtocolItem(id: 'item-1', mealNumber: 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationScheduleCard(schedule: schedule, onTap: () {}),
          ),
        ),
      );

      expect(find.text('Thức ăn CP 01'), findsOneWidget);
      expect(find.text('Đã lên lịch'), findsOneWidget);
      expect(find.text('Cữ 1'), findsOneWidget);
      expect(find.textContaining('50.0 kg'), findsOneWidget);
    });

    testWidgets('renders completed schedule card correctly', (tester) async {
      final schedule = OperationSchedule(
        id: 'sched-2',
        seasonId: 'season-1',
        protocolItemId: 'item-2',
        operationType: OperationType.mineral,
        scheduledAt: DateTime.parse('2026-10-08T09:00:00Z'),
        plannedQuantity: 20.0,
        unit: 'kg',
        doseBasisSnapshot: 'FIXED_QUANTITY',
        doseValueSnapshot: 20.0,
        calculationVersion: 'v1',
        status: OperationStatus.completed,
        product: const OperationProduct(id: 'p2', name: 'Khoáng Cal-Phos'),
        execution: OperationExecution(
          id: 'exec-2',
          actualQuantity: 22.0,
          executedAt: DateTime.parse('2026-10-08T09:15:00Z'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationScheduleCard(schedule: schedule, onTap: () {}),
          ),
        ),
      );

      expect(find.text('Khoáng Cal-Phos'), findsOneWidget);
      expect(find.text('Đã thực hiện'), findsOneWidget);
      expect(find.textContaining('20.0 kg'), findsOneWidget);
    });

    testWidgets('renders cancelled schedule card with cancellation reason', (
      tester,
    ) async {
      final schedule = OperationSchedule(
        id: 'sched-3',
        seasonId: 'season-1',
        protocolItemId: 'item-3',
        operationType: OperationType.chemical,
        scheduledAt: DateTime.parse('2026-10-08T14:00:00Z'),
        plannedQuantity: 5.0,
        unit: 'lít',
        doseBasisSnapshot: 'PER_M3_WATER',
        doseValueSnapshot: 1.0,
        calculationVersion: 'v1',
        status: OperationStatus.cancelled,
        cancellationType: 'TREATMENT_ABORTED',
        cancellationReason: 'Nước đạt chuẩn, dừng xử lý',
        cancelledAt: DateTime.parse('2026-10-08T13:30:00Z'),
        product: const OperationProduct(id: 'p3', name: 'BKC 80%'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationScheduleCard(schedule: schedule, onTap: () {}),
          ),
        ),
      );

      expect(find.text('BKC 80%'), findsOneWidget);
      expect(find.text('Đã hủy'), findsOneWidget);
      expect(find.textContaining('5.0 lít'), findsOneWidget);
    });

  });

  group('OperationStatsBar Widget', () {
    testWidgets('renders all counts accurately', (tester) async {
      const summary = OperationSummary(
        planned: 5,
        completed: 12,
        cancelled: 2,
        total: 19,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OperationStatsBar(summary: summary)),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.textContaining('CHỜ THỰC'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.textContaining('HOÀN THÀNH'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.textContaining('ĐÃ HỦY'), findsOneWidget);
    });
  });

  group('OperationListPage Widget', () {
    testWidgets('renders list page with tabs, biomass warning banner and items', (
      tester,
    ) async {
      final fakeRepo = _MockOperationRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [operationRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(
            home: OperationListPage(seasonId: 'season-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Vận hành'), findsOneWidget);
      expect(find.text('Tất cả'), findsOneWidget);
      expect(find.text('Chờ làm'), findsOneWidget);
      expect(find.text('Hoàn thành'), findsOneWidget);
      expect(find.text('Đã hủy'), findsOneWidget);

      // Verify biomass warning banner
      expect(find.text('Chưa thể sinh lịch kế tiếp'), findsOneWidget);
      expect(
        find.textContaining('Chưa cập nhật sinh khối quá 3 ngày'),
        findsOneWidget,
      );

      // Verify sections
      expect(find.text('Cữ ăn & thuốc theo cữ'), findsOneWidget);
      expect(find.text('Xử lý khoáng / hóa chất'), findsOneWidget);

      // Tap on 'Hoàn thành' tab - should filter instantly on front-end without calling repo again
      await tester.tap(find.text('Hoàn thành'));
      await tester.pumpAndSettle();
      expect(fakeRepo.lastStatus, isNull);
      expect(find.text('Thức ăn CP 01'), findsNothing);
    });
  });
}

final class _MockOperationRepository implements OperationRepository {
  String? lastStatus;

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async {
    lastStatus = status;

    return OperationListResult(
      summary: const OperationSummary(
        planned: 1,
        completed: 1,
        cancelled: 0,
        total: 2,
      ),
      banner: const OperationBanner(
        hasBiomassWarning: true,
        message: 'Chưa cập nhật sinh khối quá 3 ngày',
      ),
      seasonName: 'Vụ 1 - Nuôi chính',
      pondName: 'Ao A1',
      schedules: <OperationSchedule>[
        OperationSchedule(
          id: 'sched-feed-1',
          seasonId: seasonId,
          protocolItemId: 'item-1',
          operationType: OperationType.feeding,
          scheduledAt: DateTime.parse('2026-10-08T07:00:00Z'),
          plannedQuantity: 40.0,
          unit: 'kg',
          doseBasisSnapshot: 'PERCENT_BIOMASS',
          doseValueSnapshot: 3.5,
          calculationVersion: 'v1',
          status: OperationStatus.planned,
          product: const OperationProduct(id: 'p1', name: 'Thức ăn CP 01'),
          protocolItem: const OperationProtocolItem(
            id: 'item-1',
            mealNumber: 1,
          ),
        ),
        OperationSchedule(
          id: 'sched-chem-1',
          seasonId: seasonId,
          protocolItemId: 'item-2',
          operationType: OperationType.chemical,
          scheduledAt: DateTime.parse('2026-10-08T10:00:00Z'),
          plannedQuantity: 10.0,
          unit: 'lít',
          doseBasisSnapshot: 'PER_M3_WATER',
          doseValueSnapshot: 2.0,
          calculationVersion: 'v1',
          status: OperationStatus.completed,
          product: const OperationProduct(
            id: 'p2',
            name: 'Yucca xử lý khí độc',
          ),
          execution: OperationExecution(
            id: 'exec-chem-1',
            actualQuantity: 10.0,
            executedAt: DateTime.parse('2026-10-08T10:05:00Z'),
          ),
        ),
      ],
    );
  }

  @override
  Future<OperationSchedule> getSchedule(String scheduleId) async {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<OperationStats> getSeasonStats(String seasonId) async {
    throw UnimplementedError();
  }
}
