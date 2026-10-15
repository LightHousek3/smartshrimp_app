import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_list_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_statistics_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_trend_provider.dart';

WaterLog _log(int day, double oxygen, {bool voided = false}) => WaterLog(
  id: 'log-$day',
  seasonId: 'season',
  recordedAt: DateTime(2026, 9, day, 6),
  createdAt: DateTime(2026, 9, day, 6),
  isVoided: voided,
  exceededParameters: oxygen < 4 ? ['dissolvedOxygenMgL'] : [],
  dissolvedOxygenMgL: oxygen,
  temperatureC: 28.5,
  salinityPpt: 15.3,
  nh3MgL: .012,
  no2MgL: .08,
  alkalinityMgLCaCO3: 142,
  ph: 8,
  h2sMgL: .00001,
);

class _Repository implements WaterLogRepository {
  final requests =
      <
        ({
          DateTime? from,
          DateTime? to,
          String? cursor,
          int limit,
          bool includeVoided,
        })
      >[];
  List<WaterLog> logs = [
    for (var i = 0; i < 12; i++)
      _log(
        i + 7,
        [4.6, 3.9, 4.25, 4.5, 4.7, 4.4, 4.15, 3.85, 4.35, 4.8, 5.0, 5.2][i],
      ),
  ];
  bool paginated = false;
  bool badCursor = false;
  AppException? error;
  Completer<WaterLogPage>? pending;
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async =>
      WaterLogMetadata.legacy(ShrimpType.whiteleg);
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
    requests.add((
      from: from,
      to: to,
      cursor: cursor,
      limit: limit,
      includeVoided: includeVoided,
    ));
    if (error != null) throw error!;
    if (pending != null) return pending!.future;
    if (paginated) {
      return WaterLogPage(
        items: cursor == null
            ? [_log(9, 5), _log(10, 9, voided: true)]
            : [_log(9, 5), _log(7, 3.9)],
        totalResults: 3,
        hasNextPage: cursor == null || badCursor,
        nextCursor: 'next',
      );
    }
    return WaterLogPage(
      items: logs.reversed.toList(),
      totalResults: logs.length,
      hasNextPage: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _container(_Repository repository) async {
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _open(
  WidgetTester tester,
  _Repository repository, {
  bool list = false,
  double width = 402,
  bool settle = true,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = Size(width, 874);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);
  Widget stats(String? pond, String? season) => WaterLogStatisticsPage(
    seasonId: 'season',
    pondName: pond,
    seasonName: season,
  );
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
            : stats('Ao A3', 'Vụ Đông Xuân 2025'),
      ),
      GoRoute(
        path: '/seasons/season/water-logs/statistics',
        builder: (_, state) {
          final extra = state.extra as Map<String, String>;
          return stats(extra['pondName'], extra['seasonName']);
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
      child: RepaintBoundary(
        key: const Key('preview'),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  if (settle) await tester.pumpAndSettle();
}

void main() {
  test(
    'all fetches every page, deduplicates, sorts and excludes voided rows',
    () async {
      final repository = _Repository()..paginated = true;
      final container = await _container(repository);
      final result = await container.read(
        waterLogTrendProvider((seasonId: 'season', days: null)).future,
      );
      expect(result.logs.map((log) => log.id), ['log-7', 'log-9']);
      expect(repository.requests.map((r) => r.cursor), [null, 'next']);
      expect(
        repository.requests.every(
          (r) =>
              r.from == null &&
              r.to == null &&
              r.limit == 50 &&
              !r.includeVoided,
        ),
        isTrue,
      );
      expect(repository.requests.first.to, repository.requests.last.to);
    },
  );
  for (final days in [7, 30]) {
    test(
      '$days day range is sent to the API with a fixed end instant',
      () async {
        final repository = _Repository();
        final container = await _container(repository);
        await container.read(
          waterLogTrendProvider((seasonId: 'season', days: days)).future,
        );
        final request = repository.requests.single;
        expect(request.to!.difference(request.from!), Duration(days: days));
      },
    );
  }
  test(
    'non-progressing pagination fails instead of silently truncating',
    () async {
      final container = await _container(
        _Repository()
          ..paginated = true
          ..badCursor = true,
      );
      final provider = waterLogTrendProvider((seasonId: 'season', days: null));
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await expectLater(
        container.read(provider.future),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
  test('mutation revision reloads trend data', () async {
    final repository = _Repository();
    final container = await _container(repository);
    final provider = waterLogTrendProvider((seasonId: 'season', days: null));
    final sub = container.listen(provider, (_, _) {});
    addTearDown(sub.close);
    await container.read(provider.future);
    repository.logs = [];
    container.read(waterLogRevisionProvider('season').notifier).changed();
    expect((await container.read(provider.future)).logs, isEmpty);
  });
  testWidgets('statistics button navigates with pond and season labels', (
    tester,
  ) async {
    await _open(tester, _Repository(), list: true);
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('goldens/water_list_statistics_button.png'),
    );
    await tester.tap(find.byKey(const Key('water_statistics_button')));
    await tester.pumpAndSettle();
    expect(find.byType(WaterLogStatisticsPage), findsOneWidget);
    expect(find.text('Ao A3 · Vụ Đông Xuân 2025'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('trend matches Figma layout and supports sample selection', (
    tester,
  ) async {
    await _open(tester, _Repository());
    expect(find.text('12 lần đo hợp lệ'), findsOneWidget);
    expect(find.text('10/12 lần đo'), findsOneWidget);
    expect(find.text('từ 4 mg/L'), findsOneWidget);
    expect(find.text('5,2'), findsOneWidget);
    expect(find.text('Tăng 0,2 mg/L'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('water_trend_chart'))).dy,
      lessThan(
        tester.getTopLeft(find.byKey(const Key('water_average_summary'))).dy,
      ),
    );
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('goldens/water_statistics.png'),
    );
    await tester.ensureVisible(find.byKey(const Key('water_trend_chart')));
    await tester.pumpAndSettle();
    final chart = tester.getRect(find.byKey(const Key('water_trend_chart')));
    await tester.tapAt(Offset(chart.left + 12, chart.center.dy));
    await tester.pump();
    expect(find.text('4,6'), findsOneWidget);
    expect(find.text('Chưa có lần đo trước'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'small screen switches range and scrolls to H2S without losing precision',
    (tester) async {
      final repository = _Repository();
      await _open(tester, repository, width: 320);
      await tester.ensureVisible(find.byKey(const Key('water_range_7')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('water_range_7')));
      await tester.pumpAndSettle();
      expect(
        repository.requests.last.to!.difference(repository.requests.last.from!),
        const Duration(days: 7),
      );
      await tester.ensureVisible(find.byType(ListView).first);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('water_metric_h2sMgL')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('water_trend_selected_value')))
            .data,
        '0,00001',
      );
      expect(find.text('12/12 lần đo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('loading, API error, retry and empty metric remain usable', (
    tester,
  ) async {
    final repository = _Repository()..pending = Completer<WaterLogPage>();
    await _open(tester, repository, settle: false);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.pending!.completeError(const NetworkException());
    await tester.pumpAndSettle();
    expect(find.text(const NetworkException().message), findsOneWidget);
    repository.pending = null;
    repository.logs = [];
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Chưa có dữ liệu cho chỉ số này'),
      findsOneWidget,
    );
    repository.error = const NetworkException();
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.text(const NetworkException().message), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
