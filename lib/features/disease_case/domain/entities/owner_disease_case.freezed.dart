// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_disease_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiseaseCaseCard {

@JsonKey(fromJson: _requiredText) String get id;@JsonKey(fromJson: _requiredText) String get title;@JsonKey(fromJson: _requiredText) String get description;@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus get status;@JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown) DiseaseCaseSeverity get severity;@JsonKey(fromJson: _requiredText) String get expertName;@JsonKey(fromJson: _count) int get responseCount; String? get aiDiagnosis;
/// Create a copy of DiseaseCaseCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseCardCopyWith<DiseaseCaseCard> get copyWith => _$DiseaseCaseCardCopyWithImpl<DiseaseCaseCard>(this as DiseaseCaseCard, _$identity);

  /// Serializes this DiseaseCaseCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.expertName, expertName) || other.expertName == expertName)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.aiDiagnosis, aiDiagnosis) || other.aiDiagnosis == aiDiagnosis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,severity,expertName,responseCount,aiDiagnosis);

@override
String toString() {
  return 'DiseaseCaseCard(id: $id, title: $title, description: $description, status: $status, severity: $severity, expertName: $expertName, responseCount: $responseCount, aiDiagnosis: $aiDiagnosis)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseCardCopyWith<$Res>  {
  factory $DiseaseCaseCardCopyWith(DiseaseCaseCard value, $Res Function(DiseaseCaseCard) _then) = _$DiseaseCaseCardCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _requiredText) String id,@JsonKey(fromJson: _requiredText) String title,@JsonKey(fromJson: _requiredText) String description,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus status,@JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown) DiseaseCaseSeverity severity,@JsonKey(fromJson: _requiredText) String expertName,@JsonKey(fromJson: _count) int responseCount, String? aiDiagnosis
});




}
/// @nodoc
class _$DiseaseCaseCardCopyWithImpl<$Res>
    implements $DiseaseCaseCardCopyWith<$Res> {
  _$DiseaseCaseCardCopyWithImpl(this._self, this._then);

  final DiseaseCaseCard _self;
  final $Res Function(DiseaseCaseCard) _then;

/// Create a copy of DiseaseCaseCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? severity = null,Object? expertName = null,Object? responseCount = null,Object? aiDiagnosis = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as DiseaseCaseSeverity,expertName: null == expertName ? _self.expertName : expertName // ignore: cast_nullable_to_non_nullable
as String,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,aiDiagnosis: freezed == aiDiagnosis ? _self.aiDiagnosis : aiDiagnosis // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCaseCard].
extension DiseaseCaseCardPatterns on DiseaseCaseCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCaseCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCaseCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCaseCard value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCaseCard value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _requiredText)  String description, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown)  DiseaseCaseSeverity severity, @JsonKey(fromJson: _requiredText)  String expertName, @JsonKey(fromJson: _count)  int responseCount,  String? aiDiagnosis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCaseCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.severity,_that.expertName,_that.responseCount,_that.aiDiagnosis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _requiredText)  String description, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown)  DiseaseCaseSeverity severity, @JsonKey(fromJson: _requiredText)  String expertName, @JsonKey(fromJson: _count)  int responseCount,  String? aiDiagnosis)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseCard():
return $default(_that.id,_that.title,_that.description,_that.status,_that.severity,_that.expertName,_that.responseCount,_that.aiDiagnosis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _requiredText)  String description, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus status, @JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown)  DiseaseCaseSeverity severity, @JsonKey(fromJson: _requiredText)  String expertName, @JsonKey(fromJson: _count)  int responseCount,  String? aiDiagnosis)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.severity,_that.expertName,_that.responseCount,_that.aiDiagnosis);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCaseCard implements DiseaseCaseCard {
  const _DiseaseCaseCard({@JsonKey(fromJson: _requiredText) required this.id, @JsonKey(fromJson: _requiredText) required this.title, @JsonKey(fromJson: _requiredText) required this.description, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) required this.status, @JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown) required this.severity, @JsonKey(fromJson: _requiredText) required this.expertName, @JsonKey(fromJson: _count) required this.responseCount, this.aiDiagnosis});
  factory _DiseaseCaseCard.fromJson(Map<String, dynamic> json) => _$DiseaseCaseCardFromJson(json);

@override@JsonKey(fromJson: _requiredText) final  String id;
@override@JsonKey(fromJson: _requiredText) final  String title;
@override@JsonKey(fromJson: _requiredText) final  String description;
@override@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) final  DiseaseCaseStatus status;
@override@JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown) final  DiseaseCaseSeverity severity;
@override@JsonKey(fromJson: _requiredText) final  String expertName;
@override@JsonKey(fromJson: _count) final  int responseCount;
@override final  String? aiDiagnosis;

/// Create a copy of DiseaseCaseCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseCardCopyWith<_DiseaseCaseCard> get copyWith => __$DiseaseCaseCardCopyWithImpl<_DiseaseCaseCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCaseCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.expertName, expertName) || other.expertName == expertName)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.aiDiagnosis, aiDiagnosis) || other.aiDiagnosis == aiDiagnosis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,severity,expertName,responseCount,aiDiagnosis);

