// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assigned_season_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssignedSeasonPersonnel {

 String get role; String get name; String? get avatarUrl;
/// Create a copy of AssignedSeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignedSeasonPersonnelCopyWith<AssignedSeasonPersonnel> get copyWith => _$AssignedSeasonPersonnelCopyWithImpl<AssignedSeasonPersonnel>(this as AssignedSeasonPersonnel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignedSeasonPersonnel&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,role,name,avatarUrl);

@override
String toString() {
  return 'AssignedSeasonPersonnel(role: $role, name: $name, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $AssignedSeasonPersonnelCopyWith<$Res>  {
  factory $AssignedSeasonPersonnelCopyWith(AssignedSeasonPersonnel value, $Res Function(AssignedSeasonPersonnel) _then) = _$AssignedSeasonPersonnelCopyWithImpl;
@useResult
$Res call({
 String role, String name, String? avatarUrl
});




}
/// @nodoc
class _$AssignedSeasonPersonnelCopyWithImpl<$Res>
    implements $AssignedSeasonPersonnelCopyWith<$Res> {
  _$AssignedSeasonPersonnelCopyWithImpl(this._self, this._then);

  final AssignedSeasonPersonnel _self;
  final $Res Function(AssignedSeasonPersonnel) _then;

/// Create a copy of AssignedSeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? name = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignedSeasonPersonnel].
extension AssignedSeasonPersonnelPatterns on AssignedSeasonPersonnel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignedSeasonPersonnel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignedSeasonPersonnel value)  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignedSeasonPersonnel value)?  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String name,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel() when $default != null:
return $default(_that.role,_that.name,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String name,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel():
return $default(_that.role,_that.name,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String name,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonPersonnel() when $default != null:
return $default(_that.role,_that.name,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AssignedSeasonPersonnel implements AssignedSeasonPersonnel {
  const _AssignedSeasonPersonnel({required this.role, required this.name, this.avatarUrl});
  

@override final  String role;
@override final  String name;
@override final  String? avatarUrl;

/// Create a copy of AssignedSeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignedSeasonPersonnelCopyWith<_AssignedSeasonPersonnel> get copyWith => __$AssignedSeasonPersonnelCopyWithImpl<_AssignedSeasonPersonnel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignedSeasonPersonnel&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,role,name,avatarUrl);

@override
String toString() {
  return 'AssignedSeasonPersonnel(role: $role, name: $name, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$AssignedSeasonPersonnelCopyWith<$Res> implements $AssignedSeasonPersonnelCopyWith<$Res> {
  factory _$AssignedSeasonPersonnelCopyWith(_AssignedSeasonPersonnel value, $Res Function(_AssignedSeasonPersonnel) _then) = __$AssignedSeasonPersonnelCopyWithImpl;
@override @useResult
$Res call({
 String role, String name, String? avatarUrl
});




}
/// @nodoc
class __$AssignedSeasonPersonnelCopyWithImpl<$Res>
    implements _$AssignedSeasonPersonnelCopyWith<$Res> {
  __$AssignedSeasonPersonnelCopyWithImpl(this._self, this._then);

  final _AssignedSeasonPersonnel _self;
  final $Res Function(_AssignedSeasonPersonnel) _then;

/// Create a copy of AssignedSeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? name = null,Object? avatarUrl = freezed,}) {
  return _then(_AssignedSeasonPersonnel(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$OtherAssignedSeason {

 String get id; String get name; String get status; DateTime get assignedAt; String get pondId; String get pondName; String get pondStatus; double? get pondAreaM2; double? get pondVolumeM3;
/// Create a copy of OtherAssignedSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtherAssignedSeasonCopyWith<OtherAssignedSeason> get copyWith => _$OtherAssignedSeasonCopyWithImpl<OtherAssignedSeason>(this as OtherAssignedSeason, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtherAssignedSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.pondStatus, pondStatus) || other.pondStatus == pondStatus)&&(identical(other.pondAreaM2, pondAreaM2) || other.pondAreaM2 == pondAreaM2)&&(identical(other.pondVolumeM3, pondVolumeM3) || other.pondVolumeM3 == pondVolumeM3));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,assignedAt,pondId,pondName,pondStatus,pondAreaM2,pondVolumeM3);

@override
String toString() {
  return 'OtherAssignedSeason(id: $id, name: $name, status: $status, assignedAt: $assignedAt, pondId: $pondId, pondName: $pondName, pondStatus: $pondStatus, pondAreaM2: $pondAreaM2, pondVolumeM3: $pondVolumeM3)';
}


}

/// @nodoc
abstract mixin class $OtherAssignedSeasonCopyWith<$Res>  {
  factory $OtherAssignedSeasonCopyWith(OtherAssignedSeason value, $Res Function(OtherAssignedSeason) _then) = _$OtherAssignedSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, DateTime assignedAt, String pondId, String pondName, String pondStatus, double? pondAreaM2, double? pondVolumeM3
});




}
/// @nodoc
class _$OtherAssignedSeasonCopyWithImpl<$Res>
    implements $OtherAssignedSeasonCopyWith<$Res> {
  _$OtherAssignedSeasonCopyWithImpl(this._self, this._then);

  final OtherAssignedSeason _self;
  final $Res Function(OtherAssignedSeason) _then;

/// Create a copy of OtherAssignedSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? assignedAt = null,Object? pondId = null,Object? pondName = null,Object? pondStatus = null,Object? pondAreaM2 = freezed,Object? pondVolumeM3 = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,pondStatus: null == pondStatus ? _self.pondStatus : pondStatus // ignore: cast_nullable_to_non_nullable
as String,pondAreaM2: freezed == pondAreaM2 ? _self.pondAreaM2 : pondAreaM2 // ignore: cast_nullable_to_non_nullable
as double?,pondVolumeM3: freezed == pondVolumeM3 ? _self.pondVolumeM3 : pondVolumeM3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtherAssignedSeason].
extension OtherAssignedSeasonPatterns on OtherAssignedSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtherAssignedSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtherAssignedSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtherAssignedSeason value)  $default,){
final _that = this;
switch (_that) {
case _OtherAssignedSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtherAssignedSeason value)?  $default,){
final _that = this;
switch (_that) {
case _OtherAssignedSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  DateTime assignedAt,  String pondId,  String pondName,  String pondStatus,  double? pondAreaM2,  double? pondVolumeM3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtherAssignedSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.assignedAt,_that.pondId,_that.pondName,_that.pondStatus,_that.pondAreaM2,_that.pondVolumeM3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  DateTime assignedAt,  String pondId,  String pondName,  String pondStatus,  double? pondAreaM2,  double? pondVolumeM3)  $default,) {final _that = this;
switch (_that) {
case _OtherAssignedSeason():
return $default(_that.id,_that.name,_that.status,_that.assignedAt,_that.pondId,_that.pondName,_that.pondStatus,_that.pondAreaM2,_that.pondVolumeM3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  DateTime assignedAt,  String pondId,  String pondName,  String pondStatus,  double? pondAreaM2,  double? pondVolumeM3)?  $default,) {final _that = this;
switch (_that) {
case _OtherAssignedSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.assignedAt,_that.pondId,_that.pondName,_that.pondStatus,_that.pondAreaM2,_that.pondVolumeM3);case _:
  return null;

}
}

}

/// @nodoc


class _OtherAssignedSeason implements OtherAssignedSeason {
  const _OtherAssignedSeason({required this.id, required this.name, required this.status, required this.assignedAt, required this.pondId, required this.pondName, required this.pondStatus, this.pondAreaM2, this.pondVolumeM3});
  

@override final  String id;
@override final  String name;
@override final  String status;
@override final  DateTime assignedAt;
@override final  String pondId;
@override final  String pondName;
@override final  String pondStatus;
@override final  double? pondAreaM2;
@override final  double? pondVolumeM3;

/// Create a copy of OtherAssignedSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtherAssignedSeasonCopyWith<_OtherAssignedSeason> get copyWith => __$OtherAssignedSeasonCopyWithImpl<_OtherAssignedSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtherAssignedSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.pondStatus, pondStatus) || other.pondStatus == pondStatus)&&(identical(other.pondAreaM2, pondAreaM2) || other.pondAreaM2 == pondAreaM2)&&(identical(other.pondVolumeM3, pondVolumeM3) || other.pondVolumeM3 == pondVolumeM3));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,assignedAt,pondId,pondName,pondStatus,pondAreaM2,pondVolumeM3);

@override
String toString() {
  return 'OtherAssignedSeason(id: $id, name: $name, status: $status, assignedAt: $assignedAt, pondId: $pondId, pondName: $pondName, pondStatus: $pondStatus, pondAreaM2: $pondAreaM2, pondVolumeM3: $pondVolumeM3)';
}


}

/// @nodoc
abstract mixin class _$OtherAssignedSeasonCopyWith<$Res> implements $OtherAssignedSeasonCopyWith<$Res> {
  factory _$OtherAssignedSeasonCopyWith(_OtherAssignedSeason value, $Res Function(_OtherAssignedSeason) _then) = __$OtherAssignedSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, DateTime assignedAt, String pondId, String pondName, String pondStatus, double? pondAreaM2, double? pondVolumeM3
});




}
/// @nodoc
class __$OtherAssignedSeasonCopyWithImpl<$Res>
    implements _$OtherAssignedSeasonCopyWith<$Res> {
  __$OtherAssignedSeasonCopyWithImpl(this._self, this._then);

  final _OtherAssignedSeason _self;
  final $Res Function(_OtherAssignedSeason) _then;

/// Create a copy of OtherAssignedSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? assignedAt = null,Object? pondId = null,Object? pondName = null,Object? pondStatus = null,Object? pondAreaM2 = freezed,Object? pondVolumeM3 = freezed,}) {
  return _then(_OtherAssignedSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,pondStatus: null == pondStatus ? _self.pondStatus : pondStatus // ignore: cast_nullable_to_non_nullable
as String,pondAreaM2: freezed == pondAreaM2 ? _self.pondAreaM2 : pondAreaM2 // ignore: cast_nullable_to_non_nullable
as double?,pondVolumeM3: freezed == pondVolumeM3 ? _self.pondVolumeM3 : pondVolumeM3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$AssignedSeasonDetail {

 String get id; String get name; AssignedSeasonStatus get status; String get shrimpType; String get pondId; String get pondName; String get pondType; String get pondStatus; String get farmId; String get farmName; List<AssignedSeasonPersonnel> get personnel; List<OtherAssignedSeason> get otherAssignedSeasons; DateTime get assignedAt; String? get farmAddress; DateTime? get stockingDate; DateTime? get expectedEndDate; int? get initialQuantity; double? get initialDensityPerM2; double? get currentBiomassKg; double? get areaM2; double? get depthM; double? get volumeM3;
/// Create a copy of AssignedSeasonDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignedSeasonDetailCopyWith<AssignedSeasonDetail> get copyWith => _$AssignedSeasonDetailCopyWithImpl<AssignedSeasonDetail>(this as AssignedSeasonDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignedSeasonDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.pondType, pondType) || other.pondType == pondType)&&(identical(other.pondStatus, pondStatus) || other.pondStatus == pondStatus)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&const DeepCollectionEquality().equals(other.personnel, personnel)&&const DeepCollectionEquality().equals(other.otherAssignedSeasons, otherAssignedSeasons)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.farmAddress, farmAddress) || other.farmAddress == farmAddress)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.initialQuantity, initialQuantity) || other.initialQuantity == initialQuantity)&&(identical(other.initialDensityPerM2, initialDensityPerM2) || other.initialDensityPerM2 == initialDensityPerM2)&&(identical(other.currentBiomassKg, currentBiomassKg) || other.currentBiomassKg == currentBiomassKg)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,shrimpType,pondId,pondName,pondType,pondStatus,farmId,farmName,const DeepCollectionEquality().hash(personnel),const DeepCollectionEquality().hash(otherAssignedSeasons),assignedAt,farmAddress,stockingDate,expectedEndDate,initialQuantity,initialDensityPerM2,currentBiomassKg,areaM2,depthM,volumeM3]);

@override
String toString() {
  return 'AssignedSeasonDetail(id: $id, name: $name, status: $status, shrimpType: $shrimpType, pondId: $pondId, pondName: $pondName, pondType: $pondType, pondStatus: $pondStatus, farmId: $farmId, farmName: $farmName, personnel: $personnel, otherAssignedSeasons: $otherAssignedSeasons, assignedAt: $assignedAt, farmAddress: $farmAddress, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, initialQuantity: $initialQuantity, initialDensityPerM2: $initialDensityPerM2, currentBiomassKg: $currentBiomassKg, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3)';
}


}

/// @nodoc
abstract mixin class $AssignedSeasonDetailCopyWith<$Res>  {
  factory $AssignedSeasonDetailCopyWith(AssignedSeasonDetail value, $Res Function(AssignedSeasonDetail) _then) = _$AssignedSeasonDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, AssignedSeasonStatus status, String shrimpType, String pondId, String pondName, String pondType, String pondStatus, String farmId, String farmName, List<AssignedSeasonPersonnel> personnel, List<OtherAssignedSeason> otherAssignedSeasons, DateTime assignedAt, String? farmAddress, DateTime? stockingDate, DateTime? expectedEndDate, int? initialQuantity, double? initialDensityPerM2, double? currentBiomassKg, double? areaM2, double? depthM, double? volumeM3
});




}
/// @nodoc
class _$AssignedSeasonDetailCopyWithImpl<$Res>
    implements $AssignedSeasonDetailCopyWith<$Res> {
  _$AssignedSeasonDetailCopyWithImpl(this._self, this._then);

  final AssignedSeasonDetail _self;
  final $Res Function(AssignedSeasonDetail) _then;

/// Create a copy of AssignedSeasonDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? shrimpType = null,Object? pondId = null,Object? pondName = null,Object? pondType = null,Object? pondStatus = null,Object? farmId = null,Object? farmName = null,Object? personnel = null,Object? otherAssignedSeasons = null,Object? assignedAt = null,Object? farmAddress = freezed,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? initialQuantity = freezed,Object? initialDensityPerM2 = freezed,Object? currentBiomassKg = freezed,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssignedSeasonStatus,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,pondType: null == pondType ? _self.pondType : pondType // ignore: cast_nullable_to_non_nullable
as String,pondStatus: null == pondStatus ? _self.pondStatus : pondStatus // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,personnel: null == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as List<AssignedSeasonPersonnel>,otherAssignedSeasons: null == otherAssignedSeasons ? _self.otherAssignedSeasons : otherAssignedSeasons // ignore: cast_nullable_to_non_nullable
as List<OtherAssignedSeason>,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,farmAddress: freezed == farmAddress ? _self.farmAddress : farmAddress // ignore: cast_nullable_to_non_nullable
as String?,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialQuantity: freezed == initialQuantity ? _self.initialQuantity : initialQuantity // ignore: cast_nullable_to_non_nullable
as int?,initialDensityPerM2: freezed == initialDensityPerM2 ? _self.initialDensityPerM2 : initialDensityPerM2 // ignore: cast_nullable_to_non_nullable
as double?,currentBiomassKg: freezed == currentBiomassKg ? _self.currentBiomassKg : currentBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignedSeasonDetail].
extension AssignedSeasonDetailPatterns on AssignedSeasonDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignedSeasonDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignedSeasonDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignedSeasonDetail value)  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignedSeasonDetail value)?  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String pondType,  String pondStatus,  String farmId,  String farmName,  List<AssignedSeasonPersonnel> personnel,  List<OtherAssignedSeason> otherAssignedSeasons,  DateTime assignedAt,  String? farmAddress,  DateTime? stockingDate,  DateTime? expectedEndDate,  int? initialQuantity,  double? initialDensityPerM2,  double? currentBiomassKg,  double? areaM2,  double? depthM,  double? volumeM3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignedSeasonDetail() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.pondType,_that.pondStatus,_that.farmId,_that.farmName,_that.personnel,_that.otherAssignedSeasons,_that.assignedAt,_that.farmAddress,_that.stockingDate,_that.expectedEndDate,_that.initialQuantity,_that.initialDensityPerM2,_that.currentBiomassKg,_that.areaM2,_that.depthM,_that.volumeM3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String pondType,  String pondStatus,  String farmId,  String farmName,  List<AssignedSeasonPersonnel> personnel,  List<OtherAssignedSeason> otherAssignedSeasons,  DateTime assignedAt,  String? farmAddress,  DateTime? stockingDate,  DateTime? expectedEndDate,  int? initialQuantity,  double? initialDensityPerM2,  double? currentBiomassKg,  double? areaM2,  double? depthM,  double? volumeM3)  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonDetail():
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.pondType,_that.pondStatus,_that.farmId,_that.farmName,_that.personnel,_that.otherAssignedSeasons,_that.assignedAt,_that.farmAddress,_that.stockingDate,_that.expectedEndDate,_that.initialQuantity,_that.initialDensityPerM2,_that.currentBiomassKg,_that.areaM2,_that.depthM,_that.volumeM3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String pondType,  String pondStatus,  String farmId,  String farmName,  List<AssignedSeasonPersonnel> personnel,  List<OtherAssignedSeason> otherAssignedSeasons,  DateTime assignedAt,  String? farmAddress,  DateTime? stockingDate,  DateTime? expectedEndDate,  int? initialQuantity,  double? initialDensityPerM2,  double? currentBiomassKg,  double? areaM2,  double? depthM,  double? volumeM3)?  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonDetail() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.pondType,_that.pondStatus,_that.farmId,_that.farmName,_that.personnel,_that.otherAssignedSeasons,_that.assignedAt,_that.farmAddress,_that.stockingDate,_that.expectedEndDate,_that.initialQuantity,_that.initialDensityPerM2,_that.currentBiomassKg,_that.areaM2,_that.depthM,_that.volumeM3);case _:
  return null;

}
}

}

