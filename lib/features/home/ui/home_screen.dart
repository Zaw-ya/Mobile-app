// import 'package:app/core/helpers/app_utilities.dart';
// import 'package:app/core/helpers/extensions.dart';
// import 'package:app/core/routing/routes.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/services/notification_service.dart';
// import '../logic/home_cubit.dart';
// import '../logic/home_states.dart';
// import 'widgets/dashboard_screen.dart';
// import 'widgets/settings.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/theming/colors.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   int selectedScreen = 0;
//
//   List<Widget> screens = [const DashboardScreen(), const SettingsScreen()];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => setFirebase());
//   }
//
//   void setFirebase() async {
//     try {
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         try {
//           // Get the token and handle refreshes
//           String? token = await FirebaseMessaging.instance.getToken();
//           debugPrint("FCM Token: $token");
//         } catch (e) {
//           debugPrint("Error getting APNs token: $e");
//         }
//
//         // Save token to your backend here
//         // sendTokenToBackend(token);
//
//         // Handle token refresh
//         FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//           // Update token on your backend here
//         });
//       }
//
//       // Set up message handlers
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//
//         final notification = message.notification;
//         if (notification != null) {
//           NotificationService().showNotificationWithActions(
//             id: message.messageId.hashCode,
//             title: notification.title ?? "",
//             body: notification.body ?? "",
//             payload: message.data.toString(),
//           );
//         }
//       });
//
//       // Check for initial message (app opened from terminated state)
//       FirebaseMessaging.instance
//           .getInitialMessage()
//           .then((RemoteMessage? message) {
//         if (message != null) {
//           debugPrint(
//               "App opened from terminated state with message: ${message.messageId}");
//           // Handle the initial message - perhaps navigate to a specific screen
//         }
//       });
//
//       // Handle message when app is in background but opened
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         debugPrint(
//             "App opened from background state with message: ${message.messageId}");
//         // Handle the message - perhaps navigate to a specific screen
//       });
//     } catch (e) {
//       debugPrint("FCM setup error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeStates>(
//       buildWhen: (previous, current) => previous != current,
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: bgColor,
//           // appBar: AppBar(),
//           body: body(),
//           floatingActionButton: qrScanButton(),
//           floatingActionButtonLocation:
//               FloatingActionButtonLocation.centerDocked,
//           bottomNavigationBar: bottomNav(),
//         );
//       },
//       // listener: _handleStateChanges
//     );
//   }
//
//   // void _handleStateChanges(BuildContext context, HomeStates state) {
//   //   state.whenOrNull(
//   //
//   //     success: (response) {
//   //      // WidgetsBinding.instance.addPostFrameCallback((_) {
//   //         final profile = response;
//   //
//   //         final topicToSubscribe = profile.cityId.toString();
//   //         final topicSubscribed = AppUtilities().subscriptionTopic;
//   //         final msg = FirebaseMessaging.instance;
//   //         debugPrint('🔍 _storeProfileDataForNotifications called for ');
//   //     //  });
//   //     },
//   //   );
//   // }
//   Widget body() {
//     return screens[selectedScreen];
//   }
//
//   FloatingActionButton qrScanButton() {
//     if (AppUtilities().loginData.roleName == "Client") {
//       return FloatingActionButton(
//           backgroundColor: Colors.transparent, elevation: 0, onPressed: () {});
//     }
//
//     return FloatingActionButton(
//       backgroundColor: primaryColor,
//       shape: const CircleBorder(side: BorderSide(color: bgColor, width: 3)),
//       onPressed: () async {
//         /// if you want to prevent user to scan the qr code until he has checked in
//
//         // String eventId = await AppUtilities.instance.getSavedString("event_id", "");
//         // // Check if user has checked in
//         // final hasCheckedIn = await AppUtilities.instance.getSavedBool('event_check_in_status_$eventId', false);
//         // if (hasCheckedIn) {
//         context.pushNamed(Routes.qrCodeScreen);
//         // } else {
//         //   context.showErrorToast("must_check_in_first".tr());
//         // }
//       },
//       child: const Icon(
//         Icons.qr_code,
//         color: Colors.white,
//       ),
//     );
//   }
//
//   BottomNavigationBar bottomNav() {
//     return BottomNavigationBar(
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       backgroundColor: navBarBackground,
//       onTap: (index) {
//         setState(() {
//           debugPrint("index: $index");
//           selectedScreen = index;
//         });
//       },
//       items: [
//         BottomNavigationBarItem(
//           label: "Dashboard",
//           icon: Icon(
//             Icons.home_rounded,
//             color: selectedScreen == 0
//                 ? Colors.white
//                 : Colors.white.withAlpha(128),
//             size: selectedScreen == 0 ? 30 : 20,
//           ),
//         ),
//         BottomNavigationBarItem(
//             label: "Settings",
//             icon: Icon(
//               Icons.settings_rounded,
//               color: selectedScreen == 1
//                   ? Colors.white
//                   : Colors.white.withAlpha(128),
//               size: selectedScreen == 1 ? 30 : 20,
//             )),
//       ],
//     );
//   }
// }
