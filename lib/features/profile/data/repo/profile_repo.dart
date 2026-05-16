import 'dart:developer';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/profile_model.dart';


class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<ApiResult<ProfileModel>> getProfile() async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getProfile(AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

    Future<ApiResult<ProfileModel>> getGkProfile({required int gatekeeperId}) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getGkProfile(gatekeeperId,AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
