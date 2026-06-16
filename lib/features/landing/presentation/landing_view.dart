import 'package:app/core/di/dependency_injection.dart';
import 'package:app/features/client_events/logic/client_events_cubit.dart';
import 'package:app/features/client_statistics/logic/client_statistics_cubit.dart';
import 'package:app/features/profile/logic/profile_cubit.dart';
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
  const LandingView({
    super.key,
    this.initialIndex = 0,
  });
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<LandingCubit>();
    final currentLocale = context.locale;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LandingCubit>(
          create: (_) => getIt<LandingCubit>(),
        ),
        BlocProvider<ClientStatisticsCubit>(
          create: (_) => getIt<ClientStatisticsCubit>()..getClientEvents(),
        ),
        // BlocProvider<NotificationsCubit>(
        //   create: (_) => getIt<NotificationsCubit>()..loadNotifications(),
        // ),
        BlocProvider<ClientEventsCubit>(
          create: (_) => getIt<ClientEventsCubit>()..getClientEvents(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => getIt<ProfileCubit>(),
        ),
      ],
      child: BlocBuilder<LandingCubit, LandingStates>(
        buildWhen: (prev, current) => prev != current,
        builder: (context, state) {
          final cubit = context.read<LandingCubit>();
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
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  color: AppColor.primaryLight,
                  border: Border(
                    top: BorderSide(color: AppColor.gray200, width: 1),
                  ),
                ),
                child: BottomNavigationBar(
                  key: ValueKey(currentLocale.languageCode),
                  elevation: 0,
                  currentIndex: cubit.currentIndex,
                  onTap: cubit.changeIndex,
                  selectedItemColor: AppColor.primaryDark,
                  unselectedItemColor: AppColor.gray300,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  iconSize: 26,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: cubit.isOrganizer
                      ? _buildOrganizerNavItems(cubit)
                      : _buildUserNavItems(cubit),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<BottomNavigationBarItem> _buildOrganizerNavItems(LandingCubit cubit) {
  return [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesHome,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesHomeActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesCalendar,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesCalendarActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesProfile,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesProfileActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
  ];
}

List<BottomNavigationBarItem> _buildUserNavItems(LandingCubit cubit) {
  return [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesCalendar,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesCalendarActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesStatistics,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesStatisticsActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.imagesProfile,
        colorFilter: const ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        Assets.imagesProfileActive,
        colorFilter: const ColorFilter.mode(AppColor.primaryDark, BlendMode.srcIn),
      ),
      label: '',
    ),
  ];
}
