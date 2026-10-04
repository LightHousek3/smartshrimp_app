import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';

final class RagApiService {
  RagApiService(this._client);
  final ApiClient _client;
  static const _base = '/me/rag';
  Future<RagConversationPage> list(String seasonId, {int page = 1}) async {
    final response = await _client.get(
      '$_base/conversations',
      authenticated: true,
      queryParameters: {'seasonId': seasonId, 'page': page},
    );
    final meta = response.meta;
    if (meta?['hasNextPage'] is! bool || meta?['page'] is! int) {
      throw const InvalidResponseException();
    }
    if (meta?['totalResults'] != null &&
        (meta!['totalResults'] is! int || (meta['totalResults'] as int) < 0)) {
      throw const InvalidResponseException();
    }
    return RagConversationPage(
      items: response.requireListData().map((e) {
        if (e is! Map<String, dynamic>) throw const InvalidResponseException();
        return RagConversationSummary.parse(e);
      }).toList(),
      hasNextPage: meta!['hasNextPage'] as bool,
      page: meta['page'] as int,
      totalResults: meta['totalResults'] as int?,
    );
  }

  Future<RagChatState> detail(String id, {int page = 1}) async {
    final response = await _client.get(
      '$_base/conversations/${Uri.encodeComponent(id)}',
      authenticated: true,
      queryParameters: {'page': page, 'limit': 50},
    );
    try {
      final data = response.requireMapData();
      final season = data['season'] as Map<String, dynamic>;
      final seasonId = data['seasonId'] as String;
      if (seasonId.isEmpty || season['id'] != seasonId) {
        throw const InvalidResponseException();
      }
      return RagChatState(
        seasonId: seasonId,
        seasonName: season['name'] as String,
        conversationId: data['id'] as String,
        canAsk: data['canAsk'] as bool,
        queries: (data['queries'] as List)
            .map((e) => RagQuery.parse(e as Map<String, dynamic>))
            .toList(),
        hasNextPage: response.meta!['hasNextPage'] as bool,
        page: response.meta!['page'] as int,
      );
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }

  Future<RagQuery> ask({
    required String seasonId,
    required String question,
    String? conversationId,
  }) async {
    final response = await _client.post(
      '$_base/queries',
      authenticated: true,
      receiveTimeout: const Duration(seconds: 75),
      data: {
        'seasonId': seasonId,
        'question': question,
        'conversationId': ?conversationId,
      },
    );
    return RagQuery.parse(response.requireMapData());
  }

  Future<RagFeedback> rate(String id, int rating, String? comment) async {
    final response = await _client.put(
      '$_base/queries/${Uri.encodeComponent(id)}/feedback',
      authenticated: true,
      data: {'rating': rating, 'comment': comment},
    );
    try {
      final feedback = RagFeedback.fromJson(response.requireMapData());
      if (feedback.rating < 1 || feedback.rating > 5) {
        throw const InvalidResponseException();
      }
      return feedback;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }
}
