import 'dart:developer';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';

import '../../../profile/data/models/profile_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  Future<ApiResult<ProfileModel>> getProfile() async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getProfile(AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
