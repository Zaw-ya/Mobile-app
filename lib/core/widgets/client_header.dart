import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/features/notifications/logic/notifications_cubit.dart';
import 'package:app/features/notifications/logic/notifications_states.dart';
import 'package:app/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ClientHeader extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const ClientHeader({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    // BlocBuilder to rebuild the Badge when state changing
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final int count = state.unreadCount;

        return Container(
          padding: EdgeInsets.only(
              top: edge * 2.5, bottom: edge, left: edge, right: edge),
          decoration: BoxDecoration(color: AppColor.homeBackground),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                      text: subTitle ?? "",
                      color: AppColor.primaryColor,
                      fontSize: 16),
                  TitleText(
                      text: title ?? "", fontSize: 25, color: AppColor.black),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.notifications),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: SvgPicture.asset(Assets.svgsNotifications,
                            colorFilter: ColorFilter.mode(
                                AppColor.primaryColor, BlendMode.srcIn),
                            width: 28,
                            height: 28),
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        bottom: -6,
                        right: isArabic ? -10 : null,
                        left: isArabic ? null : -10,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 30),
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColor.mainRed,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: AppColor.whiteColor, width: 1.5),
                          ),
                          child: Center(
                            child: TitleText(
                              text: count > 99 ? '99+' : '$count',
                              fontSize: 16,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
