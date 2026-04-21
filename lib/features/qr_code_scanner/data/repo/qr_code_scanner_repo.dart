import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/scan_body_request.dart';
import '../models/scan_response.dart';

class QrCodeScannerRepo {
  final ApiService _apiService;

  QrCodeScannerRepo(this._apiService);

  Future<ApiResult<ScanResponse>> scanQrCode(
      ScanBodyRequest scanBodyRequest) async {
    try {
      var response = await _apiService.scanQrCode(
          scanBodyRequest, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');

      if (e.response != null) {
        // Extract the `message` field from the response
        final errorMessage = e.response?.data?['message'] ?? "scanned_before";

        // Handle specific messages
        if (errorMessage == "Maximum scan limit exceed") {
          return ApiResult.failure("scan_error_max_limit");
        }
        if (errorMessage == "scanned_before" ||
            errorMessage.contains("Scanned")) {
          return ApiResult.failure("scan_error_scanned_before");
        }

        // Return a fallback error message if no specific match
        return ApiResult.failure(errorMessage);
      }

      // Handle other types of Dio errors
      return ApiResult.failure("scan_failed".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
