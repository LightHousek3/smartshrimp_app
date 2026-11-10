// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_substance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventorySubstance {

 String get id; String get name; String get status; String get group; String get appendix; String get sourceRow; int get page; String get note; String? get mention;
/// Create a copy of InventorySubstance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySubstanceCopyWith<InventorySubstance> get copyWith => _$InventorySubstanceCopyWithImpl<InventorySubstance>(this as InventorySubstance, _$identity);

  /// Serializes this InventorySubstance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySubstance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.group, group) || other.group == group)&&(identical(other.appendix, appendix) || other.appendix == appendix)&&(identical(other.sourceRow, sourceRow) || other.sourceRow == sourceRow)&&(identical(other.page, page) || other.page == page)&&(identical(other.note, note) || other.note == note)&&(identical(other.mention, mention) || other.mention == mention));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,group,appendix,sourceRow,page,note,mention);

@override
String toString() {
  return 'InventorySubstance(id: $id, name: $name, status: $status, group: $group, appendix: $appendix, sourceRow: $sourceRow, page: $page, note: $note, mention: $mention)';
}


}

/// @nodoc
abstract mixin class $InventorySubstanceCopyWith<$Res>  {
  factory $InventorySubstanceCopyWith(InventorySubstance value, $Res Function(InventorySubstance) _then) = _$InventorySubstanceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, String group, String appendix, String sourceRow, int page, String note, String? mention
});




}
/// @nodoc
class _$InventorySubstanceCopyWithImpl<$Res>
    implements $InventorySubstanceCopyWith<$Res> {
  _$InventorySubstanceCopyWithImpl(this._self, this._then);

  final InventorySubstance _self;
  final $Res Function(InventorySubstance) _then;

/// Create a copy of InventorySubstance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? group = null,Object? appendix = null,Object? sourceRow = null,Object? page = null,Object? note = null,Object? mention = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,appendix: null == appendix ? _self.appendix : appendix // ignore: cast_nullable_to_non_nullable
as String,sourceRow: null == sourceRow ? _self.sourceRow : sourceRow // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySubstance].
extension InventorySubstancePatterns on InventorySubstance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySubstance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySubstance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySubstance value)  $default,){
final _that = this;
switch (_that) {
case _InventorySubstance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySubstance value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySubstance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  String group,  String appendix,  String sourceRow,  int page,  String note,  String? mention)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySubstance() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.group,_that.appendix,_that.sourceRow,_that.page,_that.note,_that.mention);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  String group,  String appendix,  String sourceRow,  int page,  String note,  String? mention)  $default,) {final _that = this;
switch (_that) {
case _InventorySubstance():
return $default(_that.id,_that.name,_that.status,_that.group,_that.appendix,_that.sourceRow,_that.page,_that.note,_that.mention);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  String group,  String appendix,  String sourceRow,  int page,  String note,  String? mention)?  $default,) {final _that = this;
switch (_that) {
case _InventorySubstance() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.group,_that.appendix,_that.sourceRow,_that.page,_that.note,_that.mention);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySubstance implements InventorySubstance {
  const _InventorySubstance({required this.id, required this.name, required this.status, required this.group, required this.appendix, required this.sourceRow, required this.page, required this.note, this.mention});
  factory _InventorySubstance.fromJson(Map<String, dynamic> json) => _$InventorySubstanceFromJson(json);

@override final  String id;
@override final  String name;
@override final  String status;
@override final  String group;
@override final  String appendix;
@override final  String sourceRow;
@override final  int page;
@override final  String note;
@override final  String? mention;

/// Create a copy of InventorySubstance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySubstanceCopyWith<_InventorySubstance> get copyWith => __$InventorySubstanceCopyWithImpl<_InventorySubstance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySubstanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySubstance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.group, group) || other.group == group)&&(identical(other.appendix, appendix) || other.appendix == appendix)&&(identical(other.sourceRow, sourceRow) || other.sourceRow == sourceRow)&&(identical(other.page, page) || other.page == page)&&(identical(other.note, note) || other.note == note)&&(identical(other.mention, mention) || other.mention == mention));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,group,appendix,sourceRow,page,note,mention);

@override
String toString() {
  return 'InventorySubstance(id: $id, name: $name, status: $status, group: $group, appendix: $appendix, sourceRow: $sourceRow, page: $page, note: $note, mention: $mention)';
}


}

/// @nodoc
abstract mixin class _$InventorySubstanceCopyWith<$Res> implements $InventorySubstanceCopyWith<$Res> {
  factory _$InventorySubstanceCopyWith(_InventorySubstance value, $Res Function(_InventorySubstance) _then) = __$InventorySubstanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, String group, String appendix, String sourceRow, int page, String note, String? mention
});




}
/// @nodoc
class __$InventorySubstanceCopyWithImpl<$Res>
    implements _$InventorySubstanceCopyWith<$Res> {
  __$InventorySubstanceCopyWithImpl(this._self, this._then);

  final _InventorySubstance _self;
  final $Res Function(_InventorySubstance) _then;

/// Create a copy of InventorySubstance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? group = null,Object? appendix = null,Object? sourceRow = null,Object? page = null,Object? note = null,Object? mention = freezed,}) {
  return _then(_InventorySubstance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,appendix: null == appendix ? _self.appendix : appendix // ignore: cast_nullable_to_non_nullable
as String,sourceRow: null == sourceRow ? _self.sourceRow : sourceRow // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventorySubstancePage {

 List<InventorySubstance> get items; bool get hasNextPage; String? get nextCursor;
/// Create a copy of InventorySubstancePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySubstancePageCopyWith<InventorySubstancePage> get copyWith => _$InventorySubstancePageCopyWithImpl<InventorySubstancePage>(this as InventorySubstancePage, _$identity);

  /// Serializes this InventorySubstancePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySubstancePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),hasNextPage,nextCursor);

@override
String toString() {
  return 'InventorySubstancePage(items: $items, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $InventorySubstancePageCopyWith<$Res>  {
  factory $InventorySubstancePageCopyWith(InventorySubstancePage value, $Res Function(InventorySubstancePage) _then) = _$InventorySubstancePageCopyWithImpl;
@useResult
$Res call({
 List<InventorySubstance> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$InventorySubstancePageCopyWithImpl<$Res>
    implements $InventorySubstancePageCopyWith<$Res> {
  _$InventorySubstancePageCopyWithImpl(this._self, this._then);

  final InventorySubstancePage _self;
  final $Res Function(InventorySubstancePage) _then;

/// Create a copy of InventorySubstancePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySubstancePage].
extension InventorySubstancePagePatterns on InventorySubstancePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySubstancePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySubstancePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySubstancePage value)  $default,){
final _that = this;
switch (_that) {
case _InventorySubstancePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySubstancePage value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySubstancePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InventorySubstance> items,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySubstancePage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InventorySubstance> items,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _InventorySubstancePage():
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InventorySubstance> items,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _InventorySubstancePage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySubstancePage implements InventorySubstancePage {
  const _InventorySubstancePage({required final  List<InventorySubstance> items, required this.hasNextPage, this.nextCursor}): _items = items;
  factory _InventorySubstancePage.fromJson(Map<String, dynamic> json) => _$InventorySubstancePageFromJson(json);

 final  List<InventorySubstance> _items;
@override List<InventorySubstance> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of InventorySubstancePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySubstancePageCopyWith<_InventorySubstancePage> get copyWith => __$InventorySubstancePageCopyWithImpl<_InventorySubstancePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySubstancePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySubstancePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNextPage,nextCursor);

@override
String toString() {
  return 'InventorySubstancePage(items: $items, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$InventorySubstancePageCopyWith<$Res> implements $InventorySubstancePageCopyWith<$Res> {
  factory _$InventorySubstancePageCopyWith(_InventorySubstancePage value, $Res Function(_InventorySubstancePage) _then) = __$InventorySubstancePageCopyWithImpl;
@override @useResult
$Res call({
 List<InventorySubstance> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$InventorySubstancePageCopyWithImpl<$Res>
    implements _$InventorySubstancePageCopyWith<$Res> {
  __$InventorySubstancePageCopyWithImpl(this._self, this._then);

  final _InventorySubstancePage _self;
  final $Res Function(_InventorySubstancePage) _then;

/// Create a copy of InventorySubstancePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_InventorySubstancePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventorySubstanceCheck {

 String get status; String get message; List<InventorySubstance> get matches;
/// Create a copy of InventorySubstanceCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySubstanceCheckCopyWith<InventorySubstanceCheck> get copyWith => _$InventorySubstanceCheckCopyWithImpl<InventorySubstanceCheck>(this as InventorySubstanceCheck, _$identity);

  /// Serializes this InventorySubstanceCheck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySubstanceCheck&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.matches, matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(matches));

@override
String toString() {
  return 'InventorySubstanceCheck(status: $status, message: $message, matches: $matches)';
}


}

/// @nodoc
abstract mixin class $InventorySubstanceCheckCopyWith<$Res>  {
  factory $InventorySubstanceCheckCopyWith(InventorySubstanceCheck value, $Res Function(InventorySubstanceCheck) _then) = _$InventorySubstanceCheckCopyWithImpl;
@useResult
$Res call({
 String status, String message, List<InventorySubstance> matches
});




}
/// @nodoc
class _$InventorySubstanceCheckCopyWithImpl<$Res>
    implements $InventorySubstanceCheckCopyWith<$Res> {
  _$InventorySubstanceCheckCopyWithImpl(this._self, this._then);

  final InventorySubstanceCheck _self;
  final $Res Function(InventorySubstanceCheck) _then;

/// Create a copy of InventorySubstanceCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? matches = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySubstanceCheck].
extension InventorySubstanceCheckPatterns on InventorySubstanceCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySubstanceCheck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySubstanceCheck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySubstanceCheck value)  $default,){
final _that = this;
switch (_that) {
case _InventorySubstanceCheck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySubstanceCheck value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySubstanceCheck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String message,  List<InventorySubstance> matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySubstanceCheck() when $default != null:
return $default(_that.status,_that.message,_that.matches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String message,  List<InventorySubstance> matches)  $default,) {final _that = this;
switch (_that) {
case _InventorySubstanceCheck():
return $default(_that.status,_that.message,_that.matches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String message,  List<InventorySubstance> matches)?  $default,) {final _that = this;
switch (_that) {
case _InventorySubstanceCheck() when $default != null:
return $default(_that.status,_that.message,_that.matches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySubstanceCheck extends InventorySubstanceCheck {
  const _InventorySubstanceCheck({required this.status, required this.message, final  List<InventorySubstance> matches = const <InventorySubstance>[]}): _matches = matches,super._();
  factory _InventorySubstanceCheck.fromJson(Map<String, dynamic> json) => _$InventorySubstanceCheckFromJson(json);

@override final  String status;
@override final  String message;
 final  List<InventorySubstance> _matches;
@override@JsonKey() List<InventorySubstance> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}


/// Create a copy of InventorySubstanceCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySubstanceCheckCopyWith<_InventorySubstanceCheck> get copyWith => __$InventorySubstanceCheckCopyWithImpl<_InventorySubstanceCheck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySubstanceCheckToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySubstanceCheck&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._matches, _matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_matches));

@override
String toString() {
  return 'InventorySubstanceCheck(status: $status, message: $message, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$InventorySubstanceCheckCopyWith<$Res> implements $InventorySubstanceCheckCopyWith<$Res> {
  factory _$InventorySubstanceCheckCopyWith(_InventorySubstanceCheck value, $Res Function(_InventorySubstanceCheck) _then) = __$InventorySubstanceCheckCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, List<InventorySubstance> matches
});




}
/// @nodoc
class __$InventorySubstanceCheckCopyWithImpl<$Res>
    implements _$InventorySubstanceCheckCopyWith<$Res> {
  __$InventorySubstanceCheckCopyWithImpl(this._self, this._then);

  final _InventorySubstanceCheck _self;
  final $Res Function(_InventorySubstanceCheck) _then;

/// Create a copy of InventorySubstanceCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? matches = null,}) {
  return _then(_InventorySubstanceCheck(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,
  ));
}


}

/// @nodoc
mixin _$InventorySubstanceState {

 List<InventorySubstance> get items; String get query; bool get isSearching; bool get isLoadingMore; bool get hasNextPage; String? get nextCursor; String? get searchError; bool get isChecking; InventorySubstanceCheck? get check; String? get checkError;
/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySubstanceStateCopyWith<InventorySubstanceState> get copyWith => _$InventorySubstanceStateCopyWithImpl<InventorySubstanceState>(this as InventorySubstanceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySubstanceState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.searchError, searchError) || other.searchError == searchError)&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.check, check) || other.check == check)&&(identical(other.checkError, checkError) || other.checkError == checkError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),query,isSearching,isLoadingMore,hasNextPage,nextCursor,searchError,isChecking,check,checkError);

@override
String toString() {
  return 'InventorySubstanceState(items: $items, query: $query, isSearching: $isSearching, isLoadingMore: $isLoadingMore, hasNextPage: $hasNextPage, nextCursor: $nextCursor, searchError: $searchError, isChecking: $isChecking, check: $check, checkError: $checkError)';
}


}

/// @nodoc
abstract mixin class $InventorySubstanceStateCopyWith<$Res>  {
  factory $InventorySubstanceStateCopyWith(InventorySubstanceState value, $Res Function(InventorySubstanceState) _then) = _$InventorySubstanceStateCopyWithImpl;
@useResult
$Res call({
 List<InventorySubstance> items, String query, bool isSearching, bool isLoadingMore, bool hasNextPage, String? nextCursor, String? searchError, bool isChecking, InventorySubstanceCheck? check, String? checkError
});


$InventorySubstanceCheckCopyWith<$Res>? get check;

}
/// @nodoc
class _$InventorySubstanceStateCopyWithImpl<$Res>
    implements $InventorySubstanceStateCopyWith<$Res> {
  _$InventorySubstanceStateCopyWithImpl(this._self, this._then);

  final InventorySubstanceState _self;
  final $Res Function(InventorySubstanceState) _then;

/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? query = null,Object? isSearching = null,Object? isLoadingMore = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? searchError = freezed,Object? isChecking = null,Object? check = freezed,Object? checkError = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,searchError: freezed == searchError ? _self.searchError : searchError // ignore: cast_nullable_to_non_nullable
as String?,isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,check: freezed == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as InventorySubstanceCheck?,checkError: freezed == checkError ? _self.checkError : checkError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySubstanceCheckCopyWith<$Res>? get check {
    if (_self.check == null) {
    return null;
  }

  return $InventorySubstanceCheckCopyWith<$Res>(_self.check!, (value) {
    return _then(_self.copyWith(check: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventorySubstanceState].
extension InventorySubstanceStatePatterns on InventorySubstanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySubstanceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySubstanceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySubstanceState value)  $default,){
final _that = this;
switch (_that) {
case _InventorySubstanceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySubstanceState value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySubstanceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InventorySubstance> items,  String query,  bool isSearching,  bool isLoadingMore,  bool hasNextPage,  String? nextCursor,  String? searchError,  bool isChecking,  InventorySubstanceCheck? check,  String? checkError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySubstanceState() when $default != null:
return $default(_that.items,_that.query,_that.isSearching,_that.isLoadingMore,_that.hasNextPage,_that.nextCursor,_that.searchError,_that.isChecking,_that.check,_that.checkError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InventorySubstance> items,  String query,  bool isSearching,  bool isLoadingMore,  bool hasNextPage,  String? nextCursor,  String? searchError,  bool isChecking,  InventorySubstanceCheck? check,  String? checkError)  $default,) {final _that = this;
switch (_that) {
case _InventorySubstanceState():
return $default(_that.items,_that.query,_that.isSearching,_that.isLoadingMore,_that.hasNextPage,_that.nextCursor,_that.searchError,_that.isChecking,_that.check,_that.checkError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InventorySubstance> items,  String query,  bool isSearching,  bool isLoadingMore,  bool hasNextPage,  String? nextCursor,  String? searchError,  bool isChecking,  InventorySubstanceCheck? check,  String? checkError)?  $default,) {final _that = this;
switch (_that) {
case _InventorySubstanceState() when $default != null:
return $default(_that.items,_that.query,_that.isSearching,_that.isLoadingMore,_that.hasNextPage,_that.nextCursor,_that.searchError,_that.isChecking,_that.check,_that.checkError);case _:
  return null;

}
}

}

/// @nodoc


class _InventorySubstanceState implements InventorySubstanceState {
  const _InventorySubstanceState({final  List<InventorySubstance> items = const <InventorySubstance>[], this.query = '', this.isSearching = false, this.isLoadingMore = false, this.hasNextPage = false, this.nextCursor, this.searchError, this.isChecking = false, this.check, this.checkError}): _items = items;
  

 final  List<InventorySubstance> _items;
@override@JsonKey() List<InventorySubstance> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasNextPage;
@override final  String? nextCursor;
@override final  String? searchError;
@override@JsonKey() final  bool isChecking;
@override final  InventorySubstanceCheck? check;
@override final  String? checkError;

/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySubstanceStateCopyWith<_InventorySubstanceState> get copyWith => __$InventorySubstanceStateCopyWithImpl<_InventorySubstanceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySubstanceState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.searchError, searchError) || other.searchError == searchError)&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.check, check) || other.check == check)&&(identical(other.checkError, checkError) || other.checkError == checkError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),query,isSearching,isLoadingMore,hasNextPage,nextCursor,searchError,isChecking,check,checkError);

@override
String toString() {
  return 'InventorySubstanceState(items: $items, query: $query, isSearching: $isSearching, isLoadingMore: $isLoadingMore, hasNextPage: $hasNextPage, nextCursor: $nextCursor, searchError: $searchError, isChecking: $isChecking, check: $check, checkError: $checkError)';
}


}

/// @nodoc
abstract mixin class _$InventorySubstanceStateCopyWith<$Res> implements $InventorySubstanceStateCopyWith<$Res> {
  factory _$InventorySubstanceStateCopyWith(_InventorySubstanceState value, $Res Function(_InventorySubstanceState) _then) = __$InventorySubstanceStateCopyWithImpl;
@override @useResult
$Res call({
 List<InventorySubstance> items, String query, bool isSearching, bool isLoadingMore, bool hasNextPage, String? nextCursor, String? searchError, bool isChecking, InventorySubstanceCheck? check, String? checkError
});


@override $InventorySubstanceCheckCopyWith<$Res>? get check;

}
/// @nodoc
class __$InventorySubstanceStateCopyWithImpl<$Res>
    implements _$InventorySubstanceStateCopyWith<$Res> {
  __$InventorySubstanceStateCopyWithImpl(this._self, this._then);

  final _InventorySubstanceState _self;
  final $Res Function(_InventorySubstanceState) _then;

/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? query = null,Object? isSearching = null,Object? isLoadingMore = null,Object? hasNextPage = null,Object? nextCursor = freezed,Object? searchError = freezed,Object? isChecking = null,Object? check = freezed,Object? checkError = freezed,}) {
  return _then(_InventorySubstanceState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InventorySubstance>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,searchError: freezed == searchError ? _self.searchError : searchError // ignore: cast_nullable_to_non_nullable
as String?,isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,check: freezed == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as InventorySubstanceCheck?,checkError: freezed == checkError ? _self.checkError : checkError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InventorySubstanceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySubstanceCheckCopyWith<$Res>? get check {
    if (_self.check == null) {
    return null;
  }

  return $InventorySubstanceCheckCopyWith<$Res>(_self.check!, (value) {
    return _then(_self.copyWith(check: value));
  });
}
}

// dart format on
