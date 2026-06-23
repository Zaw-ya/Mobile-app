import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../../core/theming/colors.dart';
import '../../../../generated/assets.dart';
import '../../data/models/profile_model.dart';

class UserCart extends StatelessWidget {
  final ProfileModel? profileModel;

  const UserCart({super.key, this.profileModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(edge * 0.7),
      child: Container(
        padding: EdgeInsets.all(edge * 0.8),
        decoration: BoxDecoration(
          color: AppColor.primaryDark,
          borderRadius: BorderRadius.circular(radiusInner),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(edge * 0.8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryLight.withValues(alpha: 0.15),
                  ),
                  child: SvgPicture.asset(
                    Assets.imagesProfile,
                    colorFilter: const ColorFilter.mode(
                      AppColor.primaryLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: edge * 0.4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${profileModel?.firstName} ${profileModel?.lastName}',
                        style: context.typography.titleMedium
                            .copyWith(color: AppColor.primaryLight),
                      ),
                      Text(
                        profileModel?.email ?? '',
                        style: context.typography.bodySmall.copyWith(
                          color: AppColor.primaryLight.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: edge * 0.9),
            Container(
              padding: EdgeInsets.all(edge * 0.8),
              decoration: BoxDecoration(
                color: AppColor.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(radiusInput),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.imagesMarker,
                          colorFilter: const ColorFilter.mode(
                            AppColor.primaryLight,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: edge * 0.4),
                        Expanded(
                          child: Text(
                            '${profileModel?.address}',
                            style: context.typography.bodySmall.copyWith(
                              color: AppColor.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: edge * 0.4),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          Assets.imagesPhone,
                          colorFilter: const ColorFilter.mode(
                            AppColor.primaryLight,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: edge * 0.4),
                        Text(
                          profileModel?.primaryContactNo ?? '',
                          style: context.typography.numericMedium.copyWith(
                            color: AppColor.primaryLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
