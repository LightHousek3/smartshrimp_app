// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthAccount {

 String get id; String get email; String? get fullName; String? get phone; String? get avatarUrl;@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole get role;@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus get status; String? get managedByOwnerId; DateTime? get activatedAt; DateTime? get lastLoginAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AuthAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAccountCopyWith<AuthAccount> get copyWith => _$AuthAccountCopyWithImpl<AuthAccount>(this as AuthAccount, _$identity);

  /// Serializes this AuthAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.managedByOwnerId, managedByOwnerId) || other.managedByOwnerId == managedByOwnerId)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,avatarUrl,role,status,managedByOwnerId,activatedAt,lastLoginAt,createdAt,updatedAt);

@override
String toString() {
  return 'AuthAccount(id: $id, email: $email, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, role: $role, status: $status, managedByOwnerId: $managedByOwnerId, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AuthAccountCopyWith<$Res>  {
  factory $AuthAccountCopyWith(AuthAccount value, $Res Function(AuthAccount) _then) = _$AuthAccountCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? fullName, String? phone, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, String? managedByOwnerId, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AuthAccountCopyWithImpl<$Res>
    implements $AuthAccountCopyWith<$Res> {
  _$AuthAccountCopyWithImpl(this._self, this._then);

  final AuthAccount _self;
  final $Res Function(AuthAccount) _then;

/// Create a copy of AuthAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? managedByOwnerId = freezed,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,managedByOwnerId: freezed == managedByOwnerId ? _self.managedByOwnerId : managedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthAccount].
extension AuthAccountPatterns on AuthAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthAccount value)  $default,){
final _that = this;
switch (_that) {
case _AuthAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthAccount value)?  $default,){
final _that = this;
switch (_that) {
case _AuthAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthAccount() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AuthAccount():
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? fullName,  String? phone,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  String? managedByOwnerId,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AuthAccount() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.avatarUrl,_that.role,_that.status,_that.managedByOwnerId,_that.activatedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthAccount extends AuthAccount {
  const _AuthAccount({required this.id, required this.email, this.fullName, this.phone, this.avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown) required this.role, @JsonKey(unknownEnumValue: AccountStatus.unknown) required this.status, this.managedByOwnerId, this.activatedAt, this.lastLoginAt, this.createdAt, this.updatedAt}): super._();
  factory _AuthAccount.fromJson(Map<String, dynamic> json) => _$AuthAccountFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? fullName;
@override final  String? phone;
@override final  String? avatarUrl;
@override@JsonKey(unknownEnumValue: AccountRole.unknown) final  AccountRole role;
@override@JsonKey(unknownEnumValue: AccountStatus.unknown) final  AccountStatus status;
@override final  String? managedByOwnerId;
@override final  DateTime? activatedAt;
@override final  DateTime? lastLoginAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AuthAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthAccountCopyWith<_AuthAccount> get copyWith => __$AuthAccountCopyWithImpl<_AuthAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.managedByOwnerId, managedByOwnerId) || other.managedByOwnerId == managedByOwnerId)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,avatarUrl,role,status,managedByOwnerId,activatedAt,lastLoginAt,createdAt,updatedAt);

@override
String toString() {
  return 'AuthAccount(id: $id, email: $email, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, role: $role, status: $status, managedByOwnerId: $managedByOwnerId, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AuthAccountCopyWith<$Res> implements $AuthAccountCopyWith<$Res> {
  factory _$AuthAccountCopyWith(_AuthAccount value, $Res Function(_AuthAccount) _then) = __$AuthAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? fullName, String? phone, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, String? managedByOwnerId, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AuthAccountCopyWithImpl<$Res>
    implements _$AuthAccountCopyWith<$Res> {
  __$AuthAccountCopyWithImpl(this._self, this._then);

  final _AuthAccount _self;
  final $Res Function(_AuthAccount) _then;

/// Create a copy of AuthAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? managedByOwnerId = freezed,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AuthAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,managedByOwnerId: freezed == managedByOwnerId ? _self.managedByOwnerId : managedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
