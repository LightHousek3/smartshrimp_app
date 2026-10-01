// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FarmLocation {

 double get latitude; double get longitude; String? get displayAddress; double? get accuracyMeters;
/// Create a copy of FarmLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmLocationCopyWith<FarmLocation> get copyWith => _$FarmLocationCopyWithImpl<FarmLocation>(this as FarmLocation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmLocation&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.displayAddress, displayAddress) || other.displayAddress == displayAddress)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,displayAddress,accuracyMeters);

@override
String toString() {
  return 'FarmLocation(latitude: $latitude, longitude: $longitude, displayAddress: $displayAddress, accuracyMeters: $accuracyMeters)';
}


}

/// @nodoc
abstract mixin class $FarmLocationCopyWith<$Res>  {
  factory $FarmLocationCopyWith(FarmLocation value, $Res Function(FarmLocation) _then) = _$FarmLocationCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String? displayAddress, double? accuracyMeters
});




}
/// @nodoc
class _$FarmLocationCopyWithImpl<$Res>
    implements $FarmLocationCopyWith<$Res> {
  _$FarmLocationCopyWithImpl(this._self, this._then);

  final FarmLocation _self;
  final $Res Function(FarmLocation) _then;

/// Create a copy of FarmLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? displayAddress = freezed,Object? accuracyMeters = freezed,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,displayAddress: freezed == displayAddress ? _self.displayAddress : displayAddress // ignore: cast_nullable_to_non_nullable
as String?,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmLocation].
extension FarmLocationPatterns on FarmLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmLocation value)  $default,){
final _that = this;
switch (_that) {
case _FarmLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmLocation value)?  $default,){
final _that = this;
switch (_that) {
case _FarmLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String? displayAddress,  double? accuracyMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmLocation() when $default != null:
return $default(_that.latitude,_that.longitude,_that.displayAddress,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String? displayAddress,  double? accuracyMeters)  $default,) {final _that = this;
switch (_that) {
case _FarmLocation():
return $default(_that.latitude,_that.longitude,_that.displayAddress,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  String? displayAddress,  double? accuracyMeters)?  $default,) {final _that = this;
switch (_that) {
case _FarmLocation() when $default != null:
return $default(_that.latitude,_that.longitude,_that.displayAddress,_that.accuracyMeters);case _:
  return null;

}
}

}

/// @nodoc


class _FarmLocation implements FarmLocation {
  const _FarmLocation({required this.latitude, required this.longitude, this.displayAddress, this.accuracyMeters});
  

@override final  double latitude;
@override final  double longitude;
@override final  String? displayAddress;
@override final  double? accuracyMeters;

/// Create a copy of FarmLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmLocationCopyWith<_FarmLocation> get copyWith => __$FarmLocationCopyWithImpl<_FarmLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmLocation&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.displayAddress, displayAddress) || other.displayAddress == displayAddress)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,displayAddress,accuracyMeters);

@override
String toString() {
  return 'FarmLocation(latitude: $latitude, longitude: $longitude, displayAddress: $displayAddress, accuracyMeters: $accuracyMeters)';
}


}

/// @nodoc
abstract mixin class _$FarmLocationCopyWith<$Res> implements $FarmLocationCopyWith<$Res> {
  factory _$FarmLocationCopyWith(_FarmLocation value, $Res Function(_FarmLocation) _then) = __$FarmLocationCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, String? displayAddress, double? accuracyMeters
});




}
/// @nodoc
class __$FarmLocationCopyWithImpl<$Res>
    implements _$FarmLocationCopyWith<$Res> {
  __$FarmLocationCopyWithImpl(this._self, this._then);

  final _FarmLocation _self;
  final $Res Function(_FarmLocation) _then;

/// Create a copy of FarmLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? displayAddress = freezed,Object? accuracyMeters = freezed,}) {
  return _then(_FarmLocation(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,displayAddress: freezed == displayAddress ? _self.displayAddress : displayAddress // ignore: cast_nullable_to_non_nullable
as String?,accuracyMeters: freezed == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
