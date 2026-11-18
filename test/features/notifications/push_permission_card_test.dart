import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/push_permission_card.dart';

final class _AuthRepository implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'account-one',
    email: 'owner@example.com',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _PushRepository implements PushRepository {
  Completer<PushPermission>? registration;
  int calls = 0;
  PushPermission allowed = PushPermission.unconfigured;
  Object? settingsError;

  @override
  Future<void> openSettings() async {
    if (settingsError case final error?) throw error;
  }

  @override
  Future<PushPermission> register(
    String accountId, {
    bool requestPermission = true,
  }) async {
    calls++;
    return registration?.future ?? allowed;
  }

  @override
  void suspend() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _open(WidgetTester tester, _PushRepository repository) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_AuthRepository()),
        pushRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(home: Scaffold(body: PushPermissionCard())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a failed settings launch shows a localized notice', (
    tester,
  ) async {
    await _open(
      tester,
      _PushRepository()
        ..allowed = PushPermission.denied
        ..settingsError = const ApiException('Không thể mở Cài đặt.'),
    );
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();
    expect(find.text('Không thể mở Cài đặt.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'retry shows progress, prevents duplicate taps and exposes localized errors',
    (tester) async {
      final repository = _PushRepository();
      await _open(tester, repository);
      repository.registration = Completer<PushPermission>();

      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed,
        isNull,
      );

      repository.registration!.completeError(
        const ApiException(
          'Chưa thể kết nối dịch vụ thông báo. Vui lòng thử lại.',
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Chưa thể kết nối dịch vụ thông báo. Vui lòng thử lại.'),
        findsOneWidget,
      );
      expect(repository.calls, 2);

      repository.registration = Completer<PushPermission>();
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      repository.registration!.complete(PushPermission.authorized);
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsNothing);
      expect(repository.calls, 3);
    },
  );

  testWidgets('unexpected errors keep a safe Vietnamese fallback', (
    tester,
  ) async {
    final repository = _PushRepository();
    await _open(tester, repository);
    repository.registration = Completer<PushPermission>();
    await tester.tap(find.text('Thử lại'));
    await tester.pump();
    repository.registration!.completeError(
      StateError('native configuration failed'),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Chưa thể nhận thông báo trên thiết bị.'),
      findsOneWidget,
    );
    expect(find.textContaining('native configuration failed'), findsNothing);
    expect(find.text('Thử lại'), findsOneWidget);
  });
}
