// import 'package:app/core/helpers/app_utilities.dart';
//
// /// Service to handle event check-in/out state management
// class EventCheckService {
//   static const String _checkInStatusKey = 'event_check_in_status_';
//   final AppUtilities _utilities;
//
//   EventCheckService({AppUtilities? utilities})
//       : _utilities = utilities ?? AppUtilities.instance;
//
//   /// Check if a user has already checked in to an event
//   Future<bool> hasCheckedIn(String eventId) async {
//     final status = await _utilities.getSavedBool(_checkInStatusKey + eventId, false);
//     return status;
//   }
//
//   /// Mark an event as checked in
//   Future<void> markAsCheckedIn(String eventId) async {
//     await _utilities.setSavedString("event_id", eventId);
//     await _utilities.setSavedBool(_checkInStatusKey + eventId, true);
//   }
//
//   /// Mark an event as checked out
//   Future<void> markAsCheckedOut(String eventId) async {
//     await _utilities.setSavedBool(_checkInStatusKey + eventId, false);
//   }
//
// }
