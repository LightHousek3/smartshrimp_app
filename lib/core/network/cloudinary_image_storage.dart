import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';

/// Validate image bytes and adapt Cloudinary responses outside the BE envelope.
/// Upload configuration comes from AppConfig; only HTTPS image URLs are accepted.
final class CloudinaryImageStorage {
  CloudinaryImageStorage(
    this._dio, {
    required String folder,
    required void Function(Uint8List) validateBytes,
    String label = 'ảnh',
    String cloudName = AppConfig.cloudinaryCloudName,
    String uploadPreset = AppConfig.cloudinaryUploadPreset,
  }) : _folder = folder,
       _validateBytes = validateBytes,
       _label = label,
       _cloudName = cloudName.trim(),
       _uploadPreset = uploadPreset.trim();
  final String _folder;
  final String _label;
  final void Function(Uint8List) _validateBytes;
  final Dio _dio;
  final String _cloudName;
  final String _uploadPreset;

  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
  }) async {
    _validateBytes(bytes);
    if (_cloudName.isEmpty || _uploadPreset.isEmpty) {
      throw const ApiException('Ứng dụng chưa được cấu hình dịch vụ tải ảnh.');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
          'upload_preset': _uploadPreset,
          'folder': _folder,
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
            ? 'Không thể tải $_label: ${message.trim()}'
            : 'Không thể tải $_label. Vui lòng thử lại.',
        statusCode: error.response?.statusCode,
      );
    }
  }
}
