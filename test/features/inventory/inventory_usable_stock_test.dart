import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'inventory_test_data.dart';

void main() {
  Map<String, dynamic> payload() =>
      jsonDecode(jsonEncode(inventoryTestProduct)) as Map<String, dynamic>;
  test('usable stock remains separate from ledger stock and value', () {
    final product = InventoryProduct.parse({...payload(), 'usableStock': 5});
    expect(product.usableStock, 5);
    expect(product.currentStock, 80);
    expect(product.inventoryValue, 2800000);
  });
  test('older responses do not invent a usable stock quantity', () {
    final data = payload()..remove('usableStock');
    expect(InventoryProduct.parse(data).usableStock, isNull);
  });
  test(
    'invalid availability is rejected rather than displayed as valid stock',
    () {
      for (final value in [-1, 81, double.nan, double.infinity, '5']) {
        expect(
          () => InventoryProduct.parse({...payload(), 'usableStock': value}),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
}
