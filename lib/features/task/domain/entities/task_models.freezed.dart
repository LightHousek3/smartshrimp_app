// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskChoice {

 String get id; String get name;
/// Create a copy of TaskChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<TaskChoice> get copyWith => _$TaskChoiceCopyWithImpl<TaskChoice>(this as TaskChoice, _$identity);

  /// Serializes this TaskChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'TaskChoice(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $TaskChoiceCopyWith<$Res>  {
  factory $TaskChoiceCopyWith(TaskChoice value, $Res Function(TaskChoice) _then) = _$TaskChoiceCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$TaskChoiceCopyWithImpl<$Res>
    implements $TaskChoiceCopyWith<$Res> {
  _$TaskChoiceCopyWithImpl(this._self, this._then);

  final TaskChoice _self;
  final $Res Function(TaskChoice) _then;

/// Create a copy of TaskChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskChoice].
extension TaskChoicePatterns on TaskChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskChoice value)  $default,){
final _that = this;
switch (_that) {
case _TaskChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskChoice value)?  $default,){
final _that = this;
switch (_that) {
case _TaskChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskChoice() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _TaskChoice():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TaskChoice() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskChoice implements TaskChoice {
  const _TaskChoice({required this.id, required this.name});
  factory _TaskChoice.fromJson(Map<String, dynamic> json) => _$TaskChoiceFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of TaskChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskChoiceCopyWith<_TaskChoice> get copyWith => __$TaskChoiceCopyWithImpl<_TaskChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'TaskChoice(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TaskChoiceCopyWith<$Res> implements $TaskChoiceCopyWith<$Res> {
  factory _$TaskChoiceCopyWith(_TaskChoice value, $Res Function(_TaskChoice) _then) = __$TaskChoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$TaskChoiceCopyWithImpl<$Res>
    implements _$TaskChoiceCopyWith<$Res> {
  __$TaskChoiceCopyWithImpl(this._self, this._then);

  final _TaskChoice _self;
  final $Res Function(_TaskChoice) _then;

/// Create a copy of TaskChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_TaskChoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TaskItem {

 String get id; String get title;@JsonKey(unknownEnumValue: TaskPriority.unknown) TaskPriority get priority;@JsonKey(unknownEnumValue: TaskStatus.unknown) TaskStatus get status; TaskChoice get assignee; DateTime get dueAt; String? get description; String? get farmId; String? get seasonId; String? get assignedTo; TaskChoice? get season; TaskChoice? get farm; DateTime? get startedAt; DateTime? get completedAt; String? get cancellationReason; DateTime? get cancelledAt; TaskChoice? get cancelledBy;
/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskItemCopyWith<TaskItem> get copyWith => _$TaskItemCopyWithImpl<TaskItem>(this as TaskItem, _$identity);

  /// Serializes this TaskItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignee, assignee) || other.assignee == assignee)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.season, season) || other.season == season)&&(identical(other.farm, farm) || other.farm == farm)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,priority,status,assignee,dueAt,description,farmId,seasonId,assignedTo,season,farm,startedAt,completedAt,cancellationReason,cancelledAt,cancelledBy);

@override
String toString() {
  return 'TaskItem(id: $id, title: $title, priority: $priority, status: $status, assignee: $assignee, dueAt: $dueAt, description: $description, farmId: $farmId, seasonId: $seasonId, assignedTo: $assignedTo, season: $season, farm: $farm, startedAt: $startedAt, completedAt: $completedAt, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy)';
}


}

/// @nodoc
abstract mixin class $TaskItemCopyWith<$Res>  {
  factory $TaskItemCopyWith(TaskItem value, $Res Function(TaskItem) _then) = _$TaskItemCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(unknownEnumValue: TaskPriority.unknown) TaskPriority priority,@JsonKey(unknownEnumValue: TaskStatus.unknown) TaskStatus status, TaskChoice assignee, DateTime dueAt, String? description, String? farmId, String? seasonId, String? assignedTo, TaskChoice? season, TaskChoice? farm, DateTime? startedAt, DateTime? completedAt, String? cancellationReason, DateTime? cancelledAt, TaskChoice? cancelledBy
});


$TaskChoiceCopyWith<$Res> get assignee;$TaskChoiceCopyWith<$Res>? get season;$TaskChoiceCopyWith<$Res>? get farm;$TaskChoiceCopyWith<$Res>? get cancelledBy;

}
/// @nodoc
class _$TaskItemCopyWithImpl<$Res>
    implements $TaskItemCopyWith<$Res> {
  _$TaskItemCopyWithImpl(this._self, this._then);

  final TaskItem _self;
  final $Res Function(TaskItem) _then;

/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? priority = null,Object? status = null,Object? assignee = null,Object? dueAt = null,Object? description = freezed,Object? farmId = freezed,Object? seasonId = freezed,Object? assignedTo = freezed,Object? season = freezed,Object? farm = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancellationReason = freezed,Object? cancelledAt = freezed,Object? cancelledBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,assignee: null == assignee ? _self.assignee : assignee // ignore: cast_nullable_to_non_nullable
as TaskChoice,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as TaskChoice?,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as TaskChoice?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as TaskChoice?,
  ));
}
/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res> get assignee {
  
  return $TaskChoiceCopyWith<$Res>(_self.assignee, (value) {
    return _then(_self.copyWith(assignee: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get cancelledBy {
    if (_self.cancelledBy == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.cancelledBy!, (value) {
    return _then(_self.copyWith(cancelledBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskItem].
extension TaskItemPatterns on TaskItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskItem value)  $default,){
final _that = this;
switch (_that) {
case _TaskItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskItem value)?  $default,){
final _that = this;
switch (_that) {
case _TaskItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(unknownEnumValue: TaskPriority.unknown)  TaskPriority priority, @JsonKey(unknownEnumValue: TaskStatus.unknown)  TaskStatus status,  TaskChoice assignee,  DateTime dueAt,  String? description,  String? farmId,  String? seasonId,  String? assignedTo,  TaskChoice? season,  TaskChoice? farm,  DateTime? startedAt,  DateTime? completedAt,  String? cancellationReason,  DateTime? cancelledAt,  TaskChoice? cancelledBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskItem() when $default != null:
return $default(_that.id,_that.title,_that.priority,_that.status,_that.assignee,_that.dueAt,_that.description,_that.farmId,_that.seasonId,_that.assignedTo,_that.season,_that.farm,_that.startedAt,_that.completedAt,_that.cancellationReason,_that.cancelledAt,_that.cancelledBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(unknownEnumValue: TaskPriority.unknown)  TaskPriority priority, @JsonKey(unknownEnumValue: TaskStatus.unknown)  TaskStatus status,  TaskChoice assignee,  DateTime dueAt,  String? description,  String? farmId,  String? seasonId,  String? assignedTo,  TaskChoice? season,  TaskChoice? farm,  DateTime? startedAt,  DateTime? completedAt,  String? cancellationReason,  DateTime? cancelledAt,  TaskChoice? cancelledBy)  $default,) {final _that = this;
switch (_that) {
case _TaskItem():
return $default(_that.id,_that.title,_that.priority,_that.status,_that.assignee,_that.dueAt,_that.description,_that.farmId,_that.seasonId,_that.assignedTo,_that.season,_that.farm,_that.startedAt,_that.completedAt,_that.cancellationReason,_that.cancelledAt,_that.cancelledBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(unknownEnumValue: TaskPriority.unknown)  TaskPriority priority, @JsonKey(unknownEnumValue: TaskStatus.unknown)  TaskStatus status,  TaskChoice assignee,  DateTime dueAt,  String? description,  String? farmId,  String? seasonId,  String? assignedTo,  TaskChoice? season,  TaskChoice? farm,  DateTime? startedAt,  DateTime? completedAt,  String? cancellationReason,  DateTime? cancelledAt,  TaskChoice? cancelledBy)?  $default,) {final _that = this;
switch (_that) {
case _TaskItem() when $default != null:
return $default(_that.id,_that.title,_that.priority,_that.status,_that.assignee,_that.dueAt,_that.description,_that.farmId,_that.seasonId,_that.assignedTo,_that.season,_that.farm,_that.startedAt,_that.completedAt,_that.cancellationReason,_that.cancelledAt,_that.cancelledBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskItem extends TaskItem {
  const _TaskItem({required this.id, required this.title, @JsonKey(unknownEnumValue: TaskPriority.unknown) required this.priority, @JsonKey(unknownEnumValue: TaskStatus.unknown) required this.status, required this.assignee, required this.dueAt, this.description, this.farmId, this.seasonId, this.assignedTo, this.season, this.farm, this.startedAt, this.completedAt, this.cancellationReason, this.cancelledAt, this.cancelledBy}): super._();
  factory _TaskItem.fromJson(Map<String, dynamic> json) => _$TaskItemFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(unknownEnumValue: TaskPriority.unknown) final  TaskPriority priority;
@override@JsonKey(unknownEnumValue: TaskStatus.unknown) final  TaskStatus status;
@override final  TaskChoice assignee;
@override final  DateTime dueAt;
@override final  String? description;
@override final  String? farmId;
@override final  String? seasonId;
@override final  String? assignedTo;
@override final  TaskChoice? season;
@override final  TaskChoice? farm;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  String? cancellationReason;
@override final  DateTime? cancelledAt;
@override final  TaskChoice? cancelledBy;

/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskItemCopyWith<_TaskItem> get copyWith => __$TaskItemCopyWithImpl<_TaskItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignee, assignee) || other.assignee == assignee)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.season, season) || other.season == season)&&(identical(other.farm, farm) || other.farm == farm)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,priority,status,assignee,dueAt,description,farmId,seasonId,assignedTo,season,farm,startedAt,completedAt,cancellationReason,cancelledAt,cancelledBy);

@override
String toString() {
  return 'TaskItem(id: $id, title: $title, priority: $priority, status: $status, assignee: $assignee, dueAt: $dueAt, description: $description, farmId: $farmId, seasonId: $seasonId, assignedTo: $assignedTo, season: $season, farm: $farm, startedAt: $startedAt, completedAt: $completedAt, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy)';
}


}

/// @nodoc
abstract mixin class _$TaskItemCopyWith<$Res> implements $TaskItemCopyWith<$Res> {
  factory _$TaskItemCopyWith(_TaskItem value, $Res Function(_TaskItem) _then) = __$TaskItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(unknownEnumValue: TaskPriority.unknown) TaskPriority priority,@JsonKey(unknownEnumValue: TaskStatus.unknown) TaskStatus status, TaskChoice assignee, DateTime dueAt, String? description, String? farmId, String? seasonId, String? assignedTo, TaskChoice? season, TaskChoice? farm, DateTime? startedAt, DateTime? completedAt, String? cancellationReason, DateTime? cancelledAt, TaskChoice? cancelledBy
});


@override $TaskChoiceCopyWith<$Res> get assignee;@override $TaskChoiceCopyWith<$Res>? get season;@override $TaskChoiceCopyWith<$Res>? get farm;@override $TaskChoiceCopyWith<$Res>? get cancelledBy;

}
/// @nodoc
class __$TaskItemCopyWithImpl<$Res>
    implements _$TaskItemCopyWith<$Res> {
  __$TaskItemCopyWithImpl(this._self, this._then);

  final _TaskItem _self;
  final $Res Function(_TaskItem) _then;

/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? priority = null,Object? status = null,Object? assignee = null,Object? dueAt = null,Object? description = freezed,Object? farmId = freezed,Object? seasonId = freezed,Object? assignedTo = freezed,Object? season = freezed,Object? farm = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancellationReason = freezed,Object? cancelledAt = freezed,Object? cancelledBy = freezed,}) {
  return _then(_TaskItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,assignee: null == assignee ? _self.assignee : assignee // ignore: cast_nullable_to_non_nullable
as TaskChoice,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as TaskChoice?,farm: freezed == farm ? _self.farm : farm // ignore: cast_nullable_to_non_nullable
as TaskChoice?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as TaskChoice?,
  ));
}

/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res> get assignee {
  
  return $TaskChoiceCopyWith<$Res>(_self.assignee, (value) {
    return _then(_self.copyWith(assignee: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get farm {
    if (_self.farm == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.farm!, (value) {
    return _then(_self.copyWith(farm: value));
  });
}/// Create a copy of TaskItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get cancelledBy {
    if (_self.cancelledBy == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.cancelledBy!, (value) {
    return _then(_self.copyWith(cancelledBy: value));
  });
}
}


/// @nodoc
mixin _$TaskSeasonChoice {

 String get id; String get name; String get pondName; TaskChoice? get technician;
/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSeasonChoiceCopyWith<TaskSeasonChoice> get copyWith => _$TaskSeasonChoiceCopyWithImpl<TaskSeasonChoice>(this as TaskSeasonChoice, _$identity);

  /// Serializes this TaskSeasonChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSeasonChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.technician, technician) || other.technician == technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pondName,technician);

@override
String toString() {
  return 'TaskSeasonChoice(id: $id, name: $name, pondName: $pondName, technician: $technician)';
}


}

/// @nodoc
abstract mixin class $TaskSeasonChoiceCopyWith<$Res>  {
  factory $TaskSeasonChoiceCopyWith(TaskSeasonChoice value, $Res Function(TaskSeasonChoice) _then) = _$TaskSeasonChoiceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String pondName, TaskChoice? technician
});


$TaskChoiceCopyWith<$Res>? get technician;

}
/// @nodoc
class _$TaskSeasonChoiceCopyWithImpl<$Res>
    implements $TaskSeasonChoiceCopyWith<$Res> {
  _$TaskSeasonChoiceCopyWithImpl(this._self, this._then);

  final TaskSeasonChoice _self;
  final $Res Function(TaskSeasonChoice) _then;

/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pondName = null,Object? technician = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as TaskChoice?,
  ));
}
/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get technician {
    if (_self.technician == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.technician!, (value) {
    return _then(_self.copyWith(technician: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskSeasonChoice].
extension TaskSeasonChoicePatterns on TaskSeasonChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSeasonChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSeasonChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSeasonChoice value)  $default,){
final _that = this;
switch (_that) {
case _TaskSeasonChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSeasonChoice value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSeasonChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String pondName,  TaskChoice? technician)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSeasonChoice() when $default != null:
return $default(_that.id,_that.name,_that.pondName,_that.technician);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String pondName,  TaskChoice? technician)  $default,) {final _that = this;
switch (_that) {
case _TaskSeasonChoice():
return $default(_that.id,_that.name,_that.pondName,_that.technician);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String pondName,  TaskChoice? technician)?  $default,) {final _that = this;
switch (_that) {
case _TaskSeasonChoice() when $default != null:
return $default(_that.id,_that.name,_that.pondName,_that.technician);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSeasonChoice implements TaskSeasonChoice {
  const _TaskSeasonChoice({required this.id, required this.name, required this.pondName, this.technician});
  factory _TaskSeasonChoice.fromJson(Map<String, dynamic> json) => _$TaskSeasonChoiceFromJson(json);

@override final  String id;
@override final  String name;
@override final  String pondName;
@override final  TaskChoice? technician;

/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSeasonChoiceCopyWith<_TaskSeasonChoice> get copyWith => __$TaskSeasonChoiceCopyWithImpl<_TaskSeasonChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSeasonChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSeasonChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.technician, technician) || other.technician == technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pondName,technician);

@override
String toString() {
  return 'TaskSeasonChoice(id: $id, name: $name, pondName: $pondName, technician: $technician)';
}


}

/// @nodoc
abstract mixin class _$TaskSeasonChoiceCopyWith<$Res> implements $TaskSeasonChoiceCopyWith<$Res> {
  factory _$TaskSeasonChoiceCopyWith(_TaskSeasonChoice value, $Res Function(_TaskSeasonChoice) _then) = __$TaskSeasonChoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String pondName, TaskChoice? technician
});


@override $TaskChoiceCopyWith<$Res>? get technician;

}
/// @nodoc
class __$TaskSeasonChoiceCopyWithImpl<$Res>
    implements _$TaskSeasonChoiceCopyWith<$Res> {
  __$TaskSeasonChoiceCopyWithImpl(this._self, this._then);

  final _TaskSeasonChoice _self;
  final $Res Function(_TaskSeasonChoice) _then;

/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pondName = null,Object? technician = freezed,}) {
  return _then(_TaskSeasonChoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,technician: freezed == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as TaskChoice?,
  ));
}

