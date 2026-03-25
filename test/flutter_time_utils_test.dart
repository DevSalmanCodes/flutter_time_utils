// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_utils/flutter_time_utils.dart';

void main() {
  // ─────────────────────────────────────────
  // IntDurationExtension
  // ─────────────────────────────────────────
  group('IntDurationExtension', () {
    test('seconds', () {
      expect(5.seconds, const Duration(seconds: 5));
      expect(0.seconds, Duration.zero);
    });
    test('minutes', () => expect(10.minutes, const Duration(minutes: 10)));
    test('hours', () => expect(2.hours, const Duration(hours: 2)));
    test('days', () => expect(3.days, const Duration(days: 3)));
    test('milliseconds', () =>
        expect(500.milliseconds, const Duration(milliseconds: 500)));
    test('arithmetic composes', () =>
        expect(1.hours + 30.minutes, const Duration(hours: 1, minutes: 30)));
  });

  // ─────────────────────────────────────────
  // DurationExtension
  // ─────────────────────────────────────────
  group('DurationExtension', () {
    test('sleep delays approximately correctly', () async {
      final before = DateTime.now();
      await 100.milliseconds.sleep();
      final after = DateTime.now();
      expect(after.difference(before).inMilliseconds, greaterThanOrEqualTo(90));
    });

    test('isLongerThan', () {
      expect(2.minutes.isLongerThan(1.minutes), isTrue);
      expect(1.minutes.isLongerThan(2.minutes), isFalse);
    });

    test('isShorterThan', () =>
        expect(1.seconds.isShorterThan(1.minutes), isTrue));

    group('formatted', () {
      test('seconds only', () => expect(45.seconds.formatted, '45s'));
      test('minutes only', () => expect(5.minutes.formatted, '5m'));
      test('minutes + seconds',
          () => expect((2.minutes + 5.seconds).formatted, '2m 5s'));
      test('hours only', () => expect(2.hours.formatted, '2h'));
      test('hours + minutes',
          () => expect((1.hours + 30.minutes).formatted, '1h 30m'));
      test('days only', () => expect(1.days.formatted, '1d'));
    });

    // ── ago / fromNow ─────────────────────
    group('ago', () {
      test('5.minutes.ago', () => expect(5.minutes.ago, '5 minutes ago'));
      test('1.hours.ago', () => expect(1.hours.ago, '1 hour ago'));
      test('2.days.ago', () => expect(2.days.ago, '2 days ago'));
    });

    group('fromNow', () {
      test('5.minutes.fromNow',
          () => expect(5.minutes.fromNow, 'in 5 minutes'));
      test('3.hours.fromNow', () => expect(3.hours.fromNow, 'in 3 hours'));
      test('2.days.fromNow', () => expect(2.days.fromNow, 'in 2 days'));
    });

    group('agoShort', () {
      test('5.minutes.agoShort', () => expect(5.minutes.agoShort, '5m'));
      test('3.hours.agoShort', () => expect(3.hours.agoShort, '3h'));
      test('2.days.agoShort', () => expect(2.days.agoShort, '2d'));
    });

    group('fromNowShort', () {
      test('2.days.fromNowShort', () => expect(2.days.fromNowShort, '+2d'));
      test('1.hours.fromNowShort', () => expect(1.hours.fromNowShort, '+1h'));
    });
  });

  // ─────────────────────────────────────────
  // Date Formatter
  // ─────────────────────────────────────────
  group('formatDate', () {
    final date = DateTime(2026, 3, 25, 14, 5, 7);

    test('dd MMM yyyy', () => expect(formatDate(date, 'dd MMM yyyy'), '25 Mar 2026'));
    test('MMMM d, yyyy', () => expect(formatDate(date, 'MMMM d, yyyy'), 'March 25, 2026'));
    test('MM/dd/yyyy', () => expect(formatDate(date, 'MM/dd/yyyy'), '03/25/2026'));
    test('yy', () => expect(formatDate(date, 'yy'), '26'));
    test('HH:mm:ss', () => expect(formatDate(date, 'HH:mm:ss'), '14:05:07'));
    test('hh:mm a PM', () => expect(formatDate(date, 'hh:mm a'), '02:05 PM'));
    test('AM case', () {
      final morning = DateTime(2026, 1, 1, 9, 0, 0);
      expect(formatDate(morning, 'hh:mm a'), '09:00 AM');
    });
    test('midnight 12-hour', () {
      final midnight = DateTime(2026, 1, 1, 0, 0, 0);
      expect(formatDate(midnight, 'hh'), '12');
    });
    test('all month abbreviations have length 3', () {
      for (int m = 1; m <= 12; m++) {
        final d = DateTime(2026, m, 1);
        expect(formatDate(d, 'MMM').length, 3);
      }
    });
  });

  // ─────────────────────────────────────────
  // TimeAgoFormatter (new)
  // ─────────────────────────────────────────
  group('TimeAgoFormatter.format', () {
    // Use a fixed reference time so tests are deterministic.
    final ref = DateTime(2026, 3, 25, 12, 0, 0);
    DateTime past(Duration d) => ref.subtract(d);
    DateTime future(Duration d) => ref.add(d);

    // ── Long, numeric (default) ───────────
    group('long numeric (default)', () {
      test('just now < 5s', () => expect(
          TimeAgoFormatter.format(past(const Duration(seconds: 3)), now: ref),
          'Just now'));

      test('30 seconds ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(seconds: 30)), now: ref),
          '30 seconds ago'));

      test('1 minute ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(minutes: 1)), now: ref),
          '1 minute ago'));

      test('45 minutes ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(minutes: 45)), now: ref),
          '45 minutes ago'));

      test('1 hour ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(hours: 1)), now: ref),
          '1 hour ago'));

      test('5 hours ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(hours: 5)), now: ref),
          '5 hours ago'));

      test('1 day ago (numeric)', () => expect(
          TimeAgoFormatter.format(past(const Duration(hours: 25)), now: ref),
          '1 day ago'));

      test('3 days ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 3)), now: ref),
          '3 days ago'));

      test('1 week ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 8)), now: ref),
          '1 week ago'));

      test('3 weeks ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 21)), now: ref),
          '3 weeks ago'));

      test('1 month ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 35)), now: ref),
          '1 month ago'));

      test('2 months ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 65)), now: ref),
          '2 months ago'));

      test('1 year ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 370)), now: ref),
          '1 year ago'));

      test('2 years ago', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 800)), now: ref),
          '2 years ago'));
    });

    // ── Long, non-numeric ─────────────────
    group('long non-numeric', () {
      test('yesterday', () => expect(
          TimeAgoFormatter.format(past(const Duration(hours: 25)),
              numeric: false, now: ref),
          'Yesterday'));

      test('tomorrow', () => expect(
          TimeAgoFormatter.format(future(const Duration(hours: 25)),
              numeric: false, now: ref),
          'Tomorrow'));

      test('days ago still numeric', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 3)),
              numeric: false, now: ref),
          '3 days ago'));
    });

    // ── Future, long ──────────────────────
    group('future long', () {
      test('in 5 minutes', () => expect(
          TimeAgoFormatter.format(future(const Duration(minutes: 5)), now: ref),
          'in 5 minutes'));

      test('in 2 hours', () => expect(
          TimeAgoFormatter.format(future(const Duration(hours: 2)), now: ref),
          'in 2 hours'));

      test('in 1 day (numeric)', () => expect(
          TimeAgoFormatter.format(future(const Duration(hours: 25)), now: ref),
          'in 1 day'));

      test('in 2 days', () => expect(
          TimeAgoFormatter.format(future(const Duration(days: 2)), now: ref),
          'in 2 days'));
    });

    // ── Short format ──────────────────────
    group('short past', () {
      test('now', () => expect(
          TimeAgoFormatter.format(past(const Duration(seconds: 3)),
              short: true, now: ref),
          'now'));

      test('30s', () => expect(
          TimeAgoFormatter.format(past(const Duration(seconds: 30)),
              short: true, now: ref),
          '30s'));

      test('5m', () => expect(
          TimeAgoFormatter.format(past(const Duration(minutes: 5)),
              short: true, now: ref),
          '5m'));

      test('3h', () => expect(
          TimeAgoFormatter.format(past(const Duration(hours: 3)),
              short: true, now: ref),
          '3h'));

      test('3d', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 3)),
              short: true, now: ref),
          '3d'));

      test('1w', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 8)),
              short: true, now: ref),
          '1w'));

      test('1mo', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 35)),
              short: true, now: ref),
          '1mo'));

      test('1y', () => expect(
          TimeAgoFormatter.format(past(const Duration(days: 370)),
              short: true, now: ref),
          '1y'));
    });

    group('short future (+prefix)', () {
      test('+5m', () => expect(
          TimeAgoFormatter.format(future(const Duration(minutes: 5)),
              short: true, now: ref),
          '+5m'));

      test('+2d', () => expect(
          TimeAgoFormatter.format(future(const Duration(days: 2)),
              short: true, now: ref),
          '+2d'));
    });
  });

  // ─────────────────────────────────────────
  // Legacy getTimeAgo (backward compat)
  // ─────────────────────────────────────────
  group('getTimeAgo (legacy)', () {
    final now = DateTime.now();

    test('just now', () =>
        expect(getTimeAgo(now.subtract(const Duration(seconds: 3))), 'Just now'));
    test('seconds ago', () =>
        expect(getTimeAgo(now.subtract(const Duration(seconds: 30))), '30 seconds ago'));
    test('1 minute ago', () =>
        expect(getTimeAgo(now.subtract(const Duration(minutes: 1))), '1 minute ago'));
    test('hours ago', () =>
        expect(getTimeAgo(now.subtract(const Duration(hours: 5))), '5 hours ago'));
    test('yesterday', () =>
        expect(getTimeAgo(now.subtract(const Duration(hours: 25))), '1 day ago'));
    test('days ago', () =>
        expect(getTimeAgo(now.subtract(const Duration(days: 4))), '4 days ago'));
  });

  // ─────────────────────────────────────────
  // formatDuration
  // ─────────────────────────────────────────
  group('formatDuration', () {
    test('seconds only', () => expect(formatDuration(45.seconds), '45s'));
    test('minutes only', () => expect(formatDuration(5.minutes), '5m'));
    test('minutes + seconds',
        () => expect(formatDuration(2.minutes + 5.seconds), '2m 5s'));
    test('hours only', () => expect(formatDuration(2.hours), '2h'));
    test('hours + minutes',
        () => expect(formatDuration(1.hours + 30.minutes), '1h 30m'));
    test('days only', () => expect(formatDuration(1.days), '1d'));
    test('days + hours', () => expect(formatDuration(1.days + 6.hours), '1d 6h'));
    test('negative duration', () => expect(formatDuration(-30.seconds), '-30s'));
    test('zero duration', () => expect(formatDuration(Duration.zero), '0s'));
  });

  // ─────────────────────────────────────────
  // DateTimeExtension
  // ─────────────────────────────────────────
  group('DateTimeExtension', () {
    test('isToday', () => expect(DateTime.now().isToday, isTrue));
    test('isYesterday', () =>
        expect(DateTime.now().subtract(const Duration(days: 1)).isYesterday, isTrue));
    test('isTomorrow', () =>
        expect(DateTime.now().add(const Duration(days: 1)).isTomorrow, isTrue));

    test('startOfDay', () {
      final d = DateTime(2026, 3, 25, 14, 30);
      expect(d.startOfDay, DateTime(2026, 3, 25, 0, 0, 0, 0));
    });

    test('endOfDay', () {
      final d = DateTime(2026, 3, 25, 14, 30);
      expect(d.endOfDay, DateTime(2026, 3, 25, 23, 59, 59, 999));
    });

    test('format delegates to formatDate', () {
      expect(DateTime(2026, 3, 25).format('dd MMM yyyy'), '25 Mar 2026');
    });

    test('timeAgo — default', () {
      final d = DateTime.now().subtract(const Duration(hours: 1));
      expect(d.timeAgo, '1 hour ago');
    });

    test('timeAgoShort', () {
      final d = DateTime.now().subtract(const Duration(hours: 3));
      expect(d.timeAgoShort, '3h');
    });

    test('timeAgo numeric: false fallback', () {
      final d = DateTime.now().subtract(const Duration(hours: 25));
      expect(TimeAgoFormatter.format(d, numeric: false), 'Yesterday');
    });

    test('timeAgo future', () {
      final d = DateTime.now().add(const Duration(hours: 2));
      expect(d.timeAgo, 'in 2 hours');
    });

    test('differenceInDays', () {
      final a = DateTime(2026, 3, 25);
      final b = DateTime(2026, 3, 20);
      expect(a.differenceInDays(b), 5);
    });

    test('isPast', () {
      expect(DateTime(2000).isPast, isTrue);
      expect(DateTime(2099).isPast, isFalse);
    });

    test('isFuture', () => expect(DateTime(2099).isFuture, isTrue));
  });

  // ─────────────────────────────────────────
  // TimeAgoStrings customization
  // ─────────────────────────────────────────
  group('TimeAgoStrings override', () {
    setUp(() => TimeAgoStrings.justNow = 'Just now'); // reset default

    test('custom justNow', () {
      TimeAgoStrings.justNow = 'Gerade eben';
      final ref = DateTime(2026, 3, 25, 12, 0, 0);
      final result = TimeAgoFormatter.format(
        ref.subtract(const Duration(seconds: 2)),
        now: ref,
      );
      expect(result, 'Gerade eben');
      TimeAgoStrings.justNow = 'Just now'; // restore
    });
  });
}
