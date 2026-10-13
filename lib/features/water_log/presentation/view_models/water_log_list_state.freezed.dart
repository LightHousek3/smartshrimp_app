// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterLogListState {
  WaterLogPage get page;
  bool get loadingMore;
  Object? get paginationError;

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterLogListStateCopyWith<WaterLogListState> get copyWith =>
      _$WaterLogListStateCopyWithImpl<WaterLogListState>(
        this as WaterLogListState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterLogListState &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            const DeepCollectionEquality().equals(
              other.paginationError,
              paginationError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    loadingMore,
    const DeepCollectionEquality().hash(paginationError),
  );

  @override
  String toString() {
    return 'WaterLogListState(page: $page, loadingMore: $loadingMore, paginationError: $paginationError)';
  }
}

/// @nodoc
abstract mixin class $WaterLogListStateCopyWith<$Res> {
  factory $WaterLogListStateCopyWith(
    WaterLogListState value,
    $Res Function(WaterLogListState) _then,
  ) = _$WaterLogListStateCopyWithImpl;
  @useResult
  $Res call({WaterLogPage page, bool loadingMore, Object? paginationError});

  $WaterLogPageCopyWith<$Res> get page;
}

/// @nodoc
class _$WaterLogListStateCopyWithImpl<$Res>
    implements $WaterLogListStateCopyWith<$Res> {
  _$WaterLogListStateCopyWithImpl(this._self, this._then);

  final WaterLogListState _self;
  final $Res Function(WaterLogListState) _then;

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? loadingMore = null,
    Object? paginationError = freezed,
  }) {
    return _then(
      _self.copyWith(
        page: null == page
            ? _self.page
            : page // ignore: cast_nullable_to_non_nullable
                  as WaterLogPage,
        loadingMore: null == loadingMore
            ? _self.loadingMore
            : loadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        paginationError: freezed == paginationError
            ? _self.paginationError
            : paginationError,
      ),
    );
  }

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaterLogPageCopyWith<$Res> get page {
    return $WaterLogPageCopyWith<$Res>(_self.page, (value) {
      return _then(_self.copyWith(page: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WaterLogListState].
extension WaterLogListStatePatterns on WaterLogListState {
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
    TResult Function(_WaterLogListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState() when $default != null:
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
    TResult Function(_WaterLogListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState():
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
    TResult? Function(_WaterLogListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState() when $default != null:
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
      WaterLogPage page,
      bool loadingMore,
      Object? paginationError,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState() when $default != null:
        return $default(_that.page, _that.loadingMore, _that.paginationError);
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
      WaterLogPage page,
      bool loadingMore,
      Object? paginationError,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState():
        return $default(_that.page, _that.loadingMore, _that.paginationError);
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
      WaterLogPage page,
      bool loadingMore,
      Object? paginationError,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogListState() when $default != null:
        return $default(_that.page, _that.loadingMore, _that.paginationError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WaterLogListState implements WaterLogListState {
  const _WaterLogListState({
    required this.page,
    this.loadingMore = false,
    this.paginationError,
  });

  @override
  final WaterLogPage page;
  @override
  @JsonKey()
  final bool loadingMore;
  @override
  final Object? paginationError;

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterLogListStateCopyWith<_WaterLogListState> get copyWith =>
      __$WaterLogListStateCopyWithImpl<_WaterLogListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterLogListState &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            const DeepCollectionEquality().equals(
              other.paginationError,
              paginationError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    loadingMore,
    const DeepCollectionEquality().hash(paginationError),
  );

  @override
  String toString() {
    return 'WaterLogListState(page: $page, loadingMore: $loadingMore, paginationError: $paginationError)';
  }
}

/// @nodoc
abstract mixin class _$WaterLogListStateCopyWith<$Res>
    implements $WaterLogListStateCopyWith<$Res> {
  factory _$WaterLogListStateCopyWith(
    _WaterLogListState value,
    $Res Function(_WaterLogListState) _then,
  ) = __$WaterLogListStateCopyWithImpl;
  @override
  @useResult
  $Res call({WaterLogPage page, bool loadingMore, Object? paginationError});

  @override
  $WaterLogPageCopyWith<$Res> get page;
}

/// @nodoc
class __$WaterLogListStateCopyWithImpl<$Res>
    implements _$WaterLogListStateCopyWith<$Res> {
  __$WaterLogListStateCopyWithImpl(this._self, this._then);

  final _WaterLogListState _self;
  final $Res Function(_WaterLogListState) _then;

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? page = null,
    Object? loadingMore = null,
    Object? paginationError = freezed,
  }) {
    return _then(
      _WaterLogListState(
        page: null == page
            ? _self.page
            : page // ignore: cast_nullable_to_non_nullable
                  as WaterLogPage,
        loadingMore: null == loadingMore
            ? _self.loadingMore
            : loadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        paginationError: freezed == paginationError
            ? _self.paginationError
            : paginationError,
      ),
    );
  }

  /// Create a copy of WaterLogListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaterLogPageCopyWith<$Res> get page {
    return $WaterLogPageCopyWith<$Res>(_self.page, (value) {
      return _then(_self.copyWith(page: value));
    });
  }
}
