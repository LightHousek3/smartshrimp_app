import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/data/services/cloudinary_inventory_image_storage.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';

void main() {
  final imageBytes = Uint8List.fromList([0xff, 0xd8, 0xff]);

  test('uploads multipart image with the configured unsigned preset', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(
              options.uri.toString(),
              'https://api.cloudinary.com/v1_1/bmlju4ql/image/upload',
            );
            expect(options.headers.containsKey('Authorization'), isFalse);
            final body = options.data as FormData;
            expect(Map.fromEntries(body.fields), {
              'upload_preset': 'product',
              'folder': 'smartshrimp/inventory',
            });
            expect(body.files.single.key, 'file');
            expect(body.files.single.value.filename, 'product.jpg');
            expect(body.files.single.value.length, imageBytes.length);
            handler.resolve(
              Response(
                requestOptions: options,
                data: <String, dynamic>{
                  'secure_url':
                      'https://res.cloudinary.com/bmlju4ql/image/upload/product.jpg',
                },
              ),
            );
          },
        ),
      );
    final storage = CloudinaryInventoryImageStorage(
      dio,
      cloudName: ' bmlju4ql ',
      uploadPreset: ' product ',
    );
    expect(
      await storage.upload(bytes: imageBytes, fileName: 'product.jpg'),
      'https://res.cloudinary.com/bmlju4ql/image/upload/product.jpg',
    );
  });

  for (final config in [(' ', 'product'), ('bmlju4ql', '')]) {
    test(
      'rejects missing upload configuration before sending requests: $config',
      () async {
        var requests = 0;
        final dio = Dio()
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                requests++;
                handler.resolve(
                  Response(requestOptions: options, data: <String, dynamic>{}),
                );
              },
            ),
          );
        final storage = CloudinaryInventoryImageStorage(
          dio,
          cloudName: config.$1,
          uploadPreset: config.$2,
        );
        await expectLater(
          storage.upload(bytes: imageBytes, fileName: 'product.jpg'),
          throwsA(
            isA<ApiException>().having(
              (error) => error.message,
              'message',
              'Ứng dụng chưa được cấu hình dịch vụ tải ảnh.',
            ),
          ),
        );
        expect(requests, 0);
      },
    );
  }

  test('preserves Cloudinary rejection details for diagnosis', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {
                    'error': {'message': 'Upload preset not found'},
                  },
                ),
              ),
            );
          },
        ),
      );
    final storage = CloudinaryInventoryImageStorage(
      dio,
      cloudName: 'bmlju4ql',
      uploadPreset: 'missing',
    );
    await expectLater(
      storage.upload(bytes: imageBytes, fileName: 'product.jpg'),
      throwsA(
        isA<ApiException>()
            .having(
              (error) => error.message,
              'message',
              contains('Upload preset not found'),
            )
            .having((error) => error.statusCode, 'statusCode', 400),
      ),
    );
  });

  test('maps a failed connection to a network error', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );
    final storage = CloudinaryInventoryImageStorage(
      dio,
      cloudName: 'bmlju4ql',
      uploadPreset: 'product',
    );
    await expectLater(
      storage.upload(bytes: imageBytes, fileName: 'product.jpg'),
      throwsA(isA<NetworkException>()),
    );
  });

  test('rejects a response without a valid HTTPS delivery URL', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                data: <String, dynamic>{
                  'secure_url': 'http://example.com/photo.jpg',
                },
              ),
            );
          },
        ),
      );
    final storage = CloudinaryInventoryImageStorage(
      dio,
      cloudName: 'bmlju4ql',
      uploadPreset: 'product',
    );
    await expectLater(
      storage.upload(bytes: imageBytes, fileName: 'product.jpg'),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test(
    'checks actual image signatures instead of trusting the file extension',
    () {
      for (final header in [
        [0xff, 0xd8, 0xff],
        [137, 80, 78, 71, 13, 10, 26, 10],
        'RIFF1234WEBP'.codeUnits,
      ]) {
        expect(
          () => InventoryRules.validateImage(Uint8List.fromList(header)),
          returnsNormally,
        );
      }
      expect(
        () => InventoryRules.validateImage(
          Uint8List.fromList('not an image.jpg'.codeUnits),
        ),
        throwsA(isA<ApiException>()),
      );
    },
  );
  test('accepts the 5 MB boundary and rejects one byte over it', () {
    final bytes = Uint8List(InventoryRules.maxImageBytes)
      ..setAll(0, [0xff, 0xd8, 0xff]);
    expect(() => InventoryRules.validateImage(bytes), returnsNormally);
    expect(
      () => InventoryRules.validateImage(
        Uint8List(InventoryRules.maxImageBytes + 1),
      ),
      throwsA(isA<ApiException>()),
    );
    expect(
      () => InventoryRules.validateImage(Uint8List(0)),
      throwsA(isA<ApiException>()),
    );
  });
  test('rejects invalid image bytes before calling external storage', () async {
    var requests = 0;
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests++;
            handler.reject(DioException(requestOptions: options));
          },
        ),
      );
    final storage = CloudinaryInventoryImageStorage(dio);
    await expectLater(
      storage.upload(
        bytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'fake.jpg',
      ),
      throwsA(isA<ApiException>()),
    );
    expect(requests, 0);
  });
}