/// @nodoc


class _AssignedSeasonDetail extends AssignedSeasonDetail {
  const _AssignedSeasonDetail({required this.id, required this.name, required this.status, required this.shrimpType, required this.pondId, required this.pondName, required this.pondType, required this.pondStatus, required this.farmId, required this.farmName, required final  List<AssignedSeasonPersonnel> personnel, required final  List<OtherAssignedSeason> otherAssignedSeasons, required this.assignedAt, this.farmAddress, this.stockingDate, this.expectedEndDate, this.initialQuantity, this.initialDensityPerM2, this.currentBiomassKg, this.areaM2, this.depthM, this.volumeM3}): _personnel = personnel,_otherAssignedSeasons = otherAssignedSeasons,super._();
  

@override final  String id;
@override final  String name;
@override final  AssignedSeasonStatus status;
@override final  String shrimpType;
@override final  String pondId;
@override final  String pondName;
@override final  String pondType;
@override final  String pondStatus;
@override final  String farmId;
@override final  String farmName;
 final  List<AssignedSeasonPersonnel> _personnel;
@override List<AssignedSeasonPersonnel> get personnel {
  if (_personnel is EqualUnmodifiableListView) return _personnel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personnel);
}

 final  List<OtherAssignedSeason> _otherAssignedSeasons;
