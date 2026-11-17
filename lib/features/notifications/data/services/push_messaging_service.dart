import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartshrimp_app/core/notifications/firebase_bootstrap.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

abstract interface class PushMessagingTransport {
  String get platform;
  Stream<Map<String, dynamic>> get localOpened;
  Stream<RemoteMessage> get foreground;
  Stream<RemoteMessage> get opened;
  Stream<String> get tokenChanges;
  Future<bool> initialize();
  Future<PushPermission> permission({required bool request});
  Future<String?> token();
  Future<Map<String, dynamic>?> initialTarget();
  Future<void> show(RemoteMessage message, String notificationId);
  Future<void> clear();
  Future<void> openSettings();
  Future<void> dispose();
}

final class PushMessagingService implements PushMessagingTransport {
  static const channelId = 'smartshrimp_alerts';
  static const channelName = 'Thông báo SmartShrimp';
  static const channelDescription =
      'Nhắc vận hành, công việc và cập nhật vụ nuôi';

  final _local = FlutterLocalNotificationsPlugin();
  final _opened = StreamController<Map<String, dynamic>>.broadcast();
  FirebaseMessaging? _messaging;
  bool _ready = false;

  @override
  String get platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  @override
  Stream<Map<String, dynamic>> get localOpened => _opened.stream;
  @override
  Stream<RemoteMessage> get foreground => FirebaseMessaging.onMessage;
  @override
  Stream<RemoteMessage> get opened => FirebaseMessaging.onMessageOpenedApp;
  @override
  Stream<String> get tokenChanges => _messaging!.onRegistered;

  /// Background banners belong to the OS; only foreground messages use the local presenter.
  @override
  Future<bool> initialize() async {
    if (_ready) return true;
    if (!await initializePushFirebase()) return false;
    _messaging = FirebaseMessaging.instance;
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_smartshrimp'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null) return;
        final decoded = _decodeTarget(payload);
        if (decoded != null) _opened.add(decoded);
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDescription,
            importance: Importance.high,
          ),
        );
    await _messaging!.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    _ready = true;
    return true;
  }

  @override
  Future<PushPermission> permission({required bool request}) async {
    final settings = request
        ? await _messaging!.requestPermission()
        : await _messaging!.getNotificationSettings();
    return switch (settings.authorizationStatus) {
      AuthorizationStatus.authorized => PushPermission.authorized,
      AuthorizationStatus.provisional => PushPermission.provisional,
      _ => PushPermission.denied,
    };
  }

  @override
  Future<String?> token() async {
    // APNs registration may finish after permission was granted on iOS.
    if (platform == 'ios' && await _messaging!.getAPNSToken() == null) {
      return null;
    }
    final registration = _messaging!.onRegistered.first.timeout(
      const Duration(seconds: 10),
      onTimeout: () => '',
    );
    await _messaging!.register();
    final fid = await registration;
    return fid.isEmpty ? null : fid;
  }

  @override
  Future<Map<String, dynamic>?> initialTarget() async {
    final remote = await _messaging!.getInitialMessage();
    if (remote != null) return remote.data;
    final launch = await _local.getNotificationAppLaunchDetails();
    final payload = launch?.notificationResponse?.payload;
    if (launch?.didNotificationLaunchApp != true || payload == null) {
      return null;
    }
    return _decodeTarget(payload);
  }

  Map<String, dynamic>? _decodeTarget(String payload) {
    try {
      final value = jsonDecode(payload);
      return value is Map<String, dynamic> ? value : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> show(RemoteMessage message, String notificationId) =>
      _local.show(
        id:
            int.parse(
              notificationId.replaceAll('-', '').substring(0, 8),
              radix: 16,
            ) &
            0x7fffffff,
        title: message.notification?.title ?? 'SmartShrimp',
        body: message.notification?.body ?? 'Bạn có thông báo mới.',
        payload: jsonEncode(message.data),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            tag: notificationId,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );

  /// Local logout clears displayed messages even when the backend is unreachable.
  @override
  Future<void> clear() async {
    if (!_ready) return;
    await _local.cancelAll();
    await _messaging!.unregister();
  }

  @override
  Future<void> dispose() => _opened.close();

  /// Reuse the installed platform bridge; opening App settings does not request location.
  @override
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
