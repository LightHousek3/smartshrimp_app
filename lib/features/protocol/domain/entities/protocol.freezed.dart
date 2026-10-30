// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'protocol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProtocolCardData {

 String get id; String get seasonId;@JsonKey(unknownEnumValue: ProtocolType.unknown) ProtocolType get protocolType; String get title; String? get summary; int get versionNo;@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus get status; String get authorName; DateTime? get submittedAt; String? get diseaseCaseId; String? get diseaseCaseTitle; String get seasonName; String get pondName; String get farmName;
/// Create a copy of ProtocolCardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolCardDataCopyWith<ProtocolCardData> get copyWith => _$ProtocolCardDataCopyWithImpl<ProtocolCardData>(this as ProtocolCardData, _$identity);

  /// Serializes this ProtocolCardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolCardData&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.protocolType, protocolType) || other.protocolType == protocolType)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.diseaseCaseId, diseaseCaseId) || other.diseaseCaseId == diseaseCaseId)&&(identical(other.diseaseCaseTitle, diseaseCaseTitle) || other.diseaseCaseTitle == diseaseCaseTitle)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,protocolType,title,summary,versionNo,status,authorName,submittedAt,diseaseCaseId,diseaseCaseTitle,seasonName,pondName,farmName);

@override
String toString() {
  return 'ProtocolCardData(id: $id, seasonId: $seasonId, protocolType: $protocolType, title: $title, summary: $summary, versionNo: $versionNo, status: $status, authorName: $authorName, submittedAt: $submittedAt, diseaseCaseId: $diseaseCaseId, diseaseCaseTitle: $diseaseCaseTitle, seasonName: $seasonName, pondName: $pondName, farmName: $farmName)';
}


}

