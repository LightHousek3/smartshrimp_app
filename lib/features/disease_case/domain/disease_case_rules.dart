import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

abstract final class DiseaseCaseRules {
  static const titleLimit = 500;
  static const textLimit = 500;
  static const maxImageBytes = 5 * 1024 * 1024;
  static void validateAttachments(List<String> urls) {
    if (urls.length > 5 ||
        urls.toSet().length != urls.length ||
        urls.any((url) {
          final uri = Uri.tryParse(url);
          return url.length > 2048 ||
              uri == null ||
              uri.scheme != 'https' ||
              uri.host.isEmpty;
        })) {
      throw const ApiException(
        'Chọn tối đa 5 ảnh minh chứng hợp lệ.',
        statusCode: 400,
      );
    }
  }

  static void validateImage(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxImageBytes) {
      throw const ApiException(
        'Ảnh minh chứng phải có dung lượng từ 1 byte đến 5 MB.',
      );
    }
    final jpeg =
        bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff;
    final png =
        bytes.length >= 8 &&
        bytes.take(8).join(',') == '137,80,78,71,13,10,26,10';
    final webp =
        bytes.length >= 12 &&
        String.fromCharCodes(bytes.take(4)) == 'RIFF' &&
        String.fromCharCodes(bytes.skip(8).take(4)) == 'WEBP';
    if (!jpeg && !png && !webp) {
      throw const ApiException('Chọn ảnh JPG, PNG hoặc WebP.');
    }
  }

  static String? textError(String? value, int max) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập nội dung.';
    if (text.runes.length > max) return 'Tối đa $max ký tự.';
    return null;
  }
}
