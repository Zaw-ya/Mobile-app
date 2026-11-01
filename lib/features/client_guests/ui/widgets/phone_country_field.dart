import 'package:app/core/theming/typography_theme.dart';
// intl (re-exported by easy_localization) has its own TextDirection
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/phone_number_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';
import 'guest_input_decoration.dart';

/// Number field with a country chip. With a country, its calling code is
/// prefixed (the client chose it); with none ("international"), the number
/// must carry its own code. Nothing is guessed.
class PhoneCountryField extends StatelessWidget {
  const PhoneCountryField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    this.onChanged,
    this.errorText,
    this.isValid = false,
    this.dense = false,
  });

  final TextEditingController controller;
  final PhoneCountry? country;
  final ValueChanged<PhoneCountry?> onCountryChanged;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool isValid;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      style: context.typography.inputText,
      onChanged: onChanged,
      decoration: guestInputDecoration(
        context,
        hint: country == null ? '+966 5X XXX XXXX' : '5X XXX XXXX',
        errorText: errorText,
        dense: dense,
        prefix: _CountryChip(
          country: country,
          onTap: () async {
            final picked = await showCountryPicker(context, country);
            if (picked != null) onCountryChanged(picked.country);
          },
        ),
        suffix: isValid
            ? const Icon(Icons.check_rounded,
                color: AppColor.semanticSuccess, size: 18)
            : null,
      ),
    );
  }
}

class _CountryChip extends StatelessWidget {
  const _CountryChip({required this.country, required this.onTap});

  final PhoneCountry? country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(end: edge * 0.4),
        padding: EdgeInsets.symmetric(horizontal: edge * 0.5),
        decoration: const BoxDecoration(
          border: BorderDirectional(end: BorderSide(color: AppColor.gray100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              country == null ? '+' : '+${country!.callingCode}',
              textDirection: TextDirection.ltr,
              style: context.typography.numericSmall
                  .copyWith(color: AppColor.primaryDark),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 16, color: AppColor.gray500),
          ],
        ),
      ),
    );
  }
}

/// The picked country; [country] null means "international number".
class CountryChoice {
  final PhoneCountry? country;

  const CountryChoice(this.country);
}

Future<CountryChoice?> showCountryPicker(
    BuildContext context, PhoneCountry? current) {
  return showModalBottomSheet<CountryChoice>(
    context: context,
    backgroundColor: AppColor.primaryLight,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(containerRadius)),
    ),
    builder: (context) {
      Widget item(PhoneCountry? country, String label) => ListTile(
            title: Text(label, style: context.typography.bodyMedium),
            trailing: Text(
              country == null ? '' : '+${country.callingCode}',
              textDirection: TextDirection.ltr,
              style: context.typography.numericSmall,
            ),
            leading: Icon(
              country?.region == current?.region
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: AppColor.primaryDark,
              size: 20,
            ),
            onTap: () => Navigator.of(context).pop(CountryChoice(country)),
          );

      return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),
              Text('guests_select_country'.tr(),
                  style: context.typography.titleLarge),
              SizedBox(height: edge * 0.4),
              for (final country in PhoneNumberHelper.countries)
                item(country, country.labelKey.tr()),
              item(null, 'guests_country_international'.tr()),
            ],
          ),
        ),
      );
    },
  );
}