/// @nodoc
abstract mixin class $ProtocolCardDataCopyWith<$Res>  {
  factory $ProtocolCardDataCopyWith(ProtocolCardData value, $Res Function(ProtocolCardData) _then) = _$ProtocolCardDataCopyWithImpl;
@useResult
$Res call({
 String id, String seasonId,@JsonKey(unknownEnumValue: ProtocolType.unknown) ProtocolType protocolType, String title, String? summary, int versionNo,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus status, String authorName, DateTime? submittedAt, String? diseaseCaseId, String? diseaseCaseTitle, String seasonName, String pondName, String farmName
});




}
/// @nodoc
class _$ProtocolCardDataCopyWithImpl<$Res>
    implements $ProtocolCardDataCopyWith<$Res> {
  _$ProtocolCardDataCopyWithImpl(this._self, this._then);

  final ProtocolCardData _self;
  final $Res Function(ProtocolCardData) _then;

/// Create a copy of ProtocolCardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonId = null,Object? protocolType = null,Object? title = null,Object? summary = freezed,Object? versionNo = null,Object? status = null,Object? authorName = null,Object? submittedAt = freezed,Object? diseaseCaseId = freezed,Object? diseaseCaseTitle = freezed,Object? seasonName = null,Object? pondName = null,Object? farmName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,protocolType: null == protocolType ? _self.protocolType : protocolType // ignore: cast_nullable_to_non_nullable
as ProtocolType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,diseaseCaseId: freezed == diseaseCaseId ? _self.diseaseCaseId : diseaseCaseId // ignore: cast_nullable_to_non_nullable
as String?,diseaseCaseTitle: freezed == diseaseCaseTitle ? _self.diseaseCaseTitle : diseaseCaseTitle // ignore: cast_nullable_to_non_nullable
as String?,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolCardData].
extension ProtocolCardDataPatterns on ProtocolCardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolCardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolCardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolCardData value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolCardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolCardData value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolCardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seasonId, @JsonKey(unknownEnumValue: ProtocolType.unknown)  ProtocolType protocolType,  String title,  String? summary,  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String authorName,  DateTime? submittedAt,  String? diseaseCaseId,  String? diseaseCaseTitle,  String seasonName,  String pondName,  String farmName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolCardData() when $default != null:
return $default(_that.id,_that.seasonId,_that.protocolType,_that.title,_that.summary,_that.versionNo,_that.status,_that.authorName,_that.submittedAt,_that.diseaseCaseId,_that.diseaseCaseTitle,_that.seasonName,_that.pondName,_that.farmName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seasonId, @JsonKey(unknownEnumValue: ProtocolType.unknown)  ProtocolType protocolType,  String title,  String? summary,  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String authorName,  DateTime? submittedAt,  String? diseaseCaseId,  String? diseaseCaseTitle,  String seasonName,  String pondName,  String farmName)  $default,) {final _that = this;
switch (_that) {
case _ProtocolCardData():
return $default(_that.id,_that.seasonId,_that.protocolType,_that.title,_that.summary,_that.versionNo,_that.status,_that.authorName,_that.submittedAt,_that.diseaseCaseId,_that.diseaseCaseTitle,_that.seasonName,_that.pondName,_that.farmName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seasonId, @JsonKey(unknownEnumValue: ProtocolType.unknown)  ProtocolType protocolType,  String title,  String? summary,  int versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus status,  String authorName,  DateTime? submittedAt,  String? diseaseCaseId,  String? diseaseCaseTitle,  String seasonName,  String pondName,  String farmName)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolCardData() when $default != null:
return $default(_that.id,_that.seasonId,_that.protocolType,_that.title,_that.summary,_that.versionNo,_that.status,_that.authorName,_that.submittedAt,_that.diseaseCaseId,_that.diseaseCaseTitle,_that.seasonName,_that.pondName,_that.farmName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolCardData implements ProtocolCardData {
  const _ProtocolCardData({required this.id, required this.seasonId, @JsonKey(unknownEnumValue: ProtocolType.unknown) required this.protocolType, required this.title, this.summary, required this.versionNo, @JsonKey(unknownEnumValue: ProtocolStatus.unknown) required this.status, required this.authorName, this.submittedAt, this.diseaseCaseId, this.diseaseCaseTitle, required this.seasonName, required this.pondName, required this.farmName});
  factory _ProtocolCardData.fromJson(Map<String, dynamic> json) => _$ProtocolCardDataFromJson(json);

@override final  String id;
@override final  String seasonId;
@override@JsonKey(unknownEnumValue: ProtocolType.unknown) final  ProtocolType protocolType;
@override final  String title;
@override final  String? summary;
@override final  int versionNo;
@override@JsonKey(unknownEnumValue: ProtocolStatus.unknown) final  ProtocolStatus status;
@override final  String authorName;
@override final  DateTime? submittedAt;
@override final  String? diseaseCaseId;
@override final  String? diseaseCaseTitle;
@override final  String seasonName;
@override final  String pondName;
@override final  String farmName;

/// Create a copy of ProtocolCardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolCardDataCopyWith<_ProtocolCardData> get copyWith => __$ProtocolCardDataCopyWithImpl<_ProtocolCardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolCardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolCardData&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonId, seasonId) || other.seasonId == seasonId)&&(identical(other.protocolType, protocolType) || other.protocolType == protocolType)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.diseaseCaseId, diseaseCaseId) || other.diseaseCaseId == diseaseCaseId)&&(identical(other.diseaseCaseTitle, diseaseCaseTitle) || other.diseaseCaseTitle == diseaseCaseTitle)&&(identical(other.seasonName, seasonName) || other.seasonName == seasonName)&&(identical(other.pondName, pondName) || other.pondName == pondName)&&(identical(other.farmName, farmName) || other.farmName == farmName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonId,protocolType,title,summary,versionNo,status,authorName,submittedAt,diseaseCaseId,diseaseCaseTitle,seasonName,pondName,farmName);

@override
String toString() {
  return 'ProtocolCardData(id: $id, seasonId: $seasonId, protocolType: $protocolType, title: $title, summary: $summary, versionNo: $versionNo, status: $status, authorName: $authorName, submittedAt: $submittedAt, diseaseCaseId: $diseaseCaseId, diseaseCaseTitle: $diseaseCaseTitle, seasonName: $seasonName, pondName: $pondName, farmName: $farmName)';
}


}

/// @nodoc
abstract mixin class _$ProtocolCardDataCopyWith<$Res> implements $ProtocolCardDataCopyWith<$Res> {
  factory _$ProtocolCardDataCopyWith(_ProtocolCardData value, $Res Function(_ProtocolCardData) _then) = __$ProtocolCardDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String seasonId,@JsonKey(unknownEnumValue: ProtocolType.unknown) ProtocolType protocolType, String title, String? summary, int versionNo,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus status, String authorName, DateTime? submittedAt, String? diseaseCaseId, String? diseaseCaseTitle, String seasonName, String pondName, String farmName
});




}
/// @nodoc
class __$ProtocolCardDataCopyWithImpl<$Res>
    implements _$ProtocolCardDataCopyWith<$Res> {
  __$ProtocolCardDataCopyWithImpl(this._self, this._then);

  final _ProtocolCardData _self;
  final $Res Function(_ProtocolCardData) _then;

/// Create a copy of ProtocolCardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonId = null,Object? protocolType = null,Object? title = null,Object? summary = freezed,Object? versionNo = null,Object? status = null,Object? authorName = null,Object? submittedAt = freezed,Object? diseaseCaseId = freezed,Object? diseaseCaseTitle = freezed,Object? seasonName = null,Object? pondName = null,Object? farmName = null,}) {
  return _then(_ProtocolCardData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonId: null == seasonId ? _self.seasonId : seasonId // ignore: cast_nullable_to_non_nullable
as String,protocolType: null == protocolType ? _self.protocolType : protocolType // ignore: cast_nullable_to_non_nullable
as ProtocolType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,versionNo: null == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,diseaseCaseId: freezed == diseaseCaseId ? _self.diseaseCaseId : diseaseCaseId // ignore: cast_nullable_to_non_nullable
as String?,diseaseCaseTitle: freezed == diseaseCaseTitle ? _self.diseaseCaseTitle : diseaseCaseTitle // ignore: cast_nullable_to_non_nullable
as String?,seasonName: null == seasonName ? _self.seasonName : seasonName // ignore: cast_nullable_to_non_nullable
as String,pondName: null == pondName ? _self.pondName : pondName // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProtocolHistory {

 String get id;@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus? get fromStatus;@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus get toStatus; String get changedByName; DateTime get changedAt; String? get reason;
/// Create a copy of ProtocolHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolHistoryCopyWith<ProtocolHistory> get copyWith => _$ProtocolHistoryCopyWithImpl<ProtocolHistory>(this as ProtocolHistory, _$identity);

  /// Serializes this ProtocolHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromStatus,toStatus,changedByName,changedAt,reason);

@override
String toString() {
  return 'ProtocolHistory(id: $id, fromStatus: $fromStatus, toStatus: $toStatus, changedByName: $changedByName, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ProtocolHistoryCopyWith<$Res>  {
  factory $ProtocolHistoryCopyWith(ProtocolHistory value, $Res Function(ProtocolHistory) _then) = _$ProtocolHistoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus? fromStatus,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus toStatus, String changedByName, DateTime changedAt, String? reason
});




}
/// @nodoc
class _$ProtocolHistoryCopyWithImpl<$Res>
    implements $ProtocolHistoryCopyWith<$Res> {
  _$ProtocolHistoryCopyWithImpl(this._self, this._then);

  final ProtocolHistory _self;
  final $Res Function(ProtocolHistory) _then;

/// Create a copy of ProtocolHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromStatus = freezed,Object? toStatus = null,Object? changedByName = null,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ProtocolStatus?,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,changedByName: null == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolHistory].
extension ProtocolHistoryPatterns on ProtocolHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolHistory value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus? fromStatus, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus toStatus,  String changedByName,  DateTime changedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolHistory() when $default != null:
return $default(_that.id,_that.fromStatus,_that.toStatus,_that.changedByName,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus? fromStatus, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus toStatus,  String changedByName,  DateTime changedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ProtocolHistory():
return $default(_that.id,_that.fromStatus,_that.toStatus,_that.changedByName,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus? fromStatus, @JsonKey(unknownEnumValue: ProtocolStatus.unknown)  ProtocolStatus toStatus,  String changedByName,  DateTime changedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolHistory() when $default != null:
return $default(_that.id,_that.fromStatus,_that.toStatus,_that.changedByName,_that.changedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolHistory implements ProtocolHistory {
  const _ProtocolHistory({required this.id, @JsonKey(unknownEnumValue: ProtocolStatus.unknown) this.fromStatus, @JsonKey(unknownEnumValue: ProtocolStatus.unknown) required this.toStatus, required this.changedByName, required this.changedAt, this.reason});
  factory _ProtocolHistory.fromJson(Map<String, dynamic> json) => _$ProtocolHistoryFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: ProtocolStatus.unknown) final  ProtocolStatus? fromStatus;
@override@JsonKey(unknownEnumValue: ProtocolStatus.unknown) final  ProtocolStatus toStatus;
@override final  String changedByName;
@override final  DateTime changedAt;
@override final  String? reason;

/// Create a copy of ProtocolHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolHistoryCopyWith<_ProtocolHistory> get copyWith => __$ProtocolHistoryCopyWithImpl<_ProtocolHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromStatus,toStatus,changedByName,changedAt,reason);

@override
String toString() {
  return 'ProtocolHistory(id: $id, fromStatus: $fromStatus, toStatus: $toStatus, changedByName: $changedByName, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ProtocolHistoryCopyWith<$Res> implements $ProtocolHistoryCopyWith<$Res> {
  factory _$ProtocolHistoryCopyWith(_ProtocolHistory value, $Res Function(_ProtocolHistory) _then) = __$ProtocolHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus? fromStatus,@JsonKey(unknownEnumValue: ProtocolStatus.unknown) ProtocolStatus toStatus, String changedByName, DateTime changedAt, String? reason
});




}
/// @nodoc
class __$ProtocolHistoryCopyWithImpl<$Res>
    implements _$ProtocolHistoryCopyWith<$Res> {
  __$ProtocolHistoryCopyWithImpl(this._self, this._then);

  final _ProtocolHistory _self;
  final $Res Function(_ProtocolHistory) _then;

/// Create a copy of ProtocolHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromStatus = freezed,Object? toStatus = null,Object? changedByName = null,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_ProtocolHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ProtocolStatus?,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ProtocolStatus,changedByName: null == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProtocolDayMarker {

 int get day; int get completed; int get planned; int get cancelled; int get issues;
/// Create a copy of ProtocolDayMarker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolDayMarkerCopyWith<ProtocolDayMarker> get copyWith => _$ProtocolDayMarkerCopyWithImpl<ProtocolDayMarker>(this as ProtocolDayMarker, _$identity);

  /// Serializes this ProtocolDayMarker to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolDayMarker&&(identical(other.day, day) || other.day == day)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.issues, issues) || other.issues == issues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,completed,planned,cancelled,issues);

@override
String toString() {
  return 'ProtocolDayMarker(day: $day, completed: $completed, planned: $planned, cancelled: $cancelled, issues: $issues)';
}


}

/// @nodoc
abstract mixin class $ProtocolDayMarkerCopyWith<$Res>  {
  factory $ProtocolDayMarkerCopyWith(ProtocolDayMarker value, $Res Function(ProtocolDayMarker) _then) = _$ProtocolDayMarkerCopyWithImpl;
@useResult
$Res call({
 int day, int completed, int planned, int cancelled, int issues
});




}
/// @nodoc
class _$ProtocolDayMarkerCopyWithImpl<$Res>
    implements $ProtocolDayMarkerCopyWith<$Res> {
  _$ProtocolDayMarkerCopyWithImpl(this._self, this._then);

  final ProtocolDayMarker _self;
  final $Res Function(ProtocolDayMarker) _then;

/// Create a copy of ProtocolDayMarker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? completed = null,Object? planned = null,Object? cancelled = null,Object? issues = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolDayMarker].
extension ProtocolDayMarkerPatterns on ProtocolDayMarker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolDayMarker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolDayMarker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolDayMarker value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolDayMarker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolDayMarker value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolDayMarker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  int completed,  int planned,  int cancelled,  int issues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolDayMarker() when $default != null:
return $default(_that.day,_that.completed,_that.planned,_that.cancelled,_that.issues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  int completed,  int planned,  int cancelled,  int issues)  $default,) {final _that = this;
switch (_that) {
case _ProtocolDayMarker():
return $default(_that.day,_that.completed,_that.planned,_that.cancelled,_that.issues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  int completed,  int planned,  int cancelled,  int issues)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolDayMarker() when $default != null:
return $default(_that.day,_that.completed,_that.planned,_that.cancelled,_that.issues);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolDayMarker implements ProtocolDayMarker {
  const _ProtocolDayMarker({required this.day, required this.completed, required this.planned, required this.cancelled, this.issues = 0});
  factory _ProtocolDayMarker.fromJson(Map<String, dynamic> json) => _$ProtocolDayMarkerFromJson(json);

@override final  int day;
@override final  int completed;
@override final  int planned;
@override final  int cancelled;
@override@JsonKey() final  int issues;

/// Create a copy of ProtocolDayMarker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolDayMarkerCopyWith<_ProtocolDayMarker> get copyWith => __$ProtocolDayMarkerCopyWithImpl<_ProtocolDayMarker>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolDayMarkerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolDayMarker&&(identical(other.day, day) || other.day == day)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.issues, issues) || other.issues == issues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,completed,planned,cancelled,issues);

@override
String toString() {
  return 'ProtocolDayMarker(day: $day, completed: $completed, planned: $planned, cancelled: $cancelled, issues: $issues)';
}


}

/// @nodoc
abstract mixin class _$ProtocolDayMarkerCopyWith<$Res> implements $ProtocolDayMarkerCopyWith<$Res> {
  factory _$ProtocolDayMarkerCopyWith(_ProtocolDayMarker value, $Res Function(_ProtocolDayMarker) _then) = __$ProtocolDayMarkerCopyWithImpl;
@override @useResult
$Res call({
 int day, int completed, int planned, int cancelled, int issues
});




}
/// @nodoc
class __$ProtocolDayMarkerCopyWithImpl<$Res>
    implements _$ProtocolDayMarkerCopyWith<$Res> {
  __$ProtocolDayMarkerCopyWithImpl(this._self, this._then);

  final _ProtocolDayMarker _self;
  final $Res Function(_ProtocolDayMarker) _then;

/// Create a copy of ProtocolDayMarker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? completed = null,Object? planned = null,Object? cancelled = null,Object? issues = null,}) {
  return _then(_ProtocolDayMarker(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProtocolMaterialProfile {

 String? get regulatoryType; String? get registrationNumber; String? get ingredientsText; bool? get containsAntibiotic; String? get usageInstructions;@JsonKey(fromJson: _optionalDecimalString) String? get withdrawalDays; List<String> get evidenceUrls; String? get complianceStatus; String? get checkedBy; DateTime? get checkedAt; String? get reviewNote;
/// Create a copy of ProtocolMaterialProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolMaterialProfileCopyWith<ProtocolMaterialProfile> get copyWith => _$ProtocolMaterialProfileCopyWithImpl<ProtocolMaterialProfile>(this as ProtocolMaterialProfile, _$identity);

  /// Serializes this ProtocolMaterialProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolMaterialProfile&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&const DeepCollectionEquality().equals(other.evidenceUrls, evidenceUrls)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,regulatoryType,registrationNumber,ingredientsText,containsAntibiotic,usageInstructions,withdrawalDays,const DeepCollectionEquality().hash(evidenceUrls),complianceStatus,checkedBy,checkedAt,reviewNote);

@override
String toString() {
  return 'ProtocolMaterialProfile(regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, containsAntibiotic: $containsAntibiotic, usageInstructions: $usageInstructions, withdrawalDays: $withdrawalDays, evidenceUrls: $evidenceUrls, complianceStatus: $complianceStatus, checkedBy: $checkedBy, checkedAt: $checkedAt, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class $ProtocolMaterialProfileCopyWith<$Res>  {
  factory $ProtocolMaterialProfileCopyWith(ProtocolMaterialProfile value, $Res Function(ProtocolMaterialProfile) _then) = _$ProtocolMaterialProfileCopyWithImpl;
@useResult
$Res call({
 String? regulatoryType, String? registrationNumber, String? ingredientsText, bool? containsAntibiotic, String? usageInstructions,@JsonKey(fromJson: _optionalDecimalString) String? withdrawalDays, List<String> evidenceUrls, String? complianceStatus, String? checkedBy, DateTime? checkedAt, String? reviewNote
});




}
/// @nodoc
class _$ProtocolMaterialProfileCopyWithImpl<$Res>
    implements $ProtocolMaterialProfileCopyWith<$Res> {
  _$ProtocolMaterialProfileCopyWithImpl(this._self, this._then);

  final ProtocolMaterialProfile _self;
  final $Res Function(ProtocolMaterialProfile) _then;

/// Create a copy of ProtocolMaterialProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? regulatoryType = freezed,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? containsAntibiotic = freezed,Object? usageInstructions = freezed,Object? withdrawalDays = freezed,Object? evidenceUrls = null,Object? complianceStatus = freezed,Object? checkedBy = freezed,Object? checkedAt = freezed,Object? reviewNote = freezed,}) {
  return _then(_self.copyWith(
regulatoryType: freezed == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as String?,evidenceUrls: null == evidenceUrls ? _self.evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,complianceStatus: freezed == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String?,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolMaterialProfile].
extension ProtocolMaterialProfilePatterns on ProtocolMaterialProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolMaterialProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolMaterialProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolMaterialProfile value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolMaterialProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions, @JsonKey(fromJson: _optionalDecimalString)  String? withdrawalDays,  List<String> evidenceUrls,  String? complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolMaterialProfile() when $default != null:
return $default(_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.containsAntibiotic,_that.usageInstructions,_that.withdrawalDays,_that.evidenceUrls,_that.complianceStatus,_that.checkedBy,_that.checkedAt,_that.reviewNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions, @JsonKey(fromJson: _optionalDecimalString)  String? withdrawalDays,  List<String> evidenceUrls,  String? complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialProfile():
return $default(_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.containsAntibiotic,_that.usageInstructions,_that.withdrawalDays,_that.evidenceUrls,_that.complianceStatus,_that.checkedBy,_that.checkedAt,_that.reviewNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions, @JsonKey(fromJson: _optionalDecimalString)  String? withdrawalDays,  List<String> evidenceUrls,  String? complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialProfile() when $default != null:
return $default(_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.containsAntibiotic,_that.usageInstructions,_that.withdrawalDays,_that.evidenceUrls,_that.complianceStatus,_that.checkedBy,_that.checkedAt,_that.reviewNote);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolMaterialProfile implements ProtocolMaterialProfile {
  const _ProtocolMaterialProfile({this.regulatoryType, this.registrationNumber, this.ingredientsText, this.containsAntibiotic, this.usageInstructions, @JsonKey(fromJson: _optionalDecimalString) this.withdrawalDays, final  List<String> evidenceUrls = const [], this.complianceStatus, this.checkedBy, this.checkedAt, this.reviewNote}): _evidenceUrls = evidenceUrls;
  factory _ProtocolMaterialProfile.fromJson(Map<String, dynamic> json) => _$ProtocolMaterialProfileFromJson(json);

@override final  String? regulatoryType;
@override final  String? registrationNumber;
@override final  String? ingredientsText;
@override final  bool? containsAntibiotic;
@override final  String? usageInstructions;
@override@JsonKey(fromJson: _optionalDecimalString) final  String? withdrawalDays;
 final  List<String> _evidenceUrls;
@override@JsonKey() List<String> get evidenceUrls {
  if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceUrls);
}

@override final  String? complianceStatus;
@override final  String? checkedBy;
@override final  DateTime? checkedAt;
@override final  String? reviewNote;

/// Create a copy of ProtocolMaterialProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolMaterialProfileCopyWith<_ProtocolMaterialProfile> get copyWith => __$ProtocolMaterialProfileCopyWithImpl<_ProtocolMaterialProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolMaterialProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolMaterialProfile&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&const DeepCollectionEquality().equals(other._evidenceUrls, _evidenceUrls)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,regulatoryType,registrationNumber,ingredientsText,containsAntibiotic,usageInstructions,withdrawalDays,const DeepCollectionEquality().hash(_evidenceUrls),complianceStatus,checkedBy,checkedAt,reviewNote);

@override
String toString() {
  return 'ProtocolMaterialProfile(regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, containsAntibiotic: $containsAntibiotic, usageInstructions: $usageInstructions, withdrawalDays: $withdrawalDays, evidenceUrls: $evidenceUrls, complianceStatus: $complianceStatus, checkedBy: $checkedBy, checkedAt: $checkedAt, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class _$ProtocolMaterialProfileCopyWith<$Res> implements $ProtocolMaterialProfileCopyWith<$Res> {
  factory _$ProtocolMaterialProfileCopyWith(_ProtocolMaterialProfile value, $Res Function(_ProtocolMaterialProfile) _then) = __$ProtocolMaterialProfileCopyWithImpl;
@override @useResult
$Res call({
 String? regulatoryType, String? registrationNumber, String? ingredientsText, bool? containsAntibiotic, String? usageInstructions,@JsonKey(fromJson: _optionalDecimalString) String? withdrawalDays, List<String> evidenceUrls, String? complianceStatus, String? checkedBy, DateTime? checkedAt, String? reviewNote
});




}
/// @nodoc
class __$ProtocolMaterialProfileCopyWithImpl<$Res>
    implements _$ProtocolMaterialProfileCopyWith<$Res> {
  __$ProtocolMaterialProfileCopyWithImpl(this._self, this._then);

  final _ProtocolMaterialProfile _self;
  final $Res Function(_ProtocolMaterialProfile) _then;

/// Create a copy of ProtocolMaterialProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? regulatoryType = freezed,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? containsAntibiotic = freezed,Object? usageInstructions = freezed,Object? withdrawalDays = freezed,Object? evidenceUrls = null,Object? complianceStatus = freezed,Object? checkedBy = freezed,Object? checkedAt = freezed,Object? reviewNote = freezed,}) {
  return _then(_ProtocolMaterialProfile(
regulatoryType: freezed == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as String?,evidenceUrls: null == evidenceUrls ? _self._evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,complianceStatus: freezed == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String?,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProtocolManufacturer {

 String get name; String? get id; String? get address; String? get phone;
/// Create a copy of ProtocolManufacturer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolManufacturerCopyWith<ProtocolManufacturer> get copyWith => _$ProtocolManufacturerCopyWithImpl<ProtocolManufacturer>(this as ProtocolManufacturer, _$identity);

  /// Serializes this ProtocolManufacturer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolManufacturer&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,id,address,phone);

@override
String toString() {
  return 'ProtocolManufacturer(name: $name, id: $id, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ProtocolManufacturerCopyWith<$Res>  {
  factory $ProtocolManufacturerCopyWith(ProtocolManufacturer value, $Res Function(ProtocolManufacturer) _then) = _$ProtocolManufacturerCopyWithImpl;
@useResult
$Res call({
 String name, String? id, String? address, String? phone
});




}
/// @nodoc
class _$ProtocolManufacturerCopyWithImpl<$Res>
    implements $ProtocolManufacturerCopyWith<$Res> {
  _$ProtocolManufacturerCopyWithImpl(this._self, this._then);

  final ProtocolManufacturer _self;
  final $Res Function(ProtocolManufacturer) _then;

/// Create a copy of ProtocolManufacturer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? id = freezed,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolManufacturer].
extension ProtocolManufacturerPatterns on ProtocolManufacturer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolManufacturer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolManufacturer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolManufacturer value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolManufacturer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolManufacturer value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolManufacturer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? id,  String? address,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolManufacturer() when $default != null:
return $default(_that.name,_that.id,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? id,  String? address,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _ProtocolManufacturer():
return $default(_that.name,_that.id,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? id,  String? address,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolManufacturer() when $default != null:
return $default(_that.name,_that.id,_that.address,_that.phone);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolManufacturer implements ProtocolManufacturer {
  const _ProtocolManufacturer({required this.name, this.id, this.address, this.phone});
  factory _ProtocolManufacturer.fromJson(Map<String, dynamic> json) => _$ProtocolManufacturerFromJson(json);

@override final  String name;
@override final  String? id;
@override final  String? address;
@override final  String? phone;

/// Create a copy of ProtocolManufacturer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolManufacturerCopyWith<_ProtocolManufacturer> get copyWith => __$ProtocolManufacturerCopyWithImpl<_ProtocolManufacturer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolManufacturerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolManufacturer&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,id,address,phone);

@override
String toString() {
  return 'ProtocolManufacturer(name: $name, id: $id, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ProtocolManufacturerCopyWith<$Res> implements $ProtocolManufacturerCopyWith<$Res> {
  factory _$ProtocolManufacturerCopyWith(_ProtocolManufacturer value, $Res Function(_ProtocolManufacturer) _then) = __$ProtocolManufacturerCopyWithImpl;
@override @useResult
$Res call({
 String name, String? id, String? address, String? phone
});




}
/// @nodoc
class __$ProtocolManufacturerCopyWithImpl<$Res>
    implements _$ProtocolManufacturerCopyWith<$Res> {
  __$ProtocolManufacturerCopyWithImpl(this._self, this._then);

  final _ProtocolManufacturer _self;
  final $Res Function(_ProtocolManufacturer) _then;

/// Create a copy of ProtocolManufacturer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? id = freezed,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_ProtocolManufacturer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProtocolMaterialSnapshot {

 String get name; String get category; String get unit; String? get description; String? get recommendationReason; String? get manufacturerId; ProtocolManufacturer? get manufacturer; ProtocolMaterialProfile? get productCompliance; String? get conversionUnit;@JsonKey(fromJson: _optionalDecimalString) String? get conversionQuantity;
/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<ProtocolMaterialSnapshot> get copyWith => _$ProtocolMaterialSnapshotCopyWithImpl<ProtocolMaterialSnapshot>(this as ProtocolMaterialSnapshot, _$identity);

  /// Serializes this ProtocolMaterialSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolMaterialSnapshot&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.description, description) || other.description == description)&&(identical(other.recommendationReason, recommendationReason) || other.recommendationReason == recommendationReason)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.productCompliance, productCompliance) || other.productCompliance == productCompliance)&&(identical(other.conversionUnit, conversionUnit) || other.conversionUnit == conversionUnit)&&(identical(other.conversionQuantity, conversionQuantity) || other.conversionQuantity == conversionQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,unit,description,recommendationReason,manufacturerId,manufacturer,productCompliance,conversionUnit,conversionQuantity);

@override
String toString() {
  return 'ProtocolMaterialSnapshot(name: $name, category: $category, unit: $unit, description: $description, recommendationReason: $recommendationReason, manufacturerId: $manufacturerId, manufacturer: $manufacturer, productCompliance: $productCompliance, conversionUnit: $conversionUnit, conversionQuantity: $conversionQuantity)';
}


}

/// @nodoc
abstract mixin class $ProtocolMaterialSnapshotCopyWith<$Res>  {
  factory $ProtocolMaterialSnapshotCopyWith(ProtocolMaterialSnapshot value, $Res Function(ProtocolMaterialSnapshot) _then) = _$ProtocolMaterialSnapshotCopyWithImpl;
@useResult
$Res call({
 String name, String category, String unit, String? description, String? recommendationReason, String? manufacturerId, ProtocolManufacturer? manufacturer, ProtocolMaterialProfile? productCompliance, String? conversionUnit,@JsonKey(fromJson: _optionalDecimalString) String? conversionQuantity
});


$ProtocolManufacturerCopyWith<$Res>? get manufacturer;$ProtocolMaterialProfileCopyWith<$Res>? get productCompliance;

}
/// @nodoc
class _$ProtocolMaterialSnapshotCopyWithImpl<$Res>
    implements $ProtocolMaterialSnapshotCopyWith<$Res> {
  _$ProtocolMaterialSnapshotCopyWithImpl(this._self, this._then);

  final ProtocolMaterialSnapshot _self;
  final $Res Function(ProtocolMaterialSnapshot) _then;

/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? unit = null,Object? description = freezed,Object? recommendationReason = freezed,Object? manufacturerId = freezed,Object? manufacturer = freezed,Object? productCompliance = freezed,Object? conversionUnit = freezed,Object? conversionQuantity = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,recommendationReason: freezed == recommendationReason ? _self.recommendationReason : recommendationReason // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as ProtocolManufacturer?,productCompliance: freezed == productCompliance ? _self.productCompliance : productCompliance // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialProfile?,conversionUnit: freezed == conversionUnit ? _self.conversionUnit : conversionUnit // ignore: cast_nullable_to_non_nullable
as String?,conversionQuantity: freezed == conversionQuantity ? _self.conversionQuantity : conversionQuantity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolManufacturerCopyWith<$Res>? get manufacturer {
    if (_self.manufacturer == null) {
    return null;
  }

  return $ProtocolManufacturerCopyWith<$Res>(_self.manufacturer!, (value) {
    return _then(_self.copyWith(manufacturer: value));
  });
}/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialProfileCopyWith<$Res>? get productCompliance {
    if (_self.productCompliance == null) {
    return null;
  }

  return $ProtocolMaterialProfileCopyWith<$Res>(_self.productCompliance!, (value) {
    return _then(_self.copyWith(productCompliance: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProtocolMaterialSnapshot].
extension ProtocolMaterialSnapshotPatterns on ProtocolMaterialSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolMaterialSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolMaterialSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolMaterialSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String category,  String unit,  String? description,  String? recommendationReason,  String? manufacturerId,  ProtocolManufacturer? manufacturer,  ProtocolMaterialProfile? productCompliance,  String? conversionUnit, @JsonKey(fromJson: _optionalDecimalString)  String? conversionQuantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot() when $default != null:
return $default(_that.name,_that.category,_that.unit,_that.description,_that.recommendationReason,_that.manufacturerId,_that.manufacturer,_that.productCompliance,_that.conversionUnit,_that.conversionQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String category,  String unit,  String? description,  String? recommendationReason,  String? manufacturerId,  ProtocolManufacturer? manufacturer,  ProtocolMaterialProfile? productCompliance,  String? conversionUnit, @JsonKey(fromJson: _optionalDecimalString)  String? conversionQuantity)  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot():
return $default(_that.name,_that.category,_that.unit,_that.description,_that.recommendationReason,_that.manufacturerId,_that.manufacturer,_that.productCompliance,_that.conversionUnit,_that.conversionQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String category,  String unit,  String? description,  String? recommendationReason,  String? manufacturerId,  ProtocolManufacturer? manufacturer,  ProtocolMaterialProfile? productCompliance,  String? conversionUnit, @JsonKey(fromJson: _optionalDecimalString)  String? conversionQuantity)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialSnapshot() when $default != null:
return $default(_that.name,_that.category,_that.unit,_that.description,_that.recommendationReason,_that.manufacturerId,_that.manufacturer,_that.productCompliance,_that.conversionUnit,_that.conversionQuantity);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolMaterialSnapshot implements ProtocolMaterialSnapshot {
  const _ProtocolMaterialSnapshot({required this.name, required this.category, required this.unit, this.description, this.recommendationReason, this.manufacturerId, this.manufacturer, this.productCompliance, this.conversionUnit, @JsonKey(fromJson: _optionalDecimalString) this.conversionQuantity});
  factory _ProtocolMaterialSnapshot.fromJson(Map<String, dynamic> json) => _$ProtocolMaterialSnapshotFromJson(json);

@override final  String name;
@override final  String category;
@override final  String unit;
@override final  String? description;
@override final  String? recommendationReason;
@override final  String? manufacturerId;
@override final  ProtocolManufacturer? manufacturer;
@override final  ProtocolMaterialProfile? productCompliance;
@override final  String? conversionUnit;
@override@JsonKey(fromJson: _optionalDecimalString) final  String? conversionQuantity;

/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolMaterialSnapshotCopyWith<_ProtocolMaterialSnapshot> get copyWith => __$ProtocolMaterialSnapshotCopyWithImpl<_ProtocolMaterialSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolMaterialSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolMaterialSnapshot&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.description, description) || other.description == description)&&(identical(other.recommendationReason, recommendationReason) || other.recommendationReason == recommendationReason)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.productCompliance, productCompliance) || other.productCompliance == productCompliance)&&(identical(other.conversionUnit, conversionUnit) || other.conversionUnit == conversionUnit)&&(identical(other.conversionQuantity, conversionQuantity) || other.conversionQuantity == conversionQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,unit,description,recommendationReason,manufacturerId,manufacturer,productCompliance,conversionUnit,conversionQuantity);

@override
String toString() {
  return 'ProtocolMaterialSnapshot(name: $name, category: $category, unit: $unit, description: $description, recommendationReason: $recommendationReason, manufacturerId: $manufacturerId, manufacturer: $manufacturer, productCompliance: $productCompliance, conversionUnit: $conversionUnit, conversionQuantity: $conversionQuantity)';
}


}

/// @nodoc
abstract mixin class _$ProtocolMaterialSnapshotCopyWith<$Res> implements $ProtocolMaterialSnapshotCopyWith<$Res> {
  factory _$ProtocolMaterialSnapshotCopyWith(_ProtocolMaterialSnapshot value, $Res Function(_ProtocolMaterialSnapshot) _then) = __$ProtocolMaterialSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String name, String category, String unit, String? description, String? recommendationReason, String? manufacturerId, ProtocolManufacturer? manufacturer, ProtocolMaterialProfile? productCompliance, String? conversionUnit,@JsonKey(fromJson: _optionalDecimalString) String? conversionQuantity
});


@override $ProtocolManufacturerCopyWith<$Res>? get manufacturer;@override $ProtocolMaterialProfileCopyWith<$Res>? get productCompliance;

}
/// @nodoc
class __$ProtocolMaterialSnapshotCopyWithImpl<$Res>
    implements _$ProtocolMaterialSnapshotCopyWith<$Res> {
  __$ProtocolMaterialSnapshotCopyWithImpl(this._self, this._then);

  final _ProtocolMaterialSnapshot _self;
  final $Res Function(_ProtocolMaterialSnapshot) _then;

/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? unit = null,Object? description = freezed,Object? recommendationReason = freezed,Object? manufacturerId = freezed,Object? manufacturer = freezed,Object? productCompliance = freezed,Object? conversionUnit = freezed,Object? conversionQuantity = freezed,}) {
  return _then(_ProtocolMaterialSnapshot(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,recommendationReason: freezed == recommendationReason ? _self.recommendationReason : recommendationReason // ignore: cast_nullable_to_non_nullable
as String?,manufacturerId: freezed == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as ProtocolManufacturer?,productCompliance: freezed == productCompliance ? _self.productCompliance : productCompliance // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialProfile?,conversionUnit: freezed == conversionUnit ? _self.conversionUnit : conversionUnit // ignore: cast_nullable_to_non_nullable
as String?,conversionQuantity: freezed == conversionQuantity ? _self.conversionQuantity : conversionQuantity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolManufacturerCopyWith<$Res>? get manufacturer {
    if (_self.manufacturer == null) {
    return null;
  }

  return $ProtocolManufacturerCopyWith<$Res>(_self.manufacturer!, (value) {
    return _then(_self.copyWith(manufacturer: value));
  });
}/// Create a copy of ProtocolMaterialSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialProfileCopyWith<$Res>? get productCompliance {
    if (_self.productCompliance == null) {
    return null;
  }

  return $ProtocolMaterialProfileCopyWith<$Res>(_self.productCompliance!, (value) {
    return _then(_self.copyWith(productCompliance: value));
  });
}
}


/// @nodoc
mixin _$ProtocolMaterialReview {

 String get itemId; String get name; String? get productId; String get operationType; String get doseBasis; String get doseValue; String get doseUnit; String get dailyDoseIncrement; int get firstDay; int get lastDay; int get repeatIntervalDays; int get recurrenceAnchorDay; int get doseAnchorDay; int? get mealNumber; String? get plannedTime; String? get recommendedManufacturerId; bool get requiresResolution; String? get resolutionMessage;@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? get proposed;@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? get catalog;
/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolMaterialReviewCopyWith<ProtocolMaterialReview> get copyWith => _$ProtocolMaterialReviewCopyWithImpl<ProtocolMaterialReview>(this as ProtocolMaterialReview, _$identity);

  /// Serializes this ProtocolMaterialReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolMaterialReview&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.doseBasis, doseBasis) || other.doseBasis == doseBasis)&&(identical(other.doseValue, doseValue) || other.doseValue == doseValue)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.dailyDoseIncrement, dailyDoseIncrement) || other.dailyDoseIncrement == dailyDoseIncrement)&&(identical(other.firstDay, firstDay) || other.firstDay == firstDay)&&(identical(other.lastDay, lastDay) || other.lastDay == lastDay)&&(identical(other.repeatIntervalDays, repeatIntervalDays) || other.repeatIntervalDays == repeatIntervalDays)&&(identical(other.recurrenceAnchorDay, recurrenceAnchorDay) || other.recurrenceAnchorDay == recurrenceAnchorDay)&&(identical(other.doseAnchorDay, doseAnchorDay) || other.doseAnchorDay == doseAnchorDay)&&(identical(other.mealNumber, mealNumber) || other.mealNumber == mealNumber)&&(identical(other.plannedTime, plannedTime) || other.plannedTime == plannedTime)&&(identical(other.recommendedManufacturerId, recommendedManufacturerId) || other.recommendedManufacturerId == recommendedManufacturerId)&&(identical(other.requiresResolution, requiresResolution) || other.requiresResolution == requiresResolution)&&(identical(other.resolutionMessage, resolutionMessage) || other.resolutionMessage == resolutionMessage)&&(identical(other.proposed, proposed) || other.proposed == proposed)&&(identical(other.catalog, catalog) || other.catalog == catalog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,name,productId,operationType,doseBasis,doseValue,doseUnit,dailyDoseIncrement,firstDay,lastDay,repeatIntervalDays,recurrenceAnchorDay,doseAnchorDay,mealNumber,plannedTime,recommendedManufacturerId,requiresResolution,resolutionMessage,proposed,catalog]);

@override
String toString() {
  return 'ProtocolMaterialReview(itemId: $itemId, name: $name, productId: $productId, operationType: $operationType, doseBasis: $doseBasis, doseValue: $doseValue, doseUnit: $doseUnit, dailyDoseIncrement: $dailyDoseIncrement, firstDay: $firstDay, lastDay: $lastDay, repeatIntervalDays: $repeatIntervalDays, recurrenceAnchorDay: $recurrenceAnchorDay, doseAnchorDay: $doseAnchorDay, mealNumber: $mealNumber, plannedTime: $plannedTime, recommendedManufacturerId: $recommendedManufacturerId, requiresResolution: $requiresResolution, resolutionMessage: $resolutionMessage, proposed: $proposed, catalog: $catalog)';
}


}

/// @nodoc
abstract mixin class $ProtocolMaterialReviewCopyWith<$Res>  {
  factory $ProtocolMaterialReviewCopyWith(ProtocolMaterialReview value, $Res Function(ProtocolMaterialReview) _then) = _$ProtocolMaterialReviewCopyWithImpl;
@useResult
$Res call({
 String itemId, String name, String? productId, String operationType, String doseBasis, String doseValue, String doseUnit, String dailyDoseIncrement, int firstDay, int lastDay, int repeatIntervalDays, int recurrenceAnchorDay, int doseAnchorDay, int? mealNumber, String? plannedTime, String? recommendedManufacturerId, bool requiresResolution, String? resolutionMessage,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? proposed,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? catalog
});


$ProtocolMaterialSnapshotCopyWith<$Res>? get proposed;$ProtocolMaterialSnapshotCopyWith<$Res>? get catalog;

}
/// @nodoc
class _$ProtocolMaterialReviewCopyWithImpl<$Res>
    implements $ProtocolMaterialReviewCopyWith<$Res> {
  _$ProtocolMaterialReviewCopyWithImpl(this._self, this._then);

  final ProtocolMaterialReview _self;
  final $Res Function(ProtocolMaterialReview) _then;

/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? name = null,Object? productId = freezed,Object? operationType = null,Object? doseBasis = null,Object? doseValue = null,Object? doseUnit = null,Object? dailyDoseIncrement = null,Object? firstDay = null,Object? lastDay = null,Object? repeatIntervalDays = null,Object? recurrenceAnchorDay = null,Object? doseAnchorDay = null,Object? mealNumber = freezed,Object? plannedTime = freezed,Object? recommendedManufacturerId = freezed,Object? requiresResolution = null,Object? resolutionMessage = freezed,Object? proposed = freezed,Object? catalog = freezed,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,doseBasis: null == doseBasis ? _self.doseBasis : doseBasis // ignore: cast_nullable_to_non_nullable
as String,doseValue: null == doseValue ? _self.doseValue : doseValue // ignore: cast_nullable_to_non_nullable
as String,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,dailyDoseIncrement: null == dailyDoseIncrement ? _self.dailyDoseIncrement : dailyDoseIncrement // ignore: cast_nullable_to_non_nullable
as String,firstDay: null == firstDay ? _self.firstDay : firstDay // ignore: cast_nullable_to_non_nullable
as int,lastDay: null == lastDay ? _self.lastDay : lastDay // ignore: cast_nullable_to_non_nullable
as int,repeatIntervalDays: null == repeatIntervalDays ? _self.repeatIntervalDays : repeatIntervalDays // ignore: cast_nullable_to_non_nullable
as int,recurrenceAnchorDay: null == recurrenceAnchorDay ? _self.recurrenceAnchorDay : recurrenceAnchorDay // ignore: cast_nullable_to_non_nullable
as int,doseAnchorDay: null == doseAnchorDay ? _self.doseAnchorDay : doseAnchorDay // ignore: cast_nullable_to_non_nullable
as int,mealNumber: freezed == mealNumber ? _self.mealNumber : mealNumber // ignore: cast_nullable_to_non_nullable
as int?,plannedTime: freezed == plannedTime ? _self.plannedTime : plannedTime // ignore: cast_nullable_to_non_nullable
as String?,recommendedManufacturerId: freezed == recommendedManufacturerId ? _self.recommendedManufacturerId : recommendedManufacturerId // ignore: cast_nullable_to_non_nullable
as String?,requiresResolution: null == requiresResolution ? _self.requiresResolution : requiresResolution // ignore: cast_nullable_to_non_nullable
as bool,resolutionMessage: freezed == resolutionMessage ? _self.resolutionMessage : resolutionMessage // ignore: cast_nullable_to_non_nullable
as String?,proposed: freezed == proposed ? _self.proposed : proposed // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,
  ));
}
/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get proposed {
    if (_self.proposed == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.proposed!, (value) {
    return _then(_self.copyWith(proposed: value));
  });
}/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProtocolMaterialReview].
extension ProtocolMaterialReviewPatterns on ProtocolMaterialReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolMaterialReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolMaterialReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolMaterialReview value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolMaterialReview value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String name,  String? productId,  String operationType,  String doseBasis,  String doseValue,  String doseUnit,  String dailyDoseIncrement,  int firstDay,  int lastDay,  int repeatIntervalDays,  int recurrenceAnchorDay,  int doseAnchorDay,  int? mealNumber,  String? plannedTime,  String? recommendedManufacturerId,  bool requiresResolution,  String? resolutionMessage, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? proposed, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? catalog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolMaterialReview() when $default != null:
return $default(_that.itemId,_that.name,_that.productId,_that.operationType,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.dailyDoseIncrement,_that.firstDay,_that.lastDay,_that.repeatIntervalDays,_that.recurrenceAnchorDay,_that.doseAnchorDay,_that.mealNumber,_that.plannedTime,_that.recommendedManufacturerId,_that.requiresResolution,_that.resolutionMessage,_that.proposed,_that.catalog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String name,  String? productId,  String operationType,  String doseBasis,  String doseValue,  String doseUnit,  String dailyDoseIncrement,  int firstDay,  int lastDay,  int repeatIntervalDays,  int recurrenceAnchorDay,  int doseAnchorDay,  int? mealNumber,  String? plannedTime,  String? recommendedManufacturerId,  bool requiresResolution,  String? resolutionMessage, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? proposed, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? catalog)  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialReview():
return $default(_that.itemId,_that.name,_that.productId,_that.operationType,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.dailyDoseIncrement,_that.firstDay,_that.lastDay,_that.repeatIntervalDays,_that.recurrenceAnchorDay,_that.doseAnchorDay,_that.mealNumber,_that.plannedTime,_that.recommendedManufacturerId,_that.requiresResolution,_that.resolutionMessage,_that.proposed,_that.catalog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String name,  String? productId,  String operationType,  String doseBasis,  String doseValue,  String doseUnit,  String dailyDoseIncrement,  int firstDay,  int lastDay,  int repeatIntervalDays,  int recurrenceAnchorDay,  int doseAnchorDay,  int? mealNumber,  String? plannedTime,  String? recommendedManufacturerId,  bool requiresResolution,  String? resolutionMessage, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? proposed, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? catalog)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialReview() when $default != null:
return $default(_that.itemId,_that.name,_that.productId,_that.operationType,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.dailyDoseIncrement,_that.firstDay,_that.lastDay,_that.repeatIntervalDays,_that.recurrenceAnchorDay,_that.doseAnchorDay,_that.mealNumber,_that.plannedTime,_that.recommendedManufacturerId,_that.requiresResolution,_that.resolutionMessage,_that.proposed,_that.catalog);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolMaterialReview implements ProtocolMaterialReview {
  const _ProtocolMaterialReview({required this.itemId, required this.name, this.productId, required this.operationType, required this.doseBasis, required this.doseValue, required this.doseUnit, required this.dailyDoseIncrement, required this.firstDay, required this.lastDay, required this.repeatIntervalDays, required this.recurrenceAnchorDay, required this.doseAnchorDay, this.mealNumber, this.plannedTime, this.recommendedManufacturerId, required this.requiresResolution, this.resolutionMessage, @JsonKey(fromJson: _materialFromJson) this.proposed, @JsonKey(fromJson: _materialFromJson) this.catalog});
  factory _ProtocolMaterialReview.fromJson(Map<String, dynamic> json) => _$ProtocolMaterialReviewFromJson(json);

@override final  String itemId;
@override final  String name;
@override final  String? productId;
@override final  String operationType;
@override final  String doseBasis;
@override final  String doseValue;
@override final  String doseUnit;
@override final  String dailyDoseIncrement;
@override final  int firstDay;
@override final  int lastDay;
@override final  int repeatIntervalDays;
@override final  int recurrenceAnchorDay;
@override final  int doseAnchorDay;
@override final  int? mealNumber;
@override final  String? plannedTime;
@override final  String? recommendedManufacturerId;
@override final  bool requiresResolution;
@override final  String? resolutionMessage;
@override@JsonKey(fromJson: _materialFromJson) final  ProtocolMaterialSnapshot? proposed;
@override@JsonKey(fromJson: _materialFromJson) final  ProtocolMaterialSnapshot? catalog;

/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolMaterialReviewCopyWith<_ProtocolMaterialReview> get copyWith => __$ProtocolMaterialReviewCopyWithImpl<_ProtocolMaterialReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolMaterialReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolMaterialReview&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.doseBasis, doseBasis) || other.doseBasis == doseBasis)&&(identical(other.doseValue, doseValue) || other.doseValue == doseValue)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.dailyDoseIncrement, dailyDoseIncrement) || other.dailyDoseIncrement == dailyDoseIncrement)&&(identical(other.firstDay, firstDay) || other.firstDay == firstDay)&&(identical(other.lastDay, lastDay) || other.lastDay == lastDay)&&(identical(other.repeatIntervalDays, repeatIntervalDays) || other.repeatIntervalDays == repeatIntervalDays)&&(identical(other.recurrenceAnchorDay, recurrenceAnchorDay) || other.recurrenceAnchorDay == recurrenceAnchorDay)&&(identical(other.doseAnchorDay, doseAnchorDay) || other.doseAnchorDay == doseAnchorDay)&&(identical(other.mealNumber, mealNumber) || other.mealNumber == mealNumber)&&(identical(other.plannedTime, plannedTime) || other.plannedTime == plannedTime)&&(identical(other.recommendedManufacturerId, recommendedManufacturerId) || other.recommendedManufacturerId == recommendedManufacturerId)&&(identical(other.requiresResolution, requiresResolution) || other.requiresResolution == requiresResolution)&&(identical(other.resolutionMessage, resolutionMessage) || other.resolutionMessage == resolutionMessage)&&(identical(other.proposed, proposed) || other.proposed == proposed)&&(identical(other.catalog, catalog) || other.catalog == catalog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,name,productId,operationType,doseBasis,doseValue,doseUnit,dailyDoseIncrement,firstDay,lastDay,repeatIntervalDays,recurrenceAnchorDay,doseAnchorDay,mealNumber,plannedTime,recommendedManufacturerId,requiresResolution,resolutionMessage,proposed,catalog]);

@override
String toString() {
  return 'ProtocolMaterialReview(itemId: $itemId, name: $name, productId: $productId, operationType: $operationType, doseBasis: $doseBasis, doseValue: $doseValue, doseUnit: $doseUnit, dailyDoseIncrement: $dailyDoseIncrement, firstDay: $firstDay, lastDay: $lastDay, repeatIntervalDays: $repeatIntervalDays, recurrenceAnchorDay: $recurrenceAnchorDay, doseAnchorDay: $doseAnchorDay, mealNumber: $mealNumber, plannedTime: $plannedTime, recommendedManufacturerId: $recommendedManufacturerId, requiresResolution: $requiresResolution, resolutionMessage: $resolutionMessage, proposed: $proposed, catalog: $catalog)';
}


}

/// @nodoc
abstract mixin class _$ProtocolMaterialReviewCopyWith<$Res> implements $ProtocolMaterialReviewCopyWith<$Res> {
  factory _$ProtocolMaterialReviewCopyWith(_ProtocolMaterialReview value, $Res Function(_ProtocolMaterialReview) _then) = __$ProtocolMaterialReviewCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String name, String? productId, String operationType, String doseBasis, String doseValue, String doseUnit, String dailyDoseIncrement, int firstDay, int lastDay, int repeatIntervalDays, int recurrenceAnchorDay, int doseAnchorDay, int? mealNumber, String? plannedTime, String? recommendedManufacturerId, bool requiresResolution, String? resolutionMessage,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? proposed,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? catalog
});


@override $ProtocolMaterialSnapshotCopyWith<$Res>? get proposed;@override $ProtocolMaterialSnapshotCopyWith<$Res>? get catalog;

}
/// @nodoc
class __$ProtocolMaterialReviewCopyWithImpl<$Res>
    implements _$ProtocolMaterialReviewCopyWith<$Res> {
  __$ProtocolMaterialReviewCopyWithImpl(this._self, this._then);

  final _ProtocolMaterialReview _self;
  final $Res Function(_ProtocolMaterialReview) _then;

/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? name = null,Object? productId = freezed,Object? operationType = null,Object? doseBasis = null,Object? doseValue = null,Object? doseUnit = null,Object? dailyDoseIncrement = null,Object? firstDay = null,Object? lastDay = null,Object? repeatIntervalDays = null,Object? recurrenceAnchorDay = null,Object? doseAnchorDay = null,Object? mealNumber = freezed,Object? plannedTime = freezed,Object? recommendedManufacturerId = freezed,Object? requiresResolution = null,Object? resolutionMessage = freezed,Object? proposed = freezed,Object? catalog = freezed,}) {
  return _then(_ProtocolMaterialReview(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,doseBasis: null == doseBasis ? _self.doseBasis : doseBasis // ignore: cast_nullable_to_non_nullable
as String,doseValue: null == doseValue ? _self.doseValue : doseValue // ignore: cast_nullable_to_non_nullable
as String,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,dailyDoseIncrement: null == dailyDoseIncrement ? _self.dailyDoseIncrement : dailyDoseIncrement // ignore: cast_nullable_to_non_nullable
as String,firstDay: null == firstDay ? _self.firstDay : firstDay // ignore: cast_nullable_to_non_nullable
as int,lastDay: null == lastDay ? _self.lastDay : lastDay // ignore: cast_nullable_to_non_nullable
as int,repeatIntervalDays: null == repeatIntervalDays ? _self.repeatIntervalDays : repeatIntervalDays // ignore: cast_nullable_to_non_nullable
as int,recurrenceAnchorDay: null == recurrenceAnchorDay ? _self.recurrenceAnchorDay : recurrenceAnchorDay // ignore: cast_nullable_to_non_nullable
as int,doseAnchorDay: null == doseAnchorDay ? _self.doseAnchorDay : doseAnchorDay // ignore: cast_nullable_to_non_nullable
as int,mealNumber: freezed == mealNumber ? _self.mealNumber : mealNumber // ignore: cast_nullable_to_non_nullable
as int?,plannedTime: freezed == plannedTime ? _self.plannedTime : plannedTime // ignore: cast_nullable_to_non_nullable
as String?,recommendedManufacturerId: freezed == recommendedManufacturerId ? _self.recommendedManufacturerId : recommendedManufacturerId // ignore: cast_nullable_to_non_nullable
as String?,requiresResolution: null == requiresResolution ? _self.requiresResolution : requiresResolution // ignore: cast_nullable_to_non_nullable
as bool,resolutionMessage: freezed == resolutionMessage ? _self.resolutionMessage : resolutionMessage // ignore: cast_nullable_to_non_nullable
as String?,proposed: freezed == proposed ? _self.proposed : proposed // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,
  ));
}

/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get proposed {
    if (_self.proposed == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.proposed!, (value) {
    return _then(_self.copyWith(proposed: value));
  });
}/// Create a copy of ProtocolMaterialReview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}


/// @nodoc
mixin _$ProtocolMaterialOption {

 String get id; String get name; String get unit; String get manufacturerName;@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? get material;
/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolMaterialOptionCopyWith<ProtocolMaterialOption> get copyWith => _$ProtocolMaterialOptionCopyWithImpl<ProtocolMaterialOption>(this as ProtocolMaterialOption, _$identity);

  /// Serializes this ProtocolMaterialOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolMaterialOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.material, material) || other.material == material));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,manufacturerName,material);

@override
String toString() {
  return 'ProtocolMaterialOption(id: $id, name: $name, unit: $unit, manufacturerName: $manufacturerName, material: $material)';
}


}

/// @nodoc
abstract mixin class $ProtocolMaterialOptionCopyWith<$Res>  {
  factory $ProtocolMaterialOptionCopyWith(ProtocolMaterialOption value, $Res Function(ProtocolMaterialOption) _then) = _$ProtocolMaterialOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit, String manufacturerName,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? material
});


$ProtocolMaterialSnapshotCopyWith<$Res>? get material;

}
/// @nodoc
class _$ProtocolMaterialOptionCopyWithImpl<$Res>
    implements $ProtocolMaterialOptionCopyWith<$Res> {
  _$ProtocolMaterialOptionCopyWithImpl(this._self, this._then);

  final ProtocolMaterialOption _self;
  final $Res Function(ProtocolMaterialOption) _then;

/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? manufacturerName = null,Object? material = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,manufacturerName: null == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,
  ));
}
/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get material {
    if (_self.material == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.material!, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProtocolMaterialOption].
extension ProtocolMaterialOptionPatterns on ProtocolMaterialOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolMaterialOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolMaterialOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolMaterialOption value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolMaterialOption value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolMaterialOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String manufacturerName, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? material)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolMaterialOption() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.manufacturerName,_that.material);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String manufacturerName, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? material)  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialOption():
return $default(_that.id,_that.name,_that.unit,_that.manufacturerName,_that.material);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit,  String manufacturerName, @JsonKey(fromJson: _materialFromJson)  ProtocolMaterialSnapshot? material)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolMaterialOption() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.manufacturerName,_that.material);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolMaterialOption implements ProtocolMaterialOption {
  const _ProtocolMaterialOption({required this.id, required this.name, required this.unit, required this.manufacturerName, @JsonKey(fromJson: _materialFromJson) required this.material});
  factory _ProtocolMaterialOption.fromJson(Map<String, dynamic> json) => _$ProtocolMaterialOptionFromJson(json);

@override final  String id;
@override final  String name;
@override final  String unit;
@override final  String manufacturerName;
@override@JsonKey(fromJson: _materialFromJson) final  ProtocolMaterialSnapshot? material;

/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolMaterialOptionCopyWith<_ProtocolMaterialOption> get copyWith => __$ProtocolMaterialOptionCopyWithImpl<_ProtocolMaterialOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolMaterialOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolMaterialOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.material, material) || other.material == material));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,manufacturerName,material);

