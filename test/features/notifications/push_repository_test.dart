import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/data/repositories/push_repository_impl.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_api_service.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_messaging_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

final class _Api implements PushRemoteDataSource {
  final bindings = <String>[];
  int removals = 0;
  Completer<void>? held;
  bool fail = false;
  @override
  Future<void> register(String token, String platform) async {
    bindings.add(token);
    if (held != null) await held!.future;
    if (fail) throw const ApiException('Không thể đăng ký');
  }

  @override
  Future<void> unregister() async {
    removals++;
  }
}

final class _Transport implements PushMessagingTransport {
  final foregroundEvents = StreamController<RemoteMessage>.broadcast();
  final openedEvents = StreamController<RemoteMessage>.broadcast();
  final localEvents = StreamController<Map<String, dynamic>>.broadcast();
  final changes = StreamController<String>.broadcast();
  final shown = <String>[];
  bool ready = true;
  bool showFails = false;
  int clears = 0;
  int requested = 0;
  String? identifier = 'installation-one';
  Map<String, dynamic>? initial;
  PushPermission allowed = PushPermission.authorized;
  Completer<PushPermission>? permissionGate;
  @override
  String get platform => 'android';
  @override
  Stream<RemoteMessage> get foreground => foregroundEvents.stream;
  @override
  Stream<RemoteMessage> get opened => openedEvents.stream;
  @override
  Stream<Map<String, dynamic>> get localOpened => localEvents.stream;
  @override
  Stream<String> get tokenChanges => changes.stream;
  @override
  Future<bool> initialize() async => ready;
  @override
  Future<PushPermission> permission({required bool request}) async {
    if (request) requested++;
    return permissionGate?.future ?? Future.value(allowed);
  }

  @override
  Future<String?> token() async => identifier;
  @override
  Future<Map<String, dynamic>?> initialTarget() async => initial;
  @override
  Future<void> show(RemoteMessage message, String notificationId) async {
    if (showFails) throw const ApiException('Không thể hiện thông báo');
    shown.add(notificationId);
  }

  @override
  Future<void> clear() async {
    clears++;
  }

