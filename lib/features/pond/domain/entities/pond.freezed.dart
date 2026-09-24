// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pond.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PondFarm {

 String get id; String get name; DateTime? get deletedAt;
/// Create a copy of PondFarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PondFarmCopyWith<PondFarm> get copyWith => _$PondFarmCopyWithImpl<PondFarm>(this as PondFarm, _$identity);

  /// Serializes this PondFarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PondFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deletedAt);

@override
String toString() {
  return 'PondFarm(id: $id, name: $name, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $PondFarmCopyWith<$Res>  {
  factory $PondFarmCopyWith(PondFarm value, $Res Function(PondFarm) _then) = _$PondFarmCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime? deletedAt
});




}
/// @nodoc
class _$PondFarmCopyWithImpl<$Res>
    implements $PondFarmCopyWith<$Res> {
  _$PondFarmCopyWithImpl(this._self, this._then);

  final PondFarm _self;
  final $Res Function(PondFarm) _then;

/// Create a copy of PondFarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PondFarm].
extension PondFarmPatterns on PondFarm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PondFarm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PondFarm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PondFarm value)  $default,){
final _that = this;
switch (_that) {
case _PondFarm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PondFarm value)?  $default,){
final _that = this;
switch (_that) {
case _PondFarm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PondFarm() when $default != null:
return $default(_that.id,_that.name,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _PondFarm():
return $default(_that.id,_that.name,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _PondFarm() when $default != null:
return $default(_that.id,_that.name,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PondFarm implements PondFarm {
  const _PondFarm({required this.id, required this.name, this.deletedAt});
  factory _PondFarm.fromJson(Map<String, dynamic> json) => _$PondFarmFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime? deletedAt;

/// Create a copy of PondFarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PondFarmCopyWith<_PondFarm> get copyWith => __$PondFarmCopyWithImpl<_PondFarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PondFarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PondFarm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,deletedAt);

@override
String toString() {
  return 'PondFarm(id: $id, name: $name, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$PondFarmCopyWith<$Res> implements $PondFarmCopyWith<$Res> {
  factory _$PondFarmCopyWith(_PondFarm value, $Res Function(_PondFarm) _then) = __$PondFarmCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime? deletedAt
});




}
/// @nodoc
class __$PondFarmCopyWithImpl<$Res>
    implements _$PondFarmCopyWith<$Res> {
  __$PondFarmCopyWithImpl(this._self, this._then);

  final _PondFarm _self;
  final $Res Function(_PondFarm) _then;

/// Create a copy of PondFarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? deletedAt = freezed,}) {
  return _then(_PondFarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PondCurrentSeason {

 String get id;@JsonKey(unknownEnumValue: PondSeasonStatus.unknown) PondSeasonStatus get status; DateTime? get stockingDate;
/// Create a copy of PondCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PondCurrentSeasonCopyWith<PondCurrentSeason> get copyWith => _$PondCurrentSeasonCopyWithImpl<PondCurrentSeason>(this as PondCurrentSeason, _$identity);

  /// Serializes this PondCurrentSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PondCurrentSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,stockingDate);

@override
String toString() {
  return 'PondCurrentSeason(id: $id, status: $status, stockingDate: $stockingDate)';
}


}

/// @nodoc
abstract mixin class $PondCurrentSeasonCopyWith<$Res>  {
  factory $PondCurrentSeasonCopyWith(PondCurrentSeason value, $Res Function(PondCurrentSeason) _then) = _$PondCurrentSeasonCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PondSeasonStatus.unknown) PondSeasonStatus status, DateTime? stockingDate
});




}
/// @nodoc
class _$PondCurrentSeasonCopyWithImpl<$Res>
    implements $PondCurrentSeasonCopyWith<$Res> {
  _$PondCurrentSeasonCopyWithImpl(this._self, this._then);

  final PondCurrentSeason _self;
  final $Res Function(PondCurrentSeason) _then;

/// Create a copy of PondCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? stockingDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondSeasonStatus,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PondCurrentSeason].
extension PondCurrentSeasonPatterns on PondCurrentSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PondCurrentSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PondCurrentSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PondCurrentSeason value)  $default,){
final _that = this;
switch (_that) {
case _PondCurrentSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PondCurrentSeason value)?  $default,){
final _that = this;
switch (_that) {
case _PondCurrentSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PondSeasonStatus.unknown)  PondSeasonStatus status,  DateTime? stockingDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PondCurrentSeason() when $default != null:
return $default(_that.id,_that.status,_that.stockingDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: PondSeasonStatus.unknown)  PondSeasonStatus status,  DateTime? stockingDate)  $default,) {final _that = this;
switch (_that) {
case _PondCurrentSeason():
return $default(_that.id,_that.status,_that.stockingDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: PondSeasonStatus.unknown)  PondSeasonStatus status,  DateTime? stockingDate)?  $default,) {final _that = this;
switch (_that) {
case _PondCurrentSeason() when $default != null:
return $default(_that.id,_that.status,_that.stockingDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PondCurrentSeason implements PondCurrentSeason {
  const _PondCurrentSeason({required this.id, @JsonKey(unknownEnumValue: PondSeasonStatus.unknown) required this.status, this.stockingDate});
  factory _PondCurrentSeason.fromJson(Map<String, dynamic> json) => _$PondCurrentSeasonFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: PondSeasonStatus.unknown) final  PondSeasonStatus status;
@override final  DateTime? stockingDate;

/// Create a copy of PondCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PondCurrentSeasonCopyWith<_PondCurrentSeason> get copyWith => __$PondCurrentSeasonCopyWithImpl<_PondCurrentSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PondCurrentSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PondCurrentSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,stockingDate);

@override
String toString() {
  return 'PondCurrentSeason(id: $id, status: $status, stockingDate: $stockingDate)';
}


}

/// @nodoc
abstract mixin class _$PondCurrentSeasonCopyWith<$Res> implements $PondCurrentSeasonCopyWith<$Res> {
  factory _$PondCurrentSeasonCopyWith(_PondCurrentSeason value, $Res Function(_PondCurrentSeason) _then) = __$PondCurrentSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: PondSeasonStatus.unknown) PondSeasonStatus status, DateTime? stockingDate
});




}
/// @nodoc
class __$PondCurrentSeasonCopyWithImpl<$Res>
    implements _$PondCurrentSeasonCopyWith<$Res> {
  __$PondCurrentSeasonCopyWithImpl(this._self, this._then);

  final _PondCurrentSeason _self;
  final $Res Function(_PondCurrentSeason) _then;

/// Create a copy of PondCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? stockingDate = freezed,}) {
  return _then(_PondCurrentSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondSeasonStatus,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Pond {

 String get id; String get farmId; String get name; double? get areaM2; double? get depthM; double? get volumeM3;@JsonKey(unknownEnumValue: PondType.unknown) PondType get type;@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus get status; DateTime? get deletedAt; DateTime? get createdAt; DateTime? get updatedAt; PondFarm? get farm; PondCurrentSeason? get currentSeason;
/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PondCopyWith<Pond> get copyWith => _$PondCopyWithImpl<Pond>(this as Pond, _$identity);

  /// Serializes this Pond to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pond&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.farm, farm) || other.farm == farm)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,name,areaM2,depthM,volumeM3,type,status,deletedAt,createdAt,updatedAt,farm,currentSeason);

@override
String toString() {
  return 'Pond(id: $id, farmId: $farmId, name: $name, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3, type: $type, status: $status, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, farm: $farm, currentSeason: $currentSeason)';
}


}

/// @nodoc
abstract mixin class $PondCopyWith<$Res>  {
  factory $PondCopyWith(Pond value, $Res Function(Pond) _then) = _$PondCopyWithImpl;
@useResult
$Res call({
 String id, String farmId, String name, double? areaM2, double? depthM, double? volumeM3,@JsonKey(unknownEnumValue: PondType.unknown) PondType type,@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus status, DateTime? deletedAt, DateTime? createdAt, DateTime? updatedAt, PondFarm? farm, PondCurrentSeason? currentSeason
});


$PondFarmCopyWith<$Res>? get farm;$PondCurrentSeasonCopyWith<$Res>? get currentSeason;

}
/// @nodoc
class _$PondCopyWithImpl<$Res>
    implements $PondCopyWith<$Res> {
  _$PondCopyWithImpl(this._self, this._then);

  final Pond _self;
  final $Res Function(Pond) _then;

/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,Object? type = null,Object? status = null,Object? deletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? farm = freezed,Object? currentSeason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PondType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondStatus,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as PondFarm?,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as PondCurrentSeason?,
  ));
}
/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondFarmCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $PondFarmCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondCurrentSeasonCopyWith<$Res>? get currentSeason {
    if (_self.currentSeason == null) {
    return null;
  }

  return $PondCurrentSeasonCopyWith<$Res>(_self.currentSeason!, (value) {
    return _then(_self.copyWith(currentSeason: value));
  });
}
}


