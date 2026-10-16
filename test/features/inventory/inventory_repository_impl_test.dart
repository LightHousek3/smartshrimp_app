import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

import 'inventory_test_data.dart';

void main() {
  late _InventoryRemote remote;
  late InventoryRepositoryImpl repository;

  setUp(() {
    remote = _InventoryRemote();
    repository = InventoryRepositoryImpl(remote);
  });

  Future<InventoryStockResult> adjust() => repository.recordAdjustment(
    farmId: 'farm-1',
    productId: 'product-1',
    inventoryBalanceId: 'lot-1',
    increase: false,
    quantity: 6.5,
    reason: '  Kiểm kê   thực tế ',
  );

  test(
    'manual stock-out uses its own ledger type and retries with the same key',
    () async {
      Future<InventoryStockResult> stockOut() => repository.recordStockOut(
        farmId: 'farm-1',
        productId: 'product-1',
        inventoryBalanceId: 'lot-1',
        quantity: 10,
        reason: '  Xuất sử dụng  ',
      );
      remote.error = const NetworkException();
      await expectLater(stockOut(), throwsA(isA<NetworkException>()));
      remote.error = null;
      await stockOut();
      expect(remote.keys[0], remote.keys[1]);
      expect(remote.lastData, {
        'transactionType': 'STOCK_OUT',
        'inventoryBalanceId': 'lot-1',
        'quantity': 10.0,
        'reason': 'Xuất sử dụng',
      });
    },
  );

  test(
    'sends combined history filters and converts local bounds to UTC',
    () async {
      final start = DateTime(2026, 10, 1);
      final end = DateTime(2026, 10, 2, 23, 59, 59, 999);
      await repository.getHistory(
        farmId: 'farm-1',
        cursor: 'cursor-1',
        productId: 'product-1',
        transactionType: InventoryTransactionType.stockOut,
        seasonId: 'season-1',
        createdFrom: start,
        createdTo: end,
      );
      expect(remote.lastData, <String, dynamic>{
        'limit': 100,
        'cursor': 'cursor-1',
        'productId': 'product-1',
        'transactionType': 'STOCK_OUT',
        'seasonId': 'season-1',
        'createdFrom': start.toUtc().toIso8601String(),
        'createdTo': end.toUtc().toIso8601String(),
      });
    },
  );

  test(
    'omits unused history filters instead of filtering out unassigned movements',
    () async {
      await repository.getHistory(farmId: 'farm-1');
      expect(remote.lastData, <String, dynamic>{'limit': 100});
    },
  );

  test(
    'keeps increase and decrease adjustments separately filterable',
    () async {
      await repository.getHistory(
        farmId: 'farm-1',
        transactionType: InventoryTransactionType.adjustmentIn,
      );
      expect(remote.lastData!['transactionType'], 'ADJUSTMENT_IN');
      await repository.getHistory(
        farmId: 'farm-1',
        transactionType: InventoryTransactionType.adjustmentOut,
      );
      expect(remote.lastData!['transactionType'], 'ADJUSTMENT_OUT');
    },
  );

  test(
    'normalizes product fields and sends the optimistic update token',
    () async {
      await repository.updateProduct(
        farmId: 'farm-1',
        product: inventoryTestProduct,
        name: '  Thức ăn   CP 9004 ',
        category: InventoryProductCategory.feed,
        unit: InventoryProductUnit.kg,
        minAlertQuantity: 100,
      );
      expect(remote.lastData, <String, dynamic>{
        'name': 'Thức ăn CP 9004',
        'category': 'FEED',
        'unit': 'KG',
        'conversionQuantity': null,
        'conversionUnit': null,
        'minAlertQuantity': 100.0,
        'description': null,
        'imageUrl': null,
        'expectedUpdatedAt': '2026-10-01T00:00:00.000Z',
      });
    },
  );

  test(
    'sends ordered photo URLs and an empty list to remove all photos',
    () async {
      for (final photos in [
        <String>[
          'https://example.com/front.png',
          'https://example.com/back.png',
        ],
        <String>[],
      ]) {
        await repository.updateProduct(
          farmId: 'farm-1',
          product: inventoryTestProduct,
          name: inventoryTestProduct.name,
          category: InventoryProductCategory.feed,
          unit: InventoryProductUnit.kg,
          minAlertQuantity: 100,
          imageUrls: photos,
        );
        expect(remote.lastData!['imageUrls'], photos);
        expect(remote.lastData!.containsKey('imageUrl'), isFalse);
      }
    },
  );

  test(
    'sends supplier ID without a mutable supplier name on stock-in',
    () async {
      await repository.recordStockIn(
        farmId: 'farm-1',
        productId: 'product-1',
        lotNumber: 'LOT',
        receivedAt: DateTime.utc(2026, 10, 1),
        quantity: 10,
        unitPrice: 1000,
        supplierName: 'Old display name',
        supplierId: 'supplier-1',
      );
      expect(remote.lastData!['supplierId'], 'supplier-1');
      expect(remote.lastData!.containsKey('supplierName'), isFalse);
    },
  );

  test(
    'sends ordered photo URLs and an empty list to remove all photos',
    () async {
      for (final photos in [
        <String>[
          'https://example.com/front.png',
          'https://example.com/back.png',
        ],
        <String>[],
      ]) {
        await repository.updateProduct(
          farmId: 'farm-1',
          product: inventoryTestProduct,
          name: inventoryTestProduct.name,
          category: InventoryProductCategory.feed,
          unit: InventoryProductUnit.kg,
          minAlertQuantity: 100,
          imageUrls: photos,
        );
        expect(remote.lastData!['imageUrls'], photos);
        expect(remote.lastData!.containsKey('imageUrl'), isFalse);
      }
    },
  );

  test(
    'retries an uncertain stock movement with the same idempotency key',
    () async {
      remote.error = const NetworkException();
      await expectLater(adjust(), throwsA(isA<NetworkException>()));
      final originalKey = remote.keys.single;
      remote.error = null;
      await adjust();
      expect(remote.keys, <String>[originalKey, originalKey]);
      expect(remote.lastData, <String, dynamic>{
        'transactionType': 'ADJUSTMENT_OUT',
        'inventoryBalanceId': 'lot-1',
        'quantity': 6.5,
        'reason': 'Kiểm kê thực tế',
      });

      await adjust();
      expect(remote.keys.last, isNot(originalKey));
    },
  );

  test('retains an uncertain key when the response cannot be parsed', () async {
    remote.error = const InvalidResponseException();
    await expectLater(adjust(), throwsA(isA<InvalidResponseException>()));
    remote.error = null;
    await adjust();
    expect(remote.keys[0], remote.keys[1]);
  });

  test('clears the key after an explicit server rejection', () async {
    remote.error = const ApiException('Not enough stock', statusCode: 409);
    await expectLater(adjust(), throwsA(isA<ApiException>()));
    remote.error = null;
    await adjust();
    expect(remote.keys[0], isNot(remote.keys[1]));
  });

  test('changed stock payload receives its own idempotency key', () async {
    remote.error = const NetworkException();
    await expectLater(adjust(), throwsA(isA<NetworkException>()));
    remote.error = null;
    await repository.recordAdjustment(
      farmId: 'farm-1',
      productId: 'product-1',
      inventoryBalanceId: 'lot-1',
      increase: false,
      quantity: 7,
      reason: 'Kiểm kê thực tế',
    );
    expect(remote.keys[0], isNot(remote.keys[1]));
  });
}

final class _InventoryRemote implements InventoryRemoteDataSource {
  final keys = <String>[];
  Map<String, dynamic>? lastData;
  AppException? error;

  @override
  Future<InventoryHistoryPage> getHistory(
    String farmId,
    Map<String, dynamic> query,
  ) async {
    lastData = query;
    return inventoryTestHistoryPage;
  }

  @override
  Future<InventoryProduct> updateProduct(
    String farmId,
    String productId,
    Map<String, dynamic> data,
  ) async {
    lastData = data;
    return inventoryTestProduct;
  }

  @override
  Future<InventoryStockResult> recordStockTransaction(
    String farmId,
    String productId,
    Map<String, dynamic> data,
    String idempotencyKey,
  ) async {
    lastData = data;
    keys.add(idempotencyKey);
    final failure = error;
    if (failure != null) throw failure;
    return inventoryTestStockResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
