// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryHistoryFilters {

 String get search; DateTime? get fromDate; DateTime? get toDate; InventoryTransactionType? get transactionType; String? get productId; String? get seasonId;
/// Create a copy of InventoryHistoryFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryHistoryFiltersCopyWith<InventoryHistoryFilters> get copyWith => _$InventoryHistoryFiltersCopyWithImpl<InventoryHistoryFilters>(this as InventoryHistoryFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryHistoryFilters&&(identical(other.search, search) || other.search == search)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId));
}


@override
int get hashCode => Object.hash(runtimeType,search,fromDate,toDate,transactionType,productId,seasonId);

@override
String toString() {
  return 'InventoryHistoryFilters(search: $search, fromDate: $fromDate, toDate: $toDate, transactionType: $transactionType, productId: $productId, seasonId: $seasonId)';
}


}

/// @nodoc
abstract mixin class $InventoryHistoryFiltersCopyWith<$Res>  {
  factory $InventoryHistoryFiltersCopyWith(InventoryHistoryFilters value, $Res Function(InventoryHistoryFilters) _then) = _$InventoryHistoryFiltersCopyWithImpl;
@useResult
$Res call({
 String search, DateTime? fromDate, DateTime? toDate, InventoryTransactionType? transactionType, String? productId, String? seasonId
});




}
/// @nodoc
class _$InventoryHistoryFiltersCopyWithImpl<$Res>
    implements $InventoryHistoryFiltersCopyWith<$Res> {
  _$InventoryHistoryFiltersCopyWithImpl(this._self, this._then);

  final InventoryHistoryFilters _self;
  final $Res Function(InventoryHistoryFilters) _then;

/// Create a copy of InventoryHistoryFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? fromDate = freezed,Object? toDate = freezed,Object? transactionType = freezed,Object? productId = freezed,Object? seasonId = freezed,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as InventoryTransactionType?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryHistoryFilters].
extension InventoryHistoryFiltersPatterns on InventoryHistoryFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryHistoryFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryHistoryFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryHistoryFilters value)  $default,){
final _that = this;
switch (_that) {
case _InventoryHistoryFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryHistoryFilters value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryHistoryFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  DateTime? fromDate,  DateTime? toDate,  InventoryTransactionType? transactionType,  String? productId,  String? seasonId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryHistoryFilters() when $default != null:
return $default(_that.search,_that.fromDate,_that.toDate,_that.transactionType,_that.productId,_that.seasonId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  DateTime? fromDate,  DateTime? toDate,  InventoryTransactionType? transactionType,  String? productId,  String? seasonId)  $default,) {final _that = this;
switch (_that) {
case _InventoryHistoryFilters():
return $default(_that.search,_that.fromDate,_that.toDate,_that.transactionType,_that.productId,_that.seasonId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  DateTime? fromDate,  DateTime? toDate,  InventoryTransactionType? transactionType,  String? productId,  String? seasonId)?  $default,) {final _that = this;
switch (_that) {
case _InventoryHistoryFilters() when $default != null:
return $default(_that.search,_that.fromDate,_that.toDate,_that.transactionType,_that.productId,_that.seasonId);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryHistoryFilters extends InventoryHistoryFilters {
  const _InventoryHistoryFilters({this.search = '', this.fromDate, this.toDate, this.transactionType, this.productId, this.seasonId}): super._();
  

@override@JsonKey() final  String search;
@override final  DateTime? fromDate;
@override final  DateTime? toDate;
@override final  InventoryTransactionType? transactionType;
@override final  String? productId;
@override final  String? seasonId;

/// Create a copy of InventoryHistoryFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryHistoryFiltersCopyWith<_InventoryHistoryFilters> get copyWith => __$InventoryHistoryFiltersCopyWithImpl<_InventoryHistoryFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryHistoryFilters&&(identical(other.search, search) || other.search == search)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId));
}


@override
int get hashCode => Object.hash(runtimeType,search,fromDate,toDate,transactionType,productId,seasonId);

@override
String toString() {
  return 'InventoryHistoryFilters(search: $search, fromDate: $fromDate, toDate: $toDate, transactionType: $transactionType, productId: $productId, seasonId: $seasonId)';
}


}

/// @nodoc
abstract mixin class _$InventoryHistoryFiltersCopyWith<$Res> implements $InventoryHistoryFiltersCopyWith<$Res> {
  factory _$InventoryHistoryFiltersCopyWith(_InventoryHistoryFilters value, $Res Function(_InventoryHistoryFilters) _then) = __$InventoryHistoryFiltersCopyWithImpl;
@override @useResult
$Res call({
 String search, DateTime? fromDate, DateTime? toDate, InventoryTransactionType? transactionType, String? productId, String? seasonId
});




}
/// @nodoc
class __$InventoryHistoryFiltersCopyWithImpl<$Res>
    implements _$InventoryHistoryFiltersCopyWith<$Res> {
  __$InventoryHistoryFiltersCopyWithImpl(this._self, this._then);

  final _InventoryHistoryFilters _self;
  final $Res Function(_InventoryHistoryFilters) _then;

/// Create a copy of InventoryHistoryFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? fromDate = freezed,Object? toDate = freezed,Object? transactionType = freezed,Object? productId = freezed,Object? seasonId = freezed,}) {
  return _then(_InventoryHistoryFilters(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as InventoryTransactionType?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventoryLot {

 String get id; String get productId; String get lotNumber; DateTime get receivedAt; double get quantity; String? get quantityExact; DateTime? get expiryDate; double? get receivedQuantity; double get unitPrice; String get supplierName; String? get supplierId; double get inventoryValue; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of InventoryLot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryLotCopyWith<InventoryLot> get copyWith => _$InventoryLotCopyWithImpl<InventoryLot>(this as InventoryLot, _$identity);

  /// Serializes this InventoryLot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryLot&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.quantityExact, quantityExact) || other.quantityExact == quantityExact)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.receivedQuantity, receivedQuantity) || other.receivedQuantity == receivedQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,lotNumber,receivedAt,quantity,quantityExact,expiryDate,receivedQuantity,unitPrice,supplierName,supplierId,inventoryValue,createdAt,updatedAt);

@override
String toString() {
  return 'InventoryLot(id: $id, productId: $productId, lotNumber: $lotNumber, receivedAt: $receivedAt, quantity: $quantity, quantityExact: $quantityExact, expiryDate: $expiryDate, receivedQuantity: $receivedQuantity, unitPrice: $unitPrice, supplierName: $supplierName, supplierId: $supplierId, inventoryValue: $inventoryValue, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InventoryLotCopyWith<$Res>  {
  factory $InventoryLotCopyWith(InventoryLot value, $Res Function(InventoryLot) _then) = _$InventoryLotCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String lotNumber, DateTime receivedAt, double quantity, String? quantityExact, DateTime? expiryDate, double? receivedQuantity, double unitPrice, String supplierName, String? supplierId, double inventoryValue, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$InventoryLotCopyWithImpl<$Res>
    implements $InventoryLotCopyWith<$Res> {
  _$InventoryLotCopyWithImpl(this._self, this._then);

  final InventoryLot _self;
  final $Res Function(InventoryLot) _then;

/// Create a copy of InventoryLot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? lotNumber = null,Object? receivedAt = null,Object? quantity = null,Object? quantityExact = freezed,Object? expiryDate = freezed,Object? receivedQuantity = freezed,Object? unitPrice = null,Object? supplierName = null,Object? supplierId = freezed,Object? inventoryValue = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,quantityExact: freezed == quantityExact ? _self.quantityExact : quantityExact // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryLot].
extension InventoryLotPatterns on InventoryLot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryLot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryLot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryLot value)  $default,){
final _that = this;
switch (_that) {
case _InventoryLot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryLot value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryLot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String lotNumber,  DateTime receivedAt,  double quantity,  String? quantityExact,  DateTime? expiryDate,  double? receivedQuantity,  double unitPrice,  String supplierName,  String? supplierId,  double inventoryValue,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryLot() when $default != null:
return $default(_that.id,_that.productId,_that.lotNumber,_that.receivedAt,_that.quantity,_that.quantityExact,_that.expiryDate,_that.receivedQuantity,_that.unitPrice,_that.supplierName,_that.supplierId,_that.inventoryValue,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String lotNumber,  DateTime receivedAt,  double quantity,  String? quantityExact,  DateTime? expiryDate,  double? receivedQuantity,  double unitPrice,  String supplierName,  String? supplierId,  double inventoryValue,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InventoryLot():
return $default(_that.id,_that.productId,_that.lotNumber,_that.receivedAt,_that.quantity,_that.quantityExact,_that.expiryDate,_that.receivedQuantity,_that.unitPrice,_that.supplierName,_that.supplierId,_that.inventoryValue,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String lotNumber,  DateTime receivedAt,  double quantity,  String? quantityExact,  DateTime? expiryDate,  double? receivedQuantity,  double unitPrice,  String supplierName,  String? supplierId,  double inventoryValue,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InventoryLot() when $default != null:
return $default(_that.id,_that.productId,_that.lotNumber,_that.receivedAt,_that.quantity,_that.quantityExact,_that.expiryDate,_that.receivedQuantity,_that.unitPrice,_that.supplierName,_that.supplierId,_that.inventoryValue,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryLot extends InventoryLot {
  const _InventoryLot({required this.id, required this.productId, required this.lotNumber, required this.receivedAt, required this.quantity, this.quantityExact, this.expiryDate, this.receivedQuantity, required this.unitPrice, required this.supplierName, this.supplierId, required this.inventoryValue, required this.createdAt, required this.updatedAt}): super._();
  factory _InventoryLot.fromJson(Map<String, dynamic> json) => _$InventoryLotFromJson(json);

@override final  String id;
@override final  String productId;
@override final  String lotNumber;
@override final  DateTime receivedAt;
@override final  double quantity;
@override final  String? quantityExact;
@override final  DateTime? expiryDate;
@override final  double? receivedQuantity;
@override final  double unitPrice;
@override final  String supplierName;
@override final  String? supplierId;
@override final  double inventoryValue;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of InventoryLot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryLotCopyWith<_InventoryLot> get copyWith => __$InventoryLotCopyWithImpl<_InventoryLot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryLotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryLot&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.quantityExact, quantityExact) || other.quantityExact == quantityExact)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.receivedQuantity, receivedQuantity) || other.receivedQuantity == receivedQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,lotNumber,receivedAt,quantity,quantityExact,expiryDate,receivedQuantity,unitPrice,supplierName,supplierId,inventoryValue,createdAt,updatedAt);

@override
String toString() {
  return 'InventoryLot(id: $id, productId: $productId, lotNumber: $lotNumber, receivedAt: $receivedAt, quantity: $quantity, quantityExact: $quantityExact, expiryDate: $expiryDate, receivedQuantity: $receivedQuantity, unitPrice: $unitPrice, supplierName: $supplierName, supplierId: $supplierId, inventoryValue: $inventoryValue, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InventoryLotCopyWith<$Res> implements $InventoryLotCopyWith<$Res> {
  factory _$InventoryLotCopyWith(_InventoryLot value, $Res Function(_InventoryLot) _then) = __$InventoryLotCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String lotNumber, DateTime receivedAt, double quantity, String? quantityExact, DateTime? expiryDate, double? receivedQuantity, double unitPrice, String supplierName, String? supplierId, double inventoryValue, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$InventoryLotCopyWithImpl<$Res>
    implements _$InventoryLotCopyWith<$Res> {
  __$InventoryLotCopyWithImpl(this._self, this._then);

  final _InventoryLot _self;
  final $Res Function(_InventoryLot) _then;

/// Create a copy of InventoryLot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? lotNumber = null,Object? receivedAt = null,Object? quantity = null,Object? quantityExact = freezed,Object? expiryDate = freezed,Object? receivedQuantity = freezed,Object? unitPrice = null,Object? supplierName = null,Object? supplierId = freezed,Object? inventoryValue = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_InventoryLot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,quantityExact: freezed == quantityExact ? _self.quantityExact : quantityExact // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$InventoryProduct {

 String get id; String get farmId; String get name; bool get readOnly; String get manufacturerId; Map<String, dynamic> get manufacturer; InventoryCompliance? get compliance; bool get metadataLocked; bool get canDelete; String get status;@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory get category;@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit get unit; double? get conversionQuantity;@JsonKey(unknownEnumValue: InventoryConversionUnit.unknown) InventoryConversionUnit? get conversionUnit;// In conversionUnit for PACK/BOTTLE; otherwise in unit.
 double get minAlertQuantity; String? get description; String? get imageUrl; List<String> get imageUrls; DateTime get createdAt; DateTime get updatedAt; double get currentStock; double get inventoryValue; int get activeLotCount; bool get isLowStock; List<InventoryLot> get lots; int? get plannedUseCount; bool? get canArchive;
/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<InventoryProduct> get copyWith => _$InventoryProductCopyWithImpl<InventoryProduct>(this as InventoryProduct, _$identity);

  /// Serializes this InventoryProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&const DeepCollectionEquality().equals(other.manufacturer, manufacturer)&&(identical(other.compliance, compliance) || other.compliance == compliance)&&(identical(other.metadataLocked, metadataLocked) || other.metadataLocked == metadataLocked)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.conversionQuantity, conversionQuantity) || other.conversionQuantity == conversionQuantity)&&(identical(other.conversionUnit, conversionUnit) || other.conversionUnit == conversionUnit)&&(identical(other.minAlertQuantity, minAlertQuantity) || other.minAlertQuantity == minAlertQuantity)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue)&&(identical(other.activeLotCount, activeLotCount) || other.activeLotCount == activeLotCount)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&const DeepCollectionEquality().equals(other.lots, lots)&&(identical(other.plannedUseCount, plannedUseCount) || other.plannedUseCount == plannedUseCount)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,farmId,name,readOnly,manufacturerId,const DeepCollectionEquality().hash(manufacturer),compliance,metadataLocked,canDelete,status,category,unit,conversionQuantity,conversionUnit,minAlertQuantity,description,imageUrl,const DeepCollectionEquality().hash(imageUrls),createdAt,updatedAt,currentStock,inventoryValue,activeLotCount,isLowStock,const DeepCollectionEquality().hash(lots),plannedUseCount,canArchive]);

@override
String toString() {
  return 'InventoryProduct(id: $id, farmId: $farmId, name: $name, readOnly: $readOnly, manufacturerId: $manufacturerId, manufacturer: $manufacturer, compliance: $compliance, metadataLocked: $metadataLocked, canDelete: $canDelete, status: $status, category: $category, unit: $unit, conversionQuantity: $conversionQuantity, conversionUnit: $conversionUnit, minAlertQuantity: $minAlertQuantity, description: $description, imageUrl: $imageUrl, imageUrls: $imageUrls, createdAt: $createdAt, updatedAt: $updatedAt, currentStock: $currentStock, inventoryValue: $inventoryValue, activeLotCount: $activeLotCount, isLowStock: $isLowStock, lots: $lots, plannedUseCount: $plannedUseCount, canArchive: $canArchive)';
}


}

/// @nodoc
abstract mixin class $InventoryProductCopyWith<$Res>  {
  factory $InventoryProductCopyWith(InventoryProduct value, $Res Function(InventoryProduct) _then) = _$InventoryProductCopyWithImpl;
@useResult
$Res call({
 String id, String farmId, String name, bool readOnly, String manufacturerId, Map<String, dynamic> manufacturer, InventoryCompliance? compliance, bool metadataLocked, bool canDelete, String status,@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory category,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unit, double? conversionQuantity,@JsonKey(unknownEnumValue: InventoryConversionUnit.unknown) InventoryConversionUnit? conversionUnit, double minAlertQuantity, String? description, String? imageUrl, List<String> imageUrls, DateTime createdAt, DateTime updatedAt, double currentStock, double inventoryValue, int activeLotCount, bool isLowStock, List<InventoryLot> lots, int? plannedUseCount, bool? canArchive
});


$InventoryComplianceCopyWith<$Res>? get compliance;

}
/// @nodoc
class _$InventoryProductCopyWithImpl<$Res>
    implements $InventoryProductCopyWith<$Res> {
  _$InventoryProductCopyWithImpl(this._self, this._then);

  final InventoryProduct _self;
  final $Res Function(InventoryProduct) _then;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? readOnly = null,Object? manufacturerId = null,Object? manufacturer = null,Object? compliance = freezed,Object? metadataLocked = null,Object? canDelete = null,Object? status = null,Object? category = null,Object? unit = null,Object? conversionQuantity = freezed,Object? conversionUnit = freezed,Object? minAlertQuantity = null,Object? description = freezed,Object? imageUrl = freezed,Object? imageUrls = null,Object? createdAt = null,Object? updatedAt = null,Object? currentStock = null,Object? inventoryValue = null,Object? activeLotCount = null,Object? isLowStock = null,Object? lots = null,Object? plannedUseCount = freezed,Object? canArchive = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,manufacturerId: null == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,compliance: freezed == compliance ? _self.compliance : compliance // ignore: cast_nullable_to_non_nullable
as InventoryCompliance?,metadataLocked: null == metadataLocked ? _self.metadataLocked : metadataLocked // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryProductCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,conversionQuantity: freezed == conversionQuantity ? _self.conversionQuantity : conversionQuantity // ignore: cast_nullable_to_non_nullable
as double?,conversionUnit: freezed == conversionUnit ? _self.conversionUnit : conversionUnit // ignore: cast_nullable_to_non_nullable
as InventoryConversionUnit?,minAlertQuantity: null == minAlertQuantity ? _self.minAlertQuantity : minAlertQuantity // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,activeLotCount: null == activeLotCount ? _self.activeLotCount : activeLotCount // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,lots: null == lots ? _self.lots : lots // ignore: cast_nullable_to_non_nullable
as List<InventoryLot>,plannedUseCount: freezed == plannedUseCount ? _self.plannedUseCount : plannedUseCount // ignore: cast_nullable_to_non_nullable
as int?,canArchive: freezed == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryComplianceCopyWith<$Res>? get compliance {
    if (_self.compliance == null) {
    return null;
  }

  return $InventoryComplianceCopyWith<$Res>(_self.compliance!, (value) {
    return _then(_self.copyWith(compliance: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryProduct].
extension InventoryProductPatterns on InventoryProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryProduct value)  $default,){
final _that = this;
switch (_that) {
case _InventoryProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryProduct value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  bool readOnly,  String manufacturerId,  Map<String, dynamic> manufacturer,  InventoryCompliance? compliance,  bool metadataLocked,  bool canDelete,  String status, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit,  double? conversionQuantity, @JsonKey(unknownEnumValue: InventoryConversionUnit.unknown)  InventoryConversionUnit? conversionUnit,  double minAlertQuantity,  String? description,  String? imageUrl,  List<String> imageUrls,  DateTime createdAt,  DateTime updatedAt,  double currentStock,  double inventoryValue,  int activeLotCount,  bool isLowStock,  List<InventoryLot> lots,  int? plannedUseCount,  bool? canArchive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.readOnly,_that.manufacturerId,_that.manufacturer,_that.compliance,_that.metadataLocked,_that.canDelete,_that.status,_that.category,_that.unit,_that.conversionQuantity,_that.conversionUnit,_that.minAlertQuantity,_that.description,_that.imageUrl,_that.imageUrls,_that.createdAt,_that.updatedAt,_that.currentStock,_that.inventoryValue,_that.activeLotCount,_that.isLowStock,_that.lots,_that.plannedUseCount,_that.canArchive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmId,  String name,  bool readOnly,  String manufacturerId,  Map<String, dynamic> manufacturer,  InventoryCompliance? compliance,  bool metadataLocked,  bool canDelete,  String status, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit,  double? conversionQuantity, @JsonKey(unknownEnumValue: InventoryConversionUnit.unknown)  InventoryConversionUnit? conversionUnit,  double minAlertQuantity,  String? description,  String? imageUrl,  List<String> imageUrls,  DateTime createdAt,  DateTime updatedAt,  double currentStock,  double inventoryValue,  int activeLotCount,  bool isLowStock,  List<InventoryLot> lots,  int? plannedUseCount,  bool? canArchive)  $default,) {final _that = this;
switch (_that) {
case _InventoryProduct():
return $default(_that.id,_that.farmId,_that.name,_that.readOnly,_that.manufacturerId,_that.manufacturer,_that.compliance,_that.metadataLocked,_that.canDelete,_that.status,_that.category,_that.unit,_that.conversionQuantity,_that.conversionUnit,_that.minAlertQuantity,_that.description,_that.imageUrl,_that.imageUrls,_that.createdAt,_that.updatedAt,_that.currentStock,_that.inventoryValue,_that.activeLotCount,_that.isLowStock,_that.lots,_that.plannedUseCount,_that.canArchive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmId,  String name,  bool readOnly,  String manufacturerId,  Map<String, dynamic> manufacturer,  InventoryCompliance? compliance,  bool metadataLocked,  bool canDelete,  String status, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit,  double? conversionQuantity, @JsonKey(unknownEnumValue: InventoryConversionUnit.unknown)  InventoryConversionUnit? conversionUnit,  double minAlertQuantity,  String? description,  String? imageUrl,  List<String> imageUrls,  DateTime createdAt,  DateTime updatedAt,  double currentStock,  double inventoryValue,  int activeLotCount,  bool isLowStock,  List<InventoryLot> lots,  int? plannedUseCount,  bool? canArchive)?  $default,) {final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
return $default(_that.id,_that.farmId,_that.name,_that.readOnly,_that.manufacturerId,_that.manufacturer,_that.compliance,_that.metadataLocked,_that.canDelete,_that.status,_that.category,_that.unit,_that.conversionQuantity,_that.conversionUnit,_that.minAlertQuantity,_that.description,_that.imageUrl,_that.imageUrls,_that.createdAt,_that.updatedAt,_that.currentStock,_that.inventoryValue,_that.activeLotCount,_that.isLowStock,_that.lots,_that.plannedUseCount,_that.canArchive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryProduct extends InventoryProduct {
  const _InventoryProduct({required this.id, required this.farmId, required this.name, this.readOnly = false, this.manufacturerId = '', final  Map<String, dynamic> manufacturer = const <String, dynamic>{}, this.compliance, this.metadataLocked = false, this.canDelete = false, this.status = 'ACTIVE', @JsonKey(unknownEnumValue: InventoryProductCategory.unknown) required this.category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown) required this.unit, this.conversionQuantity, @JsonKey(unknownEnumValue: InventoryConversionUnit.unknown) this.conversionUnit, required this.minAlertQuantity, this.description, this.imageUrl, final  List<String> imageUrls = const <String>[], required this.createdAt, required this.updatedAt, required this.currentStock, required this.inventoryValue, required this.activeLotCount, required this.isLowStock, final  List<InventoryLot> lots = const <InventoryLot>[], this.plannedUseCount, this.canArchive}): _manufacturer = manufacturer,_imageUrls = imageUrls,_lots = lots,super._();
  factory _InventoryProduct.fromJson(Map<String, dynamic> json) => _$InventoryProductFromJson(json);

@override final  String id;
@override final  String farmId;
@override final  String name;
@override@JsonKey() final  bool readOnly;
@override@JsonKey() final  String manufacturerId;
 final  Map<String, dynamic> _manufacturer;
@override@JsonKey() Map<String, dynamic> get manufacturer {
  if (_manufacturer is EqualUnmodifiableMapView) return _manufacturer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_manufacturer);
}

@override final  InventoryCompliance? compliance;
@override@JsonKey() final  bool metadataLocked;
@override@JsonKey() final  bool canDelete;
@override@JsonKey() final  String status;
@override@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) final  InventoryProductCategory category;
@override@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) final  InventoryProductUnit unit;
@override final  double? conversionQuantity;
@override@JsonKey(unknownEnumValue: InventoryConversionUnit.unknown) final  InventoryConversionUnit? conversionUnit;
// In conversionUnit for PACK/BOTTLE; otherwise in unit.
@override final  double minAlertQuantity;
@override final  String? description;
@override final  String? imageUrl;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  double currentStock;
@override final  double inventoryValue;
@override final  int activeLotCount;
@override final  bool isLowStock;
 final  List<InventoryLot> _lots;
@override@JsonKey() List<InventoryLot> get lots {
  if (_lots is EqualUnmodifiableListView) return _lots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lots);
}

@override final  int? plannedUseCount;
@override final  bool? canArchive;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryProductCopyWith<_InventoryProduct> get copyWith => __$InventoryProductCopyWithImpl<_InventoryProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.name, name) || other.name == name)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&const DeepCollectionEquality().equals(other._manufacturer, _manufacturer)&&(identical(other.compliance, compliance) || other.compliance == compliance)&&(identical(other.metadataLocked, metadataLocked) || other.metadataLocked == metadataLocked)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.conversionQuantity, conversionQuantity) || other.conversionQuantity == conversionQuantity)&&(identical(other.conversionUnit, conversionUnit) || other.conversionUnit == conversionUnit)&&(identical(other.minAlertQuantity, minAlertQuantity) || other.minAlertQuantity == minAlertQuantity)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue)&&(identical(other.activeLotCount, activeLotCount) || other.activeLotCount == activeLotCount)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&const DeepCollectionEquality().equals(other._lots, _lots)&&(identical(other.plannedUseCount, plannedUseCount) || other.plannedUseCount == plannedUseCount)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,farmId,name,readOnly,manufacturerId,const DeepCollectionEquality().hash(_manufacturer),compliance,metadataLocked,canDelete,status,category,unit,conversionQuantity,conversionUnit,minAlertQuantity,description,imageUrl,const DeepCollectionEquality().hash(_imageUrls),createdAt,updatedAt,currentStock,inventoryValue,activeLotCount,isLowStock,const DeepCollectionEquality().hash(_lots),plannedUseCount,canArchive]);

@override
String toString() {
  return 'InventoryProduct(id: $id, farmId: $farmId, name: $name, readOnly: $readOnly, manufacturerId: $manufacturerId, manufacturer: $manufacturer, compliance: $compliance, metadataLocked: $metadataLocked, canDelete: $canDelete, status: $status, category: $category, unit: $unit, conversionQuantity: $conversionQuantity, conversionUnit: $conversionUnit, minAlertQuantity: $minAlertQuantity, description: $description, imageUrl: $imageUrl, imageUrls: $imageUrls, createdAt: $createdAt, updatedAt: $updatedAt, currentStock: $currentStock, inventoryValue: $inventoryValue, activeLotCount: $activeLotCount, isLowStock: $isLowStock, lots: $lots, plannedUseCount: $plannedUseCount, canArchive: $canArchive)';
}


}

/// @nodoc
abstract mixin class _$InventoryProductCopyWith<$Res> implements $InventoryProductCopyWith<$Res> {
  factory _$InventoryProductCopyWith(_InventoryProduct value, $Res Function(_InventoryProduct) _then) = __$InventoryProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmId, String name, bool readOnly, String manufacturerId, Map<String, dynamic> manufacturer, InventoryCompliance? compliance, bool metadataLocked, bool canDelete, String status,@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory category,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unit, double? conversionQuantity,@JsonKey(unknownEnumValue: InventoryConversionUnit.unknown) InventoryConversionUnit? conversionUnit, double minAlertQuantity, String? description, String? imageUrl, List<String> imageUrls, DateTime createdAt, DateTime updatedAt, double currentStock, double inventoryValue, int activeLotCount, bool isLowStock, List<InventoryLot> lots, int? plannedUseCount, bool? canArchive
});


@override $InventoryComplianceCopyWith<$Res>? get compliance;

}
/// @nodoc
class __$InventoryProductCopyWithImpl<$Res>
    implements _$InventoryProductCopyWith<$Res> {
  __$InventoryProductCopyWithImpl(this._self, this._then);

  final _InventoryProduct _self;
  final $Res Function(_InventoryProduct) _then;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmId = null,Object? name = null,Object? readOnly = null,Object? manufacturerId = null,Object? manufacturer = null,Object? compliance = freezed,Object? metadataLocked = null,Object? canDelete = null,Object? status = null,Object? category = null,Object? unit = null,Object? conversionQuantity = freezed,Object? conversionUnit = freezed,Object? minAlertQuantity = null,Object? description = freezed,Object? imageUrl = freezed,Object? imageUrls = null,Object? createdAt = null,Object? updatedAt = null,Object? currentStock = null,Object? inventoryValue = null,Object? activeLotCount = null,Object? isLowStock = null,Object? lots = null,Object? plannedUseCount = freezed,Object? canArchive = freezed,}) {
  return _then(_InventoryProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,manufacturerId: null == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self._manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,compliance: freezed == compliance ? _self.compliance : compliance // ignore: cast_nullable_to_non_nullable
as InventoryCompliance?,metadataLocked: null == metadataLocked ? _self.metadataLocked : metadataLocked // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryProductCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,conversionQuantity: freezed == conversionQuantity ? _self.conversionQuantity : conversionQuantity // ignore: cast_nullable_to_non_nullable
as double?,conversionUnit: freezed == conversionUnit ? _self.conversionUnit : conversionUnit // ignore: cast_nullable_to_non_nullable
as InventoryConversionUnit?,minAlertQuantity: null == minAlertQuantity ? _self.minAlertQuantity : minAlertQuantity // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,activeLotCount: null == activeLotCount ? _self.activeLotCount : activeLotCount // ignore: cast_nullable_to_non_nullable
as int,isLowStock: null == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool,lots: null == lots ? _self._lots : lots // ignore: cast_nullable_to_non_nullable
as List<InventoryLot>,plannedUseCount: freezed == plannedUseCount ? _self.plannedUseCount : plannedUseCount // ignore: cast_nullable_to_non_nullable
as int?,canArchive: freezed == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryComplianceCopyWith<$Res>? get compliance {
    if (_self.compliance == null) {
    return null;
  }

  return $InventoryComplianceCopyWith<$Res>(_self.compliance!, (value) {
    return _then(_self.copyWith(compliance: value));
  });
}
}


/// @nodoc
mixin _$InventorySummary {

 int get totalProducts; int get lowStockCount; double get inventoryValue;
/// Create a copy of InventorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySummaryCopyWith<InventorySummary> get copyWith => _$InventorySummaryCopyWithImpl<InventorySummary>(this as InventorySummary, _$identity);

  /// Serializes this InventorySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySummary&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalProducts,lowStockCount,inventoryValue);

@override
String toString() {
  return 'InventorySummary(totalProducts: $totalProducts, lowStockCount: $lowStockCount, inventoryValue: $inventoryValue)';
}


}

/// @nodoc
abstract mixin class $InventorySummaryCopyWith<$Res>  {
  factory $InventorySummaryCopyWith(InventorySummary value, $Res Function(InventorySummary) _then) = _$InventorySummaryCopyWithImpl;
@useResult
$Res call({
 int totalProducts, int lowStockCount, double inventoryValue
});




}
/// @nodoc
class _$InventorySummaryCopyWithImpl<$Res>
    implements $InventorySummaryCopyWith<$Res> {
  _$InventorySummaryCopyWithImpl(this._self, this._then);

  final InventorySummary _self;
  final $Res Function(InventorySummary) _then;

/// Create a copy of InventorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalProducts = null,Object? lowStockCount = null,Object? inventoryValue = null,}) {
  return _then(_self.copyWith(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySummary].
extension InventorySummaryPatterns on InventorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySummary value)  $default,){
final _that = this;
switch (_that) {
case _InventorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalProducts,  int lowStockCount,  double inventoryValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySummary() when $default != null:
return $default(_that.totalProducts,_that.lowStockCount,_that.inventoryValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalProducts,  int lowStockCount,  double inventoryValue)  $default,) {final _that = this;
switch (_that) {
case _InventorySummary():
return $default(_that.totalProducts,_that.lowStockCount,_that.inventoryValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalProducts,  int lowStockCount,  double inventoryValue)?  $default,) {final _that = this;
switch (_that) {
case _InventorySummary() when $default != null:
return $default(_that.totalProducts,_that.lowStockCount,_that.inventoryValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySummary implements InventorySummary {
  const _InventorySummary({required this.totalProducts, required this.lowStockCount, required this.inventoryValue});
  factory _InventorySummary.fromJson(Map<String, dynamic> json) => _$InventorySummaryFromJson(json);

@override final  int totalProducts;
@override final  int lowStockCount;
@override final  double inventoryValue;

/// Create a copy of InventorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySummaryCopyWith<_InventorySummary> get copyWith => __$InventorySummaryCopyWithImpl<_InventorySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySummary&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&(identical(other.inventoryValue, inventoryValue) || other.inventoryValue == inventoryValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalProducts,lowStockCount,inventoryValue);

@override
String toString() {
  return 'InventorySummary(totalProducts: $totalProducts, lowStockCount: $lowStockCount, inventoryValue: $inventoryValue)';
}


}

/// @nodoc
abstract mixin class _$InventorySummaryCopyWith<$Res> implements $InventorySummaryCopyWith<$Res> {
  factory _$InventorySummaryCopyWith(_InventorySummary value, $Res Function(_InventorySummary) _then) = __$InventorySummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalProducts, int lowStockCount, double inventoryValue
});




}
/// @nodoc
class __$InventorySummaryCopyWithImpl<$Res>
    implements _$InventorySummaryCopyWith<$Res> {
  __$InventorySummaryCopyWithImpl(this._self, this._then);

  final _InventorySummary _self;
  final $Res Function(_InventorySummary) _then;

/// Create a copy of InventorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalProducts = null,Object? lowStockCount = null,Object? inventoryValue = null,}) {
  return _then(_InventorySummary(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,inventoryValue: null == inventoryValue ? _self.inventoryValue : inventoryValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InventoryProductPage {

 bool get readOnly; List<InventoryProduct> get items; int get page; int get limit; int get totalResults; int get totalPages; bool get hasNextPage; InventorySummary get summary;
/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryProductPageCopyWith<InventoryProductPage> get copyWith => _$InventoryProductPageCopyWithImpl<InventoryProductPage>(this as InventoryProductPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryProductPage&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,readOnly,const DeepCollectionEquality().hash(items),page,limit,totalResults,totalPages,hasNextPage,summary);

@override
String toString() {
  return 'InventoryProductPage(readOnly: $readOnly, items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages, hasNextPage: $hasNextPage, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $InventoryProductPageCopyWith<$Res>  {
  factory $InventoryProductPageCopyWith(InventoryProductPage value, $Res Function(InventoryProductPage) _then) = _$InventoryProductPageCopyWithImpl;
@useResult
$Res call({
 bool readOnly, List<InventoryProduct> items, int page, int limit, int totalResults, int totalPages, bool hasNextPage, InventorySummary summary
});


$InventorySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$InventoryProductPageCopyWithImpl<$Res>
    implements $InventoryProductPageCopyWith<$Res> {
  _$InventoryProductPageCopyWithImpl(this._self, this._then);

  final InventoryProductPage _self;
  final $Res Function(InventoryProductPage) _then;

/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? readOnly = null,Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,Object? hasNextPage = null,Object? summary = null,}) {
  return _then(_self.copyWith(
readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryProduct>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as InventorySummary,
  ));
}
/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySummaryCopyWith<$Res> get summary {
  
  return $InventorySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryProductPage].
extension InventoryProductPagePatterns on InventoryProductPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryProductPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryProductPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryProductPage value)  $default,){
final _that = this;
switch (_that) {
case _InventoryProductPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryProductPage value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryProductPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool readOnly,  List<InventoryProduct> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage,  InventorySummary summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryProductPage() when $default != null:
return $default(_that.readOnly,_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool readOnly,  List<InventoryProduct> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage,  InventorySummary summary)  $default,) {final _that = this;
switch (_that) {
case _InventoryProductPage():
return $default(_that.readOnly,_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool readOnly,  List<InventoryProduct> items,  int page,  int limit,  int totalResults,  int totalPages,  bool hasNextPage,  InventorySummary summary)?  $default,) {final _that = this;
switch (_that) {
case _InventoryProductPage() when $default != null:
return $default(_that.readOnly,_that.items,_that.page,_that.limit,_that.totalResults,_that.totalPages,_that.hasNextPage,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryProductPage implements InventoryProductPage {
  const _InventoryProductPage({this.readOnly = false, required final  List<InventoryProduct> items, required this.page, required this.limit, required this.totalResults, required this.totalPages, required this.hasNextPage, required this.summary}): _items = items;
  

@override@JsonKey() final  bool readOnly;
 final  List<InventoryProduct> _items;
@override List<InventoryProduct> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int limit;
@override final  int totalResults;
@override final  int totalPages;
@override final  bool hasNextPage;
@override final  InventorySummary summary;

/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryProductPageCopyWith<_InventoryProductPage> get copyWith => __$InventoryProductPageCopyWithImpl<_InventoryProductPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryProductPage&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,readOnly,const DeepCollectionEquality().hash(_items),page,limit,totalResults,totalPages,hasNextPage,summary);

@override
String toString() {
  return 'InventoryProductPage(readOnly: $readOnly, items: $items, page: $page, limit: $limit, totalResults: $totalResults, totalPages: $totalPages, hasNextPage: $hasNextPage, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$InventoryProductPageCopyWith<$Res> implements $InventoryProductPageCopyWith<$Res> {
  factory _$InventoryProductPageCopyWith(_InventoryProductPage value, $Res Function(_InventoryProductPage) _then) = __$InventoryProductPageCopyWithImpl;
@override @useResult
$Res call({
 bool readOnly, List<InventoryProduct> items, int page, int limit, int totalResults, int totalPages, bool hasNextPage, InventorySummary summary
});


@override $InventorySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$InventoryProductPageCopyWithImpl<$Res>
    implements _$InventoryProductPageCopyWith<$Res> {
  __$InventoryProductPageCopyWithImpl(this._self, this._then);

  final _InventoryProductPage _self;
  final $Res Function(_InventoryProductPage) _then;

/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? readOnly = null,Object? items = null,Object? page = null,Object? limit = null,Object? totalResults = null,Object? totalPages = null,Object? hasNextPage = null,Object? summary = null,}) {
  return _then(_InventoryProductPage(
readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryProduct>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as InventorySummary,
  ));
}

/// Create a copy of InventoryProductPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySummaryCopyWith<$Res> get summary {
  
  return $InventorySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$InventoryTransactionProduct {

 String get id; String get name;@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory get category;@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit get unit;
/// Create a copy of InventoryTransactionProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryTransactionProductCopyWith<InventoryTransactionProduct> get copyWith => _$InventoryTransactionProductCopyWithImpl<InventoryTransactionProduct>(this as InventoryTransactionProduct, _$identity);

  /// Serializes this InventoryTransactionProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryTransactionProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,unit);

@override
String toString() {
  return 'InventoryTransactionProduct(id: $id, name: $name, category: $category, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $InventoryTransactionProductCopyWith<$Res>  {
  factory $InventoryTransactionProductCopyWith(InventoryTransactionProduct value, $Res Function(InventoryTransactionProduct) _then) = _$InventoryTransactionProductCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory category,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unit
});




}
/// @nodoc
class _$InventoryTransactionProductCopyWithImpl<$Res>
    implements $InventoryTransactionProductCopyWith<$Res> {
  _$InventoryTransactionProductCopyWithImpl(this._self, this._then);

  final InventoryTransactionProduct _self;
  final $Res Function(InventoryTransactionProduct) _then;

/// Create a copy of InventoryTransactionProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? unit = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryProductCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryTransactionProduct].
extension InventoryTransactionProductPatterns on InventoryTransactionProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryTransactionProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryTransactionProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryTransactionProduct value)  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryTransactionProduct value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryTransactionProduct() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit)  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionProduct():
return $default(_that.id,_that.name,_that.category,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown)  InventoryProductCategory category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unit)?  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionProduct() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryTransactionProduct implements InventoryTransactionProduct {
  const _InventoryTransactionProduct({required this.id, required this.name, @JsonKey(unknownEnumValue: InventoryProductCategory.unknown) required this.category, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown) required this.unit});
  factory _InventoryTransactionProduct.fromJson(Map<String, dynamic> json) => _$InventoryTransactionProductFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) final  InventoryProductCategory category;
@override@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) final  InventoryProductUnit unit;

/// Create a copy of InventoryTransactionProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryTransactionProductCopyWith<_InventoryTransactionProduct> get copyWith => __$InventoryTransactionProductCopyWithImpl<_InventoryTransactionProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryTransactionProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryTransactionProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,unit);

@override
String toString() {
  return 'InventoryTransactionProduct(id: $id, name: $name, category: $category, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$InventoryTransactionProductCopyWith<$Res> implements $InventoryTransactionProductCopyWith<$Res> {
  factory _$InventoryTransactionProductCopyWith(_InventoryTransactionProduct value, $Res Function(_InventoryTransactionProduct) _then) = __$InventoryTransactionProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: InventoryProductCategory.unknown) InventoryProductCategory category,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unit
});




}
/// @nodoc
class __$InventoryTransactionProductCopyWithImpl<$Res>
    implements _$InventoryTransactionProductCopyWith<$Res> {
  __$InventoryTransactionProductCopyWithImpl(this._self, this._then);

  final _InventoryTransactionProduct _self;
  final $Res Function(_InventoryTransactionProduct) _then;

/// Create a copy of InventoryTransactionProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? unit = null,}) {
  return _then(_InventoryTransactionProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryProductCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,
  ));
}


}


/// @nodoc
mixin _$InventoryTransactionSeason {

 String get id; String get name; String? get pondName;
/// Create a copy of InventoryTransactionSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryTransactionSeasonCopyWith<InventoryTransactionSeason> get copyWith => _$InventoryTransactionSeasonCopyWithImpl<InventoryTransactionSeason>(this as InventoryTransactionSeason, _$identity);

  /// Serializes this InventoryTransactionSeason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryTransactionSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pondName, pondName) || other.pondName == pondName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pondName);

@override
String toString() {
  return 'InventoryTransactionSeason(id: $id, name: $name, pondName: $pondName)';
}


}

/// @nodoc
abstract mixin class $InventoryTransactionSeasonCopyWith<$Res>  {
  factory $InventoryTransactionSeasonCopyWith(InventoryTransactionSeason value, $Res Function(InventoryTransactionSeason) _then) = _$InventoryTransactionSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? pondName
});




}
/// @nodoc
class _$InventoryTransactionSeasonCopyWithImpl<$Res>
    implements $InventoryTransactionSeasonCopyWith<$Res> {
  _$InventoryTransactionSeasonCopyWithImpl(this._self, this._then);

  final InventoryTransactionSeason _self;
  final $Res Function(InventoryTransactionSeason) _then;

/// Create a copy of InventoryTransactionSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pondName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pondName: freezed == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryTransactionSeason].
extension InventoryTransactionSeasonPatterns on InventoryTransactionSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryTransactionSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryTransactionSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryTransactionSeason value)  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryTransactionSeason value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? pondName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryTransactionSeason() when $default != null:
return $default(_that.id,_that.name,_that.pondName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? pondName)  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionSeason():
return $default(_that.id,_that.name,_that.pondName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? pondName)?  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionSeason() when $default != null:
return $default(_that.id,_that.name,_that.pondName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryTransactionSeason implements InventoryTransactionSeason {
  const _InventoryTransactionSeason({required this.id, required this.name, this.pondName});
  factory _InventoryTransactionSeason.fromJson(Map<String, dynamic> json) => _$InventoryTransactionSeasonFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? pondName;

/// Create a copy of InventoryTransactionSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryTransactionSeasonCopyWith<_InventoryTransactionSeason> get copyWith => __$InventoryTransactionSeasonCopyWithImpl<_InventoryTransactionSeason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryTransactionSeasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryTransactionSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pondName, pondName) || other.pondName == pondName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pondName);

@override
String toString() {
  return 'InventoryTransactionSeason(id: $id, name: $name, pondName: $pondName)';
}


}

/// @nodoc
abstract mixin class _$InventoryTransactionSeasonCopyWith<$Res> implements $InventoryTransactionSeasonCopyWith<$Res> {
  factory _$InventoryTransactionSeasonCopyWith(_InventoryTransactionSeason value, $Res Function(_InventoryTransactionSeason) _then) = __$InventoryTransactionSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? pondName
});




}
/// @nodoc
class __$InventoryTransactionSeasonCopyWithImpl<$Res>
    implements _$InventoryTransactionSeasonCopyWith<$Res> {
  __$InventoryTransactionSeasonCopyWithImpl(this._self, this._then);

  final _InventoryTransactionSeason _self;
  final $Res Function(_InventoryTransactionSeason) _then;

/// Create a copy of InventoryTransactionSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pondName = freezed,}) {
  return _then(_InventoryTransactionSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pondName: freezed == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventoryTransactionPerformer {

 String get id; String? get fullName; String get email;
/// Create a copy of InventoryTransactionPerformer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryTransactionPerformerCopyWith<InventoryTransactionPerformer> get copyWith => _$InventoryTransactionPerformerCopyWithImpl<InventoryTransactionPerformer>(this as InventoryTransactionPerformer, _$identity);

  /// Serializes this InventoryTransactionPerformer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryTransactionPerformer&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email);

@override
String toString() {
  return 'InventoryTransactionPerformer(id: $id, fullName: $fullName, email: $email)';
}


}

/// @nodoc
abstract mixin class $InventoryTransactionPerformerCopyWith<$Res>  {
  factory $InventoryTransactionPerformerCopyWith(InventoryTransactionPerformer value, $Res Function(InventoryTransactionPerformer) _then) = _$InventoryTransactionPerformerCopyWithImpl;
@useResult
$Res call({
 String id, String? fullName, String email
});




}
/// @nodoc
class _$InventoryTransactionPerformerCopyWithImpl<$Res>
    implements $InventoryTransactionPerformerCopyWith<$Res> {
  _$InventoryTransactionPerformerCopyWithImpl(this._self, this._then);

  final InventoryTransactionPerformer _self;
  final $Res Function(InventoryTransactionPerformer) _then;

/// Create a copy of InventoryTransactionPerformer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = freezed,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryTransactionPerformer].
extension InventoryTransactionPerformerPatterns on InventoryTransactionPerformer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryTransactionPerformer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryTransactionPerformer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryTransactionPerformer value)  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionPerformer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryTransactionPerformer value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryTransactionPerformer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? fullName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryTransactionPerformer() when $default != null:
return $default(_that.id,_that.fullName,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? fullName,  String email)  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionPerformer():
return $default(_that.id,_that.fullName,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? fullName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _InventoryTransactionPerformer() when $default != null:
return $default(_that.id,_that.fullName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryTransactionPerformer implements InventoryTransactionPerformer {
  const _InventoryTransactionPerformer({required this.id, this.fullName, required this.email});
  factory _InventoryTransactionPerformer.fromJson(Map<String, dynamic> json) => _$InventoryTransactionPerformerFromJson(json);

@override final  String id;
@override final  String? fullName;
@override final  String email;

/// Create a copy of InventoryTransactionPerformer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryTransactionPerformerCopyWith<_InventoryTransactionPerformer> get copyWith => __$InventoryTransactionPerformerCopyWithImpl<_InventoryTransactionPerformer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryTransactionPerformerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryTransactionPerformer&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email);

@override
String toString() {
  return 'InventoryTransactionPerformer(id: $id, fullName: $fullName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$InventoryTransactionPerformerCopyWith<$Res> implements $InventoryTransactionPerformerCopyWith<$Res> {
  factory _$InventoryTransactionPerformerCopyWith(_InventoryTransactionPerformer value, $Res Function(_InventoryTransactionPerformer) _then) = __$InventoryTransactionPerformerCopyWithImpl;
@override @useResult
$Res call({
 String id, String? fullName, String email
});




}
/// @nodoc
class __$InventoryTransactionPerformerCopyWithImpl<$Res>
    implements _$InventoryTransactionPerformerCopyWith<$Res> {
  __$InventoryTransactionPerformerCopyWithImpl(this._self, this._then);

  final _InventoryTransactionPerformer _self;
  final $Res Function(_InventoryTransactionPerformer) _then;

/// Create a copy of InventoryTransactionPerformer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = freezed,Object? email = null,}) {
  return _then(_InventoryTransactionPerformer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InventoryTransaction {

 String get id; String get transactionGroupId; String get productId; String get inventoryBalanceId; String? get seasonId;@JsonKey(unknownEnumValue: InventoryTransactionType.unknown) InventoryTransactionType get transactionType; double get quantity;@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit get unitSnapshot; double get totalAmount; String? get referenceType; String? get referenceId; String? get reason; String get performedBy; DateTime get createdAt; InventoryTransactionProduct get product; InventoryLot get inventoryBalance; InventoryTransactionSeason? get season; InventoryTransactionPerformer get performer;
/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryTransactionCopyWith<InventoryTransaction> get copyWith => _$InventoryTransactionCopyWithImpl<InventoryTransaction>(this as InventoryTransaction, _$identity);

  /// Serializes this InventoryTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionGroupId, transactionGroupId) || other.transactionGroupId == transactionGroupId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.inventoryBalanceId, inventoryBalanceId) || other.inventoryBalanceId == inventoryBalanceId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitSnapshot, unitSnapshot) || other.unitSnapshot == unitSnapshot)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.inventoryBalance, inventoryBalance) || other.inventoryBalance == inventoryBalance)&&(identical(other.season, season) || other.season == season)&&(identical(other.performer, performer) || other.performer == performer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionGroupId,productId,inventoryBalanceId,seasonId,transactionType,quantity,unitSnapshot,totalAmount,referenceType,referenceId,reason,performedBy,createdAt,product,inventoryBalance,season,performer);

@override
String toString() {
  return 'InventoryTransaction(id: $id, transactionGroupId: $transactionGroupId, productId: $productId, inventoryBalanceId: $inventoryBalanceId, seasonId: $seasonId, transactionType: $transactionType, quantity: $quantity, unitSnapshot: $unitSnapshot, totalAmount: $totalAmount, referenceType: $referenceType, referenceId: $referenceId, reason: $reason, performedBy: $performedBy, createdAt: $createdAt, product: $product, inventoryBalance: $inventoryBalance, season: $season, performer: $performer)';
}


}

/// @nodoc
abstract mixin class $InventoryTransactionCopyWith<$Res>  {
  factory $InventoryTransactionCopyWith(InventoryTransaction value, $Res Function(InventoryTransaction) _then) = _$InventoryTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String transactionGroupId, String productId, String inventoryBalanceId, String? seasonId,@JsonKey(unknownEnumValue: InventoryTransactionType.unknown) InventoryTransactionType transactionType, double quantity,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unitSnapshot, double totalAmount, String? referenceType, String? referenceId, String? reason, String performedBy, DateTime createdAt, InventoryTransactionProduct product, InventoryLot inventoryBalance, InventoryTransactionSeason? season, InventoryTransactionPerformer performer
});


$InventoryTransactionProductCopyWith<$Res> get product;$InventoryLotCopyWith<$Res> get inventoryBalance;$InventoryTransactionSeasonCopyWith<$Res>? get season;$InventoryTransactionPerformerCopyWith<$Res> get performer;

}
/// @nodoc
class _$InventoryTransactionCopyWithImpl<$Res>
    implements $InventoryTransactionCopyWith<$Res> {
  _$InventoryTransactionCopyWithImpl(this._self, this._then);

  final InventoryTransaction _self;
  final $Res Function(InventoryTransaction) _then;

/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionGroupId = null,Object? productId = null,Object? inventoryBalanceId = null,Object? seasonId = freezed,Object? transactionType = null,Object? quantity = null,Object? unitSnapshot = null,Object? totalAmount = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? reason = freezed,Object? performedBy = null,Object? createdAt = null,Object? product = null,Object? inventoryBalance = null,Object? season = freezed,Object? performer = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionGroupId: null == transactionGroupId ? _self.transactionGroupId : transactionGroupId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,inventoryBalanceId: null == inventoryBalanceId ? _self.inventoryBalanceId : inventoryBalanceId // ignore: cast_nullable_to_non_nullable
as String,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as InventoryTransactionType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitSnapshot: null == unitSnapshot ? _self.unitSnapshot : unitSnapshot // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryTransactionProduct,inventoryBalance: null == inventoryBalance ? _self.inventoryBalance : inventoryBalance // ignore: cast_nullable_to_non_nullable
as InventoryLot,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as InventoryTransactionSeason?,performer: null == performer ? _self.performer : performer // ignore: cast_nullable_to_non_nullable
as InventoryTransactionPerformer,
  ));
}
/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionProductCopyWith<$Res> get product {
  
  return $InventoryTransactionProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryLotCopyWith<$Res> get inventoryBalance {
  
  return $InventoryLotCopyWith<$Res>(_self.inventoryBalance, (value) {
    return _then(_self.copyWith(inventoryBalance: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionSeasonCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $InventoryTransactionSeasonCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionPerformerCopyWith<$Res> get performer {
  
  return $InventoryTransactionPerformerCopyWith<$Res>(_self.performer, (value) {
    return _then(_self.copyWith(performer: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryTransaction].
extension InventoryTransactionPatterns on InventoryTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryTransaction value)  $default,){
final _that = this;
switch (_that) {
case _InventoryTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transactionGroupId,  String productId,  String inventoryBalanceId,  String? seasonId, @JsonKey(unknownEnumValue: InventoryTransactionType.unknown)  InventoryTransactionType transactionType,  double quantity, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unitSnapshot,  double totalAmount,  String? referenceType,  String? referenceId,  String? reason,  String performedBy,  DateTime createdAt,  InventoryTransactionProduct product,  InventoryLot inventoryBalance,  InventoryTransactionSeason? season,  InventoryTransactionPerformer performer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryTransaction() when $default != null:
return $default(_that.id,_that.transactionGroupId,_that.productId,_that.inventoryBalanceId,_that.seasonId,_that.transactionType,_that.quantity,_that.unitSnapshot,_that.totalAmount,_that.referenceType,_that.referenceId,_that.reason,_that.performedBy,_that.createdAt,_that.product,_that.inventoryBalance,_that.season,_that.performer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transactionGroupId,  String productId,  String inventoryBalanceId,  String? seasonId, @JsonKey(unknownEnumValue: InventoryTransactionType.unknown)  InventoryTransactionType transactionType,  double quantity, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unitSnapshot,  double totalAmount,  String? referenceType,  String? referenceId,  String? reason,  String performedBy,  DateTime createdAt,  InventoryTransactionProduct product,  InventoryLot inventoryBalance,  InventoryTransactionSeason? season,  InventoryTransactionPerformer performer)  $default,) {final _that = this;
switch (_that) {
case _InventoryTransaction():
return $default(_that.id,_that.transactionGroupId,_that.productId,_that.inventoryBalanceId,_that.seasonId,_that.transactionType,_that.quantity,_that.unitSnapshot,_that.totalAmount,_that.referenceType,_that.referenceId,_that.reason,_that.performedBy,_that.createdAt,_that.product,_that.inventoryBalance,_that.season,_that.performer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transactionGroupId,  String productId,  String inventoryBalanceId,  String? seasonId, @JsonKey(unknownEnumValue: InventoryTransactionType.unknown)  InventoryTransactionType transactionType,  double quantity, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown)  InventoryProductUnit unitSnapshot,  double totalAmount,  String? referenceType,  String? referenceId,  String? reason,  String performedBy,  DateTime createdAt,  InventoryTransactionProduct product,  InventoryLot inventoryBalance,  InventoryTransactionSeason? season,  InventoryTransactionPerformer performer)?  $default,) {final _that = this;
switch (_that) {
case _InventoryTransaction() when $default != null:
return $default(_that.id,_that.transactionGroupId,_that.productId,_that.inventoryBalanceId,_that.seasonId,_that.transactionType,_that.quantity,_that.unitSnapshot,_that.totalAmount,_that.referenceType,_that.referenceId,_that.reason,_that.performedBy,_that.createdAt,_that.product,_that.inventoryBalance,_that.season,_that.performer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryTransaction implements InventoryTransaction {
  const _InventoryTransaction({required this.id, required this.transactionGroupId, required this.productId, required this.inventoryBalanceId, this.seasonId, @JsonKey(unknownEnumValue: InventoryTransactionType.unknown) required this.transactionType, required this.quantity, @JsonKey(unknownEnumValue: InventoryProductUnit.unknown) required this.unitSnapshot, required this.totalAmount, this.referenceType, this.referenceId, this.reason, required this.performedBy, required this.createdAt, required this.product, required this.inventoryBalance, this.season, required this.performer});
  factory _InventoryTransaction.fromJson(Map<String, dynamic> json) => _$InventoryTransactionFromJson(json);

@override final  String id;
@override final  String transactionGroupId;
@override final  String productId;
@override final  String inventoryBalanceId;
@override final  String? seasonId;
@override@JsonKey(unknownEnumValue: InventoryTransactionType.unknown) final  InventoryTransactionType transactionType;
@override final  double quantity;
@override@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) final  InventoryProductUnit unitSnapshot;
@override final  double totalAmount;
@override final  String? referenceType;
@override final  String? referenceId;
@override final  String? reason;
@override final  String performedBy;
@override final  DateTime createdAt;
@override final  InventoryTransactionProduct product;
@override final  InventoryLot inventoryBalance;
@override final  InventoryTransactionSeason? season;
@override final  InventoryTransactionPerformer performer;

/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryTransactionCopyWith<_InventoryTransaction> get copyWith => __$InventoryTransactionCopyWithImpl<_InventoryTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionGroupId, transactionGroupId) || other.transactionGroupId == transactionGroupId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.inventoryBalanceId, inventoryBalanceId) || other.inventoryBalanceId == inventoryBalanceId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitSnapshot, unitSnapshot) || other.unitSnapshot == unitSnapshot)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.inventoryBalance, inventoryBalance) || other.inventoryBalance == inventoryBalance)&&(identical(other.season, season) || other.season == season)&&(identical(other.performer, performer) || other.performer == performer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionGroupId,productId,inventoryBalanceId,seasonId,transactionType,quantity,unitSnapshot,totalAmount,referenceType,referenceId,reason,performedBy,createdAt,product,inventoryBalance,season,performer);

@override
String toString() {
  return 'InventoryTransaction(id: $id, transactionGroupId: $transactionGroupId, productId: $productId, inventoryBalanceId: $inventoryBalanceId, seasonId: $seasonId, transactionType: $transactionType, quantity: $quantity, unitSnapshot: $unitSnapshot, totalAmount: $totalAmount, referenceType: $referenceType, referenceId: $referenceId, reason: $reason, performedBy: $performedBy, createdAt: $createdAt, product: $product, inventoryBalance: $inventoryBalance, season: $season, performer: $performer)';
}


}

/// @nodoc
abstract mixin class _$InventoryTransactionCopyWith<$Res> implements $InventoryTransactionCopyWith<$Res> {
  factory _$InventoryTransactionCopyWith(_InventoryTransaction value, $Res Function(_InventoryTransaction) _then) = __$InventoryTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionGroupId, String productId, String inventoryBalanceId, String? seasonId,@JsonKey(unknownEnumValue: InventoryTransactionType.unknown) InventoryTransactionType transactionType, double quantity,@JsonKey(unknownEnumValue: InventoryProductUnit.unknown) InventoryProductUnit unitSnapshot, double totalAmount, String? referenceType, String? referenceId, String? reason, String performedBy, DateTime createdAt, InventoryTransactionProduct product, InventoryLot inventoryBalance, InventoryTransactionSeason? season, InventoryTransactionPerformer performer
});


@override $InventoryTransactionProductCopyWith<$Res> get product;@override $InventoryLotCopyWith<$Res> get inventoryBalance;@override $InventoryTransactionSeasonCopyWith<$Res>? get season;@override $InventoryTransactionPerformerCopyWith<$Res> get performer;

}
/// @nodoc
class __$InventoryTransactionCopyWithImpl<$Res>
    implements _$InventoryTransactionCopyWith<$Res> {
  __$InventoryTransactionCopyWithImpl(this._self, this._then);

  final _InventoryTransaction _self;
  final $Res Function(_InventoryTransaction) _then;

/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionGroupId = null,Object? productId = null,Object? inventoryBalanceId = null,Object? seasonId = freezed,Object? transactionType = null,Object? quantity = null,Object? unitSnapshot = null,Object? totalAmount = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? reason = freezed,Object? performedBy = null,Object? createdAt = null,Object? product = null,Object? inventoryBalance = null,Object? season = freezed,Object? performer = null,}) {
  return _then(_InventoryTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionGroupId: null == transactionGroupId ? _self.transactionGroupId : transactionGroupId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,inventoryBalanceId: null == inventoryBalanceId ? _self.inventoryBalanceId : inventoryBalanceId // ignore: cast_nullable_to_non_nullable
as String,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as InventoryTransactionType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitSnapshot: null == unitSnapshot ? _self.unitSnapshot : unitSnapshot // ignore: cast_nullable_to_non_nullable
as InventoryProductUnit,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryTransactionProduct,inventoryBalance: null == inventoryBalance ? _self.inventoryBalance : inventoryBalance // ignore: cast_nullable_to_non_nullable
as InventoryLot,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as InventoryTransactionSeason?,performer: null == performer ? _self.performer : performer // ignore: cast_nullable_to_non_nullable
as InventoryTransactionPerformer,
  ));
}

/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionProductCopyWith<$Res> get product {
  
  return $InventoryTransactionProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryLotCopyWith<$Res> get inventoryBalance {
  
  return $InventoryLotCopyWith<$Res>(_self.inventoryBalance, (value) {
    return _then(_self.copyWith(inventoryBalance: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionSeasonCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $InventoryTransactionSeasonCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of InventoryTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryTransactionPerformerCopyWith<$Res> get performer {
  
  return $InventoryTransactionPerformerCopyWith<$Res>(_self.performer, (value) {
    return _then(_self.copyWith(performer: value));
  });
}
}


/// @nodoc
mixin _$InventoryHistorySummary {

 double get totalInboundValue; double get totalOutboundValue;
/// Create a copy of InventoryHistorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryHistorySummaryCopyWith<InventoryHistorySummary> get copyWith => _$InventoryHistorySummaryCopyWithImpl<InventoryHistorySummary>(this as InventoryHistorySummary, _$identity);

  /// Serializes this InventoryHistorySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryHistorySummary&&(identical(other.totalInboundValue, totalInboundValue) || other.totalInboundValue == totalInboundValue)&&(identical(other.totalOutboundValue, totalOutboundValue) || other.totalOutboundValue == totalOutboundValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalInboundValue,totalOutboundValue);

@override
String toString() {
  return 'InventoryHistorySummary(totalInboundValue: $totalInboundValue, totalOutboundValue: $totalOutboundValue)';
}


}

/// @nodoc
abstract mixin class $InventoryHistorySummaryCopyWith<$Res>  {
  factory $InventoryHistorySummaryCopyWith(InventoryHistorySummary value, $Res Function(InventoryHistorySummary) _then) = _$InventoryHistorySummaryCopyWithImpl;
@useResult
$Res call({
 double totalInboundValue, double totalOutboundValue
});




}
/// @nodoc
class _$InventoryHistorySummaryCopyWithImpl<$Res>
    implements $InventoryHistorySummaryCopyWith<$Res> {
  _$InventoryHistorySummaryCopyWithImpl(this._self, this._then);

  final InventoryHistorySummary _self;
  final $Res Function(InventoryHistorySummary) _then;

/// Create a copy of InventoryHistorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalInboundValue = null,Object? totalOutboundValue = null,}) {
  return _then(_self.copyWith(
totalInboundValue: null == totalInboundValue ? _self.totalInboundValue : totalInboundValue // ignore: cast_nullable_to_non_nullable
as double,totalOutboundValue: null == totalOutboundValue ? _self.totalOutboundValue : totalOutboundValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryHistorySummary].
extension InventoryHistorySummaryPatterns on InventoryHistorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryHistorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryHistorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryHistorySummary value)  $default,){
final _that = this;
switch (_that) {
case _InventoryHistorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryHistorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryHistorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalInboundValue,  double totalOutboundValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryHistorySummary() when $default != null:
return $default(_that.totalInboundValue,_that.totalOutboundValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalInboundValue,  double totalOutboundValue)  $default,) {final _that = this;
switch (_that) {
case _InventoryHistorySummary():
return $default(_that.totalInboundValue,_that.totalOutboundValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalInboundValue,  double totalOutboundValue)?  $default,) {final _that = this;
switch (_that) {
case _InventoryHistorySummary() when $default != null:
return $default(_that.totalInboundValue,_that.totalOutboundValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryHistorySummary implements InventoryHistorySummary {
  const _InventoryHistorySummary({required this.totalInboundValue, required this.totalOutboundValue});
  factory _InventoryHistorySummary.fromJson(Map<String, dynamic> json) => _$InventoryHistorySummaryFromJson(json);

@override final  double totalInboundValue;
@override final  double totalOutboundValue;

/// Create a copy of InventoryHistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryHistorySummaryCopyWith<_InventoryHistorySummary> get copyWith => __$InventoryHistorySummaryCopyWithImpl<_InventoryHistorySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryHistorySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryHistorySummary&&(identical(other.totalInboundValue, totalInboundValue) || other.totalInboundValue == totalInboundValue)&&(identical(other.totalOutboundValue, totalOutboundValue) || other.totalOutboundValue == totalOutboundValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalInboundValue,totalOutboundValue);

@override
String toString() {
  return 'InventoryHistorySummary(totalInboundValue: $totalInboundValue, totalOutboundValue: $totalOutboundValue)';
}


}

/// @nodoc
abstract mixin class _$InventoryHistorySummaryCopyWith<$Res> implements $InventoryHistorySummaryCopyWith<$Res> {
  factory _$InventoryHistorySummaryCopyWith(_InventoryHistorySummary value, $Res Function(_InventoryHistorySummary) _then) = __$InventoryHistorySummaryCopyWithImpl;
@override @useResult
$Res call({
 double totalInboundValue, double totalOutboundValue
});




}
/// @nodoc
class __$InventoryHistorySummaryCopyWithImpl<$Res>
    implements _$InventoryHistorySummaryCopyWith<$Res> {
  __$InventoryHistorySummaryCopyWithImpl(this._self, this._then);

  final _InventoryHistorySummary _self;
  final $Res Function(_InventoryHistorySummary) _then;

/// Create a copy of InventoryHistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalInboundValue = null,Object? totalOutboundValue = null,}) {
  return _then(_InventoryHistorySummary(
totalInboundValue: null == totalInboundValue ? _self.totalInboundValue : totalInboundValue // ignore: cast_nullable_to_non_nullable
as double,totalOutboundValue: null == totalOutboundValue ? _self.totalOutboundValue : totalOutboundValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InventoryHistoryPage {

 List<InventoryTransaction> get items; int get limit; int get totalResults; bool get hasNextPage; String? get nextCursor; InventoryHistorySummary get summary; List<InventoryTransactionProduct> get filterProducts; List<InventoryTransactionSeason> get filterSeasons;
/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryHistoryPageCopyWith<InventoryHistoryPage> get copyWith => _$InventoryHistoryPageCopyWithImpl<InventoryHistoryPage>(this as InventoryHistoryPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryHistoryPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.filterProducts, filterProducts)&&const DeepCollectionEquality().equals(other.filterSeasons, filterSeasons));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),limit,totalResults,hasNextPage,nextCursor,summary,const DeepCollectionEquality().hash(filterProducts),const DeepCollectionEquality().hash(filterSeasons));

@override
String toString() {
  return 'InventoryHistoryPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, summary: $summary, filterProducts: $filterProducts, filterSeasons: $filterSeasons)';
}


}

/// @nodoc
abstract mixin class $InventoryHistoryPageCopyWith<$Res>  {
  factory $InventoryHistoryPageCopyWith(InventoryHistoryPage value, $Res Function(InventoryHistoryPage) _then) = _$InventoryHistoryPageCopyWithImpl;
@useResult
$Res call({
 List<InventoryTransaction> items, int limit, int totalResults, bool hasNextPage, String? nextCursor, InventoryHistorySummary summary, List<InventoryTransactionProduct> filterProducts, List<InventoryTransactionSeason> filterSeasons
});


$InventoryHistorySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$InventoryHistoryPageCopyWithImpl<$Res>
    implements $InventoryHistoryPageCopyWith<$Res> {
  _$InventoryHistoryPageCopyWithImpl(this._self, this._then);

  final InventoryHistoryPage _self;
  final $Res Function(InventoryHistoryPage) _then;

/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? summary = null,Object? filterProducts = null,Object? filterSeasons = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryTransaction>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as InventoryHistorySummary,filterProducts: null == filterProducts ? _self.filterProducts : filterProducts // ignore: cast_nullable_to_non_nullable
as List<InventoryTransactionProduct>,filterSeasons: null == filterSeasons ? _self.filterSeasons : filterSeasons // ignore: cast_nullable_to_non_nullable
as List<InventoryTransactionSeason>,
  ));
}
/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryHistorySummaryCopyWith<$Res> get summary {
  
  return $InventoryHistorySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryHistoryPage].
extension InventoryHistoryPagePatterns on InventoryHistoryPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryHistoryPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryHistoryPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryHistoryPage value)  $default,){
final _that = this;
switch (_that) {
case _InventoryHistoryPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryHistoryPage value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryHistoryPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InventoryTransaction> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  InventoryHistorySummary summary,  List<InventoryTransactionProduct> filterProducts,  List<InventoryTransactionSeason> filterSeasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryHistoryPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.summary,_that.filterProducts,_that.filterSeasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InventoryTransaction> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  InventoryHistorySummary summary,  List<InventoryTransactionProduct> filterProducts,  List<InventoryTransactionSeason> filterSeasons)  $default,) {final _that = this;
switch (_that) {
case _InventoryHistoryPage():
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.summary,_that.filterProducts,_that.filterSeasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InventoryTransaction> items,  int limit,  int totalResults,  bool hasNextPage,  String? nextCursor,  InventoryHistorySummary summary,  List<InventoryTransactionProduct> filterProducts,  List<InventoryTransactionSeason> filterSeasons)?  $default,) {final _that = this;
switch (_that) {
case _InventoryHistoryPage() when $default != null:
return $default(_that.items,_that.limit,_that.totalResults,_that.hasNextPage,_that.nextCursor,_that.summary,_that.filterProducts,_that.filterSeasons);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryHistoryPage implements InventoryHistoryPage {
  const _InventoryHistoryPage({required final  List<InventoryTransaction> items, required this.limit, required this.totalResults, required this.hasNextPage, this.nextCursor, required this.summary, final  List<InventoryTransactionProduct> filterProducts = const <InventoryTransactionProduct>[], final  List<InventoryTransactionSeason> filterSeasons = const <InventoryTransactionSeason>[]}): _items = items,_filterProducts = filterProducts,_filterSeasons = filterSeasons;
  

 final  List<InventoryTransaction> _items;
@override List<InventoryTransaction> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int limit;
@override final  int totalResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;
@override final  InventoryHistorySummary summary;
 final  List<InventoryTransactionProduct> _filterProducts;
@override@JsonKey() List<InventoryTransactionProduct> get filterProducts {
  if (_filterProducts is EqualUnmodifiableListView) return _filterProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterProducts);
}

 final  List<InventoryTransactionSeason> _filterSeasons;
@override@JsonKey() List<InventoryTransactionSeason> get filterSeasons {
  if (_filterSeasons is EqualUnmodifiableListView) return _filterSeasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterSeasons);
}


/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryHistoryPageCopyWith<_InventoryHistoryPage> get copyWith => __$InventoryHistoryPageCopyWithImpl<_InventoryHistoryPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryHistoryPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._filterProducts, _filterProducts)&&const DeepCollectionEquality().equals(other._filterSeasons, _filterSeasons));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),limit,totalResults,hasNextPage,nextCursor,summary,const DeepCollectionEquality().hash(_filterProducts),const DeepCollectionEquality().hash(_filterSeasons));

@override
String toString() {
  return 'InventoryHistoryPage(items: $items, limit: $limit, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, summary: $summary, filterProducts: $filterProducts, filterSeasons: $filterSeasons)';
}


}

/// @nodoc
abstract mixin class _$InventoryHistoryPageCopyWith<$Res> implements $InventoryHistoryPageCopyWith<$Res> {
  factory _$InventoryHistoryPageCopyWith(_InventoryHistoryPage value, $Res Function(_InventoryHistoryPage) _then) = __$InventoryHistoryPageCopyWithImpl;
@override @useResult
$Res call({
 List<InventoryTransaction> items, int limit, int totalResults, bool hasNextPage, String? nextCursor, InventoryHistorySummary summary, List<InventoryTransactionProduct> filterProducts, List<InventoryTransactionSeason> filterSeasons
});


@override $InventoryHistorySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$InventoryHistoryPageCopyWithImpl<$Res>
    implements _$InventoryHistoryPageCopyWith<$Res> {
  __$InventoryHistoryPageCopyWithImpl(this._self, this._then);

  final _InventoryHistoryPage _self;
  final $Res Function(_InventoryHistoryPage) _then;

/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? limit = null,Object? totalResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? summary = null,Object? filterProducts = null,Object? filterSeasons = null,}) {
  return _then(_InventoryHistoryPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InventoryTransaction>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as InventoryHistorySummary,filterProducts: null == filterProducts ? _self._filterProducts : filterProducts // ignore: cast_nullable_to_non_nullable
as List<InventoryTransactionProduct>,filterSeasons: null == filterSeasons ? _self._filterSeasons : filterSeasons // ignore: cast_nullable_to_non_nullable
as List<InventoryTransactionSeason>,
  ));
}

/// Create a copy of InventoryHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryHistorySummaryCopyWith<$Res> get summary {
  
  return $InventoryHistorySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$InventoryStockResult {

 String get transactionId; InventoryLot get balance; double get currentStock; bool get idempotentReplay;
/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStockResultCopyWith<InventoryStockResult> get copyWith => _$InventoryStockResultCopyWithImpl<InventoryStockResult>(this as InventoryStockResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStockResult&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,balance,currentStock,idempotentReplay);

@override
String toString() {
  return 'InventoryStockResult(transactionId: $transactionId, balance: $balance, currentStock: $currentStock, idempotentReplay: $idempotentReplay)';
}


}

/// @nodoc
abstract mixin class $InventoryStockResultCopyWith<$Res>  {
  factory $InventoryStockResultCopyWith(InventoryStockResult value, $Res Function(InventoryStockResult) _then) = _$InventoryStockResultCopyWithImpl;
@useResult
$Res call({
 String transactionId, InventoryLot balance, double currentStock, bool idempotentReplay
});


$InventoryLotCopyWith<$Res> get balance;

}
/// @nodoc
class _$InventoryStockResultCopyWithImpl<$Res>
    implements $InventoryStockResultCopyWith<$Res> {
  _$InventoryStockResultCopyWithImpl(this._self, this._then);

  final InventoryStockResult _self;
  final $Res Function(InventoryStockResult) _then;

/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? balance = null,Object? currentStock = null,Object? idempotentReplay = null,}) {
  return _then(_self.copyWith(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as InventoryLot,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryLotCopyWith<$Res> get balance {
  
  return $InventoryLotCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryStockResult].
extension InventoryStockResultPatterns on InventoryStockResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryStockResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryStockResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryStockResult value)  $default,){
final _that = this;
switch (_that) {
case _InventoryStockResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryStockResult value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryStockResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transactionId,  InventoryLot balance,  double currentStock,  bool idempotentReplay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryStockResult() when $default != null:
return $default(_that.transactionId,_that.balance,_that.currentStock,_that.idempotentReplay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transactionId,  InventoryLot balance,  double currentStock,  bool idempotentReplay)  $default,) {final _that = this;
switch (_that) {
case _InventoryStockResult():
return $default(_that.transactionId,_that.balance,_that.currentStock,_that.idempotentReplay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transactionId,  InventoryLot balance,  double currentStock,  bool idempotentReplay)?  $default,) {final _that = this;
switch (_that) {
case _InventoryStockResult() when $default != null:
return $default(_that.transactionId,_that.balance,_that.currentStock,_that.idempotentReplay);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryStockResult implements InventoryStockResult {
  const _InventoryStockResult({required this.transactionId, required this.balance, required this.currentStock, required this.idempotentReplay});
  

@override final  String transactionId;
@override final  InventoryLot balance;
@override final  double currentStock;
@override final  bool idempotentReplay;

/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStockResultCopyWith<_InventoryStockResult> get copyWith => __$InventoryStockResultCopyWithImpl<_InventoryStockResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryStockResult&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currentStock, currentStock) || other.currentStock == currentStock)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,balance,currentStock,idempotentReplay);

@override
String toString() {
  return 'InventoryStockResult(transactionId: $transactionId, balance: $balance, currentStock: $currentStock, idempotentReplay: $idempotentReplay)';
}


}

/// @nodoc
abstract mixin class _$InventoryStockResultCopyWith<$Res> implements $InventoryStockResultCopyWith<$Res> {
  factory _$InventoryStockResultCopyWith(_InventoryStockResult value, $Res Function(_InventoryStockResult) _then) = __$InventoryStockResultCopyWithImpl;
@override @useResult
$Res call({
 String transactionId, InventoryLot balance, double currentStock, bool idempotentReplay
});


@override $InventoryLotCopyWith<$Res> get balance;

}
/// @nodoc
class __$InventoryStockResultCopyWithImpl<$Res>
    implements _$InventoryStockResultCopyWith<$Res> {
  __$InventoryStockResultCopyWithImpl(this._self, this._then);

  final _InventoryStockResult _self;
  final $Res Function(_InventoryStockResult) _then;

/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? balance = null,Object? currentStock = null,Object? idempotentReplay = null,}) {
  return _then(_InventoryStockResult(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as InventoryLot,currentStock: null == currentStock ? _self.currentStock : currentStock // ignore: cast_nullable_to_non_nullable
as double,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of InventoryStockResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryLotCopyWith<$Res> get balance {
  
  return $InventoryLotCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}

// dart format on
