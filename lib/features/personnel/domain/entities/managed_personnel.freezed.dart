// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_personnel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManagedPersonnel {

 String get id; String get email; String? get phone; String? get fullName; String? get avatarUrl;@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole get role;@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus get status; int get currentSeasonAssignments; DateTime get createdAt; DateTime? get activatedAt; DateTime? get lastLoginAt; DateTime? get updatedAt;
/// Create a copy of ManagedPersonnel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedPersonnelCopyWith<ManagedPersonnel> get copyWith => _$ManagedPersonnelCopyWithImpl<ManagedPersonnel>(this as ManagedPersonnel, _$identity);

  /// Serializes this ManagedPersonnel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedPersonnel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentSeasonAssignments, currentSeasonAssignments) || other.currentSeasonAssignments == currentSeasonAssignments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,phone,fullName,avatarUrl,role,status,currentSeasonAssignments,createdAt,activatedAt,lastLoginAt,updatedAt);

@override
String toString() {
  return 'ManagedPersonnel(id: $id, email: $email, phone: $phone, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, status: $status, currentSeasonAssignments: $currentSeasonAssignments, createdAt: $createdAt, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ManagedPersonnelCopyWith<$Res>  {
  factory $ManagedPersonnelCopyWith(ManagedPersonnel value, $Res Function(ManagedPersonnel) _then) = _$ManagedPersonnelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? phone, String? fullName, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, int currentSeasonAssignments, DateTime createdAt, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ManagedPersonnelCopyWithImpl<$Res>
    implements $ManagedPersonnelCopyWith<$Res> {
  _$ManagedPersonnelCopyWithImpl(this._self, this._then);

  final ManagedPersonnel _self;
  final $Res Function(ManagedPersonnel) _then;

/// Create a copy of ManagedPersonnel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? phone = freezed,Object? fullName = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? currentSeasonAssignments = null,Object? createdAt = null,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,currentSeasonAssignments: null == currentSeasonAssignments ? _self.currentSeasonAssignments : currentSeasonAssignments // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedPersonnel].
extension ManagedPersonnelPatterns on ManagedPersonnel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedPersonnel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedPersonnel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedPersonnel value)  $default,){
final _that = this;
switch (_that) {
case _ManagedPersonnel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedPersonnel value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedPersonnel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? phone,  String? fullName,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  int currentSeasonAssignments,  DateTime createdAt,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedPersonnel() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.avatarUrl,_that.role,_that.status,_that.currentSeasonAssignments,_that.createdAt,_that.activatedAt,_that.lastLoginAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? phone,  String? fullName,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  int currentSeasonAssignments,  DateTime createdAt,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedPersonnel():
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.avatarUrl,_that.role,_that.status,_that.currentSeasonAssignments,_that.createdAt,_that.activatedAt,_that.lastLoginAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? phone,  String? fullName,  String? avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole role, @JsonKey(unknownEnumValue: AccountStatus.unknown)  AccountStatus status,  int currentSeasonAssignments,  DateTime createdAt,  DateTime? activatedAt,  DateTime? lastLoginAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedPersonnel() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.fullName,_that.avatarUrl,_that.role,_that.status,_that.currentSeasonAssignments,_that.createdAt,_that.activatedAt,_that.lastLoginAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedPersonnel extends ManagedPersonnel {
  const _ManagedPersonnel({required this.id, required this.email, this.phone, this.fullName, this.avatarUrl, @JsonKey(unknownEnumValue: AccountRole.unknown) required this.role, @JsonKey(unknownEnumValue: AccountStatus.unknown) required this.status, required this.currentSeasonAssignments, required this.createdAt, this.activatedAt, this.lastLoginAt, this.updatedAt}): super._();
  factory _ManagedPersonnel.fromJson(Map<String, dynamic> json) => _$ManagedPersonnelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? phone;
@override final  String? fullName;
@override final  String? avatarUrl;
@override@JsonKey(unknownEnumValue: AccountRole.unknown) final  AccountRole role;
@override@JsonKey(unknownEnumValue: AccountStatus.unknown) final  AccountStatus status;
@override final  int currentSeasonAssignments;
@override final  DateTime createdAt;
@override final  DateTime? activatedAt;
@override final  DateTime? lastLoginAt;
@override final  DateTime? updatedAt;

/// Create a copy of ManagedPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedPersonnelCopyWith<_ManagedPersonnel> get copyWith => __$ManagedPersonnelCopyWithImpl<_ManagedPersonnel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagedPersonnelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedPersonnel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentSeasonAssignments, currentSeasonAssignments) || other.currentSeasonAssignments == currentSeasonAssignments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,phone,fullName,avatarUrl,role,status,currentSeasonAssignments,createdAt,activatedAt,lastLoginAt,updatedAt);

@override
String toString() {
  return 'ManagedPersonnel(id: $id, email: $email, phone: $phone, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, status: $status, currentSeasonAssignments: $currentSeasonAssignments, createdAt: $createdAt, activatedAt: $activatedAt, lastLoginAt: $lastLoginAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedPersonnelCopyWith<$Res> implements $ManagedPersonnelCopyWith<$Res> {
  factory _$ManagedPersonnelCopyWith(_ManagedPersonnel value, $Res Function(_ManagedPersonnel) _then) = __$ManagedPersonnelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? phone, String? fullName, String? avatarUrl,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole role,@JsonKey(unknownEnumValue: AccountStatus.unknown) AccountStatus status, int currentSeasonAssignments, DateTime createdAt, DateTime? activatedAt, DateTime? lastLoginAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ManagedPersonnelCopyWithImpl<$Res>
    implements _$ManagedPersonnelCopyWith<$Res> {
  __$ManagedPersonnelCopyWithImpl(this._self, this._then);

  final _ManagedPersonnel _self;
  final $Res Function(_ManagedPersonnel) _then;

/// Create a copy of ManagedPersonnel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? phone = freezed,Object? fullName = freezed,Object? avatarUrl = freezed,Object? role = null,Object? status = null,Object? currentSeasonAssignments = null,Object? createdAt = null,Object? activatedAt = freezed,Object? lastLoginAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ManagedPersonnel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,currentSeasonAssignments: null == currentSeasonAssignments ? _self.currentSeasonAssignments : currentSeasonAssignments // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ManagedPersonnelPage {

 List<ManagedPersonnel> get items; int get limit; int get totalResults; bool get hasNextPage; String? get nextCursor;
/// Create a copy of ManagedPersonnelPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedPersonnelPageCopyWith<ManagedPersonnelPage> get copyWith => _$ManagedPersonnelPageCopyWithImpl<ManagedPersonnelPage>(this as ManagedPersonnelPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedPersonnelPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),limit,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'ManagedPersonnelPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $ManagedPersonnelPageCopyWith<$Res>  {
  factory $ManagedPersonnelPageCopyWith(ManagedPersonnelPage value, $Res Function(ManagedPersonnelPage) _then) = _$ManagedPersonnelPageCopyWithImpl;
@useResult
$Res call({
 List<ManagedPersonnel> items, int limit, int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$ManagedPersonnelPageCopyWithImpl<$Res>
    implements $ManagedPersonnelPageCopyWith<$Res> {
  _$ManagedPersonnelPageCopyWithImpl(this._self, this._then);

  final ManagedPersonnelPage _self;
  final $Res Function(ManagedPersonnelPage) _then;

/// Create a copy of ManagedPersonnelPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ManagedPersonnel>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedPersonnelPage].
extension ManagedPersonnelPagePatterns on ManagedPersonnelPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedPersonnelPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedPersonnelPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedPersonnelPage value)  $default,){
final _that = this;
switch (_that) {
case _ManagedPersonnelPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedPersonnelPage value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedPersonnelPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ManagedPersonnel> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedPersonnelPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ManagedPersonnel> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ManagedPersonnelPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ManagedPersonnel> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ManagedPersonnelPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedPersonnelPage implements ManagedPersonnelPage {
  const _ManagedPersonnelPage({required final  List<ManagedPersonnel> items, required this.limit, required this.totalResults, required this.hasNextPage, this.nextCursor}): _items = items;
  

 final  List<ManagedPersonnel> _items;
@override List<ManagedPersonnel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int limit;
@override final  int totalResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of ManagedPersonnelPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedPersonnelPageCopyWith<_ManagedPersonnelPage> get copyWith => __$ManagedPersonnelPageCopyWithImpl<_ManagedPersonnelPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedPersonnelPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),limit,totalResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'ManagedPersonnelPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ManagedPersonnelPageCopyWith<$Res> implements $ManagedPersonnelPageCopyWith<$Res> {
  factory _$ManagedPersonnelPageCopyWith(_ManagedPersonnelPage value, $Res Function(_ManagedPersonnelPage) _then) = __$ManagedPersonnelPageCopyWithImpl;
@override @useResult
$Res call({
 List<ManagedPersonnel> items, int limit, int totalResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$ManagedPersonnelPageCopyWithImpl<$Res>
    implements _$ManagedPersonnelPageCopyWith<$Res> {
  __$ManagedPersonnelPageCopyWithImpl(this._self, this._then);

  final _ManagedPersonnelPage _self;
  final $Res Function(_ManagedPersonnelPage) _then;

/// Create a copy of ManagedPersonnelPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_ManagedPersonnelPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ManagedPersonnel>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
