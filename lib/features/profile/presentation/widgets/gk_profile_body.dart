import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/features/profile/data/models/profile_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GkProfileBody extends StatelessWidget {
  const GkProfileBody({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(label: 'role'.tr(), value: profile.role ?? ''),
        _InfoRow(
          label: 'gender'.tr(),
          value: profile.gender == 'M' ? 'male'.tr() : 'female'.tr(),
        ),
        _InfoRow(
          label: 'total_events_assigned'.tr(),
          value: '${profile.totalEventsAssigned}',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: edge * 0.5, left: edge, right: edge),
      padding: EdgeInsets.all(edge * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.typography.bodySmall.copyWith(color: AppColor.gray700),
            ),
          ),
          Text(
            value,
            style: context.typography.titleSmall.copyWith(color: AppColor.primaryDark),
          ),
        ],
      ),
    );
  }
}
