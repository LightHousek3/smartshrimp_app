import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

/// Reuse domain entities in presentation; labels and styling stay in this file.
typedef InventoryCategory = InventoryProductCategory;
typedef InventoryProductViewData = InventoryProduct;
typedef InventoryLotViewData = InventoryLot;
typedef InventoryTransactionViewData = InventoryTransaction;

extension InventoryTransactionSeasonPresentation on InventoryTransactionSeason {
  String get label {
    final pond = pondName?.trim();
    return pond == null || pond.isEmpty ? name : '$name · $pond';
  }
}

extension InventoryCategoryPresentation on InventoryProductCategory {
  String get label => switch (this) {
    InventoryProductCategory.feed => 'Thức ăn',
    InventoryProductCategory.medicine => 'Thuốc',
    InventoryProductCategory.mineral => 'Khoáng chất',
    InventoryProductCategory.chemical => 'Hóa chất',
    InventoryProductCategory.other => 'Khác',
    InventoryProductCategory.unknown => 'Không xác định',
  };

  Color get foreground => switch (this) {
    InventoryProductCategory.feed => const Color(0xFF0F9B8E),
    InventoryProductCategory.medicine => const Color(0xFFD43B57),
    InventoryProductCategory.mineral => const Color(0xFF0F62B4),
    InventoryProductCategory.chemical => const Color(0xFF7B5BD6),
    InventoryProductCategory.other ||
    InventoryProductCategory.unknown => const Color(0xFF52637B),
  };

  Color get background => switch (this) {
    InventoryProductCategory.feed => const Color(0xFFE2F6F3),
    InventoryProductCategory.medicine => const Color(0xFFFBE6EA),
    InventoryProductCategory.mineral => const Color(0xFFEAF4FF),
    InventoryProductCategory.chemical => const Color(0xFFEFEAFC),
    InventoryProductCategory.other ||
    InventoryProductCategory.unknown => const Color(0xFFEFF2F6),
  };
}

extension InventoryUnitPresentation on InventoryProductUnit {
  String get label => switch (this) {
    InventoryProductUnit.kg => 'kg',
    InventoryProductUnit.g => 'g',
    InventoryProductUnit.l => 'lít',
    InventoryProductUnit.ml => 'ml',
    InventoryProductUnit.pack => 'gói',
    InventoryProductUnit.bottle => 'chai',
    InventoryProductUnit.unknown => '?',
  };
}

extension InventoryConversionUnitPresentation on InventoryConversionUnit {
  String get label => switch (this) {
    InventoryConversionUnit.mg => 'mg',
    InventoryConversionUnit.g => 'g',
    InventoryConversionUnit.kg => 'kg',
    InventoryConversionUnit.ml => 'ml',
    InventoryConversionUnit.l => 'lít',
    InventoryConversionUnit.unknown => '?',
  };
}

/// Display packaged-product thresholds in their configured conversion unit.
extension InventoryProductAlertPresentation on InventoryProduct {
  String get alertUnitLabel =>
      (unit == InventoryProductUnit.pack ||
              unit == InventoryProductUnit.bottle) &&
          conversionUnit != null &&
          conversionUnit != InventoryConversionUnit.unknown
      ? conversionUnit!.label
      : unit.label;
}

extension InventoryTransactionTypePresentation on InventoryTransactionType {
  String get label => switch (this) {
    InventoryTransactionType.stockIn => 'Nhập kho',
    InventoryTransactionType.stockOut => 'Xuất kho',
    InventoryTransactionType.adjustmentIn => 'Điều chỉnh tăng',
    InventoryTransactionType.adjustmentOut => 'Điều chỉnh giảm',
    InventoryTransactionType.unknown => 'Không xác định',
  };

  bool get isInbound =>
      this == InventoryTransactionType.stockIn ||
      this == InventoryTransactionType.adjustmentIn;

  bool get isAdjustment =>
      this == InventoryTransactionType.adjustmentIn ||
      this == InventoryTransactionType.adjustmentOut;

