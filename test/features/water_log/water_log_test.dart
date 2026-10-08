import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/water_log/data/services/water_log_api_service.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_form_sheet.dart';

Map<String, dynamic> _logJson() => {
  'id': 'log',
  'seasonId': 'season',
  'recordedAt': '2026-01-01T01:00:00Z',
  'createdAt': '2026-01-01T01:00:00Z',
  'isVoided': false,
  'ph': 8,
};

void main() {
  test('parses the code-free log and the statistics API contract', () {
    expect(WaterLog.parse(_logJson()).ph, 8);
    final stats = WaterLogStatistics.parse({
      'seasonId': 'season',
      'from': '2026-01-01T00:00:00Z',
      'to': '2026-01-02T00:00:00Z',
      'granularity': 'day',
      'summary': {
        'totalRecords': 2,
        'validRecords': 2,
        'voidedRecords': 0,
        'parameters': {
          'ph': {
            'count': 2,
            'min': 8,
            'max': 9,
            'avg': 8.5,
            'exceedanceRate': 0.5,
          },
        },
      },
      'series': [
        {
          'bucket': '2026-01-01',
          'ph': {'count': 2, 'min': 8, 'max': 9, 'avg': 8.5},
        },
      ],
    });
    expect(stats.series.single.values['ph']!.count, 2);
    expect(stats.series.single.values['ph']!.avg, 8.5);
  });

  test('list and statistics serialize local dates as UTC instants', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final isStatistics = request.path.endsWith('/statistics');
          handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'OK',
                'data': isStatistics
                    ? {
                        'seasonId': 'season',
                        'from': request.queryParameters['from'],
                        'to': request.queryParameters['to'],
                        'granularity': 'day',
                        'summary': {
                          'totalRecords': 0,
                          'validRecords': 0,
                          'voidedRecords': 0,
                          'parameters': <String, dynamic>{},
                        },
                        'series': [],
                      }
                    : [],
                'meta': {'totalResults': 0, 'hasNextPage': false},
              },
            ),
          );
        },
      ),
    );
    final api = WaterLogApiService(ApiClient(dio, _Session()), '/me/seasons');
    final from = DateTime(2026, 1, 1, 8);
    final to = DateTime(2026, 1, 2, 8);
    await api.getWaterLogs('season', from: from, to: to, limit: 1);
    await api.getStatistics('season', from: from, to: to, granularity: 'day');
    for (final request in requests) {
      expect(request.queryParameters['from'], from.toUtc().toIso8601String());
      expect(request.queryParameters['to'], to.toUtc().toIso8601String());
      expect((request.queryParameters['from'] as String).endsWith('Z'), isTrue);
    }
  });

  test(
    'successful create and void stay successful when refreshing fails',
    () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final provider = waterLogListProvider('season');
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(provider.future);
      repository.failReads = true;
      final controller = container.read(provider.notifier);
      final created = await controller.createWaterLog(
        payload: {'ph': 8},
        idempotencyKey: 'key',
      );
      expect(created.id, 'log');
      await controller.voidWaterLog(logId: 'log', voidReason: 'wrong sample');
      expect(repository.voidCalls, 1);
    },
  );

  testWidgets(
    'form preserves retry key, sends UTC, and changes key after editing',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = _Repository()..failCreates = true;
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        waterLogListProvider('season'),
        (_, _) {},
      );
      addTearDown(subscription.close);
      await container.read(waterLogListProvider('season').future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showWaterLogFormSheet(
                    context: context,
                    seasonId: 'season',
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '28');
      for (var i = 0; i < 2; i++) {
        await tester.ensureVisible(find.text('Lưu nhật ký'));
        await tester.tap(find.text('Lưu nhật ký'));
        await tester.pumpAndSettle();
      }
      expect(repository.keys, hasLength(2));
      expect(repository.keys[0], repository.keys[1]);
      expect(
        (repository.payloads.first['recordedAt'] as String).endsWith('Z'),
        isTrue,
      );
      await tester.enterText(find.byType(TextField).first, '29');
      await tester.ensureVisible(find.text('Lưu nhật ký'));
      await tester.tap(find.text('Lưu nhật ký'));
      await tester.pumpAndSettle();
      expect(repository.keys.last, isNot(repository.keys.first));
    },
  );
}

final class _Repository implements WaterLogRepository {
  bool failReads = false;
  bool failCreates = false;
  int voidCalls = 0;
  final keys = <String>[];
  final payloads = <Map<String, Object?>>[];

  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    int limit = 20,
    String? cursor,
  }) async {
    if (failReads) throw StateError('network unavailable');
    return const WaterLogPage(items: [], totalResults: 0, hasNextPage: false);
  }

  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) async {
    keys.add(idempotencyKey);
    payloads.add(payload);
    if (failCreates) throw StateError('request timed out');
    return WaterLog.parse(_logJson());
  }

  @override
  Future<WaterLog> voidWaterLog({
    required String seasonId,
    required String logId,
    required String voidReason,
  }) async {
    voidCalls++;
    return WaterLog.parse(_logJson());
  }

  @override
  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) => throw UnimplementedError();
}

final class _Session implements SessionStore {
  @override
  String? accessToken = 'access';
  @override
  String? refreshToken = 'refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}
