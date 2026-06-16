import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/features/notifications/logic/notifications_cubit.dart';
import 'package:app/features/notifications/logic/notifications_states.dart';
import 'package:app/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/helpers/app_utilities.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final userData = AppUtilities().loginData;

    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final int count = state.unreadCount;
        return Container(
          padding: EdgeInsets.only(
              top: 52.h, bottom: 20.h, left: 24.w, right: 24.w),
          color: AppColor.primaryLight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome'.tr(),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColor.gray500),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${userData.firstName} ${userData.lastName}',
                    style: AppTextStyles.headlineLarge,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.notifications),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AppColor.primaryDark,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.svgsNotifications,
                          colorFilter: const ColorFilter.mode(
                              AppColor.primaryLight, BlendMode.srcIn),
                          width: 22.w,
                          height: 22.w,
                        ),
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: -6,
                        right: isArabic ? null : -6,
                        left: isArabic ? -6 : null,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColor.semanticError,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColor.primaryLight, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColor.primaryLight),
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
