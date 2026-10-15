import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';

WaterLog _log(String id) => WaterLog(
  id: id,
  seasonId: 'season',
  recordedAt: DateTime(2026),
  createdAt: DateTime(2026),
  isVoided: false,
  exceededParameters: [],
);

WaterLogPage _page(String id, {bool more = false}) => WaterLogPage(
  items: [_log(id)],
  totalResults: more ? 2 : 1,
  hasNextPage: more,
  nextCursor: more ? id : null,
);

void main() {
  test(
    'repository change discards old refresh and unlocks pagination for the new session',
    () async {
      final oldRepository = _Repository()..deferRefresh = true;
      final newRepository = _Repository()..initialId = 'new-account';
      final container = ProviderContainer(
        overrides: [
          waterLogRepositoryProvider.overrideWithValue(oldRepository),
        ],
      );
      addTearDown(container.dispose);
      final provider = waterLogListProvider('season');
      container.listen(provider, (_, _) {});
      await container.read(provider.future);
      final oldRefresh = container.read(provider.notifier).refresh();
      container.updateOverrides([
        waterLogRepositoryProvider.overrideWithValue(newRepository),
      ]);
      await container.pump();
      await container.read(provider.future);
      oldRepository.refreshes.single.complete(_page('old-account-response'));
      await oldRefresh;
      expect(
        container.read(provider).requireValue.page.items.single.id,
        'new-account',
      );
      newRepository.older.complete(_page('new-account-page-2'));
      await container.read(provider.notifier).loadMore();
      expect(
        container.read(provider).requireValue.page.items.map((log) => log.id),
        ['new-account', 'new-account-page-2'],
      );
    },
  );
  for (final action in ['refresh', 'create', 'void']) {
    test('late pagination cannot overwrite $action results', () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final provider = waterLogListProvider('season');
      container.listen(provider, (_, _) {});
      await container.read(provider.future);
      final controller = container.read(provider.notifier);
      final pending = controller.loadMore();
      switch (action) {
        case 'refresh':
          await controller.refresh();
        case 'create':
          await controller.createWaterLog(
            payload: {'ph': 8},
            idempotencyKey: 'key',
          );
        case 'void':
          await controller.voidWaterLog(logId: 'old', voidReason: 'incorrect');
      }
      repository.older.complete(_page('older'));
      await pending;
      expect(
        container.read(provider).requireValue.page.items.map((log) => log.id),
        ['fresh'],
      );
    });
  }

  test('later refresh wins when responses arrive out of order', () async {
    final repository = _Repository()..deferRefresh = true;
    final container = ProviderContainer(
      overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final provider = waterLogListProvider('season');
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    final controller = container.read(provider.notifier);
    final first = controller.refresh();
    final second = controller.refresh();
    repository.refreshes[1].complete(_page('newest'));
    await second;
    repository.refreshes[0].complete(_page('stale'));
    await first;
    expect(
      container.read(provider).requireValue.page.items.single.id,
      'newest',
    );
  });
}

class _Repository implements WaterLogRepository {
  String initialId = 'old';
  final older = Completer<WaterLogPage>();
  final refreshes = <Completer<WaterLogPage>>[];
  bool deferRefresh = false;
  int calls = 0;

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
    if (cursor != null) return older.future;
    if (calls++ == 0) return _page(initialId, more: true);
    if (deferRefresh) {
      final pending = Completer<WaterLogPage>();
      refreshes.add(pending);
      return pending.future;
    }
    return _page('fresh');
  }

  @override
  Future<WaterLog> createWaterLog({
    required String seasonId,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) async => _log('fresh');

  @override
  Future<WaterLog> voidWaterLog({
    required String seasonId,
    required String logId,
    required String voidReason,
  }) async => _log(logId);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
