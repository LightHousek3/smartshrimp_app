import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';

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
    if (AppConfig.cloudinaryCloudName.isEmpty ||
        AppConfig.cloudinaryUploadPreset.isEmpty) {
      throw const ApiException('Ứng dụng chưa được cấu hình dịch vụ tải ảnh.');
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
      if (ErrorMapper.isNetworkFailure(error)) {
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
