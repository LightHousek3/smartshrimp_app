import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';

abstract interface class RagRepository {
  Future<RagConversationPage> list(String seasonId, {int page = 1});
  Future<RagChatState> detail(String conversationId, {int page = 1});
  Future<RagQuery> ask({
    required String seasonId,
    required String question,
    String? conversationId,
  });
  Future<RagFeedback> rate(String queryId, int rating, String? comment);
}
