// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_label.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryLabelResult {

 String? get name; String? get manufacturerName; String? get regulatoryType; String? get registrationNumber; String? get ingredientsText; String? get usageInstructions; bool? get containsAntibiotic; double? get withdrawalDays; InventorySubstanceCheck? get substanceCheck; Map<String, String> get evidence; List<String> get warnings;
/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryLabelResultCopyWith<InventoryLabelResult> get copyWith => _$InventoryLabelResultCopyWithImpl<InventoryLabelResult>(this as InventoryLabelResult, _$identity);

  /// Serializes this InventoryLabelResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryLabelResult&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.substanceCheck, substanceCheck) || other.substanceCheck == substanceCheck)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,manufacturerName,regulatoryType,registrationNumber,ingredientsText,usageInstructions,containsAntibiotic,withdrawalDays,substanceCheck,const DeepCollectionEquality().hash(evidence),const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'InventoryLabelResult(name: $name, manufacturerName: $manufacturerName, regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, usageInstructions: $usageInstructions, containsAntibiotic: $containsAntibiotic, withdrawalDays: $withdrawalDays, substanceCheck: $substanceCheck, evidence: $evidence, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $InventoryLabelResultCopyWith<$Res>  {
  factory $InventoryLabelResultCopyWith(InventoryLabelResult value, $Res Function(InventoryLabelResult) _then) = _$InventoryLabelResultCopyWithImpl;
@useResult
$Res call({
 String? name, String? manufacturerName, String? regulatoryType, String? registrationNumber, String? ingredientsText, String? usageInstructions, bool? containsAntibiotic, double? withdrawalDays, InventorySubstanceCheck? substanceCheck, Map<String, String> evidence, List<String> warnings
});


