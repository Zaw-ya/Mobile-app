import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_states.freezed.dart';

@Freezed()
class ProfileStates<T> with _$ProfileStates<T> {
  const factory ProfileStates.initial() = _Initial;
  const factory ProfileStates.loading() = Loading;
  const factory ProfileStates.emptyInput() = EmptyInput;
  const factory ProfileStates.success(T data) = Success<T>;
  const factory ProfileStates.error({required String message}) = Error;

  const factory ProfileStates.getGatekeeperLoading() = GetGatekeeperLoading;
  const factory ProfileStates.getGatekeeperSuccess(T data) =
      GetGatekeeperSuccess<T>;
  const factory ProfileStates.getGatekeeperError({required String message}) =
      GetGatekeeperError;
}
