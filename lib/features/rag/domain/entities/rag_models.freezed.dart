// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rag_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RagChunk {

@JsonKey(name: 'source_file') String get sourceFile;@JsonKey(name: 'chunk_index') int get chunkIndex; String get content; double get similarity;
/// Create a copy of RagChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagChunkCopyWith<RagChunk> get copyWith => _$RagChunkCopyWithImpl<RagChunk>(this as RagChunk, _$identity);

  /// Serializes this RagChunk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagChunk&&(identical(other.sourceFile, sourceFile) || other.sourceFile == sourceFile)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.content, content) || other.content == content)&&(identical(other.similarity, similarity) || other.similarity == similarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceFile,chunkIndex,content,similarity);

@override
String toString() {
  return 'RagChunk(sourceFile: $sourceFile, chunkIndex: $chunkIndex, content: $content, similarity: $similarity)';
}


}

/// @nodoc
abstract mixin class $RagChunkCopyWith<$Res>  {
  factory $RagChunkCopyWith(RagChunk value, $Res Function(RagChunk) _then) = _$RagChunkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'source_file') String sourceFile,@JsonKey(name: 'chunk_index') int chunkIndex, String content, double similarity
});




}
/// @nodoc
class _$RagChunkCopyWithImpl<$Res>
    implements $RagChunkCopyWith<$Res> {
  _$RagChunkCopyWithImpl(this._self, this._then);

  final RagChunk _self;
  final $Res Function(RagChunk) _then;

/// Create a copy of RagChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceFile = null,Object? chunkIndex = null,Object? content = null,Object? similarity = null,}) {
  return _then(_self.copyWith(
sourceFile: null == sourceFile ? _self.sourceFile : sourceFile // ignore: cast_nullable_to_non_nullable
as String,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,similarity: null == similarity ? _self.similarity : similarity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RagChunk].
extension RagChunkPatterns on RagChunk {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagChunk() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagChunk value)  $default,){
final _that = this;
switch (_that) {
case _RagChunk():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagChunk value)?  $default,){
final _that = this;
switch (_that) {
case _RagChunk() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_file')  String sourceFile, @JsonKey(name: 'chunk_index')  int chunkIndex,  String content,  double similarity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagChunk() when $default != null:
return $default(_that.sourceFile,_that.chunkIndex,_that.content,_that.similarity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_file')  String sourceFile, @JsonKey(name: 'chunk_index')  int chunkIndex,  String content,  double similarity)  $default,) {final _that = this;
switch (_that) {
case _RagChunk():
return $default(_that.sourceFile,_that.chunkIndex,_that.content,_that.similarity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'source_file')  String sourceFile, @JsonKey(name: 'chunk_index')  int chunkIndex,  String content,  double similarity)?  $default,) {final _that = this;
switch (_that) {
case _RagChunk() when $default != null:
return $default(_that.sourceFile,_that.chunkIndex,_that.content,_that.similarity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RagChunk implements RagChunk {
  const _RagChunk({@JsonKey(name: 'source_file') required this.sourceFile, @JsonKey(name: 'chunk_index') required this.chunkIndex, required this.content, required this.similarity});
  factory _RagChunk.fromJson(Map<String, dynamic> json) => _$RagChunkFromJson(json);

@override@JsonKey(name: 'source_file') final  String sourceFile;
@override@JsonKey(name: 'chunk_index') final  int chunkIndex;
@override final  String content;
@override final  double similarity;

/// Create a copy of RagChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagChunkCopyWith<_RagChunk> get copyWith => __$RagChunkCopyWithImpl<_RagChunk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RagChunkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagChunk&&(identical(other.sourceFile, sourceFile) || other.sourceFile == sourceFile)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.content, content) || other.content == content)&&(identical(other.similarity, similarity) || other.similarity == similarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceFile,chunkIndex,content,similarity);

@override
String toString() {
  return 'RagChunk(sourceFile: $sourceFile, chunkIndex: $chunkIndex, content: $content, similarity: $similarity)';
}


}

/// @nodoc
abstract mixin class _$RagChunkCopyWith<$Res> implements $RagChunkCopyWith<$Res> {
  factory _$RagChunkCopyWith(_RagChunk value, $Res Function(_RagChunk) _then) = __$RagChunkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'source_file') String sourceFile,@JsonKey(name: 'chunk_index') int chunkIndex, String content, double similarity
});




}
/// @nodoc
class __$RagChunkCopyWithImpl<$Res>
    implements _$RagChunkCopyWith<$Res> {
  __$RagChunkCopyWithImpl(this._self, this._then);

  final _RagChunk _self;
  final $Res Function(_RagChunk) _then;

/// Create a copy of RagChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceFile = null,Object? chunkIndex = null,Object? content = null,Object? similarity = null,}) {
  return _then(_RagChunk(
sourceFile: null == sourceFile ? _self.sourceFile : sourceFile // ignore: cast_nullable_to_non_nullable
as String,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,similarity: null == similarity ? _self.similarity : similarity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$RagFeedback {

 String get id; int get rating; String? get comment;
/// Create a copy of RagFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagFeedbackCopyWith<RagFeedback> get copyWith => _$RagFeedbackCopyWithImpl<RagFeedback>(this as RagFeedback, _$identity);

  /// Serializes this RagFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rating,comment);

@override
String toString() {
  return 'RagFeedback(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $RagFeedbackCopyWith<$Res>  {
  factory $RagFeedbackCopyWith(RagFeedback value, $Res Function(RagFeedback) _then) = _$RagFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, int rating, String? comment
});




}
/// @nodoc
class _$RagFeedbackCopyWithImpl<$Res>
    implements $RagFeedbackCopyWith<$Res> {
  _$RagFeedbackCopyWithImpl(this._self, this._then);

  final RagFeedback _self;
  final $Res Function(RagFeedback) _then;

/// Create a copy of RagFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rating = null,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RagFeedback].
extension RagFeedbackPatterns on RagFeedback {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagFeedback() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagFeedback value)  $default,){
final _that = this;
switch (_that) {
case _RagFeedback():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _RagFeedback() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int rating,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagFeedback() when $default != null:
return $default(_that.id,_that.rating,_that.comment);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int rating,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _RagFeedback():
return $default(_that.id,_that.rating,_that.comment);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int rating,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _RagFeedback() when $default != null:
return $default(_that.id,_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RagFeedback implements RagFeedback {
  const _RagFeedback({required this.id, required this.rating, this.comment});
  factory _RagFeedback.fromJson(Map<String, dynamic> json) => _$RagFeedbackFromJson(json);

@override final  String id;
@override final  int rating;
@override final  String? comment;

/// Create a copy of RagFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagFeedbackCopyWith<_RagFeedback> get copyWith => __$RagFeedbackCopyWithImpl<_RagFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RagFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rating,comment);

@override
String toString() {
  return 'RagFeedback(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$RagFeedbackCopyWith<$Res> implements $RagFeedbackCopyWith<$Res> {
  factory _$RagFeedbackCopyWith(_RagFeedback value, $Res Function(_RagFeedback) _then) = __$RagFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, int rating, String? comment
});




}
/// @nodoc
class __$RagFeedbackCopyWithImpl<$Res>
    implements _$RagFeedbackCopyWith<$Res> {
  __$RagFeedbackCopyWithImpl(this._self, this._then);

  final _RagFeedback _self;
  final $Res Function(_RagFeedback) _then;

/// Create a copy of RagFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rating = null,Object? comment = freezed,}) {
  return _then(_RagFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RagQuery {

 String get id; String get conversationId; String get question; RagQueryStatus get queryStatus; DateTime get createdAt; List<RagChunk> get retrievedChunks; String? get answer; String? get warning; String? get errorMessage; double? get topSimilarity; RagFeedback? get feedback;
/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagQueryCopyWith<RagQuery> get copyWith => _$RagQueryCopyWithImpl<RagQuery>(this as RagQuery, _$identity);

  /// Serializes this RagQuery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagQuery&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.question, question) || other.question == question)&&(identical(other.queryStatus, queryStatus) || other.queryStatus == queryStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.retrievedChunks, retrievedChunks)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.topSimilarity, topSimilarity) || other.topSimilarity == topSimilarity)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,question,queryStatus,createdAt,const DeepCollectionEquality().hash(retrievedChunks),answer,warning,errorMessage,topSimilarity,feedback);

@override
String toString() {
  return 'RagQuery(id: $id, conversationId: $conversationId, question: $question, queryStatus: $queryStatus, createdAt: $createdAt, retrievedChunks: $retrievedChunks, answer: $answer, warning: $warning, errorMessage: $errorMessage, topSimilarity: $topSimilarity, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $RagQueryCopyWith<$Res>  {
  factory $RagQueryCopyWith(RagQuery value, $Res Function(RagQuery) _then) = _$RagQueryCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String question, RagQueryStatus queryStatus, DateTime createdAt, List<RagChunk> retrievedChunks, String? answer, String? warning, String? errorMessage, double? topSimilarity, RagFeedback? feedback
});


$RagFeedbackCopyWith<$Res>? get feedback;

}
/// @nodoc
class _$RagQueryCopyWithImpl<$Res>
    implements $RagQueryCopyWith<$Res> {
  _$RagQueryCopyWithImpl(this._self, this._then);

  final RagQuery _self;
  final $Res Function(RagQuery) _then;

/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? question = null,Object? queryStatus = null,Object? createdAt = null,Object? retrievedChunks = null,Object? answer = freezed,Object? warning = freezed,Object? errorMessage = freezed,Object? topSimilarity = freezed,Object? feedback = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,queryStatus: null == queryStatus ? _self.queryStatus : queryStatus // ignore: cast_nullable_to_non_nullable
as RagQueryStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retrievedChunks: null == retrievedChunks ? _self.retrievedChunks : retrievedChunks // ignore: cast_nullable_to_non_nullable
as List<RagChunk>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String?,warning: freezed == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,topSimilarity: freezed == topSimilarity ? _self.topSimilarity : topSimilarity // ignore: cast_nullable_to_non_nullable
as double?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as RagFeedback?,
  ));
}
/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RagFeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $RagFeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}


/// Adds pattern-matching-related methods to [RagQuery].
extension RagQueryPatterns on RagQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagQuery value)  $default,){
final _that = this;
switch (_that) {
case _RagQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagQuery value)?  $default,){
final _that = this;
switch (_that) {
case _RagQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String question,  RagQueryStatus queryStatus,  DateTime createdAt,  List<RagChunk> retrievedChunks,  String? answer,  String? warning,  String? errorMessage,  double? topSimilarity,  RagFeedback? feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagQuery() when $default != null:
return $default(_that.id,_that.conversationId,_that.question,_that.queryStatus,_that.createdAt,_that.retrievedChunks,_that.answer,_that.warning,_that.errorMessage,_that.topSimilarity,_that.feedback);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String question,  RagQueryStatus queryStatus,  DateTime createdAt,  List<RagChunk> retrievedChunks,  String? answer,  String? warning,  String? errorMessage,  double? topSimilarity,  RagFeedback? feedback)  $default,) {final _that = this;
switch (_that) {
case _RagQuery():
return $default(_that.id,_that.conversationId,_that.question,_that.queryStatus,_that.createdAt,_that.retrievedChunks,_that.answer,_that.warning,_that.errorMessage,_that.topSimilarity,_that.feedback);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String question,  RagQueryStatus queryStatus,  DateTime createdAt,  List<RagChunk> retrievedChunks,  String? answer,  String? warning,  String? errorMessage,  double? topSimilarity,  RagFeedback? feedback)?  $default,) {final _that = this;
switch (_that) {
case _RagQuery() when $default != null:
return $default(_that.id,_that.conversationId,_that.question,_that.queryStatus,_that.createdAt,_that.retrievedChunks,_that.answer,_that.warning,_that.errorMessage,_that.topSimilarity,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RagQuery extends RagQuery {
  const _RagQuery({required this.id, required this.conversationId, required this.question, required this.queryStatus, required this.createdAt, required final  List<RagChunk> retrievedChunks, this.answer, this.warning, this.errorMessage, this.topSimilarity, this.feedback}): _retrievedChunks = retrievedChunks,super._();
  factory _RagQuery.fromJson(Map<String, dynamic> json) => _$RagQueryFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String question;
@override final  RagQueryStatus queryStatus;
@override final  DateTime createdAt;
 final  List<RagChunk> _retrievedChunks;
@override List<RagChunk> get retrievedChunks {
  if (_retrievedChunks is EqualUnmodifiableListView) return _retrievedChunks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_retrievedChunks);
}

@override final  String? answer;
@override final  String? warning;
@override final  String? errorMessage;
@override final  double? topSimilarity;
@override final  RagFeedback? feedback;

/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagQueryCopyWith<_RagQuery> get copyWith => __$RagQueryCopyWithImpl<_RagQuery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RagQueryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagQuery&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.question, question) || other.question == question)&&(identical(other.queryStatus, queryStatus) || other.queryStatus == queryStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._retrievedChunks, _retrievedChunks)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.topSimilarity, topSimilarity) || other.topSimilarity == topSimilarity)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,question,queryStatus,createdAt,const DeepCollectionEquality().hash(_retrievedChunks),answer,warning,errorMessage,topSimilarity,feedback);

@override
String toString() {
  return 'RagQuery(id: $id, conversationId: $conversationId, question: $question, queryStatus: $queryStatus, createdAt: $createdAt, retrievedChunks: $retrievedChunks, answer: $answer, warning: $warning, errorMessage: $errorMessage, topSimilarity: $topSimilarity, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$RagQueryCopyWith<$Res> implements $RagQueryCopyWith<$Res> {
  factory _$RagQueryCopyWith(_RagQuery value, $Res Function(_RagQuery) _then) = __$RagQueryCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String question, RagQueryStatus queryStatus, DateTime createdAt, List<RagChunk> retrievedChunks, String? answer, String? warning, String? errorMessage, double? topSimilarity, RagFeedback? feedback
});


