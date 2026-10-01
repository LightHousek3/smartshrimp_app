// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assigned_season.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssignedSeason {

 String get id; String get name; AssignedSeasonStatus get status; String get shrimpType; String get pondId; String get pondName; String get farmId; String get farmName; DateTime get assignedAt; DateTime? get stockingDate; DateTime? get expectedEndDate; double? get initialBiomassKg;
/// Create a copy of AssignedSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignedSeasonCopyWith<AssignedSeason> get copyWith => _$AssignedSeasonCopyWithImpl<AssignedSeason>(this as AssignedSeason, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignedSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.initialBiomassKg, initialBiomassKg) || other.initialBiomassKg == initialBiomassKg));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,shrimpType,pondId,pondName,farmId,farmName,assignedAt,stockingDate,expectedEndDate,initialBiomassKg);

@override
String toString() {
  return 'AssignedSeason(id: $id, name: $name, status: $status, shrimpType: $shrimpType, pondId: $pondId, pondName: $pondName, farmId: $farmId, farmName: $farmName, assignedAt: $assignedAt, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, initialBiomassKg: $initialBiomassKg)';
}


}

/// @nodoc
abstract mixin class $AssignedSeasonCopyWith<$Res>  {
  factory $AssignedSeasonCopyWith(AssignedSeason value, $Res Function(AssignedSeason) _then) = _$AssignedSeasonCopyWithImpl;
@useResult
$Res call({
 String id, String name, AssignedSeasonStatus status, String shrimpType, String pondId, String pondName, String farmId, String farmName, DateTime assignedAt, DateTime? stockingDate, DateTime? expectedEndDate, double? initialBiomassKg
});




}
/// @nodoc
class _$AssignedSeasonCopyWithImpl<$Res>
    implements $AssignedSeasonCopyWith<$Res> {
  _$AssignedSeasonCopyWithImpl(this._self, this._then);

  final AssignedSeason _self;
  final $Res Function(AssignedSeason) _then;

/// Create a copy of AssignedSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? shrimpType = null,Object? pondId = null,Object? pondName = null,Object? farmId = null,Object? farmName = null,Object? assignedAt = null,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? initialBiomassKg = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssignedSeasonStatus,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialBiomassKg: freezed == initialBiomassKg ? _self.initialBiomassKg : initialBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignedSeason].
extension AssignedSeasonPatterns on AssignedSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignedSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignedSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignedSeason value)  $default,){
final _that = this;
switch (_that) {
case _AssignedSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignedSeason value)?  $default,){
final _that = this;
switch (_that) {
case _AssignedSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String farmId,  String farmName,  DateTime assignedAt,  DateTime? stockingDate,  DateTime? expectedEndDate,  double? initialBiomassKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignedSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.assignedAt,_that.stockingDate,_that.expectedEndDate,_that.initialBiomassKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String farmId,  String farmName,  DateTime assignedAt,  DateTime? stockingDate,  DateTime? expectedEndDate,  double? initialBiomassKg)  $default,) {final _that = this;
switch (_that) {
case _AssignedSeason():
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.assignedAt,_that.stockingDate,_that.expectedEndDate,_that.initialBiomassKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AssignedSeasonStatus status,  String shrimpType,  String pondId,  String pondName,  String farmId,  String farmName,  DateTime assignedAt,  DateTime? stockingDate,  DateTime? expectedEndDate,  double? initialBiomassKg)?  $default,) {final _that = this;
switch (_that) {
case _AssignedSeason() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.shrimpType,_that.pondId,_that.pondName,_that.farmId,_that.farmName,_that.assignedAt,_that.stockingDate,_that.expectedEndDate,_that.initialBiomassKg);case _:
  return null;

}
}

}

/// @nodoc


