import 'dart:convert';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import '../data/models/scan_body_request.dart';
import 'qr_code_scanner_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/qr_code_scanner_repo.dart';

class QrCodeScannerCubit extends Cubit<QrCodeScannerStates> {
  final QrCodeScannerRepo _qrCodeScannerRepo;

  QrCodeScannerCubit(this._qrCodeScannerRepo)
      : super(const QrCodeScannerStates.initial());



  bool stopScan = false;



  String? _scanStartTime;
  String get scanStartTime => _scanStartTime ?? '';
  set scanStartTime(String value) {
    _scanStartTime = value;
  }

  String? _scanEndTime;
  String get scanEndTime => _scanEndTime ?? '';
  set scanEndTime(String value) {
    _scanEndTime = value;
  }

  bool isValidBase64(String str) {
    try {
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> scanQrCode(String data) async {
    if (stopScan) return;
    stopScan = true;
    _scanEndTime = DateTime.now().toString();
    emit(const QrCodeScannerStates.loading());

    try {
      final response = await _qrCodeScannerRepo
          .scanQrCode(ScanBodyRequest(qrCode: data))
          .timeout(const Duration(seconds: 10));

      response.when(
        success: (response) {
          stopScan = false;
          emit(QrCodeScannerStates.success(response));
        },
        failure: (error) {
          stopScan = false;

          if (error == "scan_error_max_limit") {
            emit(QrCodeScannerStates.error(
                message: "scan_error_scanned_before".tr()));
          } else if (error == "scan_error_scanned_before") {
            emit(QrCodeScannerStates.error(
                message: "scan_error_scanned_before".tr()));
          } else {
            emit(QrCodeScannerStates.error(message: error.toString()));
          }
        },
      );
    } catch (e) {
      stopScan = false;
      emit(QrCodeScannerStates.error(message: "some_error".tr()));
    }
  }

  void reloadPage() {
    emit(const QrCodeScannerStates.loading());
    stopScan = false;
    emit(const QrCodeScannerStates.initial());
  }
}