@override
String toString() {
  return 'DiseaseCaseCard(id: $id, title: $title, description: $description, status: $status, severity: $severity, expertName: $expertName, responseCount: $responseCount, aiDiagnosis: $aiDiagnosis)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseCardCopyWith<$Res> implements $DiseaseCaseCardCopyWith<$Res> {
  factory _$DiseaseCaseCardCopyWith(_DiseaseCaseCard value, $Res Function(_DiseaseCaseCard) _then) = __$DiseaseCaseCardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _requiredText) String id,@JsonKey(fromJson: _requiredText) String title,@JsonKey(fromJson: _requiredText) String description,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus status,@JsonKey(unknownEnumValue: DiseaseCaseSeverity.unknown) DiseaseCaseSeverity severity,@JsonKey(fromJson: _requiredText) String expertName,@JsonKey(fromJson: _count) int responseCount, String? aiDiagnosis
});




}
/// @nodoc
class __$DiseaseCaseCardCopyWithImpl<$Res>
    implements _$DiseaseCaseCardCopyWith<$Res> {
  __$DiseaseCaseCardCopyWithImpl(this._self, this._then);

  final _DiseaseCaseCard _self;
  final $Res Function(_DiseaseCaseCard) _then;

/// Create a copy of DiseaseCaseCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? status = null,Object? severity = null,Object? expertName = null,Object? responseCount = null,Object? aiDiagnosis = freezed,}) {
  return _then(_DiseaseCaseCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as DiseaseCaseSeverity,expertName: null == expertName ? _self.expertName : expertName // ignore: cast_nullable_to_non_nullable
as String,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,aiDiagnosis: freezed == aiDiagnosis ? _self.aiDiagnosis : aiDiagnosis // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DiseaseCasePage {

 List<DiseaseCaseCard> get items;@JsonKey(fromJson: _requiredText) String get seasonName;@JsonKey(fromJson: _requiredText) String get pondName;@JsonKey(fromJson: _positiveInt) int get page; bool get hasNextPage;@JsonKey(fromJson: _count) int get activeCount;@JsonKey(fromJson: _count) int get resolvedCount;
/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCasePageCopyWith<DiseaseCasePage> get copyWith => _$DiseaseCasePageCopyWithImpl<DiseaseCasePage>(this as DiseaseCasePage, _$identity);

  /// Serializes this DiseaseCasePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCasePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.resolvedCount, resolvedCount) || other.resolvedCount == resolvedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),seasonName,pondName,page,hasNextPage,activeCount,resolvedCount);

@override
String toString() {
  return 'DiseaseCasePage(items: $items, seasonName: $seasonName, pondName: $pondName, page: $page, hasNextPage: $hasNextPage, activeCount: $activeCount, resolvedCount: $resolvedCount)';
}


}

/// @nodoc
abstract mixin class $DiseaseCasePageCopyWith<$Res>  {
  factory $DiseaseCasePageCopyWith(DiseaseCasePage value, $Res Function(DiseaseCasePage) _then) = _$DiseaseCasePageCopyWithImpl;
@useResult
$Res call({
 List<DiseaseCaseCard> items,@JsonKey(fromJson: _requiredText) String seasonName,@JsonKey(fromJson: _requiredText) String pondName,@JsonKey(fromJson: _positiveInt) int page, bool hasNextPage,@JsonKey(fromJson: _count) int activeCount,@JsonKey(fromJson: _count) int resolvedCount
});




}
/// @nodoc
class _$DiseaseCasePageCopyWithImpl<$Res>
    implements $DiseaseCasePageCopyWith<$Res> {
  _$DiseaseCasePageCopyWithImpl(this._self, this._then);

  final DiseaseCasePage _self;
  final $Res Function(DiseaseCasePage) _then;

/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? seasonName = null,Object? pondName = null,Object? page = null,Object? hasNextPage = null,Object? activeCount = null,Object? resolvedCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseCard>,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,resolvedCount: null == resolvedCount ? _self.resolvedCount : resolvedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCasePage].
extension DiseaseCasePagePatterns on DiseaseCasePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCasePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCasePage value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCasePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCasePage value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiseaseCaseCard> items, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _positiveInt)  int page,  bool hasNextPage, @JsonKey(fromJson: _count)  int activeCount, @JsonKey(fromJson: _count)  int resolvedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
return $default(_that.items,_that.seasonName,_that.pondName,_that.page,_that.hasNextPage,_that.activeCount,_that.resolvedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiseaseCaseCard> items, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _positiveInt)  int page,  bool hasNextPage, @JsonKey(fromJson: _count)  int activeCount, @JsonKey(fromJson: _count)  int resolvedCount)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCasePage():
return $default(_that.items,_that.seasonName,_that.pondName,_that.page,_that.hasNextPage,_that.activeCount,_that.resolvedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiseaseCaseCard> items, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _positiveInt)  int page,  bool hasNextPage, @JsonKey(fromJson: _count)  int activeCount, @JsonKey(fromJson: _count)  int resolvedCount)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCasePage() when $default != null:
return $default(_that.items,_that.seasonName,_that.pondName,_that.page,_that.hasNextPage,_that.activeCount,_that.resolvedCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCasePage implements DiseaseCasePage {
  const _DiseaseCasePage({required final  List<DiseaseCaseCard> items, @JsonKey(fromJson: _requiredText) required this.seasonName, @JsonKey(fromJson: _requiredText) required this.pondName, @JsonKey(fromJson: _positiveInt) required this.page, required this.hasNextPage, @JsonKey(fromJson: _count) required this.activeCount, @JsonKey(fromJson: _count) required this.resolvedCount}): _items = items;
  factory _DiseaseCasePage.fromJson(Map<String, dynamic> json) => _$DiseaseCasePageFromJson(json);

 final  List<DiseaseCaseCard> _items;
@override List<DiseaseCaseCard> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(fromJson: _requiredText) final  String seasonName;
@override@JsonKey(fromJson: _requiredText) final  String pondName;
@override@JsonKey(fromJson: _positiveInt) final  int page;
@override final  bool hasNextPage;
@override@JsonKey(fromJson: _count) final  int activeCount;
@override@JsonKey(fromJson: _count) final  int resolvedCount;

/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCasePageCopyWith<_DiseaseCasePage> get copyWith => __$DiseaseCasePageCopyWithImpl<_DiseaseCasePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCasePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCasePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.resolvedCount, resolvedCount) || other.resolvedCount == resolvedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),seasonName,pondName,page,hasNextPage,activeCount,resolvedCount);

