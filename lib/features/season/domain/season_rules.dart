abstract final class SeasonRules {
  static const nameMaxLength = 255;

  static String normalizeText(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String? validateName(String? value) {
    final normalized = normalizeText(value ?? '');
    if (normalized.isEmpty) return 'Vui lòng nhập tên vụ nuôi.';
    if (normalized.length > nameMaxLength) {
      return 'Tên vụ nuôi không được quá $nameMaxLength ký tự.';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final quantity = int.tryParse(text);
    if (quantity == null || quantity <= 0) {
      return 'Số lượng phải là số nguyên lớn hơn 0.';
    }
    return null;
  }

  static String? validateAverageWeight(String? value) {
    final text = value?.trim().replaceAll(',', '.') ?? '';
    if (text.isEmpty) return null;
    final weight = double.tryParse(text);
    if (weight == null || weight <= 0) {
      return 'Khối lượng phải là số lớn hơn 0.';
    }
    final decimals = text.contains('.') ? text.split('.').last.length : 0;
    if (decimals > 3) return 'Chỉ nhập tối đa 3 chữ số thập phân.';
    return null;
  }

  static String? validateDateRange(DateTime? stocking, DateTime? expectedEnd) {
    if (stocking != null &&
        expectedEnd != null &&
        expectedEnd.isBefore(stocking)) {
      return 'Ngày kết thúc dự kiến phải từ ngày thả giống trở đi.';
    }
    return null;
  }

  static String? validateCancellationReason(String? value) =>
      normalizeText(value ?? '').isEmpty ? 'Vui lòng nhập lý do hủy.' : null;

  static int? parseQuantity(String value) =>
      value.trim().isEmpty ? null : int.tryParse(value.trim());

  static double? parseWeight(String value) => value.trim().isEmpty
      ? null
      : double.tryParse(value.trim().replaceAll(',', '.'));

  static String dateOnly(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
