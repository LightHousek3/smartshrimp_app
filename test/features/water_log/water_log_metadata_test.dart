import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_refresh_boundary.dart';

Map<String, dynamic> _fixture([String species = 'WHITELEG']) =>
    (jsonDecode(File('test/fixtures/water-metadata.json').readAsStringSync())
            as Map<String, dynamic>)[species]
        as Map<String, dynamic>;

void main() {
  for (final species in ['WHITELEG', 'BLACK_TIGER']) {
    test('parses BE fixture and inclusive boundaries for $species', () {
      final metadata = WaterLogMetadata.parse(_fixture(species));
      expect(metadata.metrics, hasLength(8));
      for (final metric in metadata.metrics) {
        if (metric.warningMin != null) {
          expect(
            metadata.warnings({metric.field: metric.warningMin!}),
            isEmpty,
          );
          expect(
            metadata.warnings({metric.field: metric.warningMin! - .001}),
            hasLength(1),
          );
        }
        if (metric.warningMax != null) {
          expect(
            metadata.warnings({metric.field: metric.warningMax!}),
            isEmpty,
          );
          expect(
            metadata.warnings({metric.field: metric.warningMax! + .001}),
            hasLength(1),
          );
        }
      }
      expect(metadata.warnings({}), isEmpty);
      final legacy = WaterLogMetadata.legacy(shrimpTypeFromJson(species));
      for (final metric in metadata.metrics) {
        final pinned = legacy.metrics.firstWhere(
          (item) => item.field == metric.field,
        );
        expect(pinned.warningMin, metric.warningMin);
        expect(pinned.warningMax, metric.warningMax);
        expect(pinned.inputMin, metric.inputMin);
        expect(pinned.inputMax, metric.inputMax);
        expect(pinned.scale, metric.scale);
      }
    });
  }
  test(
    'rejects unknown schema/species, missing/duplicate metrics and malformed bounds',
    () {
      final invalid = <Map<String, dynamic>>[
        {..._fixture(), 'schemaVersion': 2},
        {..._fixture(), 'schemaVersion': 1.5},
        {..._fixture(), 'shrimpType': 'UNKNOWN'},
        {..._fixture(), 'metrics': []},
        {..._fixture(), 'policyVersion': ''},
        {..._fixture(), 'noteMaxLength': 0},
        {..._fixture(), 'recordedAtFutureToleranceSeconds': -1},
      ];
      for (final field in [
        'field',
        'unit',
        'inputMax',
        'warningMin',
        'warningMax',
      ]) {
        final json = _fixture();
        (json['metrics'][0] as Map).remove(field);
        invalid.add(json);
      }
      final duplicate = _fixture();
      duplicate['metrics'][1] = duplicate['metrics'][0];
      invalid.add(duplicate);
      for (final json in invalid) {
        expect(
          () => WaterLogMetadata.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  test(
    'canonical decimal rounding matches DB scale at ties and exponent values',
    () {
      final metadata = WaterLogMetadata.parse(_fixture());
      final ph = metadata.metrics.firstWhere((metric) => metric.field == 'ph');
      final nh3 = metadata.metrics.firstWhere(
        (metric) => metric.field == 'nh3MgL',
      );
      expect(ph.canonicalValue(8.504), 8.5);
      expect(ph.canonicalValue(8.505), 8.51);
      expect(ph.canonicalValue(1.005), 1.01);
      expect(ph.canonicalValue(-1.005), -1.01);
      expect(nh3.canonicalValue(0.100004), .1);
      expect(nh3.canonicalValue(0.100005), .10001);
      expect(nh3.canonicalValue(1e-7), 0);
      expect(nh3.canonicalValue(1e4), 10000);
      expect(metadata.warnings({'ph': ph.canonicalValue(8.504)}), isEmpty);
    },
  );
  for (final path in ['/me/seasons', '/expert/seasons', '/owner/seasons']) {
    test('metadata uses authenticated GET and envelope for $path', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            expect(request.method, 'GET');
            expect(request.path, '$path/season/water-logs/metadata');
            expect(request.headers['Authorization'], 'Bearer access');
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {'success': true, 'message': 'OK', 'data': _fixture()},
              ),
            );
          },
        ),
      );
      expect(
        (await WaterLogApiService(
          ApiClient(dio, _Session()),
          path,
        ).getMetadata('season')).policyVersion,
        'water-v1',
      );
    });
  }
  test('server warning policy overrides the pinned App policy', () async {
    final json = _fixture();
    json['metrics'][0]['warningMax'] = 28;
    final repository = _Repository()..metadata = WaterLogMetadata.parse(json);
    final container = ProviderContainer(
      overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(waterLogListProvider('season'), (_, _) {});
    addTearDown(sub.close);
    await container.read(waterLogListProvider('season').future);
    final metadata = await container
        .read(waterLogListProvider('season').notifier)
        .loadMetadata();
    expect(metadata.warnings({'temperatureC': 29}), hasLength(1));
    expect(repository.metadataReads, 1);
  });
  for (final status in [400, 401, 403, 404, 429, 500]) {
    test(
      'metadata $status propagates without a legacy fallback or additional list read',
      () async {
        final repository = _Repository()
          ..error = ApiException('failed', statusCode: status);
        final container = ProviderContainer(
          overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        final sub = container.listen(waterLogListProvider('season'), (_, _) {});
        addTearDown(sub.close);
        await container.read(waterLogListProvider('season').future);
        final before = repository.listReads;
        final future = container
            .read(waterLogListProvider('season').notifier)
            .loadMetadata();
        await expectLater(future, throwsA(isA<ApiException>()));
        expect(repository.listReads, before);
      },
    );
  }
  test(
    '404 with inaccessible season does not fall back, nor do network/bad responses',
    () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final sub = container.listen(waterLogListProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await container.read(waterLogListProvider('season').future);
      final controller = container.read(
        waterLogListProvider('season').notifier,
      );
      repository.error = const ApiException('missing route', statusCode: 404);
      repository.readError = const ApiException(
        'missing season',
        statusCode: 404,
      );
      await expectLater(
        controller.loadMetadata(),
        throwsA(isA<ApiException>()),
      );
      repository.readError = null;
      for (final error in [
        const NetworkException(),
        const InvalidResponseException(),
      ]) {
        repository.error = error;
        final reads = repository.listReads;
        await expectLater(
          controller.loadMetadata(),
          throwsA(isA<AppException>()),
        );
        expect(repository.listReads, reads);
      }
    },
  );
  for (final action in ['create', 'void']) {
    test('$action refreshes statistics for the affected season only', () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      const query = (seasonId: 'season', days: 30, granularity: 'day');
      const other = (seasonId: 'other', days: 30, granularity: 'day');
      final listSub = container.listen(
        waterLogListProvider('season'),
        (_, _) {},
      );
      final statsSub = container.listen(
        waterLogStatisticsProvider(query),
        (_, _) {},
      );
      final otherSub = container.listen(
        waterLogStatisticsProvider(other),
        (_, _) {},
      );
      addTearDown(() {
        listSub.close();
        statsSub.close();
        otherSub.close();
      });
      await container.read(waterLogListProvider('season').future);
      await container.read(waterLogStatisticsProvider(query).future);
      await container.read(waterLogStatisticsProvider(other).future);
      final controller = container.read(
        waterLogListProvider('season').notifier,
      );
      if (action == 'create') {
        await controller.createWaterLog(
          payload: {'ph': 8},
          idempotencyKey: 'key',
        );
      } else {
        await controller.voidWaterLog(logId: 'log', voidReason: 'wrong');
      }
      await container.read(waterLogStatisticsProvider(query).future);
      expect(repository.statsReads['season'], 2);
      expect(repository.statsReads['other'], 1);
    });
  }
  testWidgets('resume coalesces refresh and stops after disposal', (
    tester,
  ) async {
    var calls = 0;
    final pending = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WaterLogRefreshBoundary(
            onRefresh: () {
              calls++;
              return pending.future;
            },
            child: const Text('water'),
          ),
        ),
      ),
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(calls, 1);
    pending.complete();
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(calls, 1);
  });
}

