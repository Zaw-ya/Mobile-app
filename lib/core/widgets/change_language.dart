import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/theming/app_typography.dart';
import '../../core/theming/colors.dart';
import '../dimensions/dimensions_constants.dart';

class LocaleDropdown extends StatefulWidget {
  final VoidCallback? onLanguageChanged;

  const LocaleDropdown({
    super.key,
    this.onLanguageChanged,
  });

  @override
  State<LocaleDropdown> createState() => _LocaleDropdownState();
}

class _LocaleDropdownState extends State<LocaleDropdown> {
  String? _languageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageCode = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    if (_languageCode == null) return const SizedBox.shrink();

    return InkWell(
      onTap: selectLanguage,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _languageCode == 'en'
                  ? 'assets/images/usflag.png'
                  : 'assets/images/saflag.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void selectLanguage() {
    showModalBottomSheet(
      backgroundColor: AppColor.primaryLight,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    final navigator =
                        Navigator.of(context, rootNavigator: true);
                    final setLocaleContext = context;
                    await setLocaleContext.setLocale(const Locale('en'));
                    if (mounted) {
                      setState(() => _languageCode = 'en');
                      widget.onLanguageChanged?.call();
                      navigator.pop();
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/usflag.png',
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'English',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColor.primaryDark),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final navigator =
                        Navigator.of(context, rootNavigator: true);
                    final setLocaleContext = context;
                    await setLocaleContext.setLocale(const Locale('ar'));
                    if (mounted) {
                      setState(() => _languageCode = 'ar');
                      widget.onLanguageChanged?.call();
                      navigator.pop();
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/saflag.png',
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'عربي',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColor.primaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
