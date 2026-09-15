import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/storage/device_id_store.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartshrimp_app/features/auth/data/services/auth_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

void main() {
  test(
    'normalizes email, sends device id and persists accepted session',
    () async {
      final remote = _FakeRemoteDataSource(_session(AccountRole.technician));
      final store = _FakeSessionStore();
      final repository = AuthRepositoryImpl(
        remoteDataSource: remote,
        sessionStore: store,
        deviceIdStore: _FakeDeviceIdStore(),
      );

      final account = await repository.login(
        email: '  KTV@Example.com ',
        password: 'secret',
      );

      expect(account.role, AccountRole.technician);
      expect(remote.loginEmail, 'ktv@example.com');
      expect(remote.loginDeviceId, '00000000-0000-4000-8000-000000000001');
      expect(store.accessToken, 'access-token');
      expect(store.refreshToken, 'refresh-token');
    },
  );

  test('rejects unsupported roles and revokes their new session', () async {
    final remote = _FakeRemoteDataSource(_session(AccountRole.expert));
    final store = _FakeSessionStore();
    final repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      sessionStore: store,
      deviceIdStore: _FakeDeviceIdStore(),
    );

    await expectLater(
      repository.login(email: 'expert@example.com', password: 'secret'),
      throwsA(isA<UnsupportedRoleException>()),
    );
    expect(remote.loggedOutToken, 'refresh-token');
    expect(store.refreshToken, isNull);
  });

  test('invalid stored refresh token is cleared during restore', () async {
    final remote = _FakeRemoteDataSource(
      _session(AccountRole.technician),
      refreshError: const ApiException(
        'Invalid refresh token',
        statusCode: 401,
      ),
    );
    final store = _FakeSessionStore()..refreshToken = 'expired-token';
    final repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      sessionStore: store,
      deviceIdStore: _FakeDeviceIdStore(),
    );

    expect(await repository.restoreSession(), isNull);
    expect(store.refreshToken, isNull);
  });

  test(
    'network failure preserves the stored session for a later retry',
    () async {
      final remote = _FakeRemoteDataSource(
        _session(AccountRole.technician),
        refreshError: const NetworkException(),
      );
      final store = _FakeSessionStore()..refreshToken = 'refresh-token';
      final repository = AuthRepositoryImpl(
        remoteDataSource: remote,
        sessionStore: store,
        deviceIdStore: _FakeDeviceIdStore(),
      );

      await expectLater(
        repository.restoreSession(),
        throwsA(isA<NetworkException>()),
      );
      expect(store.refreshToken, 'refresh-token');
    },
  );
}

AuthSession _session(AccountRole role) {
  return AuthSession(
    account: AuthAccount(
      id: '2ad2294a-8d7d-4a74-b17a-139ba35468e8',
      email: 'account@example.com',
      fullName: 'SmartShrimp Account',
      role: role,
      status: AccountStatus.active,
    ),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );
}

final class _FakeRemoteDataSource implements AuthRemoteDataSource {
  _FakeRemoteDataSource(this.session, {this.refreshError});

  final AuthSession session;
  final Object? refreshError;
  String? loginEmail;
  String? loginDeviceId;
  String? loggedOutToken;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    loginEmail = email;
    loginDeviceId = deviceId;
    return session;
  }

  @override
  Future<void> logout(String refreshToken) async {
    loggedOutToken = refreshToken;
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    if (refreshError case final error?) throw error;
    return session;
  }
}

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken;

  @override
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

final class _FakeDeviceIdStore implements DeviceIdStore {
  @override
  Future<String> getOrCreate() async {
    return '00000000-0000-4000-8000-000000000001';
  }
}