  @override
  Future<void> openSettings() async {}
  @override
  Future<void> dispose() async {
    await foregroundEvents.close();
    await openedEvents.close();
    await localEvents.close();
    await changes.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const notificationId = '3bbcee75-cecc-5b56-8031-b6641c1ed1f1';
  late _Api api;
  late _Transport native;
  late PushRepositoryImpl repository;
  Map<String, dynamic> payload({
    String account = 'one',
    bool expired = false,
  }) => {
    'notificationId': notificationId,
    'accountId': account,
    'expiresAt': DateTime.now()
        .add(Duration(hours: expired ? -1 : 1))
        .toIso8601String(),
  };
  Future<void> settle() async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    api = _Api();
    native = _Transport();
    repository = PushRepositoryImpl(api, native);
  });
  tearDown(() async {
    await repository.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'permission remains readable without Firebase configuration or a server binding',
    () async {
      native.ready = false;
      expect(await repository.register('one'), PushPermission.unconfigured);
      expect(await repository.permission(), PushPermission.authorized);
      expect(native.requested, 0);
      expect(api.bindings, isEmpty);
      expect(api.removals, 0);
    },
  );

  test('a registration error does not hide device permission', () async {
    api.fail = true;
    await expectLater(repository.register('one'), throwsA(isA<ApiException>()));
    expect(await repository.permission(), PushPermission.authorized);
    native.allowed = PushPermission.denied;
    expect(await repository.permission(), PushPermission.denied);
    expect(api.removals, 0);
  });

  test(
    'N: registration binds once; foreground duplicates update one logical notification',
    () async {
      expect(await repository.register('one'), PushPermission.authorized);
      await repository.register('one', requestPermission: false);
      native.changes.add('installation-one');
      final message = RemoteMessage(data: payload());
      native.foregroundEvents.add(message);
      native.foregroundEvents.add(message);
      await settle();
      expect(api.bindings, ['installation-one']);
      expect(native.shown, [notificationId]);
      expect(native.requested, 1);
    },
  );
  test(
    'A: a failed foreground presentation can be retried with the same notification',
    () async {
      final errors = <Object>[];
      final subscription = repository.states.listen(
        (_) {},
        onError: errors.add,
      );
      await repository.register('one');
      native.showFails = true;
      final message = RemoteMessage(data: payload());
      native.foregroundEvents.add(message);
      await settle();
      expect(errors, hasLength(1));
      native.showFails = false;
      native.foregroundEvents.add(message);
      await settle();
      expect(native.shown, [notificationId]);
      await subscription.cancel();
    },
  );
  test(
    'B: denying permission waits for an older registration before detaching it',
    () async {
      api.held = Completer<void>();
      final registering = repository.register('one');
      await settle();
      expect(api.bindings, hasLength(1));
      native.allowed = PushPermission.denied;
      final denied = repository.register('one');
      await settle();
      expect(api.removals, 0);
      api.held!.complete();
      await registering;
      expect(await denied, PushPermission.denied);
      expect(api.removals, 1);
    },
  );
  test(
    'A: wrong-account, expired and malformed messages never display or navigate',
    () async {
      final opened = <String>[];
      final subscription = repository.openedNotificationIds.listen(opened.add);
      await repository.register('one');
      for (final data in [
        payload(account: 'other'),
        payload(expired: true),
        {'notificationId': 'bad'},
      ]) {
        native.foregroundEvents.add(RemoteMessage(data: data));
        native.openedEvents.add(RemoteMessage(data: data));
      }
      await settle();
      expect(native.shown, isEmpty);
      expect(opened, isEmpty);
      await subscription.cancel();
    },
  );
  test('N: a cold-start tap waits for the matching restored account', () async {
    final opened = <String>[];
    final subscription = repository.openedNotificationIds.listen(opened.add);
    native.initial = payload();
    await repository.register('one');
    await settle();
    expect(opened, [notificationId]);
    await subscription.cancel();
  });
  test(
    'N: a replacement installation identifier rebinds; switching accounts permits a fresh binding',
    () async {
      await repository.register('one');
      native.changes.add('installation-two');
      await settle();
      await repository.register('two');
      expect(api.bindings, [
        'installation-one',
        'installation-two',
        'installation-one',
      ]);
    },
  );
  test(
    'A: denied permission detaches the endpoint and does not request an identifier',
    () async {
      native.allowed = PushPermission.denied;
      expect(await repository.register('one'), PushPermission.denied);
      expect(api.bindings, isEmpty);
      expect(api.removals, 1);
    },
  );
  test(
    'A: missing Firebase configuration and unsupported platforms preserve the inbox',
    () async {
      native.ready = false;
      expect(await repository.register('one'), PushPermission.unconfigured);
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      expect(await repository.register('one'), PushPermission.unavailable);
      expect(api.bindings, isEmpty);
    },
  );
  test('B: logout waits for an in-flight registration then removes it', () async {
    api.held = Completer<void>();
    final binding = repository.register('one');
    await settle();
    expect(api.bindings, hasLength(1));
    final logout = repository.unregister();
    api.held!.complete();
    await binding;
    await logout;
    // Even if registration finishes after suspension, native unregister prevents delivery.
    expect(native.clears, 1);
    expect(api.removals, 1);
    native.changes.add('stale');
    await settle();
    expect(api.bindings, hasLength(1));
  });
  test(
    'A: failed foreground re-registration surfaces an actionable error',
    () async {
      final errors = <Object>[];
      final subscription = repository.states.listen(
        (_) {},
        onError: errors.add,
      );
      await repository.register('one');
      api.fail = true;
      native.changes.add('replacement');
      await settle();
      expect(errors.single, isA<ApiException>());
      await subscription.cancel();
    },
  );
  test(
    'B: permission from an older session cannot register after logout',
    () async {
      native.permissionGate = Completer<PushPermission>();
      final pending = repository.register('one');
      await settle();
      repository.suspend();
      native.permissionGate!.complete(PushPermission.authorized);
      expect(await pending, PushPermission.unavailable);
      expect(api.bindings, isEmpty);
    },
  );
  test(
    'N: missing APNs readiness reports pending without binding a placeholder',
    () async {
      native.identifier = null;
      expect(await repository.register('one'), PushPermission.pending);
      expect(api.bindings, isEmpty);
    },
  );
  test(
    'A: native stream failures become state errors instead of unhandled exceptions',
    () async {
      final errors = <Object>[];
      final subscription = repository.states.listen(
        (_) {},
        onError: errors.add,
      );
      await repository.register('one');
      native.changes.addError(StateError('Native stream unavailable'));
      await settle();
      expect(errors.single, isA<ApiException>());
      await subscription.cancel();
    },
  );
}
