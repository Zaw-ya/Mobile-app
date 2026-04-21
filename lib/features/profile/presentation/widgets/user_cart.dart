import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';
import '../../data/models/profile_model.dart';

class UserCart extends StatelessWidget {
  final ProfileModel? profileModel;

  const UserCart({super.key, this.profileModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.homeBackground, AppColor.whiteColor],
            ),
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          child: Container(
            padding: EdgeInsets.all(edge * 0.7),
            margin: EdgeInsets.all(edge * 0.7),
            decoration: BoxDecoration(
              gradient: AppColor.greenGradient,
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
                        color: AppColor.whiteColor.withValues(alpha: 0.2),
                      ),
                      child: SvgPicture.asset(
                        Assets.imagesProfile,
                        colorFilter: ColorFilter.mode(
                            AppColor.whiteColor, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: edge * 0.4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TitleText(
                            text:
                                '${profileModel?.firstName} ${profileModel?.lastName}',
                            fontSize: 18,
                            color: AppColor.gray50,
                          ),
                          NormalText(
                            text: profileModel?.email ?? '',
                            fontSize: 18,
                            color: AppColor.gray50,
                            align: TextAlign.start,
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
                    color: AppColor.whiteColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(radiusInput),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.imagesMarker),
                            SizedBox(width: edge * 0.4),
                            Expanded(
                              child: TitleText(
                                text: '${profileModel?.address}',
                                fontSize: 15,
                                color: AppColor.gray50,
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
                            SvgPicture.asset(Assets.imagesPhone),
                            SizedBox(width: edge * 0.4),
                            NormalText(
                              text: profileModel?.primaryContactNo ?? '',
                              fontSize: 16,
                              color: AppColor.gray50,
                              align: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
