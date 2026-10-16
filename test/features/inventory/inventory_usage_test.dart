import 'package:flutter_test/flutter_test.dart';
import 'inventory_test_data.dart';

void main() {
  test('usage follows remaining stock against recorded receipts', () {
    expect(
      inventoryTestLot.copyWith(receivedQuantity: 100, quantity: 51).usageRatio,
      0.49,
    );
    expect(
      inventoryTestLot
          .copyWith(receivedQuantity: 100, quantity: 100)
          .usageRatio,
      0,
    );
    expect(
      inventoryTestLot.copyWith(receivedQuantity: 100, quantity: 0).usageRatio,
      1,
    );
  });
  test('unknown or zero receipts do not produce a fabricated percentage', () {
    expect(inventoryTestLot.usageRatio, isNull);
    expect(
      inventoryTestLot.copyWith(receivedQuantity: 0, quantity: 0).usageRatio,
      isNull,
    );
  });
}
