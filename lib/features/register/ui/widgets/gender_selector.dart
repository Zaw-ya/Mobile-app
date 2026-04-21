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
          color: AppColor.gray900,
          fontSize: 16,
        ),
        SizedBox(height: edge * 0.3),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: edge * 0.7,
            vertical: edge * 0.5,
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColor.primaryColor : AppColor.gray400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor,
                    ),
                  ),
                )
                    : null,
              ),
              SizedBox(width: edge * 0.2),
              TitleText(
                text: label,
                color: isSelected ? AppColor.primaryColor : AppColor.gray700,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}