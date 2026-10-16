import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';

void main() {
  test(
    'default filters include every movement and transactions without season',
    () {
      const filters = InventoryHistoryFilters();
      expect(filters.isEmpty, isTrue);
      expect(filters.isValidDateRange, isTrue);
      expect(filters.seasonId, isNull);
      expect(filters.createdFrom, isNull);
      expect(filters.createdTo, isNull);
    },
  );

  test('date bounds cover the complete selected local days', () {
    final filters = InventoryHistoryFilters(
      fromDate: DateTime(2026, 10, 1, 18),
      toDate: DateTime(2026, 10, 2, 8),
    );
    expect(filters.createdFrom, DateTime(2026, 10, 1));
    expect(filters.createdTo, DateTime(2026, 10, 2, 23, 59, 59, 999));
    expect(filters.createdFrom!.toUtc().toLocal(), DateTime(2026, 10, 1));
  });

  test('accepts the same day even when the input times are inverted', () {
    final filters = InventoryHistoryFilters(
      fromDate: DateTime(2026, 10, 2, 20),
      toDate: DateTime(2026, 10, 2, 1),
    );
    expect(filters.isValidDateRange, isTrue);
    expect(
      filters.createdTo!.difference(filters.createdFrom!),
      const Duration(days: 1) - const Duration(milliseconds: 1),
    );
  });

  test('rejects an inverted calendar range and accepts open-ended dates', () {
    expect(
      InventoryHistoryFilters(
        fromDate: DateTime(2026, 10, 3),
        toDate: DateTime(2026, 10, 2),
      ).isValidDateRange,
      isFalse,
    );
    expect(
      InventoryHistoryFilters(fromDate: DateTime(2026, 10, 3)).isValidDateRange,
      isTrue,
    );
    expect(
      InventoryHistoryFilters(toDate: DateTime(2026, 10, 2)).isValidDateRange,
      isTrue,
    );
  });

  test('end-of-day bounds roll over month and leap-year boundaries', () {
    expect(
      InventoryHistoryFilters(toDate: DateTime(2024, 2, 29)).createdTo,
      DateTime(2024, 3, 1).subtract(const Duration(milliseconds: 1)),
    );
    expect(
      InventoryHistoryFilters(toDate: DateTime(2026, 12, 31)).createdTo,
      DateTime(2027).subtract(const Duration(milliseconds: 1)),
    );
  });

  test('filters have value equality and allow clearing individual fields', () {
    const filters = InventoryHistoryFilters(
      productId: 'product-1',
      seasonId: 'season-1',
    );
    expect(filters, filters.copyWith());
    expect(filters.hashCode, filters.copyWith().hashCode);
    expect(filters.copyWith(productId: null).productId, isNull);
    expect(filters.copyWith(productId: null).seasonId, 'season-1');
  });

  test(
    'season labels distinguish ponds while supporting older API responses',
    () {
      final season = InventoryTransactionSeason.fromJson(<String, dynamic>{
        'id': 'season-1',
        'name': 'Vụ Đông Xuân',
        'pondName': 'Ao A3',
      });
      expect(season.label, 'Vụ Đông Xuân · Ao A3');
      expect(season.copyWith(pondName: null).label, 'Vụ Đông Xuân');
      expect(season.copyWith(pondName: ' ').label, 'Vụ Đông Xuân');
    },
  );
}
