import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

abstract final class AuthFormRules {
  static String? email(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (email.length > 320 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  static String? password(String? value) => (value ?? '').isEmpty
      ? 'Vui lòng nhập mật khẩu.'
      : ProfileRules.validateNewPassword(value, '');

  static String? confirmation(String? value, String password) =>
      (value ?? '').isEmpty
      ? 'Vui lòng xác nhận mật khẩu.'
      : ProfileRules.validatePasswordConfirmation(value, password);

  static String? fullName(String? value) => (value ?? '').trim().isEmpty
      ? 'Vui lòng nhập họ và tên.'
      : ProfileRules.validateFullName(value);
}