class _AssignedSeason extends AssignedSeason {
  const _AssignedSeason({required this.id, required this.name, required this.status, required this.shrimpType, required this.pondId, required this.pondName, required this.farmId, required this.farmName, required this.assignedAt, this.stockingDate, this.expectedEndDate, this.initialBiomassKg}): super._();
  

@override final  String id;
@override final  String name;
@override final  AssignedSeasonStatus status;
@override final  String shrimpType;
@override final  String pondId;
@override final  String pondName;
@override final  String farmId;
@override final  String farmName;
@override final  DateTime assignedAt;
@override final  DateTime? stockingDate;
@override final  DateTime? expectedEndDate;
@override final  double? initialBiomassKg;

/// Create a copy of AssignedSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignedSeasonCopyWith<_AssignedSeason> get copyWith => __$AssignedSeasonCopyWithImpl<_AssignedSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignedSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.shrimpType, shrimpType) || other.shrimpType == shrimpType)&&(identical(other.pondId, pondId) || other.pondId == pondId)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.stockingDate, stockingDate) || other.stockingDate == stockingDate)&&(identical(other.expectedEndDate, expectedEndDate) || other.expectedEndDate == expectedEndDate)&&(identical(other.initialBiomassKg, initialBiomassKg) || other.initialBiomassKg == initialBiomassKg));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,shrimpType,pondId,pondName,farmId,farmName,assignedAt,stockingDate,expectedEndDate,initialBiomassKg);

@override
String toString() {
  return 'AssignedSeason(id: $id, name: $name, status: $status, shrimpType: $shrimpType, pondId: $pondId, pondName: $pondName, farmId: $farmId, farmName: $farmName, assignedAt: $assignedAt, stockingDate: $stockingDate, expectedEndDate: $expectedEndDate, initialBiomassKg: $initialBiomassKg)';
}


}