@override
String toString() {
  return 'DiseaseCasePage(items: $items, seasonName: $seasonName, pondName: $pondName, page: $page, hasNextPage: $hasNextPage, activeCount: $activeCount, resolvedCount: $resolvedCount)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCasePageCopyWith<$Res> implements $DiseaseCasePageCopyWith<$Res> {
  factory _$DiseaseCasePageCopyWith(_DiseaseCasePage value, $Res Function(_DiseaseCasePage) _then) = __$DiseaseCasePageCopyWithImpl;
@override @useResult
$Res call({
 List<DiseaseCaseCard> items,@JsonKey(fromJson: _requiredText) String seasonName,@JsonKey(fromJson: _requiredText) String pondName,@JsonKey(fromJson: _positiveInt) int page, bool hasNextPage,@JsonKey(fromJson: _count) int activeCount,@JsonKey(fromJson: _count) int resolvedCount
});




}
/// @nodoc
class __$DiseaseCasePageCopyWithImpl<$Res>
    implements _$DiseaseCasePageCopyWith<$Res> {
  __$DiseaseCasePageCopyWithImpl(this._self, this._then);

  final _DiseaseCasePage _self;
  final $Res Function(_DiseaseCasePage) _then;

/// Create a copy of DiseaseCasePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? seasonName = null,Object? pondName = null,Object? page = null,Object? hasNextPage = null,Object? activeCount = null,Object? resolvedCount = null,}) {
  return _then(_DiseaseCasePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseCard>,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,resolvedCount: null == resolvedCount ? _self.resolvedCount : resolvedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DiseaseCaseDetail {

 DiseaseCaseCard get card;@JsonKey(fromJson: _requiredText) String get seasonName;@JsonKey(fromJson: _requiredText) String get pondName;@JsonKey(fromJson: _requiredText) String get farmName;@JsonKey(fromJson: _requiredText) String get reporterName; DateTime get createdAt; DateTime get updatedAt; List<DiseaseCaseAttachment> get attachments; List<DiseaseCaseProtocol> get protocols; List<DiseaseCaseEvent> get timeline; DiseaseCaseSnapshot? get snapshot; String? get resolutionSummary;
/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseDetailCopyWith<DiseaseCaseDetail> get copyWith => _$DiseaseCaseDetailCopyWithImpl<DiseaseCaseDetail>(this as DiseaseCaseDetail, _$identity);

  /// Serializes this DiseaseCaseDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseDetail&&(identical(other.card, card) || other.card == card)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.reporterName, reporterName) || other.reporterName == reporterName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.protocols, protocols)&&const DeepCollectionEquality().equals(other.timeline, timeline)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.resolutionSummary, resolutionSummary) || other.resolutionSummary == resolutionSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,card,seasonName,pondName,farmName,reporterName,createdAt,updatedAt,const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(protocols),const DeepCollectionEquality().hash(timeline),snapshot,resolutionSummary);

@override
String toString() {
  return 'DiseaseCaseDetail(card: $card, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, reporterName: $reporterName, createdAt: $createdAt, updatedAt: $updatedAt, attachments: $attachments, protocols: $protocols, timeline: $timeline, snapshot: $snapshot, resolutionSummary: $resolutionSummary)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseDetailCopyWith<$Res>  {
  factory $DiseaseCaseDetailCopyWith(DiseaseCaseDetail value, $Res Function(DiseaseCaseDetail) _then) = _$DiseaseCaseDetailCopyWithImpl;
@useResult
$Res call({
 DiseaseCaseCard card,@JsonKey(fromJson: _requiredText) String seasonName,@JsonKey(fromJson: _requiredText) String pondName,@JsonKey(fromJson: _requiredText) String farmName,@JsonKey(fromJson: _requiredText) String reporterName, DateTime createdAt, DateTime updatedAt, List<DiseaseCaseAttachment> attachments, List<DiseaseCaseProtocol> protocols, List<DiseaseCaseEvent> timeline, DiseaseCaseSnapshot? snapshot, String? resolutionSummary
});


$DiseaseCaseCardCopyWith<$Res> get card;$DiseaseCaseSnapshotCopyWith<$Res>? get snapshot;

}
/// @nodoc
class _$DiseaseCaseDetailCopyWithImpl<$Res>
    implements $DiseaseCaseDetailCopyWith<$Res> {
  _$DiseaseCaseDetailCopyWithImpl(this._self, this._then);

  final DiseaseCaseDetail _self;
  final $Res Function(DiseaseCaseDetail) _then;

/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? card = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? reporterName = null,Object? createdAt = null,Object? updatedAt = null,Object? attachments = null,Object? protocols = null,Object? timeline = null,Object? snapshot = freezed,Object? resolutionSummary = freezed,}) {
  return _then(_self.copyWith(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as DiseaseCaseCard,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,reporterName: null == reporterName ? _self.reporterName : reporterName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseAttachment>,protocols: null == protocols ? _self.protocols : protocols // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseProtocol>,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseEvent>,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as DiseaseCaseSnapshot?,resolutionSummary: freezed == resolutionSummary ? _self.resolutionSummary : resolutionSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiseaseCaseCardCopyWith<$Res> get card {

  return $DiseaseCaseCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiseaseCaseSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $DiseaseCaseSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiseaseCaseDetail].
extension DiseaseCaseDetailPatterns on DiseaseCaseDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCaseDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCaseDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCaseDetail value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCaseDetail value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiseaseCaseCard card, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _requiredText)  String farmName, @JsonKey(fromJson: _requiredText)  String reporterName,  DateTime createdAt,  DateTime updatedAt,  List<DiseaseCaseAttachment> attachments,  List<DiseaseCaseProtocol> protocols,  List<DiseaseCaseEvent> timeline,  DiseaseCaseSnapshot? snapshot,  String? resolutionSummary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCaseDetail() when $default != null:
return $default(_that.card,_that.seasonName,_that.pondName,_that.farmName,_that.reporterName,_that.createdAt,_that.updatedAt,_that.attachments,_that.protocols,_that.timeline,_that.snapshot,_that.resolutionSummary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiseaseCaseCard card, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _requiredText)  String farmName, @JsonKey(fromJson: _requiredText)  String reporterName,  DateTime createdAt,  DateTime updatedAt,  List<DiseaseCaseAttachment> attachments,  List<DiseaseCaseProtocol> protocols,  List<DiseaseCaseEvent> timeline,  DiseaseCaseSnapshot? snapshot,  String? resolutionSummary)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseDetail():
return $default(_that.card,_that.seasonName,_that.pondName,_that.farmName,_that.reporterName,_that.createdAt,_that.updatedAt,_that.attachments,_that.protocols,_that.timeline,_that.snapshot,_that.resolutionSummary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiseaseCaseCard card, @JsonKey(fromJson: _requiredText)  String seasonName, @JsonKey(fromJson: _requiredText)  String pondName, @JsonKey(fromJson: _requiredText)  String farmName, @JsonKey(fromJson: _requiredText)  String reporterName,  DateTime createdAt,  DateTime updatedAt,  List<DiseaseCaseAttachment> attachments,  List<DiseaseCaseProtocol> protocols,  List<DiseaseCaseEvent> timeline,  DiseaseCaseSnapshot? snapshot,  String? resolutionSummary)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseDetail() when $default != null:
return $default(_that.card,_that.seasonName,_that.pondName,_that.farmName,_that.reporterName,_that.createdAt,_that.updatedAt,_that.attachments,_that.protocols,_that.timeline,_that.snapshot,_that.resolutionSummary);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCaseDetail implements DiseaseCaseDetail {
  const _DiseaseCaseDetail({required this.card, @JsonKey(fromJson: _requiredText) required this.seasonName, @JsonKey(fromJson: _requiredText) required this.pondName, @JsonKey(fromJson: _requiredText) required this.farmName, @JsonKey(fromJson: _requiredText) required this.reporterName, required this.createdAt, required this.updatedAt, required final  List<DiseaseCaseAttachment> attachments, required final  List<DiseaseCaseProtocol> protocols, required final  List<DiseaseCaseEvent> timeline, this.snapshot, this.resolutionSummary}): _attachments = attachments,_protocols = protocols,_timeline = timeline;
  factory _DiseaseCaseDetail.fromJson(Map<String, dynamic> json) => _$DiseaseCaseDetailFromJson(json);

@override final  DiseaseCaseCard card;
@override@JsonKey(fromJson: _requiredText) final  String seasonName;
@override@JsonKey(fromJson: _requiredText) final  String pondName;
@override@JsonKey(fromJson: _requiredText) final  String farmName;
@override@JsonKey(fromJson: _requiredText) final  String reporterName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<DiseaseCaseAttachment> _attachments;
@override List<DiseaseCaseAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

 final  List<DiseaseCaseProtocol> _protocols;
@override List<DiseaseCaseProtocol> get protocols {
  if (_protocols is EqualUnmodifiableListView) return _protocols;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_protocols);
}

 final  List<DiseaseCaseEvent> _timeline;
@override List<DiseaseCaseEvent> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

@override final  DiseaseCaseSnapshot? snapshot;
@override final  String? resolutionSummary;

/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseDetailCopyWith<_DiseaseCaseDetail> get copyWith => __$DiseaseCaseDetailCopyWithImpl<_DiseaseCaseDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCaseDetail&&(identical(other.card, card) || other.card == card)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.reporterName, reporterName) || other.reporterName == reporterName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._protocols, _protocols)&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.resolutionSummary, resolutionSummary) || other.resolutionSummary == resolutionSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,card,seasonName,pondName,farmName,reporterName,createdAt,updatedAt,const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_protocols),const DeepCollectionEquality().hash(_timeline),snapshot,resolutionSummary);

