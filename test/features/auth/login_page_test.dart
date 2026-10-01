import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/login_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

void main() {
  testWidgets('shows button loading and keeps credentials after login error', (
    tester,
  ) async {
    final repository = _LoginAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(home: LoginPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'owner@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'wrong-password',
    );
    await tester.tap(
      find.descendant(
        of: find.byType(GradientButton),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pump();

    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.email, 'owner@example.com');
    expect(repository.password, 'wrong-password');

    repository.loginCompleter.completeError(
      const ApiException('Email hoặc mật khẩu không đúng.', statusCode: 401),
      StackTrace.current,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppFormErrorBanner), findsOneWidget);
    expect(find.text('Không thể đăng nhập'), findsOneWidget);
    expect(find.text('Email hoặc mật khẩu không đúng.'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('login_email_field')))
          .controller!
          .text,
      'owner@example.com',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('login_password_field')))
          .controller!
          .text,
      'wrong-password',
    );
  });
}

final class _LoginAuthRepository implements AuthRepository {
  final Completer<AuthAccount> loginCompleter = Completer<AuthAccount>();

  String? email;
  String? password;

  @override
  Future<AuthAccount> login({required String email, required String password}) {
    this.email = email;
    this.password = password;
    return loginCompleter.future;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => null;
}