@override $RagFeedbackCopyWith<$Res>? get feedback;

}
/// @nodoc
class __$RagQueryCopyWithImpl<$Res>
    implements _$RagQueryCopyWith<$Res> {
  __$RagQueryCopyWithImpl(this._self, this._then);

  final _RagQuery _self;
  final $Res Function(_RagQuery) _then;

/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? question = null,Object? queryStatus = null,Object? createdAt = null,Object? retrievedChunks = null,Object? answer = freezed,Object? warning = freezed,Object? errorMessage = freezed,Object? topSimilarity = freezed,Object? feedback = freezed,}) {
  return _then(_RagQuery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,queryStatus: null == queryStatus ? _self.queryStatus : queryStatus // ignore: cast_nullable_to_non_nullable
as RagQueryStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retrievedChunks: null == retrievedChunks ? _self._retrievedChunks : retrievedChunks // ignore: cast_nullable_to_non_nullable
as List<RagChunk>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String?,warning: freezed == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,topSimilarity: freezed == topSimilarity ? _self.topSimilarity : topSimilarity // ignore: cast_nullable_to_non_nullable
as double?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as RagFeedback?,
  ));
}

/// Create a copy of RagQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RagFeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $RagFeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}


/// @nodoc
mixin _$RagConversationSummary {

 String get id; String get seasonId; DateTime get lastMessageAt; String? get title; String? get lastMessagePreview; int? get messageCount;
/// Create a copy of RagConversationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagConversationSummaryCopyWith<RagConversationSummary> get copyWith => _$RagConversationSummaryCopyWithImpl<RagConversationSummary>(this as RagConversationSummary, _$identity);

  /// Serializes this RagConversationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagConversationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,lastMessageAt,title,lastMessagePreview,messageCount);

@override
String toString() {
  return 'RagConversationSummary(id: $id, seasonId: $seasonId, lastMessageAt: $lastMessageAt, title: $title, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount)';
}


}