@override List<OtherAssignedSeason> get otherAssignedSeasons {
  if (_otherAssignedSeasons is EqualUnmodifiableListView) return _otherAssignedSeasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherAssignedSeasons);
}

@override final  DateTime assignedAt;
@override final  String? farmAddress;
@override final  DateTime? stockingDate;
@override final  DateTime? expectedEndDate;
@override final  int? initialQuantity;
@override final  double? initialDensityPerM2;
@override final  double? currentBiomassKg;
@override final  double? areaM2;
@override final  double? depthM;
@override final  double? volumeM3;

/// Create a copy of AssignedSeasonDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignedSeasonDetailCopyWith<_AssignedSeasonDetail> get copyWith => __$AssignedSeasonDetailCopyWithImpl<_AssignedSeasonDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignedSeasonDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.pondType, pondType) || other.pondType == pondType)&&(identical(other.pondStatus, pondStatus) || other.pondStatus == pondStatus)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&const DeepCollectionEquality().equals(other._personnel, _personnel)&&const DeepCollectionEquality().equals(other._otherAssignedSeasons, _otherAssignedSeasons)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.farmAddress, farmAddress) || other.farmAddress == farmAddress)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.initialQuantity, initialQuantity) || other.initialQuantity == initialQuantity)&&(identical(other.initialDensityPerM2, initialDensityPerM2) || other.initialDensityPerM2 == initialDensityPerM2)&&(identical(other.currentBiomassKg, currentBiomassKg) || other.currentBiomassKg == currentBiomassKg)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.depthM, depthM) || other.depthM == depthM)&&(identical(other.volumeM3, volumeM3) || other.volumeM3 == volumeM3));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,status,shrimpType,pondId,pondName,pondType,pondStatus,farmId,farmName,const DeepCollectionEquality().hash(_personnel),const DeepCollectionEquality().hash(_otherAssignedSeasons),assignedAt,farmAddress,stockingDate,expectedEndDate,initialQuantity,initialDensityPerM2,currentBiomassKg,areaM2,depthM,volumeM3]);

