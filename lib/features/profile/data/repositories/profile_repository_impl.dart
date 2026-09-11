import 'dart:typed_data';

import 'package:smartshrimp_app/features/profile/data/services/profile_api_service.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required AvatarStorage avatarStorage,
  }) : _remoteDataSource = remoteDataSource,
       _avatarStorage = avatarStorage;

  final ProfileRemoteDataSource _remoteDataSource;
  final AvatarStorage _avatarStorage;

  @override
  Future<UserProfile> getProfile() => _remoteDataSource.getProfile();

  @override
  Future<UserProfile> updateProfile({required String fullName, String? phone}) {
    final normalizedPhone = phone?.trim();
    return _remoteDataSource.updateProfile(<String, dynamic>{
      'fullName': fullName.trim(),
      'phone': normalizedPhone == null || normalizedPhone.isEmpty
          ? null
          : normalizedPhone,
    });
  }

  @override
  Future<UserProfile> updateAvatar({
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
  }) {
    return _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
