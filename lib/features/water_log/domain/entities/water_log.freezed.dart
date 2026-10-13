// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterLogPage {
  List<WaterLog> get items;
  int get totalResults;
  bool get hasNextPage;
  String? get nextCursor;
  WaterLogCounts? get counts;

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WaterLogPageCopyWith<WaterLogPage> get copyWith =>
      _$WaterLogPageCopyWithImpl<WaterLogPage>(
        this as WaterLogPage,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WaterLogPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.counts, counts) || other.counts == counts));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(items),
    totalResults,
    hasNextPage,
    nextCursor,
    counts,
  );

  @override
  String toString() {
    return 'WaterLogPage(items: $items, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class $WaterLogPageCopyWith<$Res> {
  factory $WaterLogPageCopyWith(
    WaterLogPage value,
    $Res Function(WaterLogPage) _then,
  ) = _$WaterLogPageCopyWithImpl;
  @useResult
  $Res call({
    List<WaterLog> items,
    int totalResults,
    bool hasNextPage,
    String? nextCursor,
    WaterLogCounts? counts,
  });

  $WaterLogCountsCopyWith<$Res>? get counts;
}

/// @nodoc
class _$WaterLogPageCopyWithImpl<$Res> implements $WaterLogPageCopyWith<$Res> {
  _$WaterLogPageCopyWithImpl(this._self, this._then);

  final WaterLogPage _self;
  final $Res Function(WaterLogPage) _then;

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalResults = null,
    Object? hasNextPage = null,
    Object? nextCursor = freezed,
    Object? counts = freezed,
  }) {
    return _then(
      _self.copyWith(
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<WaterLog>,
        totalResults: null == totalResults
            ? _self.totalResults
            : totalResults // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNextPage: null == hasNextPage
            ? _self.hasNextPage
            : hasNextPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        nextCursor: freezed == nextCursor
            ? _self.nextCursor
            : nextCursor // ignore: cast_nullable_to_non_nullable
                  as String?,
        counts: freezed == counts
            ? _self.counts
            : counts // ignore: cast_nullable_to_non_nullable
                  as WaterLogCounts?,
      ),
    );
  }

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaterLogCountsCopyWith<$Res>? get counts {
    if (_self.counts == null) {
      return null;
    }

    return $WaterLogCountsCopyWith<$Res>(_self.counts!, (value) {
      return _then(_self.copyWith(counts: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WaterLogPage].
extension WaterLogPagePatterns on WaterLogPage {
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
    TResult Function(_WaterLogPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage() when $default != null:
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
    TResult Function(_WaterLogPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage():
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
    TResult? Function(_WaterLogPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage() when $default != null:
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
      List<WaterLog> items,
      int totalResults,
      bool hasNextPage,
      String? nextCursor,
      WaterLogCounts? counts,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage() when $default != null:
        return $default(
          _that.items,
          _that.totalResults,
          _that.hasNextPage,
          _that.nextCursor,
          _that.counts,
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
      List<WaterLog> items,
      int totalResults,
      bool hasNextPage,
      String? nextCursor,
      WaterLogCounts? counts,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage():
        return $default(
          _that.items,
          _that.totalResults,
          _that.hasNextPage,
          _that.nextCursor,
          _that.counts,
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
      List<WaterLog> items,
      int totalResults,
      bool hasNextPage,
      String? nextCursor,
      WaterLogCounts? counts,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WaterLogPage() when $default != null:
        return $default(
          _that.items,
          _that.totalResults,
          _that.hasNextPage,
          _that.nextCursor,
          _that.counts,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WaterLogPage extends WaterLogPage {
  const _WaterLogPage({
    required final List<WaterLog> items,
    required this.totalResults,
    required this.hasNextPage,
    this.nextCursor,
    this.counts,
  }) : _items = items,
       super._();

  final List<WaterLog> _items;
  @override
  List<WaterLog> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int totalResults;
  @override
  final bool hasNextPage;
  @override
  final String? nextCursor;
  @override
  final WaterLogCounts? counts;

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WaterLogPageCopyWith<_WaterLogPage> get copyWith =>
      __$WaterLogPageCopyWithImpl<_WaterLogPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WaterLogPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.counts, counts) || other.counts == counts));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    totalResults,
    hasNextPage,
    nextCursor,
    counts,
  );

  @override
  String toString() {
    return 'WaterLogPage(items: $items, totalResults: $totalResults, hasNextPage: $hasNextPage, nextCursor: $nextCursor, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class _$WaterLogPageCopyWith<$Res>
    implements $WaterLogPageCopyWith<$Res> {
  factory _$WaterLogPageCopyWith(
    _WaterLogPage value,
    $Res Function(_WaterLogPage) _then,
  ) = __$WaterLogPageCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<WaterLog> items,
    int totalResults,
    bool hasNextPage,
    String? nextCursor,
    WaterLogCounts? counts,
  });

  @override
  $WaterLogCountsCopyWith<$Res>? get counts;
}

/// @nodoc
class __$WaterLogPageCopyWithImpl<$Res>
    implements _$WaterLogPageCopyWith<$Res> {
  __$WaterLogPageCopyWithImpl(this._self, this._then);

  final _WaterLogPage _self;
  final $Res Function(_WaterLogPage) _then;

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? totalResults = null,
    Object? hasNextPage = null,
    Object? nextCursor = freezed,
    Object? counts = freezed,
  }) {
    return _then(
      _WaterLogPage(
        items: null == items
            ? _self._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<WaterLog>,
        totalResults: null == totalResults
            ? _self.totalResults
            : totalResults // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNextPage: null == hasNextPage
            ? _self.hasNextPage
            : hasNextPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        nextCursor: freezed == nextCursor
            ? _self.nextCursor
            : nextCursor // ignore: cast_nullable_to_non_nullable
                  as String?,
        counts: freezed == counts
            ? _self.counts
            : counts // ignore: cast_nullable_to_non_nullable
                  as WaterLogCounts?,
      ),
    );
  }

  /// Create a copy of WaterLogPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaterLogCountsCopyWith<$Res>? get counts {
    if (_self.counts == null) {
      return null;
    }

    return $WaterLogCountsCopyWith<$Res>(_self.counts!, (value) {
      return _then(_self.copyWith(counts: value));
    });
  }
}
