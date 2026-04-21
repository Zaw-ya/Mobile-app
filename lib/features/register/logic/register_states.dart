import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_states.freezed.dart';

@Freezed()
class RegisterStates<T> with _$RegisterStates<T> {
  const factory RegisterStates.initial() = _Initial;
  const factory RegisterStates.loading() = Loading;
  const factory RegisterStates.emptyInput() = EmptyInput;
  const factory RegisterStates.success(T data) = Success<T>;
  const factory RegisterStates.error({required String message}) = Error;
}
