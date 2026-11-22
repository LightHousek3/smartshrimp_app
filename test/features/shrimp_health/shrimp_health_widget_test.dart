import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/pages/shrimp_health_detail_page.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/pages/shrimp_health_list_page.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/pages/shrimp_health_statistics_page.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_card.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_detail_sheet.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/repositories/shrimp_health_repository.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_form_sheet.dart';

void main() {
  testWidgets(
    'health form waits for the server baseline before allowing save',
    (tester) async {
      final pending = Completer<int?>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith(
              (ref, query) => pending.future,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ShrimpHealthFormSheet(
                seasonId: 'season-1',
                initialQuantity: 240000,
                previousPopulation: 200000,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      expect(find.text('200.000'), findsNothing);
      pending.complete(105000);
      await tester.pumpAndSettle();
      expect(find.text('105.000'), findsOneWidget);
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed population load can retry while preserving observation notes',
    (tester) async {
      var attempts = 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith((ref, query) async {
              if (attempts++ == 0) throw Exception('Không tải được số còn lại');
              return 105000;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ShrimpHealthFormSheet(seasonId: 'season-1')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNull,
      );
      final note = find.widgetWithText(
        TextFormField,
        'Màu sắc, đường ruột, phân, vỏ...',
      );
      await tester.enterText(note, 'Tôm ăn tốt');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      final retry = find.text('Tải lại số tôm còn lại');
      await tester.ensureVisible(retry);
      await tester.pumpAndSettle();
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(find.text('105.000'), findsOneWidget);
      expect(find.text('Tôm ăn tốt'), findsOneWidget);
      expect(
        tester.widget<GradientButton>(find.byType(GradientButton)).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'known zero population stays read-only and does not fall back to initial stock',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith(
              (ref, query) async => 0,
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ShrimpHealthFormSheet(
                seasonId: 'season-1',
                initialQuantity: 240000,
                previousPopulation: 200000,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('240.000'), findsNothing);
      expect(find.text('200.000'), findsNothing);
      expect(
        tester
            .widgetList<TextField>(find.byType(TextField))
            .where((field) => field.readOnly && field.controller?.text == '0'),
        hasLength(1),
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '0').first,
        '1',
      );
      tester.state<FormState>(find.byType(Form)).validate();
      await tester.pumpAndSettle();
      expect(find.text('Hao hụt vượt quá số tôm hiện có'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

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

  testWidgets('server rejection preserves the health form and entered facts', (
    tester,
  ) async {
    final repository = _FakeShrimpHealthRepository(
      listResult: ShrimpHealthListResult(logs: [sampleLog]),
      createError: const ApiException(
        'Dữ liệu vụ nuôi vừa thay đổi',
        statusCode: 409,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthPopulationProvider.overrideWith(
            (ref, query) async => 105000,
          ),
          shrimpHealthRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: Scaffold(body: ShrimpHealthFormSheet(seasonId: 'season-1')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Màu sắc, đường ruột, phân, vỏ...'),
      'Tôm ăn tốt',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lưu bản ghi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu bản ghi'));
    await tester.pumpAndSettle();
    expect(find.text('Dữ liệu vụ nuôi vừa thay đổi'), findsOneWidget);
    expect(find.text('Tôm ăn tốt'), findsOneWidget);
    expect(find.text('105.000'), findsOneWidget);
    expect(find.byType(ShrimpHealthFormSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'save reports a population updated by the server during recording',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith(
              (ref, query) async => 400000,
            ),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(
                listResult: ShrimpHealthListResult(logs: [sampleLog]),
              ),
            ),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      ShrimpHealthFormSheet.show(context, seasonId: 'season-1'),
                  child: const Text('Mở form'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Mở form'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Lưu bản ghi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu bản ghi'));
      await tester.pumpAndSettle();
      expect(find.byType(ShrimpHealthFormSheet), findsNothing);
      expect(
        find.textContaining(
          'Ước tính đàn được cập nhật theo dữ liệu mới nhất: 391.200 con.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Renders ShrimpHealthCard without crashing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShrimpHealthCard(log: sampleLog, onTap: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cỡ TB'), findsOneWidget);
  });

  testWidgets('Renders ShrimpHealthDetailSheet without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assignedSeasonCanWriteProvider(
            'season-1',
          ).overrideWith((ref) => true),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ShrimpHealthDetailSheet(seasonId: 'season-1', log: sampleLog),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sức khỏe H-512'), findsOneWidget);
    // Void button should be enabled since sampleLog was recorded today
    final voidButtonFinder = find.widgetWithText(
      OutlinedButton,
      'Hủy hiệu lực bản ghi',
    );
    expect(voidButtonFinder, findsOneWidget);
    final button = tester.widget<OutlinedButton>(voidButtonFinder);
    expect(button.onPressed, isNotNull);
  });

  testWidgets(
    'ShrimpHealthDetailSheet allows voiding past logs with a reason',
    (tester) async {
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
          overrides: [
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => true),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ShrimpHealthDetailSheet(seasonId: 'season-1', log: pastLog),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final voidButtonFinder = find.widgetWithText(
        OutlinedButton,
        'Hủy hiệu lực bản ghi',
      );
      expect(voidButtonFinder, findsOneWidget);
      final button = tester.widget<OutlinedButton>(voidButtonFinder);
      expect(button.onPressed, isNotNull);
      expect(
        find.text('Chỉ được hủy hiệu lực bản ghi trong ngày'),
        findsNothing,
      );
      await tester.ensureVisible(voidButtonFinder);
      await tester.tap(voidButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Lý do hủy hiệu lực (bắt buộc)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'health detail page allows voiding an old log in a writable season',
    (tester) async {
      final old = ShrimpHealthLog(
        id: 'old-log',
        seasonId: 'season-1',
        recordedBy: 'previous-technician',
        recordedAt: DateTime.now().subtract(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        healthStatus: HealthStatus.good,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => true),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(
                listResult: ShrimpHealthListResult(logs: [old]),
              ),
            ),
          ],
          child: const MaterialApp(
            home: ShrimpHealthDetailPage(
              seasonId: 'season-1',
              logId: 'old-log',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final button = find.widgetWithText(OutlinedButton, 'Hủy bản ghi này');
      expect(tester.widget<OutlinedButton>(button).onPressed, isNotNull);
      expect(
        find.text('Chỉ được hủy hiệu lực bản ghi trong ngày'),
        findsNothing,
      );
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('read-only health sheet preserves observations and hides void', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assignedSeasonCanWriteProvider(
            'season-1',
          ).overrideWith((ref) => false),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ShrimpHealthDetailSheet(seasonId: 'season-1', log: sampleLog),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sức khỏe H-512'), findsOneWidget);
    expect(find.text('Hủy hiệu lực bản ghi'), findsNothing);
    expect(find.text('Xác nhận'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'read-only health route hides void even for a log recorded today',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => false),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(
                listResult: ShrimpHealthListResult(logs: [sampleLog]),
              ),
            ),
          ],
          child: const MaterialApp(
            home: ShrimpHealthDetailPage(seasonId: 'season-1', logId: 'log'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hủy hiệu lực bản ghi'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'read-only health list keeps statistics and hides record actions',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => false),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(
                listResult: const ShrimpHealthListResult(logs: []),
              ),
            ),
          ],
          child: const MaterialApp(
            home: ShrimpHealthListPage(seasonId: 'season-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Thống kê'), findsOneWidget);
      expect(find.text('Ghi nhận sức khỏe tôm'), findsNothing);
      expect(find.text('Chưa có ghi nhận hôm nay'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Renders ShrimpHealthFormSheet without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shrimpHealthPopulationProvider.overrideWith(
            (ref, query) async => null,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: ShrimpHealthFormSheet(seasonId: 'season-1')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ghi nhận sức khỏe tôm'), findsOneWidget);
  });

  testWidgets(
    'ShrimpHealthFormSheet auto-calculates population and biomass as read-only',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith(
              (ref, query) async => 300000,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ShrimpHealthFormSheet(
                  seasonId: 'season-1',
                  initialQuantity: 300000,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check initial population is auto-filled to 300.000
      expect(find.text('300.000'), findsOneWidget);

      // Verify TextField for avg weight, population and biomass are read-only
      final textFields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      final readOnlyFields = textFields
          .where((f) => f.readOnly == true)
          .toList();
      expect(readOnlyFields.length, 3); // avg weight, population & biomass

      // Enter mortality = 1000
      final mortalityField = find.widgetWithText(TextFormField, '0');
      await tester.enterText(mortalityField, '1000');
      await tester.pumpAndSettle();

      // Population auto-updates to 299.000
      expect(find.text('299.000'), findsOneWidget);

      // Enter sample size = 100
      final sampleField = find.widgetWithText(TextFormField, '120');
      await tester.enterText(sampleField, '100');
      await tester.pumpAndSettle();

      // Enter sample weight = 1.2 (kg)
      final weightField = find.widgetWithText(TextFormField, '1.2');
      await tester.enterText(weightField, '1.2');
      await tester.pumpAndSettle();

      // Avg weight box shows 12
      expect(find.text('12'), findsOneWidget);

      // Biomass is auto-calculated: 299000 * 12 / 1000 = 3588 kg
      expect(find.text('3588'), findsOneWidget);
    },
  );

  testWidgets(
    'ShrimpHealthFormSheet uses server population after harvest instead of stale previous population',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shrimpHealthPopulationProvider.overrideWith(
              (ref, query) async => 105000,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ShrimpHealthFormSheet(
                  seasonId: 'season-1',
                  initialQuantity: 300000,
                  previousPopulation: 295000,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The server baseline includes the harvest; previousPopulation is stale.
      expect(find.text('105.000'), findsOneWidget);

      // Enter mortality = 1000
      final mortalityField = find.widgetWithText(TextFormField, '0');
      await tester.enterText(mortalityField, '1000');
      await tester.pumpAndSettle();

      // Apply only the mortality from this new observation.
      expect(find.text('104.000'), findsOneWidget);
    },
  );

  testWidgets(
    'Renders ShrimpHealthStatisticsPage with empty stats without crashing',
    (tester) async {
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
            home: ShrimpHealthStatisticsPage(seasonId: 'season-1'),
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
    },
  );

  testWidgets(
    'Renders ShrimpHealthStatisticsPage with sample stats data without crashing',
    (tester) async {
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
            home: ShrimpHealthStatisticsPage(seasonId: 'season-1'),
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
    },
  );

  testWidgets(
    'Renders ShrimpHealthStatisticsPage with 1 growth point and single 100% health status',
    (tester) async {
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
            home: ShrimpHealthStatisticsPage(seasonId: 'season-1'),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Thống kê tăng trưởng tôm'), findsOneWidget);
      expect(
        find.text(
          'Đã ghi nhận 1 lần đo (12.4 g). Cần ít nhất 2 lần đo để vẽ đường tăng trưởng.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Renders ShrimpHealthStatisticsPage with low percentage rounding edge case',
    (tester) async {
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
            home: ShrimpHealthStatisticsPage(seasonId: 'season-1'),
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
    },
  );

  testWidgets(
    'Renders ShrimpHealthListPage with decimal biomass log without crashing',
    (tester) async {
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
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => true),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(listResult: listResult),
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
      expect(
        find.ancestor(
          of: find.byType(PageHeaderBar),
          matching: find.byType(AppGradientBackground),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('shrimp_health_statistics_button')),
        findsOneWidget,
      );
      expect(find.text('Thống kê'), findsOneWidget);
      expect(find.text('SINH KHỐI'), findsOneWidget);
      expect(
        find.text('161'),
        findsNWidgets(2),
      ); // KPI card and ShrimpHealthCard tile
      expect(find.text('Tất cả (1)'), findsOneWidget);

      // Test frontend-only tab switching
      await tester.tap(find.text('Cảnh báo (0)'));
      await tester.pumpAndSettle();
      expect(find.text('Không có bản ghi phù hợp'), findsOneWidget);

      await tester.tap(find.text('Tất cả (1)'));
      await tester.pumpAndSettle();
      expect(find.text('161'), findsNWidgets(2));
    },
  );

  testWidgets(
    'Renders ShrimpHealthListPage showing missing today banner when no log today',
    (tester) async {
      final listResult = ShrimpHealthListResult(
        logs: [
          ShrimpHealthLog(
            id: 'old-log-1',
            seasonId: 'season-1',
            recordedBy: 'user-1',
            recordedByName: 'Kỹ thuật viên A',
            recordedAt: DateTime.now().subtract(
              const Duration(days: 2),
            ), // 2 days ago
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
            assignedSeasonCanWriteProvider(
              'season-1',
            ).overrideWith((ref) => true),
            shrimpHealthRepositoryProvider.overrideWithValue(
              _FakeShrimpHealthRepository(listResult: listResult),
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
      expect(
        find.ancestor(
          of: find.byType(PageHeaderBar),
          matching: find.byType(AppGradientBackground),
        ),
        findsOneWidget,
      );
    },
  );
}

class _FakeShrimpHealthRepository implements ShrimpHealthRepository {
  _FakeShrimpHealthRepository({required this.listResult, this.createError});

  final ShrimpHealthListResult listResult;
  final Object? createError;

  @override
  Future<int?> getAvailablePopulation(String seasonId, DateTime at) async =>
      null;

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
  }) async {
    if (createError != null) throw createError!;
    return listResult.logs.first;
  }

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
