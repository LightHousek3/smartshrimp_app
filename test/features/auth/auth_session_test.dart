import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';

void main() {
  const user = <String, dynamic>{
    'id': '2ad2294a-8d7d-4a74-b17a-139ba35468e8',
    'email': 'owner@example.com',
    'fullName': 'Chủ trang trại',
    'role': 'FARM_OWNER',
    'status': 'ACTIVE',
  };

  test('parses the nested login response contract', () {
    final session = AuthSession.fromLoginData(<String, dynamic>{
      'user': user,
      'tokens': <String, dynamic>{
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
      },
    });

    expect(session.user.role, AppUserRole.farmOwner);
    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
  });

  test('parses the flat refresh response contract', () {
    final session = AuthSession.fromRefreshData(<String, dynamic>{
      'user': user,
      'accessToken': 'new-access-token',
      'refreshToken': 'new-refresh-token',
    });

    expect(session.user.email, 'owner@example.com');
    expect(session.accessToken, 'new-access-token');
  });

  test('rejects malformed token data', () {
    expect(
      () => AuthSession.fromLoginData(<String, dynamic>{
        'user': user,
        'tokens': <String, dynamic>{'accessToken': ''},
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}
