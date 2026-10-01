// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aquaculture_season.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeasonAccount {

 String get id; String get email; String get fullName; String? get phone; String get status;
/// Create a copy of SeasonAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonAccountCopyWith<SeasonAccount> get copyWith => _$SeasonAccountCopyWithImpl<SeasonAccount>(this as SeasonAccount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,status);

@override
String toString() {
  return 'SeasonAccount(id: $id, email: $email, fullName: $fullName, phone: $phone, status: $status)';
}


}

/// @nodoc
abstract mixin class $SeasonAccountCopyWith<$Res>  {
  factory $SeasonAccountCopyWith(SeasonAccount value, $Res Function(SeasonAccount) _then) = _$SeasonAccountCopyWithImpl;
@useResult
$Res call({
 String id, String email, String fullName, String? phone, String status
});




}
/// @nodoc
class _$SeasonAccountCopyWithImpl<$Res>
    implements $SeasonAccountCopyWith<$Res> {
  _$SeasonAccountCopyWithImpl(this._self, this._then);

  final SeasonAccount _self;
  final $Res Function(SeasonAccount) _then;

/// Create a copy of SeasonAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phone = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonAccount].
extension SeasonAccountPatterns on SeasonAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonAccount value)  $default,){
final _that = this;
switch (_that) {
case _SeasonAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonAccount value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String? phone,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonAccount() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String? phone,  String status)  $default,) {final _that = this;
switch (_that) {
case _SeasonAccount():
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String fullName,  String? phone,  String status)?  $default,) {final _that = this;
switch (_that) {
case _SeasonAccount() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.phone,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonAccount implements SeasonAccount {
  const _SeasonAccount({required this.id, required this.email, required this.fullName, this.phone, required this.status});
  

@override final  String id;
@override final  String email;
@override final  String fullName;
@override final  String? phone;
@override final  String status;

/// Create a copy of SeasonAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonAccountCopyWith<_SeasonAccount> get copyWith => __$SeasonAccountCopyWithImpl<_SeasonAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,phone,status);

@override
String toString() {
  return 'SeasonAccount(id: $id, email: $email, fullName: $fullName, phone: $phone, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SeasonAccountCopyWith<$Res> implements $SeasonAccountCopyWith<$Res> {
  factory _$SeasonAccountCopyWith(_SeasonAccount value, $Res Function(_SeasonAccount) _then) = __$SeasonAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String fullName, String? phone, String status
});




}
/// @nodoc
class __$SeasonAccountCopyWithImpl<$Res>
    implements _$SeasonAccountCopyWith<$Res> {
  __$SeasonAccountCopyWithImpl(this._self, this._then);

  final _SeasonAccount _self;
  final $Res Function(_SeasonAccount) _then;

/// Create a copy of SeasonAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? phone = freezed,Object? status = null,}) {
  return _then(_SeasonAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SeasonAssignment {

 String get id; String get role; DateTime get assignedAt; SeasonAccount get account; DateTime? get unassignedAt;
/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonAssignmentCopyWith<SeasonAssignment> get copyWith => _$SeasonAssignmentCopyWithImpl<SeasonAssignment>(this as SeasonAssignment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.account, account) || other.account == account)&&(identical(other.unassignedAt, unassignedAt) || other.unassignedAt == unassignedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,assignedAt,account,unassignedAt);

@override
String toString() {
  return 'SeasonAssignment(id: $id, role: $role, assignedAt: $assignedAt, account: $account, unassignedAt: $unassignedAt)';
}


}

/// @nodoc
abstract mixin class $SeasonAssignmentCopyWith<$Res>  {
  factory $SeasonAssignmentCopyWith(SeasonAssignment value, $Res Function(SeasonAssignment) _then) = _$SeasonAssignmentCopyWithImpl;
@useResult
$Res call({
 String id, String role, DateTime assignedAt, SeasonAccount account, DateTime? unassignedAt
});


$SeasonAccountCopyWith<$Res> get account;

}
/// @nodoc
class _$SeasonAssignmentCopyWithImpl<$Res>
    implements $SeasonAssignmentCopyWith<$Res> {
  _$SeasonAssignmentCopyWithImpl(this._self, this._then);

  final SeasonAssignment _self;
  final $Res Function(SeasonAssignment) _then;

/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? assignedAt = null,Object? account = null,Object? unassignedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as SeasonAccount,unassignedAt: freezed == unassignedAt ? _self.unassignedAt : unassignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAccountCopyWith<$Res> get account {
  
  return $SeasonAccountCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonAssignment].
extension SeasonAssignmentPatterns on SeasonAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonAssignment value)  $default,){
final _that = this;
switch (_that) {
case _SeasonAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  DateTime assignedAt,  SeasonAccount account,  DateTime? unassignedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonAssignment() when $default != null:
return $default(_that.id,_that.role,_that.assignedAt,_that.account,_that.unassignedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  DateTime assignedAt,  SeasonAccount account,  DateTime? unassignedAt)  $default,) {final _that = this;
switch (_that) {
case _SeasonAssignment():
return $default(_that.id,_that.role,_that.assignedAt,_that.account,_that.unassignedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  DateTime assignedAt,  SeasonAccount account,  DateTime? unassignedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeasonAssignment() when $default != null:
return $default(_that.id,_that.role,_that.assignedAt,_that.account,_that.unassignedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonAssignment implements SeasonAssignment {
  const _SeasonAssignment({required this.id, required this.role, required this.assignedAt, required this.account, this.unassignedAt});
  

@override final  String id;
@override final  String role;
@override final  DateTime assignedAt;
@override final  SeasonAccount account;
@override final  DateTime? unassignedAt;

/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonAssignmentCopyWith<_SeasonAssignment> get copyWith => __$SeasonAssignmentCopyWithImpl<_SeasonAssignment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.account, account) || other.account == account)&&(identical(other.unassignedAt, unassignedAt) || other.unassignedAt == unassignedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,assignedAt,account,unassignedAt);

@override
String toString() {
  return 'SeasonAssignment(id: $id, role: $role, assignedAt: $assignedAt, account: $account, unassignedAt: $unassignedAt)';
}


}

/// @nodoc
abstract mixin class _$SeasonAssignmentCopyWith<$Res> implements $SeasonAssignmentCopyWith<$Res> {
  factory _$SeasonAssignmentCopyWith(_SeasonAssignment value, $Res Function(_SeasonAssignment) _then) = __$SeasonAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, DateTime assignedAt, SeasonAccount account, DateTime? unassignedAt
});


@override $SeasonAccountCopyWith<$Res> get account;

}
/// @nodoc
class __$SeasonAssignmentCopyWithImpl<$Res>
    implements _$SeasonAssignmentCopyWith<$Res> {
  __$SeasonAssignmentCopyWithImpl(this._self, this._then);

  final _SeasonAssignment _self;
  final $Res Function(_SeasonAssignment) _then;

/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? assignedAt = null,Object? account = null,Object? unassignedAt = freezed,}) {
  return _then(_SeasonAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as SeasonAccount,unassignedAt: freezed == unassignedAt ? _self.unassignedAt : unassignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SeasonAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAccountCopyWith<$Res> get account {
  
  return $SeasonAccountCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}

/// @nodoc
mixin _$SeasonPersonnel {

 SeasonAssignment? get technician; SeasonAssignment? get expert;
/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonPersonnelCopyWith<SeasonPersonnel> get copyWith => _$SeasonPersonnelCopyWithImpl<SeasonPersonnel>(this as SeasonPersonnel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonPersonnel&&(identical(other.technician, technician) || other.technician == technician)&&(identical(other.expert, expert) || other.expert == expert));
}


@override
int get hashCode => Object.hash(runtimeType,technician,expert);

@override
String toString() {
  return 'SeasonPersonnel(technician: $technician, expert: $expert)';
}


}

/// @nodoc
abstract mixin class $SeasonPersonnelCopyWith<$Res>  {
  factory $SeasonPersonnelCopyWith(SeasonPersonnel value, $Res Function(SeasonPersonnel) _then) = _$SeasonPersonnelCopyWithImpl;
@useResult
$Res call({
 SeasonAssignment? technician, SeasonAssignment? expert
});


$SeasonAssignmentCopyWith<$Res>? get technician;$SeasonAssignmentCopyWith<$Res>? get expert;

}
/// @nodoc
class _$SeasonPersonnelCopyWithImpl<$Res>
    implements $SeasonPersonnelCopyWith<$Res> {
  _$SeasonPersonnelCopyWithImpl(this._self, this._then);

  final SeasonPersonnel _self;
  final $Res Function(SeasonPersonnel) _then;

/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technician = freezed,Object? expert = freezed,}) {
  return _then(_self.copyWith(
technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as SeasonAssignment?,expert: freezed == expert ? _self.expert : expert // ignore: cast_nullable_to_non_nullable
as SeasonAssignment?,
  ));
}
/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAssignmentCopyWith<$Res>? get technician {
    if (_self.technician == null) {
    return null;
  }

  return $SeasonAssignmentCopyWith<$Res>(_self.technician!, (value) {
    return _then(_self.copyWith(technician: value));
  });
}/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAssignmentCopyWith<$Res>? get expert {
    if (_self.expert == null) {
    return null;
  }

  return $SeasonAssignmentCopyWith<$Res>(_self.expert!, (value) {
    return _then(_self.copyWith(expert: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonPersonnel].
extension SeasonPersonnelPatterns on SeasonPersonnel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonPersonnel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonPersonnel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonPersonnel value)  $default,){
final _that = this;
switch (_that) {
case _SeasonPersonnel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonPersonnel value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonPersonnel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SeasonAssignment? technician,  SeasonAssignment? expert)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonPersonnel() when $default != null:
return $default(_that.technician,_that.expert);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SeasonAssignment? technician,  SeasonAssignment? expert)  $default,) {final _that = this;
switch (_that) {
case _SeasonPersonnel():
return $default(_that.technician,_that.expert);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SeasonAssignment? technician,  SeasonAssignment? expert)?  $default,) {final _that = this;
switch (_that) {
case _SeasonPersonnel() when $default != null:
return $default(_that.technician,_that.expert);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonPersonnel implements SeasonPersonnel {
  const _SeasonPersonnel({this.technician, this.expert});
  

@override final  SeasonAssignment? technician;
@override final  SeasonAssignment? expert;

/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonPersonnelCopyWith<_SeasonPersonnel> get copyWith => __$SeasonPersonnelCopyWithImpl<_SeasonPersonnel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonPersonnel&&(identical(other.technician, technician) || other.technician == technician)&&(identical(other.expert, expert) || other.expert == expert));
}


@override
int get hashCode => Object.hash(runtimeType,technician,expert);

@override
String toString() {
  return 'SeasonPersonnel(technician: $technician, expert: $expert)';
}


}

/// @nodoc
abstract mixin class _$SeasonPersonnelCopyWith<$Res> implements $SeasonPersonnelCopyWith<$Res> {
  factory _$SeasonPersonnelCopyWith(_SeasonPersonnel value, $Res Function(_SeasonPersonnel) _then) = __$SeasonPersonnelCopyWithImpl;
@override @useResult
$Res call({
 SeasonAssignment? technician, SeasonAssignment? expert
});


@override $SeasonAssignmentCopyWith<$Res>? get technician;@override $SeasonAssignmentCopyWith<$Res>? get expert;

}
/// @nodoc
class __$SeasonPersonnelCopyWithImpl<$Res>
    implements _$SeasonPersonnelCopyWith<$Res> {
  __$SeasonPersonnelCopyWithImpl(this._self, this._then);

  final _SeasonPersonnel _self;
  final $Res Function(_SeasonPersonnel) _then;

/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technician = freezed,Object? expert = freezed,}) {
  return _then(_SeasonPersonnel(
technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as SeasonAssignment?,expert: freezed == expert ? _self.expert : expert // ignore: cast_nullable_to_non_nullable
as SeasonAssignment?,
  ));
}

/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAssignmentCopyWith<$Res>? get technician {
    if (_self.technician == null) {
    return null;
  }

  return $SeasonAssignmentCopyWith<$Res>(_self.technician!, (value) {
    return _then(_self.copyWith(technician: value));
  });
}/// Create a copy of SeasonPersonnel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonAssignmentCopyWith<$Res>? get expert {
    if (_self.expert == null) {
    return null;
  }

  return $SeasonAssignmentCopyWith<$Res>(_self.expert!, (value) {
    return _then(_self.copyWith(expert: value));
  });
}
}

