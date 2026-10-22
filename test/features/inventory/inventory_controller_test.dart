import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';

import 'inventory_test_data.dart';

void main() {
  late _InventoryRepository repository;
  late ProviderContainer container;

  setUp(() async {
    repository = _InventoryRepository();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(const _AuthRepository()),
        inventoryRepositoryProvider.overrideWithValue(repository),
      ],
    );
    await container.read(authControllerProvider.future);
  });
  tearDown(() => container.dispose());

  test('retains all combined history filters across cursor pages', () async {
    final filters = InventoryHistoryFilters(
      search: 'mã lô',
      productId: 'product-1',
      seasonId: 'season-1',
      transactionType: InventoryTransactionType.stockOut,
      fromDate: DateTime(2026, 10, 1),
      toDate: DateTime(2026, 10, 2),
    );
    final firstItem = inventoryTestTransaction.copyWith(
      transactionType: InventoryTransactionType.stockOut,
    );
    final secondItem = firstItem.copyWith(id: 'transaction-2');
    repository.historyPages[null] = inventoryTestHistoryPage.copyWith(
      items: [firstItem],
      totalResults: 42,
      hasNextPage: true,
      nextCursor: firstItem.id,
      summary: const InventoryHistorySummary(
        totalInboundValue: 0,
        totalOutboundValue: 5600000,
      ),
    );
    repository.historyPages[firstItem.id] = inventoryTestHistoryPage.copyWith(
      items: [secondItem],
      totalResults: 42,
      summary: const InventoryHistorySummary(
        totalInboundValue: 0,
        totalOutboundValue: 5600000,
      ),
    );
    final provider = filteredInventoryHistoryControllerProvider((
      farmId: 'farm-1',
      filters: filters,
    ));
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    final first = await container.read(provider.future);
    expect(first.items, [firstItem]);
    expect(first.totalResults, 42);
    expect(repository.historyRequests, hasLength(1));
    await container.read(provider.notifier).loadMore();
    final result = container.read(provider).requireValue;
    expect(result.items, [firstItem, secondItem]);
    expect(result.totalResults, 42);
    expect(result.summary.totalOutboundValue, 5600000);
    expect(repository.historyRequests, hasLength(2));
    for (final request in repository.historyRequests) {
      expect(request['limit'], 10);
      expect(request['search'], 'mã lô');
      expect(request['productId'], 'product-1');
      expect(request['seasonId'], 'season-1');
      expect(request['transactionType'], InventoryTransactionType.stockOut);
      expect(request['createdFrom'], DateTime(2026, 10, 1));
      expect(request['createdTo'], DateTime(2026, 10, 2, 23, 59, 59, 999));
    }
    expect(repository.historyRequests.map((request) => request['cursor']), [
      null,
      firstItem.id,
    ]);
  });

  test('rejects an inverted history range without making a request', () async {
    final provider = filteredInventoryHistoryControllerProvider((
      farmId: 'farm-1',
      filters: InventoryHistoryFilters(
        fromDate: DateTime(2026, 10, 3),
        toDate: DateTime(2026, 10, 2),
      ),
    ));
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    await expectLater(
      container.read(provider.future),
      throwsA(isA<ApiException>()),
    );
    expect(repository.historyCalls, 0);
  });

  test(
    'loads ten products initially and fetches the next page on demand',
    () async {
      repository.pages[1] = inventoryTestProductPage(hasNextPage: true);
      repository.pages[2] = inventoryTestProductPage(
        page: 2,
        items: <InventoryProduct>[
          inventoryTestProduct.copyWith(id: 'product-2', status: 'INACTIVE'),
        ],
      );
      final subscription = container.listen(
        inventoryListControllerProvider('farm-1'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final result = await container.read(
        inventoryListControllerProvider('farm-1').future,
      );
      expect(repository.requestedPages, <int>[1]);
      expect(repository.productRequests.single['limit'], 10);
      expect(result.items, hasLength(1));
      expect(result.hasNextPage, isTrue);
      await container
          .read(inventoryListControllerProvider('farm-1').notifier)
          .loadMore();
      final loaded = container
          .read(inventoryListControllerProvider('farm-1'))
          .requireValue;
      expect(repository.requestedPages, <int>[1, 2]);
      expect(
        repository.archiveStatuses,
        everyElement(InventoryArchiveStatus.all),
      );
      expect(loaded.items, hasLength(2));
      expect(loaded.items.last.isArchived, isTrue);
      expect(loaded.hasNextPage, isFalse);
    },
  );

  test(
    'catalog sends combined search and filters to the API on every page',
    () async {
      final provider = filteredInventoryListControllerProvider((
        farmId: 'farm-1',
        search: 'thuốc',
        category: InventoryProductCategory.medicine,
        lowStockOnly: true,
        archiveStatus: InventoryArchiveStatus.active,
      ));
      repository.pages[1] = inventoryTestProductPage(hasNextPage: true);
      repository.pages[2] = inventoryTestProductPage(page: 2);
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(provider.future);
      await container.read(provider.notifier).loadMore();
      expect(repository.productRequests, hasLength(2));
      for (final request in repository.productRequests) {
        expect(request['limit'], 10);
        expect(request['search'], 'thuốc');
        expect(request['category'], InventoryProductCategory.medicine);
        expect(request['lowStockOnly'], true);
        expect(request['archiveStatus'], InventoryArchiveStatus.active);
      }
    },
  );

  test(
    'rejects a repeating history cursor instead of looping forever',
    () async {
      repository.history = inventoryTestHistoryPage.copyWith(
        hasNextPage: true,
        nextCursor: 'repeated-cursor',
      );
      final subscription = container.listen(
        inventoryHistoryControllerProvider('farm-1'),
        (_, _) {},
      );
      addTearDown(subscription.close);
      await container.read(inventoryHistoryControllerProvider('farm-1').future);
      await expectLater(
        container
            .read(inventoryHistoryControllerProvider('farm-1').notifier)
            .loadMore(),
        throwsA(isA<InvalidResponseException>()),
      );
      expect(repository.historyCalls, 2);
      expect(
        container
            .read(inventoryHistoryControllerProvider('farm-1'))
            .requireValue
            .items,
        inventoryTestHistoryPage.items,
      );
    },
  );

  test(
    'duplicate load-more calls issue one request and a refresh discards its late page',
    () async {
      final provider = inventoryHistoryControllerProvider('farm-1');
      repository.history = inventoryTestHistoryPage.copyWith(
        hasNextPage: true,
        nextCursor: 'page-two',
      );
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(provider.future);
      repository.historyPending = Completer<InventoryHistoryPage>();
      final notifier = container.read(provider.notifier);
      final pending = notifier.loadMore();
      await notifier.loadMore();
      expect(repository.historyCalls, 2);
      final fresh = inventoryTestHistoryPage.copyWith(
        items: [inventoryTestTransaction.copyWith(id: 'refreshed')],
      );
      repository.history = fresh;
      await notifier.refresh();
      repository.historyPending!.complete(
        inventoryTestHistoryPage.copyWith(
          items: [inventoryTestTransaction.copyWith(id: 'stale')],
        ),
      );
      await pending;
      expect(
        container.read(provider).requireValue.items.single.id,
        'refreshed',
      );
      expect(repository.historyCalls, 3);
    },
  );

  test(
    'archive succeeds on the first interaction and refreshes detail',
    () async {
      const key = (farmId: 'farm-1', productId: 'product-1');
      final subscription = container.listen(
        inventoryDetailControllerProvider(key),
        (_, _) {},
      );
      addTearDown(subscription.close);
      await container.read(inventoryDetailControllerProvider(key).future);

      await container
          .read(inventoryMutationControllerProvider('farm-1').notifier)
          .archive('product-1');
      final detail = await container.read(
        inventoryDetailControllerProvider(key).future,
      );

      expect(repository.archiveCalls, 1);
      expect(detail.isArchived, isTrue);
    },
  );

  test('prevents a second adjustment while the first one is pending', () async {
    final subscription = container.listen(
      inventoryMutationControllerProvider('farm-1'),
      (_, _) {},
    );
    addTearDown(subscription.close);
    repository.pending = Completer<InventoryStockResult>();
    final notifier = container.read(
      inventoryMutationControllerProvider('farm-1').notifier,
    );
    final first = notifier.adjust(
      productId: 'product-1',
      inventoryBalanceId: 'lot-1',
      increase: false,
      quantity: 5,
      reason: 'Stock count',
    );
    await expectLater(
      notifier.adjust(
        productId: 'product-1',
        inventoryBalanceId: 'lot-1',
        increase: false,
        quantity: 5,
        reason: 'Stock count',
      ),
      throwsA(isA<ApiException>()),
    );
    repository.pending!.complete(inventoryTestStockResult);
    await first;
    expect(repository.adjustmentCalls, 1);
  });

  test(
    'finishes an in-flight mutation safely after the provider is disposed',
    () async {
      final subscription = container.listen(
        inventoryMutationControllerProvider('farm-1'),
        (_, _) {},
      );
      repository.pending = Completer<InventoryStockResult>();
      final operation = container
          .read(inventoryMutationControllerProvider('farm-1').notifier)
          .adjust(
            productId: 'product-1',
            inventoryBalanceId: 'lot-1',
            increase: true,
            quantity: 5,
            reason: 'Stock count',
          );
      subscription.close();
      await container.pump();
      repository.pending!.complete(inventoryTestStockResult);
      expect(await operation, inventoryTestStockResult);
    },
  );
}

final class _AuthRepository implements AuthRepository {
  const _AuthRepository();

  static const account = AuthAccount(
    id: 'owner-1',
    email: 'owner@smartshrimp.vn',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );

  @override
  Future<AuthAccount?> restoreSession() async => account;

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => account;

  @override
  Future<void> logout() async {}
}

final class _InventoryRepository implements InventoryRepository {
  final pages = <int, InventoryProductPage>{1: inventoryTestProductPage()};
  final requestedPages = <int>[];
  final productRequests = <Map<String, Object?>>[];
  final archiveStatuses = <InventoryArchiveStatus>[];
  InventoryProduct product = inventoryTestProduct;
  InventoryHistoryPage history = inventoryTestHistoryPage;
  Completer<InventoryStockResult>? pending;
  Completer<InventoryHistoryPage>? historyPending;
  int historyCalls = 0;
  int archiveCalls = 0;
  int adjustmentCalls = 0;
  final historyPages = <String?, InventoryHistoryPage>{};
  final historyRequests = <Map<String, Object?>>[];

  @override
  Future<InventoryProductPage> getProducts({
    required String farmId,
    int page = 1,
    int limit = 100,
    String? search,
    InventoryProductCategory? category,
    bool lowStockOnly = false,
    InventoryArchiveStatus archiveStatus = InventoryArchiveStatus.active,
  }) async {
    requestedPages.add(page);
    productRequests.add({
      'page': page,
      'limit': limit,
      'search': search,
      'category': category,
      'lowStockOnly': lowStockOnly,
      'archiveStatus': archiveStatus,
    });
    archiveStatuses.add(archiveStatus);
    return pages[page]!;
  }

  @override
  Future<InventoryProduct> getProduct({
    required String farmId,
    required String productId,
  }) async => product;

  @override
  Future<InventoryHistoryPage> getHistory({
    required String farmId,
    String? search,
    String? cursor,
    int limit = 100,
    String? productId,
    InventoryTransactionType? transactionType,
    String? seasonId,
    DateTime? createdFrom,
    DateTime? createdTo,
  }) async {
    historyCalls++;
    historyRequests.add(<String, Object?>{
      'limit': limit,
      'search': search,
      'cursor': cursor,
      'productId': productId,
      'transactionType': transactionType,
      'seasonId': seasonId,
      'createdFrom': createdFrom,
      'createdTo': createdTo,
    });
    if (cursor != null && historyPending != null) return historyPending!.future;
    return historyPages[cursor] ?? history;
  }

  @override
  Future<InventoryProduct> archiveProduct({
    required String farmId,
    required String productId,
  }) async {
    archiveCalls++;
    product = product.copyWith(status: 'INACTIVE');
    return product;
  }

  @override
  Future<InventoryStockResult> recordAdjustment({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required bool increase,
    required double quantity,
    String? quantityExact,
    required String reason,
  }) {
    adjustmentCalls++;
    return pending?.future ?? Future.value(inventoryTestStockResult);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
