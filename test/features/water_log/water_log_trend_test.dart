import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_list_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_statistics_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_trend_chart.dart';
import 'water_statistics_fixtures.dart';

class _Repository implements WaterLogRepository {
  final requests = <({DateTime? from, DateTime to, String granularity})>[];
  int listCalls = 0, metadataCalls = 0;
  WaterLogStatistics data = sampleStatistics();
  AppException? error, metadataError;
  Completer<WaterLogStatistics>? pending;
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async {
    metadataCalls++;
    if (metadataError != null) throw metadataError!;
    return WaterLogMetadata.legacy(ShrimpType.whiteleg);
  }

  @override
  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    DateTime? from,
    required DateTime to,
    required String granularity,
  }) async {
    requests.add((from: from, to: to, granularity: granularity));
    if (error != null) throw error!;
    if (pending != null) return pending!.future;
    return data;
  }

  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    WaterLogFilter? filter,
    bool includeCounts = false,
    int limit = 20,
    String? cursor,
  }) async {
    listCalls++;
    return const WaterLogPage(items: [], totalResults: 0, hasNextPage: false);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _open(
  WidgetTester tester,
  _Repository repository, {
  bool list = false,
  double width = 402,
  bool settle = true,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => list
            ? const WaterLogListPage(
                seasonId: 'season',
                pondName: 'Ao A3',
                seasonName: 'Vụ Đông Xuân 2025',
              )
            : const WaterLogStatisticsPage(
                seasonId: 'season',
                pondName: 'Ao A3',
                seasonName: 'Vụ Đông Xuân 2025',
              ),
      ),
      GoRoute(
        path: '/seasons/season/water-logs/statistics',
        builder: (_, state) {
          final extra = state.extra as Map<String, String>;
          return WaterLogStatisticsPage(
            seasonId: 'season',
            pondName: extra['pondName'],
            seasonName: extra['seasonName'],
          );
        },
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        waterLogRepositoryProvider.overrideWithValue(repository),
        waterLogCanWriteProvider('season').overrideWithValue(false),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

void main() {
  for (final days in <int?>[7, 30, null]) {
    test(
      'statistics provider sends $days days using one fixed end instant',
      () async {
        final repository = _Repository();
        final container = ProviderContainer(
          overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        final before = DateTime.now();
        await container.read(
          waterLogStatisticsProvider((
            seasonId: 'season',
            days: days,
            granularity: 'day',
          )).future,
        );
        final request = repository.requests.single;
        expect(request.to.isBefore(before), isFalse);
        expect(request.to.isAfter(DateTime.now()), isFalse);
        expect(
          request.from,
          days == null ? null : request.to.subtract(Duration(days: days)),
        );
        expect(request.granularity, 'day');
        expect(repository.listCalls, 0);
      },
    );
  }

  testWidgets('chips request statistics only and summary uses backend totals', (
    tester,
  ) async {
    final repository = _Repository();
    await _open(tester, repository, width: 320);
    expect(find.text('Thống kê chất lượng nước'), findsOneWidget);
    expect(find.text('11 lần đo hợp lệ'), findsOneWidget);
    expect(
      find.text('11 nhật ký hợp lệ · 6/17 phép đo ngoài ngưỡng'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Text>(
            find.byKey(const Key('water_average_dissolvedOxygenMgL')),
          )
          .data,
      '6,37',
    );
    expect(
      repository.requests.single.to.difference(
        repository.requests.single.from!,
      ),
      const Duration(days: 7),
    );
    expect(find.text('4 · 40%'), findsOneWidget);
    expect(find.text('0 · 0%'), findsOneWidget);
    for (final days in <int?>[7, 30, null]) {
      final chip = find.byKey(Key('water_range_${days ?? 'all'}'));
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
      final request = repository.requests.last;
      expect(
        request.from,
        days == null ? null : request.to.subtract(Duration(days: days)),
      );
      expect(request.granularity, 'day');
    }
    expect(repository.requests, hasLength(3));
    expect(repository.listCalls, 0);
    final chart = tester.widget<WaterTrendChart>(find.byType(WaterTrendChart));
    expect(chart.field, 'dissolvedOxygenMgL');
    expect(chart.series, hasLength(3));
    expect(chart.series.map((p) => p.values[chart.field]!.avg), [5, 6, 7]);
    expect(chart.metric.warningMin, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'refresh and revision reload backend data without a list request',
    (tester) async {
      final repository = _Repository();
      await _open(tester, repository);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(WaterLogStatisticsPage)),
      );
      repository.data = sampleStatistics(empty: true);
      container.read(waterLogRevisionProvider('season').notifier).changed();
      await tester.pumpAndSettle();
      expect(find.text('0 lần đo hợp lệ'), findsOneWidget);
      expect(
        find.text(
          'Chưa có dữ liệu cho chỉ số này trong khoảng thời gian đã chọn.',
        ),
        findsOneWidget,
      );
      expect(find.byType(WaterTrendChart), findsNothing);
      final reads = repository.requests.length;
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      expect(repository.requests, hasLength(reads + 1));
      expect(repository.listCalls, 0);
    },
  );

  testWidgets(
    'old response keeps averages but does not infer counts from rates',
    (tester) async {
      await _open(
        tester,
        _Repository()..data = sampleStatistics(counts: false),
      );
      expect(
        find.text('11 nhật ký hợp lệ · —/17 phép đo ngoài ngưỡng'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(
              find.byKey(const Key('water_average_dissolvedOxygenMgL')),
            )
            .data,
        '6,37',
      );
    },
  );

  testWidgets('loading, API error and retry remain usable', (tester) async {
    final repository = _Repository()..pending = Completer<WaterLogStatistics>();
    await _open(tester, repository, settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.pending!.completeError(
      const ApiException('Statistics unavailable', statusCode: 403),
    );
    await tester.pumpAndSettle();
    expect(find.text('Statistics unavailable'), findsOneWidget);
    repository.pending = null;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.byType(WaterTrendChart), findsOneWidget);
    expect(repository.listCalls, 0);
  });

  testWidgets('metadata errors retry independently of statistics aggregation', (
    tester,
  ) async {
    final repository = _Repository()
      ..metadataError = const ApiException(
        'Metadata unavailable',
        statusCode: 403,
      );
    await _open(tester, repository);
    expect(find.text('Metadata unavailable'), findsOneWidget);
    repository.metadataError = null;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.byType(WaterTrendChart), findsOneWidget);
  });

  testWidgets(
    'metric switching preserves five-decimal precision on narrow screens',
    (tester) async {
      final payload = statisticsJson();
      payload['series'] = [
        {
          'bucket': '2026-01-01',
          'h2sMgL': {'count': 1, 'min': .00001, 'max': .00001, 'avg': .00001},
        },
      ];
      final repository = _Repository()
        ..data = WaterLogStatistics.parse(payload);
      await _open(tester, repository, width: 320);
      final metrics = find.byType(ListView).first;
      await tester.ensureVisible(metrics);
      await tester.drag(metrics, const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('water_metric_h2sMgL')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('water_trend_selected_value')))
            .data,
        '0,00001',
      );
      expect(repository.listCalls, 0);
      expect(repository.requests, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('statistics button still navigates with pond and season labels', (
    tester,
  ) async {
    final repository = _Repository();
    await _open(tester, repository, list: true);
    await tester.tap(find.byKey(const Key('water_statistics_button')));
    await tester.pumpAndSettle();
    expect(find.byType(WaterLogStatisticsPage), findsOneWidget);
    expect(find.text('Ao A3 · Vụ Đông Xuân 2025'), findsOneWidget);
    expect(repository.requests, hasLength(1));
  });

  test(
    'legacy and new statistics payloads parse without requiring exceedCount',
    () {
      expect(
        sampleStatistics().parameters['dissolvedOxygenMgL']!.exceedCount,
        4,
      );
      final current = sampleStatistics().parameters['dissolvedOxygenMgL']!;
      expect(current.belowMinCount, 4);
      expect(current.aboveMaxCount, 0);
      expect(current.belowMinRate, .4);
      expect(current.aboveMaxRate, 0);
      final legacy = sampleStatistics(
        counts: false,
      ).parameters['dissolvedOxygenMgL']!;
      expect(legacy.belowMinCount, isNull);
      expect(legacy.aboveMaxCount, isNull);
      expect(legacy.belowMinRate, isNull);
      expect(legacy.aboveMaxRate, isNull);
      expect(
        sampleStatistics(
          counts: false,
        ).parameters['dissolvedOxygenMgL']!.exceedCount,
        isNull,
      );
      expect(
        sampleStatistics()
            .series
            .first
            .values['dissolvedOxygenMgL']!
            .exceedCount,
        isNull,
      );
    },
  );
}
