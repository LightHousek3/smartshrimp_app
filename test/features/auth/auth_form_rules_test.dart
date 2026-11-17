import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/auth_form_rules.dart';

void main() {
  for (final value in [
    'a@example.com',
    'a+b@example.com',
    ' A.B@Example.com ',
    'a@b.c',
    'a@example.invalid',
  ]) {
    test('accepts supported email syntax: $value', () {
      expect(AuthFormRules.email(value), isNull);
    });
  }
  for (final value in [
    '',
    'bad-email',
    'a..b@example.com',
    '.a@example.com',
    'a@example.12',
    'a@x.1a',
    'a@-bad.com',
    'a@bad_.com',
    'á@example.com',
    'a@127.0.0.1',
    '${'a' * 65}@example.com',
  ]) {
    test('rejects malformed email in Vietnamese: $value', () {
      final message = AuthFormRules.email(value);
      expect(message, isNotNull);
      expect(message, isNot(contains('must be')));
    });
  }
  test('email maximum matches the backend address limit', () {
    final value = '${'a' * 64}@${'b' * 63}.${'c' * 63}.${'d' * 61}';
    expect(value.length, 254);
    expect(AuthFormRules.email(value), isNull);
    expect(AuthFormRules.email('${value}d'), contains('254'));
  });
}