@override
String toString() {
  return 'DiseaseCaseDetail(card: $card, seasonName: $seasonName, pondName: $pondName, farmName: $farmName, reporterName: $reporterName, createdAt: $createdAt, updatedAt: $updatedAt, attachments: $attachments, protocols: $protocols, timeline: $timeline, snapshot: $snapshot, resolutionSummary: $resolutionSummary)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseDetailCopyWith<$Res> implements $DiseaseCaseDetailCopyWith<$Res> {
  factory _$DiseaseCaseDetailCopyWith(_DiseaseCaseDetail value, $Res Function(_DiseaseCaseDetail) _then) = __$DiseaseCaseDetailCopyWithImpl;
@override @useResult
$Res call({
 DiseaseCaseCard card,@JsonKey(fromJson: _requiredText) String seasonName,@JsonKey(fromJson: _requiredText) String pondName,@JsonKey(fromJson: _requiredText) String farmName,@JsonKey(fromJson: _requiredText) String reporterName, DateTime createdAt, DateTime updatedAt, List<DiseaseCaseAttachment> attachments, List<DiseaseCaseProtocol> protocols, List<DiseaseCaseEvent> timeline, DiseaseCaseSnapshot? snapshot, String? resolutionSummary
});


@override $DiseaseCaseCardCopyWith<$Res> get card;@override $DiseaseCaseSnapshotCopyWith<$Res>? get snapshot;

}
/// @nodoc
class __$DiseaseCaseDetailCopyWithImpl<$Res>
    implements _$DiseaseCaseDetailCopyWith<$Res> {
  __$DiseaseCaseDetailCopyWithImpl(this._self, this._then);

  final _DiseaseCaseDetail _self;
  final $Res Function(_DiseaseCaseDetail) _then;

/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? card = null,Object? seasonName = null,Object? pondName = null,Object? farmName = null,Object? reporterName = null,Object? createdAt = null,Object? updatedAt = null,Object? attachments = null,Object? protocols = null,Object? timeline = null,Object? snapshot = freezed,Object? resolutionSummary = freezed,}) {
  return _then(_DiseaseCaseDetail(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as DiseaseCaseCard,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,reporterName: null == reporterName ? _self.reporterName : reporterName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseAttachment>,protocols: null == protocols ? _self._protocols : protocols // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseProtocol>,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<DiseaseCaseEvent>,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as DiseaseCaseSnapshot?,resolutionSummary: freezed == resolutionSummary ? _self.resolutionSummary : resolutionSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiseaseCaseCardCopyWith<$Res> get card {

  return $DiseaseCaseCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}/// Create a copy of DiseaseCaseDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiseaseCaseSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $DiseaseCaseSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// @nodoc
mixin _$DiseaseCaseSnapshot {

 List<String> get exceededWaterMetrics; DateTime? get capturedAt;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) OpeningHealthStatus? get healthStatus; String? get note; num? get avgWeightG; num? get mortalityCount; num? get ph; num? get no2MgL; num? get nh3MgL;
/// Create a copy of DiseaseCaseSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseSnapshotCopyWith<DiseaseCaseSnapshot> get copyWith => _$DiseaseCaseSnapshotCopyWithImpl<DiseaseCaseSnapshot>(this as DiseaseCaseSnapshot, _$identity);

  /// Serializes this DiseaseCaseSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseSnapshot&&const DeepCollectionEquality().equals(other.exceededWaterMetrics, exceededWaterMetrics)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.healthStatus, healthStatus) || other.healthStatus == healthStatus)&&(identical(other.note, note) || other.note == note)&&(identical(other.avgWeightG, avgWeightG) || other.avgWeightG == avgWeightG)&&(identical(other.mortalityCount, mortalityCount) || other.mortalityCount == mortalityCount)&&(identical(other.ph, ph) || other.ph == ph)&&(identical(other.no2MgL, no2MgL) || other.no2MgL == no2MgL)&&(identical(other.nh3MgL, nh3MgL) || other.nh3MgL == nh3MgL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(exceededWaterMetrics),capturedAt,healthStatus,note,avgWeightG,mortalityCount,ph,no2MgL,nh3MgL);

@override
String toString() {
  return 'DiseaseCaseSnapshot(exceededWaterMetrics: $exceededWaterMetrics, capturedAt: $capturedAt, healthStatus: $healthStatus, note: $note, avgWeightG: $avgWeightG, mortalityCount: $mortalityCount, ph: $ph, no2MgL: $no2MgL, nh3MgL: $nh3MgL)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseSnapshotCopyWith<$Res>  {
  factory $DiseaseCaseSnapshotCopyWith(DiseaseCaseSnapshot value, $Res Function(DiseaseCaseSnapshot) _then) = _$DiseaseCaseSnapshotCopyWithImpl;
@useResult
$Res call({
 List<String> exceededWaterMetrics, DateTime? capturedAt,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) OpeningHealthStatus? healthStatus, String? note, num? avgWeightG, num? mortalityCount, num? ph, num? no2MgL, num? nh3MgL
});




}
/// @nodoc
class _$DiseaseCaseSnapshotCopyWithImpl<$Res>
    implements $DiseaseCaseSnapshotCopyWith<$Res> {
  _$DiseaseCaseSnapshotCopyWithImpl(this._self, this._then);

  final DiseaseCaseSnapshot _self;
  final $Res Function(DiseaseCaseSnapshot) _then;

/// Create a copy of DiseaseCaseSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exceededWaterMetrics = null,Object? capturedAt = freezed,Object? healthStatus = freezed,Object? note = freezed,Object? avgWeightG = freezed,Object? mortalityCount = freezed,Object? ph = freezed,Object? no2MgL = freezed,Object? nh3MgL = freezed,}) {
  return _then(_self.copyWith(
exceededWaterMetrics: null == exceededWaterMetrics ? _self.exceededWaterMetrics : exceededWaterMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,healthStatus: freezed == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as OpeningHealthStatus?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,avgWeightG: freezed == avgWeightG ? _self.avgWeightG : avgWeightG // ignore: cast_nullable_to_non_nullable
as num?,mortalityCount: freezed == mortalityCount ? _self.mortalityCount : mortalityCount // ignore: cast_nullable_to_non_nullable
as num?,ph: freezed == ph ? _self.ph : ph // ignore: cast_nullable_to_non_nullable
as num?,no2MgL: freezed == no2MgL ? _self.no2MgL : no2MgL // ignore: cast_nullable_to_non_nullable
as num?,nh3MgL: freezed == nh3MgL ? _self.nh3MgL : nh3MgL // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCaseSnapshot].
extension DiseaseCaseSnapshotPatterns on DiseaseCaseSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCaseSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCaseSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCaseSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> exceededWaterMetrics,  DateTime? capturedAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  OpeningHealthStatus? healthStatus,  String? note,  num? avgWeightG,  num? mortalityCount,  num? ph,  num? no2MgL,  num? nh3MgL)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot() when $default != null:
return $default(_that.exceededWaterMetrics,_that.capturedAt,_that.healthStatus,_that.note,_that.avgWeightG,_that.mortalityCount,_that.ph,_that.no2MgL,_that.nh3MgL);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> exceededWaterMetrics,  DateTime? capturedAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  OpeningHealthStatus? healthStatus,  String? note,  num? avgWeightG,  num? mortalityCount,  num? ph,  num? no2MgL,  num? nh3MgL)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot():
return $default(_that.exceededWaterMetrics,_that.capturedAt,_that.healthStatus,_that.note,_that.avgWeightG,_that.mortalityCount,_that.ph,_that.no2MgL,_that.nh3MgL);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> exceededWaterMetrics,  DateTime? capturedAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  OpeningHealthStatus? healthStatus,  String? note,  num? avgWeightG,  num? mortalityCount,  num? ph,  num? no2MgL,  num? nh3MgL)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseSnapshot() when $default != null:
return $default(_that.exceededWaterMetrics,_that.capturedAt,_that.healthStatus,_that.note,_that.avgWeightG,_that.mortalityCount,_that.ph,_that.no2MgL,_that.nh3MgL);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCaseSnapshot implements DiseaseCaseSnapshot {
  const _DiseaseCaseSnapshot({required final  List<String> exceededWaterMetrics, this.capturedAt, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.healthStatus, this.note, this.avgWeightG, this.mortalityCount, this.ph, this.no2MgL, this.nh3MgL}): _exceededWaterMetrics = exceededWaterMetrics;
  factory _DiseaseCaseSnapshot.fromJson(Map<String, dynamic> json) => _$DiseaseCaseSnapshotFromJson(json);

 final  List<String> _exceededWaterMetrics;
@override List<String> get exceededWaterMetrics {
  if (_exceededWaterMetrics is EqualUnmodifiableListView) return _exceededWaterMetrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exceededWaterMetrics);
}

@override final  DateTime? capturedAt;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  OpeningHealthStatus? healthStatus;
@override final  String? note;
@override final  num? avgWeightG;
@override final  num? mortalityCount;
@override final  num? ph;
@override final  num? no2MgL;
@override final  num? nh3MgL;

/// Create a copy of DiseaseCaseSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseSnapshotCopyWith<_DiseaseCaseSnapshot> get copyWith => __$DiseaseCaseSnapshotCopyWithImpl<_DiseaseCaseSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCaseSnapshot&&const DeepCollectionEquality().equals(other._exceededWaterMetrics, _exceededWaterMetrics)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.healthStatus, healthStatus) || other.healthStatus == healthStatus)&&(identical(other.note, note) || other.note == note)&&(identical(other.avgWeightG, avgWeightG) || other.avgWeightG == avgWeightG)&&(identical(other.mortalityCount, mortalityCount) || other.mortalityCount == mortalityCount)&&(identical(other.ph, ph) || other.ph == ph)&&(identical(other.no2MgL, no2MgL) || other.no2MgL == no2MgL)&&(identical(other.nh3MgL, nh3MgL) || other.nh3MgL == nh3MgL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_exceededWaterMetrics),capturedAt,healthStatus,note,avgWeightG,mortalityCount,ph,no2MgL,nh3MgL);

@override
String toString() {
  return 'DiseaseCaseSnapshot(exceededWaterMetrics: $exceededWaterMetrics, capturedAt: $capturedAt, healthStatus: $healthStatus, note: $note, avgWeightG: $avgWeightG, mortalityCount: $mortalityCount, ph: $ph, no2MgL: $no2MgL, nh3MgL: $nh3MgL)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseSnapshotCopyWith<$Res> implements $DiseaseCaseSnapshotCopyWith<$Res> {
  factory _$DiseaseCaseSnapshotCopyWith(_DiseaseCaseSnapshot value, $Res Function(_DiseaseCaseSnapshot) _then) = __$DiseaseCaseSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<String> exceededWaterMetrics, DateTime? capturedAt,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) OpeningHealthStatus? healthStatus, String? note, num? avgWeightG, num? mortalityCount, num? ph, num? no2MgL, num? nh3MgL
});




}
/// @nodoc
class __$DiseaseCaseSnapshotCopyWithImpl<$Res>
    implements _$DiseaseCaseSnapshotCopyWith<$Res> {
  __$DiseaseCaseSnapshotCopyWithImpl(this._self, this._then);

  final _DiseaseCaseSnapshot _self;
  final $Res Function(_DiseaseCaseSnapshot) _then;

/// Create a copy of DiseaseCaseSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exceededWaterMetrics = null,Object? capturedAt = freezed,Object? healthStatus = freezed,Object? note = freezed,Object? avgWeightG = freezed,Object? mortalityCount = freezed,Object? ph = freezed,Object? no2MgL = freezed,Object? nh3MgL = freezed,}) {
  return _then(_DiseaseCaseSnapshot(
exceededWaterMetrics: null == exceededWaterMetrics ? _self._exceededWaterMetrics : exceededWaterMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,healthStatus: freezed == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as OpeningHealthStatus?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,avgWeightG: freezed == avgWeightG ? _self.avgWeightG : avgWeightG // ignore: cast_nullable_to_non_nullable
as num?,mortalityCount: freezed == mortalityCount ? _self.mortalityCount : mortalityCount // ignore: cast_nullable_to_non_nullable
as num?,ph: freezed == ph ? _self.ph : ph // ignore: cast_nullable_to_non_nullable
as num?,no2MgL: freezed == no2MgL ? _self.no2MgL : no2MgL // ignore: cast_nullable_to_non_nullable
as num?,nh3MgL: freezed == nh3MgL ? _self.nh3MgL : nh3MgL // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$DiseaseCaseAttachment {

@JsonKey(fromJson: _requiredText) String get fileUrl;@JsonKey(fromJson: _requiredText) String get uploaderName; DateTime get createdAt; String? get mediaType; String? get caption;
/// Create a copy of DiseaseCaseAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseAttachmentCopyWith<DiseaseCaseAttachment> get copyWith => _$DiseaseCaseAttachmentCopyWithImpl<DiseaseCaseAttachment>(this as DiseaseCaseAttachment, _$identity);

  /// Serializes this DiseaseCaseAttachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseAttachment&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileUrl,uploaderName,createdAt,mediaType,caption);

@override
String toString() {
  return 'DiseaseCaseAttachment(fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, mediaType: $mediaType, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseAttachmentCopyWith<$Res>  {
  factory $DiseaseCaseAttachmentCopyWith(DiseaseCaseAttachment value, $Res Function(DiseaseCaseAttachment) _then) = _$DiseaseCaseAttachmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _requiredText) String fileUrl,@JsonKey(fromJson: _requiredText) String uploaderName, DateTime createdAt, String? mediaType, String? caption
});




}
/// @nodoc
class _$DiseaseCaseAttachmentCopyWithImpl<$Res>
    implements $DiseaseCaseAttachmentCopyWith<$Res> {
  _$DiseaseCaseAttachmentCopyWithImpl(this._self, this._then);

  final DiseaseCaseAttachment _self;
  final $Res Function(DiseaseCaseAttachment) _then;

/// Create a copy of DiseaseCaseAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileUrl = null,Object? uploaderName = null,Object? createdAt = null,Object? mediaType = freezed,Object? caption = freezed,}) {
  return _then(_self.copyWith(
fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCaseAttachment].
extension DiseaseCaseAttachmentPatterns on DiseaseCaseAttachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCaseAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCaseAttachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCaseAttachment value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseAttachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCaseAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseAttachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String fileUrl, @JsonKey(fromJson: _requiredText)  String uploaderName,  DateTime createdAt,  String? mediaType,  String? caption)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCaseAttachment() when $default != null:
return $default(_that.fileUrl,_that.uploaderName,_that.createdAt,_that.mediaType,_that.caption);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String fileUrl, @JsonKey(fromJson: _requiredText)  String uploaderName,  DateTime createdAt,  String? mediaType,  String? caption)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseAttachment():
return $default(_that.fileUrl,_that.uploaderName,_that.createdAt,_that.mediaType,_that.caption);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _requiredText)  String fileUrl, @JsonKey(fromJson: _requiredText)  String uploaderName,  DateTime createdAt,  String? mediaType,  String? caption)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseAttachment() when $default != null:
return $default(_that.fileUrl,_that.uploaderName,_that.createdAt,_that.mediaType,_that.caption);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCaseAttachment implements DiseaseCaseAttachment {
  const _DiseaseCaseAttachment({@JsonKey(fromJson: _requiredText) required this.fileUrl, @JsonKey(fromJson: _requiredText) required this.uploaderName, required this.createdAt, this.mediaType, this.caption});
  factory _DiseaseCaseAttachment.fromJson(Map<String, dynamic> json) => _$DiseaseCaseAttachmentFromJson(json);

@override@JsonKey(fromJson: _requiredText) final  String fileUrl;
@override@JsonKey(fromJson: _requiredText) final  String uploaderName;
@override final  DateTime createdAt;
@override final  String? mediaType;
@override final  String? caption;

/// Create a copy of DiseaseCaseAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseAttachmentCopyWith<_DiseaseCaseAttachment> get copyWith => __$DiseaseCaseAttachmentCopyWithImpl<_DiseaseCaseAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCaseAttachment&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileUrl,uploaderName,createdAt,mediaType,caption);

@override
String toString() {
  return 'DiseaseCaseAttachment(fileUrl: $fileUrl, uploaderName: $uploaderName, createdAt: $createdAt, mediaType: $mediaType, caption: $caption)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseAttachmentCopyWith<$Res> implements $DiseaseCaseAttachmentCopyWith<$Res> {
  factory _$DiseaseCaseAttachmentCopyWith(_DiseaseCaseAttachment value, $Res Function(_DiseaseCaseAttachment) _then) = __$DiseaseCaseAttachmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _requiredText) String fileUrl,@JsonKey(fromJson: _requiredText) String uploaderName, DateTime createdAt, String? mediaType, String? caption
});




}
/// @nodoc
class __$DiseaseCaseAttachmentCopyWithImpl<$Res>
    implements _$DiseaseCaseAttachmentCopyWith<$Res> {
  __$DiseaseCaseAttachmentCopyWithImpl(this._self, this._then);

  final _DiseaseCaseAttachment _self;
  final $Res Function(_DiseaseCaseAttachment) _then;

/// Create a copy of DiseaseCaseAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileUrl = null,Object? uploaderName = null,Object? createdAt = null,Object? mediaType = freezed,Object? caption = freezed,}) {
  return _then(_DiseaseCaseAttachment(
fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DiseaseCaseProtocol {

@JsonKey(fromJson: _requiredText) String get id;@JsonKey(fromJson: _requiredText) String get title;@JsonKey(fromJson: _positiveInt) int get versionNo;@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus get status; String? get summary;
/// Create a copy of DiseaseCaseProtocol
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseProtocolCopyWith<DiseaseCaseProtocol> get copyWith => _$DiseaseCaseProtocolCopyWithImpl<DiseaseCaseProtocol>(this as DiseaseCaseProtocol, _$identity);

  /// Serializes this DiseaseCaseProtocol to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseProtocol&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,versionNo,status,summary);

@override
String toString() {
  return 'DiseaseCaseProtocol(id: $id, title: $title, versionNo: $versionNo, status: $status, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseProtocolCopyWith<$Res>  {
  factory $DiseaseCaseProtocolCopyWith(DiseaseCaseProtocol value, $Res Function(DiseaseCaseProtocol) _then) = _$DiseaseCaseProtocolCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _requiredText) String id,@JsonKey(fromJson: _requiredText) String title,@JsonKey(fromJson: _positiveInt) int versionNo,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus status, String? summary
});




}
/// @nodoc
class _$DiseaseCaseProtocolCopyWithImpl<$Res>
    implements $DiseaseCaseProtocolCopyWith<$Res> {
  _$DiseaseCaseProtocolCopyWithImpl(this._self, this._then);

  final DiseaseCaseProtocol _self;
  final $Res Function(DiseaseCaseProtocol) _then;

/// Create a copy of DiseaseCaseProtocol
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? versionNo = null,Object? status = null,Object? summary = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCaseProtocol].
extension DiseaseCaseProtocolPatterns on DiseaseCaseProtocol {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiseaseCaseProtocol value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiseaseCaseProtocol() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiseaseCaseProtocol value)  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseProtocol():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiseaseCaseProtocol value)?  $default,){
final _that = this;
switch (_that) {
case _DiseaseCaseProtocol() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _positiveInt)  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiseaseCaseProtocol() when $default != null:
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _positiveInt)  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseProtocol():
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _requiredText)  String id, @JsonKey(fromJson: _requiredText)  String title, @JsonKey(fromJson: _positiveInt)  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _DiseaseCaseProtocol() when $default != null:
return $default(_that.id,_that.title,_that.versionNo,_that.status,_that.summary);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _DiseaseCaseProtocol implements DiseaseCaseProtocol {
  const _DiseaseCaseProtocol({@JsonKey(fromJson: _requiredText) required this.id, @JsonKey(fromJson: _requiredText) required this.title, @JsonKey(fromJson: _positiveInt) required this.versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown) required this.status, this.summary});
  factory _DiseaseCaseProtocol.fromJson(Map<String, dynamic> json) => _$DiseaseCaseProtocolFromJson(json);

