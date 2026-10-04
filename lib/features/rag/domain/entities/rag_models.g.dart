// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rag_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RagChunk _$RagChunkFromJson(Map<String, dynamic> json) => _RagChunk(
  sourceFile: json['source_file'] as String,
  chunkIndex: (json['chunk_index'] as num).toInt(),
  content: json['content'] as String,
  similarity: (json['similarity'] as num).toDouble(),
);

Map<String, dynamic> _$RagChunkToJson(_RagChunk instance) => <String, dynamic>{
  'source_file': instance.sourceFile,
  'chunk_index': instance.chunkIndex,
  'content': instance.content,
  'similarity': instance.similarity,
};

_RagFeedback _$RagFeedbackFromJson(Map<String, dynamic> json) => _RagFeedback(
  id: json['id'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$RagFeedbackToJson(_RagFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
    };

_RagQuery _$RagQueryFromJson(Map<String, dynamic> json) => _RagQuery(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  question: json['question'] as String,
  queryStatus: $enumDecode(_$RagQueryStatusEnumMap, json['queryStatus']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  retrievedChunks: (json['retrievedChunks'] as List<dynamic>)
      .map((e) => RagChunk.fromJson(e as Map<String, dynamic>))
      .toList(),
  answer: json['answer'] as String?,
  warning: json['warning'] as String?,
  errorMessage: json['errorMessage'] as String?,
  topSimilarity: (json['topSimilarity'] as num?)?.toDouble(),
  feedback: json['feedback'] == null
      ? null
      : RagFeedback.fromJson(json['feedback'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RagQueryToJson(_RagQuery instance) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'question': instance.question,
  'queryStatus': _$RagQueryStatusEnumMap[instance.queryStatus]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'retrievedChunks': instance.retrievedChunks,
  'answer': instance.answer,
  'warning': instance.warning,
  'errorMessage': instance.errorMessage,
  'topSimilarity': instance.topSimilarity,
  'feedback': instance.feedback,
};

const _$RagQueryStatusEnumMap = {
  RagQueryStatus.answered: 'ANSWERED',
  RagQueryStatus.noSource: 'NO_SOURCE',
  RagQueryStatus.lowMatch: 'LOW_MATCH',
  RagQueryStatus.error: 'ERROR',
};

_RagConversationSummary _$RagConversationSummaryFromJson(
  Map<String, dynamic> json,
) => _RagConversationSummary(
  id: json['id'] as String,
  seasonId: json['seasonId'] as String,
  lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
  title: json['title'] as String?,
  lastMessagePreview: json['lastMessagePreview'] as String?,
  messageCount: (json['messageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$RagConversationSummaryToJson(
  _RagConversationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'seasonId': instance.seasonId,
  'lastMessageAt': instance.lastMessageAt.toIso8601String(),
  'title': instance.title,
  'lastMessagePreview': instance.lastMessagePreview,
  'messageCount': instance.messageCount,
};
