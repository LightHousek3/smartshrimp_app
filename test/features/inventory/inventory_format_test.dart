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
  test('keeps zero and trailing zeroes in integral stock quantities', () {
    expect(formatInventoryQuantity(0), '0');
    expect(formatInventoryQuantity(80), '80');
    expect(formatInventoryQuantity(100), '100');
    expect(formatInventoryQuantity(1000), '1.000');
    expect(formatInventoryQuantity(100.125), '100,125');
    expect(formatInventoryQuantity(80.5), '80,5');
    expect(formatInventoryQuantity(0.001), '0,001');
  });
}
