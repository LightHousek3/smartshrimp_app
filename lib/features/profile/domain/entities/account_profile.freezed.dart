// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountProfile {

 String get id; String get email; String? get fullName; String? get phone; String? get avatarUrl;@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole get role;@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus get status; String? get managedByOwnerId; ManagedOwner? get managedByOwner; TechnicianKpi? get technicianKpi; DateTime? get activatedAt; DateTime? get lastLoginAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountProfileCopyWith<AccountProfile> get copyWith => _$AccountProfileCopyWithImpl<AccountProfile>(this as AccountProfile, _$identity);

  /// Serializes this AccountProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.managedByOwnerId, managedByOwnerId) || other.managedByOwnerId == managedByOwnerId)&&(identical(other.managedByOwner, managedByOwner) || other.managedByOwner == managedByOwner)&&(identical(other.technicianKpi, technicianKpi) || other.technicianKpi == technicianKpi)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,avatarUrl,role,status,managedByOwnerId,managedByOwner,technicianKpi,activatedAt,lastLoginAt,createdAt,updatedAt);

@override
String toString() {
  return 'AccountProfile(id: $id, email: $email, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, role: $role, status: $status, managedByOwnerId: $managedByOwnerId, managedByOwner: $managedByOwner, technicianKpi: $technicianKpi, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AccountProfileCopyWith<$Res>  {
  factory $AccountProfileCopyWith(AccountProfile value, $Res Function(AccountProfile) _then) = _$AccountProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? fullName, String? phone, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, String? managedByOwnerId, ManagedOwner? managedByOwner, TechnicianKpi? technicianKpi, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? createdAt, DateTime? updatedAt
});


