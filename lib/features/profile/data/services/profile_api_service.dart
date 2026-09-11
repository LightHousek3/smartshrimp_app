import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/authenticated_api_client.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile(Map<String, dynamic> changes);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

final class ProfileApiService implements ProfileRemoteDataSource {
  ProfileApiService(this._client);

  final AuthenticatedApiClient _client;

  @override
  Future<UserProfile> getProfile() async {
    final response = await _client.get('/profile');
    return UserProfile.fromJson(_dataFrom(response));
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> changes) async {
    final response = await _client.patch('/profile', data: changes);
    return UserProfile.fromJson(_dataFrom(response));
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _client.patch(
      '/profile/password',
      data: <String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
    final body = response.data;
    if (body == null || body['success'] != true) {
      throw const InvalidResponseException();
    }
  }

  Map<String, dynamic> _dataFrom(Response<Map<String, dynamic>> response) {
    final body = response.data;
    final data = body?['data'];
    if (body == null ||
        body['success'] != true ||
        data is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return data;
  }
}

abstract interface class AvatarStorage {
  Future<String> upload({required Uint8List bytes, required String fileName});
}

final class CloudinaryAvatarStorage implements AvatarStorage {
  CloudinaryAvatarStorage(this._dio);

  static const maxAvatarBytes = 5 * 1024 * 1024;

  final Dio _dio;

  @override
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (bytes.isEmpty) {
      throw const ApiException('Ảnh đã chọn không hợp lệ.');
    }
    if (bytes.length > maxAvatarBytes) {
      throw const ApiException('Ảnh đại diện không được vượt quá 5 MB.');
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        AppConfig.cloudinaryImageUploadUrl,
        data: FormData.fromMap(<String, dynamic>{
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
          'upload_preset': AppConfig.cloudinaryUploadPreset,
          'folder': AppConfig.cloudinaryAvatarFolder,
        }),
      );
      final secureUrl = response.data?['secure_url'];
      if (secureUrl is! String || secureUrl.isEmpty) {
        throw const InvalidResponseException();
      }
      return secureUrl;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
      }
      final data = error.response?.data;
      final cloudinaryError = data is Map<String, dynamic>
          ? data['error']
          : null;
      final message = cloudinaryError is Map<String, dynamic>
          ? cloudinaryError['message']
          : null;
      throw ApiException(
        message is String && message.isNotEmpty
            ? 'Không thể tải ảnh lên: $message'
            : 'Không thể tải ảnh lên Cloudinary. Vui lòng thử lại.',
        statusCode: error.response?.statusCode,
      );
    }
  }
}
