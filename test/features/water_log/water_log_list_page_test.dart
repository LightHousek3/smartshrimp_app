import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_counts.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_list_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';

WaterLog _log(
  String id, {
  bool warning = false,
  bool voided = false,
  int day = 8,
  double oxygen = 5.4,
}) => WaterLog(
  id: id,
  seasonId: 'season',
  recordedAt: DateTime(2026, 9, day, 6, 30),
  createdAt: DateTime(2026, 9, day),
  isVoided: voided,
  exceededParameters: warning ? ['ph'] : [],
  temperatureC: 28.5,
  ph: warning ? 9 : 7.9,
  dissolvedOxygenMgL: oxygen,
  salinityPpt: 20,
  nh3MgL: 0.08,
  no2MgL: 0.4,
  alkalinityMgLCaCO3: 132,
  h2sMgL: 0,
);

Future<void> _open(
  WidgetTester tester,
  _Repository repository, {
  bool settle = true,
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
  tester.view.physicalSize = const Size(395, 854);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_Auth()),
      waterLogRepositoryProvider.overrideWithValue(repository),
      assignedSeasonRepositoryProvider.overrideWithValue(_Seasons(status)),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const WaterLogListPage(
          seasonId: 'season',
          pondName: 'Ao A5',
          seasonName: 'Vụ Đông Xuân 2025',
        ),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  if (settle) await tester.pumpAndSettle();
}

