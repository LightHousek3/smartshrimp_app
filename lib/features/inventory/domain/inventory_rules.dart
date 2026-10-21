import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

abstract final class InventoryRules {
  static const maxProductImages = 3;
  static const maxImageBytes = 5 * 1024 * 1024;

  static void validateImage(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxImageBytes) {
      throw const ApiException(
        'Ảnh vật tư phải có dung lượng từ 1 byte đến 5 MB.',
      );
    }
    final jpeg =
        bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff;
    final png =
        bytes.length >= 8 &&
        bytes.take(8).join(',') == '137,80,78,71,13,10,26,10';
    final webp =
        bytes.length >= 12 &&
        String.fromCharCodes(bytes.take(4)) == 'RIFF' &&
        String.fromCharCodes(bytes.skip(8).take(4)) == 'WEBP';
    if (!jpeg && !png && !webp) {
      throw const ApiException('Chọn ảnh JPG, PNG hoặc WebP.');
    }
  }

  static const maxNameLength = 255;
  static const maxDescriptionLength = 5000;
  static const maxLotLength = 100;
  static const maxSupplierLength = 255;
  static const maxReasonLength = 2000;
  static const maxQuantity = 99999999999.999;
  static const maxUnitPrice = 999999999999.99;
  static const maxConversionQuantity = 9999999999.9999;

  static String normalizeText(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static bool isPackaged(InventoryProductUnit unit) =>
      unit == InventoryProductUnit.pack || unit == InventoryProductUnit.bottle;

  static double? parseNumber(String? value) {
    final text = value?.trim() ?? '';
    if (!RegExp(r'^\d+(?:[.,]\d+)?$').hasMatch(text)) return null;
    final number = double.tryParse(text.replaceAll(',', '.'));
    return number != null && number.isFinite ? number : null;
  }

  static String? quantityError(String? value, {bool allowZero = false}) =>
      _numberError(
        value,
        label: allowZero ? 'Ngưỡng cảnh báo' : 'Số lượng',
        maximum: maxQuantity,
        precision: 3,
        allowZero: allowZero,
      );

  static String? unitPriceError(String? value) => _numberError(
    value,
    label: 'Đơn giá',
    maximum: maxUnitPrice,
    precision: 2,
    allowZero: true,
  );

  static String? conversionError(String? value) => _numberError(
    value,
    label: 'Số lượng quy đổi',
    maximum: maxConversionQuantity,
    precision: 4,
  );

  static String? _numberError(
    String? value, {
    required String label,
    required double maximum,
    required int precision,
    bool allowZero = false,
  }) {
    final number = parseNumber(value);
    if (number == null || (allowZero ? number < 0 : number <= 0)) {
      return '$label phải là số ${allowZero ? 'không âm' : 'lớn hơn 0'}';
    }
    if (number > maximum) return '$label vượt quá giới hạn cho phép';
    final parts = value!.trim().replaceAll(',', '.').split('.');
    final decimalPlaces = parts.length == 1
        ? 0
        : parts.last.replaceFirst(RegExp(r'0+$'), '').length;
    if (decimalPlaces > precision) {
      return '$label chỉ được có tối đa $precision chữ số thập phân';
    }
    return null;
  }

  static void validateConversion({
    required InventoryProductUnit unit,
    required double? conversionQuantity,
    required InventoryConversionUnit? conversionUnit,
  }) {
    final packaged = isPackaged(unit);
    if (packaged &&
        (conversionQuantity == null ||
            !conversionQuantity.isFinite ||
            conversionQuantity <= 0 ||
            conversionQuantity > maxConversionQuantity ||
            conversionUnit == null ||
            conversionUnit == InventoryConversionUnit.unknown)) {
      throw const FormatException(
        'Gói và chai phải có số lượng cùng đơn vị quy đổi.',
      );
    }
    if (!packaged && (conversionQuantity != null || conversionUnit != null)) {
      throw const FormatException(
        'Thông tin quy đổi chỉ áp dụng cho gói và chai.',
      );
    }
  }
}
