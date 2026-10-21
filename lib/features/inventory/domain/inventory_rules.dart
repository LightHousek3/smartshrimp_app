import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

/// Keep client validation aligned with inventory API limits and SQL precision.
abstract final class InventoryRules {
  static const maxProductImages = 3;
  static const maxImageBytes = 5 * 1024 * 1024;

  /// Check size and file signatures instead of trusting names or MIME metadata.
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
  static const maxDescriptionLength = 500;
  static const maxLotLength = 100;
  static const maxSupplierLength = 255;
  static const maxReasonLength = 255;
  static const maxQuantity = 99999999999.999;
  static const maxUnitPrice = 999999999999.99;
  static const maxConversionQuantity = 9999999999.9999;

  /// Preserve decimal text all the way to the API instead of rounding through double.
  static String normalizedQuantity(String text) {
    final normalized = text.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(normalized)) {
      throw const FormatException('Số lượng không hợp lệ');
    }
    final parts = normalized.split('.');
    final fraction = parts.length == 1
        ? ''
        : parts[1].replaceFirst(RegExp(r'0+$'), '');
    if (BigInt.parse(parts[0]) > BigInt.from(99999999999) ||
        fraction.length > 9) {
      throw const FormatException('Số lượng vượt giới hạn');
    }
    final integer = BigInt.parse(parts[0]).toString();
    return fraction.isEmpty ? integer : '$integer.$fraction';
  }

  static String dateText(DateTime date) => [
    date.year.toString().padLeft(4, '0'),
    date.month.toString().padLeft(2, '0'),
    date.day.toString().padLeft(2, '0'),
  ].join('-');

  static String normalizeText(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static bool isPackaged(InventoryProductUnit unit) =>
      unit == InventoryProductUnit.pack || unit == InventoryProductUnit.bottle;

  /// Accept decimal commas or dots without interpreting grouping or exponents.
  static double? parseNumber(String? value) {
    final text = value?.trim() ?? '';
    if (!RegExp(r'^\d+(?:[.,]\d+)?$').hasMatch(text)) return null;
    final number = double.tryParse(text.replaceAll(',', '.'));
    return number != null && number.isFinite ? number : null;
  }

  static String? quantityError(String? value, {bool allowZero = false}) {
    if (!allowZero) {
      try {
        normalizedQuantity(value ?? '');
      } on FormatException {
        return 'Số lượng phải nằm trong giới hạn và tối đa 9 chữ số thập phân';
      }
    }
    return _numberError(
      value,
      label: allowZero ? 'Ngưỡng cảnh báo' : 'Số lượng',
      maximum: allowZero ? maxQuantity : 100000000000,
      precision: allowZero ? 3 : 9,
      allowZero: allowZero,
    );
  }

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

  /// Require a valid conversion pair for packages and reject it for other units.
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