$ManagedOwnerCopyWith<$Res>? get managedByOwner;$TechnicianKpiCopyWith<$Res>? get technicianKpi;

}
/// @nodoc
class _$AccountProfileCopyWithImpl<$Res>
    implements $AccountProfileCopyWith<$Res> {
  _$AccountProfileCopyWithImpl(this._self, this._then);

  final AccountProfile _self;
  final $Res Function(AccountProfile) _then;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? managedByOwnerId = freezed,Object? managedByOwner = freezed,Object? technicianKpi = freezed,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,managedByOwnerId: freezed == managedByOwnerId ? _self.managedByOwnerId : managedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,managedByOwner: freezed == managedByOwner ? _self.managedByOwner : managedByOwner // ignore: cast_nullable_to_non_nullable
as ManagedOwner?,technicianKpi: freezed == technicianKpi ? _self.technicianKpi : technicianKpi // ignore: cast_nullable_to_non_nullable
as TechnicianKpi?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManagedOwnerCopyWith<$Res>? get managedByOwner {
    if (_self.managedByOwner == null) {
    return null;
  }

  return $ManagedOwnerCopyWith<$Res>(_self.managedByOwner!, (value) {
    return _then(_self.copyWith(managedByOwner: value));
  });
}/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TechnicianKpiCopyWith<$Res>? get technicianKpi {
    if (_self.technicianKpi == null) {
    return null;
  }

  return $TechnicianKpiCopyWith<$Res>(_self.technicianKpi!, (value) {
    return _then(_self.copyWith(technicianKpi: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountProfile].
extension AccountProfilePatterns on AccountProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountProfile value)  $default,){
final _that = this;
switch (_that) {
case _AccountProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  ManagedOwner? managedByOwner,  TechnicianKpi? technicianKpi,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.managedByOwner,_that.technicianKpi,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  ManagedOwner? managedByOwner,  TechnicianKpi? technicianKpi,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AccountProfile():
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.managedByOwner,_that.technicianKpi,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  ManagedOwner? managedByOwner,  TechnicianKpi? technicianKpi,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.managedByOwner,_that.technicianKpi,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AccountProfile extends AccountProfile {
  const _AccountProfile({required this.id, required this.email, this.fullName, this.phone, this.avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown) required this.role, @JsonKey(unknownEnumValue: AccountStatus.unknown) required this.status, this.managedByOwnerId, this.managedByOwner, this.technicianKpi, this.activatedAt, this.lastLoginAt, this.createdAt, this.updatedAt}): super._();
  factory _AccountProfile.fromJson(Map<String, dynamic> json) => _$AccountProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? fullName;
@override final  String? phone;
@override final  String? avatarUrl;
@override@JsonKey(unknownEnumValue: AccountRole.unknown) final  AccountRole role;
@override@JsonKey(unknownEnumValue: AccountStatus.unknown) final  AccountStatus status;
@override final  String? managedByOwnerId;
@override final  ManagedOwner? managedByOwner;
@override final  TechnicianKpi? technicianKpi;
@override final  DateTime? activatedAt;
@override final  DateTime? lastLoginAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountProfileCopyWith<_AccountProfile> get copyWith => __$AccountProfileCopyWithImpl<_AccountProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.managedByOwnerId, managedByOwnerId) || other.managedByOwnerId == managedByOwnerId)&&(identical(other.managedByOwner, managedByOwner) || other.managedByOwner == managedByOwner)&&(identical(other.technicianKpi, technicianKpi) || other.technicianKpi == technicianKpi)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,avatarUrl,role,status,managedByOwnerId,managedByOwner,technicianKpi,activatedAt,lastLoginAt,createdAt,updatedAt);

@override
String toString() {
  return 'AccountProfile(id: $id, email: $email, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, role: $role, status: $status, managedByOwnerId: $managedByOwnerId, managedByOwner: $managedByOwner, technicianKpi: $technicianKpi, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AccountProfileCopyWith<$Res> implements $AccountProfileCopyWith<$Res> {
  factory _$AccountProfileCopyWith(_AccountProfile value, $Res Function(_AccountProfile) _then) = __$AccountProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? fullName, String? phone, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, String? managedByOwnerId, ManagedOwner? managedByOwner, TechnicianKpi? technicianKpi, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? createdAt, DateTime? updatedAt
});


@override $ManagedOwnerCopyWith<$Res>? get managedByOwner;@override $TechnicianKpiCopyWith<$Res>? get technicianKpi;

}
/// @nodoc
class __$AccountProfileCopyWithImpl<$Res>
    implements _$AccountProfileCopyWith<$Res> {
  __$AccountProfileCopyWithImpl(this._self, this._then);

  final _AccountProfile _self;
  final $Res Function(_AccountProfile) _then;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? managedByOwnerId = freezed,Object? managedByOwner = freezed,Object? technicianKpi = freezed,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AccountProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,managedByOwnerId: freezed == managedByOwnerId ? _self.managedByOwnerId : managedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,managedByOwner: freezed == managedByOwner ? _self.managedByOwner : managedByOwner // ignore: cast_nullable_to_non_nullable
as ManagedOwner?,technicianKpi: freezed == technicianKpi ? _self.technicianKpi : technicianKpi // ignore: cast_nullable_to_non_nullable
as TechnicianKpi?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ManagedOwnerCopyWith<$Res>? get managedByOwner {
    if (_self.managedByOwner == null) {
    return null;
  }

  return $ManagedOwnerCopyWith<$Res>(_self.managedByOwner!, (value) {
    return _then(_self.copyWith(managedByOwner: value));
  });
}/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TechnicianKpiCopyWith<$Res>? get technicianKpi {
    if (_self.technicianKpi == null) {
    return null;
  }

  return $TechnicianKpiCopyWith<$Res>(_self.technicianKpi!, (value) {
    return _then(_self.copyWith(technicianKpi: value));
  });
}
}


