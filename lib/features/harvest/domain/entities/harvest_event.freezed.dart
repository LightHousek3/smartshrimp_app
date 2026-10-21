// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harvest_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HarvestPlace {

 String get id; String get name; HarvestPlace? get farm;
/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestPlaceCopyWith<HarvestPlace> get copyWith => _$HarvestPlaceCopyWithImpl<HarvestPlace>(this as HarvestPlace, _$identity);

  /// Serializes this HarvestPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farm, farm) || other.farm == farm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farm);

@override
String toString() {
  return 'HarvestPlace(id: $id, name: $name, farm: $farm)';
}


}

/// @nodoc
abstract mixin class $HarvestPlaceCopyWith<$Res>  {
  factory $HarvestPlaceCopyWith(HarvestPlace value, $Res Function(HarvestPlace) _then) = _$HarvestPlaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, HarvestPlace? farm
});


$HarvestPlaceCopyWith<$Res>? get farm;

}
/// @nodoc
class _$HarvestPlaceCopyWithImpl<$Res>
    implements $HarvestPlaceCopyWith<$Res> {
  _$HarvestPlaceCopyWithImpl(this._self, this._then);

  final HarvestPlace _self;
  final $Res Function(HarvestPlace) _then;

/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? farm = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as HarvestPlace?,
  ));
}
/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestPlaceCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $HarvestPlaceCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}
}


/// Adds pattern-matching-related methods to [HarvestPlace].
extension HarvestPlacePatterns on HarvestPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestPlace value)  $default,){
final _that = this;
switch (_that) {
case _HarvestPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestPlace value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  HarvestPlace? farm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestPlace() when $default != null:
return $default(_that.id,_that.name,_that.farm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  HarvestPlace? farm)  $default,) {final _that = this;
switch (_that) {
case _HarvestPlace():
return $default(_that.id,_that.name,_that.farm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  HarvestPlace? farm)?  $default,) {final _that = this;
switch (_that) {
case _HarvestPlace() when $default != null:
return $default(_that.id,_that.name,_that.farm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarvestPlace implements HarvestPlace {
  const _HarvestPlace({required this.id, required this.name, this.farm});
  factory _HarvestPlace.fromJson(Map<String, dynamic> json) => _$HarvestPlaceFromJson(json);

@override final  String id;
@override final  String name;
@override final  HarvestPlace? farm;

/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestPlaceCopyWith<_HarvestPlace> get copyWith => __$HarvestPlaceCopyWithImpl<_HarvestPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farm, farm) || other.farm == farm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farm);

@override
String toString() {
  return 'HarvestPlace(id: $id, name: $name, farm: $farm)';
}


}

/// @nodoc
abstract mixin class _$HarvestPlaceCopyWith<$Res> implements $HarvestPlaceCopyWith<$Res> {
  factory _$HarvestPlaceCopyWith(_HarvestPlace value, $Res Function(_HarvestPlace) _then) = __$HarvestPlaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, HarvestPlace? farm
});


@override $HarvestPlaceCopyWith<$Res>? get farm;

}
/// @nodoc
class __$HarvestPlaceCopyWithImpl<$Res>
    implements _$HarvestPlaceCopyWith<$Res> {
  __$HarvestPlaceCopyWithImpl(this._self, this._then);

  final _HarvestPlace _self;
  final $Res Function(_HarvestPlace) _then;

/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? farm = freezed,}) {
  return _then(_HarvestPlace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as HarvestPlace?,
  ));
}

/// Create a copy of HarvestPlace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestPlaceCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $HarvestPlaceCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}
}


/// @nodoc
mixin _$HarvestSeason {

 String get id; String get name; String get status; HarvestPlace get pond;
/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestSeasonCopyWith<HarvestSeason> get copyWith => _$HarvestSeasonCopyWithImpl<HarvestSeason>(this as HarvestSeason, _$identity);

  /// Serializes this HarvestSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.pond, pond) || other.pond == pond));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,pond);

@override
String toString() {
  return 'HarvestSeason(id: $id, name: $name, status: $status, pond: $pond)';
}


}

