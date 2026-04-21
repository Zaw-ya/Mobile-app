import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/normal_text.dart';
import '../data/models/city_response.dart';
import '../data/models/country_response.dart';
import '../logic/location_cubit.dart';
import '../logic/location_states.dart';

class GatekeeperLocationSelector extends StatelessWidget {
  final Function(CountryResponse) onCountryChange;
  final Function(CityResponse) onCityChange;

  const GatekeeperLocationSelector({
    super.key,
    required this.onCountryChange,
    required this.onCityChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationStates>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildCountryDropdown(
                context,
                state.countries,
                state.selectedCountry,
                state.isCountryLoading,
                state.error,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCityDropdown(
                context,
                state.cities,
                state.selectedCity,
                state.isCityLoading,
                state.error,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountryDropdown(
      BuildContext context,
      List<CountryResponse> countries,
      CountryResponse? selectedCountry,
      bool isLoading,
      String? error,
      ) {
    return _DropdownContainer(
      child: error != null
          ? _buildErrorWidget(
        onRetry: () => context.read<LocationCubit>().fetchCountries(),
      )
          : isLoading
          ? _buildLoader()
          : _buildDropdown<CountryResponse>(
        context: context,
        items: countries,
        selectedValue: selectedCountry,
        onChanged: (value) {
          if (value != null) onCountryChange(value);
        },
        hintText: 'select_country',
      ),
    );
  }

  Widget _buildCityDropdown(
      BuildContext context,
      List<CityResponse> cities,
      CityResponse? selectedCity,
      bool isLoading,
      String? error,
      ) {
    final bool isEnabled =
        context.read<LocationCubit>().selectedCountry != null;

    return _DropdownContainer(
      isEnabled: isEnabled,
      child: error != null
          ? _buildErrorWidget(
        onRetry: () {
          final country =
              context.read<LocationCubit>().selectedCountry;
          if (country != null) {
            context.read<LocationCubit>().setSelectedCountry(country);
          } else {
            context.read<LocationCubit>().fetchCountries();
          }
        },
      )
          : isLoading
          ? _buildLoader()
          : _buildDropdown<CityResponse>(
        context: context,
        items: cities,
        selectedValue: selectedCity,
        onChanged: isEnabled
            ? (value) {
          if (value != null) {
            context.read<LocationCubit>().setSelectedCity(value);
            onCityChange(value);
          }
        }
            : null,
        hintText: 'select_city',
      ),
    );
  }

  // ── Loader ──
  Widget _buildLoader() {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.gray400,
        ),
      ),
    );
  }

  // ── Error with retry button ──
  Widget _buildErrorWidget({required VoidCallback onRetry}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'no_internet'.tr(),
          style: const TextStyle(
            color: AppColor.mainRed,
            fontSize: 11,
          ),
        ),
        GestureDetector(
          onTap: onRetry,
          child: const Icon(
            Icons.refresh_rounded,
            color: AppColor.gray400,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required List<T> items,
    required T? selectedValue,
    required Function(T?)? onChanged,
    required String hintText,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        dropdownColor: AppColor.whiteColor,
        hint: NormalText(
          text: hintText.tr(),
          color: AppColor.gray400,
          fontSize: 12,
        ),
        isExpanded: true,
        value: selectedValue,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColor.gray400,
          size: 22,
        ),
        style: const TextStyle(
          color: AppColor.gray400,
          fontSize: 12,
        ),
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: NormalText(
              text: hintText.tr(),
              color: AppColor.gray400,
              fontSize: 12,
            ),
          ),
          ...items.map((item) {
            final String displayText = item is CountryResponse
                ? item.countryName
                : (item as CityResponse).cityName;
            return DropdownMenuItem<T>(
              value: item,
              child: NormalText(
                text: displayText,
                color: AppColor.gray400,
                fontSize: 12,
              ),
            );
          }),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

// ── Reusable styled container ──
class _DropdownContainer extends StatelessWidget {
  final Widget child;
  final bool isEnabled;

  const _DropdownContainer({
    required this.child,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isEnabled
              ? AppColor.gray400
              : AppColor.gray400.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}