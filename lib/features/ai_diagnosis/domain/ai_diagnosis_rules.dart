import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'entities/ai_diagnosis_image.dart';

abstract final class AiDiagnosisRules {
  static const maxImages = 5;
  static const maxFileBytes = 10 * 1024 * 1024;

  /// MIME comes from the bytes, not from a user-controlled file extension.
  static String mimeType(Uint8List bytes) {
    if (bytes.length >= 8 &&
        _prefix(bytes, [137, 80, 78, 71, 13, 10, 26, 10])) {
      return 'image/png';
    }
    if (bytes.length >= 3 && _prefix(bytes, [255, 216, 255])) {
      return 'image/jpeg';
    }
    if (bytes.length >= 12 &&
        _prefix(bytes, [82, 73, 70, 70]) &&
        _prefix(bytes.sublist(8), [87, 69, 66, 80])) {
      return 'image/webp';
    }
    throw const ApiException('Chỉ hỗ trợ ảnh JPG, PNG hoặc WebP.');
  }

  static bool _prefix(Uint8List bytes, List<int> signature) {
    for (var i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }

  static void validateSize(int bytes) {
    if (bytes <= 0 || bytes > maxFileBytes) {
      throw const ApiException(
        'Mỗi ảnh phải có dữ liệu và không vượt quá 10 MB.',
      );
    }
  }

  static void validate(List<AiDiagnosisImage> images) {
    if (images.isEmpty || images.length > maxImages) {
      throw const ApiException('Vui lòng chọn từ 1 đến 5 ảnh mẫu tôm.');
    }
    for (final image in images) {
      validateSize(image.bytes.length);
      if (mimeType(image.bytes) != image.mimeType) {
        throw const ApiException('Định dạng ảnh không khớp nội dung file.');
      }
    }
  }
}
