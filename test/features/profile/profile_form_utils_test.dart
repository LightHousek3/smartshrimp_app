import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';

void main() {
  group('profile validation', () {
    test('normalizes and accepts supported Vietnamese phone formats', () {
      expect(ProfileFormUtils.normalizePhone('0912 345 678'), '0912345678');
      expect(
        ProfileFormUtils.normalizePhone('+84 (912) 345-678'),
        '0912345678',
      );
      expect(ProfileFormUtils.validatePhone('0912 345 678'), isNull);
      expect(ProfileFormUtils.validatePhone('+84 912 345 678'), isNull);
      expect(ProfileFormUtils.validatePhone('0123 456 789'), isNotNull);
      expect(ProfileFormUtils.validatePhone('phone'), isNotNull);
    });

    test('normalizes and validates Vietnamese full names', () {
      expect(
        ProfileFormUtils.normalizeFullName('  TS.   Nguyễn Thị Mai Anh  '),
        'TS. Nguyễn Thị Mai Anh',
      );
      expect(ProfileFormUtils.validateFullName('Đỗ An.'), isNull);
      expect(ProfileFormUtils.validateFullName('A'), isNotNull);
      expect(ProfileFormUtils.validateFullName('Nguyễn @ An'), isNotNull);
      expect(ProfileFormUtils.validateFullName('Nguyễn 123'), isNotNull);
      expect(
        ProfileFormUtils.validateFullName(List<String>.filled(51, 'A').join()),
        isNotNull,
      );
    });

    test('validates password boundaries and confirmation', () {
      final password72Bytes = List<String>.filled(36, 'é').join();
      expect(ProfileFormUtils.validateNewPassword('12345', 'old'), isNotNull);
      expect(ProfileFormUtils.validateNewPassword('123456', 'old'), isNull);
      expect(
        ProfileFormUtils.validateNewPassword(password72Bytes, 'old'),
        isNull,
      );
      expect(
        ProfileFormUtils.validateNewPassword('${password72Bytes}a', 'old'),
        isNotNull,
      );
      expect(
        ProfileFormUtils.validatePasswordConfirmation('654321', '123456'),
        isNotNull,
      );
    });

    test('classifies password strength with the shared thresholds', () {
      expect(
        ProfileFormUtils.passwordStrength('12345'),
        PasswordStrength.tooShort,
      );
      expect(
        ProfileFormUtils.passwordStrength('123456'),
        PasswordStrength.medium,
      );
      expect(
        ProfileFormUtils.passwordStrength('Abcdef1!'),
        PasswordStrength.fairlyStrong,
      );
      expect(
        ProfileFormUtils.passwordStrength('Abcdefghij1!'),
        PasswordStrength.strong,
      );
    });
  });
}
