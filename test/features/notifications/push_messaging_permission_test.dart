import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_messaging_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late PushMessagingService service;
  late List<String> calls;
  Object? response;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    service = PushMessagingService();
    calls = [];
    response = true;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return response;
    });
  });
  tearDown(() async {
    await service.dispose();
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'Android reads OS permission without initializing Firebase or asking again',
    () async {
      expect(
        await service.permission(request: false),
        PushPermission.authorized,
      );
      response = false;
      expect(await service.permission(request: false), PushPermission.denied);
      expect(calls, ['areNotificationsEnabled', 'areNotificationsEnabled']);
    },
  );

  test('an unavailable permission result is not reported as denied', () async {
    response = null;
    await expectLater(
      service.permission(request: false),
      throwsA(isA<ApiException>()),
    );
  });

  test('iOS preserves provisional authorization', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    response = {'isEnabled': true, 'isProvisionalEnabled': true};
    expect(
      await service.permission(request: false),
      PushPermission.provisional,
    );
    response = {'isEnabled': false};
    expect(await service.permission(request: false), PushPermission.denied);
    expect(calls, ['checkPermissions', 'checkPermissions']);
  });

  test(
    'settings opens the notification page and a failed launch is localized',
    () async {
      await service.openSettings();
      response = false;
      await expectLater(service.openSettings(), throwsA(isA<ApiException>()));
      expect(calls, [
        'openAppNotificationSettings',
        'openAppNotificationSettings',
      ]);
    },
  );
}
