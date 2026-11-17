import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/notifications/firebase_bootstrap.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_api_service.dart';
import 'package:smartshrimp_app/features/notifications/data/services/push_messaging_service.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

final class PushRepositoryImpl implements PushRepository {
  PushRepositoryImpl(this._api, this._messaging);

  final PushRemoteDataSource _api;
  final PushMessagingTransport _messaging;
  final _opened = StreamController<String>.broadcast();
  final _states = StreamController<PushPermission>.broadcast();
  final _presented = <String>{};
  final _subscriptions = <StreamSubscription<dynamic>>[];
  String? _accountId;
  Map<String, dynamic>? _pendingTarget;
  Future<void> _serial = Future<void>.value();
  bool _listening = false;
  bool _disposed = false;
  int _generation = 0;
  Timer? _registrationRetry;
  PushPermission _permission = PushPermission.unavailable;
  bool _registered = false;
  String? _boundIdentifier;
  static final _uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[45][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  @override
  Stream<String> get openedNotificationIds => _opened.stream;
  @override
  Stream<PushPermission> get states => _states.stream;

  /// Reject delayed messages from a previous account or beyond the sender's useful lifetime.
  String? _target(Map<String, dynamic> data) {
    final id = data['notificationId'];
    final expiry = DateTime.tryParse(data['expiresAt']?.toString() ?? '');
    if (_accountId == null ||
        data['accountId'] != _accountId ||
        id is! String ||
        !_uuid.hasMatch(id) ||
        expiry == null ||
        !DateTime.now().isBefore(expiry)) {
      return null;
    }
    return id;
  }

  void _open(Map<String, dynamic> data) {
    if (_disposed) return;
    if (_accountId == null) {
      _pendingTarget = data;
      return;
    }
    final id = _target(data);
    if (id != null) _opened.add(id);
  }

  Future<void> _foreground(RemoteMessage message) async {
    final id = _target(message.data);
    if (id == null || !_presented.add(id)) return;
    if (_presented.length > 200) _presented.remove(_presented.first);
    try {
      await _messaging.show(message, id);
    } on Object {
      _presented.remove(id);
      rethrow;
    }
  }

  /// Keep registration and detachment ordered when permission or session state changes.
  Future<void> _withBindingLock(Future<void> Function() action) async {
    final previous = _serial;
    final completed = Completer<void>();
    _serial = completed.future;
    await previous;
    try {
      await action();
    } finally {
      completed.complete();
    }
  }

  Future<void> _bind(String token, int generation) =>
      _withBindingLock(() async {
        if (_disposed ||
            generation != _generation ||
            _accountId == null ||
            ![
              PushPermission.authorized,
              PushPermission.provisional,
            ].contains(_permission)) {
          return;
        }
        if (_registered && _boundIdentifier == token) return;
        await _api.register(token, _messaging.platform);
        if (generation == _generation && !_disposed) {
          _registered = true;
          _boundIdentifier = token;
          _states.add(_permission);
        }
      });

  /// Surface asynchronous native/refresh failures through state rather than an unhandled zone error.
  Future<void> _observe(Future<void> Function() action) async {
    final generation = _generation;
    try {
      await action();
    } on AppException catch (error) {
      if (!_disposed && generation == _generation) _states.addError(error);
    } on FirebaseException {
      if (!_disposed && generation == _generation) {
        _states.addError(
          const ApiException(
            'Chưa thể kết nối dịch vụ thông báo. Vui lòng thử lại.',
          ),
        );
      }
    } on PlatformException {
      if (!_disposed && generation == _generation) {
        _states.addError(
          const ApiException(
            'Thiết bị chưa sẵn sàng nhận thông báo. Vui lòng thử lại.',
          ),
        );
      }
    }
  }

  void _streamError(Object error, StackTrace stack) {
    if (_disposed || _accountId == null) return;
    _states.addError(
      error is AppException
          ? error
          : const ApiException(
              'Chưa thể cập nhật thông báo thiết bị. Vui lòng thử lại.',
            ),
      stack,
    );
  }

  Future<void> _retryToken(int generation, int remaining) async {
    if (_disposed || generation != _generation || _accountId == null) return;
    final token = await _messaging.token();
    if (_disposed || generation != _generation || _accountId == null) return;
    if (token != null) {
      await _bind(token, generation);
      return;
    }
    if (remaining > 0) {
      _registrationRetry = Timer(
        const Duration(seconds: 3),
        () => unawaited(_observe(() => _retryToken(generation, remaining - 1))),
      );
    }
  }

  @override
  Future<PushPermission> register(
    String accountId, {
    bool requestPermission = true,
  }) async {
    try {
      return await _register(accountId, requestPermission: requestPermission);
    } on FirebaseException {
      throw const ApiException(
        'Chưa thể kết nối dịch vụ thông báo. Vui lòng thử lại.',
      );
    } on PlatformException {
      throw const ApiException(
        'Thiết bị chưa sẵn sàng nhận thông báo. Vui lòng thử lại.',
      );
    }
  }

  Future<PushPermission> _register(
    String accountId, {
    required bool requestPermission,
  }) async {
    final generation = ++_generation;
    if (_accountId != accountId) {
      _registered = false;
      _boundIdentifier = null;
      _permission = PushPermission.unavailable;
    }
    _accountId = accountId;
    _registrationRetry?.cancel();
    if (!supportsNativePush) return PushPermission.unavailable;
    if (!await _messaging.initialize()) return PushPermission.unconfigured;
    if (generation != _generation || _disposed) {
      return PushPermission.unavailable;
    }
    if (!_listening) {
      _listening = true;
      _subscriptions.addAll([
        _messaging.foreground.listen(
          (event) => unawaited(_observe(() => _foreground(event))),
          onError: _streamError,
        ),
        _messaging.opened.listen(
          (event) => _open(event.data),
          onError: _streamError,
        ),
        _messaging.localOpened.listen(_open, onError: _streamError),
        _messaging.tokenChanges.listen((token) {
          if (_accountId != null) {
            unawaited(_observe(() => _bind(token, _generation)));
          }
        }, onError: _streamError),
      ]);
      _pendingTarget = await _messaging.initialTarget() ?? _pendingTarget;
    }
    final target = _pendingTarget;
    _pendingTarget = null;
    if (target != null) _open(target);
    if (generation != _generation || _disposed) {
      return PushPermission.unavailable;
    }
    final permission = await _messaging.permission(request: requestPermission);
    if (generation != _generation || _disposed) {
      return PushPermission.unavailable;
    }
    _permission = permission;
    if (permission == PushPermission.denied) {
      await _withBindingLock(() async {
        if (generation != _generation || _disposed) return;
        await _api.unregister();
        if (generation == _generation && !_disposed) {
          _registered = false;
          _boundIdentifier = null;
        }
      });
      return permission;
    }
    final token = await _messaging.token();
    if (generation != _generation || _disposed) {
      return PushPermission.unavailable;
    }
    if (token != null) {
      await _bind(token, generation);
    } else {
      _registrationRetry = Timer(
        const Duration(seconds: 3),
        () => unawaited(_observe(() => _retryToken(generation, 4))),
      );
      return PushPermission.pending;
    }
    return permission;
  }

  @override
  void suspend() {
    _generation++;
    _accountId = null;
    _registrationRetry?.cancel();
    _presented.clear();
  }

  @override
  Future<void> unregister() async {
    final detach = _accountId != null || _registered;
    suspend();
    _pendingTarget = null;
    _presented.clear();
    await _serial;
    try {
      if (detach) await _api.unregister();
    } on AppException {
      // Logout still clears the native endpoint when its server session cannot be reached.
    } finally {
      _registered = false;
      try {
        await _messaging.clear();
      } on Object {
        // Offline logout cannot wait for the provider to acknowledge token deletion.
      }
    }
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    suspend();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _opened.close();
    await _states.close();
    await _messaging.dispose();
  }

  @override
  Future<void> openSettings() => _messaging.openSettings();
}
