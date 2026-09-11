import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/storage/device_id_store.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/data/services/auth_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionStore sessionStore,
    required DeviceIdStore deviceIdStore,
  }) : _remoteDataSource = remoteDataSource,
       _sessionStore = sessionStore,
       _deviceIdStore = deviceIdStore;

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStore _sessionStore;
  final DeviceIdStore _deviceIdStore;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      email: email.trim().toLowerCase(),
      password: password,
      deviceId: await _deviceIdStore.getOrCreate(),
    );
    return _acceptSession(session, revokeIfUnsupported: true);
  }

  @override
  Future<AuthUser?> restoreSession() async {
    await _sessionStore.initialize();
    final refreshToken = _sessionStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final session = await _remoteDataSource.refresh(refreshToken);
      return await _acceptSession(session);
    } on Object {
      await _sessionStore.clear();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = _sessionStore.refreshToken;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _remoteDataSource.logout(refreshToken);
      }
    } on Object {
      // Logging out locally must still succeed if the session was already
      // revoked (for example, immediately after changing the password).
    } finally {
      await _sessionStore.clear();
    }
  }

  Future<AuthUser> _acceptSession(
    AuthSession session, {
    bool revokeIfUnsupported = false,
  }) async {
    if (!session.user.canUseMobileApp) {
      if (revokeIfUnsupported) {
        try {
          await _remoteDataSource.logout(session.refreshToken);
        } on Object {
          // Local access is still denied if server-side revocation is unavailable.
        }
      }
      await _sessionStore.clear();
      throw const UnsupportedRoleException();
    }

    await _sessionStore.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    return session.user;
  }
}
