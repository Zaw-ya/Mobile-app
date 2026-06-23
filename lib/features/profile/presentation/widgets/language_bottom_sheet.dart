import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String _selectedLang;
  bool _isAnimating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLang = context.locale.languageCode;
  }

  void _changeLanguage(String langCode) async {
    if (_isAnimating || _selectedLang == langCode) return;

    setState(() {
      _selectedLang = langCode;
      _isAnimating = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      context.setLocale(Locale(langCode));
      setState(() => _isAnimating = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, scrollController) => AnimatedOpacity(
        opacity: _isAnimating ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 400),
        child: AnimatedScale(
          scale: _isAnimating ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 400),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerRadius),
                topRight: Radius.circular(containerRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.all(edge),
            child: Column(
              children: [
                const DragHandle(),
                SizedBox(height: edge * 0.5),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'app_language'.tr(),
                    style: context.typography.titleLarge
                        .copyWith(color: AppColor.primaryDark),
                  ),
                ),
                SizedBox(height: edge * 0.5),
                RadioGroup<String>(
                  groupValue: _selectedLang,
                  onChanged: (value) => _changeLanguage(value ?? ''),
                  child: Column(
                    children: [
                      _LangOption(
                        langCode: 'ar',
                        label: 'arabic'.tr(),
                        selectedLang: _selectedLang,
                        onTap: _changeLanguage,
                      ),
                      SizedBox(height: edge * 0.4),
                      _LangOption(
                        langCode: 'en',
                        label: 'english'.tr(),
                        selectedLang: _selectedLang,
                        onTap: _changeLanguage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.langCode,
    required this.label,
    required this.selectedLang,
    required this.onTap,
  });

  final String langCode;
  final String label;
  final String selectedLang;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedLang == langCode;
    return GestureDetector(
      onTap: () => onTap(langCode),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.5,
          vertical: edge * 0.3,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(
            color: isSelected ? AppColor.primaryDark : AppColor.gray100,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: langCode,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              activeColor: AppColor.primaryDark,
            ),
            SizedBox(width: edge * 0.3),
            Expanded(
              child: Text(
                label,
                style: context.typography.bodyMedium
                    .copyWith(color: AppColor.primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