/// @nodoc
abstract mixin class $HarvestSeasonCopyWith<$Res>  {
  factory $HarvestSeasonCopyWith(HarvestSeason value, $Res Function(HarvestSeason) _then) = _$HarvestSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, HarvestPlace pond
});


$HarvestPlaceCopyWith<$Res> get pond;

}
/// @nodoc
class _$HarvestSeasonCopyWithImpl<$Res>
    implements $HarvestSeasonCopyWith<$Res> {
  _$HarvestSeasonCopyWithImpl(this._self, this._then);

  final HarvestSeason _self;
  final $Res Function(HarvestSeason) _then;

/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? pond = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pond: null == pond ? _self.pond : pond // ignore: cast_nullable_to_non_nullable
as HarvestPlace,
  ));
}
/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestPlaceCopyWith<$Res> get pond {
  
  return $HarvestPlaceCopyWith<$Res>(_self.pond, (value) {
    return _then(_self.copyWith(pond: value));
  });
}
}


/// Adds pattern-matching-related methods to [HarvestSeason].
extension HarvestSeasonPatterns on HarvestSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestSeason value)  $default,){
final _that = this;
switch (_that) {
case _HarvestSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestSeason value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  HarvestPlace pond)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.pond);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  HarvestPlace pond)  $default,) {final _that = this;
switch (_that) {
case _HarvestSeason():
return $default(_that.id,_that.name,_that.status,_that.pond);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  HarvestPlace pond)?  $default,) {final _that = this;
switch (_that) {
case _HarvestSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.pond);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarvestSeason implements HarvestSeason {
  const _HarvestSeason({required this.id, required this.name, required this.status, required this.pond});
  factory _HarvestSeason.fromJson(Map<String, dynamic> json) => _$HarvestSeasonFromJson(json);

@override final  String id;
@override final  String name;
@override final  String status;
@override final  HarvestPlace pond;

/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestSeasonCopyWith<_HarvestSeason> get copyWith => __$HarvestSeasonCopyWithImpl<_HarvestSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.pond, pond) || other.pond == pond));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,pond);

@override
String toString() {
  return 'HarvestSeason(id: $id, name: $name, status: $status, pond: $pond)';
}


}

/// @nodoc
abstract mixin class _$HarvestSeasonCopyWith<$Res> implements $HarvestSeasonCopyWith<$Res> {
  factory _$HarvestSeasonCopyWith(_HarvestSeason value, $Res Function(_HarvestSeason) _then) = __$HarvestSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, HarvestPlace pond
});


@override $HarvestPlaceCopyWith<$Res> get pond;

}
/// @nodoc
class __$HarvestSeasonCopyWithImpl<$Res>
    implements _$HarvestSeasonCopyWith<$Res> {
  __$HarvestSeasonCopyWithImpl(this._self, this._then);

  final _HarvestSeason _self;
  final $Res Function(_HarvestSeason) _then;

/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? pond = null,}) {
  return _then(_HarvestSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pond: null == pond ? _self.pond : pond // ignore: cast_nullable_to_non_nullable
as HarvestPlace,
  ));
}

/// Create a copy of HarvestSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestPlaceCopyWith<$Res> get pond {
  
  return $HarvestPlaceCopyWith<$Res>(_self.pond, (value) {
    return _then(_self.copyWith(pond: value));
  });
}
}


