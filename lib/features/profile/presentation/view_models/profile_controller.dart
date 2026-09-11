import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smartshrimp_app/features/profile/data/services/profile_api_service.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';
import 'package:smartshrimp_app/features/profile/domain/repositories/profile_repository.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileApiService(ref.watch(authenticatedApiClientProvider));
});

final avatarStorageProvider = Provider<AvatarStorage>((ref) {
  return CloudinaryAvatarStorage(ref.watch(cloudinaryDioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    avatarStorage: ref.watch(avatarStorageProvider),
  );
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserProfile>(
      ProfileController.new,
    );

final class ProfileController extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final authState = ref.watch(authControllerProvider);
    if (authState.value == null) {
      throw StateError('Profile requires an authenticated user.');
    }
    return _loadProfile();
  }

  Future<void> refresh() async {
    try {
      state = AsyncData(await _loadProfile());
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<UserProfile> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    final profile = await _runAuthenticated(
      () => ref
          .read(profileRepositoryProvider)
          .updateProfile(fullName: fullName, phone: phone),
    );
    state = AsyncData(profile);
    return profile;
  }

  Future<UserProfile> updateAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final profile = await _runAuthenticated(
      () => ref
          .read(profileRepositoryProvider)
          .updateAvatar(bytes: bytes, fileName: fileName),
    );
    state = AsyncData(profile);
    return profile;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _runAuthenticated(
      () => ref
          .read(profileRepositoryProvider)
          .changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
    );
  }

  Future<UserProfile> _loadProfile() {
    return _runAuthenticated(ref.read(profileRepositoryProvider).getProfile);
  }

  Future<T> _runAuthenticated<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }
}
