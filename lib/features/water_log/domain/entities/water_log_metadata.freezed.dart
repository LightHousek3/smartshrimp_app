// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterMetricMetadata {
  String get field;
  String get unit;
  double get inputMin;
  double? get inputMax;
  int get scale;
  double? get warningMin;
  double? get warningMax;

  /// Create a copy of WaterMetricMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterMetricMetadataCopyWith<WaterMetricMetadata> get copyWith =>
      _$WaterMetricMetadataCopyWithImpl<WaterMetricMetadata>(
        this as WaterMetricMetadata,
        _$identity,
      );

  /// Serializes this WaterMetricMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterMetricMetadata &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.inputMin, inputMin) ||
                other.inputMin == inputMin) &&
            (identical(other.inputMax, inputMax) ||
                other.inputMax == inputMax) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.warningMin, warningMin) ||
                other.warningMin == warningMin) &&
            (identical(other.warningMax, warningMax) ||
                other.warningMax == warningMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    field,
    unit,
    inputMin,
    inputMax,
    scale,
    warningMin,
    warningMax,
  );

  @override
  String toString() {
    return 'WaterMetricMetadata(field: $field, unit: $unit, inputMin: $inputMin, inputMax: $inputMax, scale: $scale, warningMin: $warningMin, warningMax: $warningMax)';
  }
}

/// @nodoc
abstract mixin class $WaterMetricMetadataCopyWith<$Res> {
  factory $WaterMetricMetadataCopyWith(
    WaterMetricMetadata value,
    $Res Function(WaterMetricMetadata) _then,
  ) = _$WaterMetricMetadataCopyWithImpl;
  @useResult
  $Res call({
    String field,
    String unit,
    double inputMin,
    double? inputMax,
    int scale,
    double? warningMin,
    double? warningMax,
  });
}

