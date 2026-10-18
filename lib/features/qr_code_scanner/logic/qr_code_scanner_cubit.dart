import 'dart:convert';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import '../data/models/scan_body_request.dart';
import 'qr_code_scanner_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/qr_code_scanner_repo.dart';

class QrCodeScannerCubit extends Cubit<QrCodeScannerStates> {
  final QrCodeScannerRepo _qrCodeScannerRepo;

  QrCodeScannerCubit(this._qrCodeScannerRepo,)
      : super(const QrCodeScannerStates.initial());



  bool stopScan = false;

  /// True when the last scan was refused for a missing check-in,
  /// so the screen sends the gatekeeper back to check in.
  bool requiresCheckIn = false;



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

  Future<void> scanQrCode(String data, int eventId) async {
    if (stopScan) return;
    stopScan = true;
    _scanEndTime = DateTime.now().toString();
    emit(const QrCodeScannerStates.loading());

    try {
      final response = await _qrCodeScannerRepo
          .scanQrCode(ScanBodyRequest(qrCode: data, eventId: eventId ))
          .timeout(const Duration(seconds: 10));

      response.when(
        success: (response) {
          stopScan = false;
          emit(QrCodeScannerStates.success(response));
        },
        failure: (error) {
          stopScan = false;
          requiresCheckIn = error == QrCodeScannerRepo.checkInRequiredCode ||
              error == QrCodeScannerRepo.checkedOutCode;

          if (error == QrCodeScannerRepo.checkInRequiredCode) {
            emit(QrCodeScannerStates.error(
                message: "scan_error_checkin_required".tr()));
          } else if (error == QrCodeScannerRepo.checkedOutCode) {
            emit(QrCodeScannerStates.error(
                message: "scan_error_checked_out".tr()));
          } else if (error == "scan_error_max_limit") {
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
