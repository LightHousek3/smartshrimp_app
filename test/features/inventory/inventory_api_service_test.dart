import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_api_service.dart';

void main() {
  test('archiving uses its distinct action endpoint', () async {
    late RequestOptions captured;
    final service = InventoryApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          captured = request;
          handler.resolve(_success(request, data: _productJson()));
        }),
        _SessionStore(),
      ),
    );
    await service.archiveProduct('farm-1', 'product-1');
    expect(captured.method, 'POST');
    expect(captured.uri.path, '/owner/farms/farm-1/products/product-1/archive');
  });
  test(
    'history forwards filter query, authentication and matching summary',
    () async {
      late RequestOptions captured;
      final service = InventoryApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            captured = request;
            handler.resolve(
              _success(
                request,
                data: <Map<String, dynamic>>[],
                meta: <String, dynamic>{
                  'limit': 100,
                  'totalResults': 0,
                  'hasNextPage': false,
                  'nextCursor': null,
                  'summary': <String, dynamic>{
                    'totalInboundValue': 0,
                    'totalOutboundValue': 0,
                  },
                },
              ),
            );
          }),
          _SessionStore(),
        ),
      );
      final query = <String, dynamic>{
        'limit': 100,
        'productId': 'product-1',
        'transactionType': 'STOCK_OUT',
        'seasonId': 'season-1',
        'createdFrom': '2026-10-01T00:00:00.000Z',
        'createdTo': '2026-10-02T23:59:59.999Z',
      };
      final page = await service.getHistory('farm-1', query);
      expect(captured.method, 'GET');
      expect(captured.uri.path, '/owner/farms/farm-1/inventory-transactions');
      expect(captured.queryParameters, query);
      expect(captured.headers['Authorization'], 'Bearer access-token');
      expect(page.totalResults, 0);
      expect(page.summary.totalOutboundValue, 0);
    },
  );

  test('loads products with pagination and summary metadata', () async {
    late RequestOptions captured;
    final service = InventoryApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          captured = request;
          handler.resolve(
            _success(
              request,
              data: <Map<String, dynamic>>[_productJson()],
              meta: <String, dynamic>{
                'page': 1,
                'limit': 100,
                'totalResults': 1,
                'totalPages': 1,
                'hasNextPage': false,
                'summary': <String, dynamic>{
                  'totalProducts': 1,
                  'lowStockCount': 1,
                  'inventoryValue': 2800000,
                },
              },
            ),
          );
        }),
        _SessionStore(),
      ),
    );

    final page = await service.getProducts('farm 1', <String, dynamic>{
      'page': 1,
      'limit': 100,
      'archiveStatus': 'ALL',
    });

    expect(captured.method, 'GET');
    expect(captured.uri.path, '/owner/farms/farm%201/products');
    expect(captured.queryParameters['archiveStatus'], 'ALL');
    expect(page.items.single.name, 'Thức ăn CP 9004');
    expect(page.summary.lowStockCount, 1);
  });

  test('stock transaction sends a unique idempotency header', () async {
    late RequestOptions captured;
    final service = InventoryApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          captured = request;
          handler.resolve(
            _success(
              request,
              data: <String, dynamic>{
                'transaction': <String, dynamic>{'id': 'transaction-1'},
                'balance': _lotJson(),
                'currentStock': 80,
                'idempotentReplay': false,
              },
            ),
          );
        }),
        _SessionStore(),
      ),
    );

    final result = await service.recordStockTransaction(
      'farm-1',
      'product-1',
      <String, dynamic>{'transactionType': 'STOCK_IN', 'quantity': 80},
      'inventory-request-1',
    );

    expect(captured.method, 'POST');
    expect(
      captured.uri.path,
      '/owner/farms/farm-1/products/product-1/stock-transactions',
    );
    expect(captured.headers['Authorization'], 'Bearer access-token');
    expect(captured.headers['Idempotency-Key'], 'inventory-request-1');
    expect(result.transactionId, 'transaction-1');
    expect(result.currentStock, 80);
  });

  test('rejects malformed product payload at the API boundary', () async {
    final service = InventoryApiService(
      ApiClient(
        _dioWithHandler((request, handler) {
          handler.resolve(
            _success(request, data: <String, dynamic>{'id': 'product-1'}),
          );
        }),
        _SessionStore(),
      ),
    );

    await expectLater(
      service.getProduct('farm-1', 'product-1'),
      throwsA(isA<InvalidResponseException>()),
    );
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
  required Object data,
  Map<String, dynamic>? meta,
}) {
  return Response<Map<String, dynamic>>(
    requestOptions: request,
    statusCode: 200,
    data: <String, dynamic>{
      'success': true,
      'message': 'Success',
      'data': data,
      'meta': ?meta,
    },
  );
}

Map<String, dynamic> _productJson() => <String, dynamic>{
  'id': 'product-1',
  'farmId': 'farm-1',
  'name': 'Thức ăn CP 9004',
  'category': 'FEED',
  'unit': 'KG',
  'conversionQuantity': null,
  'conversionUnit': null,
  'minAlertQuantity': 100,
  'description': 'Thức ăn cho tôm',
  'archivedAt': null,
  'isArchived': false,
  'isDeleted': false,
  'deletedAt': null,
  'createdAt': '2026-10-01T00:00:00.000Z',
  'updatedAt': '2026-10-01T00:00:00.000Z',
  'currentStock': 80,
  'inventoryValue': 2800000,
  'activeLotCount': 1,
  'isLowStock': true,
  'lots': <Map<String, dynamic>>[_lotJson()],
  'plannedUseCount': 0,
  'canArchive': false,
};

Map<String, dynamic> _lotJson() => <String, dynamic>{
  'id': 'lot-1',
  'productId': 'product-1',
  'lotNumber': 'LOT-001',
  'receivedAt': '2026-10-01T00:00:00.000Z',
  'quantity': 80,
  'unitPrice': 35000,
  'supplierName': 'Nhà cung cấp A',
  'inventoryValue': 2800000,
  'createdAt': '2026-10-01T00:00:00.000Z',
  'updatedAt': '2026-10-01T00:00:00.000Z',
};

final class _SessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';

  @override
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

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