/// @nodoc
mixin _$HarvestEvent {

 String get id; String get seasonId;@JsonKey(unknownEnumValue: HarvestType.unknown) HarvestType get harvestType; DateTime get harvestedAt; double get totalWeightKg; String get recordedBy; DateTime get createdAt; HarvestSeason get season; String? get quantityCount; double? get avgSizePerKg; double? get pricePerKg; double? get totalRevenue; String? get estimatedRemainingCount; String? get buyerName; String? get buyerContact; String? get note; String? get recorderName; String? get varianceReason; List<String> get warnings;
/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestEventCopyWith<HarvestEvent> get copyWith => _$HarvestEventCopyWithImpl<HarvestEvent>(this as HarvestEvent, _$identity);

  /// Serializes this HarvestEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.harvestType, harvestType) || other.harvestType == harvestType)&&(identical(other.harvestedAt, harvestedAt) || other.harvestedAt == harvestedAt)&&(identical(other.totalWeightKg, totalWeightKg) || other.totalWeightKg == totalWeightKg)&&(identical(other.recordedBy, recordedBy) || other.recordedBy == recordedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.season, season) || other.season == season)&&(identical(other.quantityCount, quantityCount) || other.quantityCount == quantityCount)&&(identical(other.avgSizePerKg, avgSizePerKg) || other.avgSizePerKg == avgSizePerKg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.estimatedRemainingCount, estimatedRemainingCount) || other.estimatedRemainingCount == estimatedRemainingCount)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.buyerContact, buyerContact) || other.buyerContact == buyerContact)&&(identical(other.note, note) || other.note == note)&&(identical(other.recorderName, recorderName) || other.recorderName == recorderName)&&(identical(other.varianceReason, varianceReason) || other.varianceReason == varianceReason)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,seasonId,harvestType,harvestedAt,totalWeightKg,recordedBy,createdAt,season,quantityCount,avgSizePerKg,pricePerKg,totalRevenue,estimatedRemainingCount,buyerName,buyerContact,note,recorderName,varianceReason,const DeepCollectionEquality().hash(warnings)]);

@override
String toString() {
  return 'HarvestEvent(id: $id, seasonId: $seasonId, harvestType: $harvestType, harvestedAt: $harvestedAt, totalWeightKg: $totalWeightKg, recordedBy: $recordedBy, createdAt: $createdAt, season: $season, quantityCount: $quantityCount, avgSizePerKg: $avgSizePerKg, pricePerKg: $pricePerKg, totalRevenue: $totalRevenue, estimatedRemainingCount: $estimatedRemainingCount, buyerName: $buyerName, buyerContact: $buyerContact, note: $note, recorderName: $recorderName, varianceReason: $varianceReason, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $HarvestEventCopyWith<$Res>  {
  factory $HarvestEventCopyWith(HarvestEvent value, $Res Function(HarvestEvent) _then) = _$HarvestEventCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId,@JsonKey(unknownEnumValue: HarvestType.unknown) HarvestType harvestType, DateTime harvestedAt, double totalWeightKg, String recordedBy, DateTime createdAt, HarvestSeason season, String? quantityCount, double? avgSizePerKg, double? pricePerKg, double? totalRevenue, String? estimatedRemainingCount, String? buyerName, String? buyerContact, String? note, String? recorderName, String? varianceReason, List<String> warnings
});


$HarvestSeasonCopyWith<$Res> get season;

}
/// @nodoc
class _$HarvestEventCopyWithImpl<$Res>
    implements $HarvestEventCopyWith<$Res> {
  _$HarvestEventCopyWithImpl(this._self, this._then);

  final HarvestEvent _self;
  final $Res Function(HarvestEvent) _then;

/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? harvestType = null,Object? harvestedAt = null,Object? totalWeightKg = null,Object? recordedBy = null,Object? createdAt = null,Object? season = null,Object? quantityCount = freezed,Object? avgSizePerKg = freezed,Object? pricePerKg = freezed,Object? totalRevenue = freezed,Object? estimatedRemainingCount = freezed,Object? buyerName = freezed,Object? buyerContact = freezed,Object? note = freezed,Object? recorderName = freezed,Object? varianceReason = freezed,Object? warnings = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,harvestType: null == harvestType ? _self.harvestType : harvestType // ignore: cast_nullable_to_non_nullable
as HarvestType,harvestedAt: null == harvestedAt ? _self.harvestedAt : harvestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalWeightKg: null == totalWeightKg ? _self.totalWeightKg : totalWeightKg // ignore: cast_nullable_to_non_nullable
as double,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as HarvestSeason,quantityCount: freezed == quantityCount ? _self.quantityCount : quantityCount // ignore: cast_nullable_to_non_nullable
as String?,avgSizePerKg: freezed == avgSizePerKg ? _self.avgSizePerKg : avgSizePerKg // ignore: cast_nullable_to_non_nullable
as double?,pricePerKg: freezed == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as double?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double?,estimatedRemainingCount: freezed == estimatedRemainingCount ? _self.estimatedRemainingCount : estimatedRemainingCount // ignore: cast_nullable_to_non_nullable
as String?,buyerName: freezed == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String?,buyerContact: freezed == buyerContact ? _self.buyerContact : buyerContact // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recorderName: freezed == recorderName ? _self.recorderName : recorderName // ignore: cast_nullable_to_non_nullable
as String?,varianceReason: freezed == varianceReason ? _self.varianceReason : varianceReason // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestSeasonCopyWith<$Res> get season {
  
  return $HarvestSeasonCopyWith<$Res>(_self.season, (value) {
    return _then(_self.copyWith(season: value));
  });
}
}


