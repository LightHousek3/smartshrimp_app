import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/data/services/ai_diagnosis_api_service.dart';
import 'ai_diagnosis_fixtures.dart';

class TestSession implements SessionStore {
  @override
  String? accessToken = 'expired';
  @override
  String? refreshToken = 'refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

/// Consume the real multipart stream so a reused/finalized body cannot pass the test.
class DiagnosisTransport implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final bodies = <String>[];
  bool rejectFirst = false, timeout = false;
  int statusCode = 200;
  Map<String, dynamic>? response;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final bytes = requestStream == null
        ? <int>[]
        : await requestStream.expand((chunk) => chunk).toList();
    bodies.add(latin1.decode(bytes));
    if (options.path == '/auth/refresh-token') {
      return reply(200, {
        'success': true,
        'message': 'OK',
        'data': {'accessToken': 'renewed', 'refreshToken': 'rotated'},
      });
    }
    if (timeout) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.receiveTimeout,
      );
    }
    if (rejectFirst &&
        requests
                .where(
                  (r) => r.method == 'POST' && r.path != '/auth/refresh-token',
                )
                .length ==
            1) {
      return reply(401, {
        'success': false,
        'statusCode': 401,
        'message': 'Expired access token',
      });
    }
    return reply(
      statusCode,
      response ?? {'success': true, 'message': 'OK', 'data': diagnosisJson()},
    );
  }

  ResponseBody reply(int status, Map<String, dynamic> json) =>
      ResponseBody.fromString(
        jsonEncode(json),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
  @override
  void close({bool force = false}) {}
}

AiDiagnosisApiService service(
  DiagnosisTransport transport, [
  TestSession? store,
]) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.test/api/v1',
      contentType: Headers.jsonContentType,
    ),
  );
  dio.httpClientAdapter = transport;
  return AiDiagnosisApiService(ApiClient(dio, store ?? TestSession()));
}

void main() {
  test(
    'N/B: recreates repeated image streams after one 401 and rotates credentials',
    () async {
      final transport = DiagnosisTransport()..rejectFirst = true;
      final store = TestSession();
      final result = await service(
        transport,
        store,
      ).create('season', [sampleImage(), sampleImage()]);
      expect(result.id, 'diagnosis');
      expect(transport.requests.map((r) => r.method), ['POST', 'POST', 'POST']);
      expect(transport.requests.map((r) => r.path), [
        '/technician/seasons/season/ai-diagnoses',
        '/auth/refresh-token',
        '/technician/seasons/season/ai-diagnoses',
      ]);
      expect(
        transport.requests.first.headers['Authorization'],
        'Bearer expired',
      );
      expect(
        transport.requests.last.headers['Authorization'],
        'Bearer renewed',
      );
      expect(store.refreshToken, 'rotated');
      for (final i in [0, 2]) {
        expect(
          RegExp('name="images"').allMatches(transport.bodies[i]).length,
          2,
        );
        expect(transport.bodies[i], contains('filename="shrimp.png"'));
        expect(transport.bodies[i], contains('content-type: image/png'));
        expect(
          transport.bodies[i],
          contains(latin1.decode(sampleImage().bytes)),
        );
        expect(transport.requests[i].sendTimeout, AppConfig.aiDiagnosisTimeout);
        expect(
          transport.requests[i].receiveTimeout,
          AppConfig.aiDiagnosisTimeout,
        );
      }
    },
  );
  test('A: a timeout never repeats a classification POST', () async {
    final transport = DiagnosisTransport()..timeout = true;
    await expectLater(
      service(transport).create('season', [sampleImage()]),
      throwsA(isA<NetworkException>()),
    );
    expect(transport.requests.length, 1);
  });
  test('N: reads cursor pagination through the standard envelope', () async {
    final transport = DiagnosisTransport()
      ..response = {
        'success': true,
        'message': 'OK',
        'data': [summaryJson()],
        'meta': {'totalResults': 2, 'hasNextPage': true, 'nextCursor': 'next'},
      };
    final page = await service(transport).list('season', cursor: 'previous');
    expect(page.pagination.nextCursor, 'next');
    expect(transport.requests.single.method, 'GET');
    expect(transport.requests.single.queryParameters, {
      'limit': 10,
      'cursor': 'previous',
    });
  });
  test(
    'N: the initial GET requests exactly ten items without a cursor',
    () async {
      final transport = DiagnosisTransport()
        ..response = {
          'success': true,
          'message': 'OK',
          'data': List.generate(10, (i) => summaryJson(id: 'diagnosis-$i')),
          'meta': {
            'totalResults': 25,
            'hasNextPage': true,
            'nextCursor': 'next-10',
          },
        };
      final page = await service(transport).list('season');
      expect(page.items.length, 10);
      expect(transport.requests.single.queryParameters, {'limit': 10});
    },
  );
  test('A: rejects a response that exceeds the requested page size', () async {
    final transport = DiagnosisTransport()
      ..response = {
        'success': true,
        'message': 'OK',
        'data': List.generate(11, (i) => summaryJson(id: 'diagnosis-$i')),
        'meta': {
          'totalResults': 25,
          'hasNextPage': true,
          'nextCursor': 'next-11',
        },
      };
    await expectLater(
      service(transport).list('season'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('A: rejects a cursor that does not advance', () async {
    final transport = DiagnosisTransport()
      ..response = {
        'success': true,
        'message': 'OK',
        'data': [summaryJson()],
        'meta': {'totalResults': 2, 'hasNextPage': true, 'nextCursor': 'same'},
      };
    await expectLater(
      service(transport).list('season', cursor: 'same'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('A: detail must belong to the requested season and diagnosis', () async {
    final transport = DiagnosisTransport();
    await expectLater(
      service(transport).detail('other-season', 'diagnosis'),
      throwsA(isA<InvalidResponseException>()),
    );
    await expectLater(
      service(transport).detail('season', 'other-diagnosis'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  for (final status in [403, 404, 429, 502, 503, 504]) {
    test('A: preserves HTTP $status and the backend message', () async {
      final transport = DiagnosisTransport()
        ..statusCode = status
        ..response = {
          'success': false,
          'statusCode': status,
          'message': 'Không thể nhận diện.',
        };
      await expectLater(
        service(transport).create('season', [sampleImage()]),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', status)
              .having((e) => e.message, 'message', 'Không thể nhận diện.'),
        ),
      );
      expect(transport.requests.length, 1);
    });
  }
}
