abstract final class PondRules {
  static const nameMaxLength = 255;
  static const maxAreaM2 = 9999999999.99;
  static const maxDepthM = 9999.99;
  static const maxVolumeM3 = 999999999999.99;

  static String normalizeName(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String? validateName(String? value) {
    final name = normalizeName(value ?? '');
    if (name.isEmpty) return 'Vui lòng nhập tên ao.';
    if (name.length > nameMaxLength) {
      return 'Tên ao không được vượt quá $nameMaxLength ký tự.';
    }
    return null;
  }

  static double? parseNumber(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    return normalized.isEmpty ? null : double.tryParse(normalized);
  }

  static String? validatePositiveNumber(
    String? value,
    String label, {
    bool required = false,
    double? max,
  }) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return required ? 'Vui lòng nhập $label.' : null;
    final number = parseNumber(raw);
    if (number == null || !number.isFinite || number <= 0) {
      return '$label phải là số lớn hơn 0.';
    }
    if (!RegExp(r'^\d+(?:[.,]\d{1,2})?$').hasMatch(raw)) {
      return '$label chỉ được có tối đa 2 chữ số thập phân.';
    }
    if (max != null && number > max) {
      return '$label không được vượt quá ${_formatLimit(max)}.';
    }
    return null;
  }

  static String? validateArea(String? value) => validatePositiveNumber(
    value,
    'Diện tích',
    required: true,
    max: maxAreaM2,
  );

  static String? validateDepth(String? value) =>
      validatePositiveNumber(value, 'Độ sâu', required: true, max: maxDepthM);

  static String? validateCalculatedVolume(double areaM2, double depthM) {
    if (areaM2 * depthM > maxVolumeM3) {
      return 'Thể tích tính từ diện tích và độ sâu vượt quá '
          '${_formatLimit(maxVolumeM3)} m³.';
    }
    return null;
  }

  static String _formatLimit(double value) =>
      value.toStringAsFixed(2).replaceFirst(RegExp(r'\.00$'), '');
}
