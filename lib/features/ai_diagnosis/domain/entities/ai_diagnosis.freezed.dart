// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_diagnosis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiDiagnosisSummary {

 String get id; DateTime get createdAt;@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus get runStatus; int get imageCount;@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? get recognitionStatus;@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? get predictedLabel; double? get confidence;
/// Create a copy of AiDiagnosisSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisSummaryCopyWith<AiDiagnosisSummary> get copyWith => _$AiDiagnosisSummaryCopyWithImpl<AiDiagnosisSummary>(this as AiDiagnosisSummary, _$identity);

  /// Serializes this AiDiagnosisSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runStatus, runStatus) || other.runStatus == runStatus)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.recognitionStatus, recognitionStatus) || other.recognitionStatus == recognitionStatus)&&(identical(other.predictedLabel, predictedLabel) || other.predictedLabel == predictedLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,runStatus,imageCount,recognitionStatus,predictedLabel,confidence);

@override
String toString() {
  return 'AiDiagnosisSummary(id: $id, createdAt: $createdAt, runStatus: $runStatus, imageCount: $imageCount, recognitionStatus: $recognitionStatus, predictedLabel: $predictedLabel, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisSummaryCopyWith<$Res>  {
  factory $AiDiagnosisSummaryCopyWith(AiDiagnosisSummary value, $Res Function(AiDiagnosisSummary) _then) = _$AiDiagnosisSummaryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt,@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus runStatus, int imageCount,@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? recognitionStatus,@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? predictedLabel, double? confidence
});




}
/// @nodoc
class _$AiDiagnosisSummaryCopyWithImpl<$Res>
    implements $AiDiagnosisSummaryCopyWith<$Res> {
  _$AiDiagnosisSummaryCopyWithImpl(this._self, this._then);

  final AiDiagnosisSummary _self;
  final $Res Function(AiDiagnosisSummary) _then;

/// Create a copy of AiDiagnosisSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? runStatus = null,Object? imageCount = null,Object? recognitionStatus = freezed,Object? predictedLabel = freezed,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,runStatus: null == runStatus ? _self.runStatus : runStatus // ignore: cast_nullable_to_non_nullable
as AiRunStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,recognitionStatus: freezed == recognitionStatus ? _self.recognitionStatus : recognitionStatus // ignore: cast_nullable_to_non_nullable
as AiRecognitionStatus?,predictedLabel: freezed == predictedLabel ? _self.predictedLabel : predictedLabel // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDiagnosisSummary].
extension AiDiagnosisSummaryPatterns on AiDiagnosisSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisSummary value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  int imageCount, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisSummary() when $default != null:
return $default(_that.id,_that.createdAt,_that.runStatus,_that.imageCount,_that.recognitionStatus,_that.predictedLabel,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  int imageCount, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisSummary():
return $default(_that.id,_that.createdAt,_that.runStatus,_that.imageCount,_that.recognitionStatus,_that.predictedLabel,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  int imageCount, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisSummary() when $default != null:
return $default(_that.id,_that.createdAt,_that.runStatus,_that.imageCount,_that.recognitionStatus,_that.predictedLabel,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDiagnosisSummary extends AiDiagnosisSummary {
  const _AiDiagnosisSummary({required this.id, required this.createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown) required this.runStatus, required this.imageCount, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) this.recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) this.predictedLabel, this.confidence}): super._();
  factory _AiDiagnosisSummary.fromJson(Map<String, dynamic> json) => _$AiDiagnosisSummaryFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override@JsonKey(unknownEnumValue: AiRunStatus.unknown) final  AiRunStatus runStatus;
@override final  int imageCount;
@override@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) final  AiRecognitionStatus? recognitionStatus;
@override@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) final  AiDiseaseLabel? predictedLabel;
@override final  double? confidence;

/// Create a copy of AiDiagnosisSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisSummaryCopyWith<_AiDiagnosisSummary> get copyWith => __$AiDiagnosisSummaryCopyWithImpl<_AiDiagnosisSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDiagnosisSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runStatus, runStatus) || other.runStatus == runStatus)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.recognitionStatus, recognitionStatus) || other.recognitionStatus == recognitionStatus)&&(identical(other.predictedLabel, predictedLabel) || other.predictedLabel == predictedLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,runStatus,imageCount,recognitionStatus,predictedLabel,confidence);