@override@JsonKey(fromJson: _requiredText) final  String id;
@override@JsonKey(fromJson: _requiredText) final  String title;
@override@JsonKey(fromJson: _positiveInt) final  int versionNo;
@override@JsonKey(unknownEnumValue: ProtocolStatus.unknown) final  ProtocolStatus status;
@override final  String? summary;

/// Create a copy of DiseaseCaseProtocol
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiseaseCaseProtocolCopyWith<_DiseaseCaseProtocol> get copyWith => __$DiseaseCaseProtocolCopyWithImpl<_DiseaseCaseProtocol>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseProtocolToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiseaseCaseProtocol&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,versionNo,status,summary);

@override
String toString() {
  return 'DiseaseCaseProtocol(id: $id, title: $title, versionNo: $versionNo, status: $status, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$DiseaseCaseProtocolCopyWith<$Res> implements $DiseaseCaseProtocolCopyWith<$Res> {
  factory _$DiseaseCaseProtocolCopyWith(_DiseaseCaseProtocol value, $Res Function(_DiseaseCaseProtocol) _then) = __$DiseaseCaseProtocolCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _requiredText) String id,@JsonKey(fromJson: _requiredText) String title,@JsonKey(fromJson: _positiveInt) int versionNo,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus status, String? summary
});




}
/// @nodoc
class __$DiseaseCaseProtocolCopyWithImpl<$Res>
    implements _$DiseaseCaseProtocolCopyWith<$Res> {
  __$DiseaseCaseProtocolCopyWithImpl(this._self, this._then);

  final _DiseaseCaseProtocol _self;
  final $Res Function(_DiseaseCaseProtocol) _then;

/// Create a copy of DiseaseCaseProtocol
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? versionNo = null,Object? status = null,Object? summary = freezed,}) {
  return _then(_DiseaseCaseProtocol(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

DiseaseCaseEvent _$DiseaseCaseEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'status':
          return DiseaseCaseStatusChange.fromJson(
            json
          );
                case 'response':
          return DiseaseCaseResponse.fromJson(
            json
          );

          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'DiseaseCaseEvent',
  'Invalid union type "${json['kind']}"!'
);
        }

}

