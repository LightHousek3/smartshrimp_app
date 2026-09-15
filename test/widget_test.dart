import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

void main() {
  testWidgets('login validates required fields', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(_testApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đăng nhập').last);
    await tester.pump();

    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
    expect(repository.loginCalls, 0);
  });

  testWidgets('successful login redirects to the five-tab home shell', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(_testApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      '  KTV@Example.com  ',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'secret123',
    );
    await tester.tap(find.text('Đăng nhập').last);
    await tester.pumpAndSettle();

    expect(repository.loginCalls, 1);
    expect(repository.lastEmail, '  KTV@Example.com  ');
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Vụ nuôi'), findsOneWidget);
    expect(find.text('Nhiệm vụ'), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Tài khoản'), findsOneWidget);
  });
}

Widget _testApp(AuthRepository repository) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: const SmartShrimpApp(),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  int loginCalls = 0;
  String? lastEmail;

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastEmail = email;
    return const AuthAccount(
      id: '2ad2294a-8d7d-4a74-b17a-139ba35468e8',
      email: 'ktv@example.com',
      fullName: 'Nguyễn Văn Bảo',
      role: AccountRole.technician,
      status: AccountStatus.active,
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => null;
}