@override
String toString() {
  return 'AssignedSeasonDetail(id: $id, name: $name, status: $status, shrimpType: $shrimpType, pondId: $pondId, pondName: $pondName, pondType: $pondType, pondStatus: $pondStatus, farmId: $farmId, farmName: $farmName, personnel: $personnel, otherAssignedSeasons: $otherAssignedSeasons, assignedAt: $assignedAt, farmAddress: $farmAddress, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, initialQuantity: $initialQuantity, initialDensityPerM2: $initialDensityPerM2, currentBiomassKg: $currentBiomassKg, areaM2: $areaM2, depthM: $depthM, volumeM3: $volumeM3)';
}


}

/// @nodoc
abstract mixin class _$AssignedSeasonDetailCopyWith<$Res> implements $AssignedSeasonDetailCopyWith<$Res> {
  factory _$AssignedSeasonDetailCopyWith(_AssignedSeasonDetail value, $Res Function(_AssignedSeasonDetail) _then) = __$AssignedSeasonDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AssignedSeasonStatus status, String shrimpType, String pondId, String pondName, String pondType, String pondStatus, String farmId, String farmName, List<AssignedSeasonPersonnel> personnel, List<OtherAssignedSeason> otherAssignedSeasons, DateTime assignedAt, String? farmAddress, DateTime? stockingDate, DateTime? expectedEndDate, int? initialQuantity, double? initialDensityPerM2, double? currentBiomassKg, double? areaM2, double? depthM, double? volumeM3
});




}
/// @nodoc
class __$AssignedSeasonDetailCopyWithImpl<$Res>
    implements _$AssignedSeasonDetailCopyWith<$Res> {
  __$AssignedSeasonDetailCopyWithImpl(this._self, this._then);

  final _AssignedSeasonDetail _self;
  final $Res Function(_AssignedSeasonDetail) _then;

/// Create a copy of AssignedSeasonDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? shrimpType = null,Object? pondId = null,Object? pondName = null,Object? pondType = null,Object? pondStatus = null,Object? farmId = null,Object? farmName = null,Object? personnel = null,Object? otherAssignedSeasons = null,Object? assignedAt = null,Object? farmAddress = freezed,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? initialQuantity = freezed,Object? initialDensityPerM2 = freezed,Object? currentBiomassKg = freezed,Object? areaM2 = freezed,Object? depthM = freezed,Object? volumeM3 = freezed,}) {
  return _then(_AssignedSeasonDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssignedSeasonStatus,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,pondType: null == pondType ? _self.pondType : pondType // ignore: cast_nullable_to_non_nullable
as String,pondStatus: null == pondStatus ? _self.pondStatus : pondStatus // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,personnel: null == personnel ? _self._personnel : personnel // ignore: cast_nullable_to_non_nullable
as List<AssignedSeasonPersonnel>,otherAssignedSeasons: null == otherAssignedSeasons ? _self._otherAssignedSeasons : otherAssignedSeasons // ignore: cast_nullable_to_non_nullable
as List<OtherAssignedSeason>,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,farmAddress: freezed == farmAddress ? _self.farmAddress : farmAddress // ignore: cast_nullable_to_non_nullable
as String?,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialQuantity: freezed == initialQuantity ? _self.initialQuantity : initialQuantity // ignore: cast_nullable_to_non_nullable
as int?,initialDensityPerM2: freezed == initialDensityPerM2 ? _self.initialDensityPerM2 : initialDensityPerM2 // ignore: cast_nullable_to_non_nullable
as double?,currentBiomassKg: freezed == currentBiomassKg ? _self.currentBiomassKg : currentBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,depthM: freezed == depthM ? _self.depthM : depthM // ignore: cast_nullable_to_non_nullable
as double?,volumeM3: freezed == volumeM3 ? _self.volumeM3 : volumeM3 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
