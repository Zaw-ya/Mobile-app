import 'package:freezed_annotation/freezed_annotation.dart';
part 'qr_code_scanner_states.freezed.dart';

@Freezed()
class QrCodeScannerStates<T> with _$QrCodeScannerStates<T> {
  const factory QrCodeScannerStates.initial() = _Initial;
  const factory QrCodeScannerStates.loading() = Loading;
  const factory QrCodeScannerStates.emptyInput() = EmptyInput;
  const factory QrCodeScannerStates.success(T data) = Success<T>;
  const factory QrCodeScannerStates.error({required String message}) = Error;
}
