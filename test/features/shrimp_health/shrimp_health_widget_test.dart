import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/pages/shrimp_health_list_page.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/pages/shrimp_health_statistics_page.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_card.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_detail_sheet.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/repositories/shrimp_health_repository.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_form_sheet.dart';

void main() {
  final sampleLog = ShrimpHealthLog(
    id: '51210af0-318a-47ac-874d-6f29fc04b0bf',
    seasonId: 'season-1',
    recordedBy: 'user-1',
    recordedByName: 'Nguyen Van A',
    recordedAt: DateTime.now(),
    sampleSize: 120,
    avgWeightG: 12.4,
    avgLengthCm: 11.2,
    mortalityCount: 0,
    estimatedPopulation: 391200,
    estimatedBiomassKg: 4851,
    healthStatus: HealthStatus.good,
    note: 'Tôm ăn khỏe, vỏ bóng đẹp',
    createdAt: DateTime.now(),
  );

  testWidgets('Renders ShrimpHealthCard without crashing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShrimpHealthCard(
            log: sampleLog,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cỡ TB'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthDetailSheet without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ShrimpHealthDetailSheet(
              seasonId: 'season-1',
              log: sampleLog,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sức khỏe H-512'), findsOneWidget);
    // Void button should be enabled since sampleLog was recorded today
    final voidButtonFinder = find.widgetWithText(OutlinedButton, 'Hủy hiệu lực bản ghi');
    expect(voidButtonFinder, findsOneWidget);
    final button = tester.widget<OutlinedButton>(voidButtonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('ShrimpHealthDetailSheet disables void button for past logs', (tester) async {
    final pastLog = ShrimpHealthLog(
      id: 'past-log-1',
      seasonId: 'season-1',
      recordedBy: 'user-1',
      recordedByName: 'Nguyen Van A',
      recordedAt: DateTime.now().subtract(const Duration(days: 2)),
      sampleSize: 120,
      avgWeightG: 12.4,
      avgLengthCm: 11.2,
      mortalityCount: 0,
      estimatedPopulation: 391200,
      estimatedBiomassKg: 4851,
      healthStatus: HealthStatus.good,
      note: 'Tôm ăn khỏe, vỏ bóng đẹp',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ShrimpHealthDetailSheet(
              seasonId: 'season-1',
              log: pastLog,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final voidButtonFinder = find.widgetWithText(OutlinedButton, 'Hủy hiệu lực bản ghi');
    expect(voidButtonFinder, findsOneWidget);
    final button = tester.widget<OutlinedButton>(voidButtonFinder);
    expect(button.onPressed, isNull);
    expect(find.text('Chỉ được hủy hiệu lực bản ghi trong ngày'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthFormSheet without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ShrimpHealthFormSheet(
              seasonId: 'season-1',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ghi nhận sức khỏe tôm'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthStatisticsPage with empty stats without crashing', (tester) async {
    final emptyStats = ShrimpHealthStatsResult(
      seasonId: 'season-1',
      shrimpType: 'WHITELEG',
      summary: const ShrimpHealthSummary(
        currentBiomassKg: null,
        currentAvgWeightG: null,
        currentAvgLengthCm: null,
        currentPopulation: null,
        currentHealthStatus: null,
        survivalRatePercent: null,
        totalMortalityInRange: 0,
        totalLogsInRange: 0,
        lastRecordedAt: null,
      ),
      healthDistribution: const ShrimpHealthDistribution(
        totalLogs: 0,
        excellent: ShrimpHealthDistributionItem(count: 0, percent: 0),
        good: ShrimpHealthDistributionItem(count: 0, percent: 0),
        warning: ShrimpHealthDistributionItem(count: 0, percent: 0),
        critical: ShrimpHealthDistributionItem(count: 0, percent: 0),
      ),
      growthSeries: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthStatsProvider.overrideWith(
            (ref, query) => Future.value(emptyStats),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthStatisticsPage(
            seasonId: 'season-1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    // Verify frontend date filter switching
    await tester.tap(find.text('7 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    await tester.tap(find.text('90 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthStatisticsPage with sample stats data without crashing', (tester) async {
    final populatedStats = ShrimpHealthStatsResult(
      seasonId: 'season-1',
      shrimpType: 'WHITELEG',
      summary: const ShrimpHealthSummary(
        currentBiomassKg: 4851,
        currentAvgWeightG: 12.4,
        currentAvgLengthCm: 11.2,
        currentPopulation: 391200,
        currentHealthStatus: HealthStatus.good,
        survivalRatePercent: 92.5,
        totalMortalityInRange: 150,
        totalLogsInRange: 10,
        lastRecordedAt: null,
      ),
      healthDistribution: const ShrimpHealthDistribution(
        totalLogs: 10,
        excellent: ShrimpHealthDistributionItem(count: 3, percent: 30.0),
        good: ShrimpHealthDistributionItem(count: 5, percent: 50.0),
        warning: ShrimpHealthDistributionItem(count: 2, percent: 20.0),
        critical: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
      ),
      growthSeries: [
        ShrimpGrowthPoint(
          date: '2026-10-01',
          recordedAt: DateTime(2026, 10, 1),
          avgWeightG: 8.5,
          estimatedBiomassKg: 3200,
        ),
        ShrimpGrowthPoint(
          date: '2026-10-08',
          recordedAt: DateTime(2026, 10, 8),
          avgWeightG: 10.2,
          estimatedBiomassKg: 4000,
        ),
        ShrimpGrowthPoint(
          date: '2026-10-15',
          recordedAt: DateTime(2026, 10, 15),
          avgWeightG: 12.4,
          estimatedBiomassKg: 4851,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthStatsProvider.overrideWith(
            (ref, query) => Future.value(populatedStats),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthStatisticsPage(
            seasonId: 'season-1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    // Verify frontend date filter switching
    await tester.tap(find.text('7 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    await tester.tap(find.text('90 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthStatisticsPage with 1 growth point and single 100% health status', (tester) async {
    final singleLogStats = ShrimpHealthStatsResult(
      seasonId: 'season-1',
      shrimpType: 'WHITELEG',
      summary: const ShrimpHealthSummary(
        currentBiomassKg: 161.2,
        currentAvgWeightG: 12.4,
        currentAvgLengthCm: 11.2,
        currentPopulation: 13000,
        currentHealthStatus: HealthStatus.good,
        survivalRatePercent: 5.42,
        totalMortalityInRange: 2,
        totalLogsInRange: 1,
        lastRecordedAt: null,
      ),
      healthDistribution: const ShrimpHealthDistribution(
        totalLogs: 1,
        excellent: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
        good: ShrimpHealthDistributionItem(count: 1, percent: 100.0),
        warning: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
        critical: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
      ),
      growthSeries: [
        ShrimpGrowthPoint(
          date: '2026-10-17',
          recordedAt: DateTime(2026, 10, 17),
          dayOfCulture: 2,
          avgWeightG: 12.4,
          avgLengthCm: 11.2,
          estimatedBiomassKg: 161.2,
          estimatedPopulation: 13000,
          mortalityCount: 2,
          healthStatus: HealthStatus.good,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthStatsProvider.overrideWith(
            (ref, query) => Future.value(singleLogStats),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthStatisticsPage(
            seasonId: 'season-1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);
    expect(find.text('Đã ghi nhận 1 lần đo (12.4 g). Cần ít nhất 2 lần đo để vẽ đường tăng trưởng.'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthStatisticsPage with low percentage rounding edge case', (tester) async {
    // What if percent is 0.04% where (percent * 10).round() is 0?
    final edgeCaseStats = ShrimpHealthStatsResult(
      seasonId: 'season-1',
      shrimpType: 'WHITELEG',
      summary: const ShrimpHealthSummary(
        currentBiomassKg: 161.2,
        currentAvgWeightG: 12.4,
        currentAvgLengthCm: 11.2,
        currentPopulation: 13000,
        currentHealthStatus: HealthStatus.good,
        survivalRatePercent: 5.42,
        totalMortalityInRange: 2,
        totalLogsInRange: 1000,
        lastRecordedAt: null,
      ),
      healthDistribution: const ShrimpHealthDistribution(
        totalLogs: 1000,
        excellent: ShrimpHealthDistributionItem(count: 1, percent: 0.04),
        good: ShrimpHealthDistributionItem(count: 999, percent: 99.96),
        warning: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
        critical: ShrimpHealthDistributionItem(count: 0, percent: 0.0),
      ),
      growthSeries: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthStatsProvider.overrideWith(
            (ref, query) => Future.value(edgeCaseStats),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthStatisticsPage(
            seasonId: 'season-1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    // Verify frontend date filter switching
    await tester.tap(find.text('7 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);

    await tester.tap(find.text('90 ngày qua'));
    await tester.pumpAndSettle();
    expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthListPage with decimal biomass log without crashing', (tester) async {
    final listResult = ShrimpHealthListResult(
      logs: [
        ShrimpHealthLog(
          id: 'f74eb3a5-f9a5-4649-a092-6374b353e7a3',
          seasonId: 'season-1',
          recordedBy: 'user-1',
          recordedByName: 'Kỹ thuật viên A',
          recordedAt: DateTime.now(),
          dayOfCulture: 2,
          sampleSize: 100,
          avgWeightG: 12.4,
          avgLengthCm: 11.2,
          mortalityCount: 2,
          estimatedPopulation: 13000,
          estimatedBiomassKg: 161.2,
          healthStatus: HealthStatus.good,
          note: null,
          isVoided: false,
          createdAt: DateTime.now(),
        ),
      ],
      counts: const ShrimpHealthCounts(
        total: 1,
        valid: 1,
        voided: 0,
        warningOrCritical: 0,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthRepositoryProvider.overrideWithValue(
            _FakeShrimpHealthRepository(
              listResult: listResult,
            ),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthListPage(
            seasonId: 'season-1',
            pondName: 'Ao A1',
            seasonName: 'Vụ 1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Sức khỏe tôm'), findsOneWidget);
    expect(find.byKey(const Key('shrimp_health_statistics_button')), findsOneWidget);
    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('SINH KHỐI'), findsOneWidget);
    expect(find.text('161'), findsNWidgets(2)); // KPI card and ShrimpHealthCard tile
    expect(find.text('Tất cả (1)'), findsOneWidget);

    // Test frontend-only tab switching
    await tester.tap(find.text('Cảnh báo (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Không có bản ghi phù hợp'), findsOneWidget);

    await tester.tap(find.text('Tất cả (1)'));
    await tester.pumpAndSettle();
    expect(find.text('161'), findsNWidgets(2));
  });

  testWidgets('Renders ShrimpHealthListPage showing missing today banner when no log today', (tester) async {
    final listResult = ShrimpHealthListResult(
      logs: [
        ShrimpHealthLog(
          id: 'old-log-1',
          seasonId: 'season-1',
          recordedBy: 'user-1',
          recordedByName: 'Kỹ thuật viên A',
          recordedAt: DateTime.now().subtract(const Duration(days: 2)), // 2 days ago
          dayOfCulture: 10,
          sampleSize: 100,
          avgWeightG: 12.4,
          avgLengthCm: 11.2,
          mortalityCount: 0,
          estimatedPopulation: 13000,
          estimatedBiomassKg: 161.2,
          healthStatus: HealthStatus.good,
          note: null,
          isVoided: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      counts: const ShrimpHealthCounts(
        total: 1,
        valid: 1,
        voided: 0,
        warningOrCritical: 0,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthRepositoryProvider.overrideWithValue(
            _FakeShrimpHealthRepository(
              listResult: listResult,
            ),
          ),
        ],
        child: const MaterialApp(
          home: ShrimpHealthListPage(
            seasonId: 'season-1',
            pondName: 'Ao A1',
            seasonName: 'Vụ 1',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Chưa có ghi nhận hôm nay'), findsOneWidget);
  });
}

class _FakeShrimpHealthRepository implements ShrimpHealthRepository {
  _FakeShrimpHealthRepository({
    required this.listResult,
  });

  final ShrimpHealthListResult listResult;

  @override
  Future<ShrimpHealthListResult> listLogs(
    String seasonId, {
    DateTime? from,
    DateTime? to,
    String? healthStatus,
    String? filter,
    int? limit,
    String? cursor,
    bool includeCounts = true,
  }) async => listResult;

  @override
  Future<ShrimpHealthLog> getLogDetail(String seasonId, String logId) async =>
      listResult.logs.first;

  @override
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
  }) async => listResult.logs.first;

  @override
  Future<ShrimpHealthLog> voidLog(
    String seasonId,
    String logId,
    String voidReason,
  ) async => listResult.logs.first;

  @override
  Future<ShrimpHealthStatsResult> getStatistics(
    String seasonId, {
    required DateTime from,
    required DateTime to,
    String granularity = 'day',
  }) async => throw UnimplementedError();
}



