// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_exceedance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterLogExceedance {

 String get field;@JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown) WaterLogWarningDirection get direction; double get value; double? get min; double? get max; String get unit;
/// Create a copy of WaterLogExceedance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterLogExceedanceCopyWith<WaterLogExceedance> get copyWith => _$WaterLogExceedanceCopyWithImpl<WaterLogExceedance>(this as WaterLogExceedance, _$identity);

  /// Serializes this WaterLogExceedance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterLogExceedance&&(identical(other.field, field) || other.field == field)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,direction,value,min,max,unit);

@override
String toString() {
  return 'WaterLogExceedance(field: $field, direction: $direction, value: $value, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $WaterLogExceedanceCopyWith<$Res>  {
  factory $WaterLogExceedanceCopyWith(WaterLogExceedance value, $Res Function(WaterLogExceedance) _then) = _$WaterLogExceedanceCopyWithImpl;
@useResult
$Res call({
 String field,@JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown) WaterLogWarningDirection direction, double value, double? min, double? max, String unit
});




}
/// @nodoc
class _$WaterLogExceedanceCopyWithImpl<$Res>
    implements $WaterLogExceedanceCopyWith<$Res> {
  _$WaterLogExceedanceCopyWithImpl(this._self, this._then);

  final WaterLogExceedance _self;
  final $Res Function(WaterLogExceedance) _then;

/// Create a copy of WaterLogExceedance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? direction = null,Object? value = null,Object? min = freezed,Object? max = freezed,Object? unit = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as WaterLogWarningDirection,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterLogExceedance].
extension WaterLogExceedancePatterns on WaterLogExceedance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterLogExceedance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterLogExceedance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterLogExceedance value)  $default,){
final _that = this;
switch (_that) {
case _WaterLogExceedance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterLogExceedance value)?  $default,){
final _that = this;
switch (_that) {
case _WaterLogExceedance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field, @JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown)  WaterLogWarningDirection direction,  double value,  double? min,  double? max,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterLogExceedance() when $default != null:
return $default(_that.field,_that.direction,_that.value,_that.min,_that.max,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field, @JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown)  WaterLogWarningDirection direction,  double value,  double? min,  double? max,  String unit)  $default,) {final _that = this;
switch (_that) {
case _WaterLogExceedance():
return $default(_that.field,_that.direction,_that.value,_that.min,_that.max,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field, @JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown)  WaterLogWarningDirection direction,  double value,  double? min,  double? max,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _WaterLogExceedance() when $default != null:
return $default(_that.field,_that.direction,_that.value,_that.min,_that.max,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterLogExceedance extends WaterLogExceedance {
  const _WaterLogExceedance({required this.field, @JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown) required this.direction, required this.value, required this.min, required this.max, required this.unit}): super._();
  factory _WaterLogExceedance.fromJson(Map<String, dynamic> json) => _$WaterLogExceedanceFromJson(json);

@override final  String field;
@override@JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown) final  WaterLogWarningDirection direction;
@override final  double value;
@override final  double? min;
@override final  double? max;
@override final  String unit;

/// Create a copy of WaterLogExceedance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterLogExceedanceCopyWith<_WaterLogExceedance> get copyWith => __$WaterLogExceedanceCopyWithImpl<_WaterLogExceedance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterLogExceedanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterLogExceedance&&(identical(other.field, field) || other.field == field)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,direction,value,min,max,unit);

@override
String toString() {
  return 'WaterLogExceedance(field: $field, direction: $direction, value: $value, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$WaterLogExceedanceCopyWith<$Res> implements $WaterLogExceedanceCopyWith<$Res> {
  factory _$WaterLogExceedanceCopyWith(_WaterLogExceedance value, $Res Function(_WaterLogExceedance) _then) = __$WaterLogExceedanceCopyWithImpl;
@override @useResult
$Res call({
 String field,@JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown) WaterLogWarningDirection direction, double value, double? min, double? max, String unit
});




}
/// @nodoc
class __$WaterLogExceedanceCopyWithImpl<$Res>
    implements _$WaterLogExceedanceCopyWith<$Res> {
  __$WaterLogExceedanceCopyWithImpl(this._self, this._then);

  final _WaterLogExceedance _self;
  final $Res Function(_WaterLogExceedance) _then;

/// Create a copy of WaterLogExceedance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? direction = null,Object? value = null,Object? min = freezed,Object? max = freezed,Object? unit = null,}) {
  return _then(_WaterLogExceedance(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as WaterLogWarningDirection,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
