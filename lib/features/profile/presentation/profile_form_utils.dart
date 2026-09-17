import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';

abstract final class ProfileFormUtils {
  static String normalizeFullName(String value) =>
      ProfileRules.normalizeFullName(value);

  static String? validateFullName(String? value) =>
      ProfileRules.validateFullName(value);

  static String normalizePhone(String value) =>
      ProfileRules.normalizePhone(value);

  static String? validatePhone(String? value) =>
      ProfileRules.validatePhone(value);

  static String? validateCurrentPassword(String? value) =>
      ProfileRules.validateCurrentPassword(value);

  static String? validateNewPassword(String? value, String currentPassword) =>
      ProfileRules.validateNewPassword(value, currentPassword);

  static String? validatePasswordConfirmation(
    String? value,
    String newPassword,
  ) => ProfileRules.validatePasswordConfirmation(value, newPassword);

  static PasswordStrength passwordStrength(String password) =>
      ProfileRules.passwordStrength(password);
}