@override
String toString() {
  return 'ProtocolMaterialOption(id: $id, name: $name, unit: $unit, manufacturerName: $manufacturerName, material: $material)';
}


}

/// @nodoc
abstract mixin class _$ProtocolMaterialOptionCopyWith<$Res> implements $ProtocolMaterialOptionCopyWith<$Res> {
  factory _$ProtocolMaterialOptionCopyWith(_ProtocolMaterialOption value, $Res Function(_ProtocolMaterialOption) _then) = __$ProtocolMaterialOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit, String manufacturerName,@JsonKey(fromJson: _materialFromJson) ProtocolMaterialSnapshot? material
});


@override $ProtocolMaterialSnapshotCopyWith<$Res>? get material;

}
/// @nodoc
class __$ProtocolMaterialOptionCopyWithImpl<$Res>
    implements _$ProtocolMaterialOptionCopyWith<$Res> {
  __$ProtocolMaterialOptionCopyWithImpl(this._self, this._then);

  final _ProtocolMaterialOption _self;
  final $Res Function(_ProtocolMaterialOption) _then;

/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? manufacturerName = null,Object? material = freezed,}) {
  return _then(_ProtocolMaterialOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,manufacturerName: null == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as ProtocolMaterialSnapshot?,
  ));
}

/// Create a copy of ProtocolMaterialOption
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolMaterialSnapshotCopyWith<$Res>? get material {
    if (_self.material == null) {
    return null;
  }

  return $ProtocolMaterialSnapshotCopyWith<$Res>(_self.material!, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$ProtocolDetail {

 ProtocolCardData get card; DateTime get updatedAt; String? get anchorDate; int get durationDays; DateTime? get reviewedAt; String? get reviewerName; String? get rejectionReason; DateTime? get supersededAt; List<ProtocolDayMarker> get dayMarkers; List<ProtocolHistory> get history; bool get canReview; int get contentVersion; int? get sourceTemplateVersionNo; String? get scheduleMessage; List<ProtocolMaterialReview> get materialReviews;
/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolDetailCopyWith<ProtocolDetail> get copyWith => _$ProtocolDetailCopyWithImpl<ProtocolDetail>(this as ProtocolDetail, _$identity);

  /// Serializes this ProtocolDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolDetail&&(identical(other.card, card) || other.card == card)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.anchorDate, anchorDate) || other.anchorDate == anchorDate)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.supersededAt, supersededAt) || other.supersededAt == supersededAt)&&const DeepCollectionEquality().equals(other.dayMarkers, dayMarkers)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.canReview, canReview) || other.canReview == canReview)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.sourceTemplateVersionNo, sourceTemplateVersionNo) || other.sourceTemplateVersionNo == sourceTemplateVersionNo)&&(identical(other.scheduleMessage, scheduleMessage) || other.scheduleMessage == scheduleMessage)&&const DeepCollectionEquality().equals(other.materialReviews, materialReviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,card,updatedAt,anchorDate,durationDays,reviewedAt,reviewerName,rejectionReason,supersededAt,const DeepCollectionEquality().hash(dayMarkers),const DeepCollectionEquality().hash(history),canReview,contentVersion,sourceTemplateVersionNo,scheduleMessage,const DeepCollectionEquality().hash(materialReviews));

@override
String toString() {
  return 'ProtocolDetail(card: $card, updatedAt: $updatedAt, anchorDate: $anchorDate, durationDays: $durationDays, reviewedAt: $reviewedAt, reviewerName: $reviewerName, rejectionReason: $rejectionReason, supersededAt: $supersededAt, dayMarkers: $dayMarkers, history: $history, canReview: $canReview, contentVersion: $contentVersion, sourceTemplateVersionNo: $sourceTemplateVersionNo, scheduleMessage: $scheduleMessage, materialReviews: $materialReviews)';
}


}

/// @nodoc
abstract mixin class $ProtocolDetailCopyWith<$Res>  {
  factory $ProtocolDetailCopyWith(ProtocolDetail value, $Res Function(ProtocolDetail) _then) = _$ProtocolDetailCopyWithImpl;
@useResult
$Res call({
 ProtocolCardData card, DateTime updatedAt, String? anchorDate, int durationDays, DateTime? reviewedAt, String? reviewerName, String? rejectionReason, DateTime? supersededAt, List<ProtocolDayMarker> dayMarkers, List<ProtocolHistory> history, bool canReview, int contentVersion, int? sourceTemplateVersionNo, String? scheduleMessage, List<ProtocolMaterialReview> materialReviews
});


$ProtocolCardDataCopyWith<$Res> get card;

}
/// @nodoc
class _$ProtocolDetailCopyWithImpl<$Res>
    implements $ProtocolDetailCopyWith<$Res> {
  _$ProtocolDetailCopyWithImpl(this._self, this._then);

  final ProtocolDetail _self;
  final $Res Function(ProtocolDetail) _then;

/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? card = null,Object? updatedAt = null,Object? anchorDate = freezed,Object? durationDays = null,Object? reviewedAt = freezed,Object? reviewerName = freezed,Object? rejectionReason = freezed,Object? supersededAt = freezed,Object? dayMarkers = null,Object? history = null,Object? canReview = null,Object? contentVersion = null,Object? sourceTemplateVersionNo = freezed,Object? scheduleMessage = freezed,Object? materialReviews = null,}) {
  return _then(_self.copyWith(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as ProtocolCardData,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,anchorDate: freezed == anchorDate ? _self.anchorDate : anchorDate // ignore: cast_nullable_to_non_nullable
as String?,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,supersededAt: freezed == supersededAt ? _self.supersededAt : supersededAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dayMarkers: null == dayMarkers ? _self.dayMarkers : dayMarkers // ignore: cast_nullable_to_non_nullable
as List<ProtocolDayMarker>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ProtocolHistory>,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,sourceTemplateVersionNo: freezed == sourceTemplateVersionNo ? _self.sourceTemplateVersionNo : sourceTemplateVersionNo // ignore: cast_nullable_to_non_nullable
as int?,scheduleMessage: freezed == scheduleMessage ? _self.scheduleMessage : scheduleMessage // ignore: cast_nullable_to_non_nullable
as String?,materialReviews: null == materialReviews ? _self.materialReviews : materialReviews // ignore: cast_nullable_to_non_nullable
as List<ProtocolMaterialReview>,
  ));
}
/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolCardDataCopyWith<$Res> get card {
  
  return $ProtocolCardDataCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProtocolDetail].
extension ProtocolDetailPatterns on ProtocolDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProtocolCardData card,  DateTime updatedAt,  String? anchorDate,  int durationDays,  DateTime? reviewedAt,  String? reviewerName,  String? rejectionReason,  DateTime? supersededAt,  List<ProtocolDayMarker> dayMarkers,  List<ProtocolHistory> history,  bool canReview,  int contentVersion,  int? sourceTemplateVersionNo,  String? scheduleMessage,  List<ProtocolMaterialReview> materialReviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolDetail() when $default != null:
return $default(_that.card,_that.updatedAt,_that.anchorDate,_that.durationDays,_that.reviewedAt,_that.reviewerName,_that.rejectionReason,_that.supersededAt,_that.dayMarkers,_that.history,_that.canReview,_that.contentVersion,_that.sourceTemplateVersionNo,_that.scheduleMessage,_that.materialReviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProtocolCardData card,  DateTime updatedAt,  String? anchorDate,  int durationDays,  DateTime? reviewedAt,  String? reviewerName,  String? rejectionReason,  DateTime? supersededAt,  List<ProtocolDayMarker> dayMarkers,  List<ProtocolHistory> history,  bool canReview,  int contentVersion,  int? sourceTemplateVersionNo,  String? scheduleMessage,  List<ProtocolMaterialReview> materialReviews)  $default,) {final _that = this;
switch (_that) {
case _ProtocolDetail():
return $default(_that.card,_that.updatedAt,_that.anchorDate,_that.durationDays,_that.reviewedAt,_that.reviewerName,_that.rejectionReason,_that.supersededAt,_that.dayMarkers,_that.history,_that.canReview,_that.contentVersion,_that.sourceTemplateVersionNo,_that.scheduleMessage,_that.materialReviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProtocolCardData card,  DateTime updatedAt,  String? anchorDate,  int durationDays,  DateTime? reviewedAt,  String? reviewerName,  String? rejectionReason,  DateTime? supersededAt,  List<ProtocolDayMarker> dayMarkers,  List<ProtocolHistory> history,  bool canReview,  int contentVersion,  int? sourceTemplateVersionNo,  String? scheduleMessage,  List<ProtocolMaterialReview> materialReviews)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolDetail() when $default != null:
return $default(_that.card,_that.updatedAt,_that.anchorDate,_that.durationDays,_that.reviewedAt,_that.reviewerName,_that.rejectionReason,_that.supersededAt,_that.dayMarkers,_that.history,_that.canReview,_that.contentVersion,_that.sourceTemplateVersionNo,_that.scheduleMessage,_that.materialReviews);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolDetail implements ProtocolDetail {
  const _ProtocolDetail({required this.card, required this.updatedAt, this.anchorDate, required this.durationDays, this.reviewedAt, this.reviewerName, this.rejectionReason, this.supersededAt, required final  List<ProtocolDayMarker> dayMarkers, required final  List<ProtocolHistory> history, required this.canReview, this.contentVersion = 1, this.sourceTemplateVersionNo, this.scheduleMessage, final  List<ProtocolMaterialReview> materialReviews = const []}): _dayMarkers = dayMarkers,_history = history,_materialReviews = materialReviews;
  factory _ProtocolDetail.fromJson(Map<String, dynamic> json) => _$ProtocolDetailFromJson(json);

@override final  ProtocolCardData card;
@override final  DateTime updatedAt;
@override final  String? anchorDate;
@override final  int durationDays;
@override final  DateTime? reviewedAt;
@override final  String? reviewerName;
@override final  String? rejectionReason;
@override final  DateTime? supersededAt;
 final  List<ProtocolDayMarker> _dayMarkers;
@override List<ProtocolDayMarker> get dayMarkers {
  if (_dayMarkers is EqualUnmodifiableListView) return _dayMarkers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dayMarkers);
}

 final  List<ProtocolHistory> _history;
@override List<ProtocolHistory> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override final  bool canReview;
@override@JsonKey() final  int contentVersion;
@override final  int? sourceTemplateVersionNo;
@override final  String? scheduleMessage;
 final  List<ProtocolMaterialReview> _materialReviews;
@override@JsonKey() List<ProtocolMaterialReview> get materialReviews {
  if (_materialReviews is EqualUnmodifiableListView) return _materialReviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_materialReviews);
}


/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolDetailCopyWith<_ProtocolDetail> get copyWith => __$ProtocolDetailCopyWithImpl<_ProtocolDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolDetail&&(identical(other.card, card) || other.card == card)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.anchorDate, anchorDate) || other.anchorDate == anchorDate)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.supersededAt, supersededAt) || other.supersededAt == supersededAt)&&const DeepCollectionEquality().equals(other._dayMarkers, _dayMarkers)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.canReview, canReview) || other.canReview == canReview)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.sourceTemplateVersionNo, sourceTemplateVersionNo) || other.sourceTemplateVersionNo == sourceTemplateVersionNo)&&(identical(other.scheduleMessage, scheduleMessage) || other.scheduleMessage == scheduleMessage)&&const DeepCollectionEquality().equals(other._materialReviews, _materialReviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,card,updatedAt,anchorDate,durationDays,reviewedAt,reviewerName,rejectionReason,supersededAt,const DeepCollectionEquality().hash(_dayMarkers),const DeepCollectionEquality().hash(_history),canReview,contentVersion,sourceTemplateVersionNo,scheduleMessage,const DeepCollectionEquality().hash(_materialReviews));

