import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';

void main() {
  group('InventoryRules', () {
    test(
      'parses decimal quantities and prices without changing their value',
      () {
        expect(InventoryRules.parseNumber('35000.50'), 35000.5);
        expect(InventoryRules.parseNumber('35000,50'), 35000.5);
        expect(InventoryRules.parseNumber(' 80 '), 80);
        expect(InventoryRules.parseNumber('1.000.000'), isNull);
        expect(InventoryRules.parseNumber('NaN'), isNull);
        expect(InventoryRules.parseNumber('Infinity'), isNull);
      },
    );

    test('quantity validation matches backend precision and range', () {
      expect(InventoryRules.quantityError('0'), isNotNull);
      expect(InventoryRules.quantityError('0', allowZero: true), isNull);
      expect(InventoryRules.quantityError('0.001'), isNull);
      expect(InventoryRules.quantityError('0.000000001'), isNull);
      expect(InventoryRules.quantityError('0.0000000001'), isNotNull);
      expect(InventoryRules.normalizedQuantity('000,000000001'), '0.000000001');
      expect(InventoryRules.quantityError('99999999999.999'), isNull);
      expect(InventoryRules.quantityError('100000000000'), isNotNull);
      expect(InventoryRules.quantityError('NaN'), isNotNull);
    });

    test('price and conversion validation match backend decimal limits', () {
      expect(InventoryRules.unitPriceError('35000.50'), isNull);
      expect(InventoryRules.unitPriceError('35000,505'), isNotNull);
      expect(InventoryRules.unitPriceError('999999999999.99'), isNull);
      expect(InventoryRules.unitPriceError('1000000000000'), isNotNull);
      expect(InventoryRules.conversionError('0.0001'), isNull);
      expect(InventoryRules.conversionError('0.00001'), isNotNull);
      expect(InventoryRules.conversionError('10000000000'), isNotNull);
    });

    test('normalizes user-entered whitespace before sending to backend', () {
      expect(
        InventoryRules.normalizeText('  Thức ăn   CP 9004  '),
        'Thức ăn CP 9004',
      );
    });

    test('requires conversion data for packaged products', () {
      expect(
        () => InventoryRules.validateConversion(
          unit: InventoryProductUnit.pack,
          conversionQuantity: null,
          conversionUnit: null,
        ),
        throwsFormatException,
      );

      expect(
        () => InventoryRules.validateConversion(
          unit: InventoryProductUnit.pack,
          conversionQuantity: 500,
          conversionUnit: InventoryConversionUnit.g,
        ),
        returnsNormally,
      );
    });

    test('rejects conversion data for base measurement units', () {
      expect(
        () => InventoryRules.validateConversion(
          unit: InventoryProductUnit.kg,
          conversionQuantity: 1000,
          conversionUnit: InventoryConversionUnit.g,
        ),
        throwsFormatException,
      );
    });
  });
}