/// @nodoc
abstract mixin class $RagConversationSummaryCopyWith<$Res>  {
  factory $RagConversationSummaryCopyWith(RagConversationSummary value, $Res Function(RagConversationSummary) _then) = _$RagConversationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, DateTime lastMessageAt, String? title, String? lastMessagePreview, int? messageCount
});




}
/// @nodoc
class _$RagConversationSummaryCopyWithImpl<$Res>
    implements $RagConversationSummaryCopyWith<$Res> {
  _$RagConversationSummaryCopyWithImpl(this._self, this._then);

  final RagConversationSummary _self;
  final $Res Function(RagConversationSummary) _then;

/// Create a copy of RagConversationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? lastMessageAt = null,Object? title = freezed,Object? lastMessagePreview = freezed,Object? messageCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: freezed == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RagConversationSummary].
extension RagConversationSummaryPatterns on RagConversationSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagConversationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagConversationSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagConversationSummary value)  $default,){
final _that = this;
switch (_that) {
case _RagConversationSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagConversationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RagConversationSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  DateTime lastMessageAt,  String? title,  String? lastMessagePreview,  int? messageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagConversationSummary() when $default != null:
return $default(_that.id,_that.seasonId,_that.lastMessageAt,_that.title,_that.lastMessagePreview,_that.messageCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  DateTime lastMessageAt,  String? title,  String? lastMessagePreview,  int? messageCount)  $default,) {final _that = this;
switch (_that) {
case _RagConversationSummary():
return $default(_that.id,_that.seasonId,_that.lastMessageAt,_that.title,_that.lastMessagePreview,_that.messageCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  DateTime lastMessageAt,  String? title,  String? lastMessagePreview,  int? messageCount)?  $default,) {final _that = this;
switch (_that) {
case _RagConversationSummary() when $default != null:
return $default(_that.id,_that.seasonId,_that.lastMessageAt,_that.title,_that.lastMessagePreview,_that.messageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RagConversationSummary implements RagConversationSummary {
  const _RagConversationSummary({required this.id, required this.seasonId, required this.lastMessageAt, this.title, this.lastMessagePreview, this.messageCount});
  factory _RagConversationSummary.fromJson(Map<String, dynamic> json) => _$RagConversationSummaryFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  DateTime lastMessageAt;
@override final  String? title;
@override final  String? lastMessagePreview;
@override final  int? messageCount;

/// Create a copy of RagConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagConversationSummaryCopyWith<_RagConversationSummary> get copyWith => __$RagConversationSummaryCopyWithImpl<_RagConversationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RagConversationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagConversationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,lastMessageAt,title,lastMessagePreview,messageCount);

@override
String toString() {
  return 'RagConversationSummary(id: $id, seasonId: $seasonId, lastMessageAt: $lastMessageAt, title: $title, lastMessagePreview: $lastMessagePreview, messageCount: $messageCount)';
}


}

/// @nodoc
abstract mixin class _$RagConversationSummaryCopyWith<$Res> implements $RagConversationSummaryCopyWith<$Res> {
  factory _$RagConversationSummaryCopyWith(_RagConversationSummary value, $Res Function(_RagConversationSummary) _then) = __$RagConversationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, DateTime lastMessageAt, String? title, String? lastMessagePreview, int? messageCount
});




}
/// @nodoc
class __$RagConversationSummaryCopyWithImpl<$Res>
    implements _$RagConversationSummaryCopyWith<$Res> {
  __$RagConversationSummaryCopyWithImpl(this._self, this._then);

  final _RagConversationSummary _self;
  final $Res Function(_RagConversationSummary) _then;

/// Create a copy of RagConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? lastMessageAt = null,Object? title = freezed,Object? lastMessagePreview = freezed,Object? messageCount = freezed,}) {
  return _then(_RagConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,messageCount: freezed == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$RagConversationPage {

 List<RagConversationSummary> get items; bool get hasNextPage; int get page; int? get totalResults;
/// Create a copy of RagConversationPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagConversationPageCopyWith<RagConversationPage> get copyWith => _$RagConversationPageCopyWithImpl<RagConversationPage>(this as RagConversationPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagConversationPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),hasNextPage,page,totalResults);

@override
String toString() {
  return 'RagConversationPage(items: $items, hasNextPage: $hasNextPage, page: $page, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class $RagConversationPageCopyWith<$Res>  {
  factory $RagConversationPageCopyWith(RagConversationPage value, $Res Function(RagConversationPage) _then) = _$RagConversationPageCopyWithImpl;
@useResult
$Res call({
 List<RagConversationSummary> items, bool hasNextPage, int page, int? totalResults
});




}
/// @nodoc
class _$RagConversationPageCopyWithImpl<$Res>
    implements $RagConversationPageCopyWith<$Res> {
  _$RagConversationPageCopyWithImpl(this._self, this._then);

  final RagConversationPage _self;
  final $Res Function(RagConversationPage) _then;

/// Create a copy of RagConversationPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasNextPage = null,Object? page = null,Object? totalResults = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RagConversationSummary>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalResults: freezed == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RagConversationPage].
extension RagConversationPagePatterns on RagConversationPage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagConversationPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagConversationPage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagConversationPage value)  $default,){
final _that = this;
switch (_that) {
case _RagConversationPage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagConversationPage value)?  $default,){
final _that = this;
switch (_that) {
case _RagConversationPage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RagConversationSummary> items,  bool hasNextPage,  int page,  int? totalResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagConversationPage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.page,_that.totalResults);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RagConversationSummary> items,  bool hasNextPage,  int page,  int? totalResults)  $default,) {final _that = this;
switch (_that) {
case _RagConversationPage():
return $default(_that.items,_that.hasNextPage,_that.page,_that.totalResults);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RagConversationSummary> items,  bool hasNextPage,  int page,  int? totalResults)?  $default,) {final _that = this;
switch (_that) {
case _RagConversationPage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.page,_that.totalResults);case _:
  return null;

}
}

}

/// @nodoc


class _RagConversationPage implements RagConversationPage {
  const _RagConversationPage({required final  List<RagConversationSummary> items, required this.hasNextPage, required this.page, this.totalResults}): _items = items;


 final  List<RagConversationSummary> _items;
@override List<RagConversationSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasNextPage;
@override final  int page;
@override final  int? totalResults;

/// Create a copy of RagConversationPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagConversationPageCopyWith<_RagConversationPage> get copyWith => __$RagConversationPageCopyWithImpl<_RagConversationPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagConversationPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNextPage,page,totalResults);

@override
String toString() {
  return 'RagConversationPage(items: $items, hasNextPage: $hasNextPage, page: $page, totalResults: $totalResults)';
}


}

/// @nodoc
abstract mixin class _$RagConversationPageCopyWith<$Res> implements $RagConversationPageCopyWith<$Res> {
  factory _$RagConversationPageCopyWith(_RagConversationPage value, $Res Function(_RagConversationPage) _then) = __$RagConversationPageCopyWithImpl;
@override @useResult
$Res call({
 List<RagConversationSummary> items, bool hasNextPage, int page, int? totalResults
});




}
/// @nodoc
class __$RagConversationPageCopyWithImpl<$Res>
    implements _$RagConversationPageCopyWith<$Res> {
  __$RagConversationPageCopyWithImpl(this._self, this._then);

  final _RagConversationPage _self;
  final $Res Function(_RagConversationPage) _then;

/// Create a copy of RagConversationPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNextPage = null,Object? page = null,Object? totalResults = freezed,}) {
  return _then(_RagConversationPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RagConversationSummary>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalResults: freezed == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$RagChatState {

 String get seasonId; String get seasonName; bool get canAsk; String? get conversationId; List<RagQuery> get queries; bool get hasNextPage; int get page; bool get busy;
/// Create a copy of RagChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RagChatStateCopyWith<RagChatState> get copyWith => _$RagChatStateCopyWithImpl<RagChatState>(this as RagChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RagChatState&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.canAsk, canAsk) || other.canAsk == canAsk)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other.queries, queries)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.page, page) || other.page == page)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,canAsk,conversationId,const DeepCollectionEquality().hash(queries),hasNextPage,page,busy);

@override
String toString() {
  return 'RagChatState(seasonId: $seasonId, seasonName: $seasonName, canAsk: $canAsk, conversationId: $conversationId, queries: $queries, hasNextPage: $hasNextPage, page: $page, busy: $busy)';
}


}

/// @nodoc
abstract mixin class $RagChatStateCopyWith<$Res>  {
  factory $RagChatStateCopyWith(RagChatState value, $Res Function(RagChatState) _then) = _$RagChatStateCopyWithImpl;
@useResult
$Res call({
 String seasonId, String seasonName, bool canAsk, String? conversationId, List<RagQuery> queries, bool hasNextPage, int page, bool busy
});




}
/// @nodoc
class _$RagChatStateCopyWithImpl<$Res>
    implements $RagChatStateCopyWith<$Res> {
  _$RagChatStateCopyWithImpl(this._self, this._then);

  final RagChatState _self;
  final $Res Function(RagChatState) _then;

/// Create a copy of RagChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonId = null,Object? seasonName = null,Object? canAsk = null,Object? conversationId = freezed,Object? queries = null,Object? hasNextPage = null,Object? page = null,Object? busy = null,}) {
  return _then(_self.copyWith(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,canAsk: null == canAsk ? _self.canAsk : canAsk // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,queries: null == queries ? _self.queries : queries // ignore: cast_nullable_to_non_nullable
as List<RagQuery>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RagChatState].
extension RagChatStatePatterns on RagChatState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RagChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RagChatState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RagChatState value)  $default,){
final _that = this;
switch (_that) {
case _RagChatState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RagChatState value)?  $default,){
final _that = this;
switch (_that) {
case _RagChatState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  bool canAsk,  String? conversationId,  List<RagQuery> queries,  bool hasNextPage,  int page,  bool busy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RagChatState() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.canAsk,_that.conversationId,_that.queries,_that.hasNextPage,_that.page,_that.busy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  bool canAsk,  String? conversationId,  List<RagQuery> queries,  bool hasNextPage,  int page,  bool busy)  $default,) {final _that = this;
switch (_that) {
case _RagChatState():
return $default(_that.seasonId,_that.seasonName,_that.canAsk,_that.conversationId,_that.queries,_that.hasNextPage,_that.page,_that.busy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String seasonId,  String seasonName,  bool canAsk,  String? conversationId,  List<RagQuery> queries,  bool hasNextPage,  int page,  bool busy)?  $default,) {final _that = this;
switch (_that) {
case _RagChatState() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.canAsk,_that.conversationId,_that.queries,_that.hasNextPage,_that.page,_that.busy);case _:
  return null;

}
}

}

/// @nodoc


class _RagChatState implements RagChatState {
  const _RagChatState({required this.seasonId, required this.seasonName, required this.canAsk, this.conversationId, final  List<RagQuery> queries = const [], this.hasNextPage = false, this.page = 1, this.busy = false}): _queries = queries;


@override final  String seasonId;
@override final  String seasonName;
@override final  bool canAsk;
@override final  String? conversationId;
 final  List<RagQuery> _queries;
@override@JsonKey() List<RagQuery> get queries {
  if (_queries is EqualUnmodifiableListView) return _queries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queries);
}

@override@JsonKey() final  bool hasNextPage;
@override@JsonKey() final  int page;
@override@JsonKey() final  bool busy;

/// Create a copy of RagChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RagChatStateCopyWith<_RagChatState> get copyWith => __$RagChatStateCopyWithImpl<_RagChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RagChatState&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.canAsk, canAsk) || other.canAsk == canAsk)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._queries, _queries)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.page, page) || other.page == page)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,canAsk,conversationId,const DeepCollectionEquality().hash(_queries),hasNextPage,page,busy);

@override
String toString() {
  return 'RagChatState(seasonId: $seasonId, seasonName: $seasonName, canAsk: $canAsk, conversationId: $conversationId, queries: $queries, hasNextPage: $hasNextPage, page: $page, busy: $busy)';
}


}

/// @nodoc
abstract mixin class _$RagChatStateCopyWith<$Res> implements $RagChatStateCopyWith<$Res> {
  factory _$RagChatStateCopyWith(_RagChatState value, $Res Function(_RagChatState) _then) = __$RagChatStateCopyWithImpl;
@override @useResult
$Res call({
 String seasonId, String seasonName, bool canAsk, String? conversationId, List<RagQuery> queries, bool hasNextPage, int page, bool busy
});




}
/// @nodoc
class __$RagChatStateCopyWithImpl<$Res>
    implements _$RagChatStateCopyWith<$Res> {
  __$RagChatStateCopyWithImpl(this._self, this._then);

  final _RagChatState _self;
  final $Res Function(_RagChatState) _then;

/// Create a copy of RagChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonId = null,Object? seasonName = null,Object? canAsk = null,Object? conversationId = freezed,Object? queries = null,Object? hasNextPage = null,Object? page = null,Object? busy = null,}) {
  return _then(_RagChatState(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,canAsk: null == canAsk ? _self.canAsk : canAsk // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,queries: null == queries ? _self._queries : queries // ignore: cast_nullable_to_non_nullable
as List<RagQuery>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
