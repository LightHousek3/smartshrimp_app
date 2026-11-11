// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disease_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaseCreationOptions {

 List<Map<String, dynamic>> get relatedCases; List<Map<String, dynamic>> get aiDiagnoses;
/// Create a copy of CaseCreationOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaseCreationOptionsCopyWith<CaseCreationOptions> get copyWith => _$CaseCreationOptionsCopyWithImpl<CaseCreationOptions>(this as CaseCreationOptions, _$identity);

  /// Serializes this CaseCreationOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaseCreationOptions&&const DeepCollectionEquality().equals(other.relatedCases, relatedCases)&&const DeepCollectionEquality().equals(other.aiDiagnoses, aiDiagnoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(relatedCases),const DeepCollectionEquality().hash(aiDiagnoses));

@override
String toString() {
  return 'CaseCreationOptions(relatedCases: $relatedCases, aiDiagnoses: $aiDiagnoses)';
}


}

/// @nodoc
abstract mixin class $CaseCreationOptionsCopyWith<$Res>  {
  factory $CaseCreationOptionsCopyWith(CaseCreationOptions value, $Res Function(CaseCreationOptions) _then) = _$CaseCreationOptionsCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> relatedCases, List<Map<String, dynamic>> aiDiagnoses
});




}
/// @nodoc
class _$CaseCreationOptionsCopyWithImpl<$Res>
    implements $CaseCreationOptionsCopyWith<$Res> {
  _$CaseCreationOptionsCopyWithImpl(this._self, this._then);

  final CaseCreationOptions _self;
  final $Res Function(CaseCreationOptions) _then;

/// Create a copy of CaseCreationOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relatedCases = null,Object? aiDiagnoses = null,}) {
  return _then(_self.copyWith(
relatedCases: null == relatedCases ? _self.relatedCases : relatedCases // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,aiDiagnoses: null == aiDiagnoses ? _self.aiDiagnoses : aiDiagnoses // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [CaseCreationOptions].
extension CaseCreationOptionsPatterns on CaseCreationOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaseCreationOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaseCreationOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaseCreationOptions value)  $default,){
final _that = this;
switch (_that) {
case _CaseCreationOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaseCreationOptions value)?  $default,){
final _that = this;
switch (_that) {
case _CaseCreationOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> relatedCases,  List<Map<String, dynamic>> aiDiagnoses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaseCreationOptions() when $default != null:
return $default(_that.relatedCases,_that.aiDiagnoses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> relatedCases,  List<Map<String, dynamic>> aiDiagnoses)  $default,) {final _that = this;
switch (_that) {
case _CaseCreationOptions():
return $default(_that.relatedCases,_that.aiDiagnoses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> relatedCases,  List<Map<String, dynamic>> aiDiagnoses)?  $default,) {final _that = this;
switch (_that) {
case _CaseCreationOptions() when $default != null:
return $default(_that.relatedCases,_that.aiDiagnoses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaseCreationOptions implements CaseCreationOptions {
  const _CaseCreationOptions({final  List<Map<String, dynamic>> relatedCases = const [], final  List<Map<String, dynamic>> aiDiagnoses = const []}): _relatedCases = relatedCases,_aiDiagnoses = aiDiagnoses;
  factory _CaseCreationOptions.fromJson(Map<String, dynamic> json) => _$CaseCreationOptionsFromJson(json);

 final  List<Map<String, dynamic>> _relatedCases;
@override@JsonKey() List<Map<String, dynamic>> get relatedCases {
  if (_relatedCases is EqualUnmodifiableListView) return _relatedCases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedCases);
}

 final  List<Map<String, dynamic>> _aiDiagnoses;
@override@JsonKey() List<Map<String, dynamic>> get aiDiagnoses {
  if (_aiDiagnoses is EqualUnmodifiableListView) return _aiDiagnoses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aiDiagnoses);
}


/// Create a copy of CaseCreationOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaseCreationOptionsCopyWith<_CaseCreationOptions> get copyWith => __$CaseCreationOptionsCopyWithImpl<_CaseCreationOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaseCreationOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaseCreationOptions&&const DeepCollectionEquality().equals(other._relatedCases, _relatedCases)&&const DeepCollectionEquality().equals(other._aiDiagnoses, _aiDiagnoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_relatedCases),const DeepCollectionEquality().hash(_aiDiagnoses));

@override
String toString() {
  return 'CaseCreationOptions(relatedCases: $relatedCases, aiDiagnoses: $aiDiagnoses)';
}


}

/// @nodoc
abstract mixin class _$CaseCreationOptionsCopyWith<$Res> implements $CaseCreationOptionsCopyWith<$Res> {
  factory _$CaseCreationOptionsCopyWith(_CaseCreationOptions value, $Res Function(_CaseCreationOptions) _then) = __$CaseCreationOptionsCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> relatedCases, List<Map<String, dynamic>> aiDiagnoses
});




}
/// @nodoc
class __$CaseCreationOptionsCopyWithImpl<$Res>
    implements _$CaseCreationOptionsCopyWith<$Res> {
  __$CaseCreationOptionsCopyWithImpl(this._self, this._then);

  final _CaseCreationOptions _self;
  final $Res Function(_CaseCreationOptions) _then;

/// Create a copy of CaseCreationOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relatedCases = null,Object? aiDiagnoses = null,}) {
  return _then(_CaseCreationOptions(
relatedCases: null == relatedCases ? _self._relatedCases : relatedCases // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,aiDiagnoses: null == aiDiagnoses ? _self._aiDiagnoses : aiDiagnoses // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$CaseResponse {

 String get id; String get authorId;@JsonKey(unknownEnumValue: CaseResponseType.unknown) CaseResponseType get responseType; String get message; DateTime get createdAt; Map<String, dynamic>? get author;@JsonKey(fromJson: _responseAttachmentUrls) List<String> get attachments;
/// Create a copy of CaseResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaseResponseCopyWith<CaseResponse> get copyWith => _$CaseResponseCopyWithImpl<CaseResponse>(this as CaseResponse, _$identity);

  /// Serializes this CaseResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.author, author)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,responseType,message,createdAt,const DeepCollectionEquality().hash(author),const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'CaseResponse(id: $id, authorId: $authorId, responseType: $responseType, message: $message, createdAt: $createdAt, author: $author, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $CaseResponseCopyWith<$Res>  {
  factory $CaseResponseCopyWith(CaseResponse value, $Res Function(CaseResponse) _then) = _$CaseResponseCopyWithImpl;
@useResult
$Res call({
 String id, String authorId,@JsonKey(unknownEnumValue: CaseResponseType.unknown) CaseResponseType responseType, String message, DateTime createdAt, Map<String, dynamic>? author,@JsonKey(fromJson: _responseAttachmentUrls) List<String> attachments
});




}
/// @nodoc
class _$CaseResponseCopyWithImpl<$Res>
    implements $CaseResponseCopyWith<$Res> {
  _$CaseResponseCopyWithImpl(this._self, this._then);

  final CaseResponse _self;
  final $Res Function(CaseResponse) _then;

/// Create a copy of CaseResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? responseType = null,Object? message = null,Object? createdAt = null,Object? author = freezed,Object? attachments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as CaseResponseType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CaseResponse].
extension CaseResponsePatterns on CaseResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaseResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaseResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaseResponse value)  $default,){
final _that = this;
switch (_that) {
case _CaseResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaseResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CaseResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId, @JsonKey(unknownEnumValue: CaseResponseType.unknown)  CaseResponseType responseType,  String message,  DateTime createdAt,  Map<String, dynamic>? author, @JsonKey(fromJson: _responseAttachmentUrls)  List<String> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaseResponse() when $default != null:
return $default(_that.id,_that.authorId,_that.responseType,_that.message,_that.createdAt,_that.author,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId, @JsonKey(unknownEnumValue: CaseResponseType.unknown)  CaseResponseType responseType,  String message,  DateTime createdAt,  Map<String, dynamic>? author, @JsonKey(fromJson: _responseAttachmentUrls)  List<String> attachments)  $default,) {final _that = this;
switch (_that) {
case _CaseResponse():
return $default(_that.id,_that.authorId,_that.responseType,_that.message,_that.createdAt,_that.author,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId, @JsonKey(unknownEnumValue: CaseResponseType.unknown)  CaseResponseType responseType,  String message,  DateTime createdAt,  Map<String, dynamic>? author, @JsonKey(fromJson: _responseAttachmentUrls)  List<String> attachments)?  $default,) {final _that = this;
switch (_that) {
case _CaseResponse() when $default != null:
return $default(_that.id,_that.authorId,_that.responseType,_that.message,_that.createdAt,_that.author,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaseResponse implements CaseResponse {
  const _CaseResponse({required this.id, required this.authorId, @JsonKey(unknownEnumValue: CaseResponseType.unknown) required this.responseType, required this.message, required this.createdAt, final  Map<String, dynamic>? author, @JsonKey(fromJson: _responseAttachmentUrls) final  List<String> attachments = const []}): _author = author,_attachments = attachments;
  factory _CaseResponse.fromJson(Map<String, dynamic> json) => _$CaseResponseFromJson(json);

@override final  String id;
@override final  String authorId;
@override@JsonKey(unknownEnumValue: CaseResponseType.unknown) final  CaseResponseType responseType;
@override final  String message;
@override final  DateTime createdAt;
 final  Map<String, dynamic>? _author;
@override Map<String, dynamic>? get author {
  final value = _author;
  if (value == null) return null;
  if (_author is EqualUnmodifiableMapView) return _author;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String> _attachments;
@override@JsonKey(fromJson: _responseAttachmentUrls) List<String> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of CaseResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaseResponseCopyWith<_CaseResponse> get copyWith => __$CaseResponseCopyWithImpl<_CaseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._author, _author)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,responseType,message,createdAt,const DeepCollectionEquality().hash(_author),const DeepCollectionEquality().hash(_attachments));

@override
String toString() {
  return 'CaseResponse(id: $id, authorId: $authorId, responseType: $responseType, message: $message, createdAt: $createdAt, author: $author, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$CaseResponseCopyWith<$Res> implements $CaseResponseCopyWith<$Res> {
  factory _$CaseResponseCopyWith(_CaseResponse value, $Res Function(_CaseResponse) _then) = __$CaseResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId,@JsonKey(unknownEnumValue: CaseResponseType.unknown) CaseResponseType responseType, String message, DateTime createdAt, Map<String, dynamic>? author,@JsonKey(fromJson: _responseAttachmentUrls) List<String> attachments
});




}
/// @nodoc
class __$CaseResponseCopyWithImpl<$Res>
    implements _$CaseResponseCopyWith<$Res> {
  __$CaseResponseCopyWithImpl(this._self, this._then);

  final _CaseResponse _self;
  final $Res Function(_CaseResponse) _then;

/// Create a copy of CaseResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? responseType = null,Object? message = null,Object? createdAt = null,Object? author = freezed,Object? attachments = null,}) {
  return _then(_CaseResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as CaseResponseType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,author: freezed == author ? _self._author : author // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DiseaseCase {

 String get id; String get seasonId; String get title;@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus get status;@JsonKey(unknownEnumValue: CaseSeverity.unknown) CaseSeverity get severity; DateTime get createdAt; DateTime get updatedAt; String? get description; String? get resolutionSummary; DateTime? get resolvedAt; String? get reportedBy; String? get expertId; String? get relatedCaseId; Map<String, dynamic>? get expert; Map<String, dynamic>? get reporter;@JsonKey(name: '_count') Map<String, dynamic> get counts; bool get canRespond; Map<String, dynamic> get caseSnapshot; List<Map<String, dynamic>> get attachments; List<CaseResponse> get responses; List<Map<String, dynamic>> get statusHistory;
/// Create a copy of DiseaseCase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseCopyWith<DiseaseCase> get copyWith => _$DiseaseCaseCopyWithImpl<DiseaseCase>(this as DiseaseCase, _$identity);

  /// Serializes this DiseaseCase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCase&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.resolutionSummary, resolutionSummary) || other.resolutionSummary == resolutionSummary)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy)&&(identical(other.expertId, expertId) || other.expertId == expertId)&&(identical(other.relatedCaseId, relatedCaseId) || other.relatedCaseId == relatedCaseId)&&const DeepCollectionEquality().equals(other.expert, expert)&&const DeepCollectionEquality().equals(other.reporter, reporter)&&const DeepCollectionEquality().equals(other.counts, counts)&&(identical(other.canRespond, canRespond) || other.canRespond == canRespond)&&const DeepCollectionEquality().equals(other.caseSnapshot, caseSnapshot)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.responses, responses)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,seasonId,title,status,severity,createdAt,updatedAt,description,resolutionSummary,resolvedAt,reportedBy,expertId,relatedCaseId,const DeepCollectionEquality().hash(expert),const DeepCollectionEquality().hash(reporter),const DeepCollectionEquality().hash(counts),canRespond,const DeepCollectionEquality().hash(caseSnapshot),const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(responses),const DeepCollectionEquality().hash(statusHistory)]);

@override
String toString() {
  return 'DiseaseCase(id: $id, seasonId: $seasonId, title: $title, status: $status, severity: $severity, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, resolutionSummary: $resolutionSummary, resolvedAt: $resolvedAt, reportedBy: $reportedBy, expertId: $expertId, relatedCaseId: $relatedCaseId, expert: $expert, reporter: $reporter, counts: $counts, canRespond: $canRespond, caseSnapshot: $caseSnapshot, attachments: $attachments, responses: $responses, statusHistory: $statusHistory)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseCopyWith<$Res>  {
  factory $DiseaseCaseCopyWith(DiseaseCase value, $Res Function(DiseaseCase) _then) = _$DiseaseCaseCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, String title,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus status,@JsonKey(unknownEnumValue: CaseSeverity.unknown) CaseSeverity severity, DateTime createdAt, DateTime updatedAt, String? description, String? resolutionSummary, DateTime? resolvedAt, String? reportedBy, String? expertId, String? relatedCaseId, Map<String, dynamic>? expert, Map<String, dynamic>? reporter,@JsonKey(name: '_count') Map<String, dynamic> counts, bool canRespond, Map<String, dynamic> caseSnapshot, List<Map<String, dynamic>> attachments, List<CaseResponse> responses, List<Map<String, dynamic>> statusHistory
});




}
/// @nodoc
class _$DiseaseCaseCopyWithImpl<$Res>
    implements $DiseaseCaseCopyWith<$Res> {
  _$DiseaseCaseCopyWithImpl(this._self, this._then);

  final DiseaseCase _self;
  final $Res Function(DiseaseCase) _then;

/// Create a copy of DiseaseCase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? title = null,Object? status = null,Object? severity = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? resolutionSummary = freezed,Object? resolvedAt = freezed,Object? reportedBy = freezed,Object? expertId = freezed,Object? relatedCaseId = freezed,Object? expert = freezed,Object? reporter = freezed,Object? counts = null,Object? canRespond = null,Object? caseSnapshot = null,Object? attachments = null,Object? responses = null,Object? statusHistory = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as CaseSeverity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,resolutionSummary: freezed == resolutionSummary ? _self.resolutionSummary : resolutionSummary // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,expertId: freezed == expertId ? _self.expertId : expertId // ignore: cast_nullable_to_non_nullable
as String?,relatedCaseId: freezed == relatedCaseId ? _self.relatedCaseId : relatedCaseId // ignore: cast_nullable_to_non_nullable
as String?,expert: freezed == expert ? _self.expert : expert // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reporter: freezed == reporter ? _self.reporter : reporter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,canRespond: null == canRespond ? _self.canRespond : canRespond // ignore: cast_nullable_to_non_nullable
as bool,caseSnapshot: null == caseSnapshot ? _self.caseSnapshot : caseSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,responses: null == responses ? _self.responses : responses // ignore: cast_nullable_to_non_nullable
as List<CaseResponse>,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCase].
extension DiseaseCasePatterns on DiseaseCase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCase value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCase value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  String title, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: CaseSeverity.unknown)  CaseSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? resolutionSummary,  DateTime? resolvedAt,  String? reportedBy,  String? expertId,  String? relatedCaseId,  Map<String, dynamic>? expert,  Map<String, dynamic>? reporter, @JsonKey(name: '_count')  Map<String, dynamic> counts,  bool canRespond,  Map<String, dynamic> caseSnapshot,  List<Map<String, dynamic>> attachments,  List<CaseResponse> responses,  List<Map<String, dynamic>> statusHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCase() when $default != null:
return $default(_that.id,_that.seasonId,_that.title,_that.status,_that.severity,_that.createdAt,_that.updatedAt,_that.description,_that.resolutionSummary,_that.resolvedAt,_that.reportedBy,_that.expertId,_that.relatedCaseId,_that.expert,_that.reporter,_that.counts,_that.canRespond,_that.caseSnapshot,_that.attachments,_that.responses,_that.statusHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  String title, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: CaseSeverity.unknown)  CaseSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? resolutionSummary,  DateTime? resolvedAt,  String? reportedBy,  String? expertId,  String? relatedCaseId,  Map<String, dynamic>? expert,  Map<String, dynamic>? reporter, @JsonKey(name: '_count')  Map<String, dynamic> counts,  bool canRespond,  Map<String, dynamic> caseSnapshot,  List<Map<String, dynamic>> attachments,  List<CaseResponse> responses,  List<Map<String, dynamic>> statusHistory)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCase():
return $default(_that.id,_that.seasonId,_that.title,_that.status,_that.severity,_that.createdAt,_that.updatedAt,_that.description,_that.resolutionSummary,_that.resolvedAt,_that.reportedBy,_that.expertId,_that.relatedCaseId,_that.expert,_that.reporter,_that.counts,_that.canRespond,_that.caseSnapshot,_that.attachments,_that.responses,_that.statusHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  String title, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: CaseSeverity.unknown)  CaseSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? resolutionSummary,  DateTime? resolvedAt,  String? reportedBy,  String? expertId,  String? relatedCaseId,  Map<String, dynamic>? expert,  Map<String, dynamic>? reporter, @JsonKey(name: '_count')  Map<String, dynamic> counts,  bool canRespond,  Map<String, dynamic> caseSnapshot,  List<Map<String, dynamic>> attachments,  List<CaseResponse> responses,  List<Map<String, dynamic>> statusHistory)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCase() when $default != null:
return $default(_that.id,_that.seasonId,_that.title,_that.status,_that.severity,_that.createdAt,_that.updatedAt,_that.description,_that.resolutionSummary,_that.resolvedAt,_that.reportedBy,_that.expertId,_that.relatedCaseId,_that.expert,_that.reporter,_that.counts,_that.canRespond,_that.caseSnapshot,_that.attachments,_that.responses,_that.statusHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiseaseCase extends DiseaseCase {
  const _DiseaseCase({required this.id, required this.seasonId, required this.title, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) required this.status, @JsonKey(unknownEnumValue: CaseSeverity.unknown) required this.severity, required this.createdAt, required this.updatedAt, this.description, this.resolutionSummary, this.resolvedAt, this.reportedBy, this.expertId, this.relatedCaseId, final  Map<String, dynamic>? expert, final  Map<String, dynamic>? reporter, @JsonKey(name: '_count') final  Map<String, dynamic> counts = const {}, this.canRespond = false, final  Map<String, dynamic> caseSnapshot = const {}, final  List<Map<String, dynamic>> attachments = const [], final  List<CaseResponse> responses = const [], final  List<Map<String, dynamic>> statusHistory = const []}): _expert = expert,_reporter = reporter,_counts = counts,_caseSnapshot = caseSnapshot,_attachments = attachments,_responses = responses,_statusHistory = statusHistory,super._();
  factory _DiseaseCase.fromJson(Map<String, dynamic> json) => _$DiseaseCaseFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  String title;
@override@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) final  DiseaseCaseStatus status;
@override@JsonKey(unknownEnumValue: CaseSeverity.unknown) final  CaseSeverity severity;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override final  String? resolutionSummary;
@override final  DateTime? resolvedAt;
@override final  String? reportedBy;
@override final  String? expertId;
@override final  String? relatedCaseId;
 final  Map<String, dynamic>? _expert;
@override Map<String, dynamic>? get expert {
  final value = _expert;
  if (value == null) return null;
  if (_expert is EqualUnmodifiableMapView) return _expert;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _reporter;
@override Map<String, dynamic>? get reporter {
  final value = _reporter;
  if (value == null) return null;
  if (_reporter is EqualUnmodifiableMapView) return _reporter;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic> _counts;
@override@JsonKey(name: '_count') Map<String, dynamic> get counts {
  if (_counts is EqualUnmodifiableMapView) return _counts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_counts);
}

@override@JsonKey() final  bool canRespond;
 final  Map<String, dynamic> _caseSnapshot;
@override@JsonKey() Map<String, dynamic> get caseSnapshot {
  if (_caseSnapshot is EqualUnmodifiableMapView) return _caseSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_caseSnapshot);
}

 final  List<Map<String, dynamic>> _attachments;
@override@JsonKey() List<Map<String, dynamic>> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

 final  List<CaseResponse> _responses;
@override@JsonKey() List<CaseResponse> get responses {
  if (_responses is EqualUnmodifiableListView) return _responses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_responses);
}

 final  List<Map<String, dynamic>> _statusHistory;
@override@JsonKey() List<Map<String, dynamic>> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}


/// Create a copy of DiseaseCase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseCopyWith<_DiseaseCase> get copyWith => __$DiseaseCaseCopyWithImpl<_DiseaseCase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCase&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.resolutionSummary, resolutionSummary) || other.resolutionSummary == resolutionSummary)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy)&&(identical(other.expertId, expertId) || other.expertId == expertId)&&(identical(other.relatedCaseId, relatedCaseId) || other.relatedCaseId == relatedCaseId)&&const DeepCollectionEquality().equals(other._expert, _expert)&&const DeepCollectionEquality().equals(other._reporter, _reporter)&&const DeepCollectionEquality().equals(other._counts, _counts)&&(identical(other.canRespond, canRespond) || other.canRespond == canRespond)&&const DeepCollectionEquality().equals(other._caseSnapshot, _caseSnapshot)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._responses, _responses)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,seasonId,title,status,severity,createdAt,updatedAt,description,resolutionSummary,resolvedAt,reportedBy,expertId,relatedCaseId,const DeepCollectionEquality().hash(_expert),const DeepCollectionEquality().hash(_reporter),const DeepCollectionEquality().hash(_counts),canRespond,const DeepCollectionEquality().hash(_caseSnapshot),const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_responses),const DeepCollectionEquality().hash(_statusHistory)]);

@override
String toString() {
  return 'DiseaseCase(id: $id, seasonId: $seasonId, title: $title, status: $status, severity: $severity, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, resolutionSummary: $resolutionSummary, resolvedAt: $resolvedAt, reportedBy: $reportedBy, expertId: $expertId, relatedCaseId: $relatedCaseId, expert: $expert, reporter: $reporter, counts: $counts, canRespond: $canRespond, caseSnapshot: $caseSnapshot, attachments: $attachments, responses: $responses, statusHistory: $statusHistory)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseCopyWith<$Res> implements $DiseaseCaseCopyWith<$Res> {
  factory _$DiseaseCaseCopyWith(_DiseaseCase value, $Res Function(_DiseaseCase) _then) = __$DiseaseCaseCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, String title,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus status,@JsonKey(unknownEnumValue: CaseSeverity.unknown) CaseSeverity severity, DateTime createdAt, DateTime updatedAt, String? description, String? resolutionSummary, DateTime? resolvedAt, String? reportedBy, String? expertId, String? relatedCaseId, Map<String, dynamic>? expert, Map<String, dynamic>? reporter,@JsonKey(name: '_count') Map<String, dynamic> counts, bool canRespond, Map<String, dynamic> caseSnapshot, List<Map<String, dynamic>> attachments, List<CaseResponse> responses, List<Map<String, dynamic>> statusHistory
});




}
/// @nodoc
class __$DiseaseCaseCopyWithImpl<$Res>
    implements _$DiseaseCaseCopyWith<$Res> {
  __$DiseaseCaseCopyWithImpl(this._self, this._then);

  final _DiseaseCase _self;
  final $Res Function(_DiseaseCase) _then;

/// Create a copy of DiseaseCase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? title = null,Object? status = null,Object? severity = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? resolutionSummary = freezed,Object? resolvedAt = freezed,Object? reportedBy = freezed,Object? expertId = freezed,Object? relatedCaseId = freezed,Object? expert = freezed,Object? reporter = freezed,Object? counts = null,Object? canRespond = null,Object? caseSnapshot = null,Object? attachments = null,Object? responses = null,Object? statusHistory = null,}) {
  return _then(_DiseaseCase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as CaseSeverity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,resolutionSummary: freezed == resolutionSummary ? _self.resolutionSummary : resolutionSummary // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,expertId: freezed == expertId ? _self.expertId : expertId // ignore: cast_nullable_to_non_nullable
as String?,relatedCaseId: freezed == relatedCaseId ? _self.relatedCaseId : relatedCaseId // ignore: cast_nullable_to_non_nullable
as String?,expert: freezed == expert ? _self._expert : expert // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reporter: freezed == reporter ? _self._reporter : reporter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,counts: null == counts ? _self._counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,canRespond: null == canRespond ? _self.canRespond : canRespond // ignore: cast_nullable_to_non_nullable
as bool,caseSnapshot: null == caseSnapshot ? _self._caseSnapshot : caseSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,responses: null == responses ? _self._responses : responses // ignore: cast_nullable_to_non_nullable
as List<CaseResponse>,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$DiseaseCasePage {

 List<DiseaseCase> get items; int get page; int get totalResults; bool get hasNextPage; bool get canCreate; String? get existingCaseId; int get ongoingCount; int get resolvedCount; Map<String, dynamic> get season;
/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCasePageCopyWith<DiseaseCasePage> get copyWith => _$DiseaseCasePageCopyWithImpl<DiseaseCasePage>(this as DiseaseCasePage, _$identity);

  /// Serializes this DiseaseCasePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCasePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.existingCaseId, existingCaseId) || other.existingCaseId == existingCaseId)&&(identical(other.ongoingCount, ongoingCount) || other.ongoingCount == ongoingCount)&&(identical(other.resolvedCount, resolvedCount) || other.resolvedCount == resolvedCount)&&const DeepCollectionEquality().equals(other.season, season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,totalResults,hasNextPage,canCreate,existingCaseId,ongoingCount,resolvedCount,const DeepCollectionEquality().hash(season));

@override
String toString() {
  return 'DiseaseCasePage(items: $items, page: $page, totalResults: $totalResults, hasNextPage: $hasNextPage, canCreate: $canCreate, existingCaseId: $existingCaseId, ongoingCount: $ongoingCount, resolvedCount: $resolvedCount, season: $season)';
}


}

/// @nodoc
abstract mixin class $DiseaseCasePageCopyWith<$Res>  {
  factory $DiseaseCasePageCopyWith(DiseaseCasePage value, $Res Function(DiseaseCasePage) _then) = _$DiseaseCasePageCopyWithImpl;
@useResult
$Res call({
 List<DiseaseCase> items, int page, int totalResults, bool hasNextPage, bool canCreate, String? existingCaseId, int ongoingCount, int resolvedCount, Map<String, dynamic> season
});




}
/// @nodoc
class _$DiseaseCasePageCopyWithImpl<$Res>
    implements $DiseaseCasePageCopyWith<$Res> {
  _$DiseaseCasePageCopyWithImpl(this._self, this._then);

  final DiseaseCasePage _self;
  final $Res Function(DiseaseCasePage) _then;

/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? totalResults = null,Object? hasNextPage = null,Object? canCreate = null,Object? existingCaseId = freezed,Object? ongoingCount = null,Object? resolvedCount = null,Object? season = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DiseaseCase>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,existingCaseId: freezed == existingCaseId ? _self.existingCaseId : existingCaseId // ignore: cast_nullable_to_non_nullable
as String?,ongoingCount: null == ongoingCount ? _self.ongoingCount : ongoingCount // ignore: cast_nullable_to_non_nullable
as int,resolvedCount: null == resolvedCount ? _self.resolvedCount : resolvedCount // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCasePage].
extension DiseaseCasePagePatterns on DiseaseCasePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCasePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCasePage value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCasePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCasePage value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiseaseCase> items,  int page,  int totalResults,  bool hasNextPage,  bool canCreate,  String? existingCaseId,  int ongoingCount,  int resolvedCount,  Map<String, dynamic> season)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
return $default(_that.items,_that.page,_that.totalResults,_that.hasNextPage,_that.canCreate,_that.existingCaseId,_that.ongoingCount,_that.resolvedCount,_that.season);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiseaseCase> items,  int page,  int totalResults,  bool hasNextPage,  bool canCreate,  String? existingCaseId,  int ongoingCount,  int resolvedCount,  Map<String, dynamic> season)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCasePage():
return $default(_that.items,_that.page,_that.totalResults,_that.hasNextPage,_that.canCreate,_that.existingCaseId,_that.ongoingCount,_that.resolvedCount,_that.season);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiseaseCase> items,  int page,  int totalResults,  bool hasNextPage,  bool canCreate,  String? existingCaseId,  int ongoingCount,  int resolvedCount,  Map<String, dynamic> season)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
return $default(_that.items,_that.page,_that.totalResults,_that.hasNextPage,_that.canCreate,_that.existingCaseId,_that.ongoingCount,_that.resolvedCount,_that.season);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiseaseCasePage implements DiseaseCasePage {
  const _DiseaseCasePage({required final  List<DiseaseCase> items, required this.page, required this.totalResults, required this.hasNextPage, required this.canCreate, this.existingCaseId, this.ongoingCount = 0, this.resolvedCount = 0, final  Map<String, dynamic> season = const {}}): _items = items,_season = season;
  factory _DiseaseCasePage.fromJson(Map<String, dynamic> json) => _$DiseaseCasePageFromJson(json);

 final  List<DiseaseCase> _items;
@override List<DiseaseCase> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int totalResults;
@override final  bool hasNextPage;
@override final  bool canCreate;
@override final  String? existingCaseId;
@override@JsonKey() final  int ongoingCount;
@override@JsonKey() final  int resolvedCount;
 final  Map<String, dynamic> _season;
@override@JsonKey() Map<String, dynamic> get season {
  if (_season is EqualUnmodifiableMapView) return _season;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_season);
}


