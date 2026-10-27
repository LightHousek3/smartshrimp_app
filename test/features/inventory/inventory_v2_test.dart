import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_compliance.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';

void main() {
  test('Owner draft writes exclude server review identity and conclusions', () {
    final record = InventoryCompliance(
      regulatoryType: 'medicine',
      registrationNumber: 'REG-1',
      complianceStatus: 'reviewed',
      checkedBy: 'expert',
      checkedAt: DateTime.utc(2026, 10, 21),
      reviewNote: 'Expert evidence',
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