@override
String toString() {
  return 'ProtocolDetail(card: $card, updatedAt: $updatedAt, anchorDate: $anchorDate, durationDays: $durationDays, reviewedAt: $reviewedAt, reviewerName: $reviewerName, rejectionReason: $rejectionReason, supersededAt: $supersededAt, dayMarkers: $dayMarkers, history: $history, canReview: $canReview, contentVersion: $contentVersion, sourceTemplateVersionNo: $sourceTemplateVersionNo, scheduleMessage: $scheduleMessage, materialReviews: $materialReviews)';
}


}

/// @nodoc
abstract mixin class _$ProtocolDetailCopyWith<$Res> implements $ProtocolDetailCopyWith<$Res> {
  factory _$ProtocolDetailCopyWith(_ProtocolDetail value, $Res Function(_ProtocolDetail) _then) = __$ProtocolDetailCopyWithImpl;
@override @useResult
$Res call({
 ProtocolCardData card, DateTime updatedAt, String? anchorDate, int durationDays, DateTime? reviewedAt, String? reviewerName, String? rejectionReason, DateTime? supersededAt, List<ProtocolDayMarker> dayMarkers, List<ProtocolHistory> history, bool canReview, int contentVersion, int? sourceTemplateVersionNo, String? scheduleMessage, List<ProtocolMaterialReview> materialReviews
});


@override $ProtocolCardDataCopyWith<$Res> get card;

}
/// @nodoc
class __$ProtocolDetailCopyWithImpl<$Res>
    implements _$ProtocolDetailCopyWith<$Res> {
  __$ProtocolDetailCopyWithImpl(this._self, this._then);

  final _ProtocolDetail _self;
  final $Res Function(_ProtocolDetail) _then;

/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? card = null,Object? updatedAt = null,Object? anchorDate = freezed,Object? durationDays = null,Object? reviewedAt = freezed,Object? reviewerName = freezed,Object? rejectionReason = freezed,Object? supersededAt = freezed,Object? dayMarkers = null,Object? history = null,Object? canReview = null,Object? contentVersion = null,Object? sourceTemplateVersionNo = freezed,Object? scheduleMessage = freezed,Object? materialReviews = null,}) {
  return _then(_ProtocolDetail(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as ProtocolCardData,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,anchorDate: freezed == anchorDate ? _self.anchorDate : anchorDate // ignore: cast_nullable_to_non_nullable
as String?,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,supersededAt: freezed == supersededAt ? _self.supersededAt : supersededAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dayMarkers: null == dayMarkers ? _self._dayMarkers : dayMarkers // ignore: cast_nullable_to_non_nullable
as List<ProtocolDayMarker>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ProtocolHistory>,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,sourceTemplateVersionNo: freezed == sourceTemplateVersionNo ? _self.sourceTemplateVersionNo : sourceTemplateVersionNo // ignore: cast_nullable_to_non_nullable
as int?,scheduleMessage: freezed == scheduleMessage ? _self.scheduleMessage : scheduleMessage // ignore: cast_nullable_to_non_nullable
as String?,materialReviews: null == materialReviews ? _self._materialReviews : materialReviews // ignore: cast_nullable_to_non_nullable
as List<ProtocolMaterialReview>,
  ));
}

