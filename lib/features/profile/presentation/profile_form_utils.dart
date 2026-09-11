import 'dart:convert';

abstract final class ProfileFormUtils {
  static String? validateFullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Họ và tên không được để trống.';
    if (name.length > 255) return 'Họ và tên không được vượt quá 255 ký tự.';
    return null;
  }

  static String normalizePhone(String value) {
    return value.replaceAll(RegExp(r'[\s.-]'), '');
  }

  static String? validatePhone(String? value) {
    final phone = normalizePhone(value?.trim() ?? '');
    if (phone.isEmpty) return null;
    if (!RegExp(r'^(?:\+?[1-9]\d{7,14}|0\d{8,10})$').hasMatch(phone)) {
      return 'Số điện thoại không hợp lệ.';
    }
    return null;
  }

  static String? validateCurrentPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại.';
    if (utf8.encode(password).length > 72) {
      return 'Mật khẩu không được vượt quá 72 byte.';
    }
    return null;
  }

  static String? validateNewPassword(String? value, String currentPassword) {
    final password = value ?? '';
    if (password.length < 6) return 'Mật khẩu mới cần ít nhất 6 ký tự.';
    if (utf8.encode(password).length > 72) {
      return 'Mật khẩu không được vượt quá 72 byte.';
    }
    if (password == currentPassword) {
      return 'Mật khẩu mới phải khác mật khẩu hiện tại.';
    }
    return null;
  }

  static String? validatePasswordConfirmation(
    String? value,
    String newPassword,
  ) {
    if ((value ?? '').isEmpty) return 'Vui lòng xác nhận mật khẩu mới.';
    if (value != newPassword) return 'Mật khẩu nhập lại không khớp.';
    return null;
  }
}
