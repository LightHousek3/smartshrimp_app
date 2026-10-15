// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinanceFilter {

 String? get farmId; FinancePeriod get period; DateTime? get from; DateTime? get to;
/// Create a copy of FinanceFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceFilterCopyWith<FinanceFilter> get copyWith => _$FinanceFilterCopyWithImpl<FinanceFilter>(this as FinanceFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceFilter&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.period, period) || other.period == period)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,farmId,period,from,to);

@override
String toString() {
  return 'FinanceFilter(farmId: $farmId, period: $period, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $FinanceFilterCopyWith<$Res>  {
  factory $FinanceFilterCopyWith(FinanceFilter value, $Res Function(FinanceFilter) _then) = _$FinanceFilterCopyWithImpl;
@useResult
$Res call({
 String? farmId, FinancePeriod period, DateTime? from, DateTime? to
});




}
/// @nodoc
class _$FinanceFilterCopyWithImpl<$Res>
    implements $FinanceFilterCopyWith<$Res> {
  _$FinanceFilterCopyWithImpl(this._self, this._then);

  final FinanceFilter _self;
  final $Res Function(FinanceFilter) _then;

/// Create a copy of FinanceFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? farmId = freezed,Object? period = null,Object? from = freezed,Object? to = freezed,}) {
  return _then(_self.copyWith(
farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as FinancePeriod,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceFilter].
extension FinanceFilterPatterns on FinanceFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceFilter value)  $default,){
final _that = this;
switch (_that) {
case _FinanceFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceFilter value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? farmId,  FinancePeriod period,  DateTime? from,  DateTime? to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceFilter() when $default != null:
return $default(_that.farmId,_that.period,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? farmId,  FinancePeriod period,  DateTime? from,  DateTime? to)  $default,) {final _that = this;
switch (_that) {
case _FinanceFilter():
return $default(_that.farmId,_that.period,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? farmId,  FinancePeriod period,  DateTime? from,  DateTime? to)?  $default,) {final _that = this;
switch (_that) {
case _FinanceFilter() when $default != null:
return $default(_that.farmId,_that.period,_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _FinanceFilter extends FinanceFilter {
  const _FinanceFilter({this.farmId, this.period = FinancePeriod.thisMonth, this.from, this.to}): super._();


@override final  String? farmId;
@override@JsonKey() final  FinancePeriod period;
@override final  DateTime? from;
@override final  DateTime? to;

/// Create a copy of FinanceFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceFilterCopyWith<_FinanceFilter> get copyWith => __$FinanceFilterCopyWithImpl<_FinanceFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceFilter&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.period, period) || other.period == period)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,farmId,period,from,to);

@override
String toString() {
  return 'FinanceFilter(farmId: $farmId, period: $period, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$FinanceFilterCopyWith<$Res> implements $FinanceFilterCopyWith<$Res> {
  factory _$FinanceFilterCopyWith(_FinanceFilter value, $Res Function(_FinanceFilter) _then) = __$FinanceFilterCopyWithImpl;
@override @useResult
$Res call({
 String? farmId, FinancePeriod period, DateTime? from, DateTime? to
});




}
/// @nodoc
class __$FinanceFilterCopyWithImpl<$Res>
    implements _$FinanceFilterCopyWith<$Res> {
  __$FinanceFilterCopyWithImpl(this._self, this._then);

  final _FinanceFilter _self;
  final $Res Function(_FinanceFilter) _then;

/// Create a copy of FinanceFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? farmId = freezed,Object? period = null,Object? from = freezed,Object? to = freezed,}) {
  return _then(_FinanceFilter(
farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as FinancePeriod,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DashboardSummary {

 int get farms; int get ponds; int get activeSeasons;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.farms, farms) || other.farms == farms)&&(identical(other.ponds, ponds) || other.ponds == ponds)&&(identical(other.activeSeasons, activeSeasons) || other.activeSeasons == activeSeasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,farms,ponds,activeSeasons);

@override
String toString() {
  return 'DashboardSummary(farms: $farms, ponds: $ponds, activeSeasons: $activeSeasons)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 int farms, int ponds, int activeSeasons
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? farms = null,Object? ponds = null,Object? activeSeasons = null,}) {
  return _then(_self.copyWith(
farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as int,ponds: null == ponds ? _self.ponds : ponds // ignore: cast_nullable_to_non_nullable
as int,activeSeasons: null == activeSeasons ? _self.activeSeasons : activeSeasons // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int farms,  int ponds,  int activeSeasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.farms,_that.ponds,_that.activeSeasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int farms,  int ponds,  int activeSeasons)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.farms,_that.ponds,_that.activeSeasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int farms,  int ponds,  int activeSeasons)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.farms,_that.ponds,_that.activeSeasons);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.farms, required this.ponds, required this.activeSeasons});
  factory _DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);

@override final  int farms;
@override final  int ponds;
@override final  int activeSeasons;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.farms, farms) || other.farms == farms)&&(identical(other.ponds, ponds) || other.ponds == ponds)&&(identical(other.activeSeasons, activeSeasons) || other.activeSeasons == activeSeasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,farms,ponds,activeSeasons);

@override
String toString() {
  return 'DashboardSummary(farms: $farms, ponds: $ponds, activeSeasons: $activeSeasons)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int farms, int ponds, int activeSeasons
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? farms = null,Object? ponds = null,Object? activeSeasons = null,}) {
  return _then(_DashboardSummary(
farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as int,ponds: null == ponds ? _self.ponds : ponds // ignore: cast_nullable_to_non_nullable
as int,activeSeasons: null == activeSeasons ? _self.activeSeasons : activeSeasons // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardAlertPreview {

 String get id; String get title; String get farmId; String get farmName; String? get pondId; String? get pondName; String? get seasonId; String? get seasonName; double? get quantity; double? get minAlertQuantity; String? get unit;
/// Create a copy of DashboardAlertPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAlertPreviewCopyWith<DashboardAlertPreview> get copyWith => _$DashboardAlertPreviewCopyWithImpl<DashboardAlertPreview>(this as DashboardAlertPreview, _$identity);

  /// Serializes this DashboardAlertPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAlertPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.minAlertQuantity, minAlertQuantity) || other.minAlertQuantity == minAlertQuantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,farmId,farmName,pondId,pondName,seasonId,seasonName,quantity,minAlertQuantity,unit);

@override
String toString() {
  return 'DashboardAlertPreview(id: $id, title: $title, farmId: $farmId, farmName: $farmName, pondId: $pondId, pondName: $pondName, seasonId: $seasonId, seasonName: $seasonName, quantity: $quantity, minAlertQuantity: $minAlertQuantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $DashboardAlertPreviewCopyWith<$Res>  {
  factory $DashboardAlertPreviewCopyWith(DashboardAlertPreview value, $Res Function(DashboardAlertPreview) _then) = _$DashboardAlertPreviewCopyWithImpl;
@useResult
$Res call({
 String id, String title, String farmId, String farmName, String? pondId, String? pondName, String? seasonId, String? seasonName, double? quantity, double? minAlertQuantity, String? unit
});




}
/// @nodoc
class _$DashboardAlertPreviewCopyWithImpl<$Res>
    implements $DashboardAlertPreviewCopyWith<$Res> {
  _$DashboardAlertPreviewCopyWithImpl(this._self, this._then);

  final DashboardAlertPreview _self;
  final $Res Function(DashboardAlertPreview) _then;

/// Create a copy of DashboardAlertPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? farmId = null,Object? farmName = null,Object? pondId = freezed,Object? pondName = freezed,Object? seasonId = freezed,Object? seasonName = freezed,Object? quantity = freezed,Object? minAlertQuantity = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,pondId: freezed == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String?,pondName: freezed == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,seasonName: freezed == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,minAlertQuantity: freezed == minAlertQuantity ? _self.minAlertQuantity : minAlertQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardAlertPreview].
extension DashboardAlertPreviewPatterns on DashboardAlertPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAlertPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAlertPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAlertPreview value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAlertPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAlertPreview value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAlertPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String farmId,  String farmName,  String? pondId,  String? pondName,  String? seasonId,  String? seasonName,  double? quantity,  double? minAlertQuantity,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAlertPreview() when $default != null:
return $default(_that.id,_that.title,_that.farmId,_that.farmName,_that.pondId,_that.pondName,_that.seasonId,_that.seasonName,_that.quantity,_that.minAlertQuantity,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String farmId,  String farmName,  String? pondId,  String? pondName,  String? seasonId,  String? seasonName,  double? quantity,  double? minAlertQuantity,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _DashboardAlertPreview():
return $default(_that.id,_that.title,_that.farmId,_that.farmName,_that.pondId,_that.pondName,_that.seasonId,_that.seasonName,_that.quantity,_that.minAlertQuantity,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String farmId,  String farmName,  String? pondId,  String? pondName,  String? seasonId,  String? seasonName,  double? quantity,  double? minAlertQuantity,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAlertPreview() when $default != null:
return $default(_that.id,_that.title,_that.farmId,_that.farmName,_that.pondId,_that.pondName,_that.seasonId,_that.seasonName,_that.quantity,_that.minAlertQuantity,_that.unit);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardAlertPreview implements DashboardAlertPreview {
  const _DashboardAlertPreview({required this.id, required this.title, required this.farmId, required this.farmName, this.pondId, this.pondName, this.seasonId, this.seasonName, this.quantity, this.minAlertQuantity, this.unit});
  factory _DashboardAlertPreview.fromJson(Map<String, dynamic> json) => _$DashboardAlertPreviewFromJson(json);

@override final  String id;
@override final  String title;
@override final  String farmId;
@override final  String farmName;
@override final  String? pondId;
@override final  String? pondName;
@override final  String? seasonId;
@override final  String? seasonName;
@override final  double? quantity;
@override final  double? minAlertQuantity;
@override final  String? unit;

/// Create a copy of DashboardAlertPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAlertPreviewCopyWith<_DashboardAlertPreview> get copyWith => __$DashboardAlertPreviewCopyWithImpl<_DashboardAlertPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardAlertPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAlertPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.minAlertQuantity, minAlertQuantity) || other.minAlertQuantity == minAlertQuantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,farmId,farmName,pondId,pondName,seasonId,seasonName,quantity,minAlertQuantity,unit);

@override
String toString() {
  return 'DashboardAlertPreview(id: $id, title: $title, farmId: $farmId, farmName: $farmName, pondId: $pondId, pondName: $pondName, seasonId: $seasonId, seasonName: $seasonName, quantity: $quantity, minAlertQuantity: $minAlertQuantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$DashboardAlertPreviewCopyWith<$Res> implements $DashboardAlertPreviewCopyWith<$Res> {
  factory _$DashboardAlertPreviewCopyWith(_DashboardAlertPreview value, $Res Function(_DashboardAlertPreview) _then) = __$DashboardAlertPreviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String farmId, String farmName, String? pondId, String? pondName, String? seasonId, String? seasonName, double? quantity, double? minAlertQuantity, String? unit
});




}
/// @nodoc
class __$DashboardAlertPreviewCopyWithImpl<$Res>
    implements _$DashboardAlertPreviewCopyWith<$Res> {
  __$DashboardAlertPreviewCopyWithImpl(this._self, this._then);

  final _DashboardAlertPreview _self;
  final $Res Function(_DashboardAlertPreview) _then;

/// Create a copy of DashboardAlertPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? farmId = null,Object? farmName = null,Object? pondId = freezed,Object? pondName = freezed,Object? seasonId = freezed,Object? seasonName = freezed,Object? quantity = freezed,Object? minAlertQuantity = freezed,Object? unit = freezed,}) {
  return _then(_DashboardAlertPreview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,pondId: freezed == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String?,pondName: freezed == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,seasonName: freezed == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,minAlertQuantity: freezed == minAlertQuantity ? _self.minAlertQuantity : minAlertQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DashboardAlert {

@JsonKey(unknownEnumValue: DashboardAlertKind.unknown) DashboardAlertKind get kind; int get count; DashboardAlertPreview get preview;
/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAlertCopyWith<DashboardAlert> get copyWith => _$DashboardAlertCopyWithImpl<DashboardAlert>(this as DashboardAlert, _$identity);

  /// Serializes this DashboardAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAlert&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.count, count) || other.count == count)&&(identical(other.preview, preview) || other.preview == preview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,count,preview);

@override
String toString() {
  return 'DashboardAlert(kind: $kind, count: $count, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $DashboardAlertCopyWith<$Res>  {
  factory $DashboardAlertCopyWith(DashboardAlert value, $Res Function(DashboardAlert) _then) = _$DashboardAlertCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: DashboardAlertKind.unknown) DashboardAlertKind kind, int count, DashboardAlertPreview preview
});


$DashboardAlertPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class _$DashboardAlertCopyWithImpl<$Res>
    implements $DashboardAlertCopyWith<$Res> {
  _$DashboardAlertCopyWithImpl(this._self, this._then);

  final DashboardAlert _self;
  final $Res Function(DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? count = null,Object? preview = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DashboardAlertKind,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as DashboardAlertPreview,
  ));
}
/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardAlertPreviewCopyWith<$Res> get preview {

  return $DashboardAlertPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardAlert].
extension DashboardAlertPatterns on DashboardAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAlert value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAlert value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: DashboardAlertKind.unknown)  DashboardAlertKind kind,  int count,  DashboardAlertPreview preview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.kind,_that.count,_that.preview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: DashboardAlertKind.unknown)  DashboardAlertKind kind,  int count,  DashboardAlertPreview preview)  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert():
return $default(_that.kind,_that.count,_that.preview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: DashboardAlertKind.unknown)  DashboardAlertKind kind,  int count,  DashboardAlertPreview preview)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.kind,_that.count,_that.preview);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardAlert implements DashboardAlert {
  const _DashboardAlert({@JsonKey(unknownEnumValue: DashboardAlertKind.unknown) required this.kind, required this.count, required this.preview});
  factory _DashboardAlert.fromJson(Map<String, dynamic> json) => _$DashboardAlertFromJson(json);

@override@JsonKey(unknownEnumValue: DashboardAlertKind.unknown) final  DashboardAlertKind kind;
@override final  int count;
@override final  DashboardAlertPreview preview;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAlertCopyWith<_DashboardAlert> get copyWith => __$DashboardAlertCopyWithImpl<_DashboardAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAlert&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.count, count) || other.count == count)&&(identical(other.preview, preview) || other.preview == preview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,count,preview);

@override
String toString() {
  return 'DashboardAlert(kind: $kind, count: $count, preview: $preview)';
}


}

/// @nodoc
abstract mixin class _$DashboardAlertCopyWith<$Res> implements $DashboardAlertCopyWith<$Res> {
  factory _$DashboardAlertCopyWith(_DashboardAlert value, $Res Function(_DashboardAlert) _then) = __$DashboardAlertCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: DashboardAlertKind.unknown) DashboardAlertKind kind, int count, DashboardAlertPreview preview
});


@override $DashboardAlertPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class __$DashboardAlertCopyWithImpl<$Res>
    implements _$DashboardAlertCopyWith<$Res> {
  __$DashboardAlertCopyWithImpl(this._self, this._then);

  final _DashboardAlert _self;
  final $Res Function(_DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? count = null,Object? preview = null,}) {
  return _then(_DashboardAlert(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DashboardAlertKind,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as DashboardAlertPreview,
  ));
}

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardAlertPreviewCopyWith<$Res> get preview {

  return $DashboardAlertPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// @nodoc
mixin _$DashboardSeason {

 String get seasonId; String get seasonName; String get pondId; String get pondName; String get farmId; String get farmName; String get shrimpType; int? get dayOfCulture;
/// Create a copy of DashboardSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSeasonCopyWith<DashboardSeason> get copyWith => _$DashboardSeasonCopyWithImpl<DashboardSeason>(this as DashboardSeason, _$identity);

  /// Serializes this DashboardSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSeason&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondId,pondName,farmId,farmName,shrimpType,dayOfCulture);

@override
String toString() {
  return 'DashboardSeason(seasonId: $seasonId, seasonName: $seasonName, pondId: $pondId, pondName: $pondName, farmId: $farmId, farmName: $farmName, shrimpType: $shrimpType, dayOfCulture: $dayOfCulture)';
}


}

/// @nodoc
abstract mixin class $DashboardSeasonCopyWith<$Res>  {
  factory $DashboardSeasonCopyWith(DashboardSeason value, $Res Function(DashboardSeason) _then) = _$DashboardSeasonCopyWithImpl;
@useResult
$Res call({
 String seasonId, String seasonName, String pondId, String pondName, String farmId, String farmName, String shrimpType, int? dayOfCulture
});




}
/// @nodoc
class _$DashboardSeasonCopyWithImpl<$Res>
    implements $DashboardSeasonCopyWith<$Res> {
  _$DashboardSeasonCopyWithImpl(this._self, this._then);

  final DashboardSeason _self;
  final $Res Function(DashboardSeason) _then;

/// Create a copy of DashboardSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondId = null,Object? pondName = null,Object? farmId = null,Object? farmName = null,Object? shrimpType = null,Object? dayOfCulture = freezed,}) {
  return _then(_self.copyWith(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSeason].
extension DashboardSeasonPatterns on DashboardSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSeason value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSeason value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondId,  String pondName,  String farmId,  String farmName,  String shrimpType,  int? dayOfCulture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSeason() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.shrimpType,_that.dayOfCulture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String seasonId,  String seasonName,  String pondId,  String pondName,  String farmId,  String farmName,  String shrimpType,  int? dayOfCulture)  $default,) {final _that = this;
switch (_that) {
case _DashboardSeason():
return $default(_that.seasonId,_that.seasonName,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.shrimpType,_that.dayOfCulture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String seasonId,  String seasonName,  String pondId,  String pondName,  String farmId,  String farmName,  String shrimpType,  int? dayOfCulture)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSeason() when $default != null:
return $default(_that.seasonId,_that.seasonName,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.shrimpType,_that.dayOfCulture);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardSeason implements DashboardSeason {
  const _DashboardSeason({required this.seasonId, required this.seasonName, required this.pondId, required this.pondName, required this.farmId, required this.farmName, required this.shrimpType, this.dayOfCulture});
  factory _DashboardSeason.fromJson(Map<String, dynamic> json) => _$DashboardSeasonFromJson(json);

@override final  String seasonId;
@override final  String seasonName;
@override final  String pondId;
@override final  String pondName;
@override final  String farmId;
@override final  String farmName;
@override final  String shrimpType;
@override final  int? dayOfCulture;

/// Create a copy of DashboardSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSeasonCopyWith<_DashboardSeason> get copyWith => __$DashboardSeasonCopyWithImpl<_DashboardSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSeason&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonId,seasonName,pondId,pondName,farmId,farmName,shrimpType,dayOfCulture);

@override
String toString() {
  return 'DashboardSeason(seasonId: $seasonId, seasonName: $seasonName, pondId: $pondId, pondName: $pondName, farmId: $farmId, farmName: $farmName, shrimpType: $shrimpType, dayOfCulture: $dayOfCulture)';
}


}

/// @nodoc
abstract mixin class _$DashboardSeasonCopyWith<$Res> implements $DashboardSeasonCopyWith<$Res> {
  factory _$DashboardSeasonCopyWith(_DashboardSeason value, $Res Function(_DashboardSeason) _then) = __$DashboardSeasonCopyWithImpl;
@override @useResult
$Res call({
 String seasonId, String seasonName, String pondId, String pondName, String farmId, String farmName, String shrimpType, int? dayOfCulture
});




}
/// @nodoc
class __$DashboardSeasonCopyWithImpl<$Res>
    implements _$DashboardSeasonCopyWith<$Res> {
  __$DashboardSeasonCopyWithImpl(this._self, this._then);

  final _DashboardSeason _self;
  final $Res Function(_DashboardSeason) _then;

/// Create a copy of DashboardSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonId = null,Object? seasonName = null,Object? pondId = null,Object? pondName = null,Object? farmId = null,Object? farmName = null,Object? shrimpType = null,Object? dayOfCulture = freezed,}) {
  return _then(_DashboardSeason(
seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DashboardFarm {

 String get id; String get name;
/// Create a copy of DashboardFarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardFarmCopyWith<DashboardFarm> get copyWith => _$DashboardFarmCopyWithImpl<DashboardFarm>(this as DashboardFarm, _$identity);

  /// Serializes this DashboardFarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'DashboardFarm(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $DashboardFarmCopyWith<$Res>  {
  factory $DashboardFarmCopyWith(DashboardFarm value, $Res Function(DashboardFarm) _then) = _$DashboardFarmCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$DashboardFarmCopyWithImpl<$Res>
    implements $DashboardFarmCopyWith<$Res> {
  _$DashboardFarmCopyWithImpl(this._self, this._then);

  final DashboardFarm _self;
  final $Res Function(DashboardFarm) _then;

/// Create a copy of DashboardFarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardFarm].
extension DashboardFarmPatterns on DashboardFarm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardFarm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardFarm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardFarm value)  $default,){
final _that = this;
switch (_that) {
case _DashboardFarm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardFarm value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardFarm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardFarm() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _DashboardFarm():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _DashboardFarm() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardFarm implements DashboardFarm {
  const _DashboardFarm({required this.id, required this.name});
  factory _DashboardFarm.fromJson(Map<String, dynamic> json) => _$DashboardFarmFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of DashboardFarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardFarmCopyWith<_DashboardFarm> get copyWith => __$DashboardFarmCopyWithImpl<_DashboardFarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardFarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'DashboardFarm(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$DashboardFarmCopyWith<$Res> implements $DashboardFarmCopyWith<$Res> {
  factory _$DashboardFarmCopyWith(_DashboardFarm value, $Res Function(_DashboardFarm) _then) = __$DashboardFarmCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$DashboardFarmCopyWithImpl<$Res>
    implements _$DashboardFarmCopyWith<$Res> {
  __$DashboardFarmCopyWithImpl(this._self, this._then);

  final _DashboardFarm _self;
  final $Res Function(_DashboardFarm) _then;

/// Create a copy of DashboardFarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_DashboardFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardInventory {

 String get farmId; String get farmName; int get productCount; int get lowStockCount; double get stockValue;
/// Create a copy of DashboardInventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardInventoryCopyWith<DashboardInventory> get copyWith => _$DashboardInventoryCopyWithImpl<DashboardInventory>(this as DashboardInventory, _$identity);

  /// Serializes this DashboardInventory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardInventory&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&(identical(other.stockValue, stockValue) || other.stockValue == stockValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,farmId,farmName,productCount,lowStockCount,stockValue);

@override
String toString() {
  return 'DashboardInventory(farmId: $farmId, farmName: $farmName, productCount: $productCount, lowStockCount: $lowStockCount, stockValue: $stockValue)';
}


}

/// @nodoc
abstract mixin class $DashboardInventoryCopyWith<$Res>  {
  factory $DashboardInventoryCopyWith(DashboardInventory value, $Res Function(DashboardInventory) _then) = _$DashboardInventoryCopyWithImpl;
@useResult
$Res call({
 String farmId, String farmName, int productCount, int lowStockCount, double stockValue
});




}
/// @nodoc
class _$DashboardInventoryCopyWithImpl<$Res>
    implements $DashboardInventoryCopyWith<$Res> {
  _$DashboardInventoryCopyWithImpl(this._self, this._then);

  final DashboardInventory _self;
  final $Res Function(DashboardInventory) _then;

/// Create a copy of DashboardInventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? farmId = null,Object? farmName = null,Object? productCount = null,Object? lowStockCount = null,Object? stockValue = null,}) {
  return _then(_self.copyWith(
farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,stockValue: null == stockValue ? _self.stockValue : stockValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardInventory].
extension DashboardInventoryPatterns on DashboardInventory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardInventory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardInventory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardInventory value)  $default,){
final _that = this;
switch (_that) {
case _DashboardInventory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardInventory value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardInventory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String farmId,  String farmName,  int productCount,  int lowStockCount,  double stockValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardInventory() when $default != null:
return $default(_that.farmId,_that.farmName,_that.productCount,_that.lowStockCount,_that.stockValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String farmId,  String farmName,  int productCount,  int lowStockCount,  double stockValue)  $default,) {final _that = this;
switch (_that) {
case _DashboardInventory():
return $default(_that.farmId,_that.farmName,_that.productCount,_that.lowStockCount,_that.stockValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String farmId,  String farmName,  int productCount,  int lowStockCount,  double stockValue)?  $default,) {final _that = this;
switch (_that) {
case _DashboardInventory() when $default != null:
return $default(_that.farmId,_that.farmName,_that.productCount,_that.lowStockCount,_that.stockValue);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardInventory implements DashboardInventory {
  const _DashboardInventory({required this.farmId, required this.farmName, required this.productCount, required this.lowStockCount, required this.stockValue});
  factory _DashboardInventory.fromJson(Map<String, dynamic> json) => _$DashboardInventoryFromJson(json);

@override final  String farmId;
@override final  String farmName;
@override final  int productCount;
@override final  int lowStockCount;
@override final  double stockValue;

/// Create a copy of DashboardInventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardInventoryCopyWith<_DashboardInventory> get copyWith => __$DashboardInventoryCopyWithImpl<_DashboardInventory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardInventoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardInventory&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&(identical(other.stockValue, stockValue) || other.stockValue == stockValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,farmId,farmName,productCount,lowStockCount,stockValue);

@override
String toString() {
  return 'DashboardInventory(farmId: $farmId, farmName: $farmName, productCount: $productCount, lowStockCount: $lowStockCount, stockValue: $stockValue)';
}


}

/// @nodoc
abstract mixin class _$DashboardInventoryCopyWith<$Res> implements $DashboardInventoryCopyWith<$Res> {
  factory _$DashboardInventoryCopyWith(_DashboardInventory value, $Res Function(_DashboardInventory) _then) = __$DashboardInventoryCopyWithImpl;
@override @useResult
$Res call({
 String farmId, String farmName, int productCount, int lowStockCount, double stockValue
});




}
/// @nodoc
class __$DashboardInventoryCopyWithImpl<$Res>
    implements _$DashboardInventoryCopyWith<$Res> {
  __$DashboardInventoryCopyWithImpl(this._self, this._then);

  final _DashboardInventory _self;
  final $Res Function(_DashboardInventory) _then;

/// Create a copy of DashboardInventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? farmId = null,Object? farmName = null,Object? productCount = null,Object? lowStockCount = null,Object? stockValue = null,}) {
  return _then(_DashboardInventory(
farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,stockValue: null == stockValue ? _self.stockValue : stockValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardPersonnel {

 int get technicians; int get experts; int get active;
/// Create a copy of DashboardPersonnel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPersonnelCopyWith<DashboardPersonnel> get copyWith => _$DashboardPersonnelCopyWithImpl<DashboardPersonnel>(this as DashboardPersonnel, _$identity);

  /// Serializes this DashboardPersonnel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPersonnel&&(identical(other.technicians, technicians) || other.technicians == technicians)&&(identical(other.experts, experts) || other.experts == experts)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicians,experts,active);

@override
String toString() {
  return 'DashboardPersonnel(technicians: $technicians, experts: $experts, active: $active)';
}


}

/// @nodoc
abstract mixin class $DashboardPersonnelCopyWith<$Res>  {
  factory $DashboardPersonnelCopyWith(DashboardPersonnel value, $Res Function(DashboardPersonnel) _then) = _$DashboardPersonnelCopyWithImpl;
@useResult
$Res call({
 int technicians, int experts, int active
});




}
/// @nodoc
class _$DashboardPersonnelCopyWithImpl<$Res>
    implements $DashboardPersonnelCopyWith<$Res> {
  _$DashboardPersonnelCopyWithImpl(this._self, this._then);

  final DashboardPersonnel _self;
  final $Res Function(DashboardPersonnel) _then;

/// Create a copy of DashboardPersonnel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicians = null,Object? experts = null,Object? active = null,}) {
  return _then(_self.copyWith(
technicians: null == technicians ? _self.technicians : technicians // ignore: cast_nullable_to_non_nullable
as int,experts: null == experts ? _self.experts : experts // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPersonnel].
extension DashboardPersonnelPatterns on DashboardPersonnel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPersonnel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPersonnel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPersonnel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPersonnel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPersonnel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPersonnel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int technicians,  int experts,  int active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPersonnel() when $default != null:
return $default(_that.technicians,_that.experts,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int technicians,  int experts,  int active)  $default,) {final _that = this;
switch (_that) {
case _DashboardPersonnel():
return $default(_that.technicians,_that.experts,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int technicians,  int experts,  int active)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPersonnel() when $default != null:
return $default(_that.technicians,_that.experts,_that.active);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DashboardPersonnel implements DashboardPersonnel {
  const _DashboardPersonnel({required this.technicians, required this.experts, required this.active});
  factory _DashboardPersonnel.fromJson(Map<String, dynamic> json) => _$DashboardPersonnelFromJson(json);

@override final  int technicians;
@override final  int experts;
@override final  int active;

/// Create a copy of DashboardPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPersonnelCopyWith<_DashboardPersonnel> get copyWith => __$DashboardPersonnelCopyWithImpl<_DashboardPersonnel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPersonnelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPersonnel&&(identical(other.technicians, technicians) || other.technicians == technicians)&&(identical(other.experts, experts) || other.experts == experts)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicians,experts,active);

@override
String toString() {
  return 'DashboardPersonnel(technicians: $technicians, experts: $experts, active: $active)';
}


}

/// @nodoc
abstract mixin class _$DashboardPersonnelCopyWith<$Res> implements $DashboardPersonnelCopyWith<$Res> {
  factory _$DashboardPersonnelCopyWith(_DashboardPersonnel value, $Res Function(_DashboardPersonnel) _then) = __$DashboardPersonnelCopyWithImpl;
@override @useResult
$Res call({
 int technicians, int experts, int active
});




}
/// @nodoc
class __$DashboardPersonnelCopyWithImpl<$Res>
    implements _$DashboardPersonnelCopyWith<$Res> {
  __$DashboardPersonnelCopyWithImpl(this._self, this._then);

  final _DashboardPersonnel _self;
  final $Res Function(_DashboardPersonnel) _then;

/// Create a copy of DashboardPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicians = null,Object? experts = null,Object? active = null,}) {
  return _then(_DashboardPersonnel(
technicians: null == technicians ? _self.technicians : technicians // ignore: cast_nullable_to_non_nullable
as int,experts: null == experts ? _self.experts : experts // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OwnerDashboard {

 String get date; DashboardSummary get summary; List<DashboardAlert> get alerts; List<DashboardSeason> get seasons; List<DashboardInventory> get inventories; List<DashboardFarm> get financeFarms; DashboardPersonnel get personnel;
/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerDashboardCopyWith<OwnerDashboard> get copyWith => _$OwnerDashboardCopyWithImpl<OwnerDashboard>(this as OwnerDashboard, _$identity);

  /// Serializes this OwnerDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&const DeepCollectionEquality().equals(other.seasons, seasons)&&const DeepCollectionEquality().equals(other.inventories, inventories)&&const DeepCollectionEquality().equals(other.financeFarms, financeFarms)&&(identical(other.personnel, personnel) || other.personnel == personnel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,summary,const DeepCollectionEquality().hash(alerts),const DeepCollectionEquality().hash(seasons),const DeepCollectionEquality().hash(inventories),const DeepCollectionEquality().hash(financeFarms),personnel);

@override
String toString() {
  return 'OwnerDashboard(date: $date, summary: $summary, alerts: $alerts, seasons: $seasons, inventories: $inventories, financeFarms: $financeFarms, personnel: $personnel)';
}


}

/// @nodoc
abstract mixin class $OwnerDashboardCopyWith<$Res>  {
  factory $OwnerDashboardCopyWith(OwnerDashboard value, $Res Function(OwnerDashboard) _then) = _$OwnerDashboardCopyWithImpl;
@useResult
$Res call({
 String date, DashboardSummary summary, List<DashboardAlert> alerts, List<DashboardSeason> seasons, List<DashboardInventory> inventories, List<DashboardFarm> financeFarms, DashboardPersonnel personnel
});


$DashboardSummaryCopyWith<$Res> get summary;$DashboardPersonnelCopyWith<$Res> get personnel;

}
/// @nodoc
class _$OwnerDashboardCopyWithImpl<$Res>
    implements $OwnerDashboardCopyWith<$Res> {
  _$OwnerDashboardCopyWithImpl(this._self, this._then);

  final OwnerDashboard _self;
  final $Res Function(OwnerDashboard) _then;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? summary = null,Object? alerts = null,Object? seasons = null,Object? inventories = null,Object? financeFarms = null,Object? personnel = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<DashboardAlert>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<DashboardSeason>,inventories: null == inventories ? _self.inventories : inventories // ignore: cast_nullable_to_non_nullable
as List<DashboardInventory>,financeFarms: null == financeFarms ? _self.financeFarms : financeFarms // ignore: cast_nullable_to_non_nullable
as List<DashboardFarm>,personnel: null == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as DashboardPersonnel,
  ));
}
/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<$Res> get summary {

  return $DashboardSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPersonnelCopyWith<$Res> get personnel {

  return $DashboardPersonnelCopyWith<$Res>(_self.personnel, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerDashboard].
extension OwnerDashboardPatterns on OwnerDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerDashboard value)  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  DashboardSummary summary,  List<DashboardAlert> alerts,  List<DashboardSeason> seasons,  List<DashboardInventory> inventories,  List<DashboardFarm> financeFarms,  DashboardPersonnel personnel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
return $default(_that.date,_that.summary,_that.alerts,_that.seasons,_that.inventories,_that.financeFarms,_that.personnel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  DashboardSummary summary,  List<DashboardAlert> alerts,  List<DashboardSeason> seasons,  List<DashboardInventory> inventories,  List<DashboardFarm> financeFarms,  DashboardPersonnel personnel)  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboard():
return $default(_that.date,_that.summary,_that.alerts,_that.seasons,_that.inventories,_that.financeFarms,_that.personnel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  DashboardSummary summary,  List<DashboardAlert> alerts,  List<DashboardSeason> seasons,  List<DashboardInventory> inventories,  List<DashboardFarm> financeFarms,  DashboardPersonnel personnel)?  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
return $default(_that.date,_that.summary,_that.alerts,_that.seasons,_that.inventories,_that.financeFarms,_that.personnel);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _OwnerDashboard implements OwnerDashboard {
  const _OwnerDashboard({required this.date, required this.summary, required final  List<DashboardAlert> alerts, required final  List<DashboardSeason> seasons, required final  List<DashboardInventory> inventories, required final  List<DashboardFarm> financeFarms, required this.personnel}): _alerts = alerts,_seasons = seasons,_inventories = inventories,_financeFarms = financeFarms;
  factory _OwnerDashboard.fromJson(Map<String, dynamic> json) => _$OwnerDashboardFromJson(json);

@override final  String date;
@override final  DashboardSummary summary;
 final  List<DashboardAlert> _alerts;
@override List<DashboardAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

 final  List<DashboardSeason> _seasons;
@override List<DashboardSeason> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}

 final  List<DashboardInventory> _inventories;
@override List<DashboardInventory> get inventories {
  if (_inventories is EqualUnmodifiableListView) return _inventories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventories);
}

 final  List<DashboardFarm> _financeFarms;
@override List<DashboardFarm> get financeFarms {
  if (_financeFarms is EqualUnmodifiableListView) return _financeFarms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_financeFarms);
}

@override final  DashboardPersonnel personnel;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerDashboardCopyWith<_OwnerDashboard> get copyWith => __$OwnerDashboardCopyWithImpl<_OwnerDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&const DeepCollectionEquality().equals(other._seasons, _seasons)&&const DeepCollectionEquality().equals(other._inventories, _inventories)&&const DeepCollectionEquality().equals(other._financeFarms, _financeFarms)&&(identical(other.personnel, personnel) || other.personnel == personnel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,summary,const DeepCollectionEquality().hash(_alerts),const DeepCollectionEquality().hash(_seasons),const DeepCollectionEquality().hash(_inventories),const DeepCollectionEquality().hash(_financeFarms),personnel);

@override
String toString() {
  return 'OwnerDashboard(date: $date, summary: $summary, alerts: $alerts, seasons: $seasons, inventories: $inventories, financeFarms: $financeFarms, personnel: $personnel)';
}


}

/// @nodoc
abstract mixin class _$OwnerDashboardCopyWith<$Res> implements $OwnerDashboardCopyWith<$Res> {
  factory _$OwnerDashboardCopyWith(_OwnerDashboard value, $Res Function(_OwnerDashboard) _then) = __$OwnerDashboardCopyWithImpl;
@override @useResult
$Res call({
 String date, DashboardSummary summary, List<DashboardAlert> alerts, List<DashboardSeason> seasons, List<DashboardInventory> inventories, List<DashboardFarm> financeFarms, DashboardPersonnel personnel
});


@override $DashboardSummaryCopyWith<$Res> get summary;@override $DashboardPersonnelCopyWith<$Res> get personnel;

}
/// @nodoc
class __$OwnerDashboardCopyWithImpl<$Res>
    implements _$OwnerDashboardCopyWith<$Res> {
  __$OwnerDashboardCopyWithImpl(this._self, this._then);

  final _OwnerDashboard _self;
  final $Res Function(_OwnerDashboard) _then;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? summary = null,Object? alerts = null,Object? seasons = null,Object? inventories = null,Object? financeFarms = null,Object? personnel = null,}) {
  return _then(_OwnerDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<DashboardAlert>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<DashboardSeason>,inventories: null == inventories ? _self._inventories : inventories // ignore: cast_nullable_to_non_nullable
as List<DashboardInventory>,financeFarms: null == financeFarms ? _self._financeFarms : financeFarms // ignore: cast_nullable_to_non_nullable
as List<DashboardFarm>,personnel: null == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as DashboardPersonnel,
  ));
}

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<$Res> get summary {

  return $DashboardSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPersonnelCopyWith<$Res> get personnel {

  return $DashboardPersonnelCopyWith<$Res>(_self.personnel, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}
}


/// @nodoc
mixin _$FinanceMonth {

 String get month; double get income; double get cost;
/// Create a copy of FinanceMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceMonthCopyWith<FinanceMonth> get copyWith => _$FinanceMonthCopyWithImpl<FinanceMonth>(this as FinanceMonth, _$identity);

  /// Serializes this FinanceMonth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,income,cost);

@override
String toString() {
  return 'FinanceMonth(month: $month, income: $income, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $FinanceMonthCopyWith<$Res>  {
  factory $FinanceMonthCopyWith(FinanceMonth value, $Res Function(FinanceMonth) _then) = _$FinanceMonthCopyWithImpl;
@useResult
$Res call({
 String month, double income, double cost
});




}
/// @nodoc
class _$FinanceMonthCopyWithImpl<$Res>
    implements $FinanceMonthCopyWith<$Res> {
  _$FinanceMonthCopyWithImpl(this._self, this._then);

  final FinanceMonth _self;
  final $Res Function(FinanceMonth) _then;

/// Create a copy of FinanceMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? income = null,Object? cost = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceMonth].
extension FinanceMonthPatterns on FinanceMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceMonth value)  $default,){
final _that = this;
switch (_that) {
case _FinanceMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceMonth value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  double income,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceMonth() when $default != null:
return $default(_that.month,_that.income,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  double income,  double cost)  $default,) {final _that = this;
switch (_that) {
case _FinanceMonth():
return $default(_that.month,_that.income,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  double income,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _FinanceMonth() when $default != null:
return $default(_that.month,_that.income,_that.cost);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _FinanceMonth implements FinanceMonth {
  const _FinanceMonth({required this.month, required this.income, required this.cost});
  factory _FinanceMonth.fromJson(Map<String, dynamic> json) => _$FinanceMonthFromJson(json);

@override final  String month;
@override final  double income;
@override final  double cost;

/// Create a copy of FinanceMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceMonthCopyWith<_FinanceMonth> get copyWith => __$FinanceMonthCopyWithImpl<_FinanceMonth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceMonthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,income,cost);

@override
String toString() {
  return 'FinanceMonth(month: $month, income: $income, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$FinanceMonthCopyWith<$Res> implements $FinanceMonthCopyWith<$Res> {
  factory _$FinanceMonthCopyWith(_FinanceMonth value, $Res Function(_FinanceMonth) _then) = __$FinanceMonthCopyWithImpl;
@override @useResult
$Res call({
 String month, double income, double cost
});




}
/// @nodoc
class __$FinanceMonthCopyWithImpl<$Res>
    implements _$FinanceMonthCopyWith<$Res> {
  __$FinanceMonthCopyWithImpl(this._self, this._then);

  final _FinanceMonth _self;
  final $Res Function(_FinanceMonth) _then;

/// Create a copy of FinanceMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? income = null,Object? cost = null,}) {
  return _then(_FinanceMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$FinanceTotals {

 double get income; double get cost; double get profit;
/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<FinanceTotals> get copyWith => _$FinanceTotalsCopyWithImpl<FinanceTotals>(this as FinanceTotals, _$identity);

  /// Serializes this FinanceTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceTotals&&(identical(other.income, income) || other.income == income)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,cost,profit);

@override
String toString() {
  return 'FinanceTotals(income: $income, cost: $cost, profit: $profit)';
}


}

/// @nodoc
abstract mixin class $FinanceTotalsCopyWith<$Res>  {
  factory $FinanceTotalsCopyWith(FinanceTotals value, $Res Function(FinanceTotals) _then) = _$FinanceTotalsCopyWithImpl;
@useResult
$Res call({
 double income, double cost, double profit
});




}
/// @nodoc
class _$FinanceTotalsCopyWithImpl<$Res>
    implements $FinanceTotalsCopyWith<$Res> {
  _$FinanceTotalsCopyWithImpl(this._self, this._then);

  final FinanceTotals _self;
  final $Res Function(FinanceTotals) _then;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? cost = null,Object? profit = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceTotals].
extension FinanceTotalsPatterns on FinanceTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceTotals value)  $default,){
final _that = this;
switch (_that) {
case _FinanceTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceTotals value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double income,  double cost,  double profit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
return $default(_that.income,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double income,  double cost,  double profit)  $default,) {final _that = this;
switch (_that) {
case _FinanceTotals():
return $default(_that.income,_that.cost,_that.profit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double income,  double cost,  double profit)?  $default,) {final _that = this;
switch (_that) {
case _FinanceTotals() when $default != null:
return $default(_that.income,_that.cost,_that.profit);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _FinanceTotals implements FinanceTotals {
  const _FinanceTotals({required this.income, required this.cost, required this.profit});
  factory _FinanceTotals.fromJson(Map<String, dynamic> json) => _$FinanceTotalsFromJson(json);

@override final  double income;
@override final  double cost;
@override final  double profit;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceTotalsCopyWith<_FinanceTotals> get copyWith => __$FinanceTotalsCopyWithImpl<_FinanceTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceTotals&&(identical(other.income, income) || other.income == income)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,cost,profit);

@override
String toString() {
  return 'FinanceTotals(income: $income, cost: $cost, profit: $profit)';
}


}

/// @nodoc
abstract mixin class _$FinanceTotalsCopyWith<$Res> implements $FinanceTotalsCopyWith<$Res> {
  factory _$FinanceTotalsCopyWith(_FinanceTotals value, $Res Function(_FinanceTotals) _then) = __$FinanceTotalsCopyWithImpl;
@override @useResult
$Res call({
 double income, double cost, double profit
});




}
/// @nodoc
class __$FinanceTotalsCopyWithImpl<$Res>
    implements _$FinanceTotalsCopyWith<$Res> {
  __$FinanceTotalsCopyWithImpl(this._self, this._then);

  final _FinanceTotals _self;
  final $Res Function(_FinanceTotals) _then;

/// Create a copy of FinanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? cost = null,Object? profit = null,}) {
  return _then(_FinanceTotals(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OwnerFinance {

 String get from; String get to; List<FinanceMonth> get months; FinanceTotals get totals;
/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerFinanceCopyWith<OwnerFinance> get copyWith => _$OwnerFinanceCopyWithImpl<OwnerFinance>(this as OwnerFinance, _$identity);

  /// Serializes this OwnerFinance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerFinance&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other.months, months)&&(identical(other.totals, totals) || other.totals == totals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,const DeepCollectionEquality().hash(months),totals);

@override
String toString() {
  return 'OwnerFinance(from: $from, to: $to, months: $months, totals: $totals)';
}


}

/// @nodoc
abstract mixin class $OwnerFinanceCopyWith<$Res>  {
  factory $OwnerFinanceCopyWith(OwnerFinance value, $Res Function(OwnerFinance) _then) = _$OwnerFinanceCopyWithImpl;
@useResult
$Res call({
 String from, String to, List<FinanceMonth> months, FinanceTotals totals
});


$FinanceTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$OwnerFinanceCopyWithImpl<$Res>
    implements $OwnerFinanceCopyWith<$Res> {
  _$OwnerFinanceCopyWithImpl(this._self, this._then);

  final OwnerFinance _self;
  final $Res Function(OwnerFinance) _then;

/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? months = null,Object? totals = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<FinanceMonth>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as FinanceTotals,
  ));
}
/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res> get totals {

  return $FinanceTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerFinance].
extension OwnerFinancePatterns on OwnerFinance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerFinance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerFinance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerFinance value)  $default,){
final _that = this;
switch (_that) {
case _OwnerFinance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerFinance value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerFinance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  List<FinanceMonth> months,  FinanceTotals totals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerFinance() when $default != null:
return $default(_that.from,_that.to,_that.months,_that.totals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  List<FinanceMonth> months,  FinanceTotals totals)  $default,) {final _that = this;
switch (_that) {
case _OwnerFinance():
return $default(_that.from,_that.to,_that.months,_that.totals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  List<FinanceMonth> months,  FinanceTotals totals)?  $default,) {final _that = this;
switch (_that) {
case _OwnerFinance() when $default != null:
return $default(_that.from,_that.to,_that.months,_that.totals);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _OwnerFinance implements OwnerFinance {
  const _OwnerFinance({required this.from, required this.to, required final  List<FinanceMonth> months, required this.totals}): _months = months;
  factory _OwnerFinance.fromJson(Map<String, dynamic> json) => _$OwnerFinanceFromJson(json);

@override final  String from;
@override final  String to;
 final  List<FinanceMonth> _months;
@override List<FinanceMonth> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}

@override final  FinanceTotals totals;

/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerFinanceCopyWith<_OwnerFinance> get copyWith => __$OwnerFinanceCopyWithImpl<_OwnerFinance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerFinanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerFinance&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other._months, _months)&&(identical(other.totals, totals) || other.totals == totals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,const DeepCollectionEquality().hash(_months),totals);

@override
String toString() {
  return 'OwnerFinance(from: $from, to: $to, months: $months, totals: $totals)';
}


}

/// @nodoc
abstract mixin class _$OwnerFinanceCopyWith<$Res> implements $OwnerFinanceCopyWith<$Res> {
  factory _$OwnerFinanceCopyWith(_OwnerFinance value, $Res Function(_OwnerFinance) _then) = __$OwnerFinanceCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, List<FinanceMonth> months, FinanceTotals totals
});


@override $FinanceTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$OwnerFinanceCopyWithImpl<$Res>
    implements _$OwnerFinanceCopyWith<$Res> {
  __$OwnerFinanceCopyWithImpl(this._self, this._then);

  final _OwnerFinance _self;
  final $Res Function(_OwnerFinance) _then;

/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? months = null,Object? totals = null,}) {
  return _then(_OwnerFinance(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<FinanceMonth>,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as FinanceTotals,
  ));
}

/// Create a copy of OwnerFinance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceTotalsCopyWith<$Res> get totals {

  return $FinanceTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}

// dart format on