/// @nodoc
mixin _$SeasonProtocol {

 String get id; String get title; int get versionNo; String get status; DateTime? get reviewedAt;
/// Create a copy of SeasonProtocol
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonProtocolCopyWith<SeasonProtocol> get copyWith => _$SeasonProtocolCopyWithImpl<SeasonProtocol>(this as SeasonProtocol, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonProtocol&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,versionNo,status,reviewedAt);

@override
String toString() {
  return 'SeasonProtocol(id: $id, title: $title, versionNo: $versionNo, status: $status, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $SeasonProtocolCopyWith<$Res>  {
  factory $SeasonProtocolCopyWith(SeasonProtocol value, $Res Function(SeasonProtocol) _then) = _$SeasonProtocolCopyWithImpl;
@useResult
$Res call({
 String id, String title, int versionNo, String status, DateTime? reviewedAt
});




}
/// @nodoc
class _$SeasonProtocolCopyWithImpl<$Res>
    implements $SeasonProtocolCopyWith<$Res> {
  _$SeasonProtocolCopyWithImpl(this._self, this._then);

  final SeasonProtocol _self;
  final $Res Function(SeasonProtocol) _then;

/// Create a copy of SeasonProtocol
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? versionNo = null,Object? status = null,Object? reviewedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonProtocol].
extension SeasonProtocolPatterns on SeasonProtocol {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonProtocol value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonProtocol() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonProtocol value)  $default,){
final _that = this;
switch (_that) {
case _SeasonProtocol():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonProtocol value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonProtocol() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int versionNo,  String status,  DateTime? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonProtocol() when $default != null:
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int versionNo,  String status,  DateTime? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _SeasonProtocol():
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int versionNo,  String status,  DateTime? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _SeasonProtocol() when $default != null:
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonProtocol implements SeasonProtocol {
  const _SeasonProtocol({required this.id, required this.title, required this.versionNo, required this.status, this.reviewedAt});
  

@override final  String id;
@override final  String title;
@override final  int versionNo;
@override final  String status;
@override final  DateTime? reviewedAt;

/// Create a copy of SeasonProtocol
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonProtocolCopyWith<_SeasonProtocol> get copyWith => __$SeasonProtocolCopyWithImpl<_SeasonProtocol>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonProtocol&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,versionNo,status,reviewedAt);

@override
String toString() {
  return 'SeasonProtocol(id: $id, title: $title, versionNo: $versionNo, status: $status, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$SeasonProtocolCopyWith<$Res> implements $SeasonProtocolCopyWith<$Res> {
  factory _$SeasonProtocolCopyWith(_SeasonProtocol value, $Res Function(_SeasonProtocol) _then) = __$SeasonProtocolCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int versionNo, String status, DateTime? reviewedAt
});




}
/// @nodoc
class __$SeasonProtocolCopyWithImpl<$Res>
    implements _$SeasonProtocolCopyWith<$Res> {
  __$SeasonProtocolCopyWithImpl(this._self, this._then);

  final _SeasonProtocol _self;
  final $Res Function(_SeasonProtocol) _then;

/// Create a copy of SeasonProtocol
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? versionNo = null,Object? status = null,Object? reviewedAt = freezed,}) {
  return _then(_SeasonProtocol(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ActivationEligibility {

 bool get canActivate; List<String> get missingConditions;
/// Create a copy of ActivationEligibility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationEligibilityCopyWith<ActivationEligibility> get copyWith => _$ActivationEligibilityCopyWithImpl<ActivationEligibility>(this as ActivationEligibility, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationEligibility&&(identical(other.canActivate, canActivate) || other.canActivate == canActivate)&&const DeepCollectionEquality().equals(other.missingConditions, missingConditions));
}


@override
int get hashCode => Object.hash(runtimeType,canActivate,const DeepCollectionEquality().hash(missingConditions));

@override
String toString() {
  return 'ActivationEligibility(canActivate: $canActivate, missingConditions: $missingConditions)';
}


}

/// @nodoc
abstract mixin class $ActivationEligibilityCopyWith<$Res>  {
  factory $ActivationEligibilityCopyWith(ActivationEligibility value, $Res Function(ActivationEligibility) _then) = _$ActivationEligibilityCopyWithImpl;
@useResult
$Res call({
 bool canActivate, List<String> missingConditions
});




}
/// @nodoc
class _$ActivationEligibilityCopyWithImpl<$Res>
    implements $ActivationEligibilityCopyWith<$Res> {
  _$ActivationEligibilityCopyWithImpl(this._self, this._then);

  final ActivationEligibility _self;
  final $Res Function(ActivationEligibility) _then;

/// Create a copy of ActivationEligibility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canActivate = null,Object? missingConditions = null,}) {
  return _then(_self.copyWith(
canActivate: null == canActivate ? _self.canActivate : canActivate // ignore: cast_nullable_to_non_nullable
as bool,missingConditions: null == missingConditions ? _self.missingConditions : missingConditions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationEligibility].
extension ActivationEligibilityPatterns on ActivationEligibility {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationEligibility value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationEligibility() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationEligibility value)  $default,){
final _that = this;
switch (_that) {
case _ActivationEligibility():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationEligibility value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationEligibility() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool canActivate,  List<String> missingConditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationEligibility() when $default != null:
return $default(_that.canActivate,_that.missingConditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool canActivate,  List<String> missingConditions)  $default,) {final _that = this;
switch (_that) {
case _ActivationEligibility():
return $default(_that.canActivate,_that.missingConditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool canActivate,  List<String> missingConditions)?  $default,) {final _that = this;
switch (_that) {
case _ActivationEligibility() when $default != null:
return $default(_that.canActivate,_that.missingConditions);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationEligibility implements ActivationEligibility {
  const _ActivationEligibility({required this.canActivate, required final  List<String> missingConditions}): _missingConditions = missingConditions;
  

@override final  bool canActivate;
 final  List<String> _missingConditions;
@override List<String> get missingConditions {
  if (_missingConditions is EqualUnmodifiableListView) return _missingConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingConditions);
}


/// Create a copy of ActivationEligibility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationEligibilityCopyWith<_ActivationEligibility> get copyWith => __$ActivationEligibilityCopyWithImpl<_ActivationEligibility>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationEligibility&&(identical(other.canActivate, canActivate) || other.canActivate == canActivate)&&const DeepCollectionEquality().equals(other._missingConditions, _missingConditions));
}


@override
int get hashCode => Object.hash(runtimeType,canActivate,const DeepCollectionEquality().hash(_missingConditions));

@override
String toString() {
  return 'ActivationEligibility(canActivate: $canActivate, missingConditions: $missingConditions)';
}


}

/// @nodoc
abstract mixin class _$ActivationEligibilityCopyWith<$Res> implements $ActivationEligibilityCopyWith<$Res> {
  factory _$ActivationEligibilityCopyWith(_ActivationEligibility value, $Res Function(_ActivationEligibility) _then) = __$ActivationEligibilityCopyWithImpl;
@override @useResult
$Res call({
 bool canActivate, List<String> missingConditions
});




}
/// @nodoc
class __$ActivationEligibilityCopyWithImpl<$Res>
    implements _$ActivationEligibilityCopyWith<$Res> {
  __$ActivationEligibilityCopyWithImpl(this._self, this._then);

  final _ActivationEligibility _self;
  final $Res Function(_ActivationEligibility) _then;

/// Create a copy of ActivationEligibility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canActivate = null,Object? missingConditions = null,}) {
  return _then(_ActivationEligibility(
canActivate: null == canActivate ? _self.canActivate : canActivate // ignore: cast_nullable_to_non_nullable
as bool,missingConditions: null == missingConditions ? _self._missingConditions : missingConditions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$SeasonActions {

 bool get update; bool get activate; bool get cancel;
/// Create a copy of SeasonActions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonActionsCopyWith<SeasonActions> get copyWith => _$SeasonActionsCopyWithImpl<SeasonActions>(this as SeasonActions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonActions&&(identical(other.update, update) || other.update == update)&&(identical(other.activate, activate) || other.activate == activate)&&(identical(other.cancel, cancel) || other.cancel == cancel));
}


@override
int get hashCode => Object.hash(runtimeType,update,activate,cancel);

@override
String toString() {
  return 'SeasonActions(update: $update, activate: $activate, cancel: $cancel)';
}


}

/// @nodoc
abstract mixin class $SeasonActionsCopyWith<$Res>  {
  factory $SeasonActionsCopyWith(SeasonActions value, $Res Function(SeasonActions) _then) = _$SeasonActionsCopyWithImpl;
@useResult
$Res call({
 bool update, bool activate, bool cancel
});




}
/// @nodoc
class _$SeasonActionsCopyWithImpl<$Res>
    implements $SeasonActionsCopyWith<$Res> {
  _$SeasonActionsCopyWithImpl(this._self, this._then);

  final SeasonActions _self;
  final $Res Function(SeasonActions) _then;

/// Create a copy of SeasonActions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? update = null,Object? activate = null,Object? cancel = null,}) {
  return _then(_self.copyWith(
update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,activate: null == activate ? _self.activate : activate // ignore: cast_nullable_to_non_nullable
as bool,cancel: null == cancel ? _self.cancel : cancel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonActions].
extension SeasonActionsPatterns on SeasonActions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonActions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonActions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonActions value)  $default,){
final _that = this;
switch (_that) {
case _SeasonActions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonActions value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonActions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool update,  bool activate,  bool cancel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonActions() when $default != null:
return $default(_that.update,_that.activate,_that.cancel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool update,  bool activate,  bool cancel)  $default,) {final _that = this;
switch (_that) {
case _SeasonActions():
return $default(_that.update,_that.activate,_that.cancel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool update,  bool activate,  bool cancel)?  $default,) {final _that = this;
switch (_that) {
case _SeasonActions() when $default != null:
return $default(_that.update,_that.activate,_that.cancel);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonActions implements SeasonActions {
  const _SeasonActions({required this.update, required this.activate, required this.cancel});
  

@override final  bool update;
@override final  bool activate;
@override final  bool cancel;

/// Create a copy of SeasonActions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonActionsCopyWith<_SeasonActions> get copyWith => __$SeasonActionsCopyWithImpl<_SeasonActions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonActions&&(identical(other.update, update) || other.update == update)&&(identical(other.activate, activate) || other.activate == activate)&&(identical(other.cancel, cancel) || other.cancel == cancel));
}


@override
int get hashCode => Object.hash(runtimeType,update,activate,cancel);

@override
String toString() {
  return 'SeasonActions(update: $update, activate: $activate, cancel: $cancel)';
}


}

/// @nodoc
abstract mixin class _$SeasonActionsCopyWith<$Res> implements $SeasonActionsCopyWith<$Res> {
  factory _$SeasonActionsCopyWith(_SeasonActions value, $Res Function(_SeasonActions) _then) = __$SeasonActionsCopyWithImpl;
@override @useResult
$Res call({
 bool update, bool activate, bool cancel
});




}
/// @nodoc
class __$SeasonActionsCopyWithImpl<$Res>
    implements _$SeasonActionsCopyWith<$Res> {
  __$SeasonActionsCopyWithImpl(this._self, this._then);

  final _SeasonActions _self;
  final $Res Function(_SeasonActions) _then;

/// Create a copy of SeasonActions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? update = null,Object? activate = null,Object? cancel = null,}) {
  return _then(_SeasonActions(
update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,activate: null == activate ? _self.activate : activate // ignore: cast_nullable_to_non_nullable
as bool,cancel: null == cancel ? _self.cancel : cancel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AquacultureSeason {

 String get id; String get pondId; String get name; ShrimpType get shrimpType; SeasonStatus get status; String get createdBy; DateTime get createdAt; DateTime get updatedAt; Pond get pond; DateTime? get stockingDate; DateTime? get expectedEndDate; DateTime? get actualEndDate; int? get initialQuantity; double? get initialAvgWeightG; double? get initialBiomassKg; double? get initialDensityPerM2; String? get cancellationReason; int? get dayOfCulture; SeasonPersonnel? get personnel; SeasonPersonnel? get lastAssignedPersonnel; SeasonProtocol? get approvedProductionProtocol; ActivationEligibility? get activationEligibility; SeasonActions? get availableActions;
/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AquacultureSeasonCopyWith<AquacultureSeason> get copyWith => _$AquacultureSeasonCopyWithImpl<AquacultureSeason>(this as AquacultureSeason, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AquacultureSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.name, name) || other.name == name)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.pond, pond) || other.pond == pond)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.actualEndDate, actualEndDate) || other.actualEndDate == actualEndDate)&&(identical(other.initialQuantity, initialQuantity) || other.initialQuantity == initialQuantity)&&(identical(other.initialAvgWeightG, initialAvgWeightG) || other.initialAvgWeightG == initialAvgWeightG)&&(identical(other.initialBiomassKg, initialBiomassKg) || other.initialBiomassKg == initialBiomassKg)&&(identical(other.initialDensityPerM2, initialDensityPerM2) || other.initialDensityPerM2 == initialDensityPerM2)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture)&&(identical(other.personnel, personnel) || other.personnel == personnel)&&(identical(other.lastAssignedPersonnel, lastAssignedPersonnel) || other.lastAssignedPersonnel == lastAssignedPersonnel)&&(identical(other.approvedProductionProtocol, approvedProductionProtocol) || other.approvedProductionProtocol == approvedProductionProtocol)&&(identical(other.activationEligibility, activationEligibility) || other.activationEligibility == activationEligibility)&&(identical(other.availableActions, availableActions) || other.availableActions == availableActions));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,pondId,name,shrimpType,status,createdBy,createdAt,updatedAt,pond,stockingDate,expectedEndDate,actualEndDate,initialQuantity,initialAvgWeightG,initialBiomassKg,initialDensityPerM2,cancellationReason,dayOfCulture,personnel,lastAssignedPersonnel,approvedProductionProtocol,activationEligibility,availableActions]);

@override
String toString() {
  return 'AquacultureSeason(id: $id, pondId: $pondId, name: $name, shrimpType: $shrimpType, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, pond: $pond, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, actualEndDate: $actualEndDate, initialQuantity: $initialQuantity, initialAvgWeightG: $initialAvgWeightG, initialBiomassKg: $initialBiomassKg, initialDensityPerM2: $initialDensityPerM2, cancellationReason: $cancellationReason, dayOfCulture: $dayOfCulture, personnel: $personnel, lastAssignedPersonnel: $lastAssignedPersonnel, approvedProductionProtocol: $approvedProductionProtocol, activationEligibility: $activationEligibility, availableActions: $availableActions)';
}


}

/// @nodoc
abstract mixin class $AquacultureSeasonCopyWith<$Res>  {
  factory $AquacultureSeasonCopyWith(AquacultureSeason value, $Res Function(AquacultureSeason) _then) = _$AquacultureSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String pondId, String name, ShrimpType shrimpType, SeasonStatus status, String createdBy, DateTime createdAt, DateTime updatedAt, Pond pond, DateTime? stockingDate, DateTime? expectedEndDate, DateTime? actualEndDate, int? initialQuantity, double? initialAvgWeightG, double? initialBiomassKg, double? initialDensityPerM2, String? cancellationReason, int? dayOfCulture, SeasonPersonnel? personnel, SeasonPersonnel? lastAssignedPersonnel, SeasonProtocol? approvedProductionProtocol, ActivationEligibility? activationEligibility, SeasonActions? availableActions
});


$PondCopyWith<$Res> get pond;$SeasonPersonnelCopyWith<$Res>? get personnel;$SeasonPersonnelCopyWith<$Res>? get lastAssignedPersonnel;$SeasonProtocolCopyWith<$Res>? get approvedProductionProtocol;$ActivationEligibilityCopyWith<$Res>? get activationEligibility;$SeasonActionsCopyWith<$Res>? get availableActions;

}
/// @nodoc
class _$AquacultureSeasonCopyWithImpl<$Res>
    implements $AquacultureSeasonCopyWith<$Res> {
  _$AquacultureSeasonCopyWithImpl(this._self, this._then);

  final AquacultureSeason _self;
  final $Res Function(AquacultureSeason) _then;

/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pondId = null,Object? name = null,Object? shrimpType = null,Object? status = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? pond = null,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? actualEndDate = freezed,Object? initialQuantity = freezed,Object? initialAvgWeightG = freezed,Object? initialBiomassKg = freezed,Object? initialDensityPerM2 = freezed,Object? cancellationReason = freezed,Object? dayOfCulture = freezed,Object? personnel = freezed,Object? lastAssignedPersonnel = freezed,Object? approvedProductionProtocol = freezed,Object? activationEligibility = freezed,Object? availableActions = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as ShrimpType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SeasonStatus,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pond: null == pond ? _self.pond : pond // ignore: cast_nullable_to_non_nullable
as Pond,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualEndDate: freezed == actualEndDate ? _self.actualEndDate : actualEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialQuantity: freezed == initialQuantity ? _self.initialQuantity : initialQuantity // ignore: cast_nullable_to_non_nullable
as int?,initialAvgWeightG: freezed == initialAvgWeightG ? _self.initialAvgWeightG : initialAvgWeightG // ignore: cast_nullable_to_non_nullable
as double?,initialBiomassKg: freezed == initialBiomassKg ? _self.initialBiomassKg : initialBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,initialDensityPerM2: freezed == initialDensityPerM2 ? _self.initialDensityPerM2 : initialDensityPerM2 // ignore: cast_nullable_to_non_nullable
as double?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,personnel: freezed == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as SeasonPersonnel?,lastAssignedPersonnel: freezed == lastAssignedPersonnel ? _self.lastAssignedPersonnel : lastAssignedPersonnel // ignore: cast_nullable_to_non_nullable
as SeasonPersonnel?,approvedProductionProtocol: freezed == approvedProductionProtocol ? _self.approvedProductionProtocol : approvedProductionProtocol // ignore: cast_nullable_to_non_nullable
as SeasonProtocol?,activationEligibility: freezed == activationEligibility ? _self.activationEligibility : activationEligibility // ignore: cast_nullable_to_non_nullable
as ActivationEligibility?,availableActions: freezed == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as SeasonActions?,
  ));
}
/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondCopyWith<$Res> get pond {
  
  return $PondCopyWith<$Res>(_self.pond, (value) {
    return _then(_self.copyWith(pond: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonPersonnelCopyWith<$Res>? get personnel {
    if (_self.personnel == null) {
    return null;
  }

  return $SeasonPersonnelCopyWith<$Res>(_self.personnel!, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonPersonnelCopyWith<$Res>? get lastAssignedPersonnel {
    if (_self.lastAssignedPersonnel == null) {
    return null;
  }

  return $SeasonPersonnelCopyWith<$Res>(_self.lastAssignedPersonnel!, (value) {
    return _then(_self.copyWith(lastAssignedPersonnel: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonProtocolCopyWith<$Res>? get approvedProductionProtocol {
    if (_self.approvedProductionProtocol == null) {
    return null;
  }

  return $SeasonProtocolCopyWith<$Res>(_self.approvedProductionProtocol!, (value) {
    return _then(_self.copyWith(approvedProductionProtocol: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationEligibilityCopyWith<$Res>? get activationEligibility {
    if (_self.activationEligibility == null) {
    return null;
  }

  return $ActivationEligibilityCopyWith<$Res>(_self.activationEligibility!, (value) {
    return _then(_self.copyWith(activationEligibility: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonActionsCopyWith<$Res>? get availableActions {
    if (_self.availableActions == null) {
    return null;
  }

  return $SeasonActionsCopyWith<$Res>(_self.availableActions!, (value) {
    return _then(_self.copyWith(availableActions: value));
  });
}
}


/// Adds pattern-matching-related methods to [AquacultureSeason].
extension AquacultureSeasonPatterns on AquacultureSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AquacultureSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AquacultureSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AquacultureSeason value)  $default,){
final _that = this;
switch (_that) {
case _AquacultureSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AquacultureSeason value)?  $default,){
final _that = this;
switch (_that) {
case _AquacultureSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pondId,  String name,  ShrimpType shrimpType,  SeasonStatus status,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  Pond pond,  DateTime? stockingDate,  DateTime? expectedEndDate,  DateTime? actualEndDate,  int? initialQuantity,  double? initialAvgWeightG,  double? initialBiomassKg,  double? initialDensityPerM2,  String? cancellationReason,  int? dayOfCulture,  SeasonPersonnel? personnel,  SeasonPersonnel? lastAssignedPersonnel,  SeasonProtocol? approvedProductionProtocol,  ActivationEligibility? activationEligibility,  SeasonActions? availableActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AquacultureSeason() when $default != null:
return $default(_that.id,_that.pondId,_that.name,_that.shrimpType,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.pond,_that.stockingDate,_that.expectedEndDate,_that.actualEndDate,_that.initialQuantity,_that.initialAvgWeightG,_that.initialBiomassKg,_that.initialDensityPerM2,_that.cancellationReason,_that.dayOfCulture,_that.personnel,_that.lastAssignedPersonnel,_that.approvedProductionProtocol,_that.activationEligibility,_that.availableActions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pondId,  String name,  ShrimpType shrimpType,  SeasonStatus status,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  Pond pond,  DateTime? stockingDate,  DateTime? expectedEndDate,  DateTime? actualEndDate,  int? initialQuantity,  double? initialAvgWeightG,  double? initialBiomassKg,  double? initialDensityPerM2,  String? cancellationReason,  int? dayOfCulture,  SeasonPersonnel? personnel,  SeasonPersonnel? lastAssignedPersonnel,  SeasonProtocol? approvedProductionProtocol,  ActivationEligibility? activationEligibility,  SeasonActions? availableActions)  $default,) {final _that = this;
switch (_that) {
case _AquacultureSeason():
return $default(_that.id,_that.pondId,_that.name,_that.shrimpType,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.pond,_that.stockingDate,_that.expectedEndDate,_that.actualEndDate,_that.initialQuantity,_that.initialAvgWeightG,_that.initialBiomassKg,_that.initialDensityPerM2,_that.cancellationReason,_that.dayOfCulture,_that.personnel,_that.lastAssignedPersonnel,_that.approvedProductionProtocol,_that.activationEligibility,_that.availableActions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pondId,  String name,  ShrimpType shrimpType,  SeasonStatus status,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  Pond pond,  DateTime? stockingDate,  DateTime? expectedEndDate,  DateTime? actualEndDate,  int? initialQuantity,  double? initialAvgWeightG,  double? initialBiomassKg,  double? initialDensityPerM2,  String? cancellationReason,  int? dayOfCulture,  SeasonPersonnel? personnel,  SeasonPersonnel? lastAssignedPersonnel,  SeasonProtocol? approvedProductionProtocol,  ActivationEligibility? activationEligibility,  SeasonActions? availableActions)?  $default,) {final _that = this;
switch (_that) {
case _AquacultureSeason() when $default != null:
return $default(_that.id,_that.pondId,_that.name,_that.shrimpType,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.pond,_that.stockingDate,_that.expectedEndDate,_that.actualEndDate,_that.initialQuantity,_that.initialAvgWeightG,_that.initialBiomassKg,_that.initialDensityPerM2,_that.cancellationReason,_that.dayOfCulture,_that.personnel,_that.lastAssignedPersonnel,_that.approvedProductionProtocol,_that.activationEligibility,_that.availableActions);case _:
  return null;

}
}

}

/// @nodoc


class _AquacultureSeason extends AquacultureSeason {
  const _AquacultureSeason({required this.id, required this.pondId, required this.name, required this.shrimpType, required this.status, required this.createdBy, required this.createdAt, required this.updatedAt, required this.pond, this.stockingDate, this.expectedEndDate, this.actualEndDate, this.initialQuantity, this.initialAvgWeightG, this.initialBiomassKg, this.initialDensityPerM2, this.cancellationReason, this.dayOfCulture, this.personnel, this.lastAssignedPersonnel, this.approvedProductionProtocol, this.activationEligibility, this.availableActions}): super._();
  

@override final  String id;
@override final  String pondId;
@override final  String name;
@override final  ShrimpType shrimpType;
@override final  SeasonStatus status;
@override final  String createdBy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  Pond pond;
@override final  DateTime? stockingDate;
@override final  DateTime? expectedEndDate;
@override final  DateTime? actualEndDate;
@override final  int? initialQuantity;
@override final  double? initialAvgWeightG;
@override final  double? initialBiomassKg;
@override final  double? initialDensityPerM2;
@override final  String? cancellationReason;
@override final  int? dayOfCulture;
@override final  SeasonPersonnel? personnel;
@override final  SeasonPersonnel? lastAssignedPersonnel;
@override final  SeasonProtocol? approvedProductionProtocol;
@override final  ActivationEligibility? activationEligibility;
@override final  SeasonActions? availableActions;

/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AquacultureSeasonCopyWith<_AquacultureSeason> get copyWith => __$AquacultureSeasonCopyWithImpl<_AquacultureSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AquacultureSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.name, name) || other.name == name)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.pond, pond) || other.pond == pond)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.actualEndDate, actualEndDate) || other.actualEndDate == actualEndDate)&&(identical(other.initialQuantity, initialQuantity) || other.initialQuantity == initialQuantity)&&(identical(other.initialAvgWeightG, initialAvgWeightG) || other.initialAvgWeightG == initialAvgWeightG)&&(identical(other.initialBiomassKg, initialBiomassKg) || other.initialBiomassKg == initialBiomassKg)&&(identical(other.initialDensityPerM2, initialDensityPerM2) || other.initialDensityPerM2 == initialDensityPerM2)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.dayOfCulture, dayOfCulture) || other.dayOfCulture == dayOfCulture)&&(identical(other.personnel, personnel) || other.personnel == personnel)&&(identical(other.lastAssignedPersonnel, lastAssignedPersonnel) || other.lastAssignedPersonnel == lastAssignedPersonnel)&&(identical(other.approvedProductionProtocol, approvedProductionProtocol) || other.approvedProductionProtocol == approvedProductionProtocol)&&(identical(other.activationEligibility, activationEligibility) || other.activationEligibility == activationEligibility)&&(identical(other.availableActions, availableActions) || other.availableActions == availableActions));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,pondId,name,shrimpType,status,createdBy,createdAt,updatedAt,pond,stockingDate,expectedEndDate,actualEndDate,initialQuantity,initialAvgWeightG,initialBiomassKg,initialDensityPerM2,cancellationReason,dayOfCulture,personnel,lastAssignedPersonnel,approvedProductionProtocol,activationEligibility,availableActions]);

@override
String toString() {
  return 'AquacultureSeason(id: $id, pondId: $pondId, name: $name, shrimpType: $shrimpType, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, pond: $pond, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, actualEndDate: $actualEndDate, initialQuantity: $initialQuantity, initialAvgWeightG: $initialAvgWeightG, initialBiomassKg: $initialBiomassKg, initialDensityPerM2: $initialDensityPerM2, cancellationReason: $cancellationReason, dayOfCulture: $dayOfCulture, personnel: $personnel, lastAssignedPersonnel: $lastAssignedPersonnel, approvedProductionProtocol: $approvedProductionProtocol, activationEligibility: $activationEligibility, availableActions: $availableActions)';
}


}

/// @nodoc
abstract mixin class _$AquacultureSeasonCopyWith<$Res> implements $AquacultureSeasonCopyWith<$Res> {
  factory _$AquacultureSeasonCopyWith(_AquacultureSeason value, $Res Function(_AquacultureSeason) _then) = __$AquacultureSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String pondId, String name, ShrimpType shrimpType, SeasonStatus status, String createdBy, DateTime createdAt, DateTime updatedAt, Pond pond, DateTime? stockingDate, DateTime? expectedEndDate, DateTime? actualEndDate, int? initialQuantity, double? initialAvgWeightG, double? initialBiomassKg, double? initialDensityPerM2, String? cancellationReason, int? dayOfCulture, SeasonPersonnel? personnel, SeasonPersonnel? lastAssignedPersonnel, SeasonProtocol? approvedProductionProtocol, ActivationEligibility? activationEligibility, SeasonActions? availableActions
});


@override $PondCopyWith<$Res> get pond;@override $SeasonPersonnelCopyWith<$Res>? get personnel;@override $SeasonPersonnelCopyWith<$Res>? get lastAssignedPersonnel;@override $SeasonProtocolCopyWith<$Res>? get approvedProductionProtocol;@override $ActivationEligibilityCopyWith<$Res>? get activationEligibility;@override $SeasonActionsCopyWith<$Res>? get availableActions;

}
/// @nodoc
class __$AquacultureSeasonCopyWithImpl<$Res>
    implements _$AquacultureSeasonCopyWith<$Res> {
  __$AquacultureSeasonCopyWithImpl(this._self, this._then);

  final _AquacultureSeason _self;
  final $Res Function(_AquacultureSeason) _then;

/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pondId = null,Object? name = null,Object? shrimpType = null,Object? status = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? pond = null,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? actualEndDate = freezed,Object? initialQuantity = freezed,Object? initialAvgWeightG = freezed,Object? initialBiomassKg = freezed,Object? initialDensityPerM2 = freezed,Object? cancellationReason = freezed,Object? dayOfCulture = freezed,Object? personnel = freezed,Object? lastAssignedPersonnel = freezed,Object? approvedProductionProtocol = freezed,Object? activationEligibility = freezed,Object? availableActions = freezed,}) {
  return _then(_AquacultureSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as ShrimpType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SeasonStatus,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pond: null == pond ? _self.pond : pond // ignore: cast_nullable_to_non_nullable
as Pond,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualEndDate: freezed == actualEndDate ? _self.actualEndDate : actualEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialQuantity: freezed == initialQuantity ? _self.initialQuantity : initialQuantity // ignore: cast_nullable_to_non_nullable
as int?,initialAvgWeightG: freezed == initialAvgWeightG ? _self.initialAvgWeightG : initialAvgWeightG // ignore: cast_nullable_to_non_nullable
as double?,initialBiomassKg: freezed == initialBiomassKg ? _self.initialBiomassKg : initialBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,initialDensityPerM2: freezed == initialDensityPerM2 ? _self.initialDensityPerM2 : initialDensityPerM2 // ignore: cast_nullable_to_non_nullable
as double?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,dayOfCulture: freezed == dayOfCulture ? _self.dayOfCulture : dayOfCulture // ignore: cast_nullable_to_non_nullable
as int?,personnel: freezed == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as SeasonPersonnel?,lastAssignedPersonnel: freezed == lastAssignedPersonnel ? _self.lastAssignedPersonnel : lastAssignedPersonnel // ignore: cast_nullable_to_non_nullable
as SeasonPersonnel?,approvedProductionProtocol: freezed == approvedProductionProtocol ? _self.approvedProductionProtocol : approvedProductionProtocol // ignore: cast_nullable_to_non_nullable
as SeasonProtocol?,activationEligibility: freezed == activationEligibility ? _self.activationEligibility : activationEligibility // ignore: cast_nullable_to_non_nullable
as ActivationEligibility?,availableActions: freezed == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as SeasonActions?,
  ));
}

/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PondCopyWith<$Res> get pond {
  
  return $PondCopyWith<$Res>(_self.pond, (value) {
    return _then(_self.copyWith(pond: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonPersonnelCopyWith<$Res>? get personnel {
    if (_self.personnel == null) {
    return null;
  }

  return $SeasonPersonnelCopyWith<$Res>(_self.personnel!, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonPersonnelCopyWith<$Res>? get lastAssignedPersonnel {
    if (_self.lastAssignedPersonnel == null) {
    return null;
  }

  return $SeasonPersonnelCopyWith<$Res>(_self.lastAssignedPersonnel!, (value) {
    return _then(_self.copyWith(lastAssignedPersonnel: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonProtocolCopyWith<$Res>? get approvedProductionProtocol {
    if (_self.approvedProductionProtocol == null) {
    return null;
  }

  return $SeasonProtocolCopyWith<$Res>(_self.approvedProductionProtocol!, (value) {
    return _then(_self.copyWith(approvedProductionProtocol: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationEligibilityCopyWith<$Res>? get activationEligibility {
    if (_self.activationEligibility == null) {
    return null;
  }

  return $ActivationEligibilityCopyWith<$Res>(_self.activationEligibility!, (value) {
    return _then(_self.copyWith(activationEligibility: value));
  });
}/// Create a copy of AquacultureSeason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonActionsCopyWith<$Res>? get availableActions {
    if (_self.availableActions == null) {
    return null;
  }

  return $SeasonActionsCopyWith<$Res>(_self.availableActions!, (value) {
    return _then(_self.copyWith(availableActions: value));
  });
}
}

/// @nodoc
mixin _$SeasonPage {

 List<AquacultureSeason> get items; int get limit; int get totalResults; bool get hasNextPage; String? get nextCursor;
/// Create a copy of SeasonPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonPageCopyWith<SeasonPage> get copyWith => _$SeasonPageCopyWithImpl<SeasonPage>(this as SeasonPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),limit,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'SeasonPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $SeasonPageCopyWith<$Res>  {
  factory $SeasonPageCopyWith(SeasonPage value, $Res Function(SeasonPage) _then) = _$SeasonPageCopyWithImpl;
@useResult
$Res call({
 List<AquacultureSeason> items, int limit, int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$SeasonPageCopyWithImpl<$Res>
    implements $SeasonPageCopyWith<$Res> {
  _$SeasonPageCopyWithImpl(this._self, this._then);

  final SeasonPage _self;
  final $Res Function(SeasonPage) _then;

/// Create a copy of SeasonPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AquacultureSeason>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonPage].
extension SeasonPagePatterns on SeasonPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonPage value)  $default,){
final _that = this;
switch (_that) {
case _SeasonPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonPage value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AquacultureSeason> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AquacultureSeason> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _SeasonPage():
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AquacultureSeason> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _SeasonPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonPage extends SeasonPage {
  const _SeasonPage({required final  List<AquacultureSeason> items, required this.limit, required this.totalResults, required this.hasNextPage, this.nextCursor}): _items = items,super._();
  

 final  List<AquacultureSeason> _items;
@override List<AquacultureSeason> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int limit;
@override final  int totalResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of SeasonPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonPageCopyWith<_SeasonPage> get copyWith => __$SeasonPageCopyWithImpl<_SeasonPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),limit,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'SeasonPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$SeasonPageCopyWith<$Res> implements $SeasonPageCopyWith<$Res> {
  factory _$SeasonPageCopyWith(_SeasonPage value, $Res Function(_SeasonPage) _then) = __$SeasonPageCopyWithImpl;
@override @useResult
$Res call({
 List<AquacultureSeason> items, int limit, int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$SeasonPageCopyWithImpl<$Res>
    implements _$SeasonPageCopyWith<$Res> {
  __$SeasonPageCopyWithImpl(this._self, this._then);

  final _SeasonPage _self;
  final $Res Function(_SeasonPage) _then;

/// Create a copy of SeasonPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_SeasonPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AquacultureSeason>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SeasonCancellationResult {

 AquacultureSeason get season; int get cancelledScheduleCount;
/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonCancellationResultCopyWith<SeasonCancellationResult> get copyWith => _$SeasonCancellationResultCopyWithImpl<SeasonCancellationResult>(this as SeasonCancellationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonCancellationResult&&(identical(other.season, season) || other.season == season)&&(identical(other.cancelledScheduleCount, cancelledScheduleCount) || other.cancelledScheduleCount == cancelledScheduleCount));
}


@override
int get hashCode => Object.hash(runtimeType,season,cancelledScheduleCount);

@override
String toString() {
  return 'SeasonCancellationResult(season: $season, cancelledScheduleCount: $cancelledScheduleCount)';
}


}

/// @nodoc
abstract mixin class $SeasonCancellationResultCopyWith<$Res>  {
  factory $SeasonCancellationResultCopyWith(SeasonCancellationResult value, $Res Function(SeasonCancellationResult) _then) = _$SeasonCancellationResultCopyWithImpl;
@useResult
$Res call({
 AquacultureSeason season, int cancelledScheduleCount
});


$AquacultureSeasonCopyWith<$Res> get season;

}
/// @nodoc
class _$SeasonCancellationResultCopyWithImpl<$Res>
    implements $SeasonCancellationResultCopyWith<$Res> {
  _$SeasonCancellationResultCopyWithImpl(this._self, this._then);

  final SeasonCancellationResult _self;
  final $Res Function(SeasonCancellationResult) _then;

/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? cancelledScheduleCount = null,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as AquacultureSeason,cancelledScheduleCount: null == cancelledScheduleCount ? _self.cancelledScheduleCount : cancelledScheduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AquacultureSeasonCopyWith<$Res> get season {
  
  return $AquacultureSeasonCopyWith<$Res>(_self.season, (value) {
    return _then(_self.copyWith(season: value));
  });
}
}


/// Adds pattern-matching-related methods to [SeasonCancellationResult].
extension SeasonCancellationResultPatterns on SeasonCancellationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonCancellationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonCancellationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonCancellationResult value)  $default,){
final _that = this;
switch (_that) {
case _SeasonCancellationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonCancellationResult value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonCancellationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AquacultureSeason season,  int cancelledScheduleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonCancellationResult() when $default != null:
return $default(_that.season,_that.cancelledScheduleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AquacultureSeason season,  int cancelledScheduleCount)  $default,) {final _that = this;
switch (_that) {
case _SeasonCancellationResult():
return $default(_that.season,_that.cancelledScheduleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AquacultureSeason season,  int cancelledScheduleCount)?  $default,) {final _that = this;
switch (_that) {
case _SeasonCancellationResult() when $default != null:
return $default(_that.season,_that.cancelledScheduleCount);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonCancellationResult implements SeasonCancellationResult {
  const _SeasonCancellationResult({required this.season, required this.cancelledScheduleCount});
  

@override final  AquacultureSeason season;
@override final  int cancelledScheduleCount;

/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonCancellationResultCopyWith<_SeasonCancellationResult> get copyWith => __$SeasonCancellationResultCopyWithImpl<_SeasonCancellationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonCancellationResult&&(identical(other.season, season) || other.season == season)&&(identical(other.cancelledScheduleCount, cancelledScheduleCount) || other.cancelledScheduleCount == cancelledScheduleCount));
}


@override
int get hashCode => Object.hash(runtimeType,season,cancelledScheduleCount);

@override
String toString() {
  return 'SeasonCancellationResult(season: $season, cancelledScheduleCount: $cancelledScheduleCount)';
}


}

/// @nodoc
abstract mixin class _$SeasonCancellationResultCopyWith<$Res> implements $SeasonCancellationResultCopyWith<$Res> {
  factory _$SeasonCancellationResultCopyWith(_SeasonCancellationResult value, $Res Function(_SeasonCancellationResult) _then) = __$SeasonCancellationResultCopyWithImpl;
@override @useResult
$Res call({
 AquacultureSeason season, int cancelledScheduleCount
});


@override $AquacultureSeasonCopyWith<$Res> get season;

}
/// @nodoc
class __$SeasonCancellationResultCopyWithImpl<$Res>
    implements _$SeasonCancellationResultCopyWith<$Res> {
  __$SeasonCancellationResultCopyWithImpl(this._self, this._then);

  final _SeasonCancellationResult _self;
  final $Res Function(_SeasonCancellationResult) _then;

/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? cancelledScheduleCount = null,}) {
  return _then(_SeasonCancellationResult(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as AquacultureSeason,cancelledScheduleCount: null == cancelledScheduleCount ? _self.cancelledScheduleCount : cancelledScheduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SeasonCancellationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AquacultureSeasonCopyWith<$Res> get season {
  
  return $AquacultureSeasonCopyWith<$Res>(_self.season, (value) {
    return _then(_self.copyWith(season: value));
  });
}
}

// dart format on
