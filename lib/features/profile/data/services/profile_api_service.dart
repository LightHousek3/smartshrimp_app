import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<AccountProfile> getProfile();

  Future<AccountProfile> updateProfile(Map<String, dynamic> changes);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

final class ProfileApiService implements ProfileRemoteDataSource {
  ProfileApiService(this._client);

  final ApiClient _client;

  @override
  Future<AccountProfile> getProfile() async {
    final response = await _client.get('/profile', authenticated: true);
    return AccountProfile.parse(response.requireMapData());
  }

  @override
  Future<AccountProfile> updateProfile(Map<String, dynamic> changes) async {
    final response = await _client.patch(
      '/profile',
      authenticated: true,
      data: changes,
    );
    return AccountProfile.parse(response.requireMapData());
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.patch(
      '/profile/password',
      authenticated: true,
      data: <String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
