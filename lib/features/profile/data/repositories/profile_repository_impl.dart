import 'dart:typed_data';

import 'package:smartshrimp_app/core/storage/device_id_store.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/profile/data/services/cloudinary_avatar_storage.dart';
import 'package:smartshrimp_app/features/profile/data/services/profile_api_service.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/profile_rules.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required AvatarStorage avatarStorage,
    required SessionStore sessionStore,
    required DeviceIdStore deviceIdStore,
  }) : _remoteDataSource = remoteDataSource,
       _avatarStorage = avatarStorage,
       _sessionStore = sessionStore,
       _deviceIdStore = deviceIdStore;

  final ProfileRemoteDataSource _remoteDataSource;
  final AvatarStorage _avatarStorage;
  final SessionStore _sessionStore;
  final DeviceIdStore _deviceIdStore;

  @override
  Future<AccountProfile> getProfile() => _remoteDataSource.getProfile();

  @override
  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phone,
  }) {
    final normalizedPhone = phone == null
        ? null
        : ProfileRules.normalizePhone(phone);
    return _remoteDataSource.updateProfile(<String, dynamic>{
      'fullName': ProfileRules.normalizeFullName(fullName),
      'phone': normalizedPhone == null || normalizedPhone.isEmpty
          ? null
          : normalizedPhone,
    });
  }

  @override
  Future<AccountProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final avatarUrl = await _avatarStorage.upload(
      bytes: bytes,
      fileName: fileName,
    );
    return _remoteDataSource.updateProfile(<String, dynamic>{
      'avatarUrl': avatarUrl,
    });
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      deviceId: await _deviceIdStore.getOrCreate(),
    );
    await _sessionStore.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }
}
