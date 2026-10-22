import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_response.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'inventory_test_data.dart';

void main() {
  if (const bool.fromEnvironment('INVENTORY_HISTORY_PAGING_LIVE_FIXTURE')) {
    test(
      'ten-row live history pages retain complete totals and filter choices',
      () {
        final fixture =
            jsonDecode(
                  File(
                    '../.tmp/inventory-history-ten-live-fixture.json',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>;
        final pages = [
          for (final key in ['first', 'second', 'search'])
            InventoryHistoryPage.parse(
              fixture[key]['transactions'],
              fixture[key]['meta'] as Map<String, dynamic>,
            ),
        ];
        expect(pages[0].items, hasLength(10));
        expect(pages[1].items, hasLength(10));
        expect(pages[0].summary, pages[1].summary);
        expect(pages[0].filterProducts, isNotEmpty);
        expect(pages[0].filterSeasons, isNotEmpty);
        expect(pages[2].totalResults, greaterThan(0));
      },
    );
  }
  if (const bool.fromEnvironment('INVENTORY_CATALOG_LIVE_FIXTURE')) {
    test(
      'every live catalog page parses through the response and product contracts',
      () {
        final responses =
            jsonDecode(
                  File(
                    '../.tmp/inventory-catalog-live-responses.json',
                  ).readAsStringSync(),
                )
                as List<dynamic>;
        var products = 0;
        for (var index = 0; index < responses.length; index++) {
          final response = ApiResponse.parse(responses[index]);
          final page = InventoryProductPage.parse(response.data, response.meta);
          products += page.items.length;
        }
        expect(responses, isNotEmpty);
        expect(products, greaterThan(0));
      },
    );
  }
  test('empty legacy catalogs retain the read-only capability', () {
    final page = InventoryProductPage.parse([], {
      'readOnly': true,
      'page': 1,
      'limit': 20,
      'totalResults': 0,
      'totalPages': 0,
      'hasNextPage': false,
      'summary': {'totalProducts': 0, 'lowStockCount': 0, 'inventoryValue': 0},
    });
    expect(page.readOnly, isTrue);
  });
  Map<String, dynamic> product() =>
      jsonDecode(jsonEncode(inventoryTestProduct)) as Map<String, dynamic>;
  Map<String, dynamic> supplier() => {
    'id': 'supplier-1',
    'ownerId': 'owner-1',
    'name': 'Nhà cung cấp cũ',
    'status': 'ACTIVE',
    'supplierType': 'UNKNOWN',
    'createdAt': '2026-10-01T00:00:00Z',
    'updatedAt': '2026-10-01T00:00:00Z',
  };
  test(
    'explicit legacy read mode preserves missing manufacturer instead of inventing one',
    () {
      final parsed = InventoryProduct.parse({
        ...product(),
        'manufacturerId': null,
        'manufacturer': null,
        'schemaVersion': 1,
        'readOnly': true,
      });
      expect(parsed.manufacturerId, isEmpty);
      expect(parsed.manufacturer, isEmpty);
      expect(parsed.readOnly, isTrue);
      expect(parsed.currentStock, inventoryTestProduct.currentStock);
    },
  );
  test('V2 responses still reject a missing manufacturer', () {
    expect(
      () => InventoryProduct.parse({...product(), 'manufacturerId': null}),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => InventoryProduct.parse({
        ...product(),
        'manufacturerId': null,
        'schemaVersion': 2,
        'readOnly': true,
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test(
    'expanded schema allows factual manufacturer completion without read-only mode',
    () {
      final parsed = InventoryProduct.parse({
        ...product(),
        'schemaVersion': 2,
        'requiresManufacturer': true,
        'manufacturerId': null,
        'manufacturer': null,
        'readOnly': false,
      });
      expect(parsed.manufacturerId, isEmpty);
      expect(parsed.readOnly, isFalse);
    },
  );
  test(
    'expanded directory allows role confirmation without inventing a role',
    () {
      final parsed = InventorySupplier.parse({
        ...supplier(),
        'schemaVersion': 2,
        'requiresSupplierType': true,
        'readOnly': false,
      });
      expect(parsed.readOnly, isFalse);
      expect(parsed.supplierType, 'UNKNOWN');
      expect(parsed.isManufacturer, isFalse);
    },
  );
  test(
    'legacy supplier role stays unknown and cannot be selected as manufacturer',
    () {
      final parsed = InventorySupplier.parse({
        ...supplier(),
        'schemaVersion': 1,
        'readOnly': true,
      });
      expect(parsed.readOnly, isTrue);
      expect(parsed.isManufacturer, isFalse);
      expect(parsed.ownerId, 'owner-1');
    },
  );
  test('unknown supplier roles need the explicit legacy marker', () {
    expect(
      () => InventorySupplier.parse(supplier()),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  if (const bool.fromEnvironment('INVENTORY_EXPANDED_LIVE_FIXTURE')) {
    test('upgraded live responses parse without read-only mode', () {
      final data =
          jsonDecode(
                File(
                  '../.tmp/inventory-upgrade-live-fixtures.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      expect(
        InventoryProduct.parse(
          data['product'] as Map<String, dynamic>,
        ).readOnly,
        isFalse,
      );
      expect(
        InventorySupplier.parse(
          data['supplier'] as Map<String, dynamic>,
        ).readOnly,
        isFalse,
      );
      final history = data['history'] as Map<String, dynamic>;
      expect(
        InventoryHistoryPage.parse(
          history['transactions'],
          history['meta'] as Map<String, dynamic>,
        ),
        isA<InventoryHistoryPage>(),
      );
    });
  }
  if (const bool.fromEnvironment('INVENTORY_LEGACY_LIVE_FIXTURE')) {
    test('current database read responses parse through the app contract', () {
      final data =
          jsonDecode(
                File(
                  '../.tmp/legacy-inventory-read-fixtures.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      expect(
        InventoryProduct.parse(
          data['product'] as Map<String, dynamic>,
        ).readOnly,
        isTrue,
      );
      expect(
        InventorySupplier.parse(
          data['supplier'] as Map<String, dynamic>,
        ).readOnly,
        isTrue,
      );
      final history = data['history'] as Map<String, dynamic>;
      expect(
        InventoryHistoryPage.parse(
          history['transactions'],
          history['meta'] as Map<String, dynamic>,
        ),
        isA<InventoryHistoryPage>(),
      );
    });
  }
}