void main() {
  for (final status in AssignedSeasonStatus.values) {
    testWidgets('entry to create log is limited by $status', (tester) async {
      await _open(tester, _Repository(), status: status);
      expect(
        find.text('Nhập nhật ký đo nước'),
        status == AssignedSeasonStatus.active ? findsOneWidget : findsNothing,
      );
      expect(find.byType(WaterLogCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'refresh replaces a pending page without automatically loading more',
    (tester) async {
      final repository = _RacingRepository();
      await _open(tester, repository, settle: false);
      expect(repository.cursors, [null]);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(WaterLogListPage)),
      );
      final pending = container
          .read(waterLogListProvider('season').notifier)
          .loadMore();
      await container.read(waterLogListProvider('season').notifier).refresh();
      repository.oldPage.complete(
        WaterLogPage(
          items: [_log('stale')],
          totalResults: 2,
          hasNextPage: false,
        ),
      );
      await pending;
      await tester.pumpAndSettle();
      expect(repository.cursors, [null, 'old-cursor', null]);
      expect(
        container
            .read(waterLogListProvider('season'))
            .requireValue
            .page
            .items
            .map((log) => log.id),
        ['fresh'],
      );
      expect(find.text('Tất cả (2)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('server filters find later warnings without draining all pages', (
    tester,
  ) async {
    final repository = _Repository(paginated: true);
    await _open(tester, repository);
    expect(repository.cursors, [null]);
    expect(find.text('Tất cả (3)'), findsOneWidget);
    expect(find.text('Cảnh báo (1)'), findsOneWidget);
    expect(find.text('Vô hiệu (1)'), findsOneWidget);
    await tester.tap(find.text('Cảnh báo (1)'));
    await tester.pumpAndSettle();
    expect(repository.filters, [WaterLogFilter.all, WaterLogFilter.warning]);
    expect(
      tester.widget<WaterLogCard>(find.byType(WaterLogCard)).log.id,
      'warning',
    );
    await tester.tap(find.text('Vô hiệu (1)'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<WaterLogCard>(find.byType(WaterLogCard)).log.id,
      'voided',
    );
    expect(tester.takeException(), isNull);
    expect(repository.cursors, [null, null, null]);
    expect(
      find.text('5.4'),
      findsOneWidget,
    ); // Latest DO remains independent of tab.
  });

  testWidgets('short list footer loads one page and keeps server counts', (
    tester,
  ) async {
    final repository = _Repository(paginated: true);
    await _open(tester, repository);
    expect(repository.cursors, [null]);
    await tester.ensureVisible(find.text('Tải thêm'));
    await tester.tap(find.text('Tải thêm'));
    await tester.pumpAndSettle();
    expect(repository.cursors, [null, 'next']);
    expect(repository.countRequests, [true, false]);
    expect(find.text('Cảnh báo (1)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'scroll near the end fetches the next page only after scrolling',
    (tester) async {
      final repository = _Repository(paginated: true, longPage: true);
      await _open(tester, repository);
      expect(repository.cursors, [null]);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -20000));
      await tester.pumpAndSettle();
      expect(repository.cursors, [null, 'next']);
      expect(repository.countRequests, [true, false]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('footer error retains the list and retries the same cursor', (
    tester,
  ) async {
    final repository = _Repository(paginated: true)..failMoreOnce = true;
    await _open(tester, repository);
    await tester.ensureVisible(find.text('Tải thêm'));
    await tester.tap(find.text('Tải thêm'));
    await tester.pumpAndSettle();
    expect(repository.cursors, [null, 'next']);
    expect(find.byType(WaterLogCard), findsOneWidget);
    expect(find.text('Cảnh báo (1)'), findsOneWidget);
    await tester.ensureVisible(find.text('Thử lại'));
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(repository.cursors, [null, 'next', 'next']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'refresh and resume keep the selected server filter at page one',
    (tester) async {
      final repository = _Repository(paginated: true);
      await _open(tester, repository);
      await tester.tap(find.text('Cảnh báo (1)'));
      await tester.pumpAndSettle();
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(repository.filters, [
        WaterLogFilter.all,
        WaterLogFilter.warning,
        WaterLogFilter.warning,
        WaterLogFilter.warning,
      ]);
      expect(repository.cursors.every((cursor) => cursor == null), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'renders eight parameters and handles empty filter on narrow screen',
    (tester) async {
      await _open(tester, _Repository());
      expect(find.text('H2S'), findsOneWidget);
      expect(find.text('Ao A5 · Vụ Đông Xuân 2025'), findsOneWidget);
      expect(find.text('DO MỚI NHẤT'), findsOneWidget);
      tester.view.physicalSize = const Size(320, 700);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cảnh báo (0)'));
      await tester.pumpAndSettle();
      expect(find.byType(WaterLogCard), findsNothing);
      expect(find.text('Không có bản ghi trong bộ lọc này.'), findsOneWidget);
    },
  );
}

class _Auth implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'tech',
    email: 'tech@example.com',
    role: AccountRole.technician,
    status: AccountStatus.active,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RacingRepository extends _Repository {
  final oldPage = Completer<WaterLogPage>();
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
    if (filter == null) return _latestPage();
    cursors.add(cursor);
    if (cursor == 'old-cursor') return oldPage.future;
    if (cursor == 'fresh-cursor') {
      return WaterLogPage(
        items: [_log('fresh-older')],
        totalResults: 2,
        hasNextPage: false,
      );
    }
    final initial = cursors.length == 1;
    return WaterLogPage(
      items: [_log(initial ? 'old' : 'fresh')],
      totalResults: 2,
      hasNextPage: true,
      nextCursor: initial ? 'old-cursor' : 'fresh-cursor',
      counts: const WaterLogCounts(all: 2, valid: 2, warning: 0, voided: 0),
    );
  }
}

class _Repository implements WaterLogRepository {
  _Repository({this.paginated = false, this.longPage = false});
  final bool paginated;
  final bool longPage;
  bool failMoreOnce = false;
  final cursors = <String?>[];
  final filters = <WaterLogFilter>[];
  final countRequests = <bool>[];
  WaterLogPage _latestPage() => WaterLogPage(
    items: [_log('latest')],
    totalResults: 1,
    hasNextPage: false,
  );
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
    if (filter == null) return _latestPage();
    cursors.add(cursor);
    filters.add(filter);
    countRequests.add(includeCounts);
    if (cursor != null && failMoreOnce) {
      failMoreOnce = false;
      throw StateError('network unavailable');
    }
    final counts = paginated
        ? const WaterLogCounts(all: 3, valid: 2, warning: 1, voided: 1)
        : const WaterLogCounts(all: 1, valid: 1, warning: 0, voided: 0);
    if (filter != WaterLogFilter.all) {
      return WaterLogPage(
        items: !paginated
            ? []
            : [
                _log(
                  filter.name,
                  warning: true,
                  voided: filter == WaterLogFilter.voided,
                  oxygen: 1.2,
                ),
              ],
        totalResults: !paginated ? 0 : 1,
        hasNextPage: false,
        counts: counts,
      );
    }
    if (!paginated) {
      return WaterLogPage(
        items: [_log('valid')],
        totalResults: 1,
        hasNextPage: false,
        counts: counts,
      );
    }
    if (cursor == null) {
      return WaterLogPage(
        items: longPage
            ? [for (var i = 0; i < 20; i++) _log('valid-$i')]
            : [_log('valid')],
        totalResults: 3,
        hasNextPage: true,
        nextCursor: 'next',
        counts: counts,
      );
    }
    return WaterLogPage(
      items: [
        _log('warning', warning: true, day: 7),
        _log('voided', warning: true, voided: true, day: 9),
      ],
      totalResults: 3,
      hasNextPage: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Seasons implements AssignedSeasonRepository {
  _Seasons(this.status);
  final AssignedSeasonStatus status;
  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async =>
      AssignedSeasonDetail(
        id: seasonId,
        name: 'Vụ nuôi',
        status: status,
        shrimpType: 'WHITELEG',
        pondId: 'pond',
        pondName: 'Ao A5',
        pondType: 'LINED',
        pondStatus: 'ACTIVE',
        farmId: 'farm',
        farmName: 'Trại',
        personnel: [],
        otherAssignedSeasons: [],
        assignedAt: DateTime(2026),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
