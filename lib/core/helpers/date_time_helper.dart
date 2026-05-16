import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static const List<String> _monthNamesEn = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  static const List<String> _monthNamesAr = [
    "", "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];

  // ── Internal helper ───────────────────────────────────────────────────────

  static bool _isArabic() => Intl.getCurrentLocale().startsWith('ar');

  // ── Relative Time (Facebook-style) ────────────────────────────────────────

  static String toRelativeTime(DateTime? date, {bool? isArabic}) {
    if (date == null) return '';

    final arabic = isArabic ?? _isArabic();
    final now = DateTime.now();
    final local = date.isUtc ? date.toLocal() : date;
    final diff = now.difference(local);

    // ── Future date guard ─────────────────────────────────
    if (diff.isNegative) return arabic ? 'الآن' : 'Just now';

    // ── Just now ──────────────────────────────────────────
    if (diff.inSeconds < 60) return arabic ? 'الآن' : 'Just now';

    // ── Minutes ───────────────────────────────────────────
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      if (arabic) {
        if (m == 1) return 'منذ دقيقة';
        if (m == 2) return 'منذ دقيقتين';
        if (m <= 10) return 'منذ $m دقائق';
        return 'منذ $m دقيقة';
      }
      return '$m ${m == 1 ? 'min' : 'mins'} ago';
    }

    // ── Hours ─────────────────────────────────────────────
    if (diff.inHours < 24) {
      final h = diff.inHours;
      if (arabic) {
        if (h == 1) return 'منذ ساعة';
        if (h == 2) return 'منذ ساعتين';
        if (h <= 10) return 'منذ $h ساعات';
        return 'منذ $h ساعة';
      }
      return '${h}h ago';
    }

    // ── Yesterday ─────────────────────────────────────────
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(local.year, local.month, local.day);
    final daysDiff = today.difference(msgDay).inDays;

    if (daysDiff == 1) return arabic ? 'أمس' : 'Yesterday';

    // ── Same year ─────────────────────────────────────────
    final month = arabic ? _monthNamesAr[local.month] : _monthNamesEn[local.month];
    if (local.year == now.year) return '${local.day} $month';

    // ── Older ─────────────────────────────────────────────
    return '${local.day} $month ${local.year}';
  }

  // ── الـ methods القديمة كما هي ────────────────────────────────────────────

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

  static String formatDateTime(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    return "${formatDate(dateStr, isArabic: isArabic)} • ${formatTime(dateStr, isArabic: isArabic)}";
  }

  static String formatTimeOnly(String? timeStr, {bool isArabic = false}) {
    if (timeStr == null || timeStr.isEmpty) return "";

    final timeParts = timeStr.split(':');
    if (timeParts.length < 2) return timeStr;

    int hour = int.tryParse(timeParts[0]) ?? 0;
    final int minute = int.tryParse(timeParts[1]) ?? 0;

    final String period = hour >= 12
        ? (isArabic ? "م" : "PM")
        : (isArabic ? "ص" : "AM");

    hour = hour % 12 == 0 ? 12 : hour % 12;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  static String formatDateLabel(String? dateStr, {bool isArabic = false}) {
    if (dateStr == null || dateStr.isEmpty) return "";

    final date = DateTime.tryParse(dateStr);
    if (date == null) return "";

    return DateFormat('d MMMM yyyy • h:mm a', isArabic ? 'ar' : 'en').format(date);
  }
}