import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

abstract final class AuthFormRules {
  static const emailMaxLength = 254;

  static String? email(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (email.length > emailMaxLength) {
      return 'Email không được vượt quá $emailMaxLength ký tự.';
    }
    final parts = email.split('@');
    final local = parts.first;
    final domain = parts.length == 2 ? parts.last : '';
    final labels = domain.split('.');
    final validLocal = RegExp(
      r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*$",
    );
    final validLabel = RegExp(
      r'^[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$',
    );
    if (parts.length != 2 ||
        local.length > 64 ||
        !validLocal.hasMatch(local) ||
        labels.length < 2 ||
        !labels.every(validLabel.hasMatch) ||
        !RegExp(r'^[a-zA-Z]').hasMatch(labels.last)) {
      return 'Email không hợp lệ. Ví dụ: ten@trangtrai.vn.';
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
