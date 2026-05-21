import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/features/gatekeeper_home/views/widgets/event_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../core/widgets/empty_widget.dart';
import '../../../core/widgets/loader.dart';
import '../../events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../events_scan_history/logic/scan_history_states.dart';
import 'widgets/guidelines_invitation_logs.dart';
import 'widgets/home_header.dart';
import 'widgets/upcoming_events_badge.dart';

class GatekeeperHomeScreen extends StatefulWidget {
  const GatekeeperHomeScreen({super.key});

  @override
  State<GatekeeperHomeScreen> createState() => _GatekeeperHomeScreenState();
}

class _GatekeeperHomeScreenState extends State<GatekeeperHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => setFirebase());
    // Pagination: load next page when near bottom
    _scrollController.addListener(_onScroll);
  }

  // void setFirebase() async {
  //   try {
  //     NotificationSettings settings =
  //         await FirebaseMessaging.instance.requestPermission(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //       try {
  //         // Get the token and handle refreshes
  //         String? token = await FirebaseMessaging.instance.getToken();
  //         debugPrint("FCM Token: $token");
  //       } catch (e) {
  //         debugPrint("Error getting APNs token: $e");
  //       }

  //       // Save token to your backend here
  //       // sendTokenToBackend(token);

  //       // Handle token refresh
  //       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  //         // Update token on your backend here
  //       });
  //     }

  //     // Set up message handlers
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //       final notification = message.notification;
  //       if (notification != null) {
  //         NotificationService().showNotificationWithActions(
  //           id: message.messageId.hashCode,
  //           title: notification.title ?? "",
  //           body: notification.body ?? "",
  //           payload: message.data.toString(),
  //         );
  //       }
  //     });

  //     // Check for initial message (app opened from terminated state)
  //     FirebaseMessaging.instance
  //         .getInitialMessage()
  //         .then((RemoteMessage? message) {
  //       if (message != null) {
  //         debugPrint(
  //             "App opened from terminated state with message: ${message.messageId}");
  //         // Handle the initial message - perhaps navigate to a specific screen
  //       }
  //     });

  //     // Handle message when app is in background but opened
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       debugPrint(
  //           "App opened from background state with message: ${message.messageId}");
  //       // Handle the message - perhaps navigate to a specific screen
  //     });
  //   } catch (e) {
  //     debugPrint("FCM setup error: $e");
  //   }
  // }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<GatekeeperEventsCubit>()
          .getGatekeeperEvents(isNextPage: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
      builder: (context, state) {
        final isLoading = state is LoadingScanHistory;
        final isLoadingMore = state.maybeWhen(
          success: (_, isLoadingMore) => isLoadingMore,
          orElse: () => false,
        );
        final events = context.read<GatekeeperEventsCubit>().currentEvents;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            key: ValueKey(currentLocale.languageCode),
            backgroundColor: AppColor.whiteColor,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(),
                  GuidelinesInvitationLogs(),
                  SizedBox(height: heightEdge),
                  UpcomingEventsBadge(eventsNumber: events.length),
                  // SizedBox(height: edge * 0.1),

                  // ── States ──────────────────────────────────────────────
                  state.maybeWhen(
                    emptyInput: () => EmptyWidget(),
                    error: (message) => _ErrorWidget(message: message),
                    orElse: () => _EventsList(
                      events: events,
                      isLoadingMore: isLoadingMore,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Sub-Widgets ──────────────────────────────────────────────────────────────

class _EventsList extends StatelessWidget {
  const _EventsList({
    required this.events,
    required this.isLoadingMore,
  });

  final List<EventsList> events;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (_, __) => SizedBox(height: heightEdge),
          itemBuilder: (context, index) => EventCard(event: events[index]),
        ),
        if (isLoadingMore) ...[
          SizedBox(height: edge),
          Center(child: Loader(color: AppColor.primaryColor)),
          SizedBox(height: edge),
        ],
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: edge * 3, horizontal: edge),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: edge),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            SizedBox(height: edge),
            ElevatedButton(
              onPressed: () =>
                  context.read<GatekeeperEventsCubit>().getGatekeeperEvents(),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
