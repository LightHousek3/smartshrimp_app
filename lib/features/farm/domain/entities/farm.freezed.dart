// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmCurrentSeason {

 String get id;@JsonKey(unknownEnumValue: FarmSeasonStatus.unknown) FarmSeasonStatus get status; DateTime? get stockingDate; int? get dayOfCulture;
/// Create a copy of FarmCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmCurrentSeasonCopyWith<FarmCurrentSeason> get copyWith => _$FarmCurrentSeasonCopyWithImpl<FarmCurrentSeason>(this as FarmCurrentSeason, _$identity);

  /// Serializes this FarmCurrentSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmCurrentSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,stockingDate,dayOfCulture);

@override
String toString() {
  return 'FarmCurrentSeason(id: $id, status: $status, stockingDate: $stockingDate, dayOfCulture: $dayOfCulture)';
}


}

/// @nodoc
abstract mixin class $FarmCurrentSeasonCopyWith<$Res>  {
  factory $FarmCurrentSeasonCopyWith(FarmCurrentSeason value, $Res Function(FarmCurrentSeason) _then) = _$FarmCurrentSeasonCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: FarmSeasonStatus.unknown) FarmSeasonStatus status, DateTime? stockingDate, int? dayOfCulture
});




}
/// @nodoc
class _$FarmCurrentSeasonCopyWithImpl<$Res>
    implements $FarmCurrentSeasonCopyWith<$Res> {
  _$FarmCurrentSeasonCopyWithImpl(this._self, this._then);

  final FarmCurrentSeason _self;
  final $Res Function(FarmCurrentSeason) _then;

/// Create a copy of FarmCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? stockingDate = freezed,Object? dayOfCulture = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FarmSeasonStatus,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmCurrentSeason].
extension FarmCurrentSeasonPatterns on FarmCurrentSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmCurrentSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmCurrentSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmCurrentSeason value)  $default,){
final _that = this;
switch (_that) {
case _FarmCurrentSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmCurrentSeason value)?  $default,){
final _that = this;
switch (_that) {
case _FarmCurrentSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: FarmSeasonStatus.unknown)  FarmSeasonStatus status,  DateTime? stockingDate,  int? dayOfCulture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmCurrentSeason() when $default != null:
return $default(_that.id,_that.status,_that.stockingDate,_that.dayOfCulture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: FarmSeasonStatus.unknown)  FarmSeasonStatus status,  DateTime? stockingDate,  int? dayOfCulture)  $default,) {final _that = this;
switch (_that) {
case _FarmCurrentSeason():
return $default(_that.id,_that.status,_that.stockingDate,_that.dayOfCulture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: FarmSeasonStatus.unknown)  FarmSeasonStatus status,  DateTime? stockingDate,  int? dayOfCulture)?  $default,) {final _that = this;
switch (_that) {
case _FarmCurrentSeason() when $default != null:
return $default(_that.id,_that.status,_that.stockingDate,_that.dayOfCulture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmCurrentSeason implements FarmCurrentSeason {
  const _FarmCurrentSeason({required this.id, @JsonKey(unknownEnumValue: FarmSeasonStatus.unknown) required this.status, this.stockingDate, this.dayOfCulture});
  factory _FarmCurrentSeason.fromJson(Map<String, dynamic> json) => _$FarmCurrentSeasonFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: FarmSeasonStatus.unknown) final  FarmSeasonStatus status;
@override final  DateTime? stockingDate;
@override final  int? dayOfCulture;

/// Create a copy of FarmCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmCurrentSeasonCopyWith<_FarmCurrentSeason> get copyWith => __$FarmCurrentSeasonCopyWithImpl<_FarmCurrentSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmCurrentSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmCurrentSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,stockingDate,dayOfCulture);

@override
String toString() {
  return 'FarmCurrentSeason(id: $id, status: $status, stockingDate: $stockingDate, dayOfCulture: $dayOfCulture)';
}


}

/// @nodoc
abstract mixin class _$FarmCurrentSeasonCopyWith<$Res> implements $FarmCurrentSeasonCopyWith<$Res> {
  factory _$FarmCurrentSeasonCopyWith(_FarmCurrentSeason value, $Res Function(_FarmCurrentSeason) _then) = __$FarmCurrentSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: FarmSeasonStatus.unknown) FarmSeasonStatus status, DateTime? stockingDate, int? dayOfCulture
});




}
/// @nodoc
class __$FarmCurrentSeasonCopyWithImpl<$Res>
    implements _$FarmCurrentSeasonCopyWith<$Res> {
  __$FarmCurrentSeasonCopyWithImpl(this._self, this._then);

  final _FarmCurrentSeason _self;
  final $Res Function(_FarmCurrentSeason) _then;

/// Create a copy of FarmCurrentSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? stockingDate = freezed,Object? dayOfCulture = freezed,}) {
  return _then(_FarmCurrentSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FarmSeasonStatus,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FarmPond {

 String get id; String get name; double? get areaM2; double? get depthM; double? get volumeM3;@JsonKey(unknownEnumValue: PondType.unknown) PondType get type;@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus get status; FarmCurrentSeason? get currentSeason;
/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmPondCopyWith<FarmPond> get copyWith => _$FarmPondCopyWithImpl<FarmPond>(this as FarmPond, _$identity);

  /// Serializes this FarmPond to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmPond&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,areaM2,depthM,volumeM3,type,status,currentSeason);

@override
String toString() {
  return 'FarmPond(id: $id, name: $name, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3, type: $type, status: $status, currentSeason: $currentSeason)';
}


}

/// @nodoc
abstract mixin class $FarmPondCopyWith<$Res>  {
  factory $FarmPondCopyWith(FarmPond value, $Res Function(FarmPond) _then) = _$FarmPondCopyWithImpl;
@useResult
$Res call({
 String id, String name, double? areaM2, double? depthM, double? volumeM3,@JsonKey(unknownEnumValue: PondType.unknown) PondType type,@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus status, FarmCurrentSeason? currentSeason
});


$FarmCurrentSeasonCopyWith<$Res>? get currentSeason;

}
/// @nodoc
class _$FarmPondCopyWithImpl<$Res>
    implements $FarmPondCopyWith<$Res> {
  _$FarmPondCopyWithImpl(this._self, this._then);

  final FarmPond _self;
  final $Res Function(FarmPond) _then;

/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,Object? type = null,Object? status = null,Object? currentSeason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PondType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondStatus,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as FarmCurrentSeason?,
  ));
}
/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FarmCurrentSeasonCopyWith<$Res>? get currentSeason {
    if (_self.currentSeason == null) {
    return null;
  }

  return $FarmCurrentSeasonCopyWith<$Res>(_self.currentSeason!, (value) {
    return _then(_self.copyWith(currentSeason: value));
  });
}
}


