import 'package:freezed_annotation/freezed_annotation.dart';
part 'client_statistics_states.freezed.dart';

@Freezed()
class ClientStatisticsStates<T> with _$ClientStatisticsStates<T> {
  const factory ClientStatisticsStates.initial() = _Initial;
  const factory ClientStatisticsStates.loading() = Loading;
  const factory ClientStatisticsStates.emptyInput() = EmptyInput;
  const factory ClientStatisticsStates.success(
    T response, {
    @Default(false) bool isLoadingMore,
  }) = SuccessClientStatistics;
  const factory ClientStatisticsStates.error({required String message}) = Error;
  const factory ClientStatisticsStates.successFetchData(T data) =
      SuccessFetchData<T>;
}