/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCasePageCopyWith<_DiseaseCasePage> get copyWith => __$DiseaseCasePageCopyWithImpl<_DiseaseCasePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCasePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCasePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.existingCaseId, existingCaseId) || other.existingCaseId == existingCaseId)&&(identical(other.ongoingCount, ongoingCount) || other.ongoingCount == ongoingCount)&&(identical(other.resolvedCount, resolvedCount) || other.resolvedCount == resolvedCount)&&const DeepCollectionEquality().equals(other._season, _season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,totalResults,hasNextPage,canCreate,existingCaseId,ongoingCount,resolvedCount,const DeepCollectionEquality().hash(_season));

@override
String toString() {
  return 'DiseaseCasePage(items: $items, page: $page, totalResults: $totalResults, hasNextPage: $hasNextPage, canCreate: $canCreate, existingCaseId: $existingCaseId, ongoingCount: $ongoingCount, resolvedCount: $resolvedCount, season: $season)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCasePageCopyWith<$Res> implements $DiseaseCasePageCopyWith<$Res> {
  factory _$DiseaseCasePageCopyWith(_DiseaseCasePage value, $Res Function(_DiseaseCasePage) _then) = __$DiseaseCasePageCopyWithImpl;
@override @useResult
$Res call({
 List<DiseaseCase> items, int page, int totalResults, bool hasNextPage, bool canCreate, String? existingCaseId, int ongoingCount, int resolvedCount, Map<String, dynamic> season
});




}
/// @nodoc
class __$DiseaseCasePageCopyWithImpl<$Res>
    implements _$DiseaseCasePageCopyWith<$Res> {
  __$DiseaseCasePageCopyWithImpl(this._self, this._then);

  final _DiseaseCasePage _self;
  final $Res Function(_DiseaseCasePage) _then;

/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? totalResults = null,Object? hasNextPage = null,Object? canCreate = null,Object? existingCaseId = freezed,Object? ongoingCount = null,Object? resolvedCount = null,Object? season = null,}) {
  return _then(_DiseaseCasePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DiseaseCase>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,existingCaseId: freezed == existingCaseId ? _self.existingCaseId : existingCaseId // ignore: cast_nullable_to_non_nullable
as String?,ongoingCount: null == ongoingCount ? _self.ongoingCount : ongoingCount // ignore: cast_nullable_to_non_nullable
as int,resolvedCount: null == resolvedCount ? _self.resolvedCount : resolvedCount // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self._season : season // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
