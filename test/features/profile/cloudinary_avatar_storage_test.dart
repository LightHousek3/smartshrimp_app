import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/profile/data/services/cloudinary_avatar_storage.dart';

void main() {
  group('CloudinaryAvatarStorage', () {
    test('rejects an empty image before sending a request', () async {
      final storage = CloudinaryAvatarStorage(Dio());

      await expectLater(
        storage.upload(bytes: Uint8List(0), fileName: 'avatar.jpg'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Ảnh đã chọn không hợp lệ.',
          ),
        ),
      );
    });

    test('rejects an image one byte above the five MB limit', () async {
      final storage = CloudinaryAvatarStorage(Dio());

      await expectLater(
        storage.upload(
          bytes: Uint8List(CloudinaryAvatarStorage.maxAvatarBytes + 1),
          fileName: 'avatar.jpg',
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Ảnh đại diện không được vượt quá 5 MB.',
          ),
        ),
      );
    });
  });
}