/// Create a copy of ProtocolDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProtocolCardDataCopyWith<$Res> get card {
  
  return $ProtocolCardDataCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// @nodoc
mixin _$ProtocolDayRow {

 String get itemId; String get operationType; String get productName; String? get time; String get doseBasis; double get doseValue; String get doseUnit; String? get instructions; String? get scheduleId;@JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown) ProtocolOperationStatus get status; double? get plannedQuantity; String get unit; double? get basisQuantity; String? get basisUnit; double? get actualQuantity; String? get actualProductName; String? get actualUnit; String? get varianceReason; String? get executorName; DateTime? get executedAt; String? get cancellationReason; DateTime? get cancelledAt;
/// Create a copy of ProtocolDayRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolDayRowCopyWith<ProtocolDayRow> get copyWith => _$ProtocolDayRowCopyWithImpl<ProtocolDayRow>(this as ProtocolDayRow, _$identity);

  /// Serializes this ProtocolDayRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolDayRow&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.time, time) || other.time == time)&&(identical(other.doseBasis, doseBasis) || other.doseBasis == doseBasis)&&(identical(other.doseValue, doseValue) || other.doseValue == doseValue)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.plannedQuantity, plannedQuantity) || other.plannedQuantity == plannedQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.basisQuantity, basisQuantity) || other.basisQuantity == basisQuantity)&&(identical(other.basisUnit, basisUnit) || other.basisUnit == basisUnit)&&(identical(other.actualQuantity, actualQuantity) || other.actualQuantity == actualQuantity)&&(identical(other.actualProductName, actualProductName) || other.actualProductName == actualProductName)&&(identical(other.actualUnit, actualUnit) || other.actualUnit == actualUnit)&&(identical(other.varianceReason, varianceReason) || other.varianceReason == varianceReason)&&(identical(other.executorName, executorName) || other.executorName == executorName)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,operationType,productName,time,doseBasis,doseValue,doseUnit,instructions,scheduleId,status,plannedQuantity,unit,basisQuantity,basisUnit,actualQuantity,actualProductName,actualUnit,varianceReason,executorName,executedAt,cancellationReason,cancelledAt]);

