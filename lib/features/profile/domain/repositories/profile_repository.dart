import 'dart:typed_data';

import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';

abstract interface class ProfileRepository {
  Future<AccountProfile> getProfile();

  Future<AccountProfile> updateProfile({
    required String fullName,
    String? phone,
  });

  Future<AccountProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