/// Adds pattern-matching-related methods to [FarmPond].
extension FarmPondPatterns on FarmPond {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmPond value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmPond() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmPond value)  $default,){
final _that = this;
switch (_that) {
case _FarmPond():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmPond value)?  $default,){
final _that = this;
switch (_that) {
case _FarmPond() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  FarmCurrentSeason? currentSeason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmPond() when $default != null:
return $default(_that.id,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.currentSeason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  FarmCurrentSeason? currentSeason)  $default,) {final _that = this;
switch (_that) {
case _FarmPond():
return $default(_that.id,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.currentSeason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double? areaM2,  double? depthM,  double? volumeM3, @JsonKey(unknownEnumValue: PondType.unknown)  PondType type, @JsonKey(unknownEnumValue: PondStatus.unknown)  PondStatus status,  FarmCurrentSeason? currentSeason)?  $default,) {final _that = this;
switch (_that) {
case _FarmPond() when $default != null:
return $default(_that.id,_that.name,_that.areaM2,_that.depthM,_that.volumeM3,_that.type,_that.status,_that.currentSeason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmPond implements FarmPond {
  const _FarmPond({required this.id, required this.name, this.areaM2, this.depthM, this.volumeM3, @JsonKey(unknownEnumValue: PondType.unknown) required this.type, @JsonKey(unknownEnumValue: PondStatus.unknown) required this.status, this.currentSeason});
  factory _FarmPond.fromJson(Map<String, dynamic> json) => _$FarmPondFromJson(json);

@override final  String id;
@override final  String name;
@override final  double? areaM2;
@override final  double? depthM;
@override final  double? volumeM3;
@override@JsonKey(unknownEnumValue: PondType.unknown) final  PondType type;
@override@JsonKey(unknownEnumValue: PondStatus.unknown) final  PondStatus status;
@override final  FarmCurrentSeason? currentSeason;

/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmPondCopyWith<_FarmPond> get copyWith => __$FarmPondCopyWithImpl<_FarmPond>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmPondToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmPond&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,areaM2,depthM,volumeM3,type,status,currentSeason);

@override
String toString() {
  return 'FarmPond(id: $id, name: $name, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3, type: $type, status: $status, currentSeason: $currentSeason)';
}


}

/// @nodoc
abstract mixin class _$FarmPondCopyWith<$Res> implements $FarmPondCopyWith<$Res> {
  factory _$FarmPondCopyWith(_FarmPond value, $Res Function(_FarmPond) _then) = __$FarmPondCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double? areaM2, double? depthM, double? volumeM3,@JsonKey(unknownEnumValue: PondType.unknown) PondType type,@JsonKey(unknownEnumValue: PondStatus.unknown) PondStatus status, FarmCurrentSeason? currentSeason
});


@override $FarmCurrentSeasonCopyWith<$Res>? get currentSeason;

}
/// @nodoc
class __$FarmPondCopyWithImpl<$Res>
    implements _$FarmPondCopyWith<$Res> {
  __$FarmPondCopyWithImpl(this._self, this._then);

  final _FarmPond _self;
  final $Res Function(_FarmPond) _then;

/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,Object? type = null,Object? status = null,Object? currentSeason = freezed,}) {
  return _then(_FarmPond(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PondType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PondStatus,currentSeason: freezed == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as FarmCurrentSeason?,
  ));
}

/// Create a copy of FarmPond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FarmCurrentSeasonCopyWith<$Res>? get currentSeason {
    if (_self.currentSeason == null) {
    return null;
  }

  return $FarmCurrentSeasonCopyWith<$Res>(_self.currentSeason!, (value) {
    return _then(_self.copyWith(currentSeason: value));
  });
}
}


