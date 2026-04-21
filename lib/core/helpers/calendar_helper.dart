class CalendarHelper {
  CalendarHelper._();

  // ── Localised labels ──────────────────────────────────────────────────────

  /// Column order: Sat=0, Sun=1, Mon=2 … Fri=6  (Arabic/Middle-East week)
  static const arDayNames = [
    'سبت',
    'أحد',
    'اتنين',
    'ثلاثاء',
    'اربعاء',
    'خميس',
    'جمعة',
  ];
  static const enDayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  static const arMonthNames = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  static const enMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // ── Column mapping ────────────────────────────────────────────────────────

  /// Maps Flutter weekday (Mon=1 … Sun=7) → column index (Sat=0 … Fri=6).
  static int weekdayToColumn(int weekday) {
    if (weekday == 6) return 0; // Saturday
    if (weekday == 7) return 1; // Sunday
    return weekday + 1;         // Mon=2 … Fri=6
  }

  // ── Day list builders ─────────────────────────────────────────────────────

  /// Legacy: flat list of nullable day *numbers* for a month grid.
  /// Kept for any existing callers; prefer [buildMonthDateList] for new code.
  static List<int?> buildDayList(DateTime month) {
    final firstWeekday = DateTime(month.year, month.month, 1).weekday;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startColumn = weekdayToColumn(firstWeekday);

    final days = <int?>[...List.filled(startColumn, null)];
    for (int d = 1; d <= daysInMonth; d++) {
      days.add(d);
    }
    while (days.length % 7 != 0) {
      days.add(null);
    }
    return days;
  }

  /// Returns 7 [DateTime?] cells for the week that contains [day],
  /// starting on **Saturday** (column 0).
  static List<DateTime?> buildWeekDateList(DateTime day) {
    final col = weekdayToColumn(day.weekday);
    final saturday = day.subtract(Duration(days: col));
    return List.generate(7, (i) => saturday.add(Duration(days: i)));
  }

  /// Full month grid padded with nulls so every row has exactly 7 cells.
  /// Week starts on **Saturday** (column 0).
  static List<DateTime?> buildMonthDateList(DateTime month) {
    final firstWeekday = DateTime(month.year, month.month, 1).weekday;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startColumn = weekdayToColumn(firstWeekday);

    final days = <DateTime?>[...List.filled(startColumn, null)];
    for (int d = 1; d <= daysInMonth; d++) {
      days.add(DateTime(month.year, month.month, d));
    }
    while (days.length < 42) {
      days.add(null);
    }
    return days;
  }

  // ── Colour helpers ────────────────────────────────────────────────────────

  static int minutesForDay({
    required DateTime month,
    required int day,
    required Map<String, int> data,
  }) =>
      data[_dateKey(month, day)] ?? 0;

  // ── Private ───────────────────────────────────────────────────────────────

  static String _dateKey(DateTime month, int day) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}