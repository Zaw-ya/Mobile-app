import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: 'gender'.tr(),
          color: AppColor.gray700,
          fontSize: 14,
        ),
        SizedBox(height: edge * 0.4),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                value: 'm',
                label: 'male'.tr(),
                isSelected: selectedGender == 'm',
                onTap: () => onGenderChanged('m'),
              ),
            ),
            SizedBox(width: edge * 0.4),
            Expanded(
              child: _GenderOption(
                value: 'f',
                label: 'female'.tr(),
                isSelected: selectedGender == 'f',
                onTap: () => onGenderChanged('f'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String value;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: edge * 0.6,
          vertical: edge * 0.55,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryDark : AppColor.gray300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryLight
                      : AppColor.gray400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryLight,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: edge * 0.3),
            TitleText(
              text: label,
              color: isSelected ? AppColor.primaryLight : AppColor.gray700,
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
