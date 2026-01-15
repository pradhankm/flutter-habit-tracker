import 'package:flutter_habit_tracker/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateUtilsX', () {
    test('sameDay should match dates with same yyyy-mm-dd', () {
      final a = DateTime(2026, 1, 14, 10, 0);
      final b = DateTime(2026, 1, 14, 23, 59);
      expect(DateUtilsX.isSameDay(a, b), isTrue);
    });

    test('todayKey should be stable format', () {
      final d = DateTime(2026, 1, 14);
      expect(DateUtilsX.dayKey(d), equals('2026-01-14'));
    });
  });
}
