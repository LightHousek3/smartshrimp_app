import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/pages/operation_detail_page.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/pages/operation_list_page.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_group_card.dart';
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
    for (final historical in [false, true]) {
      testWidgets(
        'opens detail for saved and historical occurrences: $historical',
        (tester) async {
          final repository = _MockOperationRepository(historical: historical);
          final router = GoRouter(
            initialLocation: '/seasons/season-1/operations',
            routes: [
              GoRoute(
                path: '/seasons/:seasonId/operations',
                builder: (_, _) =>
                    const OperationListPage(seasonId: 'season-1'),
                routes: [
                  GoRoute(
                    path: ':scheduleId',
                    builder: (_, state) => OperationDetailPage(
                      seasonId: 'season-1',
                      scheduleId: state.pathParameters['scheduleId']!,
                      mealGroup: state.extra as FeedingMedicineMealGroup,
                    ),
                  ),
                ],
              ),
            ],
          );
          addTearDown(router.dispose);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                operationRepositoryProvider.overrideWithValue(repository),
                assignedSeasonCanWriteProvider(
                  'season-1',
                ).overrideWithValue(true),
              ],
              child: MaterialApp.router(routerConfig: router),
            ),
          );
          await tester.pumpAndSettle();
          final title = find.text('Cữ 1');
          await tester.ensureVisible(title);
          final status = find.text('Đã lên lịch');
          final arrow = find.byTooltip('Thu gọn cữ').evaluate().isEmpty
              ? find.byTooltip('Mở danh sách vật tư')
              : find.byTooltip('Thu gọn cữ');
          expect(
            tester.getCenter(status).dy,
            closeTo(tester.getCenter(title).dy, 2),
          );
          expect(
            tester.getCenter(arrow).dy,
            closeTo(tester.getCenter(title).dy, 2),
          );
          expect(
            tester.getCenter(status).dx,
            greaterThan(tester.getCenter(title).dx),
          );
          expect(
            tester.getCenter(arrow).dx,
            greaterThan(tester.getCenter(status).dx),
          );
          expect(
            tester.getRect(find.byType(OperationMealGroupCard)).right -
                tester.getCenter(arrow).dx,
            lessThanOrEqualTo(32),
          );
          await tester.tap(title);
          await tester.pumpAndSettle();
          expect(
            repository.lastScheduleId,
            historical ? isNull : 'sched-feed-1',
          );
          expect(find.text('Chi tiết vận hành'), findsOneWidget);
          expect(
            find.text(historical ? 'Ghi nhận bổ sung' : 'Ghi nhận thực hiện'),
            findsOneWidget,
          );
          if (historical) {
            final save = find.text('Ghi nhận bổ sung');
            await tester.ensureVisible(save);
            await tester.tap(save);
            await tester.pumpAndSettle();
            final form = find.byType(OperationExecuteSheet);
            expect(form, findsOneWidget);
            expect(
              find.descendant(of: form, matching: find.text('Thức ăn bổ sung')),
              findsOneWidget,
            );
            expect(
              find.descendant(of: form, matching: find.text('Thức ăn CP 01')),
              findsOneWidget,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }

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

    testWidgets('counts the whole selected day and opens the calendar on it', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final today = AssignedSeasonRules.vietnamDay(DateTime.now());
      final repository = _PagedOperationRepository(today);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            operationRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: OperationListPage(seasonId: 'season-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      OperationSummary summary() => tester
          .widget<OperationStatsBar>(find.byType(OperationStatsBar))
          .summary;
      expect(summary().planned, 1);
      expect(summary().completed, 1);
      expect(summary().total, 2);
      expect(find.text('Cữ 1'), findsOneWidget);

      await tester.tap(find.text('Hoàn thành'));
      await tester.pumpAndSettle();
      expect(summary().total, 2);
      expect(find.text('Cữ 1'), findsNothing);
      expect(find.text('Yucca xử lý khí độc'), findsOneWidget);

      await tester.tap(find.text('Chọn ngày'));
      await tester.pumpAndSettle();
      expect(find.text('CHỌN NGÀY VẬN HÀNH'), findsOneWidget);
      final tomorrow = today.add(const Duration(days: 1));
      final dayAfter = today.add(const Duration(days: 2));
      var picker = tester.widget<DatePickerDialog>(
        find.byType(DatePickerDialog),
      );
      expect(DateUtils.isSameDay(picker.initialDate, today), isTrue);
      expect(DateUtils.isSameDay(picker.lastDate, dayAfter), isTrue);
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(_dayMonth(tomorrow)));
      await tester.pumpAndSettle();
      expect(summary().total, 0);
      expect(find.text('Yucca xử lý khí độc'), findsNothing);
      await tester.tap(find.text('Chọn ngày'));
      await tester.pumpAndSettle();
      picker = tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));
      expect(DateUtils.isSameDay(picker.initialDate, tomorrow), isTrue);
      await tester.tap(find.text('Xem lịch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(_dayMonth(dayAfter)));
      await tester.pumpAndSettle();
      expect(summary().total, 0);
      expect(tester.takeException(), isNull);
    });
  });

  group('OperationExecuteSheet & Variance Validation', () {
    test(
      'OperationVarianceEvaluation handles both boundaries and signed variance',
      () {
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
        expect(above.exceedsAllowed, isTrue);
        expect(above.varianceLabel, 'Chênh lệch +100%');

        // Below allowed (0.5x planned => 2x smaller)
        const below = OperationVarianceEvaluation(
          planned: 2.0,
          actual: 1.0,
          allowedPct: 10,
        );
        expect(below.exceedsAllowed, isTrue);
        expect(below.varianceLabel, 'Chênh lệch −50%');

        const smallest = OperationVarianceEvaluation(
          planned: 0.000000001,
          actual: 0.000000002,
          allowedPct: 10,
        );
        expect(smallest.exceedsAllowed, isTrue);
        expect(smallest.varianceLabel, 'Chênh lệch +100%');

        const immediatelyAbove = OperationVarianceEvaluation(
          planned: 2,
          actual: 2.200000001,
          allowedPct: 10,
        );
        expect(immediatelyAbove.exceedsAllowed, isTrue);

        const zeroTolerance = OperationVarianceEvaluation(
          planned: 0.1,
          actual: 0.100000001,
          allowedPct: 0,
        );
        expect(zeroTolerance.exceedsAllowed, isTrue);
      },
    );

    testWidgets(
      'OperationExecuteSheet shows signed variance and requires a reason when out of range',
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
                body: OperationExecuteSheet(schedules: [schedule]),
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

        await tester.enterText(find.byType(TextField).first, '2.1');
        await tester.pumpAndSettle();
        expect(find.byType(AppFormMessageBanner), findsNothing);
        expect(find.text('Lý do chênh lệch *'), findsNothing);

        // Nhập lớn hơn ngưỡng cho phép (4 kg = gấp 2 lần) => hiện box đỏ chuẩn + yêu cầu lý do
        await tester.enterText(find.byType(TextField).first, '4');
        await tester.pumpAndSettle();

        expect(find.byType(AppFormMessageBanner), findsOneWidget);
        expect(find.text('Chênh lệch +100%'), findsOneWidget);
        expect(find.text('Lý do chênh lệch *'), findsOneWidget);
        await tester.tap(find.text('Xác nhận ghi nhận'));
        await tester.pumpAndSettle();
        expect(find.text('Bắt buộc nhập lý do chênh lệch'), findsOneWidget);
        expect(find.text('Vui lòng chọn giờ thực hiện.'), findsOneWidget);

        // Nhập nhỏ hơn ngưỡng cho phép (1 kg = 0.5 lần / nhỏ hơn 2 lần)
        await tester.enterText(find.byType(TextField).first, '1');
        await tester.pumpAndSettle();
        expect(find.text('Chênh lệch −50%'), findsOneWidget);
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
                body: OperationExecuteSheet(schedules: [futureSchedule]),
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

    testWidgets('shared form warns when a material exceeds current stock', (
      tester,
    ) async {
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
        product: const OperationProduct(id: 'p2', name: 'EN-GRO Uni-President'),
        availableStock: 0.0,
        hasSufficientStock: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OperationExecuteSheet(
                schedules: [feedSchedule, medSchedule],
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
        isNotNull,
      );
      await tester.enterText(
        find
            .descendant(
              of: find.byType(OperationExecuteItemCard).last,
              matching: find.byType(TextFormField),
            )
            .first,
        '10,0',
      );
      await tester.pumpAndSettle();
      expect(find.text('Không đủ vật tư trong kho'), findsOneWidget);
      expect(find.text('Chênh lệch +900%'), findsOneWidget);
      expect(find.text('Lý do chênh lệch *'), findsNothing);
    });
  });
}