/// Adds pattern-matching-related methods to [HarvestEvent].
extension HarvestEventPatterns on HarvestEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestEvent value)  $default,){
final _that = this;
switch (_that) {
case _HarvestEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestEvent value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId, @JsonKey(unknownEnumValue: HarvestType.unknown)  HarvestType harvestType,  DateTime harvestedAt,  double totalWeightKg,  String recordedBy,  DateTime createdAt,  HarvestSeason season,  String? quantityCount,  double? avgSizePerKg,  double? pricePerKg,  double? totalRevenue,  String? estimatedRemainingCount,  String? buyerName,  String? buyerContact,  String? note,  String? recorderName,  String? varianceReason,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestEvent() when $default != null:
return $default(_that.id,_that.seasonId,_that.harvestType,_that.harvestedAt,_that.totalWeightKg,_that.recordedBy,_that.createdAt,_that.season,_that.quantityCount,_that.avgSizePerKg,_that.pricePerKg,_that.totalRevenue,_that.estimatedRemainingCount,_that.buyerName,_that.buyerContact,_that.note,_that.recorderName,_that.varianceReason,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId, @JsonKey(unknownEnumValue: HarvestType.unknown)  HarvestType harvestType,  DateTime harvestedAt,  double totalWeightKg,  String recordedBy,  DateTime createdAt,  HarvestSeason season,  String? quantityCount,  double? avgSizePerKg,  double? pricePerKg,  double? totalRevenue,  String? estimatedRemainingCount,  String? buyerName,  String? buyerContact,  String? note,  String? recorderName,  String? varianceReason,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _HarvestEvent():
return $default(_that.id,_that.seasonId,_that.harvestType,_that.harvestedAt,_that.totalWeightKg,_that.recordedBy,_that.createdAt,_that.season,_that.quantityCount,_that.avgSizePerKg,_that.pricePerKg,_that.totalRevenue,_that.estimatedRemainingCount,_that.buyerName,_that.buyerContact,_that.note,_that.recorderName,_that.varianceReason,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId, @JsonKey(unknownEnumValue: HarvestType.unknown)  HarvestType harvestType,  DateTime harvestedAt,  double totalWeightKg,  String recordedBy,  DateTime createdAt,  HarvestSeason season,  String? quantityCount,  double? avgSizePerKg,  double? pricePerKg,  double? totalRevenue,  String? estimatedRemainingCount,  String? buyerName,  String? buyerContact,  String? note,  String? recorderName,  String? varianceReason,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _HarvestEvent() when $default != null:
return $default(_that.id,_that.seasonId,_that.harvestType,_that.harvestedAt,_that.totalWeightKg,_that.recordedBy,_that.createdAt,_that.season,_that.quantityCount,_that.avgSizePerKg,_that.pricePerKg,_that.totalRevenue,_that.estimatedRemainingCount,_that.buyerName,_that.buyerContact,_that.note,_that.recorderName,_that.varianceReason,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarvestEvent implements HarvestEvent {
  const _HarvestEvent({required this.id, required this.seasonId, @JsonKey(unknownEnumValue: HarvestType.unknown) required this.harvestType, required this.harvestedAt, required this.totalWeightKg, required this.recordedBy, required this.createdAt, required this.season, this.quantityCount, this.avgSizePerKg, this.pricePerKg, this.totalRevenue, this.estimatedRemainingCount, this.buyerName, this.buyerContact, this.note, this.recorderName, this.varianceReason, final  List<String> warnings = const <String>[]}): _warnings = warnings;
  factory _HarvestEvent.fromJson(Map<String, dynamic> json) => _$HarvestEventFromJson(json);

@override final  String id;
@override final  String seasonId;
@override@JsonKey(unknownEnumValue: HarvestType.unknown) final  HarvestType harvestType;
@override final  DateTime harvestedAt;
@override final  double totalWeightKg;
@override final  String recordedBy;
@override final  DateTime createdAt;
@override final  HarvestSeason season;
@override final  String? quantityCount;
@override final  double? avgSizePerKg;
@override final  double? pricePerKg;
@override final  double? totalRevenue;
@override final  String? estimatedRemainingCount;
@override final  String? buyerName;
@override final  String? buyerContact;
@override final  String? note;
@override final  String? recorderName;
@override final  String? varianceReason;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestEventCopyWith<_HarvestEvent> get copyWith => __$HarvestEventCopyWithImpl<_HarvestEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.harvestType, harvestType) || other.harvestType == harvestType)&&(identical(other.harvestedAt, harvestedAt) || other.harvestedAt == harvestedAt)&&(identical(other.totalWeightKg, totalWeightKg) || other.totalWeightKg == totalWeightKg)&&(identical(other.recordedBy, recordedBy) || other.recordedBy == recordedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.season, season) || other.season == season)&&(identical(other.quantityCount, quantityCount) || other.quantityCount == quantityCount)&&(identical(other.avgSizePerKg, avgSizePerKg) || other.avgSizePerKg == avgSizePerKg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.estimatedRemainingCount, estimatedRemainingCount) || other.estimatedRemainingCount == estimatedRemainingCount)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.buyerContact, buyerContact) || other.buyerContact == buyerContact)&&(identical(other.note, note) || other.note == note)&&(identical(other.recorderName, recorderName) || other.recorderName == recorderName)&&(identical(other.varianceReason, varianceReason) || other.varianceReason == varianceReason)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,seasonId,harvestType,harvestedAt,totalWeightKg,recordedBy,createdAt,season,quantityCount,avgSizePerKg,pricePerKg,totalRevenue,estimatedRemainingCount,buyerName,buyerContact,note,recorderName,varianceReason,const DeepCollectionEquality().hash(_warnings)]);

