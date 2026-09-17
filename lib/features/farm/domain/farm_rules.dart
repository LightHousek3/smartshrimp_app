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
    return normalized.isEmpty ? null : double.tryParse(normalized);
  }

  static String? validateArea(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    final normalized = raw.replaceAll(',', '.');
    final area = double.tryParse(normalized);
    if (area == null) return 'Diện tích phải là một số hợp lệ.';
    if (area <= 0 || area > maxAreaHectares) {
      return 'Diện tích phải lớn hơn 0 và không vượt quá $maxAreaHectares ha.';
    }
    if (!RegExp(r'^\d+(?:[.,]\d{1,2})?$').hasMatch(raw)) {
      return 'Diện tích chỉ được có tối đa 2 chữ số thập phân.';
    }
    return null;
  }
}
