import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SessionStore {
  String? get accessToken;
  String? get refreshToken;

  Future<void> initialize();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clear();
}

final class SecureSessionStore implements SessionStore {
  SecureSessionStore(this._storage);

  static const _refreshTokenKey = 'smartshrimp_refresh_token';

  final FlutterSecureStorage _storage;
  String? _accessToken;
  String? _refreshToken;
  bool _initialized = false;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _refreshToken = await _storage.read(key: _refreshTokenKey);
    _initialized = true;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _initialized = true;
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _initialized = true;
    await _storage.delete(key: _refreshTokenKey);
  }
}