String _dayMonth(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

final class _MockOperationRepository implements OperationRepository {
  _MockOperationRepository({this.historical = false});
  final bool historical;
  String? lastStatus;
  String? lastScheduleId;

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

    final feeding = OperationSchedule(
      id: historical ? 'item-1' : 'sched-feed-1',
      seasonId: seasonId,
      protocolItemId: 'item-1',
      operationType: OperationType.feeding,
      scheduledAt: DateTime.parse('2026-06-08T07:00:00Z'),
      plannedQuantity: 40,
      unit: 'kg',
      doseBasisSnapshot: 'FIXED_QUANTITY',
      doseValueSnapshot: 40,
      calculationVersion: 'v1',
      status: OperationStatus.planned,
      product: const OperationProduct(id: 'p1', name: 'Thức ăn CP 01'),
      protocolItem: const OperationProtocolItem(id: 'item-1', mealNumber: 1),
      activatedAt: historical ? DateTime.parse('2026-06-09T07:00:00Z') : null,
    );
    return OperationListResult(
      historicalFeedingAvailable: historical,
      historicalSchedules: historical
          ? [
              feeding,
              OperationSchedule(
                id: 'item-second',
                seasonId: seasonId,
                protocolItemId: 'item-second',
                operationType: OperationType.feeding,
                scheduledAt: feeding.scheduledAt,
                plannedQuantity: 1,
                unit: 'kg',
                doseBasisSnapshot: 'FIXED_QUANTITY',
                doseValueSnapshot: 1,
                calculationVersion: 'v1',
                status: OperationStatus.planned,
                product: const OperationProduct(
                  id: 'p-second',
                  name: 'Thức ăn bổ sung',
                ),
                protocolItem: const OperationProtocolItem(
                  id: 'item-second',
                  mealNumber: 1,
                ),
                activatedAt: feeding.activatedAt,
              ),
            ]
          : [],
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
        if (!historical) feeding,
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
    lastScheduleId = scheduleId;
    final result = await getSchedules('season-1');
    return result.schedules.singleWhere((row) => row.id == scheduleId);
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
    HistoricalFeedingOccurrence? historicalOccurrence,
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

final class _PagedOperationRepository extends _MockOperationRepository {
  _PagedOperationRepository(this.today);

  final DateTime today;

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async {
    final fixtures = await super.getSchedules(seasonId);
    final isToday = date == today.toIso8601String().split('T').first;
    final feeding = fixtures.schedules.first;
    return OperationListResult(
      summary: const OperationSummary(
        planned: 2,
        completed: 1,
        cancelled: 0,
        total: 3,
      ),
      banner: const OperationBanner(hasBiomassWarning: false),
      seasonStartDate: today.subtract(const Duration(days: 7)),
      nextPage: isToday && page == null ? 2 : null,
      schedules: !isToday
          ? const []
          : page == null
          ? [feeding]
          : [
              OperationSchedule(
                id: 'sched-feed-2',
                seasonId: seasonId,
                protocolItemId: 'item-feed-2',
                operationType: OperationType.feeding,
                scheduledAt: feeding.scheduledAt,
                plannedQuantity: 5,
                unit: 'kg',
                doseBasisSnapshot: 'FIXED_QUANTITY',
                doseValueSnapshot: 5,
                calculationVersion: 'v1',
                status: OperationStatus.planned,
                product: const OperationProduct(
                  id: 'p3',
                  name: 'Thức ăn CP 02',
                ),
                protocolItem: const OperationProtocolItem(
                  id: 'item-feed-2',
                  mealNumber: 1,
                ),
              ),
              fixtures.schedules.last,
            ],
    );
  }
}