/// Adds pattern-matching-related methods to [Pond].
extension PondPatterns on Pond {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pond value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pond() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pond value)  $default,){
final _that = this;
switch (_that) {
case _Pond():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pond value)?  $default,){
final _that = this;
switch (_that) {
case _Pond() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  DateTime? deletedAt,  DateTime? createdAt,  DateTime? updatedAt,  PondFarm? farm,  PondCurrentSeason? currentSeason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pond() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.deletedAt,_that.createdAt,_that.updatedAt,_that.farm,_that.currentSeason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  DateTime? deletedAt,  DateTime? createdAt,  DateTime? updatedAt,  PondFarm? farm,  PondCurrentSeason? currentSeason)  $default,) {final _that = this;
switch (_that) {
case _Pond():
return $default(_that.id,_that.farmId,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.deletedAt,_that.createdAt,_that.updatedAt,_that.farm,_that.currentSeason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmId,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  DateTime? deletedAt,  DateTime? createdAt,  DateTime? updatedAt,  PondFarm? farm,  PondCurrentSeason? currentSeason)?  $default,) {final _that = this;
switch (_that) {
case _Pond() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.deletedAt,_that.createdAt,_that.updatedAt,_that.farm,_that.currentSeason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pond extends Pond {
  const _Pond({required this.id, required this.farmId, required this.name, this.areaM2, this.depthM, this.volumeM3, @JsonKey(unknownEnumValue: PondType.unknown) required this.type, @JsonKey(unknownEnumValue: PondStatus.unknown) required this.status, this.deletedAt, this.createdAt, this.updatedAt, this.farm, this.currentSeason}): super._();
  factory _Pond.fromJson(Map<String, dynamic> json) => _$PondFromJson(json);

@override final  String id;
@override final  String farmId;
@override final  String name;
@override final  double? areaM2;
@override final  double? depthM;
@override final  double? volumeM3;
@override@JsonKey(unknownEnumValue: PondType.unknown) final  PondType type;
@override@JsonKey(unknownEnumValue: PondStatus.unknown) final  PondStatus status;
@override final  DateTime? deletedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  PondFarm? farm;
@override final  PondCurrentSeason? currentSeason;

/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PondCopyWith<_Pond> get copyWith => __$PondCopyWithImpl<_Pond>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PondToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pond&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.farm, farm) || other.farm == farm)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,name,areaM2,depthM,volumeM3,type,status,deletedAt,createdAt,updatedAt,farm,currentSeason);

@override
String toString() {
  return 'Pond(id: $id, farmId: $farmId, name: $name, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3, type: $type, status: $status, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, farm: $farm, currentSeason: $currentSeason)';
}


}