@override
String toString() {
  return 'HarvestEvent(id: $id, seasonId: $seasonId, harvestType: $harvestType, harvestedAt: $harvestedAt, totalWeightKg: $totalWeightKg, recordedBy: $recordedBy, createdAt: $createdAt, season: $season, quantityCount: $quantityCount, avgSizePerKg: $avgSizePerKg, pricePerKg: $pricePerKg, totalRevenue: $totalRevenue, estimatedRemainingCount: $estimatedRemainingCount, buyerName: $buyerName, buyerContact: $buyerContact, note: $note, recorderName: $recorderName, varianceReason: $varianceReason, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$HarvestEventCopyWith<$Res> implements $HarvestEventCopyWith<$Res> {
  factory _$HarvestEventCopyWith(_HarvestEvent value, $Res Function(_HarvestEvent) _then) = __$HarvestEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId,@JsonKey(unknownEnumValue: HarvestType.unknown) HarvestType harvestType, DateTime harvestedAt, double totalWeightKg, String recordedBy, DateTime createdAt, HarvestSeason season, String? quantityCount, double? avgSizePerKg, double? pricePerKg, double? totalRevenue, String? estimatedRemainingCount, String? buyerName, String? buyerContact, String? note, String? recorderName, String? varianceReason, List<String> warnings
});


