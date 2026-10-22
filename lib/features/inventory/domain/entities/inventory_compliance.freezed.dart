// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_compliance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryCompliance {

 String get regulatoryType; String? get registrationNumber; String? get ingredientsText; bool? get containsAntibiotic; String? get usageInstructions; double? get withdrawalDays; List<String> get evidenceUrls; String get complianceStatus; String? get checkedBy; DateTime? get checkedAt; String? get reviewNote;
/// Create a copy of InventoryCompliance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryComplianceCopyWith<InventoryCompliance> get copyWith => _$InventoryComplianceCopyWithImpl<InventoryCompliance>(this as InventoryCompliance, _$identity);

  /// Serializes this InventoryCompliance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryCompliance&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&const DeepCollectionEquality().equals(other.evidenceUrls, evidenceUrls)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,regulatoryType,registrationNumber,ingredientsText,containsAntibiotic,usageInstructions,withdrawalDays,const DeepCollectionEquality().hash(evidenceUrls),complianceStatus,checkedBy,checkedAt,reviewNote);

@override
String toString() {
  return 'InventoryCompliance(regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, containsAntibiotic: $containsAntibiotic, usageInstructions: $usageInstructions, withdrawalDays: $withdrawalDays, evidenceUrls: $evidenceUrls, complianceStatus: $complianceStatus, checkedBy: $checkedBy, checkedAt: $checkedAt, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class $InventoryComplianceCopyWith<$Res>  {
  factory $InventoryComplianceCopyWith(InventoryCompliance value, $Res Function(InventoryCompliance) _then) = _$InventoryComplianceCopyWithImpl;
@useResult
$Res call({
 String regulatoryType, String? registrationNumber, String? ingredientsText, bool? containsAntibiotic, String? usageInstructions, double? withdrawalDays, List<String> evidenceUrls, String complianceStatus, String? checkedBy, DateTime? checkedAt, String? reviewNote
});




}
/// @nodoc
class _$InventoryComplianceCopyWithImpl<$Res>
    implements $InventoryComplianceCopyWith<$Res> {
  _$InventoryComplianceCopyWithImpl(this._self, this._then);

  final InventoryCompliance _self;
  final $Res Function(InventoryCompliance) _then;

/// Create a copy of InventoryCompliance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? regulatoryType = null,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? containsAntibiotic = freezed,Object? usageInstructions = freezed,Object? withdrawalDays = freezed,Object? evidenceUrls = null,Object? complianceStatus = null,Object? checkedBy = freezed,Object? checkedAt = freezed,Object? reviewNote = freezed,}) {
  return _then(_self.copyWith(
regulatoryType: null == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as double?,evidenceUrls: null == evidenceUrls ? _self.evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,complianceStatus: null == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryCompliance].
extension InventoryCompliancePatterns on InventoryCompliance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryCompliance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryCompliance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryCompliance value)  $default,){
final _that = this;
switch (_that) {
case _InventoryCompliance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryCompliance value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryCompliance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions,  double? withdrawalDays,  List<String> evidenceUrls,  String complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryCompliance() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions,  double? withdrawalDays,  List<String> evidenceUrls,  String complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)  $default,) {final _that = this;
switch (_that) {
case _InventoryCompliance():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String regulatoryType,  String? registrationNumber,  String? ingredientsText,  bool? containsAntibiotic,  String? usageInstructions,  double? withdrawalDays,  List<String> evidenceUrls,  String complianceStatus,  String? checkedBy,  DateTime? checkedAt,  String? reviewNote)?  $default,) {final _that = this;
switch (_that) {
case _InventoryCompliance() when $default != null:
return $default(_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.containsAntibiotic,_that.usageInstructions,_that.withdrawalDays,_that.evidenceUrls,_that.complianceStatus,_that.checkedBy,_that.checkedAt,_that.reviewNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryCompliance extends InventoryCompliance {
  const _InventoryCompliance({this.regulatoryType = 'unclassified', this.registrationNumber, this.ingredientsText, this.containsAntibiotic, this.usageInstructions, this.withdrawalDays, final  List<String> evidenceUrls = const <String>[], this.complianceStatus = 'draft', this.checkedBy, this.checkedAt, this.reviewNote}): _evidenceUrls = evidenceUrls,super._();
  factory _InventoryCompliance.fromJson(Map<String, dynamic> json) => _$InventoryComplianceFromJson(json);

@override@JsonKey() final  String regulatoryType;
@override final  String? registrationNumber;
@override final  String? ingredientsText;
@override final  bool? containsAntibiotic;
@override final  String? usageInstructions;
@override final  double? withdrawalDays;
 final  List<String> _evidenceUrls;
@override@JsonKey() List<String> get evidenceUrls {
  if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceUrls);
}

@override@JsonKey() final  String complianceStatus;
@override final  String? checkedBy;
@override final  DateTime? checkedAt;
@override final  String? reviewNote;

/// Create a copy of InventoryCompliance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryComplianceCopyWith<_InventoryCompliance> get copyWith => __$InventoryComplianceCopyWithImpl<_InventoryCompliance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryComplianceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryCompliance&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&const DeepCollectionEquality().equals(other._evidenceUrls, _evidenceUrls)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.checkedBy, checkedBy) || other.checkedBy == checkedBy)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,regulatoryType,registrationNumber,ingredientsText,containsAntibiotic,usageInstructions,withdrawalDays,const DeepCollectionEquality().hash(_evidenceUrls),complianceStatus,checkedBy,checkedAt,reviewNote);

@override
String toString() {
  return 'InventoryCompliance(regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, containsAntibiotic: $containsAntibiotic, usageInstructions: $usageInstructions, withdrawalDays: $withdrawalDays, evidenceUrls: $evidenceUrls, complianceStatus: $complianceStatus, checkedBy: $checkedBy, checkedAt: $checkedAt, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class _$InventoryComplianceCopyWith<$Res> implements $InventoryComplianceCopyWith<$Res> {
  factory _$InventoryComplianceCopyWith(_InventoryCompliance value, $Res Function(_InventoryCompliance) _then) = __$InventoryComplianceCopyWithImpl;
@override @useResult
$Res call({
 String regulatoryType, String? registrationNumber, String? ingredientsText, bool? containsAntibiotic, String? usageInstructions, double? withdrawalDays, List<String> evidenceUrls, String complianceStatus, String? checkedBy, DateTime? checkedAt, String? reviewNote
});




}
/// @nodoc
class __$InventoryComplianceCopyWithImpl<$Res>
    implements _$InventoryComplianceCopyWith<$Res> {
  __$InventoryComplianceCopyWithImpl(this._self, this._then);

  final _InventoryCompliance _self;
  final $Res Function(_InventoryCompliance) _then;

/// Create a copy of InventoryCompliance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? regulatoryType = null,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? containsAntibiotic = freezed,Object? usageInstructions = freezed,Object? withdrawalDays = freezed,Object? evidenceUrls = null,Object? complianceStatus = null,Object? checkedBy = freezed,Object? checkedAt = freezed,Object? reviewNote = freezed,}) {
  return _then(_InventoryCompliance(
regulatoryType: null == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as double?,evidenceUrls: null == evidenceUrls ? _self._evidenceUrls : evidenceUrls // ignore: cast_nullable_to_non_nullable
as List<String>,complianceStatus: null == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String,checkedBy: freezed == checkedBy ? _self.checkedBy : checkedBy // ignore: cast_nullable_to_non_nullable
as String?,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
