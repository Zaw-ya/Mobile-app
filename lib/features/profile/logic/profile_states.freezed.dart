// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileStates {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStatesCopyWith<$Res> {
  factory $ProfileStatesCopyWith(
          ProfileStates value, $Res Function(ProfileStates) then) =
      _$ProfileStatesCopyWithImpl<$Res, ProfileStates>;
}

/// @nodoc
class _$ProfileStatesCopyWithImpl<$Res, $Val extends ProfileStates>
    implements $ProfileStatesCopyWith<$Res> {
  _$ProfileStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ProfileStates.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ProfileStates {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ProfileStates.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements ProfileStates {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$EmptyInputImplCopyWith<$Res> {
  factory _$$EmptyInputImplCopyWith(
          _$EmptyInputImpl value, $Res Function(_$EmptyInputImpl) then) =
      __$$EmptyInputImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyInputImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$EmptyInputImpl>
    implements _$$EmptyInputImplCopyWith<$Res> {
  __$$EmptyInputImplCopyWithImpl(
      _$EmptyInputImpl _value, $Res Function(_$EmptyInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyInputImpl implements EmptyInput {
  const _$EmptyInputImpl();

  @override
  String toString() {
    return 'ProfileStates.emptyInput()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyInputImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return emptyInput();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return emptyInput?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return emptyInput(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return emptyInput?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (emptyInput != null) {
      return emptyInput(this);
    }
    return orElse();
  }
}

abstract class EmptyInput implements ProfileStates {
  const factory EmptyInput() = _$EmptyInputImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProfileModel data});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SuccessImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ProfileModel,
    ));
  }
}

/// @nodoc

class _$SuccessImpl implements Success {
  const _$SuccessImpl(this.data);

  @override
  final ProfileModel data;

  @override
  String toString() {
    return 'ProfileStates.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success implements ProfileStates {
  const factory Success(final ProfileModel data) = _$SuccessImpl;

  ProfileModel get data;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ProfileStates.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements ProfileStates {
  const factory Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetGatekeeperLoadingImplCopyWith<$Res> {
  factory _$$GetGatekeeperLoadingImplCopyWith(_$GetGatekeeperLoadingImpl value,
          $Res Function(_$GetGatekeeperLoadingImpl) then) =
      __$$GetGatekeeperLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetGatekeeperLoadingImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$GetGatekeeperLoadingImpl>
    implements _$$GetGatekeeperLoadingImplCopyWith<$Res> {
  __$$GetGatekeeperLoadingImplCopyWithImpl(_$GetGatekeeperLoadingImpl _value,
      $Res Function(_$GetGatekeeperLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetGatekeeperLoadingImpl implements GetGatekeeperLoading {
  const _$GetGatekeeperLoadingImpl();

  @override
  String toString() {
    return 'ProfileStates.getGatekeeperLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetGatekeeperLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return getGatekeeperLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return getGatekeeperLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperLoading != null) {
      return getGatekeeperLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return getGatekeeperLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return getGatekeeperLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperLoading != null) {
      return getGatekeeperLoading(this);
    }
    return orElse();
  }
}

abstract class GetGatekeeperLoading implements ProfileStates {
  const factory GetGatekeeperLoading() = _$GetGatekeeperLoadingImpl;
}

/// @nodoc
abstract class _$$GetGatekeeperSuccessImplCopyWith<$Res> {
  factory _$$GetGatekeeperSuccessImplCopyWith(_$GetGatekeeperSuccessImpl value,
          $Res Function(_$GetGatekeeperSuccessImpl) then) =
      __$$GetGatekeeperSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ProfileModel data});
}

/// @nodoc
class __$$GetGatekeeperSuccessImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$GetGatekeeperSuccessImpl>
    implements _$$GetGatekeeperSuccessImplCopyWith<$Res> {
  __$$GetGatekeeperSuccessImplCopyWithImpl(_$GetGatekeeperSuccessImpl _value,
      $Res Function(_$GetGatekeeperSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$GetGatekeeperSuccessImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ProfileModel,
    ));
  }
}

/// @nodoc

class _$GetGatekeeperSuccessImpl implements GetGatekeeperSuccess {
  const _$GetGatekeeperSuccessImpl(this.data);

  @override
  final ProfileModel data;

  @override
  String toString() {
    return 'ProfileStates.getGatekeeperSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetGatekeeperSuccessImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetGatekeeperSuccessImplCopyWith<_$GetGatekeeperSuccessImpl>
      get copyWith =>
          __$$GetGatekeeperSuccessImplCopyWithImpl<_$GetGatekeeperSuccessImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return getGatekeeperSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return getGatekeeperSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperSuccess != null) {
      return getGatekeeperSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return getGatekeeperSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return getGatekeeperSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperSuccess != null) {
      return getGatekeeperSuccess(this);
    }
    return orElse();
  }
}

abstract class GetGatekeeperSuccess implements ProfileStates {
  const factory GetGatekeeperSuccess(final ProfileModel data) =
      _$GetGatekeeperSuccessImpl;

  ProfileModel get data;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetGatekeeperSuccessImplCopyWith<_$GetGatekeeperSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetGatekeeperErrorImplCopyWith<$Res> {
  factory _$$GetGatekeeperErrorImplCopyWith(_$GetGatekeeperErrorImpl value,
          $Res Function(_$GetGatekeeperErrorImpl) then) =
      __$$GetGatekeeperErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$GetGatekeeperErrorImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$GetGatekeeperErrorImpl>
    implements _$$GetGatekeeperErrorImplCopyWith<$Res> {
  __$$GetGatekeeperErrorImplCopyWithImpl(_$GetGatekeeperErrorImpl _value,
      $Res Function(_$GetGatekeeperErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$GetGatekeeperErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetGatekeeperErrorImpl implements GetGatekeeperError {
  const _$GetGatekeeperErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ProfileStates.getGatekeeperError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetGatekeeperErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetGatekeeperErrorImplCopyWith<_$GetGatekeeperErrorImpl> get copyWith =>
      __$$GetGatekeeperErrorImplCopyWithImpl<_$GetGatekeeperErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return getGatekeeperError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return getGatekeeperError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperError != null) {
      return getGatekeeperError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return getGatekeeperError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return getGatekeeperError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (getGatekeeperError != null) {
      return getGatekeeperError(this);
    }
    return orElse();
  }
}

abstract class GetGatekeeperError implements ProfileStates {
  const factory GetGatekeeperError({required final String message}) =
      _$GetGatekeeperErrorImpl;

  String get message;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetGatekeeperErrorImplCopyWith<_$GetGatekeeperErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeletingAccountImplCopyWith<$Res> {
  factory _$$DeletingAccountImplCopyWith(_$DeletingAccountImpl value,
          $Res Function(_$DeletingAccountImpl) then) =
      __$$DeletingAccountImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeletingAccountImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$DeletingAccountImpl>
    implements _$$DeletingAccountImplCopyWith<$Res> {
  __$$DeletingAccountImplCopyWithImpl(
      _$DeletingAccountImpl _value, $Res Function(_$DeletingAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeletingAccountImpl implements DeletingAccount {
  const _$DeletingAccountImpl();

  @override
  String toString() {
    return 'ProfileStates.deletingAccount()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeletingAccountImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return deletingAccount();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return deletingAccount?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deletingAccount != null) {
      return deletingAccount();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deletingAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deletingAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deletingAccount != null) {
      return deletingAccount(this);
    }
    return orElse();
  }
}

abstract class DeletingAccount implements ProfileStates {
  const factory DeletingAccount() = _$DeletingAccountImpl;
}

/// @nodoc
abstract class _$$DeleteAccountSuccessImplCopyWith<$Res> {
  factory _$$DeleteAccountSuccessImplCopyWith(_$DeleteAccountSuccessImpl value,
          $Res Function(_$DeleteAccountSuccessImpl) then) =
      __$$DeleteAccountSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteAccountSuccessImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$DeleteAccountSuccessImpl>
    implements _$$DeleteAccountSuccessImplCopyWith<$Res> {
  __$$DeleteAccountSuccessImplCopyWithImpl(_$DeleteAccountSuccessImpl _value,
      $Res Function(_$DeleteAccountSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteAccountSuccessImpl implements DeleteAccountSuccess {
  const _$DeleteAccountSuccessImpl();

  @override
  String toString() {
    return 'ProfileStates.deleteAccountSuccess()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountSuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return deleteAccountSuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return deleteAccountSuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountSuccess != null) {
      return deleteAccountSuccess();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountSuccess != null) {
      return deleteAccountSuccess(this);
    }
    return orElse();
  }
}

abstract class DeleteAccountSuccess implements ProfileStates {
  const factory DeleteAccountSuccess() = _$DeleteAccountSuccessImpl;
}

/// @nodoc
abstract class _$$DeleteAccountErrorImplCopyWith<$Res> {
  factory _$$DeleteAccountErrorImplCopyWith(_$DeleteAccountErrorImpl value,
          $Res Function(_$DeleteAccountErrorImpl) then) =
      __$$DeleteAccountErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DeleteAccountErrorImplCopyWithImpl<$Res>
    extends _$ProfileStatesCopyWithImpl<$Res, _$DeleteAccountErrorImpl>
    implements _$$DeleteAccountErrorImplCopyWith<$Res> {
  __$$DeleteAccountErrorImplCopyWithImpl(_$DeleteAccountErrorImpl _value,
      $Res Function(_$DeleteAccountErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DeleteAccountErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteAccountErrorImpl implements DeleteAccountError {
  const _$DeleteAccountErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ProfileStates.deleteAccountError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountErrorImplCopyWith<_$DeleteAccountErrorImpl> get copyWith =>
      __$$DeleteAccountErrorImplCopyWithImpl<_$DeleteAccountErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() emptyInput,
    required TResult Function(ProfileModel data) success,
    required TResult Function(String message) error,
    required TResult Function() getGatekeeperLoading,
    required TResult Function(ProfileModel data) getGatekeeperSuccess,
    required TResult Function(String message) getGatekeeperError,
    required TResult Function() deletingAccount,
    required TResult Function() deleteAccountSuccess,
    required TResult Function(String message) deleteAccountError,
  }) {
    return deleteAccountError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? emptyInput,
    TResult? Function(ProfileModel data)? success,
    TResult? Function(String message)? error,
    TResult? Function()? getGatekeeperLoading,
    TResult? Function(ProfileModel data)? getGatekeeperSuccess,
    TResult? Function(String message)? getGatekeeperError,
    TResult? Function()? deletingAccount,
    TResult? Function()? deleteAccountSuccess,
    TResult? Function(String message)? deleteAccountError,
  }) {
    return deleteAccountError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? emptyInput,
    TResult Function(ProfileModel data)? success,
    TResult Function(String message)? error,
    TResult Function()? getGatekeeperLoading,
    TResult Function(ProfileModel data)? getGatekeeperSuccess,
    TResult Function(String message)? getGatekeeperError,
    TResult Function()? deletingAccount,
    TResult Function()? deleteAccountSuccess,
    TResult Function(String message)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountError != null) {
      return deleteAccountError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(EmptyInput value) emptyInput,
    required TResult Function(Success value) success,
    required TResult Function(Error value) error,
    required TResult Function(GetGatekeeperLoading value) getGatekeeperLoading,
    required TResult Function(GetGatekeeperSuccess value) getGatekeeperSuccess,
    required TResult Function(GetGatekeeperError value) getGatekeeperError,
    required TResult Function(DeletingAccount value) deletingAccount,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(EmptyInput value)? emptyInput,
    TResult? Function(Success value)? success,
    TResult? Function(Error value)? error,
    TResult? Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult? Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult? Function(GetGatekeeperError value)? getGatekeeperError,
    TResult? Function(DeletingAccount value)? deletingAccount,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(EmptyInput value)? emptyInput,
    TResult Function(Success value)? success,
    TResult Function(Error value)? error,
    TResult Function(GetGatekeeperLoading value)? getGatekeeperLoading,
    TResult Function(GetGatekeeperSuccess value)? getGatekeeperSuccess,
    TResult Function(GetGatekeeperError value)? getGatekeeperError,
    TResult Function(DeletingAccount value)? deletingAccount,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountError != null) {
      return deleteAccountError(this);
    }
    return orElse();
  }
}

abstract class DeleteAccountError implements ProfileStates {
  const factory DeleteAccountError({required final String message}) =
      _$DeleteAccountErrorImpl;

  String get message;

  /// Create a copy of ProfileStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteAccountErrorImplCopyWith<_$DeleteAccountErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
