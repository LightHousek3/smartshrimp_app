import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/storage/device_id_store.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_session.dart';
import 'package:smartshrimp_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smartshrimp_app/features/profile/data/services/cloudinary_avatar_storage.dart';
import 'package:smartshrimp_app/features/profile/data/services/profile_api_service.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';

void main() {
  late _FakeProfileRemoteDataSource remote;
  late _FakeAvatarStorage storage;
  late _FakeSessionStore sessionStore;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = _FakeProfileRemoteDataSource();
    storage = _FakeAvatarStorage();
    sessionStore = _FakeSessionStore();
    repository = ProfileRepositoryImpl(
      remoteDataSource: remote,
      avatarStorage: storage,
      sessionStore: sessionStore,
      deviceIdStore: _FakeDeviceIdStore(),
    );
  });

  test('trims editable values and clears an empty phone', () async {
    await repository.updateProfile(fullName: '  Trần Quốc Bảo  ', phone: '');

    expect(remote.lastChanges, <String, dynamic>{
      'fullName': 'Trần Quốc Bảo',
      'phone': null,
    });
  });

  test('normalizes an international Vietnamese phone before update', () async {
    await repository.updateProfile(
      fullName: '  TS.   Nguyễn Văn An  ',
      phone: '+84 (912) 345-678',
    );

    expect(remote.lastChanges, <String, dynamic>{
      'fullName': 'TS. Nguyễn Văn An',
      'phone': '0912345678',
    });
  });

  test('uploads avatar before sending the secure URL to backend', () async {
    final result = await repository.updateAvatar(
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
      fileName: 'avatar.jpg',
    );

    expect(storage.lastFileName, 'avatar.jpg');
    expect(storage.lastBytes, <int>[1, 2, 3]);
    expect(remote.lastChanges, <String, dynamic>{
      'avatarUrl': 'https://res.cloudinary.com/demo/new-avatar.jpg',
    });
    expect(result.avatarUrl, 'https://res.cloudinary.com/demo/new-avatar.jpg');
  });

  test(
    'changes password and atomically replaces the current session',
    () async {
      await repository.changePassword(
        currentPassword: 'Current1',
        newPassword: 'NewPassword1',
      );

      expect(remote.lastCurrentPassword, 'Current1');
      expect(remote.lastNewPassword, 'NewPassword1');
      expect(remote.lastDeviceId, _FakeDeviceIdStore.deviceId);
      expect(sessionStore.accessToken, 'new-access-token');
      expect(sessionStore.refreshToken, 'new-refresh-token');
      expect(sessionStore.saveCalls, 1);
    },
  );
}

const _baseProfile = AccountProfile(
  id: 'account-1',
  email: 'bao@smartshrimp.vn',
  fullName: 'Trần Quốc Bảo',
  role: AccountRole.technician,
  status: AccountStatus.active,
);

const _sessionAccount = AuthAccount(
  id: 'account-1',
  email: 'bao@smartshrimp.vn',
  fullName: 'Trần Quốc Bảo',
  role: AccountRole.technician,
  status: AccountStatus.active,
);

final class _FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  Map<String, dynamic>? lastChanges;
  String? lastCurrentPassword;
  String? lastNewPassword;
  String? lastDeviceId;

  @override
  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
    required String deviceId,
  }) async {
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
    lastDeviceId = deviceId;
    return const AuthSession(
      account: _sessionAccount,
      accessToken: 'new-access-token',
      refreshToken: 'new-refresh-token',
    );
  }

  @override
  Future<AccountProfile> getProfile() async => _baseProfile;

  @override
  Future<AccountProfile> updateProfile(Map<String, dynamic> changes) async {
    lastChanges = changes;
    return AccountProfile(
      id: _baseProfile.id,
      email: _baseProfile.email,
      fullName: changes['fullName'] as String? ?? _baseProfile.fullName,
      phone: changes['phone'] as String?,
      avatarUrl: changes['avatarUrl'] as String?,
      role: _baseProfile.role,
      status: _baseProfile.status,
    );
  }
}

final class _FakeDeviceIdStore implements DeviceIdStore {
  static const deviceId = 'e7aa283b-0931-4d93-a59a-7ce414336e3a';

  @override
  Future<String> getOrCreate() async => deviceId;
}

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken;

  @override
  String? refreshToken;

  int saveCalls = 0;

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
    saveCalls++;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

final class _FakeAvatarStorage implements AvatarStorage {
  Uint8List? lastBytes;
  String? lastFileName;

  @override
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
  }) async {
    lastBytes = bytes;
    lastFileName = fileName;
    return 'https://res.cloudinary.com/demo/new-avatar.jpg';
  }
}
