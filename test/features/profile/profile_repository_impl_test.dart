import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';
import 'package:smartshrimp_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smartshrimp_app/features/profile/data/services/profile_api_service.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';

void main() {
  late _FakeProfileRemoteDataSource remote;
  late _FakeAvatarStorage storage;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = _FakeProfileRemoteDataSource();
    storage = _FakeAvatarStorage();
    repository = ProfileRepositoryImpl(
      remoteDataSource: remote,
      avatarStorage: storage,
    );
  });

  test('trims editable values and clears an empty phone', () async {
    await repository.updateProfile(fullName: '  Trần Quốc Bảo  ', phone: '');

    expect(remote.lastChanges, <String, dynamic>{
      'fullName': 'Trần Quốc Bảo',
      'phone': null,
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
}

const _baseProfile = UserProfile(
  id: 'user-1',
  email: 'bao@smartshrimp.vn',
  fullName: 'Trần Quốc Bảo',
  role: AppUserRole.technician,
  status: 'ACTIVE',
);

final class _FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  Map<String, dynamic>? lastChanges;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<UserProfile> getProfile() async => _baseProfile;

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> changes) async {
    lastChanges = changes;
    return UserProfile(
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