@override
String toString() {
  return 'AiDiagnosisSummary(id: $id, createdAt: $createdAt, runStatus: $runStatus, imageCount: $imageCount, recognitionStatus: $recognitionStatus, predictedLabel: $predictedLabel, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisSummaryCopyWith<$Res> implements $AiDiagnosisSummaryCopyWith<$Res> {
  factory _$AiDiagnosisSummaryCopyWith(_AiDiagnosisSummary value, $Res Function(_AiDiagnosisSummary) _then) = __$AiDiagnosisSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt,@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus runStatus, int imageCount,@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? recognitionStatus,@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? predictedLabel, double? confidence
});




}
/// @nodoc
class __$AiDiagnosisSummaryCopyWithImpl<$Res>
    implements _$AiDiagnosisSummaryCopyWith<$Res> {
  __$AiDiagnosisSummaryCopyWithImpl(this._self, this._then);

  final _AiDiagnosisSummary _self;
  final $Res Function(_AiDiagnosisSummary) _then;

/// Create a copy of AiDiagnosisSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? runStatus = null,Object? imageCount = null,Object? recognitionStatus = freezed,Object? predictedLabel = freezed,Object? confidence = freezed,}) {
  return _then(_AiDiagnosisSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,runStatus: null == runStatus ? _self.runStatus : runStatus // ignore: cast_nullable_to_non_nullable
as AiRunStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,recognitionStatus: freezed == recognitionStatus ? _self.recognitionStatus : recognitionStatus // ignore: cast_nullable_to_non_nullable
as AiRecognitionStatus?,predictedLabel: freezed == predictedLabel ? _self.predictedLabel : predictedLabel // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AiPrediction {

@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel get label; double get probability;
/// Create a copy of AiPrediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiPredictionCopyWith<AiPrediction> get copyWith => _$AiPredictionCopyWithImpl<AiPrediction>(this as AiPrediction, _$identity);

  /// Serializes this AiPrediction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiPrediction&&(identical(other.label, label) || other.label == label)&&(identical(other.probability, probability) || other.probability == probability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,probability);

@override
String toString() {
  return 'AiPrediction(label: $label, probability: $probability)';
}


}

/// @nodoc
abstract mixin class $AiPredictionCopyWith<$Res>  {
  factory $AiPredictionCopyWith(AiPrediction value, $Res Function(AiPrediction) _then) = _$AiPredictionCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel label, double probability
});




}
/// @nodoc
class _$AiPredictionCopyWithImpl<$Res>
    implements $AiPredictionCopyWith<$Res> {
  _$AiPredictionCopyWithImpl(this._self, this._then);

  final AiPrediction _self;
  final $Res Function(AiPrediction) _then;

/// Create a copy of AiPrediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? probability = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiPrediction].
extension AiPredictionPatterns on AiPrediction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiPrediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiPrediction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiPrediction value)  $default,){
final _that = this;
switch (_that) {
case _AiPrediction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiPrediction value)?  $default,){
final _that = this;
switch (_that) {
case _AiPrediction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel label,  double probability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiPrediction() when $default != null:
return $default(_that.label,_that.probability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel label,  double probability)  $default,) {final _that = this;
switch (_that) {
case _AiPrediction():
return $default(_that.label,_that.probability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel label,  double probability)?  $default,) {final _that = this;
switch (_that) {
case _AiPrediction() when $default != null:
return $default(_that.label,_that.probability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiPrediction implements AiPrediction {
  const _AiPrediction({@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) required this.label, required this.probability});
  factory _AiPrediction.fromJson(Map<String, dynamic> json) => _$AiPredictionFromJson(json);

@override@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) final  AiDiseaseLabel label;
@override final  double probability;

/// Create a copy of AiPrediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiPredictionCopyWith<_AiPrediction> get copyWith => __$AiPredictionCopyWithImpl<_AiPrediction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiPredictionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiPrediction&&(identical(other.label, label) || other.label == label)&&(identical(other.probability, probability) || other.probability == probability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,probability);

@override
String toString() {
  return 'AiPrediction(label: $label, probability: $probability)';
}


}

/// @nodoc
abstract mixin class _$AiPredictionCopyWith<$Res> implements $AiPredictionCopyWith<$Res> {
  factory _$AiPredictionCopyWith(_AiPrediction value, $Res Function(_AiPrediction) _then) = __$AiPredictionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel label, double probability
});




}
/// @nodoc
class __$AiPredictionCopyWithImpl<$Res>
    implements _$AiPredictionCopyWith<$Res> {
  __$AiPredictionCopyWithImpl(this._self, this._then);

  final _AiPrediction _self;
  final $Res Function(_AiPrediction) _then;

/// Create a copy of AiPrediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? probability = null,}) {
  return _then(_AiPrediction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel,probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AiDiagnosisError {

 String get message; String? get code;
/// Create a copy of AiDiagnosisError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisErrorCopyWith<AiDiagnosisError> get copyWith => _$AiDiagnosisErrorCopyWithImpl<AiDiagnosisError>(this as AiDiagnosisError, _$identity);

  /// Serializes this AiDiagnosisError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AiDiagnosisError(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisErrorCopyWith<$Res>  {
  factory $AiDiagnosisErrorCopyWith(AiDiagnosisError value, $Res Function(AiDiagnosisError) _then) = _$AiDiagnosisErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$AiDiagnosisErrorCopyWithImpl<$Res>
    implements $AiDiagnosisErrorCopyWith<$Res> {
  _$AiDiagnosisErrorCopyWithImpl(this._self, this._then);

  final AiDiagnosisError _self;
  final $Res Function(AiDiagnosisError) _then;

/// Create a copy of AiDiagnosisError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDiagnosisError].
extension AiDiagnosisErrorPatterns on AiDiagnosisError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisError value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisError value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisError() when $default != null:
return $default(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  String? code)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisError():
return $default(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisError() when $default != null:
return $default(_that.message,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDiagnosisError implements AiDiagnosisError {
  const _AiDiagnosisError({required this.message, this.code});
  factory _AiDiagnosisError.fromJson(Map<String, dynamic> json) => _$AiDiagnosisErrorFromJson(json);

@override final  String message;
@override final  String? code;

/// Create a copy of AiDiagnosisError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisErrorCopyWith<_AiDiagnosisError> get copyWith => __$AiDiagnosisErrorCopyWithImpl<_AiDiagnosisError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDiagnosisErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AiDiagnosisError(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisErrorCopyWith<$Res> implements $AiDiagnosisErrorCopyWith<$Res> {
  factory _$AiDiagnosisErrorCopyWith(_AiDiagnosisError value, $Res Function(_AiDiagnosisError) _then) = __$AiDiagnosisErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class __$AiDiagnosisErrorCopyWithImpl<$Res>
    implements _$AiDiagnosisErrorCopyWith<$Res> {
  __$AiDiagnosisErrorCopyWithImpl(this._self, this._then);

  final _AiDiagnosisError _self;
  final $Res Function(_AiDiagnosisError) _then;

/// Create a copy of AiDiagnosisError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(_AiDiagnosisError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiDiagnosisDetail {

 String get id; String get seasonId; DateTime get createdAt;@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus get runStatus; List<String> get imageUrls; DateTime? get imageUrlsExpireAt; String? get modelVersion; int? get processingTimeMs;@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? get recognitionStatus;@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? get predictedLabel; double? get confidence; List<AiPrediction> get predictions; String? get recommendation; AiDiagnosisError? get error;
/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisDetailCopyWith<AiDiagnosisDetail> get copyWith => _$AiDiagnosisDetailCopyWithImpl<AiDiagnosisDetail>(this as AiDiagnosisDetail, _$identity);

  /// Serializes this AiDiagnosisDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runStatus, runStatus) || other.runStatus == runStatus)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.imageUrlsExpireAt, imageUrlsExpireAt) || other.imageUrlsExpireAt == imageUrlsExpireAt)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.recognitionStatus, recognitionStatus) || other.recognitionStatus == recognitionStatus)&&(identical(other.predictedLabel, predictedLabel) || other.predictedLabel == predictedLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.predictions, predictions)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,createdAt,runStatus,const DeepCollectionEquality().hash(imageUrls),imageUrlsExpireAt,modelVersion,processingTimeMs,recognitionStatus,predictedLabel,confidence,const DeepCollectionEquality().hash(predictions),recommendation,error);

@override
String toString() {
  return 'AiDiagnosisDetail(id: $id, seasonId: $seasonId, createdAt: $createdAt, runStatus: $runStatus, imageUrls: $imageUrls, imageUrlsExpireAt: $imageUrlsExpireAt, modelVersion: $modelVersion, processingTimeMs: $processingTimeMs, recognitionStatus: $recognitionStatus, predictedLabel: $predictedLabel, confidence: $confidence, predictions: $predictions, recommendation: $recommendation, error: $error)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisDetailCopyWith<$Res>  {
  factory $AiDiagnosisDetailCopyWith(AiDiagnosisDetail value, $Res Function(AiDiagnosisDetail) _then) = _$AiDiagnosisDetailCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId, DateTime createdAt,@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus runStatus, List<String> imageUrls, DateTime? imageUrlsExpireAt, String? modelVersion, int? processingTimeMs,@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? recognitionStatus,@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? predictedLabel, double? confidence, List<AiPrediction> predictions, String? recommendation, AiDiagnosisError? error
});


$AiDiagnosisErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$AiDiagnosisDetailCopyWithImpl<$Res>
    implements $AiDiagnosisDetailCopyWith<$Res> {
  _$AiDiagnosisDetailCopyWithImpl(this._self, this._then);

  final AiDiagnosisDetail _self;
  final $Res Function(AiDiagnosisDetail) _then;

/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? createdAt = null,Object? runStatus = null,Object? imageUrls = null,Object? imageUrlsExpireAt = freezed,Object? modelVersion = freezed,Object? processingTimeMs = freezed,Object? recognitionStatus = freezed,Object? predictedLabel = freezed,Object? confidence = freezed,Object? predictions = null,Object? recommendation = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,runStatus: null == runStatus ? _self.runStatus : runStatus // ignore: cast_nullable_to_non_nullable
as AiRunStatus,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrlsExpireAt: freezed == imageUrlsExpireAt ? _self.imageUrlsExpireAt : imageUrlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,processingTimeMs: freezed == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int?,recognitionStatus: freezed == recognitionStatus ? _self.recognitionStatus : recognitionStatus // ignore: cast_nullable_to_non_nullable
as AiRecognitionStatus?,predictedLabel: freezed == predictedLabel ? _self.predictedLabel : predictedLabel // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,predictions: null == predictions ? _self.predictions : predictions // ignore: cast_nullable_to_non_nullable
as List<AiPrediction>,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AiDiagnosisError?,
  ));
}
/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $AiDiagnosisErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDiagnosisDetail].
extension AiDiagnosisDetailPatterns on AiDiagnosisDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisDetail value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisDetail value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  List<String> imageUrls,  DateTime? imageUrlsExpireAt,  String? modelVersion,  int? processingTimeMs, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence,  List<AiPrediction> predictions,  String? recommendation,  AiDiagnosisError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisDetail() when $default != null:
return $default(_that.id,_that.seasonId,_that.createdAt,_that.runStatus,_that.imageUrls,_that.imageUrlsExpireAt,_that.modelVersion,_that.processingTimeMs,_that.recognitionStatus,_that.predictedLabel,_that.confidence,_that.predictions,_that.recommendation,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  List<String> imageUrls,  DateTime? imageUrlsExpireAt,  String? modelVersion,  int? processingTimeMs, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence,  List<AiPrediction> predictions,  String? recommendation,  AiDiagnosisError? error)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisDetail():
return $default(_that.id,_that.seasonId,_that.createdAt,_that.runStatus,_that.imageUrls,_that.imageUrlsExpireAt,_that.modelVersion,_that.processingTimeMs,_that.recognitionStatus,_that.predictedLabel,_that.confidence,_that.predictions,_that.recommendation,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId,  DateTime createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown)  AiRunStatus runStatus,  List<String> imageUrls,  DateTime? imageUrlsExpireAt,  String? modelVersion,  int? processingTimeMs, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown)  AiRecognitionStatus? recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown)  AiDiseaseLabel? predictedLabel,  double? confidence,  List<AiPrediction> predictions,  String? recommendation,  AiDiagnosisError? error)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisDetail() when $default != null:
return $default(_that.id,_that.seasonId,_that.createdAt,_that.runStatus,_that.imageUrls,_that.imageUrlsExpireAt,_that.modelVersion,_that.processingTimeMs,_that.recognitionStatus,_that.predictedLabel,_that.confidence,_that.predictions,_that.recommendation,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDiagnosisDetail extends AiDiagnosisDetail {
  const _AiDiagnosisDetail({required this.id, required this.seasonId, required this.createdAt, @JsonKey(unknownEnumValue: AiRunStatus.unknown) required this.runStatus, required final  List<String> imageUrls, this.imageUrlsExpireAt, this.modelVersion, this.processingTimeMs, @JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) this.recognitionStatus, @JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) this.predictedLabel, this.confidence, final  List<AiPrediction> predictions = const [], this.recommendation, this.error}): _imageUrls = imageUrls,_predictions = predictions,super._();
  factory _AiDiagnosisDetail.fromJson(Map<String, dynamic> json) => _$AiDiagnosisDetailFromJson(json);

@override final  String id;
@override final  String seasonId;
@override final  DateTime createdAt;
@override@JsonKey(unknownEnumValue: AiRunStatus.unknown) final  AiRunStatus runStatus;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  DateTime? imageUrlsExpireAt;
@override final  String? modelVersion;
@override final  int? processingTimeMs;
@override@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) final  AiRecognitionStatus? recognitionStatus;
@override@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) final  AiDiseaseLabel? predictedLabel;
@override final  double? confidence;
 final  List<AiPrediction> _predictions;
