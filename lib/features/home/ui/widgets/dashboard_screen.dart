import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../generated/assets.gen.dart';
import '../../data/models/dashboard_action.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  late final List<DashboardAction> _clientActions;
  late final List<DashboardAction> _gatekeeperActions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeActions();
  }

  void _initializeActions() {
    _clientActions = [
      DashboardAction(
        text: 'profile'.tr(),
        icon: Icons.person_outline_rounded,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.profileScreen),
      ),
      DashboardAction(
        text: 'events'.tr(),
        icon: Icons.event_outlined,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.clientEvents),
      ),
      DashboardAction(
        text: 'statistics'.tr(),
        icon: Icons.bar_chart_rounded,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.clientStatisticsScreen),
      ),
    ];

    _gatekeeperActions = [
      DashboardAction(
        text: 'profile'.tr(),
        icon: Icons.person_outline_rounded,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.profileScreen),
      ),
      DashboardAction(
        text: 'events'.tr(),
        icon: Icons.event_outlined,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.myEventsScreen),
      ),
      DashboardAction(
        text: 'events_calendar'.tr(),
        icon: Icons.calendar_month_outlined,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.eventsCalendar),
      ),
      DashboardAction(
        text: 'scan_history'.tr(),
        icon: Icons.history_rounded,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.eventsHistory),
      ),
      DashboardAction(
        text: 'event_instructions'.tr(),
        icon: Icons.info_outline_rounded,
        gradient: const LinearGradient(colors: [kNavy, kNavy]),
        onTap: () => context.pushNamed(Routes.eventInstructionsScreen),
      ),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (mounted) setState(() {});
  }

  List<DashboardAction> get _currentActions =>
      AppUtilities().loginData.roleName == 'Client'
          ? _clientActions
          : _gatekeeperActions;

  @override
  Widget build(BuildContext context) {
    final userData = AppUtilities().loginData;

    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcomeBack'.tr(),
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
                  Image.asset(
                    Assets.images.logoSymbolDark.path,
                    height: 44.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            // ── Divider ──────────────────────────────────────────────────
            const Divider(height: 1, color: AppColor.gray200),

            SizedBox(height: 20.h),

            // ── Section label ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'dashboard'.tr(),
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColor.gray500),
              ),
            ),

            SizedBox(height: 12.h),

            // ── Action grid ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                  ),
                  itemCount: _currentActions.length,
                  itemBuilder: (context, index) =>
                      _ActionCard(action: _currentActions[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Card ───────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final DashboardAction action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColor.primaryDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon,
                  color: AppColor.primaryLight, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              action.text,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
