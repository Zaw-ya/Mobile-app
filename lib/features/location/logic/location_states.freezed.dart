// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocationStates {
  bool get isCountryLoading => throw _privateConstructorUsedError;
  bool get isCityLoading => throw _privateConstructorUsedError;
  List<CountryResponse> get countries => throw _privateConstructorUsedError;
  List<CityResponse> get cities => throw _privateConstructorUsedError;
  CountryResponse? get selectedCountry => throw _privateConstructorUsedError;
  CityResponse? get selectedCity => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of LocationStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationStatesCopyWith<LocationStates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationStatesCopyWith<$Res> {
  factory $LocationStatesCopyWith(
          LocationStates value, $Res Function(LocationStates) then) =
      _$LocationStatesCopyWithImpl<$Res, LocationStates>;
  @useResult
  $Res call(
      {bool isCountryLoading,
      bool isCityLoading,
      List<CountryResponse> countries,
      List<CityResponse> cities,
      CountryResponse? selectedCountry,
      CityResponse? selectedCity,
      String? error});
}

/// @nodoc
class _$LocationStatesCopyWithImpl<$Res, $Val extends LocationStates>
    implements $LocationStatesCopyWith<$Res> {
  _$LocationStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCountryLoading = null,
    Object? isCityLoading = null,
    Object? countries = null,
    Object? cities = null,
    Object? selectedCountry = freezed,
    Object? selectedCity = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isCountryLoading: null == isCountryLoading
          ? _value.isCountryLoading
          : isCountryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCityLoading: null == isCityLoading
          ? _value.isCityLoading
          : isCityLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<CountryResponse>,
      cities: null == cities
          ? _value.cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<CityResponse>,
      selectedCountry: freezed == selectedCountry
          ? _value.selectedCountry
          : selectedCountry // ignore: cast_nullable_to_non_nullable
              as CountryResponse?,
      selectedCity: freezed == selectedCity
          ? _value.selectedCity
          : selectedCity // ignore: cast_nullable_to_non_nullable
              as CityResponse?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationStatesImplCopyWith<$Res>
    implements $LocationStatesCopyWith<$Res> {
  factory _$$LocationStatesImplCopyWith(_$LocationStatesImpl value,
          $Res Function(_$LocationStatesImpl) then) =
      __$$LocationStatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCountryLoading,
      bool isCityLoading,
      List<CountryResponse> countries,
      List<CityResponse> cities,
      CountryResponse? selectedCountry,
      CityResponse? selectedCity,
      String? error});
}

/// @nodoc
class __$$LocationStatesImplCopyWithImpl<$Res>
    extends _$LocationStatesCopyWithImpl<$Res, _$LocationStatesImpl>
    implements _$$LocationStatesImplCopyWith<$Res> {
  __$$LocationStatesImplCopyWithImpl(
      _$LocationStatesImpl _value, $Res Function(_$LocationStatesImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationStates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCountryLoading = null,
    Object? isCityLoading = null,
    Object? countries = null,
    Object? cities = null,
    Object? selectedCountry = freezed,
    Object? selectedCity = freezed,
    Object? error = freezed,
  }) {
    return _then(_$LocationStatesImpl(
      isCountryLoading: null == isCountryLoading
          ? _value.isCountryLoading
          : isCountryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCityLoading: null == isCityLoading
          ? _value.isCityLoading
          : isCityLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      countries: null == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<CountryResponse>,
      cities: null == cities
          ? _value._cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<CityResponse>,
      selectedCountry: freezed == selectedCountry
          ? _value.selectedCountry
          : selectedCountry // ignore: cast_nullable_to_non_nullable
              as CountryResponse?,
      selectedCity: freezed == selectedCity
          ? _value.selectedCity
          : selectedCity // ignore: cast_nullable_to_non_nullable
              as CityResponse?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LocationStatesImpl implements _LocationStates {
  const _$LocationStatesImpl(
      {this.isCountryLoading = true,
      this.isCityLoading = false,
      final List<CountryResponse> countries = const [],
      final List<CityResponse> cities = const [],
      this.selectedCountry,
      this.selectedCity,
      this.error})
      : _countries = countries,
        _cities = cities;

  @override
  @JsonKey()
  final bool isCountryLoading;
  @override
  @JsonKey()
  final bool isCityLoading;
  final List<CountryResponse> _countries;
  @override
  @JsonKey()
  List<CountryResponse> get countries {
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_countries);
  }

  final List<CityResponse> _cities;
  @override
  @JsonKey()
  List<CityResponse> get cities {
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cities);
  }

  @override
  final CountryResponse? selectedCountry;
  @override
  final CityResponse? selectedCity;
  @override
  final String? error;

  @override
  String toString() {
    return 'LocationStates(isCountryLoading: $isCountryLoading, isCityLoading: $isCityLoading, countries: $countries, cities: $cities, selectedCountry: $selectedCountry, selectedCity: $selectedCity, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationStatesImpl &&
            (identical(other.isCountryLoading, isCountryLoading) ||
                other.isCountryLoading == isCountryLoading) &&
            (identical(other.isCityLoading, isCityLoading) ||
                other.isCityLoading == isCityLoading) &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            (identical(other.selectedCountry, selectedCountry) ||
                other.selectedCountry == selectedCountry) &&
            (identical(other.selectedCity, selectedCity) ||
                other.selectedCity == selectedCity) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCountryLoading,
      isCityLoading,
      const DeepCollectionEquality().hash(_countries),
      const DeepCollectionEquality().hash(_cities),
      selectedCountry,
      selectedCity,
      error);

  /// Create a copy of LocationStates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationStatesImplCopyWith<_$LocationStatesImpl> get copyWith =>
      __$$LocationStatesImplCopyWithImpl<_$LocationStatesImpl>(
          this, _$identity);
}

abstract class _LocationStates implements LocationStates {
  const factory _LocationStates(
      {final bool isCountryLoading,
      final bool isCityLoading,
      final List<CountryResponse> countries,
      final List<CityResponse> cities,
      final CountryResponse? selectedCountry,
      final CityResponse? selectedCity,
      final String? error}) = _$LocationStatesImpl;

  @override
  bool get isCountryLoading;
  @override
  bool get isCityLoading;
  @override
  List<CountryResponse> get countries;
  @override
  List<CityResponse> get cities;
  @override
  CountryResponse? get selectedCountry;
  @override
  CityResponse? get selectedCity;
  @override
  String? get error;

  /// Create a copy of LocationStates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationStatesImplCopyWith<_$LocationStatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
