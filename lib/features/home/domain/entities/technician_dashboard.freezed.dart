// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechnicianSummary {

 int get activeSeasonCount; int get openTaskCount; int get unresolvedActiveSeasonCaseCount;
/// Create a copy of TechnicianSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianSummaryCopyWith<TechnicianSummary> get copyWith => _$TechnicianSummaryCopyWithImpl<TechnicianSummary>(this as TechnicianSummary, _$identity);

  /// Serializes this TechnicianSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianSummary&&(identical(other.activeSeasonCount, activeSeasonCount) || other.activeSeasonCount == activeSeasonCount)&&(identical(other.openTaskCount, openTaskCount) || other.openTaskCount == openTaskCount)&&(identical(other.unresolvedActiveSeasonCaseCount, unresolvedActiveSeasonCaseCount) || other.unresolvedActiveSeasonCaseCount == unresolvedActiveSeasonCaseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeSeasonCount,openTaskCount,unresolvedActiveSeasonCaseCount);

@override
String toString() {
  return 'TechnicianSummary(activeSeasonCount: $activeSeasonCount, openTaskCount: $openTaskCount, unresolvedActiveSeasonCaseCount: $unresolvedActiveSeasonCaseCount)';
}


}

/// @nodoc
abstract mixin class $TechnicianSummaryCopyWith<$Res>  {
  factory $TechnicianSummaryCopyWith(TechnicianSummary value, $Res Function(TechnicianSummary) _then) = _$TechnicianSummaryCopyWithImpl;
@useResult
$Res call({
 int activeSeasonCount, int openTaskCount, int unresolvedActiveSeasonCaseCount
});




}
/// @nodoc
class _$TechnicianSummaryCopyWithImpl<$Res>
    implements $TechnicianSummaryCopyWith<$Res> {
  _$TechnicianSummaryCopyWithImpl(this._self, this._then);

  final TechnicianSummary _self;
  final $Res Function(TechnicianSummary) _then;

/// Create a copy of TechnicianSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeSeasonCount = null,Object? openTaskCount = null,Object? unresolvedActiveSeasonCaseCount = null,}) {
  return _then(_self.copyWith(
activeSeasonCount: null == activeSeasonCount ? _self.activeSeasonCount : activeSeasonCount // ignore: cast_nullable_to_non_nullable
as int,openTaskCount: null == openTaskCount ? _self.openTaskCount : openTaskCount // ignore: cast_nullable_to_non_nullable
as int,unresolvedActiveSeasonCaseCount: null == unresolvedActiveSeasonCaseCount ? _self.unresolvedActiveSeasonCaseCount : unresolvedActiveSeasonCaseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianSummary].
extension TechnicianSummaryPatterns on TechnicianSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianSummary value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeSeasonCount,  int openTaskCount,  int unresolvedActiveSeasonCaseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianSummary() when $default != null:
return $default(_that.activeSeasonCount,_that.openTaskCount,_that.unresolvedActiveSeasonCaseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeSeasonCount,  int openTaskCount,  int unresolvedActiveSeasonCaseCount)  $default,) {final _that = this;
switch (_that) {
case _TechnicianSummary():
return $default(_that.activeSeasonCount,_that.openTaskCount,_that.unresolvedActiveSeasonCaseCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeSeasonCount,  int openTaskCount,  int unresolvedActiveSeasonCaseCount)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianSummary() when $default != null:
return $default(_that.activeSeasonCount,_that.openTaskCount,_that.unresolvedActiveSeasonCaseCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianSummary implements TechnicianSummary {
  const _TechnicianSummary({required this.activeSeasonCount, required this.openTaskCount, required this.unresolvedActiveSeasonCaseCount});
  factory _TechnicianSummary.fromJson(Map<String, dynamic> json) => _$TechnicianSummaryFromJson(json);

@override final  int activeSeasonCount;
@override final  int openTaskCount;
@override final  int unresolvedActiveSeasonCaseCount;

/// Create a copy of TechnicianSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianSummaryCopyWith<_TechnicianSummary> get copyWith => __$TechnicianSummaryCopyWithImpl<_TechnicianSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianSummary&&(identical(other.activeSeasonCount, activeSeasonCount) || other.activeSeasonCount == activeSeasonCount)&&(identical(other.openTaskCount, openTaskCount) || other.openTaskCount == openTaskCount)&&(identical(other.unresolvedActiveSeasonCaseCount, unresolvedActiveSeasonCaseCount) || other.unresolvedActiveSeasonCaseCount == unresolvedActiveSeasonCaseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeSeasonCount,openTaskCount,unresolvedActiveSeasonCaseCount);

@override
String toString() {
  return 'TechnicianSummary(activeSeasonCount: $activeSeasonCount, openTaskCount: $openTaskCount, unresolvedActiveSeasonCaseCount: $unresolvedActiveSeasonCaseCount)';
}


}

/// @nodoc
abstract mixin class _$TechnicianSummaryCopyWith<$Res> implements $TechnicianSummaryCopyWith<$Res> {
  factory _$TechnicianSummaryCopyWith(_TechnicianSummary value, $Res Function(_TechnicianSummary) _then) = __$TechnicianSummaryCopyWithImpl;
@override @useResult
$Res call({
 int activeSeasonCount, int openTaskCount, int unresolvedActiveSeasonCaseCount
});




}
/// @nodoc
class __$TechnicianSummaryCopyWithImpl<$Res>
    implements _$TechnicianSummaryCopyWith<$Res> {
  __$TechnicianSummaryCopyWithImpl(this._self, this._then);

  final _TechnicianSummary _self;
  final $Res Function(_TechnicianSummary) _then;

/// Create a copy of TechnicianSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeSeasonCount = null,Object? openTaskCount = null,Object? unresolvedActiveSeasonCaseCount = null,}) {
  return _then(_TechnicianSummary(
activeSeasonCount: null == activeSeasonCount ? _self.activeSeasonCount : activeSeasonCount // ignore: cast_nullable_to_non_nullable
as int,openTaskCount: null == openTaskCount ? _self.openTaskCount : openTaskCount // ignore: cast_nullable_to_non_nullable
as int,unresolvedActiveSeasonCaseCount: null == unresolvedActiveSeasonCaseCount ? _self.unresolvedActiveSeasonCaseCount : unresolvedActiveSeasonCaseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TechnicianWaterMetric {

 String get field; double get value; String get unit; DateTime get recordedAt; double? get min; double? get max;
/// Create a copy of TechnicianWaterMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianWaterMetricCopyWith<TechnicianWaterMetric> get copyWith => _$TechnicianWaterMetricCopyWithImpl<TechnicianWaterMetric>(this as TechnicianWaterMetric, _$identity);

  /// Serializes this TechnicianWaterMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianWaterMetric&&(identical(other.field, field) || other.field == field)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,value,unit,recordedAt,min,max);

@override
String toString() {
  return 'TechnicianWaterMetric(field: $field, value: $value, unit: $unit, recordedAt: $recordedAt, min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class $TechnicianWaterMetricCopyWith<$Res>  {
  factory $TechnicianWaterMetricCopyWith(TechnicianWaterMetric value, $Res Function(TechnicianWaterMetric) _then) = _$TechnicianWaterMetricCopyWithImpl;
@useResult
$Res call({
 String field, double value, String unit, DateTime recordedAt, double? min, double? max
});




}
/// @nodoc
class _$TechnicianWaterMetricCopyWithImpl<$Res>
    implements $TechnicianWaterMetricCopyWith<$Res> {
  _$TechnicianWaterMetricCopyWithImpl(this._self, this._then);

  final TechnicianWaterMetric _self;
  final $Res Function(TechnicianWaterMetric) _then;

/// Create a copy of TechnicianWaterMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? value = null,Object? unit = null,Object? recordedAt = null,Object? min = freezed,Object? max = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianWaterMetric].
extension TechnicianWaterMetricPatterns on TechnicianWaterMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianWaterMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianWaterMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianWaterMetric value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianWaterMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianWaterMetric value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianWaterMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  double value,  String unit,  DateTime recordedAt,  double? min,  double? max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianWaterMetric() when $default != null:
return $default(_that.field,_that.value,_that.unit,_that.recordedAt,_that.min,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  double value,  String unit,  DateTime recordedAt,  double? min,  double? max)  $default,) {final _that = this;
switch (_that) {
case _TechnicianWaterMetric():
return $default(_that.field,_that.value,_that.unit,_that.recordedAt,_that.min,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  double value,  String unit,  DateTime recordedAt,  double? min,  double? max)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianWaterMetric() when $default != null:
return $default(_that.field,_that.value,_that.unit,_that.recordedAt,_that.min,_that.max);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianWaterMetric implements TechnicianWaterMetric {
  const _TechnicianWaterMetric({required this.field, required this.value, required this.unit, required this.recordedAt, this.min, this.max});
  factory _TechnicianWaterMetric.fromJson(Map<String, dynamic> json) => _$TechnicianWaterMetricFromJson(json);

@override final  String field;
@override final  double value;
@override final  String unit;
@override final  DateTime recordedAt;
@override final  double? min;
@override final  double? max;

/// Create a copy of TechnicianWaterMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianWaterMetricCopyWith<_TechnicianWaterMetric> get copyWith => __$TechnicianWaterMetricCopyWithImpl<_TechnicianWaterMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianWaterMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianWaterMetric&&(identical(other.field, field) || other.field == field)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,value,unit,recordedAt,min,max);

@override
String toString() {
  return 'TechnicianWaterMetric(field: $field, value: $value, unit: $unit, recordedAt: $recordedAt, min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class _$TechnicianWaterMetricCopyWith<$Res> implements $TechnicianWaterMetricCopyWith<$Res> {
  factory _$TechnicianWaterMetricCopyWith(_TechnicianWaterMetric value, $Res Function(_TechnicianWaterMetric) _then) = __$TechnicianWaterMetricCopyWithImpl;
@override @useResult
$Res call({
 String field, double value, String unit, DateTime recordedAt, double? min, double? max
});




}
/// @nodoc
class __$TechnicianWaterMetricCopyWithImpl<$Res>
    implements _$TechnicianWaterMetricCopyWith<$Res> {
  __$TechnicianWaterMetricCopyWithImpl(this._self, this._then);

  final _TechnicianWaterMetric _self;
  final $Res Function(_TechnicianWaterMetric) _then;

/// Create a copy of TechnicianWaterMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? value = null,Object? unit = null,Object? recordedAt = null,Object? min = freezed,Object? max = freezed,}) {
  return _then(_TechnicianWaterMetric(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$TechnicianAlert {

 String get id;@JsonKey(unknownEnumValue: TechnicianAlertKind.unknown) TechnicianAlertKind get kind; String get seasonId; String get seasonName; String get pondName; String get farmName; int get count; DateTime get observedAt; List<TechnicianWaterMetric> get metrics; List<String> get reasonCodes;
/// Create a copy of TechnicianAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianAlertCopyWith<TechnicianAlert> get copyWith => _$TechnicianAlertCopyWithImpl<TechnicianAlert>(this as TechnicianAlert, _$identity);

  /// Serializes this TechnicianAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.count, count) || other.count == count)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&const DeepCollectionEquality().equals(other.metrics, metrics)&&const DeepCollectionEquality().equals(other.reasonCodes, reasonCodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,seasonId,seasonName,pondName,farmName,count,observedAt,const DeepCollectionEquality().hash(metrics),const DeepCollectionEquality().hash(reasonCodes));

@override
String toString() {
  return 'TechnicianAlert(id: $id, kind: $kind, seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, count: $count, observedAt: $observedAt, metrics: $metrics, reasonCodes: $reasonCodes)';
}


}

/// @nodoc
abstract mixin class $TechnicianAlertCopyWith<$Res>  {
  factory $TechnicianAlertCopyWith(TechnicianAlert value, $Res Function(TechnicianAlert) _then) = _$TechnicianAlertCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: TechnicianAlertKind.unknown) TechnicianAlertKind kind, String seasonId, String seasonName, String pondName, String farmName, int count, DateTime observedAt, List<TechnicianWaterMetric> metrics, List<String> reasonCodes
});




}
/// @nodoc
class _$TechnicianAlertCopyWithImpl<$Res>
    implements $TechnicianAlertCopyWith<$Res> {
  _$TechnicianAlertCopyWithImpl(this._self, this._then);

  final TechnicianAlert _self;
  final $Res Function(TechnicianAlert) _then;

/// Create a copy of TechnicianAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? count = null,Object? observedAt = null,Object? metrics = null,Object? reasonCodes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TechnicianAlertKind,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<TechnicianWaterMetric>,reasonCodes: null == reasonCodes ? _self.reasonCodes : reasonCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianAlert].
extension TechnicianAlertPatterns on TechnicianAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianAlert value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianAlert value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: TechnicianAlertKind.unknown)  TechnicianAlertKind kind,  String seasonId,  String seasonName,  String pondName,  String farmName,  int count,  DateTime observedAt,  List<TechnicianWaterMetric> metrics,  List<String> reasonCodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianAlert() when $default != null:
return $default(_that.id,_that.kind,_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.count,_that.observedAt,_that.metrics,_that.reasonCodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: TechnicianAlertKind.unknown)  TechnicianAlertKind kind,  String seasonId,  String seasonName,  String pondName,  String farmName,  int count,  DateTime observedAt,  List<TechnicianWaterMetric> metrics,  List<String> reasonCodes)  $default,) {final _that = this;
switch (_that) {
case _TechnicianAlert():
return $default(_that.id,_that.kind,_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.count,_that.observedAt,_that.metrics,_that.reasonCodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: TechnicianAlertKind.unknown)  TechnicianAlertKind kind,  String seasonId,  String seasonName,  String pondName,  String farmName,  int count,  DateTime observedAt,  List<TechnicianWaterMetric> metrics,  List<String> reasonCodes)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianAlert() when $default != null:
return $default(_that.id,_that.kind,_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.count,_that.observedAt,_that.metrics,_that.reasonCodes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianAlert implements TechnicianAlert {
  const _TechnicianAlert({required this.id, @JsonKey(unknownEnumValue: TechnicianAlertKind.unknown) required this.kind, required this.seasonId, required this.seasonName, required this.pondName, required this.farmName, required this.count, required this.observedAt, final  List<TechnicianWaterMetric> metrics = const [], final  List<String> reasonCodes = const []}): _metrics = metrics,_reasonCodes = reasonCodes;
  factory _TechnicianAlert.fromJson(Map<String, dynamic> json) => _$TechnicianAlertFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: TechnicianAlertKind.unknown) final  TechnicianAlertKind kind;
@override final  String seasonId;
@override final  String seasonName;
@override final  String pondName;
@override final  String farmName;
@override final  int count;
@override final  DateTime observedAt;
 final  List<TechnicianWaterMetric> _metrics;
@override@JsonKey() List<TechnicianWaterMetric> get metrics {
  if (_metrics is EqualUnmodifiableListView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metrics);
}

 final  List<String> _reasonCodes;
@override@JsonKey() List<String> get reasonCodes {
  if (_reasonCodes is EqualUnmodifiableListView) return _reasonCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasonCodes);
}


/// Create a copy of TechnicianAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianAlertCopyWith<_TechnicianAlert> get copyWith => __$TechnicianAlertCopyWithImpl<_TechnicianAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.count, count) || other.count == count)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&const DeepCollectionEquality().equals(other._metrics, _metrics)&&const DeepCollectionEquality().equals(other._reasonCodes, _reasonCodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,seasonId,seasonName,pondName,farmName,count,observedAt,const DeepCollectionEquality().hash(_metrics),const DeepCollectionEquality().hash(_reasonCodes));

@override
String toString() {
  return 'TechnicianAlert(id: $id, kind: $kind, seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, count: $count, observedAt: $observedAt, metrics: $metrics, reasonCodes: $reasonCodes)';
}


}

/// @nodoc
abstract mixin class _$TechnicianAlertCopyWith<$Res> implements $TechnicianAlertCopyWith<$Res> {
  factory _$TechnicianAlertCopyWith(_TechnicianAlert value, $Res Function(_TechnicianAlert) _then) = __$TechnicianAlertCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: TechnicianAlertKind.unknown) TechnicianAlertKind kind, String seasonId, String seasonName, String pondName, String farmName, int count, DateTime observedAt, List<TechnicianWaterMetric> metrics, List<String> reasonCodes
});




}
/// @nodoc
class __$TechnicianAlertCopyWithImpl<$Res>
    implements _$TechnicianAlertCopyWith<$Res> {
  __$TechnicianAlertCopyWithImpl(this._self, this._then);

  final _TechnicianAlert _self;
  final $Res Function(_TechnicianAlert) _then;

/// Create a copy of TechnicianAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? count = null,Object? observedAt = null,Object? metrics = null,Object? reasonCodes = null,}) {
  return _then(_TechnicianAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TechnicianAlertKind,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<TechnicianWaterMetric>,reasonCodes: null == reasonCodes ? _self._reasonCodes : reasonCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TechnicianOperation {

 String get id; String get operationType; DateTime get scheduledAt; double get plannedQuantity; String get unit; String? get productName;
/// Create a copy of TechnicianOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianOperationCopyWith<TechnicianOperation> get copyWith => _$TechnicianOperationCopyWithImpl<TechnicianOperation>(this as TechnicianOperation, _$identity);

  /// Serializes this TechnicianOperation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.plannedQuantity, plannedQuantity) || other.plannedQuantity == plannedQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.productName, productName) || other.productName == productName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationType,scheduledAt,plannedQuantity,unit,productName);

@override
String toString() {
  return 'TechnicianOperation(id: $id, operationType: $operationType, scheduledAt: $scheduledAt, plannedQuantity: $plannedQuantity, unit: $unit, productName: $productName)';
}


}

/// @nodoc
abstract mixin class $TechnicianOperationCopyWith<$Res>  {
  factory $TechnicianOperationCopyWith(TechnicianOperation value, $Res Function(TechnicianOperation) _then) = _$TechnicianOperationCopyWithImpl;
@useResult
$Res call({
 String id, String operationType, DateTime scheduledAt, double plannedQuantity, String unit, String? productName
});




}
/// @nodoc
class _$TechnicianOperationCopyWithImpl<$Res>
    implements $TechnicianOperationCopyWith<$Res> {
  _$TechnicianOperationCopyWithImpl(this._self, this._then);

  final TechnicianOperation _self;
  final $Res Function(TechnicianOperation) _then;

/// Create a copy of TechnicianOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operationType = null,Object? scheduledAt = null,Object? plannedQuantity = null,Object? unit = null,Object? productName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,plannedQuantity: null == plannedQuantity ? _self.plannedQuantity : plannedQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianOperation].
extension TechnicianOperationPatterns on TechnicianOperation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianOperation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianOperation value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianOperation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianOperation value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianOperation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String operationType,  DateTime scheduledAt,  double plannedQuantity,  String unit,  String? productName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianOperation() when $default != null:
return $default(_that.id,_that.operationType,_that.scheduledAt,_that.plannedQuantity,_that.unit,_that.productName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String operationType,  DateTime scheduledAt,  double plannedQuantity,  String unit,  String? productName)  $default,) {final _that = this;
switch (_that) {
case _TechnicianOperation():
return $default(_that.id,_that.operationType,_that.scheduledAt,_that.plannedQuantity,_that.unit,_that.productName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String operationType,  DateTime scheduledAt,  double plannedQuantity,  String unit,  String? productName)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianOperation() when $default != null:
return $default(_that.id,_that.operationType,_that.scheduledAt,_that.plannedQuantity,_that.unit,_that.productName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianOperation implements TechnicianOperation {
  const _TechnicianOperation({required this.id, required this.operationType, required this.scheduledAt, required this.plannedQuantity, required this.unit, this.productName});
  factory _TechnicianOperation.fromJson(Map<String, dynamic> json) => _$TechnicianOperationFromJson(json);

@override final  String id;
@override final  String operationType;
@override final  DateTime scheduledAt;
@override final  double plannedQuantity;
@override final  String unit;
@override final  String? productName;

/// Create a copy of TechnicianOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianOperationCopyWith<_TechnicianOperation> get copyWith => __$TechnicianOperationCopyWithImpl<_TechnicianOperation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianOperationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.plannedQuantity, plannedQuantity) || other.plannedQuantity == plannedQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.productName, productName) || other.productName == productName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationType,scheduledAt,plannedQuantity,unit,productName);

@override
String toString() {
  return 'TechnicianOperation(id: $id, operationType: $operationType, scheduledAt: $scheduledAt, plannedQuantity: $plannedQuantity, unit: $unit, productName: $productName)';
}


}

/// @nodoc
abstract mixin class _$TechnicianOperationCopyWith<$Res> implements $TechnicianOperationCopyWith<$Res> {
  factory _$TechnicianOperationCopyWith(_TechnicianOperation value, $Res Function(_TechnicianOperation) _then) = __$TechnicianOperationCopyWithImpl;
@override @useResult
$Res call({
 String id, String operationType, DateTime scheduledAt, double plannedQuantity, String unit, String? productName
});




}
/// @nodoc
class __$TechnicianOperationCopyWithImpl<$Res>
    implements _$TechnicianOperationCopyWith<$Res> {
  __$TechnicianOperationCopyWithImpl(this._self, this._then);

  final _TechnicianOperation _self;
  final $Res Function(_TechnicianOperation) _then;

/// Create a copy of TechnicianOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operationType = null,Object? scheduledAt = null,Object? plannedQuantity = null,Object? unit = null,Object? productName = freezed,}) {
  return _then(_TechnicianOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,plannedQuantity: null == plannedQuantity ? _self.plannedQuantity : plannedQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TechnicianOperationGroup {

 String get seasonId; String get seasonName; String get pondName; String get farmName; List<TechnicianOperation> get items;
/// Create a copy of TechnicianOperationGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianOperationGroupCopyWith<TechnicianOperationGroup> get copyWith => _$TechnicianOperationGroupCopyWithImpl<TechnicianOperationGroup>(this as TechnicianOperationGroup, _$identity);

  /// Serializes this TechnicianOperationGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianOperationGroup&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondName,farmName,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TechnicianOperationGroup(seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, items: $items)';
}


}

/// @nodoc
abstract mixin class $TechnicianOperationGroupCopyWith<$Res>  {
  factory $TechnicianOperationGroupCopyWith(TechnicianOperationGroup value, $Res Function(TechnicianOperationGroup) _then) = _$TechnicianOperationGroupCopyWithImpl;
@useResult
$Res call({
 String seasonId, String seasonName, String pondName, String farmName, List<TechnicianOperation> items
});




}
/// @nodoc
class _$TechnicianOperationGroupCopyWithImpl<$Res>
    implements $TechnicianOperationGroupCopyWith<$Res> {
  _$TechnicianOperationGroupCopyWithImpl(this._self, this._then);

  final TechnicianOperationGroup _self;
  final $Res Function(TechnicianOperationGroup) _then;

/// Create a copy of TechnicianOperationGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? items = null,}) {
  return _then(_self.copyWith(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TechnicianOperation>,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianOperationGroup].
extension TechnicianOperationGroupPatterns on TechnicianOperationGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianOperationGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianOperationGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianOperationGroup value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianOperationGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianOperationGroup value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianOperationGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondName,  String farmName,  List<TechnicianOperation> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianOperationGroup() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondName,  String farmName,  List<TechnicianOperation> items)  $default,) {final _that = this;
switch (_that) {
case _TechnicianOperationGroup():
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String seasonId,  String seasonName,  String pondName,  String farmName,  List<TechnicianOperation> items)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianOperationGroup() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.items);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianOperationGroup implements TechnicianOperationGroup {
  const _TechnicianOperationGroup({required this.seasonId, required this.seasonName, required this.pondName, required this.farmName, required final  List<TechnicianOperation> items}): _items = items;
  factory _TechnicianOperationGroup.fromJson(Map<String, dynamic> json) => _$TechnicianOperationGroupFromJson(json);

@override final  String seasonId;
@override final  String seasonName;
@override final  String pondName;
@override final  String farmName;
 final  List<TechnicianOperation> _items;
@override List<TechnicianOperation> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TechnicianOperationGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianOperationGroupCopyWith<_TechnicianOperationGroup> get copyWith => __$TechnicianOperationGroupCopyWithImpl<_TechnicianOperationGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianOperationGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianOperationGroup&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondName,farmName,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TechnicianOperationGroup(seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TechnicianOperationGroupCopyWith<$Res> implements $TechnicianOperationGroupCopyWith<$Res> {
  factory _$TechnicianOperationGroupCopyWith(_TechnicianOperationGroup value, $Res Function(_TechnicianOperationGroup) _then) = __$TechnicianOperationGroupCopyWithImpl;
@override @useResult
$Res call({
 String seasonId, String seasonName, String pondName, String farmName, List<TechnicianOperation> items
});




}
/// @nodoc
class __$TechnicianOperationGroupCopyWithImpl<$Res>
    implements _$TechnicianOperationGroupCopyWith<$Res> {
  __$TechnicianOperationGroupCopyWithImpl(this._self, this._then);

  final _TechnicianOperationGroup _self;
  final $Res Function(_TechnicianOperationGroup) _then;

/// Create a copy of TechnicianOperationGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? items = null,}) {
  return _then(_TechnicianOperationGroup(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TechnicianOperation>,
  ));
}


}


/// @nodoc
mixin _$TechnicianSeasonSnapshot {

 String get seasonId; String get seasonName; String get pondName; String get farmName;@JsonKey(unknownEnumValue: BiomassSnapshotState.unknown) BiomassSnapshotState get biomassState; int? get cultureDay; double? get biomassKg; DateTime? get biomassRecordedAt;
/// Create a copy of TechnicianSeasonSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianSeasonSnapshotCopyWith<TechnicianSeasonSnapshot> get copyWith => _$TechnicianSeasonSnapshotCopyWithImpl<TechnicianSeasonSnapshot>(this as TechnicianSeasonSnapshot, _$identity);

  /// Serializes this TechnicianSeasonSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianSeasonSnapshot&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.biomassState, biomassState) || other.biomassState == biomassState)&&(identical(other.cultureDay, cultureDay) || other.cultureDay == cultureDay)&&(identical(other.biomassKg, biomassKg) || other.biomassKg == biomassKg)&&(identical(other.biomassRecordedAt, biomassRecordedAt) || other.biomassRecordedAt == biomassRecordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondName,farmName,biomassState,cultureDay,biomassKg,biomassRecordedAt);

@override
String toString() {
  return 'TechnicianSeasonSnapshot(seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, biomassState: $biomassState, cultureDay: $cultureDay, biomassKg: $biomassKg, biomassRecordedAt: $biomassRecordedAt)';
}


}

/// @nodoc
abstract mixin class $TechnicianSeasonSnapshotCopyWith<$Res>  {
  factory $TechnicianSeasonSnapshotCopyWith(TechnicianSeasonSnapshot value, $Res Function(TechnicianSeasonSnapshot) _then) = _$TechnicianSeasonSnapshotCopyWithImpl;
@useResult
$Res call({
 String seasonId, String seasonName, String pondName, String farmName,@JsonKey(unknownEnumValue: BiomassSnapshotState.unknown) BiomassSnapshotState biomassState, int? cultureDay, double? biomassKg, DateTime? biomassRecordedAt
});




}
/// @nodoc
class _$TechnicianSeasonSnapshotCopyWithImpl<$Res>
    implements $TechnicianSeasonSnapshotCopyWith<$Res> {
  _$TechnicianSeasonSnapshotCopyWithImpl(this._self, this._then);

  final TechnicianSeasonSnapshot _self;
  final $Res Function(TechnicianSeasonSnapshot) _then;

/// Create a copy of TechnicianSeasonSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? biomassState = null,Object? cultureDay = freezed,Object? biomassKg = freezed,Object? biomassRecordedAt = freezed,}) {
  return _then(_self.copyWith(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,biomassState: null == biomassState ? _self.biomassState : biomassState // ignore: cast_nullable_to_non_nullable
as BiomassSnapshotState,cultureDay: freezed == cultureDay ? _self.cultureDay : cultureDay // ignore: cast_nullable_to_non_nullable
as int?,biomassKg: freezed == biomassKg ? _self.biomassKg : biomassKg // ignore: cast_nullable_to_non_nullable
as double?,biomassRecordedAt: freezed == biomassRecordedAt ? _self.biomassRecordedAt : biomassRecordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianSeasonSnapshot].
extension TechnicianSeasonSnapshotPatterns on TechnicianSeasonSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianSeasonSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianSeasonSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianSeasonSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondName,  String farmName, @JsonKey(unknownEnumValue: BiomassSnapshotState.unknown)  BiomassSnapshotState biomassState,  int? cultureDay,  double? biomassKg,  DateTime? biomassRecordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.biomassState,_that.cultureDay,_that.biomassKg,_that.biomassRecordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondName,  String farmName, @JsonKey(unknownEnumValue: BiomassSnapshotState.unknown)  BiomassSnapshotState biomassState,  int? cultureDay,  double? biomassKg,  DateTime? biomassRecordedAt)  $default,) {final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot():
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.biomassState,_that.cultureDay,_that.biomassKg,_that.biomassRecordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String seasonId,  String seasonName,  String pondName,  String farmName, @JsonKey(unknownEnumValue: BiomassSnapshotState.unknown)  BiomassSnapshotState biomassState,  int? cultureDay,  double? biomassKg,  DateTime? biomassRecordedAt)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianSeasonSnapshot() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondName,_that.farmName,_that.biomassState,_that.cultureDay,_that.biomassKg,_that.biomassRecordedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianSeasonSnapshot implements TechnicianSeasonSnapshot {
  const _TechnicianSeasonSnapshot({required this.seasonId, required this.seasonName, required this.pondName, required this.farmName, @JsonKey(unknownEnumValue: BiomassSnapshotState.unknown) required this.biomassState, this.cultureDay, this.biomassKg, this.biomassRecordedAt});
  factory _TechnicianSeasonSnapshot.fromJson(Map<String, dynamic> json) => _$TechnicianSeasonSnapshotFromJson(json);

@override final  String seasonId;
@override final  String seasonName;
@override final  String pondName;
@override final  String farmName;
@override@JsonKey(unknownEnumValue: BiomassSnapshotState.unknown) final  BiomassSnapshotState biomassState;
@override final  int? cultureDay;
@override final  double? biomassKg;
@override final  DateTime? biomassRecordedAt;

/// Create a copy of TechnicianSeasonSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianSeasonSnapshotCopyWith<_TechnicianSeasonSnapshot> get copyWith => __$TechnicianSeasonSnapshotCopyWithImpl<_TechnicianSeasonSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianSeasonSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianSeasonSnapshot&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.biomassState, biomassState) || other.biomassState == biomassState)&&(identical(other.cultureDay, cultureDay) || other.cultureDay == cultureDay)&&(identical(other.biomassKg, biomassKg) || other.biomassKg == biomassKg)&&(identical(other.biomassRecordedAt, biomassRecordedAt) || other.biomassRecordedAt == biomassRecordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondName,farmName,biomassState,cultureDay,biomassKg,biomassRecordedAt);

@override
String toString() {
  return 'TechnicianSeasonSnapshot(seasonId: $seasonId, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, biomassState: $biomassState, cultureDay: $cultureDay, biomassKg: $biomassKg, biomassRecordedAt: $biomassRecordedAt)';
}


}

/// @nodoc
abstract mixin class _$TechnicianSeasonSnapshotCopyWith<$Res> implements $TechnicianSeasonSnapshotCopyWith<$Res> {
  factory _$TechnicianSeasonSnapshotCopyWith(_TechnicianSeasonSnapshot value, $Res Function(_TechnicianSeasonSnapshot) _then) = __$TechnicianSeasonSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String seasonId, String seasonName, String pondName, String farmName,@JsonKey(unknownEnumValue: BiomassSnapshotState.unknown) BiomassSnapshotState biomassState, int? cultureDay, double? biomassKg, DateTime? biomassRecordedAt
});




}
/// @nodoc
class __$TechnicianSeasonSnapshotCopyWithImpl<$Res>
    implements _$TechnicianSeasonSnapshotCopyWith<$Res> {
  __$TechnicianSeasonSnapshotCopyWithImpl(this._self, this._then);

  final _TechnicianSeasonSnapshot _self;
  final $Res Function(_TechnicianSeasonSnapshot) _then;

/// Create a copy of TechnicianSeasonSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? biomassState = null,Object? cultureDay = freezed,Object? biomassKg = freezed,Object? biomassRecordedAt = freezed,}) {
  return _then(_TechnicianSeasonSnapshot(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,biomassState: null == biomassState ? _self.biomassState : biomassState // ignore: cast_nullable_to_non_nullable
as BiomassSnapshotState,cultureDay: freezed == cultureDay ? _self.cultureDay : cultureDay // ignore: cast_nullable_to_non_nullable
as int?,biomassKg: freezed == biomassKg ? _self.biomassKg : biomassKg // ignore: cast_nullable_to_non_nullable
as double?,biomassRecordedAt: freezed == biomassRecordedAt ? _self.biomassRecordedAt : biomassRecordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TechnicianDashboard {

 String get date; DateTime get serverNow; DateTime get dayEndExclusive; TechnicianSummary get summary; List<TechnicianAlert> get alerts; List<TaskItem> get tasks; List<TechnicianOperationGroup> get operationGroups; List<TechnicianSeasonSnapshot> get seasons;
/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianDashboardCopyWith<TechnicianDashboard> get copyWith => _$TechnicianDashboardCopyWithImpl<TechnicianDashboard>(this as TechnicianDashboard, _$identity);

  /// Serializes this TechnicianDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow)&&(identical(other.dayEndExclusive, dayEndExclusive) || other.dayEndExclusive == dayEndExclusive)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&const DeepCollectionEquality().equals(other.operationGroups, operationGroups)&&const DeepCollectionEquality().equals(other.seasons, seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,serverNow,dayEndExclusive,summary,const DeepCollectionEquality().hash(alerts),const DeepCollectionEquality().hash(tasks),const DeepCollectionEquality().hash(operationGroups),const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'TechnicianDashboard(date: $date, serverNow: $serverNow, dayEndExclusive: $dayEndExclusive, summary: $summary, alerts: $alerts, tasks: $tasks, operationGroups: $operationGroups, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $TechnicianDashboardCopyWith<$Res>  {
  factory $TechnicianDashboardCopyWith(TechnicianDashboard value, $Res Function(TechnicianDashboard) _then) = _$TechnicianDashboardCopyWithImpl;
@useResult
$Res call({
 String date, DateTime serverNow, DateTime dayEndExclusive, TechnicianSummary summary, List<TechnicianAlert> alerts, List<TaskItem> tasks, List<TechnicianOperationGroup> operationGroups, List<TechnicianSeasonSnapshot> seasons
});


$TechnicianSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$TechnicianDashboardCopyWithImpl<$Res>
    implements $TechnicianDashboardCopyWith<$Res> {
  _$TechnicianDashboardCopyWithImpl(this._self, this._then);

  final TechnicianDashboard _self;
  final $Res Function(TechnicianDashboard) _then;

/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? serverNow = null,Object? dayEndExclusive = null,Object? summary = null,Object? alerts = null,Object? tasks = null,Object? operationGroups = null,Object? seasons = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,dayEndExclusive: null == dayEndExclusive ? _self.dayEndExclusive : dayEndExclusive // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TechnicianSummary,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<TechnicianAlert>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,operationGroups: null == operationGroups ? _self.operationGroups : operationGroups // ignore: cast_nullable_to_non_nullable
as List<TechnicianOperationGroup>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TechnicianSeasonSnapshot>,
  ));
}
/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TechnicianSummaryCopyWith<$Res> get summary {
  
  return $TechnicianSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [TechnicianDashboard].
extension TechnicianDashboardPatterns on TechnicianDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianDashboard value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  DateTime serverNow,  DateTime dayEndExclusive,  TechnicianSummary summary,  List<TechnicianAlert> alerts,  List<TaskItem> tasks,  List<TechnicianOperationGroup> operationGroups,  List<TechnicianSeasonSnapshot> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianDashboard() when $default != null:
return $default(_that.date,_that.serverNow,_that.dayEndExclusive,_that.summary,_that.alerts,_that.tasks,_that.operationGroups,_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  DateTime serverNow,  DateTime dayEndExclusive,  TechnicianSummary summary,  List<TechnicianAlert> alerts,  List<TaskItem> tasks,  List<TechnicianOperationGroup> operationGroups,  List<TechnicianSeasonSnapshot> seasons)  $default,) {final _that = this;
switch (_that) {
case _TechnicianDashboard():
return $default(_that.date,_that.serverNow,_that.dayEndExclusive,_that.summary,_that.alerts,_that.tasks,_that.operationGroups,_that.seasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  DateTime serverNow,  DateTime dayEndExclusive,  TechnicianSummary summary,  List<TechnicianAlert> alerts,  List<TaskItem> tasks,  List<TechnicianOperationGroup> operationGroups,  List<TechnicianSeasonSnapshot> seasons)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianDashboard() when $default != null:
return $default(_that.date,_that.serverNow,_that.dayEndExclusive,_that.summary,_that.alerts,_that.tasks,_that.operationGroups,_that.seasons);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _TechnicianDashboard implements TechnicianDashboard {
  const _TechnicianDashboard({required this.date, required this.serverNow, required this.dayEndExclusive, required this.summary, required final  List<TechnicianAlert> alerts, required final  List<TaskItem> tasks, required final  List<TechnicianOperationGroup> operationGroups, required final  List<TechnicianSeasonSnapshot> seasons}): _alerts = alerts,_tasks = tasks,_operationGroups = operationGroups,_seasons = seasons;
  factory _TechnicianDashboard.fromJson(Map<String, dynamic> json) => _$TechnicianDashboardFromJson(json);

@override final  String date;
@override final  DateTime serverNow;
@override final  DateTime dayEndExclusive;
@override final  TechnicianSummary summary;
 final  List<TechnicianAlert> _alerts;
@override List<TechnicianAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

 final  List<TaskItem> _tasks;
@override List<TaskItem> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

 final  List<TechnicianOperationGroup> _operationGroups;
@override List<TechnicianOperationGroup> get operationGroups {
  if (_operationGroups is EqualUnmodifiableListView) return _operationGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_operationGroups);
}

 final  List<TechnicianSeasonSnapshot> _seasons;
@override List<TechnicianSeasonSnapshot> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianDashboardCopyWith<_TechnicianDashboard> get copyWith => __$TechnicianDashboardCopyWithImpl<_TechnicianDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow)&&(identical(other.dayEndExclusive, dayEndExclusive) || other.dayEndExclusive == dayEndExclusive)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&const DeepCollectionEquality().equals(other._operationGroups, _operationGroups)&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,serverNow,dayEndExclusive,summary,const DeepCollectionEquality().hash(_alerts),const DeepCollectionEquality().hash(_tasks),const DeepCollectionEquality().hash(_operationGroups),const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'TechnicianDashboard(date: $date, serverNow: $serverNow, dayEndExclusive: $dayEndExclusive, summary: $summary, alerts: $alerts, tasks: $tasks, operationGroups: $operationGroups, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$TechnicianDashboardCopyWith<$Res> implements $TechnicianDashboardCopyWith<$Res> {
  factory _$TechnicianDashboardCopyWith(_TechnicianDashboard value, $Res Function(_TechnicianDashboard) _then) = __$TechnicianDashboardCopyWithImpl;
@override @useResult
$Res call({
 String date, DateTime serverNow, DateTime dayEndExclusive, TechnicianSummary summary, List<TechnicianAlert> alerts, List<TaskItem> tasks, List<TechnicianOperationGroup> operationGroups, List<TechnicianSeasonSnapshot> seasons
});


@override $TechnicianSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$TechnicianDashboardCopyWithImpl<$Res>
    implements _$TechnicianDashboardCopyWith<$Res> {
  __$TechnicianDashboardCopyWithImpl(this._self, this._then);

  final _TechnicianDashboard _self;
  final $Res Function(_TechnicianDashboard) _then;

/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? serverNow = null,Object? dayEndExclusive = null,Object? summary = null,Object? alerts = null,Object? tasks = null,Object? operationGroups = null,Object? seasons = null,}) {
  return _then(_TechnicianDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,dayEndExclusive: null == dayEndExclusive ? _self.dayEndExclusive : dayEndExclusive // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TechnicianSummary,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<TechnicianAlert>,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,operationGroups: null == operationGroups ? _self._operationGroups : operationGroups // ignore: cast_nullable_to_non_nullable
as List<TechnicianOperationGroup>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TechnicianSeasonSnapshot>,
  ));
}

/// Create a copy of TechnicianDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TechnicianSummaryCopyWith<$Res> get summary {
  
  return $TechnicianSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
