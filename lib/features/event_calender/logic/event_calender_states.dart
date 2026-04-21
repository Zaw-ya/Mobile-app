import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/calender_events.dart';
part 'event_calender_states.freezed.dart';

@freezed
class EventCalenderStates with _$EventCalenderStates {
  const factory EventCalenderStates.initial() = _Initial;
  const factory EventCalenderStates.loading() = Loading;
  const factory EventCalenderStates.emptyInput() = EmptyInput;
  const factory EventCalenderStates.success({
    required List<CalenderEventsResponse> events,
    required DateTime selectedDay,
    DateTime? focusedDay,
    List<CalenderEventsResponse>? selectedEvents,
  }) = Success;
  const factory EventCalenderStates.reservationLoading() = ReservationLoading;
  const factory EventCalenderStates.reservationSuccess(String message) =
      ReservationSuccess;
  const factory EventCalenderStates.errorReservation(
      {required String message}) = ErrorReservation;
  const factory EventCalenderStates.error({required String message}) = Error;
}