class _Repository implements WaterLogRepository {
  WaterLogMetadata metadata = WaterLogMetadata.parse(_fixture());
  AppException? error;
  AppException? readError;
  int metadataReads = 0;
  int listReads = 0;
  final statsReads = <String, int>{};
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async {
    metadataReads++;
    if (error != null) throw error!;
    return metadata;
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
    listReads++;
    if (readError != null) throw readError!;
    return const WaterLogPage(items: [], totalResults: 0, hasNextPage: false);
  }

  @override
  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) async {
    statsReads.update(seasonId, (count) => count + 1, ifAbsent: () => 1);
    return WaterLogStatistics.parse({
      'seasonId': seasonId,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'granularity': granularity,
      'summary': {
        'totalRecords': 0,
        'validRecords': 0,
        'voidedRecords': 0,
        'parameters': <String, dynamic>{},
      },
      'series': [],
    });
  }

  WaterLog _log(String seasonId) => WaterLog(
    id: 'log',
    seasonId: seasonId,
    recordedAt: DateTime.now(),
    createdAt: DateTime.now(),
    isVoided: false,
    exceededParameters: [],
  );
  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) async => _log(seasonId);
  @override
  Future<WaterLog> voidWaterLog({
    required String seasonId,
    required String logId,
    required String voidReason,
  }) async => _log(seasonId);
}

class _Session implements SessionStore {
  @override
  String? get accessToken => 'access';
  @override
  Future<void> initialize() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
