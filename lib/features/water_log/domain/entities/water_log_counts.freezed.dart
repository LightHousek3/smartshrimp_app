// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterLogCounts {
  int get all;
  int get valid;
  int get warning;
  int get voided;

  /// Create a copy of WaterLogCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterLogCountsCopyWith<WaterLogCounts> get copyWith =>
      _$WaterLogCountsCopyWithImpl<WaterLogCounts>(
        this as WaterLogCounts,
        _$identity,
      );

  /// Serializes this WaterLogCounts to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterLogCounts &&
            (identical(other.all, all) || other.all == all) &&
            (identical(other.valid, valid) || other.valid == valid) &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.voided, voided) || other.voided == voided));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, all, valid, warning, voided);

  @override
  String toString() {
    return 'WaterLogCounts(all: $all, valid: $valid, warning: $warning, voided: $voided)';
  }
}

/// @nodoc
abstract mixin class $WaterLogCountsCopyWith<$Res> {
  factory $WaterLogCountsCopyWith(
    WaterLogCounts value,
    $Res Function(WaterLogCounts) _then,
  ) = _$WaterLogCountsCopyWithImpl;
  @useResult
  $Res call({int all, int valid, int warning, int voided});
}

/// @nodoc
class _$WaterLogCountsCopyWithImpl<$Res>
    implements $WaterLogCountsCopyWith<$Res> {
  _$WaterLogCountsCopyWithImpl(this._self, this._then);

  final WaterLogCounts _self;
  final $Res Function(WaterLogCounts) _then;

  /// Create a copy of WaterLogCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? all = null,
    Object? valid = null,
    Object? warning = null,
    Object? voided = null,
  }) {
    return _then(
      _self.copyWith(
        all: null == all
            ? _self.all
            : all // ignore: cast_nullable_to_non_nullable
                  as int,
        valid: null == valid
            ? _self.valid
            : valid // ignore: cast_nullable_to_non_nullable
                  as int,
        warning: null == warning
            ? _self.warning
            : warning // ignore: cast_nullable_to_non_nullable
                  as int,
        voided: null == voided
            ? _self.voided
            : voided // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WaterLogCounts].
extension WaterLogCountsPatterns on WaterLogCounts {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WaterLogCounts value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WaterLogCounts value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WaterLogCounts value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int all, int valid, int warning, int voided)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts() when $default != null:
        return $default(_that.all, _that.valid, _that.warning, _that.voided);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int all, int valid, int warning, int voided) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts():
        return $default(_that.all, _that.valid, _that.warning, _that.voided);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int all, int valid, int warning, int voided)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogCounts() when $default != null:
        return $default(_that.all, _that.valid, _that.warning, _that.voided);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WaterLogCounts extends WaterLogCounts {
  const _WaterLogCounts({
    required this.all,
    required this.valid,
    required this.warning,
    required this.voided,
  }) : super._();
  factory _WaterLogCounts.fromJson(Map<String, dynamic> json) =>
      _$WaterLogCountsFromJson(json);

  @override
  final int all;
  @override
  final int valid;
  @override
  final int warning;
  @override
  final int voided;

  /// Create a copy of WaterLogCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterLogCountsCopyWith<_WaterLogCounts> get copyWith =>
      __$WaterLogCountsCopyWithImpl<_WaterLogCounts>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WaterLogCountsToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterLogCounts &&
            (identical(other.all, all) || other.all == all) &&
            (identical(other.valid, valid) || other.valid == valid) &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.voided, voided) || other.voided == voided));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, all, valid, warning, voided);

  @override
  String toString() {
    return 'WaterLogCounts(all: $all, valid: $valid, warning: $warning, voided: $voided)';
  }
}

/// @nodoc
abstract mixin class _$WaterLogCountsCopyWith<$Res>
    implements $WaterLogCountsCopyWith<$Res> {
  factory _$WaterLogCountsCopyWith(
    _WaterLogCounts value,
    $Res Function(_WaterLogCounts) _then,
  ) = __$WaterLogCountsCopyWithImpl;
  @override
  @useResult
  $Res call({int all, int valid, int warning, int voided});
}

/// @nodoc
class __$WaterLogCountsCopyWithImpl<$Res>
    implements _$WaterLogCountsCopyWith<$Res> {
  __$WaterLogCountsCopyWithImpl(this._self, this._then);

  final _WaterLogCounts _self;
  final $Res Function(_WaterLogCounts) _then;

  /// Create a copy of WaterLogCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? all = null,
    Object? valid = null,
    Object? warning = null,
    Object? voided = null,
  }) {
    return _then(
      _WaterLogCounts(
        all: null == all
            ? _self.all
            : all // ignore: cast_nullable_to_non_nullable
                  as int,
        valid: null == valid
            ? _self.valid
            : valid // ignore: cast_nullable_to_non_nullable
                  as int,
        warning: null == warning
            ? _self.warning
            : warning // ignore: cast_nullable_to_non_nullable
                  as int,
        voided: null == voided
            ? _self.voided
            : voided // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