/// @nodoc
abstract mixin class _$PondCopyWith<$Res> implements $PondCopyWith<$Res> {
  factory _$PondCopyWith(_Pond value, $Res Function(_Pond) _then) = __$PondCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmId, String name, double? areaM2, double? depthM, double? volumeM3,@JsonKey(unknownEnumValue: PondType.unknown) PondType type,@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus status, DateTime? deletedAt, DateTime? createdAt, DateTime? updatedAt, PondFarm? farm, PondCurrentSeason? currentSeason
});


@override $PondFarmCopyWith<$Res>? get farm;@override $PondCurrentSeasonCopyWith<$Res>? get currentSeason;

}
/// @nodoc
class __$PondCopyWithImpl<$Res>
    implements _$PondCopyWith<$Res> {
  __$PondCopyWithImpl(this._self, this._then);

  final _Pond _self;
  final $Res Function(_Pond) _then;

/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,Object? type = null,Object? status = null,Object? deletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? farm = freezed,Object? currentSeason = freezed,}) {
  return _then(_Pond(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PondType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondStatus,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as PondFarm?,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as PondCurrentSeason?,
  ));
}

/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondFarmCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $PondFarmCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}/// Create a copy of Pond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondCurrentSeasonCopyWith<$Res>? get currentSeason {
    if (_self.currentSeason == null) {
    return null;
  }

  return $PondCurrentSeasonCopyWith<$Res>(_self.currentSeason!, (value) {
    return _then(_self.copyWith(currentSeason: value));
  });
}
}

