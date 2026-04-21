import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_states.freezed.dart';

@Freezed()
class HomeStates<T> with _$HomeStates<T> {
  const factory HomeStates.initial() = _Initial;
  const factory HomeStates.loading() = Loading;
  const factory HomeStates.emptyInput() = EmptyInput;
  const factory HomeStates.success(T data) = Success<T>;
  const factory HomeStates.error({required String message}) = Error;
}
