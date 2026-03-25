import '../formatters/date_formatter.dart';
import '../utils/timeago_formatter.dart';

/// DateTime utility extensions on [DateTime].
///
/// Example:
/// ```dart
/// DateTime.now().format('dd MMM yyyy');            // "25 Mar 2026"
/// DateTime.now().isToday;                          // true
/// DateTime.now().startOfDay;                       // 2026-03-25 00:00:00.000
///
/// someDate.timeAgo;                                // "3 days ago"
/// someDate.timeAgoShort;                           // "3d"
/// ```
extension DateTimeX on DateTime {
  // ─────────────────────────────────────────
  // Formatting
  // ─────────────────────────────────────────

  /// Formats this [DateTime] using the given [pattern].
  ///
  /// Supported tokens:
  /// - `yyyy` — 4-digit year
  /// - `yy`   — 2-digit year
  /// - `MM`   — 2-digit month (01–12)
  /// - `MMM`  — abbreviated month name (Jan, Feb…)
  /// - `MMMM` — full month name (January, February…)
  /// - `dd`   — 2-digit day (01–31)
  /// - `d`    — day without leading zero
  /// - `HH`   — 24-hour hour (00–23)
  /// - `hh`   — 12-hour hour (01–12)
  /// - `mm`   — minutes (00–59)
  /// - `ss`   — seconds (00–59)
  /// - `a`    — AM / PM
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().format('dd MMM yyyy HH:mm'); // "25 Mar 2026 10:56"
  /// ```
  String format(String pattern) => formatDate(this, pattern);

  // ─────────────────────────────────────────
  // Relative comparisons
  // ─────────────────────────────────────────

  /// Returns `true` if this [DateTime] falls on today's date.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns `true` if this [DateTime] falls on yesterday's date.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns `true` if this [DateTime] falls on tomorrow's date.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns `true` if this [DateTime] is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Returns `true` if this [DateTime] is in the future.
  bool get isFuture => isAfter(DateTime.now());

  // ─────────────────────────────────────────
  // Day boundaries
  // ─────────────────────────────────────────

  /// Returns a [DateTime] at 00:00:00.000 on the same day.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2026, 3, 25, 14, 30).startOfDay; // 2026-03-25 00:00:00.000
  /// ```
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a [DateTime] at 23:59:59.999 on the same day.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2026, 3, 25, 14, 30).endOfDay; // 2026-03-25 23:59:59.999
  /// ```
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // ─────────────────────────────────────────
  // Time Ago
  // ─────────────────────────────────────────

  /// Returns a human-readable relative time string from this [DateTime] to now.
  ///
  /// Examples:
  /// ```dart
  /// date.timeAgo;                     // "5 minutes ago"
  /// futureDate.timeAgo;               // "in 2 hours"
  /// ```
  String get timeAgo => TimeAgoFormatter.format(this);

  /// Returns a compact relative time string from this [DateTime] to now.
  ///
  /// Examples:
  /// ```dart
  /// date.timeAgoShort;                // "5m"
  /// futureDate.timeAgoShort;          // "+2h"
  /// ```
  String get timeAgoShort => TimeAgoFormatter.format(this, short: true);

  // ─────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────

  /// Returns only the date portion of this [DateTime] (no time components).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns the number of full days between this date and [other].
  int differenceInDays(DateTime other) =>
      dateOnly.difference(other.dateOnly).inDays.abs();
}
