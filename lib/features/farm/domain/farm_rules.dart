abstract final class FarmRules {
  static const nameMaxLength = 255;
  static const addressMaxLength = 1000;
  static const maxAreaHectares = 99999999.99;

  static String normalizeText(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String? validateName(String? value) {
    final normalized = normalizeText(value ?? '');
    if (normalized.isEmpty) return 'Vui lòng nhập tên trang trại.';
    if (normalized.length > nameMaxLength) {
      return 'Tên trang trại không được vượt quá $nameMaxLength ký tự.';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    final normalized = normalizeText(value ?? '');
    if (normalized.length > addressMaxLength) {
      return 'Địa chỉ không được vượt quá $addressMaxLength ký tự.';
    }
    return null;
  }

  static double? parseArea(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    final area = double.tryParse(normalized);
    if (area == null || !area.isFinite) return null;
    return _roundAreaText(normalized);
  }

  /// Rounds an area value to the precision supported by the database.
  static double? roundArea(double? area) {
    if (area == null || !area.isFinite) return area;
    return _roundAreaText(area.toString());
  }

  static double? _roundAreaText(String value) {
    final parts = value.split('.');
    if (parts.length > 2 || parts.any((part) => part.contains('e'))) {
      final area = double.tryParse(value);
      return area == null || !area.isFinite
          ? null
          : double.parse(area.toStringAsFixed(2));
    }

    final isNegative = parts.first.startsWith('-');
    final wholeText = switch (parts.first) {
      '' || '-' || '+' => '0',
      _ => parts.first.replaceFirst(RegExp(r'^[-+]'), ''),
    };
    final whole = BigInt.tryParse(wholeText);
    if (whole == null) return null;
    final fraction = parts.length == 2 ? parts[1] : '';
    if (fraction.isNotEmpty && !RegExp(r'^\d+$').hasMatch(fraction)) {
      return null;
    }

    final hundredths = fraction.padRight(2, '0').substring(0, 2);
    var cents = whole * BigInt.from(100) + BigInt.parse(hundredths);
    if (fraction.length > 2 && int.parse(fraction[2]) >= 5) {
      cents += BigInt.one;
    }
    final rounded = cents.toDouble() / 100;
    return isNegative ? -rounded : rounded;
  }

  static double? parseCoordinate(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    return normalized.isEmpty ? null : double.tryParse(normalized);
  }

  static String? validateLatitude(String? value) =>
      _validateCoordinate(value, label: 'Vĩ độ', minimum: -90, maximum: 90);

  static String? validateLongitude(String? value) =>
      _validateCoordinate(value, label: 'Kinh độ', minimum: -180, maximum: 180);

  static String? validateCoordinatePair(String latitude, String longitude) {
    if (latitude.trim().isEmpty != longitude.trim().isEmpty) {
      return 'Vui lòng nhập đủ cả vĩ độ và kinh độ.';
    }
    return validateLatitude(latitude) ?? validateLongitude(longitude);
  }

  static String? _validateCoordinate(
    String? value, {
    required String label,
    required double minimum,
    required double maximum,
  }) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    final coordinate = parseCoordinate(raw);
    if (coordinate == null) return '$label phải là một số hợp lệ.';
    if (coordinate < minimum || coordinate > maximum) {
      return '$label phải nằm trong khoảng $minimum đến $maximum.';
    }
    if (!RegExp(r'^[-+]?\d+(?:[.,]\d{1,8})?$').hasMatch(raw)) {
      return '$label chỉ được có tối đa 8 chữ số thập phân.';
    }
    return null;
  }

  static String? validateArea(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    final normalized = raw.replaceAll(',', '.');
    final area = parseArea(normalized);
    if (area == null) return 'Diện tích phải là một số hợp lệ.';
    if (area <= 0 || area > maxAreaHectares) {
      return 'Diện tích phải lớn hơn 0 và không vượt quá $maxAreaHectares ha.';
    }
    return null;
  }
}