/// @nodoc
mixin _$DiseaseCaseEvent {

 DateTime get at;@JsonKey(fromJson: _requiredText) String get authorName;@JsonKey(fromJson: _requiredText) String? get message;
/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseEventCopyWith<DiseaseCaseEvent> get copyWith => _$DiseaseCaseEventCopyWithImpl<DiseaseCaseEvent>(this as DiseaseCaseEvent, _$identity);

  /// Serializes this DiseaseCaseEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseEvent&&(identical(other.at, at) || other.at == at)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,authorName,message);

@override
String toString() {
  return 'DiseaseCaseEvent(at: $at, authorName: $authorName, message: $message)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseEventCopyWith<$Res>  {
  factory $DiseaseCaseEventCopyWith(DiseaseCaseEvent value, $Res Function(DiseaseCaseEvent) _then) = _$DiseaseCaseEventCopyWithImpl;
@useResult
$Res call({
 DateTime at,@JsonKey(fromJson: _requiredText) String authorName, String message
});




}
/// @nodoc
class _$DiseaseCaseEventCopyWithImpl<$Res>
    implements $DiseaseCaseEventCopyWith<$Res> {
  _$DiseaseCaseEventCopyWithImpl(this._self, this._then);

  final DiseaseCaseEvent _self;
  final $Res Function(DiseaseCaseEvent) _then;

/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? authorName = null,Object? message = null,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message! : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiseaseCaseEvent].
extension DiseaseCaseEventPatterns on DiseaseCaseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiseaseCaseStatusChange value)?  status,TResult Function( DiseaseCaseResponse value)?  response,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiseaseCaseStatusChange() when status != null:
return status(_that);case DiseaseCaseResponse() when response != null:
return response(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiseaseCaseStatusChange value)  status,required TResult Function( DiseaseCaseResponse value)  response,}){
final _that = this;
switch (_that) {
case DiseaseCaseStatusChange():
return status(_that);case DiseaseCaseResponse():
return response(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiseaseCaseStatusChange value)?  status,TResult? Function( DiseaseCaseResponse value)?  response,}){
final _that = this;
switch (_that) {
case DiseaseCaseStatusChange() when status != null:
return status(_that);case DiseaseCaseResponse() when response != null:
return response(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus toStatus, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus? fromStatus,  String? message)?  status,TResult Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole authorRole, @JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown)  DiseaseCaseResponseType responseType, @JsonKey(fromJson: _requiredText)  String message)?  response,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiseaseCaseStatusChange() when status != null:
return status(_that.at,_that.authorName,_that.toStatus,_that.fromStatus,_that.message);case DiseaseCaseResponse() when response != null:
return response(_that.at,_that.authorName,_that.authorRole,_that.responseType,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus toStatus, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus? fromStatus,  String? message)  status,required TResult Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole authorRole, @JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown)  DiseaseCaseResponseType responseType, @JsonKey(fromJson: _requiredText)  String message)  response,}) {final _that = this;
switch (_that) {
case DiseaseCaseStatusChange():
return status(_that.at,_that.authorName,_that.toStatus,_that.fromStatus,_that.message);case DiseaseCaseResponse():
return response(_that.at,_that.authorName,_that.authorRole,_that.responseType,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus toStatus, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown)  DiseaseCaseStatus? fromStatus,  String? message)?  status,TResult? Function( DateTime at, @JsonKey(fromJson: _requiredText)  String authorName, @JsonKey(unknownEnumValue: AccountRole.unknown)  AccountRole authorRole, @JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown)  DiseaseCaseResponseType responseType, @JsonKey(fromJson: _requiredText)  String message)?  response,}) {final _that = this;
switch (_that) {
case DiseaseCaseStatusChange() when status != null:
return status(_that.at,_that.authorName,_that.toStatus,_that.fromStatus,_that.message);case DiseaseCaseResponse() when response != null:
return response(_that.at,_that.authorName,_that.authorRole,_that.responseType,_that.message);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class DiseaseCaseStatusChange implements DiseaseCaseEvent {
  const DiseaseCaseStatusChange({required this.at, @JsonKey(fromJson: _requiredText) required this.authorName, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) required this.toStatus, @JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) this.fromStatus, this.message, final  String? $type}): $type = $type ?? 'status';
  factory DiseaseCaseStatusChange.fromJson(Map<String, dynamic> json) => _$DiseaseCaseStatusChangeFromJson(json);

@override final  DateTime at;
@override@JsonKey(fromJson: _requiredText) final  String authorName;
@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) final  DiseaseCaseStatus toStatus;
@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) final  DiseaseCaseStatus? fromStatus;
@override final  String? message;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseStatusChangeCopyWith<DiseaseCaseStatusChange> get copyWith => _$DiseaseCaseStatusChangeCopyWithImpl<DiseaseCaseStatusChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseStatusChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseStatusChange&&(identical(other.at, at) || other.at == at)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,authorName,toStatus,fromStatus,message);

