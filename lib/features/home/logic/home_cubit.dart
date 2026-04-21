// import 'package:app/features/home/logic/home_states.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import '../../../core/helpers/app_utilities.dart';
// import '../../profile/data/models/profile_model.dart';
// import '../data/repo/home_repo.dart';
//
// class HomeCubit extends Cubit<HomeStates> {
//   final HomeRepo _homeRepo;
//
//   HomeCubit(this._homeRepo) : super(const HomeStates.initial());
//
//   void getProfileData() async {
//     // if (!_mounted || isClosed) return;
//     emit(const HomeStates.loading());
//
//     final response = await _homeRepo.getProfile();
//     //if (!_mounted || isClosed) return;
//
//     response.when(success: (response) async {
//       // if (!_mounted || isClosed) return;
//       if (AppUtilities().loginData.roleName != "Client") {
//         await _handleNotificationSetup(response);
//       }
//       // debugPrint('✅ Profile data fetched successfully');
//
//       emit(HomeStates.success(response));
//     }, failure: (error) {
//       //   if (!_mounted || isClosed) return;
//       emit(HomeStates.error(message: error.toString()));
//     });
//   }
//
//   Future<void> _handleNotificationSetup(ProfileModel profile) async {
//     await _storeProfileDataForNotifications(profile);
//     await subscribeToTopic(profile);
//   }
//
//   Future<void> _storeProfileDataForNotifications(
//       ProfileModel profile) async {
//     debugPrint(
//         '🔍 _storeProfileDataForNotifications called for ${profile.userName}');
//     await AppUtilities().setSavedString(
//         'notification_userId', (profile.userId ?? 0).toString());
//     await AppUtilities()
//         .setSavedString('notification_userName', profile.userName ?? '');
//     await AppUtilities()
//         .setSavedString('notification_address', profile.address ?? '');
//     await AppUtilities().setSavedString(
//         'notification_cityId', (profile.cityId ?? 0).toString());
//     debugPrint('✅ Complete notification data updated for user:');
//   }
//
//   Future<void> subscribeToTopic(ProfileModel response) async {
//     //if (!_mounted || isClosed) return;
//
//     final profile = response;
//
//     final topicToSubscribe = profile.cityId.toString();
//     final topicSubscribed = AppUtilities().subscriptionTopic;
//     final msg = FirebaseMessaging.instance;
//
//     try {
//       await _handleTopicSubscription(
//         msg: msg,
//         currentTopic: topicSubscribed,
//         newTopic: topicToSubscribe,
//       );
//     } catch (e) {
//       // if (!_mounted || isClosed) return;
//       debugPrint("Subscription failed: ${e.toString()} ❌");
//     }
//   }
//
//   Future<void> _handleTopicSubscription({
//     required FirebaseMessaging msg,
//     required String currentTopic,
//     required String newTopic,
//   }) async {
//     // If already subscribed to the correct topic, do nothing
//     if (currentTopic == newTopic && currentTopic.isNotEmpty) {
//       debugPrint("Already subscribed to topic: $newTopic ✅");
//       return;
//     }
//
//     // Unsubscribe from old topic if it exists
//     if (currentTopic.isNotEmpty) {
//       await msg.unsubscribeFromTopic(currentTopic);
//       debugPrint("Unsubscribed from previous topic: $currentTopic ❌");
//     }
//
//     // Subscribe to new topic
//     await msg.subscribeToTopic(newTopic);
//     debugPrint(currentTopic.isEmpty
//         ? "Subscribed to topic (first time): $newTopic ✅"
//         : "Subscribed to new topic: $newTopic ✅");
//
//     // Save new topic
//     AppUtilities().subscriptionTopic = newTopic;
//     debugPrint("Updated saved topic: $newTopic 📌");
//   }
//
//   // Future<void> trackNotificationReceived(RemoteMessage message,
//   //     {String appState = 'unknown'}) async {
//   //   try {
//   //     debugPrint('🔔 Tracking $appState notification...');
//   //    // final userData = await _getUserDataForTracking();
//   //
//   //     // final trackingData = {
//   //     //   'userId': userData['userId'],
//   //     //   'userName': userData['userName'],
//   //     //   'location': userData['address'],
//   //     //   'timestamp': DateTime.now().toIso8601String(),
//   //     //   'cityId': userData['cityId'],
//   //     //   'notificationId': message.messageId ?? 'unknown',
//   //     //   'eventTitle':
//   //     //       message.data['eventTitle'] ?? message.notification?.title ?? '',
//   //     //   'notificationType': message.data['type'] ?? 'fcm_notification',
//   //     //   'appState': appState, // foreground, background, terminated
//   //     // };
//   //   } catch (e) {
//   //     debugPrint('❌ Error tracking $appState notification: $e');
//   //   }
//   // }
//
//   /// Gets user data from storage for tracking purposes
//   // static Future<Map<String, dynamic>> _getUserDataForTracking() async {
//   //   try {
//   //     final appUtils = AppUtilities();
//   //
//   //     // Get stored notification data
//   //     final userId = await appUtils.getSavedString('notification_userId', '0');
//   //     final userName =
//   //         await appUtils.getSavedString('notification_userName', '');
//   //     final address = await appUtils.getSavedString('notification_address', '');
//   //     final cityId = await appUtils.getSavedString('notification_cityId', '0');
//   //
//   //     // If we don't have stored notification data, try to get from login data
//   //     final fallbackData = _getFallbackUserData(appUtils);
//   //
//   //     final result = {
//   //       'userId': int.tryParse(userId) ?? fallbackData['userId'] ?? 0,
//   //       'userName':
//   //           userName.isNotEmpty ? userName : fallbackData['userName'] ?? '',
//   //       'address': address.isNotEmpty ? address : fallbackData['address'] ?? '',
//   //       'cityId': int.tryParse(cityId) ?? fallbackData['cityId'] ?? 0,
//   //     };
//   //
//   //     debugPrint(
//   //         '📊 Tracking data - UserId: ${result['userId']}, UserName: ${result['userName']}');
//   //
//   //     return result;
//   //   } catch (e) {
//   //     debugPrint('Error getting user data for tracking: $e');
//   //     return {
//   //       'userId': 0,
//   //       'userName': '',
//   //       'address': '',
//   //       'cityId': 0,
//   //     };
//   //   }
//   // }
//
//   // /// Get fallback user data from login response if notification data isn't available
//   // static Map<String, dynamic> _getFallbackUserData(AppUtilities appUtils) {
//   //   try {
//   //     final loginData = appUtils.loginData;
//   //     // Create display name from firstName and lastName since userName is not in LoginResponse
//   //     String displayName =
//   //         '${loginData.firstName ?? ''} ${loginData.lastName ?? ''}'.trim();
//   //     return {
//   //       'userId': 0, // We don't have userId in login response
//   //       'userName': displayName,
//   //       'address': '', // We don't have address in login response
//   //       'cityId': 0, // We don't have cityId in login response
//   //     };
//   //   } catch (e) {
//   //     debugPrint('Error getting fallback user data: $e');
//   //     return {
//   //       'userId': 0,
//   //       'userName': '',
//   //       'address': '',
//   //       'cityId': 0,
//   //     };
//   //   }
//   // }
//
//   /// Sends tracking data to backend
//   // static Future<void> _sendTrackingToBackend(Map<String, dynamic> data) async {
//   //   // Commented out until you add your backend endpoint and HTTP package
//   //   // try {
//   //   //   final appUtils = AppUtilities();
//   //   //   final token = await appUtils.getSavedString('serverToken', '');
//   //   //
//   //   //   final response = await http.post(
//   //   //     Uri.parse('YOUR_BACKEND_URL/notification-tracking'), // Replace with your endpoint
//   //   //     headers: {
//   //   //       'Content-Type': 'application/json',
//   //   //       'Authorization': token,
//   //   //     },
//   //   //     body: json.encode(data),
//   //   //   ).timeout(const Duration(seconds: 10));
//   //   //
//   //   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //   //     debugPrint('✅ Notification tracking sent successfully');
//   //   //   } else {
//   //   //     debugPrint('❌ Failed to send notification tracking: ${response.statusCode}');
//   //   //   }
//   //   // } catch (e) {
//   //   debugPrint(
//   //       '✅ Notification tracking prepared: ${data['userName']} - ${data['eventTitle']}');
//   //   // }
//   // }
//
//   @override
//   Future<void> close() async {
//     await super.close();
//   }
// }
