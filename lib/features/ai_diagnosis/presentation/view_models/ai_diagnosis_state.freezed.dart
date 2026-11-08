// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_diagnosis_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiDiagnosisDraft {

 List<AiDiagnosisImage> get images; bool get picking; bool get submitting; bool get submissionFailed; Object? get error;
/// Create a copy of AiDiagnosisDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisDraftCopyWith<AiDiagnosisDraft> get copyWith => _$AiDiagnosisDraftCopyWithImpl<AiDiagnosisDraft>(this as AiDiagnosisDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisDraft&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.picking, picking) || other.picking == picking)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.submissionFailed, submissionFailed) || other.submissionFailed == submissionFailed)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(images),picking,submitting,submissionFailed,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AiDiagnosisDraft(images: $images, picking: $picking, submitting: $submitting, submissionFailed: $submissionFailed, error: $error)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisDraftCopyWith<$Res>  {
  factory $AiDiagnosisDraftCopyWith(AiDiagnosisDraft value, $Res Function(AiDiagnosisDraft) _then) = _$AiDiagnosisDraftCopyWithImpl;
@useResult
$Res call({
 List<AiDiagnosisImage> images, bool picking, bool submitting, bool submissionFailed, Object? error
});




}
/// @nodoc
class _$AiDiagnosisDraftCopyWithImpl<$Res>
    implements $AiDiagnosisDraftCopyWith<$Res> {
  _$AiDiagnosisDraftCopyWithImpl(this._self, this._then);

  final AiDiagnosisDraft _self;
  final $Res Function(AiDiagnosisDraft) _then;

/// Create a copy of AiDiagnosisDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? images = null,Object? picking = null,Object? submitting = null,Object? submissionFailed = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<AiDiagnosisImage>,picking: null == picking ? _self.picking : picking // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,submissionFailed: null == submissionFailed ? _self.submissionFailed : submissionFailed // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDiagnosisDraft].
extension AiDiagnosisDraftPatterns on AiDiagnosisDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisDraft value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiDiagnosisImage> images,  bool picking,  bool submitting,  bool submissionFailed,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisDraft() when $default != null:
return $default(_that.images,_that.picking,_that.submitting,_that.submissionFailed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiDiagnosisImage> images,  bool picking,  bool submitting,  bool submissionFailed,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisDraft():
return $default(_that.images,_that.picking,_that.submitting,_that.submissionFailed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiDiagnosisImage> images,  bool picking,  bool submitting,  bool submissionFailed,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisDraft() when $default != null:
return $default(_that.images,_that.picking,_that.submitting,_that.submissionFailed,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AiDiagnosisDraft implements AiDiagnosisDraft {
  const _AiDiagnosisDraft({final  List<AiDiagnosisImage> images = const [], this.picking = false, this.submitting = false, this.submissionFailed = false, this.error}): _images = images;
  

 final  List<AiDiagnosisImage> _images;
@override@JsonKey() List<AiDiagnosisImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey() final  bool picking;
@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool submissionFailed;
@override final  Object? error;

/// Create a copy of AiDiagnosisDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisDraftCopyWith<_AiDiagnosisDraft> get copyWith => __$AiDiagnosisDraftCopyWithImpl<_AiDiagnosisDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisDraft&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.picking, picking) || other.picking == picking)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.submissionFailed, submissionFailed) || other.submissionFailed == submissionFailed)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_images),picking,submitting,submissionFailed,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AiDiagnosisDraft(images: $images, picking: $picking, submitting: $submitting, submissionFailed: $submissionFailed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisDraftCopyWith<$Res> implements $AiDiagnosisDraftCopyWith<$Res> {
  factory _$AiDiagnosisDraftCopyWith(_AiDiagnosisDraft value, $Res Function(_AiDiagnosisDraft) _then) = __$AiDiagnosisDraftCopyWithImpl;
@override @useResult
$Res call({
 List<AiDiagnosisImage> images, bool picking, bool submitting, bool submissionFailed, Object? error
});




}
/// @nodoc
class __$AiDiagnosisDraftCopyWithImpl<$Res>
    implements _$AiDiagnosisDraftCopyWith<$Res> {
  __$AiDiagnosisDraftCopyWithImpl(this._self, this._then);

  final _AiDiagnosisDraft _self;
  final $Res Function(_AiDiagnosisDraft) _then;

/// Create a copy of AiDiagnosisDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? images = null,Object? picking = null,Object? submitting = null,Object? submissionFailed = null,Object? error = freezed,}) {
  return _then(_AiDiagnosisDraft(
images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<AiDiagnosisImage>,picking: null == picking ? _self.picking : picking // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,submissionFailed: null == submissionFailed ? _self.submissionFailed : submissionFailed // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

/// @nodoc
mixin _$AiDiagnosisHistory {

 AiDiagnosisPage get page; bool get loadingMore; Object? get paginationError;
/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisHistoryCopyWith<AiDiagnosisHistory> get copyWith => _$AiDiagnosisHistoryCopyWithImpl<AiDiagnosisHistory>(this as AiDiagnosisHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisHistory&&(identical(other.page, page) || other.page == page)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&const DeepCollectionEquality().equals(other.paginationError, paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,page,loadingMore,const DeepCollectionEquality().hash(paginationError));

@override
String toString() {
  return 'AiDiagnosisHistory(page: $page, loadingMore: $loadingMore, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisHistoryCopyWith<$Res>  {
  factory $AiDiagnosisHistoryCopyWith(AiDiagnosisHistory value, $Res Function(AiDiagnosisHistory) _then) = _$AiDiagnosisHistoryCopyWithImpl;
@useResult
$Res call({
 AiDiagnosisPage page, bool loadingMore, Object? paginationError
});


$AiDiagnosisPageCopyWith<$Res> get page;

}
/// @nodoc
class _$AiDiagnosisHistoryCopyWithImpl<$Res>
    implements $AiDiagnosisHistoryCopyWith<$Res> {
  _$AiDiagnosisHistoryCopyWithImpl(this._self, this._then);

  final AiDiagnosisHistory _self;
  final $Res Function(AiDiagnosisHistory) _then;

/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? loadingMore = null,Object? paginationError = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as AiDiagnosisPage,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,paginationError: freezed == paginationError ? _self.paginationError : paginationError ,
  ));
}
/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisPageCopyWith<$Res> get page {
  
  return $AiDiagnosisPageCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDiagnosisHistory].
extension AiDiagnosisHistoryPatterns on AiDiagnosisHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisHistory value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisHistory value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiDiagnosisPage page,  bool loadingMore,  Object? paginationError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisHistory() when $default != null:
return $default(_that.page,_that.loadingMore,_that.paginationError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiDiagnosisPage page,  bool loadingMore,  Object? paginationError)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisHistory():
return $default(_that.page,_that.loadingMore,_that.paginationError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiDiagnosisPage page,  bool loadingMore,  Object? paginationError)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisHistory() when $default != null:
return $default(_that.page,_that.loadingMore,_that.paginationError);case _:
  return null;

}
}

}

/// @nodoc


class _AiDiagnosisHistory implements AiDiagnosisHistory {
  const _AiDiagnosisHistory({required this.page, this.loadingMore = false, this.paginationError});
  

@override final  AiDiagnosisPage page;
@override@JsonKey() final  bool loadingMore;
@override final  Object? paginationError;

/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisHistoryCopyWith<_AiDiagnosisHistory> get copyWith => __$AiDiagnosisHistoryCopyWithImpl<_AiDiagnosisHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisHistory&&(identical(other.page, page) || other.page == page)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&const DeepCollectionEquality().equals(other.paginationError, paginationError));
}


@override
int get hashCode => Object.hash(runtimeType,page,loadingMore,const DeepCollectionEquality().hash(paginationError));

@override
String toString() {
  return 'AiDiagnosisHistory(page: $page, loadingMore: $loadingMore, paginationError: $paginationError)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisHistoryCopyWith<$Res> implements $AiDiagnosisHistoryCopyWith<$Res> {
  factory _$AiDiagnosisHistoryCopyWith(_AiDiagnosisHistory value, $Res Function(_AiDiagnosisHistory) _then) = __$AiDiagnosisHistoryCopyWithImpl;
@override @useResult
$Res call({
 AiDiagnosisPage page, bool loadingMore, Object? paginationError
});


@override $AiDiagnosisPageCopyWith<$Res> get page;

}
/// @nodoc
class __$AiDiagnosisHistoryCopyWithImpl<$Res>
    implements _$AiDiagnosisHistoryCopyWith<$Res> {
  __$AiDiagnosisHistoryCopyWithImpl(this._self, this._then);

  final _AiDiagnosisHistory _self;
  final $Res Function(_AiDiagnosisHistory) _then;

/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? loadingMore = null,Object? paginationError = freezed,}) {
  return _then(_AiDiagnosisHistory(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as AiDiagnosisPage,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,paginationError: freezed == paginationError ? _self.paginationError : paginationError ,
  ));
}

/// Create a copy of AiDiagnosisHistory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiDiagnosisPageCopyWith<$Res> get page {
  
  return $AiDiagnosisPageCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

// dart format on
