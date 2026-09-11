import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';

void main() {
  group('profile validation', () {
    test('normalizes and accepts supported Vietnamese phone formats', () {
      expect(ProfileFormUtils.normalizePhone('0912 345 678'), '0912345678');
      expect(ProfileFormUtils.validatePhone('0912 345 678'), isNull);
      expect(ProfileFormUtils.validatePhone('+84 912 345 678'), isNull);
      expect(ProfileFormUtils.validatePhone('phone'), isNotNull);
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
  });
}