  Color get color => switch (this) {
    InventoryTransactionType.stockIn => const Color(0xFF0F9B8E),
    InventoryTransactionType.stockOut => const Color(0xFFE05638),
    InventoryTransactionType.adjustmentIn ||
    InventoryTransactionType.adjustmentOut => const Color(0xFF7455D9),
    InventoryTransactionType.unknown => const Color(0xFF52637B),
  };

  Color get backgroundColor => switch (this) {
    InventoryTransactionType.stockIn => const Color(0xFFE2F6F3),
    InventoryTransactionType.stockOut => const Color(0xFFFEECE8),
    InventoryTransactionType.adjustmentIn ||
    InventoryTransactionType.adjustmentOut => const Color(0xFFF2EDFF),
    InventoryTransactionType.unknown => const Color(0xFFEFF2F6),
  };
}

/// Display up to three decimal places, keeping smaller nonzero quantities visible.
String formatInventoryQuantity(num value) =>
    _formatInventoryQuantity(value, places: value.abs() < 0.001 ? 9 : 3);

/// Keep the nine decimal places supported by stock and execution records.
String formatInventoryExactQuantity(num value, {String? exact}) =>
    _formatInventoryQuantity(value, places: 9, exact: exact);

String _formatInventoryQuantity(
  num value, {
  required int places,
  String? exact,
}) {
  if (!value.isFinite) return '—';
  final absolute = value.abs();
  final exactDigits = exact?.replaceFirst(RegExp(r'^-'), '');
  final decimal = exactDigits != null && _quantityPattern.hasMatch(exactDigits)
      ? exactDigits
      : absolute.toString();
  final fixed = decimal.contains('e') ? absolute.toStringAsFixed(9) : decimal;
  if (!_quantityPattern.hasMatch(fixed)) return '—';
  final parts = fixed.split('.');
  var whole = parts.first;
  final fraction = parts.length > 1 ? parts.last : '';
  final scale = places == 3 ? 1000 : 1000000000;
  var rounded = int.parse(fraction.padRight(places, '0').substring(0, places));
  if (fraction.length > places && int.parse(fraction[places]) >= 5) {
    rounded++;
  }
  if (rounded == scale) {
    whole = (BigInt.parse(whole) + BigInt.one).toString();
    rounded = 0;
  }
  final sign = value.isNegative && (whole != '0' || rounded != 0) ? '-' : '';
  final digits = groupVietnameseDigits(whole);
  if (rounded == 0) return '$sign$digits';
  final decimals = rounded
      .toString()
      .padLeft(places, '0')
      .replaceFirst(RegExp(r'0+$'), '');
  return '$sign$digits,$decimals';
}

final _quantityPattern = RegExp(r'^\d+(?:\.\d+)?$');

String formatInventoryMoney(num value, {bool showSubDong = false}) {
  if (!value.isFinite) return '—';
  if (showSubDong && value > 0 && value < 1) return '< 1 ₫';
  final amount = value.round();
  final sign = amount < 0 ? '-' : '';
  return '$sign${groupVietnameseDigits(amount.abs().toString())} ₫';
}

String formatInventoryDate(DateTime value, {bool includeTime = false}) {
  final local = value.toLocal();
  final date =
      '${local.day.toString().padLeft(2, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-${local.year}';
  if (!includeTime) return date;
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')} $date';
}

String inventoryPhotoLabel(int index) => switch (index) {
  0 => 'Mặt trước',
  1 => 'Mặt sau',
  _ => 'Ảnh ${index + 1}',
};

/// Round summary amounts to one decimal place in millions or billions.
String formatInventoryCompactMoney(num value) {
  if (!value.isFinite) return '—';
  final absolute = value.abs();
  if (absolute < 999999.5) return formatInventoryMoney(value);
  final millionTenths = (absolute / 100000).round();
  final billions = millionTenths >= 10000;
  final tenths = billions ? (absolute / 100000000).round() : millionTenths;
  final whole = groupVietnameseDigits((tenths ~/ 10).toString());
  final fraction = tenths % 10;
  final decimal = fraction == 0 ? '' : ',$fraction';
  final sign = value.isNegative ? '-' : '';
  final unit = billions ? 'tỷ' : 'tr';
  return '$sign$whole$decimal $unit ₫';
}
