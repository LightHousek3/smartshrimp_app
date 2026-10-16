import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_image_storage.dart';

final class CloudinaryInventoryImageStorage implements InventoryImageStorage {
  CloudinaryInventoryImageStorage(
    this._dio, {
    String cloudName = AppConfig.cloudinaryCloudName,
    String uploadPreset = AppConfig.cloudinaryUploadPreset,
  }) : _cloudName = cloudName.trim(),
       _uploadPreset = uploadPreset.trim();
  final Dio _dio;
  final String _cloudName;
  final String _uploadPreset;

  @override
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
  }) async {
    InventoryRules.validateImage(bytes);
    if (_cloudName.isEmpty || _uploadPreset.isEmpty) {
      throw const ApiException('Ứng dụng chưa được cấu hình dịch vụ tải ảnh.');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
          'upload_preset': _uploadPreset,
          'folder': AppConfig.cloudinaryInventoryFolder,
        }),
      );
      final url = response.data?['secure_url'];
      final uri = url is String ? Uri.tryParse(url) : null;
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.isEmpty ||
          url is! String ||
          url.length > 2048) {
        throw const InvalidResponseException();
      }
      return url;
    } on DioException catch (error) {
      if (ErrorMapper.isNetworkFailure(error)) throw const NetworkException();
      final body = error.response?.data;
      final cloudinaryError = body is Map ? body['error'] : null;
      final message = cloudinaryError is Map
          ? cloudinaryError['message']
          : null;
      throw ApiException(
        message is String && message.trim().isNotEmpty
            ? 'Không thể tải ảnh vật tư: ${message.trim()}'
            : 'Không thể tải ảnh vật tư. Vui lòng thử lại.',
        statusCode: error.response?.statusCode,
      );
    }
  }
}