@override
String toString() {
  return 'ProtocolDayRow(itemId: $itemId, operationType: $operationType, productName: $productName, time: $time, doseBasis: $doseBasis, doseValue: $doseValue, doseUnit: $doseUnit, instructions: $instructions, scheduleId: $scheduleId, status: $status, plannedQuantity: $plannedQuantity, unit: $unit, basisQuantity: $basisQuantity, basisUnit: $basisUnit, actualQuantity: $actualQuantity, actualProductName: $actualProductName, actualUnit: $actualUnit, varianceReason: $varianceReason, executorName: $executorName, executedAt: $executedAt, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class $ProtocolDayRowCopyWith<$Res>  {
  factory $ProtocolDayRowCopyWith(ProtocolDayRow value, $Res Function(ProtocolDayRow) _then) = _$ProtocolDayRowCopyWithImpl;
@useResult
$Res call({
 String itemId, String operationType, String productName, String? time, String doseBasis, double doseValue, String doseUnit, String? instructions, String? scheduleId,@JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown) ProtocolOperationStatus status, double? plannedQuantity, String unit, double? basisQuantity, String? basisUnit, double? actualQuantity, String? actualProductName, String? actualUnit, String? varianceReason, String? executorName, DateTime? executedAt, String? cancellationReason, DateTime? cancelledAt
});




}
/// @nodoc
class _$ProtocolDayRowCopyWithImpl<$Res>
    implements $ProtocolDayRowCopyWith<$Res> {
  _$ProtocolDayRowCopyWithImpl(this._self, this._then);

  final ProtocolDayRow _self;
  final $Res Function(ProtocolDayRow) _then;

/// Create a copy of ProtocolDayRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? operationType = null,Object? productName = null,Object? time = freezed,Object? doseBasis = null,Object? doseValue = null,Object? doseUnit = null,Object? instructions = freezed,Object? scheduleId = freezed,Object? status = null,Object? plannedQuantity = freezed,Object? unit = null,Object? basisQuantity = freezed,Object? basisUnit = freezed,Object? actualQuantity = freezed,Object? actualProductName = freezed,Object? actualUnit = freezed,Object? varianceReason = freezed,Object? executorName = freezed,Object? executedAt = freezed,Object? cancellationReason = freezed,Object? cancelledAt = freezed,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,doseBasis: null == doseBasis ? _self.doseBasis : doseBasis // ignore: cast_nullable_to_non_nullable
as String,doseValue: null == doseValue ? _self.doseValue : doseValue // ignore: cast_nullable_to_non_nullable
as double,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolOperationStatus,plannedQuantity: freezed == plannedQuantity ? _self.plannedQuantity : plannedQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,basisQuantity: freezed == basisQuantity ? _self.basisQuantity : basisQuantity // ignore: cast_nullable_to_non_nullable
as double?,basisUnit: freezed == basisUnit ? _self.basisUnit : basisUnit // ignore: cast_nullable_to_non_nullable
as String?,actualQuantity: freezed == actualQuantity ? _self.actualQuantity : actualQuantity // ignore: cast_nullable_to_non_nullable
as double?,actualProductName: freezed == actualProductName ? _self.actualProductName : actualProductName // ignore: cast_nullable_to_non_nullable
as String?,actualUnit: freezed == actualUnit ? _self.actualUnit : actualUnit // ignore: cast_nullable_to_non_nullable
as String?,varianceReason: freezed == varianceReason ? _self.varianceReason : varianceReason // ignore: cast_nullable_to_non_nullable
as String?,executorName: freezed == executorName ? _self.executorName : executorName // ignore: cast_nullable_to_non_nullable
as String?,executedAt: freezed == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolDayRow].
extension ProtocolDayRowPatterns on ProtocolDayRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolDayRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolDayRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolDayRow value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolDayRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolDayRow value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolDayRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String operationType,  String productName,  String? time,  String doseBasis,  double doseValue,  String doseUnit,  String? instructions,  String? scheduleId, @JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown)  ProtocolOperationStatus status,  double? plannedQuantity,  String unit,  double? basisQuantity,  String? basisUnit,  double? actualQuantity,  String? actualProductName,  String? actualUnit,  String? varianceReason,  String? executorName,  DateTime? executedAt,  String? cancellationReason,  DateTime? cancelledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolDayRow() when $default != null:
return $default(_that.itemId,_that.operationType,_that.productName,_that.time,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.instructions,_that.scheduleId,_that.status,_that.plannedQuantity,_that.unit,_that.basisQuantity,_that.basisUnit,_that.actualQuantity,_that.actualProductName,_that.actualUnit,_that.varianceReason,_that.executorName,_that.executedAt,_that.cancellationReason,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String operationType,  String productName,  String? time,  String doseBasis,  double doseValue,  String doseUnit,  String? instructions,  String? scheduleId, @JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown)  ProtocolOperationStatus status,  double? plannedQuantity,  String unit,  double? basisQuantity,  String? basisUnit,  double? actualQuantity,  String? actualProductName,  String? actualUnit,  String? varianceReason,  String? executorName,  DateTime? executedAt,  String? cancellationReason,  DateTime? cancelledAt)  $default,) {final _that = this;
switch (_that) {
case _ProtocolDayRow():
return $default(_that.itemId,_that.operationType,_that.productName,_that.time,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.instructions,_that.scheduleId,_that.status,_that.plannedQuantity,_that.unit,_that.basisQuantity,_that.basisUnit,_that.actualQuantity,_that.actualProductName,_that.actualUnit,_that.varianceReason,_that.executorName,_that.executedAt,_that.cancellationReason,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String operationType,  String productName,  String? time,  String doseBasis,  double doseValue,  String doseUnit,  String? instructions,  String? scheduleId, @JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown)  ProtocolOperationStatus status,  double? plannedQuantity,  String unit,  double? basisQuantity,  String? basisUnit,  double? actualQuantity,  String? actualProductName,  String? actualUnit,  String? varianceReason,  String? executorName,  DateTime? executedAt,  String? cancellationReason,  DateTime? cancelledAt)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolDayRow() when $default != null:
return $default(_that.itemId,_that.operationType,_that.productName,_that.time,_that.doseBasis,_that.doseValue,_that.doseUnit,_that.instructions,_that.scheduleId,_that.status,_that.plannedQuantity,_that.unit,_that.basisQuantity,_that.basisUnit,_that.actualQuantity,_that.actualProductName,_that.actualUnit,_that.varianceReason,_that.executorName,_that.executedAt,_that.cancellationReason,_that.cancelledAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolDayRow implements ProtocolDayRow {
  const _ProtocolDayRow({required this.itemId, required this.operationType, required this.productName, this.time, required this.doseBasis, required this.doseValue, required this.doseUnit, this.instructions, this.scheduleId, @JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown) required this.status, this.plannedQuantity, required this.unit, this.basisQuantity, this.basisUnit, this.actualQuantity, this.actualProductName, this.actualUnit, this.varianceReason, this.executorName, this.executedAt, this.cancellationReason, this.cancelledAt});
  factory _ProtocolDayRow.fromJson(Map<String, dynamic> json) => _$ProtocolDayRowFromJson(json);

@override final  String itemId;
@override final  String operationType;
@override final  String productName;
@override final  String? time;
@override final  String doseBasis;
@override final  double doseValue;
@override final  String doseUnit;
@override final  String? instructions;
@override final  String? scheduleId;
@override@JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown) final  ProtocolOperationStatus status;
@override final  double? plannedQuantity;
@override final  String unit;
@override final  double? basisQuantity;
@override final  String? basisUnit;
@override final  double? actualQuantity;
@override final  String? actualProductName;
@override final  String? actualUnit;
@override final  String? varianceReason;
@override final  String? executorName;
@override final  DateTime? executedAt;
@override final  String? cancellationReason;
@override final  DateTime? cancelledAt;

/// Create a copy of ProtocolDayRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolDayRowCopyWith<_ProtocolDayRow> get copyWith => __$ProtocolDayRowCopyWithImpl<_ProtocolDayRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolDayRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolDayRow&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.time, time) || other.time == time)&&(identical(other.doseBasis, doseBasis) || other.doseBasis == doseBasis)&&(identical(other.doseValue, doseValue) || other.doseValue == doseValue)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.plannedQuantity, plannedQuantity) || other.plannedQuantity == plannedQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.basisQuantity, basisQuantity) || other.basisQuantity == basisQuantity)&&(identical(other.basisUnit, basisUnit) || other.basisUnit == basisUnit)&&(identical(other.actualQuantity, actualQuantity) || other.actualQuantity == actualQuantity)&&(identical(other.actualProductName, actualProductName) || other.actualProductName == actualProductName)&&(identical(other.actualUnit, actualUnit) || other.actualUnit == actualUnit)&&(identical(other.varianceReason, varianceReason) || other.varianceReason == varianceReason)&&(identical(other.executorName, executorName) || other.executorName == executorName)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,operationType,productName,time,doseBasis,doseValue,doseUnit,instructions,scheduleId,status,plannedQuantity,unit,basisQuantity,basisUnit,actualQuantity,actualProductName,actualUnit,varianceReason,executorName,executedAt,cancellationReason,cancelledAt]);

@override
String toString() {
  return 'ProtocolDayRow(itemId: $itemId, operationType: $operationType, productName: $productName, time: $time, doseBasis: $doseBasis, doseValue: $doseValue, doseUnit: $doseUnit, instructions: $instructions, scheduleId: $scheduleId, status: $status, plannedQuantity: $plannedQuantity, unit: $unit, basisQuantity: $basisQuantity, basisUnit: $basisUnit, actualQuantity: $actualQuantity, actualProductName: $actualProductName, actualUnit: $actualUnit, varianceReason: $varianceReason, executorName: $executorName, executedAt: $executedAt, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class _$ProtocolDayRowCopyWith<$Res> implements $ProtocolDayRowCopyWith<$Res> {
  factory _$ProtocolDayRowCopyWith(_ProtocolDayRow value, $Res Function(_ProtocolDayRow) _then) = __$ProtocolDayRowCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String operationType, String productName, String? time, String doseBasis, double doseValue, String doseUnit, String? instructions, String? scheduleId,@JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown) ProtocolOperationStatus status, double? plannedQuantity, String unit, double? basisQuantity, String? basisUnit, double? actualQuantity, String? actualProductName, String? actualUnit, String? varianceReason, String? executorName, DateTime? executedAt, String? cancellationReason, DateTime? cancelledAt
});




}
/// @nodoc
class __$ProtocolDayRowCopyWithImpl<$Res>
    implements _$ProtocolDayRowCopyWith<$Res> {
  __$ProtocolDayRowCopyWithImpl(this._self, this._then);

  final _ProtocolDayRow _self;
  final $Res Function(_ProtocolDayRow) _then;

/// Create a copy of ProtocolDayRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? operationType = null,Object? productName = null,Object? time = freezed,Object? doseBasis = null,Object? doseValue = null,Object? doseUnit = null,Object? instructions = freezed,Object? scheduleId = freezed,Object? status = null,Object? plannedQuantity = freezed,Object? unit = null,Object? basisQuantity = freezed,Object? basisUnit = freezed,Object? actualQuantity = freezed,Object? actualProductName = freezed,Object? actualUnit = freezed,Object? varianceReason = freezed,Object? executorName = freezed,Object? executedAt = freezed,Object? cancellationReason = freezed,Object? cancelledAt = freezed,}) {
  return _then(_ProtocolDayRow(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,doseBasis: null == doseBasis ? _self.doseBasis : doseBasis // ignore: cast_nullable_to_non_nullable
as String,doseValue: null == doseValue ? _self.doseValue : doseValue // ignore: cast_nullable_to_non_nullable
as double,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProtocolOperationStatus,plannedQuantity: freezed == plannedQuantity ? _self.plannedQuantity : plannedQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,basisQuantity: freezed == basisQuantity ? _self.basisQuantity : basisQuantity // ignore: cast_nullable_to_non_nullable
as double?,basisUnit: freezed == basisUnit ? _self.basisUnit : basisUnit // ignore: cast_nullable_to_non_nullable
as String?,actualQuantity: freezed == actualQuantity ? _self.actualQuantity : actualQuantity // ignore: cast_nullable_to_non_nullable
as double?,actualProductName: freezed == actualProductName ? _self.actualProductName : actualProductName // ignore: cast_nullable_to_non_nullable
as String?,actualUnit: freezed == actualUnit ? _self.actualUnit : actualUnit // ignore: cast_nullable_to_non_nullable
as String?,varianceReason: freezed == varianceReason ? _self.varianceReason : varianceReason // ignore: cast_nullable_to_non_nullable
as String?,executorName: freezed == executorName ? _self.executorName : executorName // ignore: cast_nullable_to_non_nullable
as String?,executedAt: freezed == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProtocolDay {

 int get day; String? get date; List<ProtocolDayRow> get rows;
/// Create a copy of ProtocolDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolDayCopyWith<ProtocolDay> get copyWith => _$ProtocolDayCopyWithImpl<ProtocolDay>(this as ProtocolDay, _$identity);

  /// Serializes this ProtocolDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolDay&&(identical(other.day, day) || other.day == day)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,date,const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'ProtocolDay(day: $day, date: $date, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $ProtocolDayCopyWith<$Res>  {
  factory $ProtocolDayCopyWith(ProtocolDay value, $Res Function(ProtocolDay) _then) = _$ProtocolDayCopyWithImpl;
@useResult
$Res call({
 int day, String? date, List<ProtocolDayRow> rows
});




}
/// @nodoc
class _$ProtocolDayCopyWithImpl<$Res>
    implements $ProtocolDayCopyWith<$Res> {
  _$ProtocolDayCopyWithImpl(this._self, this._then);

  final ProtocolDay _self;
  final $Res Function(ProtocolDay) _then;

/// Create a copy of ProtocolDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? date = freezed,Object? rows = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ProtocolDayRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolDay].
extension ProtocolDayPatterns on ProtocolDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolDay value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolDay value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  String? date,  List<ProtocolDayRow> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolDay() when $default != null:
return $default(_that.day,_that.date,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  String? date,  List<ProtocolDayRow> rows)  $default,) {final _that = this;
switch (_that) {
case _ProtocolDay():
return $default(_that.day,_that.date,_that.rows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  String? date,  List<ProtocolDayRow> rows)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolDay() when $default != null:
return $default(_that.day,_that.date,_that.rows);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolDay implements ProtocolDay {
  const _ProtocolDay({required this.day, this.date, required final  List<ProtocolDayRow> rows}): _rows = rows;
  factory _ProtocolDay.fromJson(Map<String, dynamic> json) => _$ProtocolDayFromJson(json);

@override final  int day;
@override final  String? date;
 final  List<ProtocolDayRow> _rows;
@override List<ProtocolDayRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of ProtocolDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolDayCopyWith<_ProtocolDay> get copyWith => __$ProtocolDayCopyWithImpl<_ProtocolDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolDay&&(identical(other.day, day) || other.day == day)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,date,const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'ProtocolDay(day: $day, date: $date, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$ProtocolDayCopyWith<$Res> implements $ProtocolDayCopyWith<$Res> {
  factory _$ProtocolDayCopyWith(_ProtocolDay value, $Res Function(_ProtocolDay) _then) = __$ProtocolDayCopyWithImpl;
@override @useResult
$Res call({
 int day, String? date, List<ProtocolDayRow> rows
});




}
/// @nodoc
class __$ProtocolDayCopyWithImpl<$Res>
    implements _$ProtocolDayCopyWith<$Res> {
  __$ProtocolDayCopyWithImpl(this._self, this._then);

  final _ProtocolDay _self;
  final $Res Function(_ProtocolDay) _then;

/// Create a copy of ProtocolDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? date = freezed,Object? rows = null,}) {
  return _then(_ProtocolDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ProtocolDayRow>,
  ));
}


}

/// @nodoc
mixin _$ProtocolPage {

 List<ProtocolCardData> get items; int get page; bool get hasNextPage; int get productionCount; int get treatmentCount;
/// Create a copy of ProtocolPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolPageCopyWith<ProtocolPage> get copyWith => _$ProtocolPageCopyWithImpl<ProtocolPage>(this as ProtocolPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.productionCount, productionCount) || other.productionCount == productionCount)&&(identical(other.treatmentCount, treatmentCount) || other.treatmentCount == treatmentCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,hasNextPage,productionCount,treatmentCount);

@override
String toString() {
  return 'ProtocolPage(items: $items, page: $page, hasNextPage: $hasNextPage, productionCount: $productionCount, treatmentCount: $treatmentCount)';
}


}

/// @nodoc
abstract mixin class $ProtocolPageCopyWith<$Res>  {
  factory $ProtocolPageCopyWith(ProtocolPage value, $Res Function(ProtocolPage) _then) = _$ProtocolPageCopyWithImpl;
@useResult
$Res call({
 List<ProtocolCardData> items, int page, bool hasNextPage, int productionCount, int treatmentCount
});




}
/// @nodoc
class _$ProtocolPageCopyWithImpl<$Res>
    implements $ProtocolPageCopyWith<$Res> {
  _$ProtocolPageCopyWithImpl(this._self, this._then);

  final ProtocolPage _self;
  final $Res Function(ProtocolPage) _then;

/// Create a copy of ProtocolPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? hasNextPage = null,Object? productionCount = null,Object? treatmentCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProtocolCardData>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,productionCount: null == productionCount ? _self.productionCount : productionCount // ignore: cast_nullable_to_non_nullable
as int,treatmentCount: null == treatmentCount ? _self.treatmentCount : treatmentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolPage].
extension ProtocolPagePatterns on ProtocolPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolPage value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolPage value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProtocolCardData> items,  int page,  bool hasNextPage,  int productionCount,  int treatmentCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolPage() when $default != null:
return $default(_that.items,_that.page,_that.hasNextPage,_that.productionCount,_that.treatmentCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProtocolCardData> items,  int page,  bool hasNextPage,  int productionCount,  int treatmentCount)  $default,) {final _that = this;
switch (_that) {
case _ProtocolPage():
return $default(_that.items,_that.page,_that.hasNextPage,_that.productionCount,_that.treatmentCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProtocolCardData> items,  int page,  bool hasNextPage,  int productionCount,  int treatmentCount)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolPage() when $default != null:
return $default(_that.items,_that.page,_that.hasNextPage,_that.productionCount,_that.treatmentCount);case _:
  return null;

}
}

}

/// @nodoc


class _ProtocolPage implements ProtocolPage {
  const _ProtocolPage({required final  List<ProtocolCardData> items, required this.page, required this.hasNextPage, required this.productionCount, required this.treatmentCount}): _items = items;
  

 final  List<ProtocolCardData> _items;
@override List<ProtocolCardData> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  bool hasNextPage;
@override final  int productionCount;
@override final  int treatmentCount;

/// Create a copy of ProtocolPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolPageCopyWith<_ProtocolPage> get copyWith => __$ProtocolPageCopyWithImpl<_ProtocolPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.productionCount, productionCount) || other.productionCount == productionCount)&&(identical(other.treatmentCount, treatmentCount) || other.treatmentCount == treatmentCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,hasNextPage,productionCount,treatmentCount);

@override
String toString() {
  return 'ProtocolPage(items: $items, page: $page, hasNextPage: $hasNextPage, productionCount: $productionCount, treatmentCount: $treatmentCount)';
}


}

/// @nodoc
abstract mixin class _$ProtocolPageCopyWith<$Res> implements $ProtocolPageCopyWith<$Res> {
  factory _$ProtocolPageCopyWith(_ProtocolPage value, $Res Function(_ProtocolPage) _then) = __$ProtocolPageCopyWithImpl;
@override @useResult
$Res call({
 List<ProtocolCardData> items, int page, bool hasNextPage, int productionCount, int treatmentCount
});




}
/// @nodoc
class __$ProtocolPageCopyWithImpl<$Res>
    implements _$ProtocolPageCopyWith<$Res> {
  __$ProtocolPageCopyWithImpl(this._self, this._then);

  final _ProtocolPage _self;
  final $Res Function(_ProtocolPage) _then;

/// Create a copy of ProtocolPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? hasNextPage = null,Object? productionCount = null,Object? treatmentCount = null,}) {
  return _then(_ProtocolPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProtocolCardData>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,productionCount: null == productionCount ? _self.productionCount : productionCount // ignore: cast_nullable_to_non_nullable
as int,treatmentCount: null == treatmentCount ? _self.treatmentCount : treatmentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProtocolInventoryEntry {

 String get id; String get productName; String get lotNumber; double get quantity; String get unit; String get performedByName; DateTime get createdAt; String? get reason;
/// Create a copy of ProtocolInventoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolInventoryEntryCopyWith<ProtocolInventoryEntry> get copyWith => _$ProtocolInventoryEntryCopyWithImpl<ProtocolInventoryEntry>(this as ProtocolInventoryEntry, _$identity);

  /// Serializes this ProtocolInventoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolInventoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.performedByName, performedByName) || other.performedByName == performedByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,lotNumber,quantity,unit,performedByName,createdAt,reason);

@override
String toString() {
  return 'ProtocolInventoryEntry(id: $id, productName: $productName, lotNumber: $lotNumber, quantity: $quantity, unit: $unit, performedByName: $performedByName, createdAt: $createdAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ProtocolInventoryEntryCopyWith<$Res>  {
  factory $ProtocolInventoryEntryCopyWith(ProtocolInventoryEntry value, $Res Function(ProtocolInventoryEntry) _then) = _$ProtocolInventoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, String productName, String lotNumber, double quantity, String unit, String performedByName, DateTime createdAt, String? reason
});




}
/// @nodoc
class _$ProtocolInventoryEntryCopyWithImpl<$Res>
    implements $ProtocolInventoryEntryCopyWith<$Res> {
  _$ProtocolInventoryEntryCopyWithImpl(this._self, this._then);

  final ProtocolInventoryEntry _self;
  final $Res Function(ProtocolInventoryEntry) _then;

/// Create a copy of ProtocolInventoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? lotNumber = null,Object? quantity = null,Object? unit = null,Object? performedByName = null,Object? createdAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,performedByName: null == performedByName ? _self.performedByName : performedByName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolInventoryEntry].
extension ProtocolInventoryEntryPatterns on ProtocolInventoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolInventoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolInventoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolInventoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolInventoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolInventoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolInventoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  String lotNumber,  double quantity,  String unit,  String performedByName,  DateTime createdAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolInventoryEntry() when $default != null:
return $default(_that.id,_that.productName,_that.lotNumber,_that.quantity,_that.unit,_that.performedByName,_that.createdAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  String lotNumber,  double quantity,  String unit,  String performedByName,  DateTime createdAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ProtocolInventoryEntry():
return $default(_that.id,_that.productName,_that.lotNumber,_that.quantity,_that.unit,_that.performedByName,_that.createdAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  String lotNumber,  double quantity,  String unit,  String performedByName,  DateTime createdAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolInventoryEntry() when $default != null:
return $default(_that.id,_that.productName,_that.lotNumber,_that.quantity,_that.unit,_that.performedByName,_that.createdAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ProtocolInventoryEntry implements ProtocolInventoryEntry {
  const _ProtocolInventoryEntry({required this.id, required this.productName, required this.lotNumber, required this.quantity, required this.unit, required this.performedByName, required this.createdAt, this.reason});
  factory _ProtocolInventoryEntry.fromJson(Map<String, dynamic> json) => _$ProtocolInventoryEntryFromJson(json);

@override final  String id;
@override final  String productName;
@override final  String lotNumber;
@override final  double quantity;
@override final  String unit;
@override final  String performedByName;
@override final  DateTime createdAt;
@override final  String? reason;

/// Create a copy of ProtocolInventoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolInventoryEntryCopyWith<_ProtocolInventoryEntry> get copyWith => __$ProtocolInventoryEntryCopyWithImpl<_ProtocolInventoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolInventoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolInventoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.performedByName, performedByName) || other.performedByName == performedByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,lotNumber,quantity,unit,performedByName,createdAt,reason);

@override
String toString() {
  return 'ProtocolInventoryEntry(id: $id, productName: $productName, lotNumber: $lotNumber, quantity: $quantity, unit: $unit, performedByName: $performedByName, createdAt: $createdAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ProtocolInventoryEntryCopyWith<$Res> implements $ProtocolInventoryEntryCopyWith<$Res> {
  factory _$ProtocolInventoryEntryCopyWith(_ProtocolInventoryEntry value, $Res Function(_ProtocolInventoryEntry) _then) = __$ProtocolInventoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, String lotNumber, double quantity, String unit, String performedByName, DateTime createdAt, String? reason
});




}
/// @nodoc
class __$ProtocolInventoryEntryCopyWithImpl<$Res>
    implements _$ProtocolInventoryEntryCopyWith<$Res> {
  __$ProtocolInventoryEntryCopyWithImpl(this._self, this._then);

  final _ProtocolInventoryEntry _self;
  final $Res Function(_ProtocolInventoryEntry) _then;

/// Create a copy of ProtocolInventoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? lotNumber = null,Object? quantity = null,Object? unit = null,Object? performedByName = null,Object? createdAt = null,Object? reason = freezed,}) {
  return _then(_ProtocolInventoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,performedByName: null == performedByName ? _self.performedByName : performedByName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
