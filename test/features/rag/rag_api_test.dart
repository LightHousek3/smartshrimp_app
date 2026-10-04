import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/rag/data/services/rag_api_service.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';

Map<String, dynamic> queryJson({String status = 'LOW_MATCH'}) => {
  'id': 'query',
  'conversationId': 'conversation',
  'question': 'Câu hỏi',
  'answer': 'Câu trả lời',
  'queryStatus': status,
  'createdAt': '2026-10-04T00:00:00Z',
  'warning': 'Cần kiểm chứng',
  'retrievedChunks': [
    {
      'source_file': 'guide.pdf',
      'chunk_index': 0,
      'content': 'Nguồn',
      'similarity': 0.3,
    },
  ],
};
void main() {
  test(
    'list parses real preview, message count and total pagination count',
    () async {
      final api = service((request) {
        expect(request.path, '/me/rag/conversations');
        expect(request.queryParameters, {'seasonId': 'season', 'page': 2});
        return [
          {
            'id': 'conversation',
            'seasonId': 'season',
            'title': 'Title',
            'lastMessageAt': '2025-09-08T06:40:00Z',
            'lastMessagePreview': 'Latest answer',
            'messageCount': 4,
          },
        ];
      });
      final page = await api.list('season', page: 2);
      expect(page.totalResults, 23);
      expect(page.items.single.lastMessagePreview, 'Latest answer');
      expect(page.items.single.messageCount, 4);
      expect(page.page, 2);
    },
  );
  test(
    'summary rejects negative message counts and preserves older API compatibility',
    () {
      final json = {
        'id': 'conversation',
        'seasonId': 'season',
        'lastMessageAt': '2025-09-08T06:40:00Z',
      };
      expect(RagConversationSummary.parse(json).messageCount, isNull);
      expect(
        () => RagConversationSummary.parse({...json, 'messageCount': -1}),
        throwsA(isA<InvalidResponseException>()),
      );
    },
  );
  test(
    'POST uses authenticated identity, season and extended AI timeout',
    () async {
      final api = service((request) {
        expect(request.method, 'POST');
        expect(request.path, '/me/rag/queries');
        expect(request.headers['Authorization'], 'Bearer access');
        expect(request.receiveTimeout, const Duration(seconds: 75));
        expect(request.data, {'seasonId': 'season', 'question': 'Q'});
        return queryJson();
      });
      final query = await api.ask(seasonId: 'season', question: 'Q');
      expect(query.queryStatus, RagQueryStatus.lowMatch);
      expect(query.warning, 'Cần kiểm chứng');
      expect(query.retrievedChunks.single.sourceFile, 'guide.pdf');
    },
  );
  test('PUT feedback updates rating and clears optional comment', () async {
    final api = service((request) {
      expect(request.method, 'PUT');
      expect(request.path, '/me/rag/queries/query/feedback');
      expect(request.data, {'rating': 5, 'comment': null});
      return {'id': 'feedback', 'rating': 5, 'comment': null};
    });
    expect((await api.rate('query', 5, null)).rating, 5);
  });
  test('detail requires season and parses pagination and canAsk', () async {
    final api = service((request) {
      expect(request.queryParameters, {'page': 2, 'limit': 50});
      return {
        'id': 'conversation',
        'seasonId': 'season',
        'season': {'id': 'season', 'name': 'Vụ 1'},
        'canAsk': false,
        'queries': [queryJson()],
      };
    });
    final detail = await api.detail('conversation', page: 2);
    expect(detail.canAsk, false);
    expect(detail.page, 2);
    expect(detail.queries.single.canRate, true);
  });
  test('rejects season-less detail', () async {
    final api = service(
      (_) => {
        'id': 'conversation',
        'seasonId': null,
        'season': null,
        'canAsk': true,
        'queries': [],
      },
    );
    await expectLater(
      api.detail('conversation'),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('rejects unknown status, missing answers and invalid rating', () {
    expect(
      () => RagQuery.parse(queryJson(status: 'UNKNOWN')),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => RagQuery.parse({...queryJson(), 'answer': null}),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => RagQuery.parse({
        ...queryJson(),
        'feedback': {'id': 'f', 'rating': 6},
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}

RagApiService service(Object Function(RequestOptions) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, interceptor) => interceptor.resolve(
        Response(
          requestOptions: request,
          statusCode: 200,
          data: {
            'success': true,
            'message': 'OK',
            'data': handler(request),
            'meta': {'page': 2, 'hasNextPage': false, 'totalResults': 23},
          },
        ),
      ),
    ),
  );
  return RagApiService(ApiClient(dio, _Session()));
}

final class _Session implements SessionStore {
  @override
  String? accessToken = 'access';
  @override
  String? refreshToken = 'refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
