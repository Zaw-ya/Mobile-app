import 'package:freezed_annotation/freezed_annotation.dart';
part 'client_events_states.freezed.dart';

@Freezed()
class ClientEventsStates<T> with _$ClientEventsStates<T> {
  const factory ClientEventsStates.initial() = _Initial;
  const factory ClientEventsStates.loading() = Loading;
  const factory ClientEventsStates.emptyInput() = EmptyInput;
  const factory ClientEventsStates.success(
    T response, {
    @Default(false) bool isLoadingMore,
  }) = SuccessClientEvents;
  const factory ClientEventsStates.error({required String message}) = Error;
}
