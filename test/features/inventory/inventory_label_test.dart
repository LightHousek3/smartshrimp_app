import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/inventory_label_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_label_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_label_review.dart';

Map<String, dynamic> labelJson() => {
  'name': 'Thức ăn A',
  'manufacturerName': null,
  'regulatoryType': null,
  'registrationNumber': null,
  'ingredientsText': null,
  'usageInstructions': null,
  'containsAntibiotic': false,
  'withdrawalDays': 0,
  'evidence': {
    'name': 'Thức ăn A',
    'containsAntibiotic': 'Không chứa kháng sinh',
    'withdrawalDays': '0 ngày',
  },
  'warnings': <String>[],
};

void main() {
  test(
    'parsing preserves explicit false and zero, rejects missing evidence or invalid fields',
    () {
      final result = InventoryLabelResult.parse(labelJson());
      expect(result.containsAntibiotic, isFalse);
      expect(result.withdrawalDays, 0);
      expect(result.registrationNumber, isNull);
      for (final json in [
        {...labelJson(), 'evidence': <String, String>{}},
        {...labelJson(), 'containsAntibiotic': 'false'},
        {...labelJson(), 'withdrawalDays': -1},
        {...labelJson(), 'regulatoryType': 'unknown-type'},
        {...labelJson()}..remove('name'),
        {...labelJson(), 'warnings': null},
      ]) {
        expect(
          () => InventoryLabelResult.parse(json),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );

  test(
    'sends authenticated farm-scoped OCR with base64 and saved URLs, without product writes',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {'success': true, 'message': 'Read', 'data': labelJson()},
              ),
            );
          },
        ),
      );
      final repository = InventoryLabelRepositoryImpl(
        InventoryLabelApiService(ApiClient(dio, _SessionStore())),
      );
      final bytes = Uint8List.fromList([255, 216, 255, 224]);
      final result = await repository.scan(
        farmId: 'farm-1',
        images: [
          (bytes: bytes, url: null),
          (
            bytes: null,
            url: 'https://res.cloudinary.com/cloud/image/upload/label.jpg',
          ),
        ],
      );
      expect(result.name, 'Thức ăn A');
      expect(requests, hasLength(1));
      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/owner/farms/farm-1/products/scan-label');
      expect(request.headers['Authorization'], 'Bearer test-session');
      expect(request.receiveTimeout, const Duration(seconds: 80));
      expect(request.data, {
        'images': [
          {'data': base64Encode(bytes)},
          {'url': 'https://res.cloudinary.com/cloud/image/upload/label.jpg'},
        ],
      });
      expect(request.headers.containsKey('x-goog-api-key'), isFalse);
    },
  );

  test(
    'rejects missing, oversized and invalid images before any network request',
    () async {
      var requests = 0;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (_, handler) {
            requests++;
          },
        ),
      );
      final repository = InventoryLabelRepositoryImpl(
        InventoryLabelApiService(ApiClient(dio, _SessionStore())),
      );
      final big = Uint8List(4 * 1024 * 1024)..setAll(0, [255, 216, 255]);
      for (final List<InventoryLabelImage> images in [
        <InventoryLabelImage>[],
        [
          (bytes: Uint8List.fromList([1, 2]), url: null),
        ],
        [(bytes: big, url: null), (bytes: big, url: null)],
        [(bytes: null, url: null)],
        [(bytes: null, url: 'http://localhost/a.jpg')],
      ]) {
        await expectLater(
          () => repository.scan(farmId: 'farm', images: images),
          throwsA(isA<ApiException>()),
        );
      }
      expect(requests, 0);
    },
  );

  test('preserves backend quota error through ApiClient', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          handler.reject(
            DioException(
              requestOptions: request,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: request,
                statusCode: 429,
                data: {
                  'success': false,
                  'statusCode': 429,
                  'message': 'Đã hết quota OCR',
                },
              ),
            ),
          );
        },
      ),
    );
    final repository = InventoryLabelRepositoryImpl(
      InventoryLabelApiService(ApiClient(dio, _SessionStore())),
    );
    await expectLater(
      repository.scan(
        farmId: 'farm',
        images: [
          (bytes: Uint8List.fromList([255, 216, 255]), url: null),
        ],
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'status', 429)
            .having((error) => error.message, 'message', 'Đã hết quota OCR'),
      ),
    );
  });

  test(
    'accepts 5 MiB total and blocks one byte over it before sending OCR',
    () async {
      var requests = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests++;
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {'success': true, 'message': 'Read', 'data': labelJson()},
              ),
            );
          },
        ),
      );
      final repository = InventoryLabelRepositoryImpl(
        InventoryLabelApiService(ApiClient(dio, _SessionStore())),
      );
      final first = Uint8List(3 * 1024 * 1024)..setAll(0, [255, 216, 255]);
      List<InventoryLabelImage> images(int extra) => [
        (bytes: first, url: null),
        (
          bytes: Uint8List(2 * 1024 * 1024 + extra)..setAll(0, [255, 216, 255]),
          url: null,
        ),
      ];
      await repository.scan(farmId: 'farm-1', images: images(0));
      expect(requests, 1);
      await expectLater(
        () => repository.scan(farmId: 'farm-1', images: images(1)),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            contains('Tổng ảnh OCR không được vượt quá 5 MB.'),
          ),
        ),
      );
      expect(requests, 1);
    },
  );

  Future<void> openReview(
    WidgetTester tester,
    InventoryLabelResult result,
    ValueChanged<Set<String>?> accepted,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async => accepted(
                await showDialog<Set<String>>(
                  context: context,
                  builder: (_) => InventoryLabelReview(result: result),
                ),
              ),
              child: const Text('Review'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'review starts unselected and applies only explicitly selected fields',
    (tester) async {
      Set<String>? accepted;
      await openReview(
        tester,
        InventoryLabelResult.parse(labelJson()),
        (value) => accepted = value,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .every((tile) => tile.value == false),
        isTrue,
      );
      await tester.tap(
        find.byKey(const ValueKey('inventory-label-field-name')),
      );
      await tester.pump();
      await tester.tap(find.text('Xác nhận & điền 1 trường'));
      await tester.pumpAndSettle();
      expect(accepted, {'name'});
    },
  );

  testWidgets(
    'select all toggles OCR fields and waits for separate confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Set<String>? accepted;
      await openReview(
        tester,
        InventoryLabelResult.parse(
          labelJson(),
        ).copyWith(manufacturerName: 'Maker'),
        (value) => accepted = value,
      );
      expect(accepted, isNull);
      final selectAll = find.byKey(
        const ValueKey('inventory-label-select-all'),
      );
      await tester.tap(selectAll);
      await tester.pumpAndSettle();
      expect(accepted, isNull);
      expect(find.text('Kiểm tra kết quả đọc nhãn'), findsOneWidget);
      expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .every((tile) => tile.value == true),
        isTrue,
      );

      await tester.tap(selectAll);
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .every((tile) => tile.value == false),
        isTrue,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      final name = find.byKey(const ValueKey('inventory-label-field-name'));
      await tester.ensureVisible(name);
      await tester.pumpAndSettle();
      await tester.tap(name);
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(selectAll).value, isFalse);
      await tester.tap(selectAll);
      await tester.pumpAndSettle();
      expect(accepted, isNull);
      expect(tester.widget<CheckboxListTile>(name).value, isTrue);
      expect(tester.widget<CheckboxListTile>(selectAll).value, isTrue);

      await tester.tap(find.text('Xác nhận & điền 3 trường'));
      await tester.pumpAndSettle();

      expect(accepted, {'name', 'containsAntibiotic', 'withdrawalDays'});
      expect(find.text('Kiểm tra kết quả đọc nhãn'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'closing review discards suggestions and manufacturer stays informational',
    (tester) async {
      Set<String>? accepted = {'unexpected'};
      final result = InventoryLabelResult.parse(
        labelJson(),
      ).copyWith(manufacturerName: 'Maker');
      await openReview(tester, result, (value) => accepted = value);
      expect(
        find.textContaining('Nhà sản xuất đọc được: Maker'),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const ValueKey('inventory-label-field-name')),
      );
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();
      expect(accepted, isNull);
    },
  );

  testWidgets('empty OCR result displays fallback and cannot be applied', (
    tester,
  ) async {
    await openReview(
      tester,
      const InventoryLabelResult(warnings: ['Ảnh mờ']),
      (_) {},
    );
    expect(find.text('Ảnh mờ'), findsOneWidget);
    expect(find.textContaining('Không có trường nào'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('inventory-label-select-all')),
          )
          .onChanged,
      isNull,
    );
  });
}

class _SessionStore implements SessionStore {
  @override
  String? get accessToken => 'test-session';
  @override
  String? get refreshToken => 'test-refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}
