import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/rag/data/services/rag_api_service.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/domain/repositories/rag_repository.dart';

final class RagRepositoryImpl implements RagRepository {
  RagRepositoryImpl(this._api);
  final RagApiService _api;
  @override
  Future<RagConversationPage> list(String seasonId, {int page = 1}) =>
      _api.list(seasonId, page: page);
  @override
  Future<RagChatState> detail(String conversationId, {int page = 1}) =>
      _api.detail(conversationId, page: page);
  @override
  Future<RagQuery> ask({
    required String seasonId,
    required String question,
    String? conversationId,
  }) {
    final normalized = question.trim();
    if (normalized.isEmpty || normalized.length > 2000) {
      throw const ApiException(
        'Câu hỏi cần từ 1 đến 2000 ký tự.',
        statusCode: 400,
      );
    }
    return _api.ask(
      seasonId: seasonId,
      question: normalized,
      conversationId: conversationId,
    );
  }

  @override
  Future<RagFeedback> rate(String queryId, int rating, String? comment) {
    final normalized = comment?.trim();
    if (rating < 1 || rating > 5 || (normalized?.length ?? 0) > 2000) {
      throw const ApiException(
        'Đánh giá từ 1–5 sao, bình luận tối đa 2000 ký tự.',
        statusCode: 400,
      );
    }
    return _api.rate(
      queryId,
      rating,
      normalized == null || normalized.isEmpty ? null : normalized,
    );
  }
}
