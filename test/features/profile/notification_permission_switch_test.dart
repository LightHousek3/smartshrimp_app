import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_providers.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';
import 'package:smartshrimp_app/features/profile/presentation/widgets/notification_permission_switch.dart';

final class _AuthRepository implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'owner-one',
    email: 'owner@example.com',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );

  @override
  Future<void> logout() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _Push implements PushRepository {
  PushPermission allowed = PushPermission.denied;
  Completer<PushPermission>? held;
  Object? permissionError;
  Object? settingsError;
  Completer<PushPermission>? registration;
  bool failRegistration = true;
  int registrations = 0;
  int opened = 0;
  int reads = 0;

  @override
  Future<PushPermission> permission() async {
    reads++;
    if (permissionError case final error?) throw error;
    return held?.future ?? allowed;
  }

  @override
  Future<void> openSettings() async {
    opened++;
    if (settingsError case final error?) throw error;
  }

  @override
  Future<PushPermission> register(
    String accountId, {
    bool requestPermission = true,
  }) async {
    registrations++;
    if (registration != null) return registration!.future;
    if (failRegistration) {
      throw const ApiException('Không thể đăng ký thông báo.');
    }
    return allowed;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _open(WidgetTester tester, _Push push) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_AuthRepository()),
        pushRepositoryProvider.overrideWithValue(push),
      ],
      child: const MaterialApp(
        home: Scaffold(body: Center(child: NotificationPermissionSwitch())),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
    tester.element(find.byType(NotificationPermissionSwitch)),
  );
}

void main() {
  final toggle = find.byKey(const Key('account_notification_switch'));

  for (final permission in PushPermission.values) {
    testWidgets('permission ${permission.name} reflects actual device access', (
      tester,
    ) async {
      await _open(tester, _Push()..allowed = permission);
      final widget = tester.widget<Switch>(toggle);
      final enabled = [
        PushPermission.authorized,
        PushPermission.provisional,
      ].contains(permission);
      expect(widget.value, enabled);
      expect(
        widget.onChanged != null,
        enabled || permission == PushPermission.denied,
      );
    });
  }

  testWidgets('enable dialog can be cancelled without changing permission', (
    tester,
  ) async {
    final push = _Push();
    await _open(tester, push);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Bật thông báo'), findsOneWidget);
    expect(find.text('Mở cài đặt'), findsOneWidget);
    await tester.tap(find.text('Để sau'));
    await tester.pumpAndSettle();
    expect(push.opened, 0);
    expect(tester.widget<Switch>(toggle).value, isFalse);
  });

  testWidgets('settings opens once and refresh uses the actual OS result', (
    tester,
  ) async {
    final push = _Push();
    final container = await _open(tester, push);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mở cài đặt'));
    await tester.pumpAndSettle();
    expect(push.opened, 1);
    expect(tester.widget<Switch>(toggle).value, isFalse);
    push.allowed = PushPermission.authorized;
    container.invalidate(notificationPermissionProvider);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isTrue);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Tắt thông báo'), findsOneWidget);
    await tester.tap(find.text('Mở cài đặt'));
    await tester.pumpAndSettle();
    push.allowed = PushPermission.denied;
    container.invalidate(notificationPermissionProvider);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    expect(push.opened, 2);
  });

  testWidgets('registration failure does not turn granted OS permission off', (
    tester,
  ) async {
    final container = await _open(
      tester,
      _Push()..allowed = PushPermission.authorized,
    );
    await expectLater(
      container.read(pushStatusProvider.future),
      throwsA(isA<ApiException>()),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isTrue);
  });

  testWidgets('a settings recheck waits for registration already in progress', (
    tester,
  ) async {
    final gate = Completer<PushPermission>();
    final push = _Push()..registration = gate;
    final container = await _open(tester, push);
    final initial = container.read(pushStatusProvider.future);
    await tester.pump();
    expect(push.registrations, 1);
    final recheck = container.read(pushStatusProvider.notifier).synchronize();
    push.registration = null;
    push.failRegistration = false;
    gate.complete(PushPermission.authorized);
    await initial;
    await recheck;
    expect(push.registrations, 2);
    expect(container.read(pushStatusProvider).value, PushPermission.denied);
  });

  testWidgets(
    'permission failure can retry and settings failure is localized',
    (tester) async {
      final push = _Push()..permissionError = StateError('native failure');
      await _open(tester, push);
      expect(toggle, findsNothing);
      expect(find.textContaining('native failure'), findsNothing);
      push.permissionError = null;
      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(toggle).value, isFalse);
      push.settingsError = const ApiException('Không thể mở Cài đặt.');
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mở cài đặt'));
      await tester.pumpAndSettle();
      expect(find.text('Không thể mở Cài đặt.'), findsOneWidget);
      expect(tester.widget<Switch>(toggle).value, isFalse);
    },
  );

  testWidgets(
    'session ending while dialog is open prevents a stale settings action',
    (tester) async {
      final push = _Push();
      final container = await _open(tester, push);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      await container.read(authControllerProvider.notifier).logout();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mở cài đặt'));
      await tester.pumpAndSettle();
      expect(push.opened, 0);
      expect(tester.widget<Switch>(toggle).onChanged, isNull);
    },
  );
}
