import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_counts.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';

const _counts = WaterLogCounts(all: 120, valid: 110, warning: 30, voided: 10);
WaterLog _log(String id) => WaterLog(
  id: id,
  seasonId: 'season',
  recordedAt: DateTime(2026),
  createdAt: DateTime(2026),
  isVoided: false,
  exceededParameters: [],
);
WaterLogPage _page(
  String id, {
  bool more = false,
  String? cursor,
  WaterLogCounts? counts = _counts,
}) => WaterLogPage(
  items: [_log(id)],
  totalResults: 120,
  hasNextPage: more,
  nextCursor: cursor,
  counts: counts,
);
typedef _Query = ({
  WaterLogFilter? filter,
  bool counts,
  String? cursor,
  DateTime? from,
  DateTime? to,
});

void main() {
  test(
    'append deduplicates IDs in server order and keeps first-page counts',
    () {
      final first = _page('a', more: true, cursor: 'next');
      final appended = first.append(
        WaterLogPage(
          items: [_log('a'), _log('b')],
          totalResults: 121,
          hasNextPage: false,
        ),
      );
      expect(appended.items.map((log) => log.id), ['a', 'b']);
      expect(appended.counts, _counts);
      expect(appended.totalResults, 121);
      expect(() => appended.items.add(_log('c')), throwsUnsupportedError);
    },
  );
  test(
    'strict counts parser rejects missing/noninteger/negative/inconsistent values',
    () {
      final valid = {'all': 120, 'valid': 110, 'warning': 30, 'voided': 10};
      expect(WaterLogCounts.parse(valid), _counts);
      for (final raw in [
        null,
        [],
        {},
        {...valid, 'all': 120.0},
        {...valid, 'warning': -1},
        {...valid, 'warning': 111},
        {...valid, 'voided': 11},
      ]) {
        expect(
          () => WaterLogCounts.parse(raw),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  for (final scope in ['me', 'expert', 'owner']) {
    test(
      '$scope sends server filter/counts and preserves legacy latest request',
      () async {
        final requests = <RequestOptions>[];
        final api = _api(scope, (request) {
          requests.add(request);
          return {
            'totalResults': 30,
            'hasNextPage': false,
            if (request.queryParameters['includeCounts'] == true)
              'counts': _counts.toJson(),
          };
        });
        final from = DateTime(2026, 1, 1, 8);
        await api.getWaterLogs(
          'season',
          filter: WaterLogFilter.warning,
          includeCounts: true,
          from: from,
        );
        await api.getWaterLogs(
          'season',
          filter: WaterLogFilter.warning,
          cursor: 'next',
        );
        await api.getWaterLogs('season', limit: 1);
        expect(requests.first.method, 'GET');
        expect(requests.first.path, '/$scope/seasons/season/water-logs');
        expect(requests.first.headers['Authorization'], 'Bearer access');
        expect(requests.first.queryParameters, {
          'filter': 'warning',
          'includeCounts': true,
          'limit': 20,
          'from': from.toUtc().toIso8601String(),
        });
        expect(requests[1].queryParameters, {
          'filter': 'warning',
          'limit': 20,
          'cursor': 'next',
        });
        expect(requests.last.queryParameters, {
          'includeVoided': false,
          'limit': 1,
        });
      },
    );
  }
  test(
    'requested counts never silently fall back to items on old/malformed BE',
    () async {
      for (final counts in [
        null,
        {},
        {'all': 1, 'valid': 1, 'warning': 2, 'voided': 0},
      ]) {
        final api = _api(
          'me',
          (_) => {'totalResults': 0, 'hasNextPage': false, 'counts': ?counts},
        );
        await expectLater(
          api.getWaterLogs(
            'season',
            includeCounts: true,
            filter: WaterLogFilter.all,
          ),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  test('invalid/missing/nonprogressing next cursor is rejected', () async {
    for (final cursor in [null, '', ' ', 42, 'used']) {
      final api = _api(
        'me',
        (_) => {'totalResults': 2, 'hasNextPage': true, 'nextCursor': cursor},
      );
      await expectLater(
        api.getWaterLogs('season', cursor: 'used'),
        throwsA(isA<InvalidResponseException>()),
      );
    }
  });
  test(
    'one first page; single-flight pagination retries the same cursor and retains items/counts',
    () async {
      final deferred = Completer<WaterLogPage>();
      final repository = _Repository(
        (query) => query.cursor == null
            ? Future.value(_page('first', more: true, cursor: 'next'))
            : deferred.future,
      );
      final container = _container(repository);
      final controller = container.read(
        waterLogListProvider('season').notifier,
      );
      await container.read(waterLogListProvider('season').future);
      expect(repository.queries, hasLength(1));
      final pending = controller.loadMore();
      await controller.loadMore();
      expect(repository.queries, hasLength(2));
      expect(
        container.read(waterLogListProvider('season')).requireValue.loadingMore,
        isTrue,
      );
      deferred.completeError(const ApiException('offline', statusCode: 500));
      await pending;
      final failed = container
          .read(waterLogListProvider('season'))
          .requireValue;
      expect(failed.page.items.single.id, 'first');
      expect(failed.paginationError, isA<ApiException>());
      repository.respond = (_) async => _page('older', counts: null);
      await controller.loadMore();
      final result = container
          .read(waterLogListProvider('season'))
          .requireValue;
      expect(repository.queries.map((q) => q.cursor), [null, 'next', 'next']);
      expect(repository.queries.map((q) => q.counts), [true, false, false]);
      expect(result.page.counts, _counts);
      expect(result.paginationError, isNull);
    },
  );
  test(
    'switching filter/date discards old pending pagination and refresh keeps the selected query',
    () async {
      final oldPage = Completer<WaterLogPage>();
      final repository = _Repository(
        (query) => query.cursor != null
            ? oldPage.future
            : Future.value(
                _page(
                  query.filter!.name,
                  more: query.filter == WaterLogFilter.all,
                  cursor: 'old',
                ),
              ),
      );
      final container = _container(repository);
      final provider = waterLogListProvider('season');
      await container.read(provider.future);
      final controller = container.read(provider.notifier);
      final old = controller.loadMore();
      final from = DateTime(2026, 1, 1);
      await controller.setQuery(filter: WaterLogFilter.warning, from: from);
      oldPage.complete(_page('stale'));
      await old;
      expect(
        container.read(provider).requireValue.page.items.single.id,
        'warning',
      );
      await controller.refresh();
      expect(repository.queries.last, (
        filter: WaterLogFilter.warning,
        counts: true,
        cursor: null,
        from: from,
        to: null,
      ));
      expect(container.read(provider).requireValue.loadingMore, isFalse);
    },
  );
  test(
    'changing query during initial build cannot publish the old response',
    () async {
      final initial = Completer<WaterLogPage>();
      final repository = _Repository(
        (query) => query.filter == WaterLogFilter.all
            ? initial.future
            : Future.value(_page('warning')),
      );
      final container = _container(repository);
      final controller = container.read(
        waterLogListProvider('season').notifier,
      );
      await controller.setQuery(filter: WaterLogFilter.warning);
      initial.complete(_page('stale'));
      await container.pump();
      expect(
        container
            .read(waterLogListProvider('season'))
            .requireValue
            .page
            .items
            .single
            .id,
        'warning',
      );
    },
  );
  test('late first-page response from tab A cannot replace tab B', () async {
    final warning = Completer<WaterLogPage>();
    final repository = _Repository(
      (query) => query.filter == WaterLogFilter.warning
          ? warning.future
          : Future.value(_page(query.filter!.name)),
    );
    final container = _container(repository);
    final provider = waterLogListProvider('season');
    await container.read(provider.future);
    final controller = container.read(provider.notifier);
    final old = controller.setQuery(filter: WaterLogFilter.warning);
    await container.pump();
    expect(container.read(provider).isLoading, isTrue);
    await controller.setQuery(filter: WaterLogFilter.voided);
    warning.complete(_page('stale-warning'));
    await old;
    await container.pump();
    expect(
      container.read(provider).requireValue.page.items.single.id,
      'voided',
    );
  });
  test(
    'malformed next cursor is shown in footer without losing the page',
    () async {
      final repository = _Repository(
        (query) async => _page('first', more: true, cursor: 'next'),
      );
      final container = _container(repository);
      final provider = waterLogListProvider('season');
      await container.read(provider.future);
      await container.read(provider.notifier).loadMore();
      expect(
        container.read(provider).requireValue.paginationError,
        isA<InvalidResponseException>(),
      );
      expect(
        container.read(provider).requireValue.page.items.single.id,
        'first',
      );
    },
  );
  test('dispose while loading a page ignores its late completion', () async {
    final older = Completer<WaterLogPage>();
    final repository = _Repository(
      (query) => query.cursor == null
          ? Future.value(_page('first', more: true, cursor: 'next'))
          : older.future,
    );
    final container = ProviderContainer(
      overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(waterLogListProvider('season'), (_, _) {});
    await container.read(waterLogListProvider('season').future);
    final pending = container
        .read(waterLogListProvider('season').notifier)
        .loadMore();
    container.dispose();
    older.complete(_page('late'));
    await pending;
  });
}

ProviderContainer _container(_Repository repository) {
  final container = ProviderContainer(
    overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  container.listen(waterLogListProvider('season'), (_, _) {});
  return container;
}

class _Repository implements WaterLogRepository {
  _Repository(this.respond);
  Future<WaterLogPage> Function(_Query) respond;
  final queries = <_Query>[];
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
  }) {
    final query = (
      filter: filter,
      counts: includeCounts,
      cursor: cursor,
      from: from,
      to: to,
    );
    queries.add(query);
    return respond(query);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

WaterLogApiService _api(
  String scope,
  Map<String, dynamic> Function(RequestOptions) meta,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        handler.resolve(
          Response(
            requestOptions: request,
            statusCode: 200,
            data: {
              'success': true,
              'message': 'OK',
              'data': [],
              'meta': meta(request),
            },
          ),
        );
      },
    ),
  );
  return WaterLogApiService(ApiClient(dio, _Session()), '/$scope/seasons');
}

class _Session implements SessionStore {
  @override
  Future<void> initialize() async {}
  @override
  String? get accessToken => 'access';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