/// @nodoc
mixin _$ManagedOwner {

 String get id; String get email; String? get fullName; String? get avatarUrl;
/// Create a copy of ManagedOwner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedOwnerCopyWith<ManagedOwner> get copyWith => _$ManagedOwnerCopyWithImpl<ManagedOwner>(this as ManagedOwner, _$identity);

  /// Serializes this ManagedOwner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,avatarUrl);

@override
String toString() {
  return 'ManagedOwner(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ManagedOwnerCopyWith<$Res>  {
  factory $ManagedOwnerCopyWith(ManagedOwner value, $Res Function(ManagedOwner) _then) = _$ManagedOwnerCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? fullName, String? avatarUrl
});




}
/// @nodoc
class _$ManagedOwnerCopyWithImpl<$Res>
    implements $ManagedOwnerCopyWith<$Res> {
  _$ManagedOwnerCopyWithImpl(this._self, this._then);

  final ManagedOwner _self;
  final $Res Function(ManagedOwner) _then;

/// Create a copy of ManagedOwner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedOwner].
extension ManagedOwnerPatterns on ManagedOwner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedOwner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedOwner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedOwner value)  $default,){
final _that = this;
switch (_that) {
case _ManagedOwner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedOwner value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedOwner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedOwner() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ManagedOwner():
return $default(_that.id,_that.email,_that.fullName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? fullName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ManagedOwner() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedOwner extends ManagedOwner {
  const _ManagedOwner({required this.id, required this.email, this.fullName, this.avatarUrl}): super._();
  factory _ManagedOwner.fromJson(Map<String, dynamic> json) => _$ManagedOwnerFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? fullName;
@override final  String? avatarUrl;

/// Create a copy of ManagedOwner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedOwnerCopyWith<_ManagedOwner> get copyWith => __$ManagedOwnerCopyWithImpl<_ManagedOwner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagedOwnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,avatarUrl);

@override
String toString() {
  return 'ManagedOwner(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ManagedOwnerCopyWith<$Res> implements $ManagedOwnerCopyWith<$Res> {
  factory _$ManagedOwnerCopyWith(_ManagedOwner value, $Res Function(_ManagedOwner) _then) = __$ManagedOwnerCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? fullName, String? avatarUrl
});




}
/// @nodoc
class __$ManagedOwnerCopyWithImpl<$Res>
    implements _$ManagedOwnerCopyWith<$Res> {
  __$ManagedOwnerCopyWithImpl(this._self, this._then);

  final _ManagedOwner _self;
  final $Res Function(_ManagedOwner) _then;

/// Create a copy of ManagedOwner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ManagedOwner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TechnicianKpi {

 int get seasonsParticipated; int get completedTasks; int get onTimeCompletedTasks; double? get onTimeCompletionRatePct;
/// Create a copy of TechnicianKpi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianKpiCopyWith<TechnicianKpi> get copyWith => _$TechnicianKpiCopyWithImpl<TechnicianKpi>(this as TechnicianKpi, _$identity);

  /// Serializes this TechnicianKpi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianKpi&&(identical(other.seasonsParticipated, seasonsParticipated) || other.seasonsParticipated == seasonsParticipated)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.onTimeCompletedTasks, onTimeCompletedTasks) || other.onTimeCompletedTasks == onTimeCompletedTasks)&&(identical(other.onTimeCompletionRatePct, onTimeCompletionRatePct) || other.onTimeCompletionRatePct == onTimeCompletionRatePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonsParticipated,completedTasks,onTimeCompletedTasks,onTimeCompletionRatePct);

@override
String toString() {
  return 'TechnicianKpi(seasonsParticipated: $seasonsParticipated, completedTasks: $completedTasks, onTimeCompletedTasks: $onTimeCompletedTasks, onTimeCompletionRatePct: $onTimeCompletionRatePct)';
}


}

/// @nodoc
abstract mixin class $TechnicianKpiCopyWith<$Res>  {
  factory $TechnicianKpiCopyWith(TechnicianKpi value, $Res Function(TechnicianKpi) _then) = _$TechnicianKpiCopyWithImpl;
@useResult
$Res call({
 int seasonsParticipated, int completedTasks, int onTimeCompletedTasks, double? onTimeCompletionRatePct
});




}
/// @nodoc
class _$TechnicianKpiCopyWithImpl<$Res>
    implements $TechnicianKpiCopyWith<$Res> {
  _$TechnicianKpiCopyWithImpl(this._self, this._then);

  final TechnicianKpi _self;
  final $Res Function(TechnicianKpi) _then;

/// Create a copy of TechnicianKpi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seasonsParticipated = null,Object? completedTasks = null,Object? onTimeCompletedTasks = null,Object? onTimeCompletionRatePct = freezed,}) {
  return _then(_self.copyWith(
seasonsParticipated: null == seasonsParticipated ? _self.seasonsParticipated : seasonsParticipated // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,onTimeCompletedTasks: null == onTimeCompletedTasks ? _self.onTimeCompletedTasks : onTimeCompletedTasks // ignore: cast_nullable_to_non_nullable
as int,onTimeCompletionRatePct: freezed == onTimeCompletionRatePct ? _self.onTimeCompletionRatePct : onTimeCompletionRatePct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianKpi].
extension TechnicianKpiPatterns on TechnicianKpi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianKpi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianKpi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianKpi value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianKpi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianKpi value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianKpi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seasonsParticipated,  int completedTasks,  int onTimeCompletedTasks,  double? onTimeCompletionRatePct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianKpi() when $default != null:
return $default(_that.seasonsParticipated,_that.completedTasks,_that.onTimeCompletedTasks,_that.onTimeCompletionRatePct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seasonsParticipated,  int completedTasks,  int onTimeCompletedTasks,  double? onTimeCompletionRatePct)  $default,) {final _that = this;
switch (_that) {
case _TechnicianKpi():
return $default(_that.seasonsParticipated,_that.completedTasks,_that.onTimeCompletedTasks,_that.onTimeCompletionRatePct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seasonsParticipated,  int completedTasks,  int onTimeCompletedTasks,  double? onTimeCompletionRatePct)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianKpi() when $default != null:
return $default(_that.seasonsParticipated,_that.completedTasks,_that.onTimeCompletedTasks,_that.onTimeCompletionRatePct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianKpi implements TechnicianKpi {
  const _TechnicianKpi({required this.seasonsParticipated, required this.completedTasks, required this.onTimeCompletedTasks, this.onTimeCompletionRatePct});
  factory _TechnicianKpi.fromJson(Map<String, dynamic> json) => _$TechnicianKpiFromJson(json);

@override final  int seasonsParticipated;
@override final  int completedTasks;
@override final  int onTimeCompletedTasks;
@override final  double? onTimeCompletionRatePct;

/// Create a copy of TechnicianKpi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianKpiCopyWith<_TechnicianKpi> get copyWith => __$TechnicianKpiCopyWithImpl<_TechnicianKpi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianKpiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianKpi&&(identical(other.seasonsParticipated, seasonsParticipated) || other.seasonsParticipated == seasonsParticipated)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.onTimeCompletedTasks, onTimeCompletedTasks) || other.onTimeCompletedTasks == onTimeCompletedTasks)&&(identical(other.onTimeCompletionRatePct, onTimeCompletionRatePct) || other.onTimeCompletionRatePct == onTimeCompletionRatePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seasonsParticipated,completedTasks,onTimeCompletedTasks,onTimeCompletionRatePct);

@override
String toString() {
  return 'TechnicianKpi(seasonsParticipated: $seasonsParticipated, completedTasks: $completedTasks, onTimeCompletedTasks: $onTimeCompletedTasks, onTimeCompletionRatePct: $onTimeCompletionRatePct)';
}


}

/// @nodoc
abstract mixin class _$TechnicianKpiCopyWith<$Res> implements $TechnicianKpiCopyWith<$Res> {
  factory _$TechnicianKpiCopyWith(_TechnicianKpi value, $Res Function(_TechnicianKpi) _then) = __$TechnicianKpiCopyWithImpl;
@override @useResult
$Res call({
 int seasonsParticipated, int completedTasks, int onTimeCompletedTasks, double? onTimeCompletionRatePct
});




}
/// @nodoc
class __$TechnicianKpiCopyWithImpl<$Res>
    implements _$TechnicianKpiCopyWith<$Res> {
  __$TechnicianKpiCopyWithImpl(this._self, this._then);

  final _TechnicianKpi _self;
  final $Res Function(_TechnicianKpi) _then;

/// Create a copy of TechnicianKpi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seasonsParticipated = null,Object? completedTasks = null,Object? onTimeCompletedTasks = null,Object? onTimeCompletionRatePct = freezed,}) {
  return _then(_TechnicianKpi(
seasonsParticipated: null == seasonsParticipated ? _self.seasonsParticipated : seasonsParticipated // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,onTimeCompletedTasks: null == onTimeCompletedTasks ? _self.onTimeCompletedTasks : onTimeCompletedTasks // ignore: cast_nullable_to_non_nullable
as int,onTimeCompletionRatePct: freezed == onTimeCompletionRatePct ? _self.onTimeCompletionRatePct : onTimeCompletionRatePct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