@override $HarvestSeasonCopyWith<$Res> get season;

}
/// @nodoc
class __$HarvestEventCopyWithImpl<$Res>
    implements _$HarvestEventCopyWith<$Res> {
  __$HarvestEventCopyWithImpl(this._self, this._then);

  final _HarvestEvent _self;
  final $Res Function(_HarvestEvent) _then;

/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? harvestType = null,Object? harvestedAt = null,Object? totalWeightKg = null,Object? recordedBy = null,Object? createdAt = null,Object? season = null,Object? quantityCount = freezed,Object? avgSizePerKg = freezed,Object? pricePerKg = freezed,Object? totalRevenue = freezed,Object? estimatedRemainingCount = freezed,Object? buyerName = freezed,Object? buyerContact = freezed,Object? note = freezed,Object? recorderName = freezed,Object? varianceReason = freezed,Object? warnings = null,}) {
  return _then(_HarvestEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,harvestType: null == harvestType ? _self.harvestType : harvestType // ignore: cast_nullable_to_non_nullable
as HarvestType,harvestedAt: null == harvestedAt ? _self.harvestedAt : harvestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalWeightKg: null == totalWeightKg ? _self.totalWeightKg : totalWeightKg // ignore: cast_nullable_to_non_nullable
as double,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as HarvestSeason,quantityCount: freezed == quantityCount ? _self.quantityCount : quantityCount // ignore: cast_nullable_to_non_nullable
as String?,avgSizePerKg: freezed == avgSizePerKg ? _self.avgSizePerKg : avgSizePerKg // ignore: cast_nullable_to_non_nullable
as double?,pricePerKg: freezed == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as double?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double?,estimatedRemainingCount: freezed == estimatedRemainingCount ? _self.estimatedRemainingCount : estimatedRemainingCount // ignore: cast_nullable_to_non_nullable
as String?,buyerName: freezed == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String?,buyerContact: freezed == buyerContact ? _self.buyerContact : buyerContact // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recorderName: freezed == recorderName ? _self.recorderName : recorderName // ignore: cast_nullable_to_non_nullable
as String?,varianceReason: freezed == varianceReason ? _self.varianceReason : varianceReason // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of HarvestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HarvestSeasonCopyWith<$Res> get season {
  
  return $HarvestSeasonCopyWith<$Res>(_self.season, (value) {
    return _then(_self.copyWith(season: value));
  });
}
}

/// @nodoc
mixin _$HarvestPage {

 List<HarvestEvent> get items; int get limit; int get totalResults; bool get hasNextPage; String? get nextCursor; double get totalWeightKg; double get totalRevenue; String? get availableQuantityCount;
/// Create a copy of HarvestPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestPageCopyWith<HarvestPage> get copyWith => _$HarvestPageCopyWithImpl<HarvestPage>(this as HarvestPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.totalWeightKg, totalWeightKg) || other.totalWeightKg == totalWeightKg)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.availableQuantityCount, availableQuantityCount) || other.availableQuantityCount == availableQuantityCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),limit,totalResults,hasNextPage,nextCursor,totalWeightKg,totalRevenue,availableQuantityCount);

@override
String toString() {
  return 'HarvestPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, totalWeightKg: $totalWeightKg, totalRevenue: $totalRevenue, availableQuantityCount: $availableQuantityCount)';
}


}

