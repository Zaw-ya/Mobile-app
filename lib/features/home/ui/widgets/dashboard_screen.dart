import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/app_utilities.dart';

import '../../../../core/theming/colors.dart';
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
        text: "profile".tr(),
        icon: Icons.person,
        gradient: gradient1,
        onTap: () {
          context.pushNamed(Routes.profileScreen);
        },
      ),
      DashboardAction(
        text: "events".tr(),
        icon: Icons.event,
        gradient: containerGradient,
        onTap: () {
          context.pushNamed(Routes.clientEvents);
        },
      ),
      DashboardAction(
        text: "statistics".tr(),
        icon: Icons.bar_chart,
        gradient: gradient3,
        onTap: () {
          context.pushNamed(Routes.clientStatisticsScreen);
        },
      ),
    ];

    _gatekeeperActions = [
      DashboardAction(
        text: "profile".tr(),
        icon: Icons.person,
        gradient: gradient1,
        onTap: () {
          context.pushNamed(Routes.profileScreen);
        },
      ),
      DashboardAction(
        text: "events".tr(),
        icon: Icons.event,
        gradient: containerGradient,
        onTap: () {
          context.pushNamed(Routes.myEventsScreen);
        },
      ),
      DashboardAction(
        text: "events_calendar".tr(),
        icon: Icons.calendar_month,
        gradient: gradient4,
        onTap: () {
          context.pushNamed(Routes.eventsCalendar);
        },
      ),
      DashboardAction(
        text: "scan_history".tr(),
        icon: Icons.history_toggle_off,
        gradient: gradient1,
        onTap: () {
          context.pushNamed(Routes.eventsHistory);
        },
      ),
      DashboardAction(
        text: "event_instructions".tr(),
        icon: Icons.info,
        gradient: containerGradient,
        onTap: () {
          context.pushNamed(Routes.eventInstructionsScreen);
        },
      ),
      // DashboardAction(
      //   text: "Test Notifications",
      //   icon: Icons.info,
      //   gradient: containerGradient,
      //   onTap: () async {
      //     testNotificationScheduling();
      //   },
      // ),
      // DashboardAction(
      //   text: "List Notifications",
      //   icon: Icons.info,
      //   gradient: containerGradient,
      //   onTap: () async {
      //
      //     listPendingNotifications();
      //
      //   },
      // ),
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

  // void testNotificationScheduling() async {
  //
  //   DateTime selectedTime = DateTime.now().add(const Duration(days: 6)); // For testing purposes
  // NotificationScheduler().scheduleNotificationsAtSpecificTime(selectedTime);
  // }
  //
  // Future<void> listPendingNotifications() async {
  //   try {
  //
  //
  //     final List<PendingNotificationRequest> pendingNotifications =await NewNotificationService().getPendingNotifications();
  //
  //   debugPrint('Retrieved pending notifications. Count: ${pendingNotifications.length}');
  //
  //     if (pendingNotifications.isEmpty) {
  //       debugPrint("No pending notifications found.");
  //       return;
  //     }
  //
  //     for (var notification in pendingNotifications) {
  //       debugPrint("----------------------------------------");
  //       debugPrint("Notification ID: ${notification.id}");
  //       debugPrint("Title: ${notification.title}");
  //       debugPrint("Body: ${notification.body}");
  //       debugPrint("Payload: ${notification.payload}");
  //     }
  //   } catch (e) {
  //     debugPrint('Error checking notifications: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: edge),
            _buildHeader(),
            SizedBox(height: edge),
            Expanded(child: _buildActionGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final userData = AppUtilities().loginData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: TitleText(
            text: 'dashboard'.tr(),
            color: Colors.white,
          ),
        ),
        Divider(height: edge, color: bgColorOverlay),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: 'welcomeBack'.tr(),
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              TitleText(
                text:
                    '${'hello'.tr()}: ${userData.firstName} ${userData.lastName}',
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    return Container(
      decoration: const BoxDecoration(
        color: bgColorOverlay,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(edge),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: edge,
          crossAxisSpacing: edge,
        ),
        itemCount: _currentActions.length,
        itemBuilder: (context, index) =>
            _buildActionButton(_currentActions[index]),
      ),
    );
  }

  List<DashboardAction> get _currentActions =>
      AppUtilities().loginData.roleName == "Client"
          ? _clientActions
          : _gatekeeperActions;

  Widget _buildActionButton(DashboardAction action) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: action.onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: action.gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: Colors.white, size: 32),
              const SizedBox(height: 6),
              TitleText(
                text: action.text,
                align: TextAlign.center,
                color: Colors.white,
                fontSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
