import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/pages/operation_list_page.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_execute_sheet.dart';
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

    testWidgets('renders overdue badge when planned schedule passes deadline', (
      tester,
    ) async {
      final schedule = OperationSchedule(
        id: 'sched-overdue-card',
        seasonId: 'season-1',
        protocolItemId: 'item-4',
        operationType: OperationType.mineral,
        scheduledAt: DateTime.now().subtract(const Duration(hours: 2)),
        plannedQuantity: 10.0,
        unit: 'kg',
        doseBasisSnapshot: 'FIXED_QUANTITY',
        doseValueSnapshot: 10.0,
        calculationVersion: 'v3',
        status: OperationStatus.planned,
        product: const OperationProduct(id: 'p4', name: 'Khoáng Mix'),
        protocolItem: const OperationProtocolItem(
          id: 'item-4',
          dueAtMinutes: 30,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationScheduleCard(schedule: schedule, onTap: () {}),
          ),
        ),
      );

      expect(find.text('Khoáng Mix'), findsOneWidget);
      expect(find.text('Đã lên lịch'), findsOneWidget);
      expect(find.text('Quá hạn'), findsOneWidget);
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
      expect(find.text('Tất cả'), findsNothing);
      expect(find.text('Chờ làm'), findsOneWidget);
      expect(find.text('Hoàn thành'), findsOneWidget);
      expect(find.text('Đã hủy'), findsOneWidget);

      // Verify biomass warning banner
      expect(find.text('Chưa thể sinh lịch kế tiếp'), findsOneWidget);
      expect(
        find.textContaining('Chưa cập nhật sinh khối quá 7 ngày (168 giờ)'),
        findsOneWidget,
      );

      // Verify sections: tab mặc định "Chờ làm" chỉ có cữ ăn, ẩn mục khoáng/hóa chất trống
      expect(find.text('Cữ ăn & thuốc theo cữ'), findsOneWidget);
      expect(find.text('Xử lý khoáng / hóa chất'), findsNothing);

      // Tap on 'Hoàn thành' tab - should filter instantly on front-end without calling repo again
      await tester.tap(find.text('Hoàn thành'));
      await tester.pumpAndSettle();
      expect(fakeRepo.lastStatus, isNull);
      expect(find.text('Thức ăn CP 01'), findsNothing);
      expect(find.text('Cữ ăn & thuốc theo cữ'), findsNothing);
      expect(find.text('Xử lý khoáng / hóa chất'), findsOneWidget);
    });
  });

  group('OperationExecuteSheet & Variance Validation', () {
    test('OperationVarianceEvaluation handles boundaries and ratios accurately', () {
      // Exact upper/lower boundary (2.0 ± 10% => 1.8 .. 2.2) should NOT exceed
      const upperBoundary = OperationVarianceEvaluation(
        planned: 2.0,
        actual: 2.2,
        allowedPct: 10,
      );
      expect(upperBoundary.exceedsAllowed, isFalse);

      const lowerBoundary = OperationVarianceEvaluation(
        planned: 2.0,
        actual: 1.8,
        allowedPct: 10,
      );
      expect(lowerBoundary.exceedsAllowed, isFalse);

      // Above allowed (2x planned)
      const above = OperationVarianceEvaluation(
        planned: 2.0,
        actual: 4.0,
        allowedPct: 10,
      );
      expect(above.isAboveAllowed, isTrue);
      expect(above.exceedsAllowed, isTrue);
      expect(above.warningMessage('kg'), contains('cao gấp 2 lần'));

      // Below allowed (0.5x planned => 2x smaller)
      const below = OperationVarianceEvaluation(
        planned: 2.0,
        actual: 1.0,
        allowedPct: 10,
      );
      expect(below.isBelowAllowed, isTrue);
      expect(below.exceedsAllowed, isTrue);
      expect(below.warningMessage('kg'), contains('chỉ bằng 0.5 lần'));
      expect(below.warningMessage('kg'), contains('nhỏ hơn 2 lần'));
    });

    testWidgets(
      'OperationExecuteSheet hides note field, shows red banner with ratio, and requires reason when out of range',
      (tester) async {
        final schedule = OperationSchedule(
          id: 'sched-exec-1',
          seasonId: 'season-1',
          protocolItemId: 'item-1',
          operationType: OperationType.feeding,
          scheduledAt: DateTime.now().subtract(const Duration(minutes: 10)),
          plannedQuantity: 2.0,
          unit: 'kg',
          doseBasisSnapshot: 'FIXED_QUANTITY',
          doseValueSnapshot: 2.0,
          calculationVersion: 'v3',
          status: OperationStatus.planned,
          product: const OperationProduct(id: 'p1', name: 'HI-TOM 9802'),
          protocolItem: const OperationProtocolItem(
            id: 'item-1',
            mealNumber: 1,
            protocol: OperationProtocol(
              id: 'proto-1',
              title: 'Phác đồ nuôi',
              allowedVariancePct: 10,
            ),
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: OperationExecuteSheet(
                  schedule: schedule,
                  onSuccess: () {},
                ),
              ),
            ),
          ),
        );

        // Không có ô Ghi chú
        expect(find.textContaining('Ghi chú'), findsNothing);
        // Ban đầu hợp lệ (chênh 0%) => nút bật, không yêu cầu lý do
        expect(find.text('Lý do chênh lệch *'), findsNothing);
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNotNull,
        );

        // BR-57: lệch nhẹ trong khoảng cho phép (2.1 kg = +5% <= 10%) => KHÔNG hiện box đỏ, nhưng VẪN cần lý do
        await tester.enterText(find.byType(TextField).first, '2.1');
        await tester.pumpAndSettle();
        expect(find.byType(AppFormMessageBanner), findsNothing);
        expect(find.text('Lý do chênh lệch *'), findsOneWidget);
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNull,
        );

        // Nhập lớn hơn ngưỡng cho phép (4 kg = gấp 2 lần) => hiện box đỏ chuẩn + yêu cầu lý do
        await tester.enterText(find.byType(TextField).first, '4');
        await tester.pumpAndSettle();

        expect(find.byType(AppFormMessageBanner), findsOneWidget);
        expect(find.textContaining('cao gấp 2 lần'), findsOneWidget);
        expect(find.text('Lý do chênh lệch *'), findsOneWidget);
        // Chưa nhập lý do => nút ghi nhận bị khóa
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNull,
        );

        // Nhập lý do => cho phép ghi nhận
        await tester.enterText(
          find.byType(TextField).at(1),
          'Tôm ăn mạnh hơn dự kiến',
        );
        await tester.pumpAndSettle();
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNotNull,
        );

        // Nhập nhỏ hơn ngưỡng cho phép (1 kg = 0.5 lần / nhỏ hơn 2 lần)
        await tester.enterText(find.byType(TextField).first, '1');
        await tester.pumpAndSettle();
        expect(find.textContaining('chỉ bằng 0.5 lần'), findsOneWidget);
        expect(find.textContaining('nhỏ hơn 2 lần'), findsOneWidget);
      },
    );

    testWidgets(
      'OperationExecuteSheet disables submit button before scheduledAt',
      (tester) async {
        final futureSchedule = OperationSchedule(
          id: 'sched-exec-future',
          seasonId: 'season-1',
          protocolItemId: 'item-1',
          operationType: OperationType.feeding,
          scheduledAt: DateTime.now().add(const Duration(hours: 1)),
          plannedQuantity: 2.0,
          unit: 'kg',
          doseBasisSnapshot: 'FIXED_QUANTITY',
          doseValueSnapshot: 2.0,
          calculationVersion: 'v3',
          status: OperationStatus.planned,
          product: const OperationProduct(id: 'p1', name: 'HI-TOM 9802'),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: OperationExecuteSheet(
                  schedule: futureSchedule,
                  onSuccess: () {},
                ),
              ),
            ),
          ),
        );

        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNull,
        );
      },
    );

    testWidgets(
      'OperationMealExecuteSheet blocks submit and warns when any 1 material lacks stock',
      (tester) async {
        final nowMinus = DateTime.now().subtract(const Duration(minutes: 10));
        final feedSchedule = OperationSchedule(
          id: 'sched-feed-ok',
          seasonId: 'season-1',
          protocolItemId: 'item-1',
          operationType: OperationType.feeding,
          scheduledAt: nowMinus,
          plannedQuantity: 2.0,
          unit: 'kg',
          doseBasisSnapshot: 'FIXED_QUANTITY',
          doseValueSnapshot: 2.0,
          calculationVersion: 'v3',
          status: OperationStatus.planned,
          product: const OperationProduct(id: 'p1', name: 'HI-TOM 9802'),
          availableStock: 350.0,
          hasSufficientStock: true,
        );
        final medSchedule = OperationSchedule(
          id: 'sched-med-short',
          seasonId: 'season-1',
          protocolItemId: 'item-2',
          operationType: OperationType.medicine,
          scheduledAt: nowMinus,
          plannedQuantity: 1.0,
          unit: 'kg',
          doseBasisSnapshot: 'FIXED_QUANTITY',
          doseValueSnapshot: 1.0,
          calculationVersion: 'v3',
          status: OperationStatus.planned,
          product: const OperationProduct(
            id: 'p2',
            name: 'EN-GRO Uni-President',
          ),
          availableStock: 0.0,
          hasSufficientStock: false,
        );

        final group = FeedingMedicineMealGroup(
          key: 'meal-1',
          mealNumber: 1,
          time: '07:30',
          scheduledAt: nowMinus,
          feedings: <OperationSchedule>[feedSchedule],
          medicines: <OperationSchedule>[medSchedule],
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: OperationMealExecuteSheet(
                  group: group,
                  onSuccess: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Không đủ vật tư trong kho'), findsOneWidget);
        expect(
          find.textContaining('EN-GRO Uni-President'),
          findsAtLeastNWidgets(1),
        );
        expect(
          tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
          isNull,
        );
      },
    );
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
        message: 'Chưa cập nhật sinh khối quá 7 ngày (168 giờ)',
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
  Future<List<OperationExecution>> executeSchedulesBatch(
    List<OperationExecuteBatchItem> items,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<OperationStats> getSeasonStats(String seasonId) async {
    throw UnimplementedError();
  }
}
