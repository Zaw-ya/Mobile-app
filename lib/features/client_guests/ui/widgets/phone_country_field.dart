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
/// must carry its own code. Nothing is guessed: a number typed or pasted
/// with its own code of a listed country is split into chip + national
/// number, so the code is never written twice.
class PhoneCountryField extends StatelessWidget {
  const PhoneCountryField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    this.onChanged,
    this.onSplit,
    this.errorText,
    this.isValid = false,
    this.dense = false,
  });

  final TextEditingController controller;
  final PhoneCountry? country;
  final ValueChanged<PhoneCountry?> onCountryChanged;
  final ValueChanged<String>? onChanged;

  /// Called instead of [onCountryChanged] + [onChanged] when a typed
  /// international number was split, so both change in one update.
  final ValueChanged<PhoneFieldValue>? onSplit;
  final String? errorText;
  final bool isValid;
  final bool dense;

  void _onChanged(String text) {
    if (PhoneNumberHelper.hasOwnCode(text)) {
      final split = PhoneNumberHelper.splitForField(text);
      if (split.country != null) {
        controller.value = TextEditingValue(
          text: split.text,
          selection: TextSelection.collapsed(offset: split.text.length),
        );
        if (onSplit != null) {
          onSplit!(split);
        } else {
          onCountryChanged(split.country);
          onChanged?.call(split.text);
        }
        return;
      }
    }
    onChanged?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      style: context.typography.inputText,
      onChanged: _onChanged,
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
          textDirection: TextDirection.ltr,
          children: [
            // Flag + calling code, or a globe while no country is chosen
            if (country == null)
              const Icon(Icons.public_rounded,
                  size: 16, color: AppColor.gray500)
            else
              Text(PhoneNumberHelper.flagOf(country!.region),
                  style: const TextStyle(fontSize: 15)),
            SizedBox(width: edge * 0.2),
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

/// Country list for the chip, in a scroll-controlled sheet capped at 80 %
/// of the screen: search pinned at the top, the groups with headers, and
/// «رقم دولي» last. Stays above the keyboard while searching.
Future<CountryChoice?> showCountryPicker(
    BuildContext context, PhoneCountry? current) {
  return showModalBottomSheet<CountryChoice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColor.primaryLight,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(containerRadius)),
    ),
    builder: (_) => CountryPickerSheet(current: current),
  );
}

class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key, required this.current});

  final PhoneCountry? current;

  /// The scrolling country list (for tests).
  static const Key listKey = ValueKey('country_picker_list');

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final TextEditingController _search = TextEditingController();

  static const _groupKeys = {
    PhoneCountryGroup.arab: 'guests_country_group_arab',
    PhoneCountryGroup.english: 'guests_country_group_english',
    PhoneCountryGroup.europe: 'guests_country_group_europe',
    PhoneCountryGroup.other: 'guests_country_group_other',
  };

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _pick(PhoneCountry? country) =>
      Navigator.of(context).pop(CountryChoice(country));

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final query = _search.text.trim();
    final countries = PhoneCountries.search(query);

    final rows = <Widget>[];
    PhoneCountryGroup? group;
    for (final country in countries) {
      // Group headers only while browsing; search results are one list
      if (query.isEmpty && country.group != group) {
        group = country.group;
        rows.add(_GroupHeader(_groupKeys[group]!.tr()));
      }
      rows.add(_CountryTile(
        flag: PhoneNumberHelper.flagOf(country.region),
        name: country.name(lang),
        code: '+${country.callingCode}',
        selected: country.region == widget.current?.region,
        onTap: () => _pick(country),
      ));
    }
    if (countries.isEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: edge),
        child: Text('guests_no_results_for'.tr(args: [query]),
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium
                .copyWith(color: AppColor.gray500)),
      ));
    }
    rows
      ..add(const Divider(color: AppColor.gray100))
      ..add(_CountryTile(
        name: 'guests_country_international'.tr(),
        code: '',
        selected: widget.current == null,
        onTap: () => _pick(null),
      ));

    return Padding(
      // Keeps the search and the list above the keyboard
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(edge, 0, edge, edge * 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),
              Text('guests_select_country'.tr(),
                  style: context.typography.titleLarge),
              SizedBox(height: edge * 0.4),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                style: context.typography.inputText,
                decoration: guestInputDecoration(
                  context,
                  hint: 'guests_country_search_hint'.tr(),
                  dense: true,
                  prefix: const Icon(Icons.search_rounded,
                      color: AppColor.gray400),
                  suffix: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded,
                              size: 18, color: AppColor.gray500),
                          tooltip: 'guests_clear_search'.tr(),
                          onPressed: () => setState(_search.clear),
                        ),
                ),
              ),
              SizedBox(height: edge * 0.3),
              Flexible(
                child: ListView(
                    key: CountryPickerSheet.listKey,
                    shrinkWrap: true,
                    children: rows),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: edge * 0.6, bottom: edge * 0.2),
      child: Text(title,
          style: context.typography.labelLarge
              .copyWith(color: AppColor.gray600)),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    this.flag,
    required this.name,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String? flag;
  final String name;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_off_rounded,
        color: AppColor.primaryDark,
        size: 20,
      ),
      title: Text(
        flag == null ? name : '$flag  $name',
        style: context.typography.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        code,
        textDirection: TextDirection.ltr,
        style: context.typography.numericSmall,
      ),
      onTap: onTap,
    );
  }
}
