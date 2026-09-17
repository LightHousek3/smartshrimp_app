import 'dart:convert';

enum PasswordStrength { tooShort, medium, fairlyStrong, strong }

abstract final class ProfileRules {
  static const int fullNameMinLength = 2;
  static const int fullNameMaxLength = 50;
  static const int passwordMinLength = 6;
  static const int passwordMaxBytes = 72;

  static final RegExp _fullNamePattern = RegExp(
    r'^\p{L}[\p{L}\p{M}]*\.?(?: \p{L}[\p{L}\p{M}]*\.?)*$',
    unicode: true,
  );
  static final RegExp _vietnameseMobilePattern = RegExp(
    r'^0(?:3[2-9]|5[25689]|7[06789]|8[1-9]|9[0-46-9])\d{7}$',
  );

  static String normalizeFullName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String? validateFullName(String? value) {
    final name = normalizeFullName(value ?? '');
    final length = name.runes.length;
    if (length < fullNameMinLength) {
      return 'Họ và tên phải có ít nhất $fullNameMinLength ký tự.';
    }
    if (length > fullNameMaxLength) {
      return 'Họ và tên không được vượt quá $fullNameMaxLength ký tự.';
    }
    if (!_fullNamePattern.hasMatch(name)) {
      return 'Họ và tên chỉ được chứa chữ cái, khoảng trắng và dấu chấm cuối từ.';
    }
    return null;
  }

  static String normalizePhone(String value) {
    final compact = value.trim().replaceAll(RegExp(r'[\s.()\-]'), '');
    return compact.startsWith('+84') ? '0${compact.substring(3)}' : compact;
  }

  static String? validatePhone(String? value) {
    final phone = normalizePhone(value ?? '');
    if (phone.isEmpty) return null;
    if (!_vietnameseMobilePattern.hasMatch(phone)) {
      return 'Số điện thoại không đúng định dạng Việt Nam.';
    }
    return null;
  }

  static String? validateCurrentPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại.';
    if (utf8.encode(password).length > passwordMaxBytes) {
      return 'Mật khẩu quá dài. Vui lòng sử dụng mật khẩu ngắn hơn.';
    }
    return null;
  }

  static String? validateNewPassword(String? value, String currentPassword) {
    final password = value ?? '';
    if (password.runes.length < passwordMinLength) {
      return 'Mật khẩu mới cần ít nhất $passwordMinLength ký tự.';
    }
    if (utf8.encode(password).length > passwordMaxBytes) {
      return 'Mật khẩu quá dài. Vui lòng sử dụng mật khẩu ngắn hơn.';
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

  static PasswordStrength passwordStrength(String password) {
    final length = password.runes.length;
    if (length < passwordMinLength) return PasswordStrength.tooShort;

    final groups = <bool>[
      RegExp('[a-z]').hasMatch(password),
      RegExp('[A-Z]').hasMatch(password),
      RegExp(r'\d').hasMatch(password),
      RegExp(r'[^A-Za-z0-9]').hasMatch(password),
    ].where((matched) => matched).length;

    if (length >= 12 && groups == 4) return PasswordStrength.strong;
    if (length >= 8 && groups >= 3) return PasswordStrength.fairlyStrong;
    return PasswordStrength.medium;
  }
}
