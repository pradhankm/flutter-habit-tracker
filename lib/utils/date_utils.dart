class DateUtilsX {
  /// Returns a stable key in YYYY-MM-DD format for a given date.
  static String dayKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Computes a simple streak: consecutive completed days ending today (or yesterday if today not completed).
  static int computeStreak(List<String> completedDates, DateTime now) {
    final set = completedDates.toSet();
    int streak = 0;

    DateTime cursor = now;
    if (!set.contains(dayKey(now))) {
      cursor = now.subtract(const Duration(days: 1));
    }

    while (true) {
      final k = dayKey(cursor);
      if (!set.contains(k)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

/// Backwards-compatible top-level functions.
String todayKey(DateTime now) => DateUtilsX.dayKey(now);

int computeStreak(List<String> completedDates, DateTime now) =>
    DateUtilsX.computeStreak(completedDates, now);
