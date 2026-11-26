final _localized = RegExp(r'^[-+]?(?:\d+|[1-9]\d{0,2}(?:\.\d{3})+)(?:,\d+)?$');
final _leadingComma = RegExp(r'^([-+]?),([0-9]+)$');
final _plainDecimal = RegExp(r'^[-+]?(?:\d+\.\d+|\.\d+)$');
final _groups = RegExp(r'\B(?=(\d{3})+$)');
final _trailingZeroes = RegExp(r'0+$');

/// Parse display text. A complete group such as 1.250 means 1250.
String? normalizeVietnameseNumber(String? value, {bool groupThousands = true}) {
  final text = value?.trim() ?? '';
  final leadingComma = _leadingComma.firstMatch(text);
  if (leadingComma != null) {
    return '${leadingComma[1]}0.${leadingComma[2]}';
  }
  if (groupThousands && _localized.hasMatch(text)) {
    return text.replaceAll('.', '').replaceFirst(',', '.');
  }
  if (!groupThousands && !text.contains('.')) {
    return _localized.hasMatch(text) ? text.replaceFirst(',', '.') : null;
  }
  if (!_plainDecimal.hasMatch(text)) return null;
  return text.replaceFirstMapped(RegExp(r'^([-+]?)\.'), (m) => '${m[1]}0.');
}

double? parseVietnameseNumber(String? value) {
  final number = double.tryParse(normalizeVietnameseNumber(value) ?? '');
  return number?.isFinite == true ? number : null;
}

int? parseVietnameseInteger(String? value) =>
    int.tryParse(normalizeVietnameseNumber(value) ?? '');

String groupVietnameseDigits(String digits) => digits.replaceAll(_groups, '.');

/// Format API decimals, whose decimal separator is a dot.
String formatVietnameseDecimal(String value, {bool trimTrailingZeroes = true}) {
  final [whole, ...fraction] = value.split('.');
  final raw = fraction.firstOrNull;
  final decimals = trimTrailingZeroes
      ? raw?.replaceFirst(_trailingZeroes, '')
      : raw;
  return '${groupVietnameseDigits(whole)}'
      '${decimals == null || decimals.isEmpty ? '' : ',$decimals'}';
}

String formatVietnameseNumber(num? value, {int? decimalPlaces}) {
  if (value == null || !value.isFinite) return '';
  if (value is int) return groupVietnameseDigits(value.toString());
  final plain = decimalPlaces == null
      ? value.toString()
      : value.toStringAsFixed(decimalPlaces);
  if (!plain.contains('e')) return formatVietnameseDecimal(plain);
  final [mantissa, exponent] = plain.split('e');
  final sign = mantissa.startsWith('-') ? '-' : '';
  final parts = mantissa.substring(sign.length).split('.');
  final digits = parts.join();
  final decimalAt = parts.first.length + int.parse(exponent);
  if (decimalAt <= 0) {
    return '${sign}0,${'0' * -decimalAt}$digits';
  }
  if (decimalAt >= digits.length) {
    return '$sign${groupVietnameseDigits(digits.padRight(decimalAt, '0'))}';
  }
  return formatVietnameseDecimal(
    '$sign${digits.substring(0, decimalAt)}.${digits.substring(decimalAt)}',
  );
}