$InventorySubstanceCheckCopyWith<$Res>? get substanceCheck;

}
/// @nodoc
class _$InventoryLabelResultCopyWithImpl<$Res>
    implements $InventoryLabelResultCopyWith<$Res> {
  _$InventoryLabelResultCopyWithImpl(this._self, this._then);

  final InventoryLabelResult _self;
  final $Res Function(InventoryLabelResult) _then;

/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? manufacturerName = freezed,Object? regulatoryType = freezed,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? usageInstructions = freezed,Object? containsAntibiotic = freezed,Object? withdrawalDays = freezed,Object? substanceCheck = freezed,Object? evidence = null,Object? warnings = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,regulatoryType: freezed == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as double?,substanceCheck: freezed == substanceCheck ? _self.substanceCheck : substanceCheck // ignore: cast_nullable_to_non_nullable
as InventorySubstanceCheck?,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySubstanceCheckCopyWith<$Res>? get substanceCheck {
    if (_self.substanceCheck == null) {
    return null;
  }

  return $InventorySubstanceCheckCopyWith<$Res>(_self.substanceCheck!, (value) {
    return _then(_self.copyWith(substanceCheck: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryLabelResult].
extension InventoryLabelResultPatterns on InventoryLabelResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryLabelResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryLabelResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryLabelResult value)  $default,){
final _that = this;
switch (_that) {
case _InventoryLabelResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryLabelResult value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryLabelResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? manufacturerName,  String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  String? usageInstructions,  bool? containsAntibiotic,  double? withdrawalDays,  InventorySubstanceCheck? substanceCheck,  Map<String, String> evidence,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryLabelResult() when $default != null:
return $default(_that.name,_that.manufacturerName,_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.usageInstructions,_that.containsAntibiotic,_that.withdrawalDays,_that.substanceCheck,_that.evidence,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? manufacturerName,  String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  String? usageInstructions,  bool? containsAntibiotic,  double? withdrawalDays,  InventorySubstanceCheck? substanceCheck,  Map<String, String> evidence,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _InventoryLabelResult():
return $default(_that.name,_that.manufacturerName,_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.usageInstructions,_that.containsAntibiotic,_that.withdrawalDays,_that.substanceCheck,_that.evidence,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? manufacturerName,  String? regulatoryType,  String? registrationNumber,  String? ingredientsText,  String? usageInstructions,  bool? containsAntibiotic,  double? withdrawalDays,  InventorySubstanceCheck? substanceCheck,  Map<String, String> evidence,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _InventoryLabelResult() when $default != null:
return $default(_that.name,_that.manufacturerName,_that.regulatoryType,_that.registrationNumber,_that.ingredientsText,_that.usageInstructions,_that.containsAntibiotic,_that.withdrawalDays,_that.substanceCheck,_that.evidence,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryLabelResult extends InventoryLabelResult {
  const _InventoryLabelResult({this.name, this.manufacturerName, this.regulatoryType, this.registrationNumber, this.ingredientsText, this.usageInstructions, this.containsAntibiotic, this.withdrawalDays, this.substanceCheck, final  Map<String, String> evidence = const <String, String>{}, final  List<String> warnings = const <String>[]}): _evidence = evidence,_warnings = warnings,super._();
  factory _InventoryLabelResult.fromJson(Map<String, dynamic> json) => _$InventoryLabelResultFromJson(json);

@override final  String? name;
@override final  String? manufacturerName;
@override final  String? regulatoryType;
@override final  String? registrationNumber;
@override final  String? ingredientsText;
@override final  String? usageInstructions;
@override final  bool? containsAntibiotic;
@override final  double? withdrawalDays;
@override final  InventorySubstanceCheck? substanceCheck;
 final  Map<String, String> _evidence;
@override@JsonKey() Map<String, String> get evidence {
  if (_evidence is EqualUnmodifiableMapView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_evidence);
}

 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryLabelResultCopyWith<_InventoryLabelResult> get copyWith => __$InventoryLabelResultCopyWithImpl<_InventoryLabelResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryLabelResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryLabelResult&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.regulatoryType, regulatoryType) || other.regulatoryType == regulatoryType)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.usageInstructions, usageInstructions) || other.usageInstructions == usageInstructions)&&(identical(other.containsAntibiotic, containsAntibiotic) || other.containsAntibiotic == containsAntibiotic)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.substanceCheck, substanceCheck) || other.substanceCheck == substanceCheck)&&const DeepCollectionEquality().equals(other._evidence, _evidence)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,manufacturerName,regulatoryType,registrationNumber,ingredientsText,usageInstructions,containsAntibiotic,withdrawalDays,substanceCheck,const DeepCollectionEquality().hash(_evidence),const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'InventoryLabelResult(name: $name, manufacturerName: $manufacturerName, regulatoryType: $regulatoryType, registrationNumber: $registrationNumber, ingredientsText: $ingredientsText, usageInstructions: $usageInstructions, containsAntibiotic: $containsAntibiotic, withdrawalDays: $withdrawalDays, substanceCheck: $substanceCheck, evidence: $evidence, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$InventoryLabelResultCopyWith<$Res> implements $InventoryLabelResultCopyWith<$Res> {
  factory _$InventoryLabelResultCopyWith(_InventoryLabelResult value, $Res Function(_InventoryLabelResult) _then) = __$InventoryLabelResultCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? manufacturerName, String? regulatoryType, String? registrationNumber, String? ingredientsText, String? usageInstructions, bool? containsAntibiotic, double? withdrawalDays, InventorySubstanceCheck? substanceCheck, Map<String, String> evidence, List<String> warnings
});


@override $InventorySubstanceCheckCopyWith<$Res>? get substanceCheck;

}
/// @nodoc
class __$InventoryLabelResultCopyWithImpl<$Res>
    implements _$InventoryLabelResultCopyWith<$Res> {
  __$InventoryLabelResultCopyWithImpl(this._self, this._then);

  final _InventoryLabelResult _self;
  final $Res Function(_InventoryLabelResult) _then;

/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? manufacturerName = freezed,Object? regulatoryType = freezed,Object? registrationNumber = freezed,Object? ingredientsText = freezed,Object? usageInstructions = freezed,Object? containsAntibiotic = freezed,Object? withdrawalDays = freezed,Object? substanceCheck = freezed,Object? evidence = null,Object? warnings = null,}) {
  return _then(_InventoryLabelResult(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,regulatoryType: freezed == regulatoryType ? _self.regulatoryType : regulatoryType // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,usageInstructions: freezed == usageInstructions ? _self.usageInstructions : usageInstructions // ignore: cast_nullable_to_non_nullable
as String?,containsAntibiotic: freezed == containsAntibiotic ? _self.containsAntibiotic : containsAntibiotic // ignore: cast_nullable_to_non_nullable
as bool?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as double?,substanceCheck: freezed == substanceCheck ? _self.substanceCheck : substanceCheck // ignore: cast_nullable_to_non_nullable
as InventorySubstanceCheck?,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as Map<String, String>,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of InventoryLabelResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventorySubstanceCheckCopyWith<$Res>? get substanceCheck {
    if (_self.substanceCheck == null) {
    return null;
  }

  return $InventorySubstanceCheckCopyWith<$Res>(_self.substanceCheck!, (value) {
    return _then(_self.copyWith(substanceCheck: value));
  });
}
}

// dart format on
