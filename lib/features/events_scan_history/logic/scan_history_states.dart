import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_history_states.freezed.dart';

@Freezed()
class ScanHistoryStates<T> with _$ScanHistoryStates<T> {
  const factory ScanHistoryStates.initial() = _Initial;
  const factory ScanHistoryStates.loading() = LoadingScanHistory;
  const factory ScanHistoryStates.loadingCheckIn() = LoadingCheckIn;
  const factory ScanHistoryStates.loadingDeleteEvent() = LoadingDeleteEvent;
  const factory ScanHistoryStates.loadingCheckOut() = LoadingCheckOut;
  const factory ScanHistoryStates.emptyInput() = EmptyInputScanHistory;
  const factory ScanHistoryStates.success(
    T response, {
    @Default(false) bool isLoadingMore,
  }) = SuccessScanHistory;
  const factory ScanHistoryStates.error({required String message}) =
      ErrorScanHistory;
  const factory ScanHistoryStates.successCheck(T data) = SuccessCheck<T>;
  const factory ScanHistoryStates.successDeleteEvent(T data) =
      SuccessDeleteEvent<T>;
  const factory ScanHistoryStates.errorCheck({required String message}) =
      ErrorCheck;
  const factory ScanHistoryStates.errorDeleteEvent({required String message}) =
      ErrorDeleteEvent;
}
