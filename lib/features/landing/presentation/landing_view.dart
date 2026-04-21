import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/handle_pop_invoked.dart';
import '../../../generated/assets.dart';
import 'cubits/landing_cubit.dart';
import 'cubits/landing_states.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LandingCubit>();
    final currentLocale = context.locale;

    return BlocBuilder<LandingCubit, LandingStates>(
      buildWhen: (prev, current) => prev != current,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            // Check if current index is home (index 0)
            if (cubit.currentIndex != 0) {
              // Not at home, navigate to home
              cubit.changeIndex(0);
            } else {
              // At home, show exit dialog
              await handleOnPopInvokedWithResult(context, didPop, result);
            }
          },
          child: Scaffold(
            body: PageView(
              controller: cubit.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: cubit.onPageChanged,
              children: cubit.screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              key: ValueKey(currentLocale.languageCode),
              elevation: 8,
              currentIndex: cubit.currentIndex,
              onTap: cubit.changeIndex,
              selectedItemColor: AppColor.primaryColor,
              unselectedItemColor: AppColor.gray200,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColor.whiteColor,
              iconSize: 24,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              selectedIconTheme: IconThemeData(size: 24),
              unselectedIconTheme: IconThemeData(size: 24),
              items: cubit.isOrganizer
                  ? _buildOrganizerNavItems(cubit)
                  : _buildUserNavItems(cubit),
            ),
          ),
        );
      },
    );
  }
}

List<BottomNavigationBarItem> _buildOrganizerNavItems(LandingCubit cubit) {
  return [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 0 ? Assets.imagesHomeActive : Assets.imagesHome,
      ),
      label: "home".tr(),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 1
            ? Assets.imagesCalendarActive
            : Assets.imagesCalendar,
      ),
      label: 'calendar'.tr(),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 2
            ? Assets.imagesProfileActive
            : Assets.imagesProfile,
      ),
      label: 'profile'.tr(),
    ),
  ];
}

List<BottomNavigationBarItem> _buildUserNavItems(LandingCubit cubit) {
  return [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 0
            ? Assets.imagesCalendarActive
            : Assets.imagesCalendar,
      ),
      label: "my_events".tr(),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 1
            ? Assets.imagesStatisticsActive
            : Assets.imagesStatistics,
      ),
      label: 'statistics'.tr(),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        cubit.currentIndex == 2
            ? Assets.imagesProfileActive
            : Assets.imagesProfile,
      ),
      label: 'profile'.tr(),
    ),
  ];
}
