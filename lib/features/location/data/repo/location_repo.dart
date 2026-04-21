import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../register/data/models/location_response.dart';
import '../models/city_response.dart';
import '../models/country_response.dart';

class LocationRepo {
  final ApiService _apiService;

  LocationRepo(this._apiService);

  /// Fetch all locations
  Future<ApiResult<List<LocationResponse>>> getLocations() async {
    try {
      final response = await _apiService.getLocations();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  /// Fetch all countries
  Future<ApiResult<List<CountryResponse>>> getCountries() async {
    try {
      final response = await _apiService.getCountries();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  /// Fetch cities for a given country ID
  Future<ApiResult<List<CityResponse>>> getCities(int countryId) async {
    try {
      final response = await _apiService.getCities(countryId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
