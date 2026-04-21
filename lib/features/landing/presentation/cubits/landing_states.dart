import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_states.freezed.dart';

@freezed
class LandingStates<T> with _$LandingStates<T> {
  const factory LandingStates.initial() = _Initial;

  const factory LandingStates.loading() = Loading;

  const factory LandingStates.loaded({required int currentIndex}) = Loaded;

  const factory LandingStates.success(T data) = Success<T>;

  const factory LandingStates.error({required String message}) = Error;
}