/// @nodoc
abstract mixin class $HarvestPageCopyWith<$Res>  {
  factory $HarvestPageCopyWith(HarvestPage value, $Res Function(HarvestPage) _then) = _$HarvestPageCopyWithImpl;
@useResult
$Res call({
 List<HarvestEvent> items, int limit, int totalResults, bool hasNextPage, String? nextCursor, double totalWeightKg, double totalRevenue, String? availableQuantityCount
});




}
/// @nodoc
class _$HarvestPageCopyWithImpl<$Res>
    implements $HarvestPageCopyWith<$Res> {
  _$HarvestPageCopyWithImpl(this._self, this._then);

  final HarvestPage _self;
  final $Res Function(HarvestPage) _then;

/// Create a copy of HarvestPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? totalWeightKg = null,Object? totalRevenue = null,Object? availableQuantityCount = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<HarvestEvent>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,totalWeightKg: null == totalWeightKg ? _self.totalWeightKg : totalWeightKg // ignore: cast_nullable_to_non_nullable
as double,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,availableQuantityCount: freezed == availableQuantityCount ? _self.availableQuantityCount : availableQuantityCount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HarvestPage].
extension HarvestPagePatterns on HarvestPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestPage value)  $default,){
final _that = this;
switch (_that) {
case _HarvestPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestPage value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HarvestEvent> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  double totalWeightKg,  double totalRevenue,  String? availableQuantityCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.totalWeightKg,_that.totalRevenue,_that.availableQuantityCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HarvestEvent> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  double totalWeightKg,  double totalRevenue,  String? availableQuantityCount)  $default,) {final _that = this;
switch (_that) {
case _HarvestPage():
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.totalWeightKg,_that.totalRevenue,_that.availableQuantityCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HarvestEvent> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  double totalWeightKg,  double totalRevenue,  String? availableQuantityCount)?  $default,) {final _that = this;
switch (_that) {
case _HarvestPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.totalWeightKg,_that.totalRevenue,_that.availableQuantityCount);case _:
  return null;

}
}

}

/// @nodoc


class _HarvestPage implements HarvestPage {
  const _HarvestPage({required final  List<HarvestEvent> items, required this.limit, required this.totalResults, required this.hasNextPage, this.nextCursor, required this.totalWeightKg, required this.totalRevenue, this.availableQuantityCount}): _items = items;
  

 final  List<HarvestEvent> _items;
@override List<HarvestEvent> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int limit;
@override final  int totalResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;
@override final  double totalWeightKg;
@override final  double totalRevenue;
@override final  String? availableQuantityCount;

/// Create a copy of HarvestPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestPageCopyWith<_HarvestPage> get copyWith => __$HarvestPageCopyWithImpl<_HarvestPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.totalWeightKg, totalWeightKg) || other.totalWeightKg == totalWeightKg)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.availableQuantityCount, availableQuantityCount) || other.availableQuantityCount == availableQuantityCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),limit,totalResults,hasNextPage,nextCursor,totalWeightKg,totalRevenue,availableQuantityCount);

@override
String toString() {
  return 'HarvestPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, totalWeightKg: $totalWeightKg, totalRevenue: $totalRevenue, availableQuantityCount: $availableQuantityCount)';
}


}

