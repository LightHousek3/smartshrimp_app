import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'rag_models.freezed.dart';
part 'rag_models.g.dart';

enum RagQueryStatus {
  @JsonValue('ANSWERED')
  answered,
  @JsonValue('NO_SOURCE')
  noSource,
  @JsonValue('LOW_MATCH')
  lowMatch,
  @JsonValue('ERROR')
  error,
}

@freezed
abstract class RagChunk with _$RagChunk {
  const factory RagChunk({
    @JsonKey(name: 'source_file') required String sourceFile,
    @JsonKey(name: 'chunk_index') required int chunkIndex,
    required String content,
    required double similarity,
  }) = _RagChunk;
  factory RagChunk.fromJson(Map<String, dynamic> json) =>
      _$RagChunkFromJson(json);
}

@freezed
abstract class RagFeedback with _$RagFeedback {
  const factory RagFeedback({
    required String id,
    required int rating,
    String? comment,
  }) = _RagFeedback;
  factory RagFeedback.fromJson(Map<String, dynamic> json) =>
      _$RagFeedbackFromJson(json);
}

@freezed
abstract class RagQuery with _$RagQuery {
  const RagQuery._();
  const factory RagQuery({
    required String id,
    required String conversationId,
    required String question,
    required RagQueryStatus queryStatus,
    required DateTime createdAt,
    required List<RagChunk> retrievedChunks,
    String? answer,
    String? warning,
    String? errorMessage,
    double? topSimilarity,
    RagFeedback? feedback,
  }) = _RagQuery;
  factory RagQuery.fromJson(Map<String, dynamic> json) =>
      _$RagQueryFromJson(json);
  static RagQuery parse(Map<String, dynamic> json) => _parse(() {
    final value = RagQuery.fromJson(json);
    if (value.id.isEmpty ||
        value.conversationId.isEmpty ||
        value.question.trim().isEmpty ||
        (value.queryStatus != RagQueryStatus.error &&
            (value.answer?.trim().isEmpty ?? true)) ||
        value.retrievedChunks.any(
          (c) => c.similarity < 0 || c.similarity > 1,
        ) ||
        (value.feedback != null &&
            (value.feedback!.rating < 1 || value.feedback!.rating > 5))) {
      throw const InvalidResponseException();
    }
    return value;
  });
  bool get canRate => queryStatus != RagQueryStatus.error && answer != null;
}

@freezed
abstract class RagConversationSummary with _$RagConversationSummary {
  const factory RagConversationSummary({
    required String id,
    required String seasonId,
    required DateTime lastMessageAt,
    String? title,
    String? lastMessagePreview,
    int? messageCount,
  }) = _RagConversationSummary;
  factory RagConversationSummary.fromJson(Map<String, dynamic> json) =>
      _$RagConversationSummaryFromJson(json);
  static RagConversationSummary parse(Map<String, dynamic> json) => _parse(() {
    final value = RagConversationSummary.fromJson(json);
    if (value.id.isEmpty ||
        value.seasonId.isEmpty ||
        (value.messageCount != null && value.messageCount! < 0)) {
      throw const InvalidResponseException();
    }
    return value;
  });
}

@freezed
abstract class RagConversationPage with _$RagConversationPage {
  const factory RagConversationPage({
    required List<RagConversationSummary> items,
    required bool hasNextPage,
    required int page,
    int? totalResults,
  }) = _RagConversationPage;
}

@freezed
abstract class RagChatState with _$RagChatState {
  const factory RagChatState({
    required String seasonId,
    required String seasonName,
    required bool canAsk,
    String? conversationId,
    @Default([]) List<RagQuery> queries,
    @Default(false) bool hasNextPage,
    @Default(1) int page,
    @Default(false) bool busy,
  }) = _RagChatState;
}

T _parse<T>(T Function() parse) {
  try {
    return parse();
  } on Object catch (_, stack) {
    Error.throwWithStackTrace(const InvalidResponseException(), stack);
  }
}
