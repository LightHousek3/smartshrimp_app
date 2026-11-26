import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'inventory_test_data.dart';

void main() {
  test('threshold labels use converted units only for packaged products', () {
    expect(inventoryTestProduct.alertUnitLabel, 'kg');
    expect(
      inventoryTestProduct
          .copyWith(
            unit: InventoryProductUnit.bottle,
            conversionQuantity: 1500,
            conversionUnit: InventoryConversionUnit.ml,
          )
          .alertUnitLabel,
      'ml',
    );
    expect(
      inventoryTestProduct
          .copyWith(
            unit: InventoryProductUnit.pack,
            conversionQuantity: 25,
            conversionUnit: InventoryConversionUnit.kg,
          )
          .alertUnitLabel,
      'kg',
    );
  });
  test('groups stock quantities and rounds to three decimal places', () {
    expect(formatInventoryQuantity(0), '0');
    expect(formatInventoryQuantity(80), '80');
    expect(formatInventoryQuantity(100), '100');
    expect(formatInventoryQuantity(1000), '1.000');
    expect(formatInventoryQuantity(100.125), '100,125');
    expect(formatInventoryQuantity(80.5), '80,5');
    expect(formatInventoryQuantity(0.001), '0,001');
    expect(formatInventoryQuantity(500000), '500.000');
    expect(formatInventoryQuantity(-500), '-500');
    expect(formatInventoryQuantity(1200.2345), '1.200,235');
    expect(formatInventoryQuantity(999.9995), '1.000');
  });

  test('preserves exact lot quantities without changing compact summaries', () {
    expect(formatInventoryQuantity(0.000000001), '0,000000001');
    expect(formatInventoryQuantity(0.999999), '1');
    expect(formatInventoryExactQuantity(0.999999), '0,999999');
    expect(formatInventoryExactQuantity(0.000001), '0,000001');
    expect(
      formatInventoryExactQuantity(
        10000000000.2345,
        exact: '10000000000.234499999',
      ),
      '10.000.000.000,234499999',
    );
  });

  test('rounds whole đồng and compact summaries at unit boundaries', () {
    expect(formatInventoryMoney(499999.5), '500.000 ₫');
    expect(formatInventoryMoney(-500), '-500 ₫');
    expect(formatInventoryMoney(0.10, showSubDong: true), '< 1 ₫');
    expect(formatInventoryMoney(0, showSubDong: true), '0 ₫');
    expect(formatInventoryMoney(1, showSubDong: true), '1 ₫');
    expect(formatInventoryCompactMoney(0), '0 ₫');
    expect(formatInventoryCompactMoney(500000), '500.000 ₫');
    expect(formatInventoryCompactMoney(999999.49), '999.999 ₫');
    expect(formatInventoryCompactMoney(999999.5), '1 tr ₫');
    expect(formatInventoryCompactMoney(61750000), '61,8 tr ₫');
    expect(formatInventoryCompactMoney(3149999.99), '3,1 tr ₫');
    expect(formatInventoryCompactMoney(999949999.99), '999,9 tr ₫');
    expect(formatInventoryCompactMoney(999950000), '1 tỷ ₫');
    expect(formatInventoryCompactMoney(1234567890000), '1.234,6 tỷ ₫');
  });
}