@override
String toString() {
  return 'DiseaseCaseEvent.status(at: $at, authorName: $authorName, toStatus: $toStatus, fromStatus: $fromStatus, message: $message)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseStatusChangeCopyWith<$Res> implements $DiseaseCaseEventCopyWith<$Res> {
  factory $DiseaseCaseStatusChangeCopyWith(DiseaseCaseStatusChange value, $Res Function(DiseaseCaseStatusChange) _then) = _$DiseaseCaseStatusChangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime at,@JsonKey(fromJson: _requiredText) String authorName,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus toStatus,@JsonKey(unknownEnumValue: DiseaseCaseStatus.unknown) DiseaseCaseStatus? fromStatus, String? message
});




}
/// @nodoc
class _$DiseaseCaseStatusChangeCopyWithImpl<$Res>
    implements $DiseaseCaseStatusChangeCopyWith<$Res> {
  _$DiseaseCaseStatusChangeCopyWithImpl(this._self, this._then);

  final DiseaseCaseStatusChange _self;
  final $Res Function(DiseaseCaseStatusChange) _then;

/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? authorName = null,Object? toStatus = null,Object? fromStatus = freezed,Object? message = freezed,}) {
  return _then(DiseaseCaseStatusChange(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as DiseaseCaseStatus?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable(checked: true)
class DiseaseCaseResponse implements DiseaseCaseEvent {
  const DiseaseCaseResponse({required this.at, @JsonKey(fromJson: _requiredText) required this.authorName, @JsonKey(unknownEnumValue: AccountRole.unknown) required this.authorRole, @JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown) required this.responseType, @JsonKey(fromJson: _requiredText) required this.message, final  String? $type}): $type = $type ?? 'response';
  factory DiseaseCaseResponse.fromJson(Map<String, dynamic> json) => _$DiseaseCaseResponseFromJson(json);

@override final  DateTime at;
@override@JsonKey(fromJson: _requiredText) final  String authorName;
@JsonKey(unknownEnumValue: AccountRole.unknown) final  AccountRole authorRole;
@JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown) final  DiseaseCaseResponseType responseType;
@override@JsonKey(fromJson: _requiredText) final  String message;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiseaseCaseResponseCopyWith<DiseaseCaseResponse> get copyWith => _$DiseaseCaseResponseCopyWithImpl<DiseaseCaseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiseaseCaseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiseaseCaseResponse&&(identical(other.at, at) || other.at == at)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,authorName,authorRole,responseType,message);

@override
String toString() {
  return 'DiseaseCaseEvent.response(at: $at, authorName: $authorName, authorRole: $authorRole, responseType: $responseType, message: $message)';
}


}

/// @nodoc
abstract mixin class $DiseaseCaseResponseCopyWith<$Res> implements $DiseaseCaseEventCopyWith<$Res> {
  factory $DiseaseCaseResponseCopyWith(DiseaseCaseResponse value, $Res Function(DiseaseCaseResponse) _then) = _$DiseaseCaseResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime at,@JsonKey(fromJson: _requiredText) String authorName,@JsonKey(unknownEnumValue: AccountRole.unknown) AccountRole authorRole,@JsonKey(unknownEnumValue: DiseaseCaseResponseType.unknown) DiseaseCaseResponseType responseType,@JsonKey(fromJson: _requiredText) String message
});




}
/// @nodoc
class _$DiseaseCaseResponseCopyWithImpl<$Res>
    implements $DiseaseCaseResponseCopyWith<$Res> {
  _$DiseaseCaseResponseCopyWithImpl(this._self, this._then);

  final DiseaseCaseResponse _self;
  final $Res Function(DiseaseCaseResponse) _then;

/// Create a copy of DiseaseCaseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? authorName = null,Object? authorRole = null,Object? responseType = null,Object? message = null,}) {
  return _then(DiseaseCaseResponse(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorRole: null == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as AccountRole,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as DiseaseCaseResponseType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
