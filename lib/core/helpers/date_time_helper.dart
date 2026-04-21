import 'package:easy_localization/easy_localization.dart';

class DateTimeHelper {
  static const List<String> _monthNamesEn = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  static const List<String> _monthNamesAr = [
    "", "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];

  /// Input: "2024-08-15T10:30:00" → Output: "Aug 15, 2024" or "15 أغسطس 2024"
  static String formatDate(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    if (dateStr.length < 10) return "N/A";

    final parts = dateStr.substring(0, 10).split('-');
    if (parts.length != 3) return "N/A";

    final month = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return "N/A";

    final monthName = isArabic ? _monthNamesAr[month] : _monthNamesEn[month];

    return isArabic
        ? "${parts[2]} $monthName ${parts[0]}"
        : "$monthName ${parts[2]}, ${parts[0]}";
  }

  /// Input: "2024-08-15T10:30:00" → Output: "10:30 AM" or "10:30 ص"
  static String formatTime(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";

    final timePart = dateStr.contains('T')
        ? dateStr.split('T').last
        : (dateStr.length > 10 ? dateStr.substring(11) : null);

    if (timePart == null || timePart.length < 5) return "N/A";

    final timeParts = timePart.split(':');
    if (timeParts.length < 2) return "N/A";

    int hour = int.tryParse(timeParts[0]) ?? 0;
    final int minute = int.tryParse(timeParts[1]) ?? 0;

    final String periodEn = hour >= 12 ? "PM" : "AM";
    final String periodAr = hour >= 12 ? "م" : "ص";

    hour = hour % 12 == 0 ? 12 : hour % 12;

    final String period = isArabic ? periodAr : periodEn;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  /// Input: "2024-08-15T10:30:00" → Output: "Aug 15, 2024 • 10:30 AM" or "15 أغسطس 2024 • 10:30 ص"
  static String formatDateTime(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    return "${formatDate(dateStr, isArabic: isArabic)} • ${formatTime(dateStr, isArabic: isArabic)}";
  }

  /// Input: "14:30" or "14:30:00" → Output: "02:30 PM" or "02:30 م"
  static String formatTimeOnly(String? timeStr, {bool isArabic = false}) {
    if (timeStr == null || timeStr.isEmpty) return "";

    final timeParts = timeStr.split(':');
    if (timeParts.length < 2) return timeStr; // return as-is if unrecognized

    int hour = int.tryParse(timeParts[0]) ?? 0;
    final int minute = int.tryParse(timeParts[1]) ?? 0;

    final String period = hour >= 12
        ? (isArabic ? "م" : "PM")
        : (isArabic ? "ص" : "AM");

    hour = hour % 12 == 0 ? 12 : hour % 12;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  /// Input: "2024-08-15T10:30:00" → Output: "15 أغسطس 2024 • 6:00 م" or "15 August 2024 • 6:00 AM"
  static String formatDateLabel(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "";

    final date = DateTime.tryParse(dateStr);
    if (date == null) return "";

    return DateFormat('d MMMM yyyy • h:mm a', isArabic ? 'ar' : 'en').format(date);
  }
}