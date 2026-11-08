// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_diagnosis_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiDiagnosisImage {

 Uint8List get bytes; String get mimeType; String get fileName;
/// Create a copy of AiDiagnosisImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDiagnosisImageCopyWith<AiDiagnosisImage> get copyWith => _$AiDiagnosisImageCopyWithImpl<AiDiagnosisImage>(this as AiDiagnosisImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDiagnosisImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),mimeType,fileName);

@override
String toString() {
  return 'AiDiagnosisImage(bytes: $bytes, mimeType: $mimeType, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class $AiDiagnosisImageCopyWith<$Res>  {
  factory $AiDiagnosisImageCopyWith(AiDiagnosisImage value, $Res Function(AiDiagnosisImage) _then) = _$AiDiagnosisImageCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes, String mimeType, String fileName
});




}
/// @nodoc
class _$AiDiagnosisImageCopyWithImpl<$Res>
    implements $AiDiagnosisImageCopyWith<$Res> {
  _$AiDiagnosisImageCopyWithImpl(this._self, this._then);

  final AiDiagnosisImage _self;
  final $Res Function(AiDiagnosisImage) _then;

/// Create a copy of AiDiagnosisImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bytes = null,Object? mimeType = null,Object? fileName = null,}) {
  return _then(_self.copyWith(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDiagnosisImage].
extension AiDiagnosisImagePatterns on AiDiagnosisImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDiagnosisImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDiagnosisImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDiagnosisImage value)  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDiagnosisImage value)?  $default,){
final _that = this;
switch (_that) {
case _AiDiagnosisImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List bytes,  String mimeType,  String fileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDiagnosisImage() when $default != null:
return $default(_that.bytes,_that.mimeType,_that.fileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List bytes,  String mimeType,  String fileName)  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisImage():
return $default(_that.bytes,_that.mimeType,_that.fileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List bytes,  String mimeType,  String fileName)?  $default,) {final _that = this;
switch (_that) {
case _AiDiagnosisImage() when $default != null:
return $default(_that.bytes,_that.mimeType,_that.fileName);case _:
  return null;

}
}

}

/// @nodoc


class _AiDiagnosisImage implements AiDiagnosisImage {
  const _AiDiagnosisImage({required this.bytes, required this.mimeType, required this.fileName});
  

@override final  Uint8List bytes;
@override final  String mimeType;
@override final  String fileName;

/// Create a copy of AiDiagnosisImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDiagnosisImageCopyWith<_AiDiagnosisImage> get copyWith => __$AiDiagnosisImageCopyWithImpl<_AiDiagnosisImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDiagnosisImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),mimeType,fileName);

@override
String toString() {
  return 'AiDiagnosisImage(bytes: $bytes, mimeType: $mimeType, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$AiDiagnosisImageCopyWith<$Res> implements $AiDiagnosisImageCopyWith<$Res> {
  factory _$AiDiagnosisImageCopyWith(_AiDiagnosisImage value, $Res Function(_AiDiagnosisImage) _then) = __$AiDiagnosisImageCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String mimeType, String fileName
});




}
/// @nodoc
class __$AiDiagnosisImageCopyWithImpl<$Res>
    implements _$AiDiagnosisImageCopyWith<$Res> {
  __$AiDiagnosisImageCopyWithImpl(this._self, this._then);

  final _AiDiagnosisImage _self;
  final $Res Function(_AiDiagnosisImage) _then;

/// Create a copy of AiDiagnosisImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? mimeType = null,Object? fileName = null,}) {
  return _then(_AiDiagnosisImage(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
