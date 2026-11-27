import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_compliance.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';

void main() {
  test(
    'registration format follows legal type, serial bounds and label guidance',
    () {
      for (final entry in {
        'feed': '01',
        'environment': '02',
        'dual_purpose': '03',
      }.entries) {
        expect(
          InventoryRules.formatReceiptNumber(entry.key, '${entry.value}001234'),
          '${entry.value}-001234',
        );
        for (final serial in ['000001', '123456', '999999']) {
          expect(
            InventoryRules.registrationNumberError(
              entry.key,
              ' ${entry.value}-$serial ',
            ),
            isNull,
          );
        }
        for (final serial in [
          '000000',
          '0000',
          '1234567',
          '12a456',
          '１２３４５６',
          '123 456',
        ]) {
          expect(
            InventoryRules.registrationNumberError(
              entry.key,
              '${entry.value}-$serial',
            ),
            contains('${entry.value}-123456'),
          );
        }
      }
      expect(
        InventoryRules.registrationNumberError('environment', '01-123456'),
        contains('02-123456'),
      );
      expect(
        InventoryRules.registrationNumberError('medicine', '01-123456'),
        contains('đăng ký lưu hành thuốc thú y'),
      );
      expect(
        InventoryRules.registrationNumberError('medicine', 'VN-TYT-1234'),
        isNull,
      );
      expect(InventoryRules.registrationNumberError('feed', ''), isNotNull);
      expect(
        InventoryRules.formatReceiptNumber('feed', '02001234'),
        '02001234',
      );
      expect(
        InventoryRules.formatReceiptNumber('medicine', '01001234'),
        '01001234',
      );
      expect(
        InventoryRules.registrationHint(null),
        contains('Chọn loại sản phẩm'),
      );
    },
  );
  test('Owner input excludes server declaration identity and time', () {
    final record = InventoryCompliance(
      regulatoryType: 'medicine',
      registrationNumber: 'REG-1',
      checkedBy: 'expert',
      checkedAt: DateTime.utc(2026, 10, 21),
      withdrawalDays: 7,
    );
    final body = record.toDraftJson();
    expect(body['withdrawalDays'], 7);
    expect(body.keys, isNot(contains('checkedBy')));
    expect(body.keys, isNot(contains('checkedAt')));
    expect(body.keys, isNot(contains('reviewNote')));
    expect(body.keys, isNot(contains('complianceStatus')));
  });
  test(
    'decimal transport preserves nine places and rejects overflow before a request',
    () {
      expect(InventoryRules.normalizedQuantity('000,000000001'), '0.000000001');
      expect(
        InventoryRules.normalizedQuantity('99999999999.999999999'),
        '99999999999.999999999',
      );
      expect(
        () => InventoryRules.normalizedQuantity('100000000000'),
        throwsFormatException,
      );
      expect(
        () => InventoryRules.normalizedQuantity('0.0000000001'),
        throwsFormatException,
      );
      expect(InventoryRules.quantityError('100000000000'), isNotNull);
    },
  );
}