@override@JsonKey() List<AiPrediction> get predictions {
  if (_predictions is EqualUnmodifiableListView) return _predictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_predictions);
}

@override final  String? recommendation;
@override final  AiDiagnosisError? error;

/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisDetailCopyWith<_AiDiagnosisDetail> get copyWith => __$AiDiagnosisDetailCopyWithImpl<_AiDiagnosisDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDiagnosisDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.runStatus, runStatus) || other.runStatus == runStatus)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.imageUrlsExpireAt, imageUrlsExpireAt) || other.imageUrlsExpireAt == imageUrlsExpireAt)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.recognitionStatus, recognitionStatus) || other.recognitionStatus == recognitionStatus)&&(identical(other.predictedLabel, predictedLabel) || other.predictedLabel == predictedLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._predictions, _predictions)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,createdAt,runStatus,const DeepCollectionEquality().hash(_imageUrls),imageUrlsExpireAt,modelVersion,processingTimeMs,recognitionStatus,predictedLabel,confidence,const DeepCollectionEquality().hash(_predictions),recommendation,error);

@override
String toString() {
  return 'AiDiagnosisDetail(id: $id, seasonId: $seasonId, createdAt: $createdAt, runStatus: $runStatus, imageUrls: $imageUrls, imageUrlsExpireAt: $imageUrlsExpireAt, modelVersion: $modelVersion, processingTimeMs: $processingTimeMs, recognitionStatus: $recognitionStatus, predictedLabel: $predictedLabel, confidence: $confidence, predictions: $predictions, recommendation: $recommendation, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisDetailCopyWith<$Res> implements $AiDiagnosisDetailCopyWith<$Res> {
  factory _$AiDiagnosisDetailCopyWith(_AiDiagnosisDetail value, $Res Function(_AiDiagnosisDetail) _then) = __$AiDiagnosisDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId, DateTime createdAt,@JsonKey(unknownEnumValue: AiRunStatus.unknown) AiRunStatus runStatus, List<String> imageUrls, DateTime? imageUrlsExpireAt, String? modelVersion, int? processingTimeMs,@JsonKey(unknownEnumValue: AiRecognitionStatus.unknown) AiRecognitionStatus? recognitionStatus,@JsonKey(unknownEnumValue: AiDiseaseLabel.unknown) AiDiseaseLabel? predictedLabel, double? confidence, List<AiPrediction> predictions, String? recommendation, AiDiagnosisError? error
});


