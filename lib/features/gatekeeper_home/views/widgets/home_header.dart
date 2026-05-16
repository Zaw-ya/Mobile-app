import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: edge * 2.5, bottom: edge * 1.5, left: edge, right: edge),
      decoration: BoxDecoration(color: AppColor.homeBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: "welcome".tr(),
                color: AppColor.gray700,
                fontSize: 16,
              ),
              TitleText(
                  text:
                      '${AppUtilities().loginData.firstName} ${AppUtilities().loginData.lastName}')
            ],
          ),
          
          /// Due to migirate from scanning process that scan qr code in general way without specify the event id
           
          // GestureDetector(
          //   onTap: () => {context.pushNamed(Routes.qrCodeScreen)},
          //   child: Container(
          //     width: 54,
          //     height: 54,
          //     decoration: BoxDecoration(
          //       color: AppColor.primaryColor.withValues(alpha: .2),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Center(
          //       child: SvgPicture.asset(
          //         Assets.images.qrcode,
          //         width: 28,
          //         height: 28,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
