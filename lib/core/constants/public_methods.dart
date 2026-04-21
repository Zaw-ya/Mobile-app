import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../features/events_scan_history/data/models/gatekeeper_events_response.dart';

List<String> months = [
  'Jan',
  'Feb',
  'March',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];

// ============================================
// CORE PARSING FUNCTION WITH MULTIPLE FALLBACKS
// ============================================
DateTime getDateTimeFromString(String dateString) {
  if (dateString.isEmpty) return DateTime.now().toLocal();

  // Strategy 1: Try DateTime.parse() first (handles most ISO 8601 formats)
  try {
    return DateTime.parse(dateString).toLocal();
  } catch (e1) {
    debugPrint('DateTime.parse failed: $e1');

    // Strategy 2: Try DateFormat as fallback
    try {
      final inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
      return inputDateFormat.parse(dateString, true).toLocal();
    } catch (e2) {
      debugPrint('DateFormat parse failed: $e2');

      // Strategy 3: Manual parsing as last resort
      try {
        return _manualDateParse(dateString);
      } catch (e3) {
        debugPrint('Manual parse failed: $e3');
        // Return current time as ultimate fallback
        return DateTime.now().toLocal();
      }
    }
  }
}

// Manual parsing helper (last resort)
DateTime _manualDateParse(String dateString) {
  // Remove timezone info if present
  String cleaned = dateString.split('.')[0].split('+')[0].split('Z')[0];

  // Split by 'T' to separate date and time
  List<String> parts = cleaned.split('T');
  List<String> dateParts = parts[0].split('-');

  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  int hour = 0, minute = 0, second = 0;

  if (parts.length > 1) {
    List<String> timeParts = parts[1].split(':');
    hour = int.parse(timeParts[0]);
    if (timeParts.length > 1) minute = int.parse(timeParts[1]);
    if (timeParts.length > 2) second = int.parse(timeParts[2]);
  }

  return DateTime(year, month, day, hour, minute, second).toLocal();
}

// ============================================
// GET DATE IN WORDS (Already manual - good!)
// ============================================
String getDateInWords(String date) {
  if (date.isEmpty) {
    return "";
  }

  try {
    // Split the date string manually to avoid parsing issues
    List<String> parts = date.split('T')[0].split('-');
    if (parts.length != 3) {
      return "";
    }

    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    // Month names
    List<String> monthNames = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return "${monthNames[month]} $day, $year";
  } catch (e) {
    debugPrint("Manual date format error: $e");
    return "";
  }
}

// ============================================
// GET DATE AND TIME (with fallbacks)
// ============================================
String getDateAndTime(String date) {
  try {
    // Use the robust parsing function
    DateTime dt = getDateTimeFromString(date);

    // List of month names
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    // Format minutes with leading zero if needed
    String minutes = dt.minute.toString().padLeft(2, '0');

    // Format hours (ensure 12-hour format with AM/PM)
    int hour = dt.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour > 12 ? hour - 12 : hour;
    hour = hour == 0 ? 12 : hour; // Convert 0 to 12 for 12 AM

    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minutes $period';
  } catch (e) {
    debugPrint('Error in getDateAndTime: $e');
    return '';
  }
}

// ============================================
// GET TIME IN AM/PM (with fallbacks)
// ============================================
String getTimeInAMPM(String date) {
  try {
    // Use the robust parsing function
    DateTime dt = getDateTimeFromString(date);

    // Manual formatting to avoid DateFormat issues
    String minutes = dt.minute.toString().padLeft(2, '0');
    int hour = dt.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour > 12 ? hour - 12 : hour;
    hour = hour == 0 ? 12 : hour;

    return '$hour:$minutes $period';
  } catch (e) {
    debugPrint('Error in getTimeInAMPM: $e');
    return '';
  }
}

// ============================================
// CAN CHECK IN/OUT (Already uses robust method)
// ============================================
bool canCheckInCheckout(EventsList event) {
  bool result = false;

  DateTime start =
  getDateTimeFromString(event.eventFrom ?? DateTime.now().toString());
  DateTime end =
  getDateTimeFromString(event.eventTo ?? DateTime.now().toString());

  start = DateTime(start.year, start.month, start.day, 0, 0, 0);
  end = DateTime(end.year, end.month, end.day, 23, 59, 59);

  int startInt = start.millisecondsSinceEpoch;
  int endInt = end.millisecondsSinceEpoch;
  int now = DateTime.now().millisecondsSinceEpoch;

  if (now >= startInt && now <= endInt) {
    result = true;
  } else {
    result = false;
  }

  return result;
}