/// @nodoc
abstract mixin class _$HarvestPageCopyWith<$Res> implements $HarvestPageCopyWith<$Res> {
  factory _$HarvestPageCopyWith(_HarvestPage value, $Res Function(_HarvestPage) _then) = __$HarvestPageCopyWithImpl;
@override @useResult
$Res call({
 List<HarvestEvent> items, int limit, int totalResults, bool hasNextPage, String? nextCursor, double totalWeightKg, double totalRevenue, String? availableQuantityCount
});




}
/// @nodoc
class __$HarvestPageCopyWithImpl<$Res>
    implements _$HarvestPageCopyWith<$Res> {
  __$HarvestPageCopyWithImpl(this._self, this._then);

  final _HarvestPage _self;
  final $Res Function(_HarvestPage) _then;

/// Create a copy of HarvestPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? totalWeightKg = null,Object? totalRevenue = null,Object? availableQuantityCount = freezed,}) {
  return _then(_HarvestPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<HarvestEvent>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,totalWeightKg: null == totalWeightKg ? _self.totalWeightKg : totalWeightKg // ignore: cast_nullable_to_non_nullable
as double,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,availableQuantityCount: freezed == availableQuantityCount ? _self.availableQuantityCount : availableQuantityCount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PendingHarvestSubmission {

 String get key; Map<String, dynamic> get body;
/// Create a copy of PendingHarvestSubmission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingHarvestSubmissionCopyWith<PendingHarvestSubmission> get copyWith => _$PendingHarvestSubmissionCopyWithImpl<PendingHarvestSubmission>(this as PendingHarvestSubmission, _$identity);

  /// Serializes this PendingHarvestSubmission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingHarvestSubmission&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.body, body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(body));

@override
String toString() {
  return 'PendingHarvestSubmission(key: $key, body: $body)';
}


}

/// @nodoc
abstract mixin class $PendingHarvestSubmissionCopyWith<$Res>  {
  factory $PendingHarvestSubmissionCopyWith(PendingHarvestSubmission value, $Res Function(PendingHarvestSubmission) _then) = _$PendingHarvestSubmissionCopyWithImpl;
@useResult
$Res call({
 String key, Map<String, dynamic> body
});




}
/// @nodoc
class _$PendingHarvestSubmissionCopyWithImpl<$Res>
    implements $PendingHarvestSubmissionCopyWith<$Res> {
  _$PendingHarvestSubmissionCopyWithImpl(this._self, this._then);

  final PendingHarvestSubmission _self;
  final $Res Function(PendingHarvestSubmission) _then;

/// Create a copy of PendingHarvestSubmission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? body = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingHarvestSubmission].
extension PendingHarvestSubmissionPatterns on PendingHarvestSubmission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingHarvestSubmission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingHarvestSubmission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingHarvestSubmission value)  $default,){
final _that = this;
switch (_that) {
case _PendingHarvestSubmission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingHarvestSubmission value)?  $default,){
final _that = this;
switch (_that) {
case _PendingHarvestSubmission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  Map<String, dynamic> body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingHarvestSubmission() when $default != null:
return $default(_that.key,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  Map<String, dynamic> body)  $default,) {final _that = this;
switch (_that) {
case _PendingHarvestSubmission():
return $default(_that.key,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  Map<String, dynamic> body)?  $default,) {final _that = this;
switch (_that) {
case _PendingHarvestSubmission() when $default != null:
return $default(_that.key,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingHarvestSubmission implements PendingHarvestSubmission {
  const _PendingHarvestSubmission({required this.key, required final  Map<String, dynamic> body}): _body = body;
  factory _PendingHarvestSubmission.fromJson(Map<String, dynamic> json) => _$PendingHarvestSubmissionFromJson(json);

@override final  String key;
 final  Map<String, dynamic> _body;
@override Map<String, dynamic> get body {
  if (_body is EqualUnmodifiableMapView) return _body;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_body);
}


/// Create a copy of PendingHarvestSubmission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingHarvestSubmissionCopyWith<_PendingHarvestSubmission> get copyWith => __$PendingHarvestSubmissionCopyWithImpl<_PendingHarvestSubmission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingHarvestSubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingHarvestSubmission&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other._body, _body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_body));

@override
String toString() {
  return 'PendingHarvestSubmission(key: $key, body: $body)';
}


}

/// @nodoc
abstract mixin class _$PendingHarvestSubmissionCopyWith<$Res> implements $PendingHarvestSubmissionCopyWith<$Res> {
  factory _$PendingHarvestSubmissionCopyWith(_PendingHarvestSubmission value, $Res Function(_PendingHarvestSubmission) _then) = __$PendingHarvestSubmissionCopyWithImpl;
@override @useResult
$Res call({
 String key, Map<String, dynamic> body
});




}
/// @nodoc
class __$PendingHarvestSubmissionCopyWithImpl<$Res>
    implements _$PendingHarvestSubmissionCopyWith<$Res> {
  __$PendingHarvestSubmissionCopyWithImpl(this._self, this._then);

  final _PendingHarvestSubmission _self;
  final $Res Function(_PendingHarvestSubmission) _then;

/// Create a copy of PendingHarvestSubmission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? body = null,}) {
  return _then(_PendingHarvestSubmission(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self._body : body // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