/// @nodoc
mixin _$PondPage {

 List<Pond> get items; int get page; int get limit; int get totalResults; int get totalPages; bool get hasNextPage;
/// Create a copy of PondPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PondPageCopyWith<PondPage> get copyWith => _$PondPageCopyWithImpl<PondPage>(this as PondPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PondPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,limit,totalResults,totalPages,hasNextPage);

@override
String toString() {
  return 'PondPage(items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class $PondPageCopyWith<$Res>  {
  factory $PondPageCopyWith(PondPage value, $Res Function(PondPage) _then) = _$PondPageCopyWithImpl;
@useResult
$Res call({
 List<Pond> items, int page, int limit, int totalResults, int totalPages, bool hasNextPage
});




}
/// @nodoc
class _$PondPageCopyWithImpl<$Res>
    implements $PondPageCopyWith<$Res> {
  _$PondPageCopyWithImpl(this._self, this._then);

  final PondPage _self;
  final $Res Function(PondPage) _then;

/// Create a copy of PondPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,Object? hasNextPage = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Pond>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PondPage].
extension PondPagePatterns on PondPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PondPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PondPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PondPage value)  $default,){
final _that = this;
switch (_that) {
case _PondPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PondPage value)?  $default,){
final _that = this;
switch (_that) {
case _PondPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Pond> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PondPage() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Pond> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage)  $default,) {final _that = this;
switch (_that) {
case _PondPage():
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Pond> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage)?  $default,) {final _that = this;
switch (_that) {
case _PondPage() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage);case _:
  return null;

}
}

}

/// @nodoc


class _PondPage extends PondPage {
  const _PondPage({required final  List<Pond> items, required this.page, required this.limit, required this.totalResults, required this.totalPages, required this.hasNextPage}): _items = items,super._();
  

 final  List<Pond> _items;
@override List<Pond> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int limit;
@override final  int totalResults;
@override final  int totalPages;
@override final  bool hasNextPage;

/// Create a copy of PondPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PondPageCopyWith<_PondPage> get copyWith => __$PondPageCopyWithImpl<_PondPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PondPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,limit,totalResults,totalPages,hasNextPage);

@override
String toString() {
  return 'PondPage(items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class _$PondPageCopyWith<$Res> implements $PondPageCopyWith<$Res> {
  factory _$PondPageCopyWith(_PondPage value, $Res Function(_PondPage) _then) = __$PondPageCopyWithImpl;
@override @useResult
$Res call({
 List<Pond> items, int page, int limit, int totalResults, int totalPages, bool hasNextPage
});




}
/// @nodoc
class __$PondPageCopyWithImpl<$Res>
    implements _$PondPageCopyWith<$Res> {
  __$PondPageCopyWithImpl(this._self, this._then);

  final _PondPage _self;
  final $Res Function(_PondPage) _then;

/// Create a copy of PondPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,Object? hasNextPage = null,}) {
  return _then(_PondPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Pond>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