/// @nodoc
class _$WaterMetricMetadataCopyWithImpl<$Res>
    implements $WaterMetricMetadataCopyWith<$Res> {
  _$WaterMetricMetadataCopyWithImpl(this._self, this._then);

  final WaterMetricMetadata _self;
  final $Res Function(WaterMetricMetadata) _then;

  /// Create a copy of WaterMetricMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? unit = null,
    Object? inputMin = null,
    Object? inputMax = freezed,
    Object? scale = null,
    Object? warningMin = freezed,
    Object? warningMax = freezed,
  }) {
    return _then(
      _self.copyWith(
        field: null == field
            ? _self.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: null == unit
            ? _self.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        inputMin: null == inputMin
            ? _self.inputMin
            : inputMin // ignore: cast_nullable_to_non_nullable
                  as double,
        inputMax: freezed == inputMax
            ? _self.inputMax
            : inputMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        scale: null == scale
            ? _self.scale
            : scale // ignore: cast_nullable_to_non_nullable
                  as int,
        warningMin: freezed == warningMin
            ? _self.warningMin
            : warningMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        warningMax: freezed == warningMax
            ? _self.warningMax
            : warningMax // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WaterMetricMetadata].
extension WaterMetricMetadataPatterns on WaterMetricMetadata {
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
    TResult Function(_WaterMetricMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata() when $default != null:
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
    TResult Function(_WaterMetricMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata():
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
    TResult? Function(_WaterMetricMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata() when $default != null:
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
    TResult Function(
      String field,
      String unit,
      double inputMin,
      double? inputMax,
      int scale,
      double? warningMin,
      double? warningMax,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata() when $default != null:
        return $default(
          _that.field,
          _that.unit,
          _that.inputMin,
          _that.inputMax,
          _that.scale,
          _that.warningMin,
          _that.warningMax,
        );
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
    TResult Function(
      String field,
      String unit,
      double inputMin,
      double? inputMax,
      int scale,
      double? warningMin,
      double? warningMax,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata():
        return $default(
          _that.field,
          _that.unit,
          _that.inputMin,
          _that.inputMax,
          _that.scale,
          _that.warningMin,
          _that.warningMax,
        );
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
    TResult? Function(
      String field,
      String unit,
      double inputMin,
      double? inputMax,
      int scale,
      double? warningMin,
      double? warningMax,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterMetricMetadata() when $default != null:
        return $default(
          _that.field,
          _that.unit,
          _that.inputMin,
          _that.inputMax,
          _that.scale,
          _that.warningMin,
          _that.warningMax,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WaterMetricMetadata extends WaterMetricMetadata {
  const _WaterMetricMetadata({
    required this.field,
    required this.unit,
    required this.inputMin,
    required this.inputMax,
    required this.scale,
    required this.warningMin,
    required this.warningMax,
  }) : super._();
  factory _WaterMetricMetadata.fromJson(Map<String, dynamic> json) =>
      _$WaterMetricMetadataFromJson(json);

  @override
  final String field;
  @override
  final String unit;
  @override
  final double inputMin;
  @override
  final double? inputMax;
  @override
  final int scale;
  @override
  final double? warningMin;
  @override
  final double? warningMax;

  /// Create a copy of WaterMetricMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterMetricMetadataCopyWith<_WaterMetricMetadata> get copyWith =>
      __$WaterMetricMetadataCopyWithImpl<_WaterMetricMetadata>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$WaterMetricMetadataToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterMetricMetadata &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.inputMin, inputMin) ||
                other.inputMin == inputMin) &&
            (identical(other.inputMax, inputMax) ||
                other.inputMax == inputMax) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.warningMin, warningMin) ||
                other.warningMin == warningMin) &&
            (identical(other.warningMax, warningMax) ||
                other.warningMax == warningMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    field,
    unit,
    inputMin,
    inputMax,
    scale,
    warningMin,
    warningMax,
  );

  @override
  String toString() {
    return 'WaterMetricMetadata(field: $field, unit: $unit, inputMin: $inputMin, inputMax: $inputMax, scale: $scale, warningMin: $warningMin, warningMax: $warningMax)';
  }
}

/// @nodoc
abstract mixin class _$WaterMetricMetadataCopyWith<$Res>
    implements $WaterMetricMetadataCopyWith<$Res> {
  factory _$WaterMetricMetadataCopyWith(
    _WaterMetricMetadata value,
    $Res Function(_WaterMetricMetadata) _then,
  ) = __$WaterMetricMetadataCopyWithImpl;
  @override
  @useResult
  $Res call({
    String field,
    String unit,
    double inputMin,
    double? inputMax,
    int scale,
    double? warningMin,
    double? warningMax,
  });
}

/// @nodoc
class __$WaterMetricMetadataCopyWithImpl<$Res>
    implements _$WaterMetricMetadataCopyWith<$Res> {
  __$WaterMetricMetadataCopyWithImpl(this._self, this._then);

  final _WaterMetricMetadata _self;
  final $Res Function(_WaterMetricMetadata) _then;

  /// Create a copy of WaterMetricMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field = null,
    Object? unit = null,
    Object? inputMin = null,
    Object? inputMax = freezed,
    Object? scale = null,
    Object? warningMin = freezed,
    Object? warningMax = freezed,
  }) {
    return _then(
      _WaterMetricMetadata(
        field: null == field
            ? _self.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: null == unit
            ? _self.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        inputMin: null == inputMin
            ? _self.inputMin
            : inputMin // ignore: cast_nullable_to_non_nullable
                  as double,
        inputMax: freezed == inputMax
            ? _self.inputMax
            : inputMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        scale: null == scale
            ? _self.scale
            : scale // ignore: cast_nullable_to_non_nullable
                  as int,
        warningMin: freezed == warningMin
            ? _self.warningMin
            : warningMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        warningMax: freezed == warningMax
            ? _self.warningMax
            : warningMax // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
mixin _$WaterLogMetadata {
  int get schemaVersion;
  String get policyVersion;
  String get shrimpType;
  int get recordedAtFutureToleranceSeconds;
  int get noteMaxLength;
  List<WaterMetricMetadata> get metrics;

  /// Create a copy of WaterLogMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterLogMetadataCopyWith<WaterLogMetadata> get copyWith =>
      _$WaterLogMetadataCopyWithImpl<WaterLogMetadata>(
        this as WaterLogMetadata,
        _$identity,
      );

  /// Serializes this WaterLogMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterLogMetadata &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.policyVersion, policyVersion) ||
                other.policyVersion == policyVersion) &&
            (identical(other.shrimpType, shrimpType) ||
                other.shrimpType == shrimpType) &&
            (identical(
                  other.recordedAtFutureToleranceSeconds,
                  recordedAtFutureToleranceSeconds,
                ) ||
                other.recordedAtFutureToleranceSeconds ==
                    recordedAtFutureToleranceSeconds) &&
            (identical(other.noteMaxLength, noteMaxLength) ||
                other.noteMaxLength == noteMaxLength) &&
            const DeepCollectionEquality().equals(other.metrics, metrics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    schemaVersion,
    policyVersion,
    shrimpType,
    recordedAtFutureToleranceSeconds,
    noteMaxLength,
    const DeepCollectionEquality().hash(metrics),
  );

  @override
  String toString() {
    return 'WaterLogMetadata(schemaVersion: $schemaVersion, policyVersion: $policyVersion, shrimpType: $shrimpType, recordedAtFutureToleranceSeconds: $recordedAtFutureToleranceSeconds, noteMaxLength: $noteMaxLength, metrics: $metrics)';
  }
}

/// @nodoc
abstract mixin class $WaterLogMetadataCopyWith<$Res> {
  factory $WaterLogMetadataCopyWith(
    WaterLogMetadata value,
    $Res Function(WaterLogMetadata) _then,
  ) = _$WaterLogMetadataCopyWithImpl;
  @useResult
  $Res call({
    int schemaVersion,
    String policyVersion,
    String shrimpType,
    int recordedAtFutureToleranceSeconds,
    int noteMaxLength,
    List<WaterMetricMetadata> metrics,
  });
}

/// @nodoc
class _$WaterLogMetadataCopyWithImpl<$Res>
    implements $WaterLogMetadataCopyWith<$Res> {
  _$WaterLogMetadataCopyWithImpl(this._self, this._then);

  final WaterLogMetadata _self;
  final $Res Function(WaterLogMetadata) _then;

  /// Create a copy of WaterLogMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemaVersion = null,
    Object? policyVersion = null,
    Object? shrimpType = null,
    Object? recordedAtFutureToleranceSeconds = null,
    Object? noteMaxLength = null,
    Object? metrics = null,
  }) {
    return _then(
      _self.copyWith(
        schemaVersion: null == schemaVersion
            ? _self.schemaVersion
            : schemaVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        policyVersion: null == policyVersion
            ? _self.policyVersion
            : policyVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        shrimpType: null == shrimpType
            ? _self.shrimpType
            : shrimpType // ignore: cast_nullable_to_non_nullable
                  as String,
        recordedAtFutureToleranceSeconds:
            null == recordedAtFutureToleranceSeconds
            ? _self.recordedAtFutureToleranceSeconds
            : recordedAtFutureToleranceSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        noteMaxLength: null == noteMaxLength
            ? _self.noteMaxLength
            : noteMaxLength // ignore: cast_nullable_to_non_nullable
                  as int,
        metrics: null == metrics
            ? _self.metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<WaterMetricMetadata>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WaterLogMetadata].
extension WaterLogMetadataPatterns on WaterLogMetadata {
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
    TResult Function(_WaterLogMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata() when $default != null:
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
    TResult Function(_WaterLogMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata():
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
    TResult? Function(_WaterLogMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata() when $default != null:
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
    TResult Function(
      int schemaVersion,
      String policyVersion,
      String shrimpType,
      int recordedAtFutureToleranceSeconds,
      int noteMaxLength,
      List<WaterMetricMetadata> metrics,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata() when $default != null:
        return $default(
          _that.schemaVersion,
          _that.policyVersion,
          _that.shrimpType,
          _that.recordedAtFutureToleranceSeconds,
          _that.noteMaxLength,
          _that.metrics,
        );
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
    TResult Function(
      int schemaVersion,
      String policyVersion,
      String shrimpType,
      int recordedAtFutureToleranceSeconds,
      int noteMaxLength,
      List<WaterMetricMetadata> metrics,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata():
        return $default(
          _that.schemaVersion,
          _that.policyVersion,
          _that.shrimpType,
          _that.recordedAtFutureToleranceSeconds,
          _that.noteMaxLength,
          _that.metrics,
        );
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
    TResult? Function(
      int schemaVersion,
      String policyVersion,
      String shrimpType,
      int recordedAtFutureToleranceSeconds,
      int noteMaxLength,
      List<WaterMetricMetadata> metrics,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogMetadata() when $default != null:
        return $default(
          _that.schemaVersion,
          _that.policyVersion,
          _that.shrimpType,
          _that.recordedAtFutureToleranceSeconds,
          _that.noteMaxLength,
          _that.metrics,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WaterLogMetadata extends WaterLogMetadata {
  const _WaterLogMetadata({
    required this.schemaVersion,
    required this.policyVersion,
    required this.shrimpType,
    required this.recordedAtFutureToleranceSeconds,
    required this.noteMaxLength,
    required final List<WaterMetricMetadata> metrics,
  }) : _metrics = metrics,
       super._();
  factory _WaterLogMetadata.fromJson(Map<String, dynamic> json) =>
      _$WaterLogMetadataFromJson(json);

  @override
  final int schemaVersion;
  @override
  final String policyVersion;
  @override
  final String shrimpType;
  @override
  final int recordedAtFutureToleranceSeconds;
  @override
  final int noteMaxLength;
  final List<WaterMetricMetadata> _metrics;
  @override
  List<WaterMetricMetadata> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

  /// Create a copy of WaterLogMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterLogMetadataCopyWith<_WaterLogMetadata> get copyWith =>
      __$WaterLogMetadataCopyWithImpl<_WaterLogMetadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WaterLogMetadataToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterLogMetadata &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.policyVersion, policyVersion) ||
                other.policyVersion == policyVersion) &&
            (identical(other.shrimpType, shrimpType) ||
                other.shrimpType == shrimpType) &&
            (identical(
                  other.recordedAtFutureToleranceSeconds,
                  recordedAtFutureToleranceSeconds,
                ) ||
                other.recordedAtFutureToleranceSeconds ==
                    recordedAtFutureToleranceSeconds) &&
            (identical(other.noteMaxLength, noteMaxLength) ||
                other.noteMaxLength == noteMaxLength) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    schemaVersion,
    policyVersion,
    shrimpType,
    recordedAtFutureToleranceSeconds,
    noteMaxLength,
    const DeepCollectionEquality().hash(_metrics),
  );

  @override
  String toString() {
    return 'WaterLogMetadata(schemaVersion: $schemaVersion, policyVersion: $policyVersion, shrimpType: $shrimpType, recordedAtFutureToleranceSeconds: $recordedAtFutureToleranceSeconds, noteMaxLength: $noteMaxLength, metrics: $metrics)';
  }
}

/// @nodoc
abstract mixin class _$WaterLogMetadataCopyWith<$Res>
    implements $WaterLogMetadataCopyWith<$Res> {
  factory _$WaterLogMetadataCopyWith(
    _WaterLogMetadata value,
    $Res Function(_WaterLogMetadata) _then,
  ) = __$WaterLogMetadataCopyWithImpl;
  @override
  @useResult
  $Res call({
    int schemaVersion,
    String policyVersion,
    String shrimpType,
    int recordedAtFutureToleranceSeconds,
    int noteMaxLength,
    List<WaterMetricMetadata> metrics,
  });
}

/// @nodoc
class __$WaterLogMetadataCopyWithImpl<$Res>
    implements _$WaterLogMetadataCopyWith<$Res> {
  __$WaterLogMetadataCopyWithImpl(this._self, this._then);

  final _WaterLogMetadata _self;
  final $Res Function(_WaterLogMetadata) _then;

  /// Create a copy of WaterLogMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? schemaVersion = null,
    Object? policyVersion = null,
    Object? shrimpType = null,
    Object? recordedAtFutureToleranceSeconds = null,
    Object? noteMaxLength = null,
    Object? metrics = null,
  }) {
    return _then(
      _WaterLogMetadata(
        schemaVersion: null == schemaVersion
            ? _self.schemaVersion
            : schemaVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        policyVersion: null == policyVersion
            ? _self.policyVersion
            : policyVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        shrimpType: null == shrimpType
            ? _self.shrimpType
            : shrimpType // ignore: cast_nullable_to_non_nullable
                  as String,
        recordedAtFutureToleranceSeconds:
            null == recordedAtFutureToleranceSeconds
            ? _self.recordedAtFutureToleranceSeconds
            : recordedAtFutureToleranceSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        noteMaxLength: null == noteMaxLength
            ? _self.noteMaxLength
            : noteMaxLength // ignore: cast_nullable_to_non_nullable
                  as int,
        metrics: null == metrics
            ? _self._metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<WaterMetricMetadata>,
      ),
    );
  }
}
