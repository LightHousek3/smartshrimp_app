import 'dart:async';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/pages/assigned_season_detail_page.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/pages/assigned_season_list_page.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/assigned_season/data/services/assigned_season_api_service.dart';
import 'package:smartshrimp_app/features/assigned_season/data/repositories/assigned_season_repository_impl.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart'
    show shrimpTypeLabel;

void main() {
  for (final entry in <Object?, ShrimpType>{
    'WHITELEG': ShrimpType.whiteleg,
    'BLACK_TIGER': ShrimpType.blackTiger,
    'FUTURE_SHRIMP': ShrimpType.unknown,
    '': ShrimpType.unknown,
    null: ShrimpType.unknown,
  }.entries) {
    test('assigned list and detail parse shrimp type ${entry.key}', () {
      final list = AssignedSeason.parse({
        ..._seasonJson(id: 'season-1', status: 'ACTIVE'),
        'shrimpType': entry.key,
      });
      final detail = AssignedSeasonDetail.parse(_detailJson(entry.key));
      expect(list.shrimpType, entry.value);
      expect(detail.shrimpType, entry.value);
      if (entry.value == ShrimpType.unknown) {
        // The shared helper's default remains unchanged for other screens.
        expect(shrimpTypeLabel(entry.value), 'Không xác định');
      }
    });

    testWidgets(
      'detail renders safe shrimp and personnel labels for ${entry.key}',
      (tester) async {
        tester.view.physicalSize = const Size(600, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final api = AssignedSeasonApiService(
          ApiClient(
            _dioWithHandler((request, handler) {
              expect(request.method, 'GET');
              expect(request.path, '/me/seasons/season-1');
              handler.resolve(
                _success(request, data: _detailJson(entry.key), meta: const {}),
              );
            }),
            _FakeSessionStore(),
          ),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assignedSeasonRepositoryProvider.overrideWithValue(
                AssignedSeasonRepositoryImpl(api),
              ),
              latestWaterLogProvider(
                'season-1',
              ).overrideWith((ref) async => null),
              assignedSeasonTodayOperationsProvider(
                'season-1',
              ).overrideWith((ref) async => []),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: AssignedSeasonDetailPage(seasonId: 'season-1'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final label = switch (entry.value) {
          ShrimpType.whiteleg => 'Tôm thẻ chân trắng',
          ShrimpType.blackTiger => 'Tôm sú',
          ShrimpType.unknown => 'Không rõ',
        };
        expect(find.text('$label · 5000 m² · 7500 m³'), findsOneWidget);
        if (entry.value == ShrimpType.unknown) {
          expect(find.textContaining('Tôm sú'), findsNothing);
        }
        expect(find.text('Kỹ thuật viên phụ trách'), findsOneWidget);
        expect(find.text('Chuyên gia thủy sản'), findsOneWidget);
        expect(find.text('Không rõ'), findsNWidgets(3));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  for (final entry in <Object?, AssignedSeasonPersonnelRole>{
    'TECHNICIAN': AssignedSeasonPersonnelRole.technician,
    'EXPERT': AssignedSeasonPersonnelRole.expert,
    'FUTURE_ROLE': AssignedSeasonPersonnelRole.unknown,
    '': AssignedSeasonPersonnelRole.unknown,
    null: AssignedSeasonPersonnelRole.unknown,
  }.entries) {
    test('personnel parser handles ${entry.key}', () {
      expect(assignedSeasonPersonnelRoleFromJson(entry.key), entry.value);
      final detail = AssignedSeasonDetail.parse(_detailJson('WHITELEG'));
      final index = <Object?>[
        'TECHNICIAN',
        'EXPERT',
        'FUTURE_ROLE',
        '',
        null,
      ].indexOf(entry.key);
      expect(detail.personnel[index].role, entry.value);
    });
  }

  testWidgets(
    'refresh releases old pagination UI without letting old completion hide the new spinner',
    (tester) async {
      final repository = _ControlledAssignedRepository();
      await _openList(tester, repository);
      repository.requests[0].result.complete(_listPage('old', more: true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thử tải thêm'));
      await tester.pump();
      final refresh = tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pump();
      repository.requests[2].result.complete(_listPage('fresh', more: true));
      await refresh;
      await tester.pump();
      await tester.tap(find.text('Thử tải thêm'));
      await tester.pump();
      expect(repository.requests, hasLength(4));
      repository.requests[1].result.complete(_listPage('obsolete'));
      await tester.pump();
      expect(find.text('Đang tải...'), findsOneWidget);
      repository.requests[3].result.complete(_listPage('new-next'));
      await tester.pumpAndSettle();
      expect(find.text('Ao obsolete'), findsNothing);
      expect(find.text('Ao new-next'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('losing a selected farm assignment resets only the farm filter', (
    tester,
  ) async {
    final repository = _ControlledAssignedRepository();
    var choices = _farmChoices;
    await _openList(tester, repository, farms: (ref) async => choices);
    repository.requests[0].result.complete(_listPage('initial'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Lọc trại'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Farm B'));
    await tester.pump();
    repository.requests[1].result.complete(_listPage('farm-b'));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AssignedSeasonListPage)),
    );
    choices = [_farmChoices.first];
    container.invalidate(assignedSeasonFarmOptionsProvider);
    await tester.pump();
    await tester.pump();
    expect(repository.requests[2].farmId, isNull);
    expect(repository.requests[2].status, AssignedSeasonStatus.active);
    repository.requests[2].result.complete(_listPage('remaining'));
    await tester.pumpAndSettle();
    expect(find.text('Ao remaining'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'pond-style filter toolbar fits a narrow screen and limits search length',
    (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final repository = _ControlledAssignedRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonRepositoryProvider.overrideWithValue(repository),
            assignedSeasonFarmOptionsProvider.overrideWith(
              (ref) async => _farmChoices,
            ),
          ],
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.6)),
              child: child!,
            ),
            home: const Scaffold(body: AssignedSeasonListPage()),
          ),
        ),
      );
      const empty = AssignedSeasonPage(
        items: [],
        totalResults: 0,
        activeResults: 0,
        allResults: 0,
        hasNextPage: false,
      );
      repository.requests[0].result.complete(empty);
      await tester.pumpAndSettle();
      final field = find.byKey(const Key('assigned_season_search'));
      await tester.enterText(field, 'a' * 256);
      await tester.pump(AssignedSeasonRules.searchDebounce);
      expect(
        repository.requests[1].search!.length,
        AssignedSeasonRules.searchMaxLength,
      );
      repository.requests[1].result.complete(empty);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  test(
    'repository sends combined filters and cursor through the authenticated API',
    () async {
      final repository = AssignedSeasonRepositoryImpl(
        AssignedSeasonApiService(
          ApiClient(
            _dioWithHandler((request, handler) {
              expect(request.path, '/me/seasons');
              expect(request.headers['Authorization'], 'Bearer access-token');
              expect(request.queryParameters, {
                'limit': 20,
                'status': 'ACTIVE',
                'search': 'Ao 1',
                'farmId': 'farm-1',
                'cursor': 'cursor-1',
              });
              handler.resolve(_success(request, data: [], meta: _emptyMeta));
            }),
            _FakeSessionStore(),
          ),
        ),
      );
      await repository.getAssignedSeasons(
        status: AssignedSeasonStatus.active,
        search: '  Ao 1  ',
        farmId: 'farm-1',
        cursor: 'cursor-1',
      );
    },
  );

  test(
    'farm choices use their own authenticated endpoint and validate response shape',
    () async {
      var malformed = false;
      final service = AssignedSeasonApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            expect(request.path, '/me/seasons/farms');
            expect(request.headers['Authorization'], 'Bearer access-token');
            expect(request.queryParameters, isEmpty);
            handler.resolve(
              _success(
                request,
                data: malformed
                    ? [
                        {'id': 'farm-1', 'name': 123},
                      ]
                    : [
                        {'id': 'farm-1', 'name': 'Farm A'},
                      ],
                meta: {},
              ),
            );
          }),
          _FakeSessionStore(),
        ),
      );
      expect(await service.getAssignedSeasonFarms(), [
        (id: 'farm-1', name: 'Farm A'),
      ]);
      malformed = true;
      await expectLater(
        service.getAssignedSeasonFarms(),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );

  test(
    'changing search/farm discards old pages and keeps the full query on refresh/load more',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('old', more: true));
      await container.read(assignedSeasonListProvider.future);
      final controller = container.read(assignedSeasonListProvider.notifier);
      final oldMore = controller.loadMore();
      final change = controller.setFilters(
        status: null,
        search: '  pond  ',
        farmId: 'farm-2',
      );
      await container.pump();
      expect(repository.requests[2].search, 'pond');
      expect(repository.requests[2].farmId, 'farm-2');
      expect(repository.requests[2].status, isNull);
      expect(repository.requests[2].cursor, isNull);
      repository.requests[2].result.complete(_listPage('filtered', more: true));
      await change;
      repository.requests[1].result.complete(_listPage('obsolete'));
      await oldMore;
      expect(_listIds(container), ['filtered']);
      final more = controller.loadMore();
      expect(repository.requests[3].search, 'pond');
      expect(repository.requests[3].farmId, 'farm-2');
      expect(repository.requests[3].cursor, 'filtered-cursor');
      repository.requests[3].result.complete(_listPage('next'));
      await more;
      final refresh = controller.refresh();
      await container.pump();
      expect(repository.requests[4].search, 'pond');
      expect(repository.requests[4].farmId, 'farm-2');
      expect(repository.requests[4].cursor, isNull);
      repository.requests[4].result.complete(_listPage('fresh'));
      await refresh;
      expect(controller.filter, (
        status: null,
        search: 'pond',
        farmId: 'farm-2',
      ));
      expect(_listIds(container), ['fresh']);
    },
  );

  testWidgets(
    'search debounces, retains focus during loading, discards stale results and clears immediately',
    (tester) async {
      final repository = _ControlledAssignedRepository();
      await _openList(tester, repository);
      repository.requests[0].result.complete(_listPage('initial'));
      await tester.pumpAndSettle();
      final search = find.byKey(const Key('assigned_season_search'));
      await tester.enterText(search, 'first');
      await tester.pump(const Duration(milliseconds: 200));
      expect(repository.requests, hasLength(1));
      await tester.enterText(search, ' second ');
      await tester.pump(const Duration(milliseconds: 299));
      expect(repository.requests, hasLength(1));
      await tester.pump(const Duration(milliseconds: 1));
      expect(repository.requests[1].search, 'second');
      expect(search, findsOneWidget);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.enterText(search, 'third');
      await tester.pump(AssignedSeasonRules.searchDebounce);
      repository.requests[2].result.complete(_listPage('latest'));
      await tester.pump();
      repository.requests[1].result.complete(_listPage('stale'));
      await tester.pumpAndSettle();
      expect(find.text('Ao latest'), findsOneWidget);
      expect(find.text('Ao stale'), findsNothing);
      await tester.tap(find.byTooltip('Xóa tìm kiếm'));
      await tester.pump();
      expect(repository.requests[3].search, '');
      repository.requests[3].result.complete(_listPage('cleared'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(search).controller!.text, '');
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'farm menu includes farms outside the loaded page and combines with tab selection',
    (tester) async {
      final repository = _ControlledAssignedRepository();
      await _openList(tester, repository);
      repository.requests[0].result.complete(_listPage('initial', more: true));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lọc trại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Farm B'));
      await tester.pump();
      expect(repository.requests[1].farmId, 'farm-2');
      repository.requests[1].result.complete(_listPage('farm-b'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tất cả (1)'));
      await tester.pump();
      expect(repository.requests[2].status, isNull);
      expect(repository.requests[2].farmId, 'farm-2');
      repository.requests[2].result.complete(_listPage('all-in-b'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xóa bộ lọc'));
      await tester.pump();
      expect(repository.requests[3].status, isNull);
      expect(repository.requests[3].farmId, isNull);
      repository.requests[3].result.complete(_listPage('reset'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'farm options can fail and retry without blocking search or reloading the list',
    (tester) async {
      final repository = _ControlledAssignedRepository();
      var fail = true;
      await _openList(
        tester,
        repository,
        farms: (ref) async {
          if (fail) throw const ApiException('farm options failed');
          return _farmChoices;
        },
      );
      repository.requests[0].result.complete(_listPage('initial'));
      await tester.pumpAndSettle();
      expect(find.text('farm options failed'), findsOneWidget);
      expect(find.byKey(const Key('assigned_season_search')), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Thử lại trại'));
      await tester.pumpAndSettle();
      expect(find.text('farm options failed'), findsNothing);
      expect(repository.requests, hasLength(1));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('empty search keeps controls and can reset its query', (
    tester,
  ) async {
    final repository = _ControlledAssignedRepository();
    await _openList(tester, repository);
    repository.requests[0].result.complete(_listPage('initial'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('assigned_season_search')),
      'missing',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(repository.requests[1].search, 'missing');
    repository.requests[1].result.complete(
      const AssignedSeasonPage(
        items: [],
        totalResults: 0,
        activeResults: 0,
        allResults: 0,
        hasNextPage: false,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy vụ nuôi phù hợp'), findsOneWidget);
    await tester.tap(find.text('Xóa bộ lọc tìm kiếm'));
    await tester.pump();
    repository.requests[2].result.complete(_listPage('reset'));
    await tester.pumpAndSettle();
    expect(repository.requests[2].search, '');
    await tester.pumpWidget(const SizedBox.shrink());
  });
  for (final (raw, label) in <(String?, String)>[
    ('EXCELLENT', 'Rất tốt'),
    ('GOOD', 'Bình thường'),
    ('WARNING', 'Cảnh báo'),
    ('CRITICAL', 'Nguy cấp'),
    (null, 'Chưa có'),
    ('FUTURE_STATUS', 'Không xác định'),
  ]) {
    testWidgets('list health $raw displays $label', (tester) async {
      final repository = _ControlledAssignedRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonFarmOptionsProvider.overrideWith(
              (ref) async => _farmChoices,
            ),
            assignedSeasonRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: AssignedSeasonListPage()),
          ),
        ),
      );
      repository.requests[0].result.complete(
        _listPage('health', healthStatus: raw),
      );
      await tester.pumpAndSettle();
      expect(find.text(label), findsOneWidget);
      if (raw != null) expect(find.text('Chưa có'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  test(
    'list parser preserves nullable/unknown health and rejects malformed types',
    () {
      final json = _seasonJson(id: 'health', status: 'ACTIVE');
      expect(AssignedSeason.parse(json).currentHealthStatus, isNull);
      expect(
        AssignedSeason.parse({
          ...json,
          'currentHealthStatus': 'CRITICAL',
        }).currentHealthStatus,
        'CRITICAL',
      );
      expect(
        AssignedSeason.parse({
          ...json,
          'currentHealthStatus': 'FUTURE_STATUS',
        }).currentHealthStatus,
        'FUTURE_STATUS',
      );
      expect(
        () => AssignedSeason.parse({...json, 'currentHealthStatus': 1}),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
  test('list refresh cancels an unfinished initial response', () async {
    final repository = _ControlledAssignedRepository();
    final container = _listContainer(repository);
    final controller = container.read(assignedSeasonListProvider.notifier);
    final refresh = controller.refresh();
    await container.pump();
    repository.requests[1].result.complete(_listPage('fresh'));
    await refresh;
    repository.requests[0].result.complete(_listPage('old'));
    await container.pump();
    expect(_listIds(container), ['fresh']);
  });

  test(
    'switching tabs discards the previous tab pagination response',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('active', more: true));
      await container.read(assignedSeasonListProvider.future);
      final controller = container.read(assignedSeasonListProvider.notifier);
      final oldMore = controller.loadMore();
      final switchTab = controller.setActiveOnly(false);
      await container.pump();
      expect(repository.requests[1].status, AssignedSeasonStatus.active);
      expect(repository.requests[1].cursor, 'active-cursor');
      expect(repository.requests[2].status, isNull);
      expect(repository.requests[2].cursor, isNull);
      repository.requests[2].result.complete(_listPage('all'));
      await switchTab;
      repository.requests[1].result.complete(_listPage('old-next'));
      await oldMore;
      expect(_listIds(container), ['all']);
    },
  );

  test(
    'old pagination cannot replace refresh data or unlock newer pagination',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('old', more: true));
      await container.read(assignedSeasonListProvider.future);
      final controller = container.read(assignedSeasonListProvider.notifier);
      final oldMore = controller.loadMore();
      final refresh = controller.refresh();
      await container.pump();
      repository.requests[2].result.complete(_listPage('fresh', more: true));
      await refresh;
      final newMore = controller.loadMore();
      repository.requests[1].result.complete(_listPage('obsolete'));
      await oldMore;
      await controller.loadMore();
      expect(repository.requests, hasLength(4));
      repository.requests[3].result.complete(_listPage('fresh-next'));
      await newMore;
      expect(_listIds(container), ['fresh', 'fresh-next']);
    },
  );

  test(
    'an obsolete page failure does not surface under a new filter',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('old', more: true));
      await container.read(assignedSeasonListProvider.future);
      final controller = container.read(assignedSeasonListProvider.notifier);
      final oldMore = controller.loadMore();
      final switchTab = controller.setActiveOnly(false);
      await container.pump();
      repository.requests[2].result.complete(_listPage('all'));
      await switchTab;
      repository.requests[1].result.completeError(
        const ApiException('obsolete error'),
      );
      await oldMore;
      expect(_listIds(container), ['all']);
    },
  );

  test(
    'refresh failure preserves visible rows and reaches the caller',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('visible', more: true));
      await container.read(assignedSeasonListProvider.future);
      final refresh = container
          .read(assignedSeasonListProvider.notifier)
          .refresh();
      final expectation = expectLater(refresh, throwsA(isA<ApiException>()));
      await container.pump();
      repository.requests[1].result.completeError(
        const ApiException('refresh failed'),
      );
      await expectation;
      expect(_listIds(container), ['visible']);
      final more = container
          .read(assignedSeasonListProvider.notifier)
          .loadMore();
      repository.requests[2].result.complete(_listPage('next'));
      await more;
      expect(_listIds(container), ['visible', 'next']);
    },
  );

  test(
    'pagination completion after disposal does not write provider state',
    () async {
      final repository = _ControlledAssignedRepository();
      final container = _listContainer(repository);
      repository.requests[0].result.complete(_listPage('old', more: true));
      await container.read(assignedSeasonListProvider.future);
      final more = container
          .read(assignedSeasonListProvider.notifier)
          .loadMore();
      container.dispose();
      repository.requests[1].result.complete(_listPage('late'));
      await more;
    },
  );

  test('filter failure does not display rows from the previous tab', () async {
    final repository = _ControlledAssignedRepository();
    final container = _listContainer(repository);
    repository.requests[0].result.complete(_listPage('active'));
    await container.read(assignedSeasonListProvider.future);
    final change = container
        .read(assignedSeasonListProvider.notifier)
        .setActiveOnly(false);
    await container.pump();
    repository.requests[1].result.completeError(
      const ApiException('filter failed'),
    );
    await change;
    final state = container.read(assignedSeasonListProvider);
    expect(state.hasError, isTrue);
    expect(
      container.read(assignedSeasonListProvider.notifier).retainRowsOnRefresh,
      isFalse,
    );
  });

  testWidgets('failed filter and retry never show rows from another tab', (
    tester,
  ) async {
    final repository = _ControlledAssignedRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assignedSeasonFarmOptionsProvider.overrideWith(
            (ref) async => _farmChoices,
          ),
          assignedSeasonRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: Scaffold(body: AssignedSeasonListPage()),
        ),
      ),
    );
    repository.requests[0].result.complete(_listPage('active'));
    await tester.pumpAndSettle();
    expect(find.text('Ao active'), findsOneWidget);
    await tester.tap(find.text('Tất cả (1)'));
    await tester.pump();
    expect(find.text('Ao active'), findsNothing);
    repository.requests[1].result.completeError(
      const ApiException('filter failed'),
    );
    await tester.pumpAndSettle();
    expect(find.text('filter failed'), findsOneWidget);
    expect(find.text('Ao active'), findsNothing);
    await tester.tap(find.text('Thử lại'));
    await tester.pump();
    expect(find.text('Ao active'), findsNothing);
    repository.requests[2].result.complete(_listPage('all'));
    await tester.pumpAndSettle();
    expect(find.text('Ao all'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final (entry, biomassAfter) in [
    ('Sức khỏe', 200.0),
    ('Sức khỏe', null),
    ('Xem chi tiết', 200.0),
    ('Xem chi tiết', null),
  ]) {
    testWidgets(
      'returning from health via $entry refreshes list health, biomass to $biomassAfter and preview',
      (tester) async {
        tester.view.physicalSize = const Size(600, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final repository = _AssignedRepository();
        var previews = 0;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: AssignedSeasonListPage()),
            ),
            GoRoute(
              path: '/seasons/:id',
              builder: (_, state) => Scaffold(
                body: AssignedSeasonDetailPage(
                  seasonId: state.pathParameters['id']!,
                ),
              ),
            ),
            GoRoute(
              path: '/seasons/:id/shrimp-health',
              builder: (context, _) => Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () {
                      repository.biomass = biomassAfter;
                      repository.healthStatus = biomassAfter == null
                          ? null
                          : 'WARNING';
                      context.pop();
                    },
                    child: const Text('Save and return'),
                  ),
                ),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assignedSeasonFarmOptionsProvider.overrideWith(
                (ref) async => _farmChoices,
              ),
              assignedSeasonRepositoryProvider.overrideWithValue(repository),
              latestWaterLogProvider(
                'season-1',
              ).overrideWith((ref) async => null),
              assignedSeasonTodayOperationsProvider('season-1').overrideWith((
                ref,
              ) async {
                previews++;
                return [];
              }),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Bình thường'), findsOneWidget);
        await tester.tap(find.text('Tất cả (1)'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('assigned_season_search')),
          'season',
        );
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Lọc trại'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Farm A'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ao season-1'));
        await tester.pumpAndSettle();
        expect(find.text('100 kg'), findsOneWidget);
        expect(repository.reads, 1);
        await tester.tap(find.text(entry));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save and return'));
        await tester.pumpAndSettle();
        expect(
          find.text(biomassAfter == null ? '— kg' : '200 kg'),
          findsOneWidget,
        );
        expect(repository.reads, 2);
        expect(previews, 2);
        router.pop();
        await tester.pumpAndSettle();
        expect(
          find.text(biomassAfter == null ? 'Chưa có' : 'Cảnh báo'),
          findsOneWidget,
        );
        expect(repository.lastListStatus, isNull);
        expect(repository.lastListSearch, 'season');
        expect(repository.lastListFarmId, 'farm-1');
        expect(repository.listReads, 5);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets(
    'detail exposes preview error, retries and keeps the disease case placeholder',
    (tester) async {
      tester.view.physicalSize = const Size(600, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      var fail = true;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonFarmOptionsProvider.overrideWith(
              (ref) async => _farmChoices,
            ),
            assignedSeasonRepositoryProvider.overrideWithValue(
              _AssignedRepository(),
            ),
            latestWaterLogProvider(
              'season-1',
            ).overrideWith((ref) async => null),
            assignedSeasonTodayOperationsProvider('season-1').overrideWith((
              ref,
            ) async {
              if (fail) throw const ApiException('preview failed');
              return [];
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AssignedSeasonDetailPage(seasonId: 'season-1'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('preview failed'), findsOneWidget);
      expect(find.byIcon(Icons.emergency_outlined), findsOneWidget);
      expect(find.text('Ca bệnh'), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Th\u1eed l\u1ea1i'));
      await tester.pumpAndSettle();
      expect(find.text('preview failed'), findsNothing);
      expect(
        find.text(
          'Ch\u01b0a c\u00f3 l\u1ecbch v\u1eadn h\u00e0nh n\u00e0o h\u00f4m nay',
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  test('unknown assigned season status fails consistently', () {
    expect(
      () => assignedSeasonStatusFromJson('FUTURE'),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('DOC uses Vietnam calendar and rejects future stocking dates', () {
    expect(
      AssignedSeasonRules.vietnamDay(DateTime.parse('2026-11-07T17:00:00Z')),
      DateTime.utc(2026, 11, 8),
    );
    final today = AssignedSeasonRules.vietnamDay(DateTime.now());
    expect(
      AssignedSeasonRules.dayOfCulture(today, AssignedSeasonStatus.active),
      1,
    );
    expect(
      AssignedSeasonRules.dayOfCulture(
        today.add(const Duration(days: 1)),
        AssignedSeasonStatus.active,
      ),
      isNull,
    );
    expect(
      AssignedSeasonRules.dayOfCulture(today, AssignedSeasonStatus.planning),
      isNull,
    );
  });

  test(
    'today preview spans UTC days, paginates, sorts and excludes boundaries',
    () async {
      final day = AssignedSeasonRules.vietnamDay(DateTime.now());
      final start = day.subtract(AssignedSeasonRules.vietnamOffset);
      final end = start.add(const Duration(days: 1));
      final calls = <String>[];
      final repository = _PreviewRepository((date, page) async {
        calls.add('$date:$page');
        if (date == AssignedSeasonRules.dateOnly(start)) {
          if (page == 1) {
            return List.generate(
              AssignedSeasonRules.operationPageSize,
              (i) => _schedule(
                'old-$i',
                start.subtract(const Duration(seconds: 1)),
              ),
            );
          }
          return [
            _schedule('midnight', start),
            _schedule('late', start.add(const Duration(hours: 1))),
          ];
        }
        return [
          _schedule('noon', day.add(const Duration(hours: 5))),
          _schedule('evening', day.add(const Duration(hours: 16))),
          _schedule('tomorrow', end),
        ];
      });
      final container = ProviderContainer(
        overrides: [operationRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final result = await container.read(
        assignedSeasonTodayOperationsProvider('season-1').future,
      );
      expect(result.map((item) => item.id), ['midnight', 'late', 'noon']);
      expect(calls, contains('${AssignedSeasonRules.dateOnly(start)}:2'));
    },
  );

  test(
    'preview exposes loading failure and can retry after invalidation',
    () async {
      var fail = true;
      final container = ProviderContainer(
        overrides: [
          assignedSeasonFarmOptionsProvider.overrideWith(
            (ref) async => _farmChoices,
          ),
          operationRepositoryProvider.overrideWithValue(
            _PreviewRepository((date, page) async {
              if (fail) throw const InvalidResponseException();
              return [];
            }),
          ),
        ],
      );
      addTearDown(container.dispose);
      final provider = assignedSeasonTodayOperationsProvider('season-1');
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await expectLater(
        container.read(provider.future),
        throwsA(isA<InvalidResponseException>()),
      );
      fail = false;
      container.invalidate(provider);
      expect(await container.read(provider.future), isEmpty);
    },
  );

  test('parses list counts and all season statuses', () async {
    final statuses = <String>['PLANNING', 'ACTIVE', 'COMPLETED', 'CANCELLED'];
    final service = AssignedSeasonApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          handler.resolve(
            _success(
              request,
              data: <Object?>[
                for (var i = 0; i < statuses.length; i++)
                  _seasonJson(id: 'season-$i', status: statuses[i]),
              ],
              meta: <String, dynamic>{
                'limit': 20,
                'totalResults': 4,
                'activeResults': 1,
                'allResults': 4,
                'hasNextPage': false,
                'nextCursor': null,
              },
            ),
          );
        }),
        _FakeSessionStore(),
      ),
    );

    final page = await service.getAssignedSeasons(<String, dynamic>{
      'limit': 20,
    });

    expect(page.items.first.initialDensityPerM2, 100);
    expect(page.activeResults, 1);
    expect(page.allResults, 4);
    expect(page.items.map((item) => item.status), <AssignedSeasonStatus>[
      AssignedSeasonStatus.planning,
      AssignedSeasonStatus.active,
      AssignedSeasonStatus.completed,
      AssignedSeasonStatus.cancelled,
    ]);
  });

  test('parses assigned season stocking metrics and current biomass', () {
    final detail = AssignedSeasonDetail.parse(<String, dynamic>{
      'id': 'season-1',
      'name': 'Vụ 1',
      'status': 'ACTIVE',
      'shrimpType': 'WHITELEG',
      'stockingDate': '2026-09-29',
      'expectedEndDate': '2027-01-15',
      'initialQuantity': 500000,
      'initialDensityPerM2': 100,
      'currentBiomassKg': 1234.5,
      'pond': <String, dynamic>{
        'id': 'pond-1',
        'name': 'Ao A1',
        'type': 'AQUACULTURE',
        'status': 'AVAILABLE',
        'areaM2': 5000,
        'depthM': 1.5,
        'volumeM3': 7500,
      },
      'farm': <String, dynamic>{
        'id': 'farm-1',
        'name': 'Trại 1',
        'address': null,
      },
      'personnel': <dynamic>[],
      'otherAssignedSeasons': <dynamic>[],
      'assignment': <String, dynamic>{'assignedAt': '2026-09-29T00:00:00.000Z'},
    });

    expect(detail.initialQuantity, 500000);
    expect(detail.expectedEndDate, DateTime(2027, 1, 15));
    expect(detail.initialDensityPerM2, 100);
    expect(detail.currentBiomassKg, 1234.5);
  });
}

Dio _dioWithHandler(
  FutureOr<void> Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}

Response<Map<String, dynamic>> _success(
  RequestOptions request, {
  required Object? data,
  required Map<String, dynamic> meta,
}) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{
    'success': true,
    'message': 'Success',
    'data': data,
    'meta': meta,
  },
);

Map<String, dynamic> _seasonJson({
  required String id,
  required String status,
}) => <String, dynamic>{
  'id': id,
  'name': 'Vụ $id',
  'status': status,
  'shrimpType': 'WHITELEG',
  'stockingDate': '2026-09-01',
  'expectedEndDate': null,
  'initialDensityPerM2': 100,
  'pond': <String, dynamic>{
    'id': 'pond-$id',
    'name': 'Ao $id',
    'status': 'AVAILABLE',
  },
  'farm': <String, dynamic>{'id': 'farm-1', 'name': 'Trại 1'},
  'assignment': <String, dynamic>{'assignedAt': '2026-09-01T00:00:00.000Z'},
};

Map<String, dynamic> _detailJson(Object? shrimpType) => {
  ..._seasonJson(id: 'season-1', status: 'ACTIVE'),
  'shrimpType': shrimpType,
  'pond': {
    'id': 'pond-1',
    'name': 'Ao A1',
    'type': 'AQUACULTURE',
    'status': 'AVAILABLE',
    'areaM2': 5000,
    'volumeM3': 7500,
  },
  'personnel': [
    for (final role in ['TECHNICIAN', 'EXPERT', 'FUTURE_ROLE', '', null])
      {
        'role': role,
        'account': {'fullName': 'Personnel $role'},
      },
  ],
  'otherAssignedSeasons': <dynamic>[],
};

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken = 'refresh-token';
  @override
  Future<void> clear() async {}
  @override
  Future<void> initialize() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

OperationSchedule _schedule(String id, DateTime at) => OperationSchedule(
  id: id,
  seasonId: 'season-1',
  protocolItemId: 'item-1',
  operationType: OperationType.feeding,
  scheduledAt: at,
  plannedQuantity: 1,
  unit: 'KG',
  doseBasisSnapshot: 'FIXED_QUANTITY',
  doseValueSnapshot: 1,
  calculationVersion: '1',
  status: OperationStatus.planned,
);

final class _PreviewRepository implements OperationRepository {
  _PreviewRepository(this.load);
  final Future<List<OperationSchedule>> Function(String date, int page) load;

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async => OperationListResult(
    summary: const OperationSummary(
      planned: 0,
      completed: 0,
      cancelled: 0,
      total: 0,
    ),
    banner: const OperationBanner(hasBiomassWarning: false),
    schedules: await load(date!, page!),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _AssignedRepository implements AssignedSeasonRepository {
  double? biomass = 100;
  String? healthStatus = 'GOOD';
  AssignedSeasonStatus? lastListStatus;
  String? lastListSearch, lastListFarmId;
  int listReads = 0;
  int reads = 0;
  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = AssignedSeasonRules.pageSize,
  }) async {
    listReads++;
    lastListStatus = status;
    lastListSearch = search;
    lastListFarmId = farmId;
    return _listPage('season-1', healthStatus: healthStatus);
  }

  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async {
    reads++;
    return AssignedSeasonDetail(
      currentBiomassKg: biomass,
      id: seasonId,
      name: 'Season',
      status: AssignedSeasonStatus.active,
      shrimpType: ShrimpType.whiteleg,
      pondId: 'pond-1',
      pondName: 'Pond',
      pondType: 'AQUACULTURE',
      pondStatus: 'AVAILABLE',
      farmId: 'farm-1',
      farmName: 'Farm',
      personnel: [],
      otherAssignedSeasons: [],
      assignedAt: DateTime.utc(2026),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _ControlledAssignedRepository implements AssignedSeasonRepository {
  final requests =
      <
        ({
          AssignedSeasonStatus? status,
          String? search,
          String? farmId,
          String? cursor,
          Completer<AssignedSeasonPage> result,
        })
      >[];

  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = AssignedSeasonRules.pageSize,
  }) {
    final result = Completer<AssignedSeasonPage>();
    requests.add((
      status: status,
      search: search,
      farmId: farmId,
      cursor: cursor,
      result: result,
    ));
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ProviderContainer _listContainer(_ControlledAssignedRepository repository) {
  final container = ProviderContainer(
    overrides: [assignedSeasonRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  container.listen(assignedSeasonListProvider, (_, _) {});
  return container;
}

AssignedSeasonPage _listPage(
  String id, {
  bool more = false,
  String? healthStatus,
}) => AssignedSeasonPage(
  items: [
    AssignedSeason.parse({
      ..._seasonJson(id: id, status: 'ACTIVE'),
      'currentHealthStatus': healthStatus,
    }),
  ],
  totalResults: 1,
  activeResults: 1,
  allResults: 1,
  hasNextPage: more,
  nextCursor: more ? '$id-cursor' : null,
);

List<String> _listIds(ProviderContainer container) => container
    .read(assignedSeasonListProvider)
    .value!
    .items
    .map((item) => item.id)
    .toList();

const _farmChoices = <AssignedSeasonFarm>[
  (id: 'farm-1', name: 'Farm A'),
  (id: 'farm-2', name: 'Farm B'),
];

const _emptyMeta = <String, dynamic>{
  'limit': 20,
  'totalResults': 0,
  'activeResults': 0,
  'allResults': 0,
  'hasNextPage': false,
  'nextCursor': null,
};

Future<void> _openList(
  WidgetTester tester,
  _ControlledAssignedRepository repository, {
  Future<List<AssignedSeasonFarm>> Function(Ref)? farms,
}) => tester.pumpWidget(
  ProviderScope(
    overrides: [
      assignedSeasonRepositoryProvider.overrideWithValue(repository),
      assignedSeasonFarmOptionsProvider.overrideWith(
        farms ?? (ref) async => _farmChoices,
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: AssignedSeasonListPage())),
  ),
);