/// @nodoc
mixin _$Farm {

 String get id; String get ownerId; String get name; String? get address; double? get latitude; double? get longitude; double? get totalAreaHectares; int get pondCount; int get activeSeasonCount; bool get canArchive; List<FarmPond> get ponds; DateTime? get archivedAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmCopyWith<Farm> get copyWith => _$FarmCopyWithImpl<Farm>(this as Farm, _$identity);

  /// Serializes this Farm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.totalAreaHectares, totalAreaHectares) || other.totalAreaHectares == totalAreaHectares)&&(identical(other.pondCount, pondCount) || other.pondCount == pondCount)&&(identical(other.activeSeasonCount, activeSeasonCount) || other.activeSeasonCount == activeSeasonCount)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&const DeepCollectionEquality().equals(other.ponds, ponds)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,latitude,longitude,totalAreaHectares,pondCount,activeSeasonCount,canArchive,const DeepCollectionEquality().hash(ponds),archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Farm(id: $id, ownerId: $ownerId, name: $name, address: $address, latitude: $latitude, longitude: $longitude, totalAreaHectares: $totalAreaHectares, pondCount: $pondCount, activeSeasonCount: $activeSeasonCount, canArchive: $canArchive, ponds: $ponds, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FarmCopyWith<$Res>  {
  factory $FarmCopyWith(Farm value, $Res Function(Farm) _then) = _$FarmCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String? address, double? latitude, double? longitude, double? totalAreaHectares, int pondCount, int activeSeasonCount, bool canArchive, List<FarmPond> ponds, DateTime? archivedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$FarmCopyWithImpl<$Res>
    implements $FarmCopyWith<$Res> {
  _$FarmCopyWithImpl(this._self, this._then);

  final Farm _self;
  final $Res Function(Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? totalAreaHectares = freezed,Object? pondCount = null,Object? activeSeasonCount = null,Object? canArchive = null,Object? ponds = null,Object? archivedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,totalAreaHectares: freezed == totalAreaHectares ? _self.totalAreaHectares : totalAreaHectares // ignore: cast_nullable_to_non_nullable
as double?,pondCount: null == pondCount ? _self.pondCount : pondCount // ignore: cast_nullable_to_non_nullable
as int,activeSeasonCount: null == activeSeasonCount ? _self.activeSeasonCount : activeSeasonCount // ignore: cast_nullable_to_non_nullable
as int,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,ponds: null == ponds ? _self.ponds : ponds // ignore: cast_nullable_to_non_nullable
as List<FarmPond>,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Farm].
extension FarmPatterns on Farm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Farm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Farm value)  $default,){
final _that = this;
switch (_that) {
case _Farm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Farm value)?  $default,){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String? address,  double? latitude,  double? longitude,  double? totalAreaHectares,  int pondCount,  int activeSeasonCount,  bool canArchive,  List<FarmPond> ponds,  DateTime? archivedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.latitude,_that.longitude,_that.totalAreaHectares,_that.pondCount,_that.activeSeasonCount,_that.canArchive,_that.ponds,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String? address,  double? latitude,  double? longitude,  double? totalAreaHectares,  int pondCount,  int activeSeasonCount,  bool canArchive,  List<FarmPond> ponds,  DateTime? archivedAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Farm():
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.latitude,_that.longitude,_that.totalAreaHectares,_that.pondCount,_that.activeSeasonCount,_that.canArchive,_that.ponds,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String? address,  double? latitude,  double? longitude,  double? totalAreaHectares,  int pondCount,  int activeSeasonCount,  bool canArchive,  List<FarmPond> ponds,  DateTime? archivedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.latitude,_that.longitude,_that.totalAreaHectares,_that.pondCount,_that.activeSeasonCount,_that.canArchive,_that.ponds,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Farm extends Farm {
  const _Farm({required this.id, required this.ownerId, required this.name, this.address, this.latitude, this.longitude, this.totalAreaHectares, this.pondCount = 0, this.activeSeasonCount = 0, this.canArchive = true, final  List<FarmPond> ponds = const <FarmPond>[], this.archivedAt, this.createdAt, this.updatedAt}): _ponds = ponds,super._();
  factory _Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String name;
@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
@override final  double? totalAreaHectares;
@override@JsonKey() final  int pondCount;
@override@JsonKey() final  int activeSeasonCount;
@override@JsonKey() final  bool canArchive;
 final  List<FarmPond> _ponds;
@override@JsonKey() List<FarmPond> get ponds {
  if (_ponds is EqualUnmodifiableListView) return _ponds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ponds);
}

@override final  DateTime? archivedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmCopyWith<_Farm> get copyWith => __$FarmCopyWithImpl<_Farm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.totalAreaHectares, totalAreaHectares) || other.totalAreaHectares == totalAreaHectares)&&(identical(other.pondCount, pondCount) || other.pondCount == pondCount)&&(identical(other.activeSeasonCount, activeSeasonCount) || other.activeSeasonCount == activeSeasonCount)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&const DeepCollectionEquality().equals(other._ponds, _ponds)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,latitude,longitude,totalAreaHectares,pondCount,activeSeasonCount,canArchive,const DeepCollectionEquality().hash(_ponds),archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Farm(id: $id, ownerId: $ownerId, name: $name, address: $address, latitude: $latitude, longitude: $longitude, totalAreaHectares: $totalAreaHectares, pondCount: $pondCount, activeSeasonCount: $activeSeasonCount, canArchive: $canArchive, ponds: $ponds, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FarmCopyWith<$Res> implements $FarmCopyWith<$Res> {
  factory _$FarmCopyWith(_Farm value, $Res Function(_Farm) _then) = __$FarmCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String? address, double? latitude, double? longitude, double? totalAreaHectares, int pondCount, int activeSeasonCount, bool canArchive, List<FarmPond> ponds, DateTime? archivedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$FarmCopyWithImpl<$Res>
    implements _$FarmCopyWith<$Res> {
  __$FarmCopyWithImpl(this._self, this._then);

  final _Farm _self;
  final $Res Function(_Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? totalAreaHectares = freezed,Object? pondCount = null,Object? activeSeasonCount = null,Object? canArchive = null,Object? ponds = null,Object? archivedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Farm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,totalAreaHectares: freezed == totalAreaHectares ? _self.totalAreaHectares : totalAreaHectares // ignore: cast_nullable_to_non_nullable
as double?,pondCount: null == pondCount ? _self.pondCount : pondCount // ignore: cast_nullable_to_non_nullable
as int,activeSeasonCount: null == activeSeasonCount ? _self.activeSeasonCount : activeSeasonCount // ignore: cast_nullable_to_non_nullable
as int,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,ponds: null == ponds ? _self._ponds : ponds // ignore: cast_nullable_to_non_nullable
as List<FarmPond>,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$FarmPage {

 List<Farm> get items; int get page; int get limit; int get totalResults; int get totalPages;
/// Create a copy of FarmPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmPageCopyWith<FarmPage> get copyWith => _$FarmPageCopyWithImpl<FarmPage>(this as FarmPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,limit,totalResults,totalPages);

@override
String toString() {
  return 'FarmPage(items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $FarmPageCopyWith<$Res>  {
  factory $FarmPageCopyWith(FarmPage value, $Res Function(FarmPage) _then) = _$FarmPageCopyWithImpl;
@useResult
$Res call({
 List<Farm> items, int page, int limit, int totalResults, int totalPages
});




}
/// @nodoc
class _$FarmPageCopyWithImpl<$Res>
    implements $FarmPageCopyWith<$Res> {
  _$FarmPageCopyWithImpl(this._self, this._then);

  final FarmPage _self;
  final $Res Function(FarmPage) _then;

/// Create a copy of FarmPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Farm>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmPage].
extension FarmPagePatterns on FarmPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmPage value)  $default,){
final _that = this;
switch (_that) {
case _FarmPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmPage value)?  $default,){
final _that = this;
switch (_that) {
case _FarmPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Farm> items,  int page,  int limit,  int totalResults,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmPage() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Farm> items,  int page,  int limit,  int totalResults,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _FarmPage():
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Farm> items,  int page,  int limit,  int totalResults,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _FarmPage() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _FarmPage extends FarmPage {
  const _FarmPage({required final  List<Farm> items, required this.page, required this.limit, required this.totalResults, required this.totalPages}): _items = items,super._();
  

 final  List<Farm> _items;
@override List<Farm> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int limit;
@override final  int totalResults;
@override final  int totalPages;

/// Create a copy of FarmPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmPageCopyWith<_FarmPage> get copyWith => __$FarmPageCopyWithImpl<_FarmPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,limit,totalResults,totalPages);

@override
String toString() {
  return 'FarmPage(items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$FarmPageCopyWith<$Res> implements $FarmPageCopyWith<$Res> {
  factory _$FarmPageCopyWith(_FarmPage value, $Res Function(_FarmPage) _then) = __$FarmPageCopyWithImpl;
@override @useResult
$Res call({
 List<Farm> items, int page, int limit, int totalResults, int totalPages
});




}
/// @nodoc
class __$FarmPageCopyWithImpl<$Res>
    implements _$FarmPageCopyWith<$Res> {
  __$FarmPageCopyWithImpl(this._self, this._then);

  final _FarmPage _self;
  final $Res Function(_FarmPage) _then;

/// Create a copy of FarmPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,}) {
  return _then(_FarmPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Farm>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
