// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_statistics_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClientStatisticsStates<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientStatisticsStatesCopyWith<T, $Res> {
  factory $ClientStatisticsStatesCopyWith(ClientStatisticsStates<T> value,
          $Res Function(ClientStatisticsStates<T>) then) =
      _$ClientStatisticsStatesCopyWithImpl<T, $Res, ClientStatisticsStates<T>>;
}

/// @nodoc
class _$ClientStatisticsStatesCopyWithImpl<T, $Res,
        $Val extends ClientStatisticsStates<T>>
    implements $ClientStatisticsStatesCopyWith<T, $Res> {
  _$ClientStatisticsStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<T, $Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl<T> value, $Res Function(_$InitialImpl<T>) then) =
      __$$InitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res, _$InitialImpl<T>>
    implements _$$InitialImplCopyWith<T, $Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl<T> _value, $Res Function(_$InitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl<T> implements _Initial<T> {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial<T> implements ClientStatisticsStates<T> {
  const factory _Initial() = _$InitialImpl<T>;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl<T> value, $Res Function(_$LoadingImpl<T>) then) =
      __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl<T> _value, $Res Function(_$LoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl<T> implements Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements ClientStatisticsStates<T> {
  const factory Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$EmptyInputImplCopyWith<T, $Res> {
  factory _$$EmptyInputImplCopyWith(
          _$EmptyInputImpl<T> value, $Res Function(_$EmptyInputImpl<T>) then) =
      __$$EmptyInputImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$EmptyInputImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res, _$EmptyInputImpl<T>>
    implements _$$EmptyInputImplCopyWith<T, $Res> {
  __$$EmptyInputImplCopyWithImpl(
      _$EmptyInputImpl<T> _value, $Res Function(_$EmptyInputImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyInputImpl<T> implements EmptyInput<T> {
  const _$EmptyInputImpl();

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.emptyInput()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyInputImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return emptyInput();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return emptyInput?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (emptyInput != null) {
      return emptyInput();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return emptyInput(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return emptyInput?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (emptyInput != null) {
      return emptyInput(this);
    }
    return orElse();
  }
}

abstract class EmptyInput<T> implements ClientStatisticsStates<T> {
  const factory EmptyInput() = _$EmptyInputImpl<T>;
}

/// @nodoc
abstract class _$$SuccessClientStatisticsImplCopyWith<T, $Res> {
  factory _$$SuccessClientStatisticsImplCopyWith(
          _$SuccessClientStatisticsImpl<T> value,
          $Res Function(_$SuccessClientStatisticsImpl<T>) then) =
      __$$SuccessClientStatisticsImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T response, bool isLoadingMore});
}

/// @nodoc
class __$$SuccessClientStatisticsImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res,
        _$SuccessClientStatisticsImpl<T>>
    implements _$$SuccessClientStatisticsImplCopyWith<T, $Res> {
  __$$SuccessClientStatisticsImplCopyWithImpl(
      _$SuccessClientStatisticsImpl<T> _value,
      $Res Function(_$SuccessClientStatisticsImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
    Object? isLoadingMore = null,
  }) {
    return _then(_$SuccessClientStatisticsImpl<T>(
      freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as T,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SuccessClientStatisticsImpl<T> implements SuccessClientStatistics<T> {
  const _$SuccessClientStatisticsImpl(this.response,
      {this.isLoadingMore = false});

  @override
  final T response;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.success(response: $response, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessClientStatisticsImpl<T> &&
            const DeepCollectionEquality().equals(other.response, response) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(response), isLoadingMore);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessClientStatisticsImplCopyWith<T, _$SuccessClientStatisticsImpl<T>>
      get copyWith => __$$SuccessClientStatisticsImplCopyWithImpl<T,
          _$SuccessClientStatisticsImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return success(response, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return success?.call(response, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(response, isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SuccessClientStatistics<T> implements ClientStatisticsStates<T> {
  const factory SuccessClientStatistics(final T response,
      {final bool isLoadingMore}) = _$SuccessClientStatisticsImpl<T>;

  T get response;
  bool get isLoadingMore;

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessClientStatisticsImplCopyWith<T, _$SuccessClientStatisticsImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<T, $Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl<T> value, $Res Function(_$ErrorImpl<T>) then) =
      __$$ErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res, _$ErrorImpl<T>>
    implements _$$ErrorImplCopyWith<T, $Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl<T> _value, $Res Function(_$ErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl<T>(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl<T> implements Error<T> {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      __$$ErrorImplCopyWithImpl<T, _$ErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error<T> implements ClientStatisticsStates<T> {
  const factory Error({required final String message}) = _$ErrorImpl<T>;

  String get message;

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessFetchDataImplCopyWith<T, $Res> {
  factory _$$SuccessFetchDataImplCopyWith(_$SuccessFetchDataImpl<T> value,
          $Res Function(_$SuccessFetchDataImpl<T>) then) =
      __$$SuccessFetchDataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$SuccessFetchDataImplCopyWithImpl<T, $Res>
    extends _$ClientStatisticsStatesCopyWithImpl<T, $Res,
        _$SuccessFetchDataImpl<T>>
    implements _$$SuccessFetchDataImplCopyWith<T, $Res> {
  __$$SuccessFetchDataImplCopyWithImpl(_$SuccessFetchDataImpl<T> _value,
      $Res Function(_$SuccessFetchDataImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$SuccessFetchDataImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$SuccessFetchDataImpl<T> implements SuccessFetchData<T> {
  const _$SuccessFetchDataImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'ClientStatisticsStates<$T>.successFetchData(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessFetchDataImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessFetchDataImplCopyWith<T, _$SuccessFetchDataImpl<T>> get copyWith =>
      __$$SuccessFetchDataImplCopyWithImpl<T, _$SuccessFetchDataImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(T response, bool isLoadingMore) success,
    required TResult Function(String message) error,
    required TResult Function(T data) successFetchData,
  }) {
    return successFetchData(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(T response, bool isLoadingMore)? success,
    TResult? Function(String message)? error,
    TResult? Function(T data)? successFetchData,
  }) {
    return successFetchData?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(T response, bool isLoadingMore)? success,
    TResult Function(String message)? error,
    TResult Function(T data)? successFetchData,
    required TResult orElse(),
  }) {
    if (successFetchData != null) {
      return successFetchData(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(EmptyInput<T> value) emptyInput,
    required TResult Function(SuccessClientStatistics<T> value) success,
    required TResult Function(Error<T> value) error,
    required TResult Function(SuccessFetchData<T> value) successFetchData,
  }) {
    return successFetchData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(EmptyInput<T> value)? emptyInput,
    TResult? Function(SuccessClientStatistics<T> value)? success,
    TResult? Function(Error<T> value)? error,
    TResult? Function(SuccessFetchData<T> value)? successFetchData,
  }) {
    return successFetchData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(EmptyInput<T> value)? emptyInput,
    TResult Function(SuccessClientStatistics<T> value)? success,
    TResult Function(Error<T> value)? error,
    TResult Function(SuccessFetchData<T> value)? successFetchData,
    required TResult orElse(),
  }) {
    if (successFetchData != null) {
      return successFetchData(this);
    }
    return orElse();
  }
}

abstract class SuccessFetchData<T> implements ClientStatisticsStates<T> {
  const factory SuccessFetchData(final T data) = _$SuccessFetchDataImpl<T>;

  T get data;

  /// Create a copy of ClientStatisticsStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessFetchDataImplCopyWith<T, _$SuccessFetchDataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
