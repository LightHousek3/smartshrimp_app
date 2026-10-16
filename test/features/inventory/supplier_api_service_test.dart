import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/supplier_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/supplier_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';

void main() {
  final supplier = <String, dynamic>{
    'id': 'supplier-1',
    'farmId': 'farm-1',
    'name': 'CP',
    'createdAt': '2026-10-01T00:00:00Z',
    'updatedAt': '2026-10-01T00:00:00Z',
  };
  test(
    'supplier CRUD uses authenticated farm routes, normalized contacts and version tokens',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: request.method == 'DELETE' ? 204 : 200,
                  data: request.method == 'DELETE'
                      ? null
                      : {'success': true, 'message': 'OK', 'data': supplier},
                ),
              );
            },
          ),
        );
      final repo = SupplierRepositoryImpl(
        SupplierApiService(ApiClient(dio, _SessionStore())),
      );
      final created = await repo.saveSupplier(
        farmId: 'farm-1',
        name: '  Đại   lý CP ',
        email: ' SALES@EXAMPLE.COM ',
        phone: '',
      );
      expect(requests.last.method, 'POST');
      expect(requests.last.path, '/owner/farms/farm-1/suppliers');
      expect((requests.last.data as Map)['name'], 'Đại lý CP');
      expect((requests.last.data as Map)['email'], 'sales@example.com');
      expect((requests.last.data as Map)['phone'], isNull);
      await repo.getSupplier('farm-1', created.id);
      expect(requests.last.method, 'GET');
      await repo.saveSupplier(farmId: 'farm-1', existing: created, name: 'New');
      expect(requests.last.method, 'PATCH');
      expect(
        (requests.last.data as Map)['expectedUpdatedAt'],
        '2026-10-01T00:00:00.000Z',
      );
      await repo.deleteSupplier('farm-1', created.id);
      expect(requests.last.method, 'DELETE');
      expect(
        requests.every((r) => r.headers['Authorization'] == 'Bearer token'),
        isTrue,
      );
    },
  );
  test(
    'loads all supplier pages and rejects broken pagination responses',
    () async {
      var broken = false;
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              final page = request.queryParameters['page'];
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'message': 'OK',
                    'data': broken
                        ? []
                        : [
                            {...supplier, 'id': 'supplier-$page'},
                          ],
                    'meta': {'hasNextPage': broken || page == 1},
                  },
                ),
              );
            },
          ),
        );
      final repo = SupplierRepositoryImpl(
        SupplierApiService(ApiClient(dio, _SessionStore())),
      );
      expect((await repo.getSuppliers('farm-1')).map((s) => s.id), [
        'supplier-1',
        'supplier-2',
      ]);
      broken = true;
      await expectLater(
        repo.getSuppliers('farm-1'),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
  test('rejects malformed supplier records', () {
    expect(
      () => InventorySupplier.parse({...supplier, 'updatedAt': 'bad-date'}),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => InventorySupplier.parse({...supplier, 'name': ''}),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}

final class _SessionStore implements SessionStore {
  @override
  String? accessToken = 'token';
  @override
  String? refreshToken;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