@override $AiDiagnosisErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$AiDiagnosisDetailCopyWithImpl<$Res>
    implements _$AiDiagnosisDetailCopyWith<$Res> {
  __$AiDiagnosisDetailCopyWithImpl(this._self, this._then);

  final _AiDiagnosisDetail _self;
  final $Res Function(_AiDiagnosisDetail) _then;

/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? createdAt = null,Object? runStatus = null,Object? imageUrls = null,Object? imageUrlsExpireAt = freezed,Object? modelVersion = freezed,Object? processingTimeMs = freezed,Object? recognitionStatus = freezed,Object? predictedLabel = freezed,Object? confidence = freezed,Object? predictions = null,Object? recommendation = freezed,Object? error = freezed,}) {
  return _then(_AiDiagnosisDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,runStatus: null == runStatus ? _self.runStatus : runStatus // ignore: cast_nullable_to_non_nullable
as AiRunStatus,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrlsExpireAt: freezed == imageUrlsExpireAt ? _self.imageUrlsExpireAt : imageUrlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,processingTimeMs: freezed == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int?,recognitionStatus: freezed == recognitionStatus ? _self.recognitionStatus : recognitionStatus // ignore: cast_nullable_to_non_nullable
as AiRecognitionStatus?,predictedLabel: freezed == predictedLabel ? _self.predictedLabel : predictedLabel // ignore: cast_nullable_to_non_nullable
as AiDiseaseLabel?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,predictions: null == predictions ? _self._predictions : predictions // ignore: cast_nullable_to_non_nullable
as List<AiPrediction>,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AiDiagnosisError?,
  ));
}