/// Create a copy of TaskSeasonChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskChoiceCopyWith<$Res>? get technician {
    if (_self.technician == null) {
    return null;
  }

  return $TaskChoiceCopyWith<$Res>(_self.technician!, (value) {
    return _then(_self.copyWith(technician: value));
  });
}
}


/// @nodoc
mixin _$TaskOptions {

 List<TaskChoice> get farms; List<TaskChoice> get technicians; List<TaskSeasonChoice> get seasons;
/// Create a copy of TaskOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskOptionsCopyWith<TaskOptions> get copyWith => _$TaskOptionsCopyWithImpl<TaskOptions>(this as TaskOptions, _$identity);

  /// Serializes this TaskOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskOptions&&const DeepCollectionEquality().equals(other.farms, farms)&&const DeepCollectionEquality().equals(other.technicians, technicians)&&const DeepCollectionEquality().equals(other.seasons, seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(farms),const DeepCollectionEquality().hash(technicians),const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'TaskOptions(farms: $farms, technicians: $technicians, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $TaskOptionsCopyWith<$Res>  {
  factory $TaskOptionsCopyWith(TaskOptions value, $Res Function(TaskOptions) _then) = _$TaskOptionsCopyWithImpl;
@useResult
$Res call({
 List<TaskChoice> farms, List<TaskChoice> technicians, List<TaskSeasonChoice> seasons
});




}
/// @nodoc
class _$TaskOptionsCopyWithImpl<$Res>
    implements $TaskOptionsCopyWith<$Res> {
  _$TaskOptionsCopyWithImpl(this._self, this._then);

  final TaskOptions _self;
  final $Res Function(TaskOptions) _then;

/// Create a copy of TaskOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? farms = null,Object? technicians = null,Object? seasons = null,}) {
  return _then(_self.copyWith(
farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as List<TaskChoice>,technicians: null == technicians ? _self.technicians : technicians // ignore: cast_nullable_to_non_nullable
as List<TaskChoice>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TaskSeasonChoice>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskOptions].
extension TaskOptionsPatterns on TaskOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskOptions value)  $default,){
final _that = this;
switch (_that) {
case _TaskOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskOptions value)?  $default,){
final _that = this;
switch (_that) {
case _TaskOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskChoice> farms,  List<TaskChoice> technicians,  List<TaskSeasonChoice> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskOptions() when $default != null:
return $default(_that.farms,_that.technicians,_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskChoice> farms,  List<TaskChoice> technicians,  List<TaskSeasonChoice> seasons)  $default,) {final _that = this;
switch (_that) {
case _TaskOptions():
return $default(_that.farms,_that.technicians,_that.seasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskChoice> farms,  List<TaskChoice> technicians,  List<TaskSeasonChoice> seasons)?  $default,) {final _that = this;
switch (_that) {
case _TaskOptions() when $default != null:
return $default(_that.farms,_that.technicians,_that.seasons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskOptions implements TaskOptions {
  const _TaskOptions({required final  List<TaskChoice> farms, required final  List<TaskChoice> technicians, required final  List<TaskSeasonChoice> seasons}): _farms = farms,_technicians = technicians,_seasons = seasons;
  factory _TaskOptions.fromJson(Map<String, dynamic> json) => _$TaskOptionsFromJson(json);

 final  List<TaskChoice> _farms;
@override List<TaskChoice> get farms {
  if (_farms is EqualUnmodifiableListView) return _farms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_farms);
}

 final  List<TaskChoice> _technicians;
@override List<TaskChoice> get technicians {
  if (_technicians is EqualUnmodifiableListView) return _technicians;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technicians);
}

 final  List<TaskSeasonChoice> _seasons;
@override List<TaskSeasonChoice> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of TaskOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskOptionsCopyWith<_TaskOptions> get copyWith => __$TaskOptionsCopyWithImpl<_TaskOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskOptions&&const DeepCollectionEquality().equals(other._farms, _farms)&&const DeepCollectionEquality().equals(other._technicians, _technicians)&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_farms),const DeepCollectionEquality().hash(_technicians),const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'TaskOptions(farms: $farms, technicians: $technicians, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$TaskOptionsCopyWith<$Res> implements $TaskOptionsCopyWith<$Res> {
  factory _$TaskOptionsCopyWith(_TaskOptions value, $Res Function(_TaskOptions) _then) = __$TaskOptionsCopyWithImpl;
@override @useResult
$Res call({
 List<TaskChoice> farms, List<TaskChoice> technicians, List<TaskSeasonChoice> seasons
});




}
/// @nodoc
class __$TaskOptionsCopyWithImpl<$Res>
    implements _$TaskOptionsCopyWith<$Res> {
  __$TaskOptionsCopyWithImpl(this._self, this._then);

  final _TaskOptions _self;
  final $Res Function(_TaskOptions) _then;

/// Create a copy of TaskOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? farms = null,Object? technicians = null,Object? seasons = null,}) {
  return _then(_TaskOptions(
farms: null == farms ? _self._farms : farms // ignore: cast_nullable_to_non_nullable
as List<TaskChoice>,technicians: null == technicians ? _self._technicians : technicians // ignore: cast_nullable_to_non_nullable
as List<TaskChoice>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TaskSeasonChoice>,
  ));
}


}


/// @nodoc
mixin _$TaskCounts {

@JsonKey(name: 'PENDING') int get pending;@JsonKey(name: 'IN_PROGRESS') int get inProgress;@JsonKey(name: 'COMPLETED') int get completed;@JsonKey(name: 'CANCELLED') int get cancelled;
/// Create a copy of TaskCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCountsCopyWith<TaskCounts> get copyWith => _$TaskCountsCopyWithImpl<TaskCounts>(this as TaskCounts, _$identity);

  /// Serializes this TaskCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCounts&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pending,inProgress,completed,cancelled);

@override
String toString() {
  return 'TaskCounts(pending: $pending, inProgress: $inProgress, completed: $completed, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class $TaskCountsCopyWith<$Res>  {
  factory $TaskCountsCopyWith(TaskCounts value, $Res Function(TaskCounts) _then) = _$TaskCountsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'PENDING') int pending,@JsonKey(name: 'IN_PROGRESS') int inProgress,@JsonKey(name: 'COMPLETED') int completed,@JsonKey(name: 'CANCELLED') int cancelled
});




}
/// @nodoc
class _$TaskCountsCopyWithImpl<$Res>
    implements $TaskCountsCopyWith<$Res> {
  _$TaskCountsCopyWithImpl(this._self, this._then);

  final TaskCounts _self;
  final $Res Function(TaskCounts) _then;

/// Create a copy of TaskCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,}) {
  return _then(_self.copyWith(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCounts].
extension TaskCountsPatterns on TaskCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCounts value)  $default,){
final _that = this;
switch (_that) {
case _TaskCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCounts value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'PENDING')  int pending, @JsonKey(name: 'IN_PROGRESS')  int inProgress, @JsonKey(name: 'COMPLETED')  int completed, @JsonKey(name: 'CANCELLED')  int cancelled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCounts() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'PENDING')  int pending, @JsonKey(name: 'IN_PROGRESS')  int inProgress, @JsonKey(name: 'COMPLETED')  int completed, @JsonKey(name: 'CANCELLED')  int cancelled)  $default,) {final _that = this;
switch (_that) {
case _TaskCounts():
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'PENDING')  int pending, @JsonKey(name: 'IN_PROGRESS')  int inProgress, @JsonKey(name: 'COMPLETED')  int completed, @JsonKey(name: 'CANCELLED')  int cancelled)?  $default,) {final _that = this;
switch (_that) {
case _TaskCounts() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCounts extends TaskCounts {
  const _TaskCounts({@JsonKey(name: 'PENDING') required this.pending, @JsonKey(name: 'IN_PROGRESS') required this.inProgress, @JsonKey(name: 'COMPLETED') required this.completed, @JsonKey(name: 'CANCELLED') required this.cancelled}): super._();
  factory _TaskCounts.fromJson(Map<String, dynamic> json) => _$TaskCountsFromJson(json);

@override@JsonKey(name: 'PENDING') final  int pending;
@override@JsonKey(name: 'IN_PROGRESS') final  int inProgress;
@override@JsonKey(name: 'COMPLETED') final  int completed;
@override@JsonKey(name: 'CANCELLED') final  int cancelled;

/// Create a copy of TaskCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCountsCopyWith<_TaskCounts> get copyWith => __$TaskCountsCopyWithImpl<_TaskCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCounts&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pending,inProgress,completed,cancelled);

@override
String toString() {
  return 'TaskCounts(pending: $pending, inProgress: $inProgress, completed: $completed, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class _$TaskCountsCopyWith<$Res> implements $TaskCountsCopyWith<$Res> {
  factory _$TaskCountsCopyWith(_TaskCounts value, $Res Function(_TaskCounts) _then) = __$TaskCountsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'PENDING') int pending,@JsonKey(name: 'IN_PROGRESS') int inProgress,@JsonKey(name: 'COMPLETED') int completed,@JsonKey(name: 'CANCELLED') int cancelled
});




}
/// @nodoc
class __$TaskCountsCopyWithImpl<$Res>
    implements _$TaskCountsCopyWith<$Res> {
  __$TaskCountsCopyWithImpl(this._self, this._then);

  final _TaskCounts _self;
  final $Res Function(_TaskCounts) _then;

/// Create a copy of TaskCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,}) {
  return _then(_TaskCounts(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskPage {

 List<TaskItem> get items; int get page; bool get hasNextPage; int get totalResults; TaskCounts get counts; DateTime get serverNow;
/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskPageCopyWith<TaskPage> get copyWith => _$TaskPageCopyWithImpl<TaskPage>(this as TaskPage, _$identity);

  /// Serializes this TaskPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,hasNextPage,totalResults,counts,serverNow);

@override
String toString() {
  return 'TaskPage(items: $items, page: $page, hasNextPage: $hasNextPage, totalResults: $totalResults, counts: $counts, serverNow: $serverNow)';
}


}

/// @nodoc
abstract mixin class $TaskPageCopyWith<$Res>  {
  factory $TaskPageCopyWith(TaskPage value, $Res Function(TaskPage) _then) = _$TaskPageCopyWithImpl;
@useResult
$Res call({
 List<TaskItem> items, int page, bool hasNextPage, int totalResults, TaskCounts counts, DateTime serverNow
});


$TaskCountsCopyWith<$Res> get counts;

}
/// @nodoc
class _$TaskPageCopyWithImpl<$Res>
    implements $TaskPageCopyWith<$Res> {
  _$TaskPageCopyWithImpl(this._self, this._then);

  final TaskPage _self;
  final $Res Function(TaskPage) _then;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? hasNextPage = null,Object? totalResults = null,Object? counts = null,Object? serverNow = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as TaskCounts,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCountsCopyWith<$Res> get counts {
  
  return $TaskCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskPage].
extension TaskPagePatterns on TaskPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskPage value)  $default,){
final _that = this;
switch (_that) {
case _TaskPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskPage value)?  $default,){
final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskItem> items,  int page,  bool hasNextPage,  int totalResults,  TaskCounts counts,  DateTime serverNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
return $default(_that.items,_that.page,_that.hasNextPage,_that.totalResults,_that.counts,_that.serverNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskItem> items,  int page,  bool hasNextPage,  int totalResults,  TaskCounts counts,  DateTime serverNow)  $default,) {final _that = this;
switch (_that) {
case _TaskPage():
return $default(_that.items,_that.page,_that.hasNextPage,_that.totalResults,_that.counts,_that.serverNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskItem> items,  int page,  bool hasNextPage,  int totalResults,  TaskCounts counts,  DateTime serverNow)?  $default,) {final _that = this;
switch (_that) {
case _TaskPage() when $default != null:
return $default(_that.items,_that.page,_that.hasNextPage,_that.totalResults,_that.counts,_that.serverNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskPage implements TaskPage {
  const _TaskPage({required final  List<TaskItem> items, required this.page, required this.hasNextPage, required this.totalResults, required this.counts, required this.serverNow}): _items = items;
  factory _TaskPage.fromJson(Map<String, dynamic> json) => _$TaskPageFromJson(json);

 final  List<TaskItem> _items;
@override List<TaskItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  bool hasNextPage;
@override final  int totalResults;
@override final  TaskCounts counts;
@override final  DateTime serverNow;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskPageCopyWith<_TaskPage> get copyWith => __$TaskPageCopyWithImpl<_TaskPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,hasNextPage,totalResults,counts,serverNow);

@override
String toString() {
  return 'TaskPage(items: $items, page: $page, hasNextPage: $hasNextPage, totalResults: $totalResults, counts: $counts, serverNow: $serverNow)';
}


}

/// @nodoc
abstract mixin class _$TaskPageCopyWith<$Res> implements $TaskPageCopyWith<$Res> {
  factory _$TaskPageCopyWith(_TaskPage value, $Res Function(_TaskPage) _then) = __$TaskPageCopyWithImpl;
@override @useResult
$Res call({
 List<TaskItem> items, int page, bool hasNextPage, int totalResults, TaskCounts counts, DateTime serverNow
});


@override $TaskCountsCopyWith<$Res> get counts;

}
/// @nodoc
class __$TaskPageCopyWithImpl<$Res>
    implements _$TaskPageCopyWith<$Res> {
  __$TaskPageCopyWithImpl(this._self, this._then);

  final _TaskPage _self;
  final $Res Function(_TaskPage) _then;

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? hasNextPage = null,Object? totalResults = null,Object? counts = null,Object? serverNow = null,}) {
  return _then(_TaskPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as TaskCounts,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of TaskPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCountsCopyWith<$Res> get counts {
  
  return $TaskCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// @nodoc
mixin _$TaskInput {

 String get title; String? get description; TaskPriority get priority; DateTime get dueAt; String get farmId; String? get seasonId; String? get assignedTo;
/// Create a copy of TaskInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskInputCopyWith<TaskInput> get copyWith => _$TaskInputCopyWithImpl<TaskInput>(this as TaskInput, _$identity);

  /// Serializes this TaskInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskInput&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,dueAt,farmId,seasonId,assignedTo);

@override
String toString() {
  return 'TaskInput(title: $title, description: $description, priority: $priority, dueAt: $dueAt, farmId: $farmId, seasonId: $seasonId, assignedTo: $assignedTo)';
}


}

/// @nodoc
abstract mixin class $TaskInputCopyWith<$Res>  {
  factory $TaskInputCopyWith(TaskInput value, $Res Function(TaskInput) _then) = _$TaskInputCopyWithImpl;
@useResult
$Res call({
 String title, String? description, TaskPriority priority, DateTime dueAt, String farmId, String? seasonId, String? assignedTo
});




}
/// @nodoc
class _$TaskInputCopyWithImpl<$Res>
    implements $TaskInputCopyWith<$Res> {
  _$TaskInputCopyWithImpl(this._self, this._then);

  final TaskInput _self;
  final $Res Function(TaskInput) _then;

/// Create a copy of TaskInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? priority = null,Object? dueAt = null,Object? farmId = null,Object? seasonId = freezed,Object? assignedTo = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskInput].
extension TaskInputPatterns on TaskInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskInput value)  $default,){
final _that = this;
switch (_that) {
case _TaskInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskInput value)?  $default,){
final _that = this;
switch (_that) {
case _TaskInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  TaskPriority priority,  DateTime dueAt,  String farmId,  String? seasonId,  String? assignedTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskInput() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.dueAt,_that.farmId,_that.seasonId,_that.assignedTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  TaskPriority priority,  DateTime dueAt,  String farmId,  String? seasonId,  String? assignedTo)  $default,) {final _that = this;
switch (_that) {
case _TaskInput():
return $default(_that.title,_that.description,_that.priority,_that.dueAt,_that.farmId,_that.seasonId,_that.assignedTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  TaskPriority priority,  DateTime dueAt,  String farmId,  String? seasonId,  String? assignedTo)?  $default,) {final _that = this;
switch (_that) {
case _TaskInput() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.dueAt,_that.farmId,_that.seasonId,_that.assignedTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskInput implements TaskInput {
  const _TaskInput({required this.title, this.description, required this.priority, required this.dueAt, required this.farmId, this.seasonId, this.assignedTo});
  factory _TaskInput.fromJson(Map<String, dynamic> json) => _$TaskInputFromJson(json);

@override final  String title;
@override final  String? description;
@override final  TaskPriority priority;
@override final  DateTime dueAt;
@override final  String farmId;
@override final  String? seasonId;
@override final  String? assignedTo;

/// Create a copy of TaskInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskInputCopyWith<_TaskInput> get copyWith => __$TaskInputCopyWithImpl<_TaskInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskInput&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,dueAt,farmId,seasonId,assignedTo);

@override
String toString() {
  return 'TaskInput(title: $title, description: $description, priority: $priority, dueAt: $dueAt, farmId: $farmId, seasonId: $seasonId, assignedTo: $assignedTo)';
}


}

/// @nodoc
abstract mixin class _$TaskInputCopyWith<$Res> implements $TaskInputCopyWith<$Res> {
  factory _$TaskInputCopyWith(_TaskInput value, $Res Function(_TaskInput) _then) = __$TaskInputCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, TaskPriority priority, DateTime dueAt, String farmId, String? seasonId, String? assignedTo
});




}
/// @nodoc
class __$TaskInputCopyWithImpl<$Res>
    implements _$TaskInputCopyWith<$Res> {
  __$TaskInputCopyWithImpl(this._self, this._then);

  final _TaskInput _self;
  final $Res Function(_TaskInput) _then;

/// Create a copy of TaskInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? priority = null,Object? dueAt = null,Object? farmId = null,Object? seasonId = freezed,Object? assignedTo = freezed,}) {
  return _then(_TaskInput(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,seasonId: freezed == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