/// @nodoc
abstract mixin class _$AssignedSeasonCopyWith<$Res> implements $AssignedSeasonCopyWith<$Res> {
  factory _$AssignedSeasonCopyWith(_AssignedSeason value, $Res Function(_AssignedSeason) _then) = __$AssignedSeasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AssignedSeasonStatus status, String shrimpType, String pondId, String pondName, String farmId, String farmName, DateTime assignedAt, DateTime? stockingDate, DateTime? expectedEndDate, double? initialBiomassKg
});




}
/// @nodoc
class __$AssignedSeasonCopyWithImpl<$Res>
    implements _$AssignedSeasonCopyWith<$Res> {
  __$AssignedSeasonCopyWithImpl(this._self, this._then);

  final _AssignedSeason _self;
  final $Res Function(_AssignedSeason) _then;

/// Create a copy of AssignedSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? shrimpType = null,Object? pondId = null,Object? pondName = null,Object? farmId = null,Object? farmName = null,Object? assignedAt = null,Object? stockingDate = freezed,Object? expectedEndDate = freezed,Object? initialBiomassKg = freezed,}) {
  return _then(_AssignedSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AssignedSeasonStatus,shrimpType: null == shrimpType ? _self.shrimpType : shrimpType // ignore: cast_nullable_to_non_nullable
as String,pondId: null == pondId ? _self.pondId : pondId // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stockingDate: freezed == stockingDate ? _self.stockingDate : stockingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedEndDate: freezed == expectedEndDate ? _self.expectedEndDate : expectedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,initialBiomassKg: freezed == initialBiomassKg ? _self.initialBiomassKg : initialBiomassKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$AssignedSeasonPage {

 List<AssignedSeason> get items; int get totalResults; int get activeResults; int get allResults; bool get hasNextPage; String? get nextCursor;
/// Create a copy of AssignedSeasonPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignedSeasonPageCopyWith<AssignedSeasonPage> get copyWith => _$AssignedSeasonPageCopyWithImpl<AssignedSeasonPage>(this as AssignedSeasonPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignedSeasonPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.activeResults, activeResults) || other.activeResults == activeResults)&&(identical(other.allResults, allResults) || other.allResults == allResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),totalResults,activeResults,allResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'AssignedSeasonPage(items: $items, totalResults: $totalResults, activeResults: $activeResults, allResults: $allResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AssignedSeasonPageCopyWith<$Res>  {
  factory $AssignedSeasonPageCopyWith(AssignedSeasonPage value, $Res Function(AssignedSeasonPage) _then) = _$AssignedSeasonPageCopyWithImpl;
@useResult
$Res call({
 List<AssignedSeason> items, int totalResults, int activeResults, int allResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$AssignedSeasonPageCopyWithImpl<$Res>
    implements $AssignedSeasonPageCopyWith<$Res> {
  _$AssignedSeasonPageCopyWithImpl(this._self, this._then);

  final AssignedSeasonPage _self;
  final $Res Function(AssignedSeasonPage) _then;

/// Create a copy of AssignedSeasonPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? totalResults = null,Object? activeResults = null,Object? allResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AssignedSeason>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,activeResults: null == activeResults ? _self.activeResults : activeResults // ignore: cast_nullable_to_non_nullable
as int,allResults: null == allResults ? _self.allResults : allResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignedSeasonPage].
extension AssignedSeasonPagePatterns on AssignedSeasonPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignedSeasonPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignedSeasonPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignedSeasonPage value)  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignedSeasonPage value)?  $default,){
final _that = this;
switch (_that) {
case _AssignedSeasonPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AssignedSeason> items,  int totalResults,  int activeResults,  int allResults,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignedSeasonPage() when $default != null:
return $default(_that.items,_that.totalResults,_that.activeResults,_that.allResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AssignedSeason> items,  int totalResults,  int activeResults,  int allResults,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonPage():
return $default(_that.items,_that.totalResults,_that.activeResults,_that.allResults,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AssignedSeason> items,  int totalResults,  int activeResults,  int allResults,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AssignedSeasonPage() when $default != null:
return $default(_that.items,_that.totalResults,_that.activeResults,_that.allResults,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _AssignedSeasonPage extends AssignedSeasonPage {
  const _AssignedSeasonPage({required final  List<AssignedSeason> items, required this.totalResults, required this.activeResults, required this.allResults, required this.hasNextPage, this.nextCursor}): _items = items,super._();
  

 final  List<AssignedSeason> _items;
@override List<AssignedSeason> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int totalResults;
@override final  int activeResults;
@override final  int allResults;
@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of AssignedSeasonPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignedSeasonPageCopyWith<_AssignedSeasonPage> get copyWith => __$AssignedSeasonPageCopyWithImpl<_AssignedSeasonPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignedSeasonPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.activeResults, activeResults) || other.activeResults == activeResults)&&(identical(other.allResults, allResults) || other.allResults == allResults)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),totalResults,activeResults,allResults,hasNextPage,nextCursor);

@override
String toString() {
  return 'AssignedSeasonPage(items: $items, totalResults: $totalResults, activeResults: $activeResults, allResults: $allResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AssignedSeasonPageCopyWith<$Res> implements $AssignedSeasonPageCopyWith<$Res> {
  factory _$AssignedSeasonPageCopyWith(_AssignedSeasonPage value, $Res Function(_AssignedSeasonPage) _then) = __$AssignedSeasonPageCopyWithImpl;
@override @useResult
$Res call({
 List<AssignedSeason> items, int totalResults, int activeResults, int allResults, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$AssignedSeasonPageCopyWithImpl<$Res>
    implements _$AssignedSeasonPageCopyWith<$Res> {
  __$AssignedSeasonPageCopyWithImpl(this._self, this._then);

  final _AssignedSeasonPage _self;
  final $Res Function(_AssignedSeasonPage) _then;

/// Create a copy of AssignedSeasonPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? totalResults = null,Object? activeResults = null,Object? allResults = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_AssignedSeasonPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AssignedSeason>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,activeResults: null == activeResults ? _self.activeResults : activeResults // ignore: cast_nullable_to_non_nullable
as int,allResults: null == allResults ? _self.allResults : allResults // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