/// Create a copy of AiDiagnosisDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $AiDiagnosisErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$AiDiagnosisPagination {

 int get totalResults; bool get hasNextPage; String? get nextCursor;
/// Create a copy of AiDiagnosisPagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisPaginationCopyWith<AiDiagnosisPagination> get copyWith => _$AiDiagnosisPaginationCopyWithImpl<AiDiagnosisPagination>(this as AiDiagnosisPagination, _$identity);

  /// Serializes this AiDiagnosisPagination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisPagination&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'AiDiagnosisPagination(totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisPaginationCopyWith<$Res>  {
  factory $AiDiagnosisPaginationCopyWith(AiDiagnosisPagination value, $Res Function(AiDiagnosisPagination) _then) = _$AiDiagnosisPaginationCopyWithImpl;
@useResult
$Res call({
 int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$AiDiagnosisPaginationCopyWithImpl<$Res>
    implements $AiDiagnosisPaginationCopyWith<$Res> {
  _$AiDiagnosisPaginationCopyWithImpl(this._self, this._then);

  final AiDiagnosisPagination _self;
  final $Res Function(AiDiagnosisPagination) _then;

/// Create a copy of AiDiagnosisPagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDiagnosisPagination].
extension AiDiagnosisPaginationPatterns on AiDiagnosisPagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisPagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisPagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisPagination value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisPagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisPagination value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisPagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisPagination() when $default != null:
return $default(_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalResults,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisPagination():
return $default(_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisPagination() when $default != null:
return $default(_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDiagnosisPagination implements AiDiagnosisPagination {
  const _AiDiagnosisPagination({required this.totalResults, required this.hasNextPage, this.nextCursor});
  factory _AiDiagnosisPagination.fromJson(Map<String, dynamic> json) => _$AiDiagnosisPaginationFromJson(json);

@override final  int totalResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of AiDiagnosisPagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisPaginationCopyWith<_AiDiagnosisPagination> get copyWith => __$AiDiagnosisPaginationCopyWithImpl<_AiDiagnosisPagination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDiagnosisPaginationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisPagination&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'AiDiagnosisPagination(totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisPaginationCopyWith<$Res> implements $AiDiagnosisPaginationCopyWith<$Res> {
  factory _$AiDiagnosisPaginationCopyWith(_AiDiagnosisPagination value, $Res Function(_AiDiagnosisPagination) _then) = __$AiDiagnosisPaginationCopyWithImpl;
@override @useResult
$Res call({
 int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$AiDiagnosisPaginationCopyWithImpl<$Res>
    implements _$AiDiagnosisPaginationCopyWith<$Res> {
  __$AiDiagnosisPaginationCopyWithImpl(this._self, this._then);

  final _AiDiagnosisPagination _self;
  final $Res Function(_AiDiagnosisPagination) _then;

/// Create a copy of AiDiagnosisPagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_AiDiagnosisPagination(
totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AiDiagnosisPage {

 List<AiDiagnosisSummary> get items; AiDiagnosisPagination get pagination;
/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisPageCopyWith<AiDiagnosisPage> get copyWith => _$AiDiagnosisPageCopyWithImpl<AiDiagnosisPage>(this as AiDiagnosisPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pagination);

@override
String toString() {
  return 'AiDiagnosisPage(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisPageCopyWith<$Res>  {
  factory $AiDiagnosisPageCopyWith(AiDiagnosisPage value, $Res Function(AiDiagnosisPage) _then) = _$AiDiagnosisPageCopyWithImpl;
@useResult
$Res call({
 List<AiDiagnosisSummary> items, AiDiagnosisPagination pagination
});


$AiDiagnosisPaginationCopyWith<$Res> get pagination;

}
/// @nodoc
class _$AiDiagnosisPageCopyWithImpl<$Res>
    implements $AiDiagnosisPageCopyWith<$Res> {
  _$AiDiagnosisPageCopyWithImpl(this._self, this._then);

  final AiDiagnosisPage _self;
  final $Res Function(AiDiagnosisPage) _then;

/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AiDiagnosisSummary>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as AiDiagnosisPagination,
  ));
}
/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisPaginationCopyWith<$Res> get pagination {
  
  return $AiDiagnosisPaginationCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDiagnosisPage].
extension AiDiagnosisPagePatterns on AiDiagnosisPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisPage value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisPage value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiDiagnosisSummary> items,  AiDiagnosisPagination pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisPage() when $default != null:
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiDiagnosisSummary> items,  AiDiagnosisPagination pagination)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisPage():
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiDiagnosisSummary> items,  AiDiagnosisPagination pagination)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisPage() when $default != null:
return $default(_that.items,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc


class _AiDiagnosisPage implements AiDiagnosisPage {
  const _AiDiagnosisPage({required final  List<AiDiagnosisSummary> items, required this.pagination}): _items = items;
  

 final  List<AiDiagnosisSummary> _items;
@override List<AiDiagnosisSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  AiDiagnosisPagination pagination;

/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisPageCopyWith<_AiDiagnosisPage> get copyWith => __$AiDiagnosisPageCopyWithImpl<_AiDiagnosisPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pagination);

@override
String toString() {
  return 'AiDiagnosisPage(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisPageCopyWith<$Res> implements $AiDiagnosisPageCopyWith<$Res> {
  factory _$AiDiagnosisPageCopyWith(_AiDiagnosisPage value, $Res Function(_AiDiagnosisPage) _then) = __$AiDiagnosisPageCopyWithImpl;
@override @useResult
$Res call({
 List<AiDiagnosisSummary> items, AiDiagnosisPagination pagination
});


@override $AiDiagnosisPaginationCopyWith<$Res> get pagination;

}
/// @nodoc
class __$AiDiagnosisPageCopyWithImpl<$Res>
    implements _$AiDiagnosisPageCopyWith<$Res> {
  __$AiDiagnosisPageCopyWithImpl(this._self, this._then);

  final _AiDiagnosisPage _self;
  final $Res Function(_AiDiagnosisPage) _then;

/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_AiDiagnosisPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AiDiagnosisSummary>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as AiDiagnosisPagination,
  ));
}

/// Create a copy of AiDiagnosisPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisPaginationCopyWith<$Res> get pagination {
  
  return $AiDiagnosisPaginationCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}

// dart format on
