import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/city_response.dart';
import '../data/models/country_response.dart';
import '../data/repo/location_repo.dart';
import 'location_states.dart';

class LocationCubit extends Cubit<LocationStates> {
  final LocationRepo _locationRepo;

  LocationCubit(this._locationRepo) : super(const LocationStates()) {
    fetchCountries();
  }

  CountryResponse? get selectedCountry => state.selectedCountry;

  CityResponse? get selectedCity => state.selectedCity;

  Future<void> fetchCountries() async {
    // ✅ Clear error and show loading first
    emit(state.copyWith(
      error: null,
      isCountryLoading: true,
    ));

    try {
      final result = await _locationRepo.getCountries();
      result.when(
        success: (countries) {
          emit(state.copyWith(
            countries: countries,
            isCountryLoading: false,
          ));
        },
        failure: (_) {
          emit(state.copyWith(
            error: 'connection_error',    
            isCountryLoading: false,
          ));
        },
      );
    } catch (_) {
      emit(state.copyWith(
        error: 'connection_error',
        isCountryLoading: false,
      ));
    }
  }

  Future<void> setSelectedCountry(CountryResponse country) async {
    // ✅ Clear error and show loading first
    emit(state.copyWith(
      selectedCountry: country,
      selectedCity: null,
      isCityLoading: true,
      cities: [],
      error: null, // ✅ clear error so loader shows
    ));

    try {
      final result = await _locationRepo.getCities(country.id);
      result.when(
        success: (cities) {
          emit(state.copyWith(
            cities: cities,
            isCityLoading: false,
          ));
        },
        failure: (_) {
          emit(state.copyWith(
            error: 'connection_error',
            isCityLoading: false,
          ));
        },
      );
    } catch (_) {
      emit(state.copyWith(
        error: 'connection_error',
        isCityLoading: false,
      ));
    }
  }


  void setSelectedCity(CityResponse city) {
    emit(state.copyWith(
      selectedCity: city,
    ));
  }

  void reset() {
    emit(state.copyWith(
      selectedCountry: null,
      selectedCity: null,
      cities: [],
      error: null,
    ));
  }
}
