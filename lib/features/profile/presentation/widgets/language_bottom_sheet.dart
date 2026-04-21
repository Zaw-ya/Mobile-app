import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../../../core/widgets/title_text.dart';


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
      setState(() {
        _isAnimating = false;
      });
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
              color: AppColor.whiteColor,
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
                Row(
                  children: [
                    TitleText(
                      text: "app_language".tr(),
                      color: AppColor.gray900,
                      fontSize: 20,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: edge * 0.5),

                // RadioGroup wraps both radio options
                RadioGroup<String>(
                  groupValue: _selectedLang,
                  onChanged: (value) => _changeLanguage(value ?? ''),
                  child: Column(
                    children: [
                      // Arabic Option
                      GestureDetector(
                        onTap: () => _changeLanguage('ar'),
                        child: Container(
                          margin: EdgeInsets.only(top: edge * 0.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: edge * 0.5,
                            vertical: edge * 0.3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.gray50,
                            borderRadius: BorderRadius.circular(radiusInput),
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'ar',
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                activeColor: AppColor.primaryColor,
                              ),
                              SizedBox(width: edge * 0.3),
                              Expanded(
                                child: NormalText(
                                  text: "arabic".tr(),
                                  color: AppColor.gray900,
                                  fontSize: 18,
                                  align: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // English Option
                      GestureDetector(
                        onTap: () => _changeLanguage('en'),
                        child: Container(
                          margin: EdgeInsets.only(top: edge * 0.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: edge * 0.5,
                            vertical: edge * 0.3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.gray50,
                            borderRadius: BorderRadius.circular(radiusInput),
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'en',
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                activeColor: AppColor.primaryColor,
                              ),
                              SizedBox(width: edge * 0.3),
                              Expanded(
                                child: NormalText(
                                  text: "english".tr(),
                                  color: AppColor.gray900,
                                  fontSize: 18,
                                  align: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
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
