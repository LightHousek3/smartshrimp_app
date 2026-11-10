import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';

void main() {
  group('InventoryRules', () {
    test(
      'preserves special names and raw punctuation while splitting mobile lists',
      () {
        final examples = <(String, List<String>)>[
          ('cồn , Auramine , rượu', ['cồn', 'Auramine', 'rượu']),
          ('cồn ， Auramine 、 rượu', ['cồn', 'Auramine', 'rượu']),
          ('1, 2 pare, 1.1 ure, 1-2 ure', ['1, 2 pare', '1.1 ure', '1-2 ure']),
          (
            'N,N-dimethyl chloride, N, N′-ure, Auramine',
            ['N,N-dimethyl chloride', 'N, N′-ure', 'Auramine'],
          ),
          (
            'Vitamin C: 1, 0 g, Men [nước, enzyme], Auramine',
            ['Vitamin C: 1, 0 g', 'Men [nước, enzyme]', 'Auramine'],
          ),
          (
            '"Tên lạ, chưa có danh mục", Auramine',
            ['"Tên lạ, chưa có danh mục"', 'Auramine'],
          ),
          ('“Tên khác, đủ tên”; Auramine', ['“Tên khác, đủ tên”', 'Auramine']),
          (
            '"Tên dùng dấu ; và dấu phẩy, trong cùng một mục"\r\nAuramine',
            ['"Tên dùng dấu ; và dấu phẩy, trong cùng một mục"', 'Auramine'],
          ),
        ];
        for (final (raw, expected) in examples) {
          final segments = InventoryRules.ingredientSegments(raw);
          expect(
            segments.map((segment) => segment.text),
            expected,
            reason: raw,
          );
          for (final segment in segments) {
            expect(
              raw.substring(segment.start, segment.end).trim(),
              startsWith(segment.text),
            );
          }
        }
        const catalogName = 'Formalin, Formaldehyde';
        final literal = InventoryRules.ingredientLiteral(catalogName);
        expect(literal, '"$catalogName"');
        expect(
          InventoryRules.ingredientSegments(
            '$literal, Auramine',
          ).map((part) => part.text),
          [literal, 'Auramine'],
        );
      },
    );
    test(
      'splits ingredient delimiters while preserving chemical and decimal commas',
      () {
        const text =
            '1,2-Propanediol, Vitamin C: 1,0 g; Men (Bacillus subtilis, nước)\r\nEtanidazole';
        final segments = InventoryRules.ingredientSegments(text);
        expect(segments.map((segment) => segment.text), [
          '1,2-Propanediol',
          'Vitamin C: 1,0 g',
          'Men (Bacillus subtilis, nước)',
          'Etanidazole',
        ]);
        expect(segments.map((segment) => segment.terminated), [
          true,
          true,
          true,
          false,
        ]);
        final removed = segments[1];
        expect(
          text.replaceRange(removed.start, removed.end, ''),
          '1,2-Propanediol, Men (Bacillus subtilis, nước)\r\nEtanidazole',
        );
        expect(InventoryRules.ingredientSegments(', ; \n'), isEmpty);
        expect(
          InventoryRules.ingredientSegments(
            'Men (nước, enzyme (a, b)), Vitamin C,',
          ).map((segment) => segment.text),
          ['Men (nước, enzyme (a, b))', 'Vitamin C'],
        );
      },
    );
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

    test(
      'bottles accept only liters and milliliters while packs keep all conversions',
      () {
        for (final conversionUnit in InventoryConversionUnit.values.where(
          (unit) => unit != InventoryConversionUnit.unknown,
        )) {
          void validate(InventoryProductUnit unit) =>
              InventoryRules.validateConversion(
                unit: unit,
                conversionQuantity: 500,
                conversionUnit: conversionUnit,
              );
          expect(() => validate(InventoryProductUnit.pack), returnsNormally);
          expect(
            () => validate(InventoryProductUnit.bottle),
            [
                  InventoryConversionUnit.ml,
                  InventoryConversionUnit.l,
                ].contains(conversionUnit)
                ? returnsNormally
                : throwsFormatException,
          );
        }
      },
    );
  });
}
