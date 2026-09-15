import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

void main() {
  const account = <String, dynamic>{
    'id': '2ad2294a-8d7d-4a74-b17a-139ba35468e8',
    'email': 'owner@example.com',
    'fullName': 'Chủ trang trại',
    'role': 'FARM_OWNER',
    'status': 'ACTIVE',
  };

  test('parses the nested login response contract', () {
    final session = AuthSession.fromLoginData(<String, dynamic>{
      'account': account,
      'tokens': <String, dynamic>{
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
      },
    });

    expect(session.account.role, AccountRole.farmOwner);
    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
  });

  test('parses the flat refresh response contract', () {
    final session = AuthSession.fromRefreshData(<String, dynamic>{
      'account': account,
      'accessToken': 'new-access-token',
      'refreshToken': 'new-refresh-token',
    });

    expect(session.account.email, 'owner@example.com');
    expect(session.accessToken, 'new-access-token');
  });

  test('rejects malformed token data', () {
    expect(
      () => AuthSession.fromLoginData(<String, dynamic>{
        'account': account,
        'tokens': <String, dynamic>{'accessToken': ''},
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('maps future account role and status values to safe fallbacks', () {
    final parsed = AuthAccount.parse(<String, dynamic>{
      ...account,
      'role': 'NEW_ROLE',
      'status': 'NEW_STATUS',
    });

    expect(parsed.role, AccountRole.unknown);
    expect(parsed.status, AccountStatus.unknown);
  });

  test('rejects a malformed account payload at the parsing boundary', () {
    expect(
      () => AuthAccount.parse(<String, dynamic>{...account, 'id': 7}),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('supports generated value equality and copyWith', () {
    final original = AuthAccount.parse(account);
    final equalCopy = AuthAccount.parse(account);
    final renamed = original.copyWith(fullName: 'Tên mới');

    expect(original, equalCopy);
    expect(renamed.fullName, 'Tên mới');
    expect(original.fullName, 'Chủ trang trại');
  });
}
