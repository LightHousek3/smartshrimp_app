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
    InventoryProductUnit.pcs => 'cái',
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

String formatInventoryQuantity(num value) {
  final number = value.toDouble();
  final parts = number
      .toStringAsFixed(9)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '')
      .split('.');
  final digits = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[index]);
  }
  if (parts.length == 2 && parts.last.isNotEmpty) {
    buffer.write(',${parts.last}');
  }
  return buffer.toString();
}

String formatInventoryMoney(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[index]);
  }
  return '${buffer.toString()} ₫';
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

/// Short money labels keep summary tiles readable; detailed amounts stay exact.
String formatInventoryCompactMoney(num value) {
  if (value.abs() < 1000000) return formatInventoryMoney(value);
  final divisor = value.abs() >= 1000000000 ? 1000000000 : 1000000;
  final suffix = divisor == 1000000000 ? 'tỷ' : 'tr';
  final amount = (value / divisor)
      .toStringAsFixed(1)
      .replaceFirst(RegExp(r'\.0$'), '')
      .replaceAll('.', ',');
  return '$amount $suffix ₫';
}
