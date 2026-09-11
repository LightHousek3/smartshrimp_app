import 'dart:typed_data';

import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile({required String fullName, String? phone});

  Future<UserProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
