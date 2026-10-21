// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_supplier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventorySupplier {

 String get id; String get farmId; String get name; String? get contactName; String? get phone; String? get email; String? get address; String? get note; bool get isActive; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of InventorySupplier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySupplierCopyWith<InventorySupplier> get copyWith => _$InventorySupplierCopyWithImpl<InventorySupplier>(this as InventorySupplier, _$identity);

  /// Serializes this InventorySupplier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySupplier&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.note, note) || other.note == note)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,name,contactName,phone,email,address,note,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'InventorySupplier(id: $id, farmId: $farmId, name: $name, contactName: $contactName, phone: $phone, email: $email, address: $address, note: $note, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InventorySupplierCopyWith<$Res>  {
  factory $InventorySupplierCopyWith(InventorySupplier value, $Res Function(InventorySupplier) _then) = _$InventorySupplierCopyWithImpl;
@useResult
$Res call({
 String id, String farmId, String name, String? contactName, String? phone, String? email, String? address, String? note, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$InventorySupplierCopyWithImpl<$Res>
    implements $InventorySupplierCopyWith<$Res> {
  _$InventorySupplierCopyWithImpl(this._self, this._then);

  final InventorySupplier _self;
  final $Res Function(InventorySupplier) _then;

/// Create a copy of InventorySupplier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? contactName = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? note = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySupplier].
extension InventorySupplierPatterns on InventorySupplier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySupplier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySupplier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySupplier value)  $default,){
final _that = this;
switch (_that) {
case _InventorySupplier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySupplier value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySupplier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  String? contactName,  String? phone,  String? email,  String? address,  String? note,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySupplier() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.contactName,_that.phone,_that.email,_that.address,_that.note,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  String? contactName,  String? phone,  String? email,  String? address,  String? note,  bool isActive,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InventorySupplier():
return $default(_that.id,_that.farmId,_that.name,_that.contactName,_that.phone,_that.email,_that.address,_that.note,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmId,  String name,  String? contactName,  String? phone,  String? email,  String? address,  String? note,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InventorySupplier() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.contactName,_that.phone,_that.email,_that.address,_that.note,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySupplier implements InventorySupplier {
  const _InventorySupplier({required this.id, required this.farmId, required this.name, this.contactName, this.phone, this.email, this.address, this.note, this.isActive = true, required this.createdAt, required this.updatedAt});
  factory _InventorySupplier.fromJson(Map<String, dynamic> json) => _$InventorySupplierFromJson(json);

@override final  String id;
@override final  String farmId;
@override final  String name;
@override final  String? contactName;
@override final  String? phone;
@override final  String? email;
@override final  String? address;
@override final  String? note;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of InventorySupplier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySupplierCopyWith<_InventorySupplier> get copyWith => __$InventorySupplierCopyWithImpl<_InventorySupplier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySupplierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySupplier&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.note, note) || other.note == note)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,name,contactName,phone,email,address,note,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'InventorySupplier(id: $id, farmId: $farmId, name: $name, contactName: $contactName, phone: $phone, email: $email, address: $address, note: $note, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InventorySupplierCopyWith<$Res> implements $InventorySupplierCopyWith<$Res> {
  factory _$InventorySupplierCopyWith(_InventorySupplier value, $Res Function(_InventorySupplier) _then) = __$InventorySupplierCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmId, String name, String? contactName, String? phone, String? email, String? address, String? note, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$InventorySupplierCopyWithImpl<$Res>
    implements _$InventorySupplierCopyWith<$Res> {
  __$InventorySupplierCopyWithImpl(this._self, this._then);

  final _InventorySupplier _self;
  final $Res Function(_InventorySupplier) _then;

/// Create a copy of InventorySupplier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? contactName = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? note = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_InventorySupplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
