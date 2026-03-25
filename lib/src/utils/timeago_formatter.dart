// Centralized timeAgo formatting logic — the single source of truth for
// all relative time strings in the package.
//
// Split from [time_ago.dart] to keep extensions thin and to make the
// string layer easy to override for localization.
//
// ---
//
// ## Quick reference
//
// ```dart
// // Via DateTime extension (recommended)
// date.timeAgo();                     // "5 minutes ago"
// date.timeAgo(short: true);          // "5m"
// date.timeAgo(numeric: false);       // "Yesterday"
//
// // Via Duration shortcuts
// 5.minutes.ago;                      // "5 minutes ago"
// 2.days.fromNow;                     // "in 2 days"
//
// // Directly
// TimeAgoFormatter.format(date);
// TimeAgoFormatter.format(date, short: true, numeric: false);
// ```

// ═══════════════════════════════════════════════════════════════════════════
// Localizable strings
// ═══════════════════════════════════════════════════════════════════════════

/// Centralized string definitions for timeAgo labels.
///
/// Override these static fields to provide custom or localized strings.
///
/// Example:
/// ```dart
/// TimeAgoStrings.justNow = 'Gerade eben'; // German
/// ```
class TimeAgoStrings {
  TimeAgoStrings._();

  // ── Past ────────────────────────────────────────────────────────────────

  /// Displayed when the difference is less than 5 seconds.
  static String justNow = 'Just now';

  /// Returns a label for N seconds in the past.
  static String secondsAgo(int s) => '$s ${s == 1 ? 'second' : 'seconds'} ago';

  /// Returns a label for N minutes in the past.
  static String minutesAgo(int m) => '$m ${m == 1 ? 'minute' : 'minutes'} ago';

  /// Returns a label for N hours in the past.
  static String hoursAgo(int h) => '$h ${h == 1 ? 'hour' : 'hours'} ago';

  /// Used when [numeric] is `false` and the date was ~1 day ago.
  static String yesterday = 'Yesterday';

  /// Returns a label for N days in the past.
  static String daysAgo(int d) => '$d ${d == 1 ? 'day' : 'days'} ago';

  /// Returns a label for N weeks in the past.
  static String weeksAgo(int w) => '$w ${w == 1 ? 'week' : 'weeks'} ago';

  /// Returns a label for N months in the past.
  static String monthsAgo(int m) => '$m ${m == 1 ? 'month' : 'months'} ago';

  /// Returns a label for N years in the past.
  static String yearsAgo(int y) => '$y ${y == 1 ? 'year' : 'years'} ago';

  // ── Future ──────────────────────────────────────────────────────────────

  /// Returns a label for N seconds in the future.
  static String inSeconds(int s) => 'in $s ${s == 1 ? 'second' : 'seconds'}';

  /// Returns a label for N minutes in the future.
  static String inMinutes(int m) => 'in $m ${m == 1 ? 'minute' : 'minutes'}';

  /// Returns a label for N hours in the future.
  static String inHours(int h) => 'in $h ${h == 1 ? 'hour' : 'hours'}';

  /// Used when [numeric] is `false` and the date is ~1 day from now.
  static String tomorrow = 'Tomorrow';

  /// Returns a label for N days in the future.
  static String inDays(int d) => 'in $d ${d == 1 ? 'day' : 'days'}';

  /// Returns a label for N weeks in the future.
  static String inWeeks(int w) => 'in $w ${w == 1 ? 'week' : 'weeks'}';

  /// Returns a label for N months in the future.
  static String inMonths(int m) => 'in $m ${m == 1 ? 'month' : 'months'}';

  /// Returns a label for N years in the future.
  static String inYears(int y) => 'in $y ${y == 1 ? 'year' : 'years'}';

  // ── Short (social-media style) ───────────────────────────────────────────

  /// Short label for just now.
  static String justNowShort = 'now';

  /// Short label for seconds.
  static String secondsShort(int s) => '${s}s';

  /// Short label for minutes.
  static String minutesShort(int m) => '${m}m';

  /// Short label for hours.
  static String hoursShort(int h) => '${h}h';

  /// Short label for days.
  static String daysShort(int d) => '${d}d';

  /// Short label for weeks.
  static String weeksShort(int w) => '${w}w';

  /// Short label for months.
  static String monthsShort(int m) => '${m}mo';

  /// Short label for years.
  static String yearsShort(int y) => '${y}y';
}

// ═══════════════════════════════════════════════════════════════════════════
// Core formatter
// ═══════════════════════════════════════════════════════════════════════════

/// Formats a [DateTime] into a human-readable relative time string.
///
/// Parameters:
/// - [short] — when `true`, returns compact single-unit labels like `"5m"`, `"2h"`.
/// - [numeric] — when `false`, uses natural language for 1-day boundaries
///   (`"Yesterday"` / `"Tomorrow"`) instead of `"1 day ago"` / `"in 1 day"`.
///
/// Examples:
/// ```dart
/// TimeAgoFormatter.format(fiveMinutesAgo);                    // "5 minutes ago"
/// TimeAgoFormatter.format(fiveMinutesAgo, short: true);       // "5m"
/// TimeAgoFormatter.format(oneDayAgo, numeric: false);         // "Yesterday"
/// TimeAgoFormatter.format(twoHoursFromNow);                   // "in 2 hours"
/// TimeAgoFormatter.format(twoHoursFromNow, short: true);      // "2h"
/// ```
class TimeAgoFormatter {
  TimeAgoFormatter._();

  /// Formats [date] relative to [now] (defaults to [DateTime.now()]).
  ///
  /// Providing [now] explicitly is useful in tests.
  static String format(
    DateTime date, {
    bool short = false,
    bool numeric = true,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(date);
    final isFuture = diff.isNegative;
    
    // Add 1 second of padding for future dates to overcome the microsecond
    // decay that occurs between multiple `DateTime.now()` evaluations.
    final abs = diff.abs() + (isFuture ? const Duration(seconds: 1) : Duration.zero);

    return short
        ? _short(abs, isFuture)
        : _long(abs, isFuture, numeric);
  }

  // ── Long format ─────────────────────────────────────────────────────────

  static String _long(Duration abs, bool isFuture, bool numeric) {
    final seconds = abs.inSeconds;
    final minutes = abs.inMinutes;
    final hours = abs.inHours;
    final days = abs.inDays;

    if (seconds < 5) return TimeAgoStrings.justNow;

    if (seconds < 60) {
      return isFuture
          ? TimeAgoStrings.inSeconds(seconds)
          : TimeAgoStrings.secondsAgo(seconds);
    }

    if (minutes < 60) {
      return isFuture
          ? TimeAgoStrings.inMinutes(minutes)
          : TimeAgoStrings.minutesAgo(minutes);
    }

    if (hours < 22) {
      return isFuture
          ? TimeAgoStrings.inHours(hours)
          : TimeAgoStrings.hoursAgo(hours);
    }

    // 22h–26h window → yesterday / tomorrow
    if (hours < 26) {
      if (!numeric) {
        return isFuture ? TimeAgoStrings.tomorrow : TimeAgoStrings.yesterday;
      }
      return isFuture ? TimeAgoStrings.inDays(1) : TimeAgoStrings.daysAgo(1);
    }

    if (days < 7) {
      return isFuture
          ? TimeAgoStrings.inDays(days)
          : TimeAgoStrings.daysAgo(days);
    }

    if (days < 30) {
      final weeks = (days / 7).floor();
      if (!numeric && weeks == 1) {
        return isFuture ? TimeAgoStrings.inWeeks(1) : TimeAgoStrings.weeksAgo(1);
      }
      return isFuture
          ? TimeAgoStrings.inWeeks(weeks)
          : TimeAgoStrings.weeksAgo(weeks);
    }

    if (days < 365) {
      final months = (days / 30).floor();
      return isFuture
          ? TimeAgoStrings.inMonths(months)
          : TimeAgoStrings.monthsAgo(months);
    }

    final years = (days / 365).floor();
    return isFuture
        ? TimeAgoStrings.inYears(years)
        : TimeAgoStrings.yearsAgo(years);
  }

  // ── Short format ─────────────────────────────────────────────────────────

  static String _short(Duration abs, bool isFuture) {
    final seconds = abs.inSeconds;
    final minutes = abs.inMinutes;
    final hours = abs.inHours;
    final days = abs.inDays;

    // Prefix for future in short mode: "+5m" feels unnatural — keep "5m" for
    // short past, and add a "+" prefix for future to distinguish.
    String label;

    if (seconds < 5) {
      return TimeAgoStrings.justNowShort;
    } else if (seconds < 60) {
      label = TimeAgoStrings.secondsShort(seconds);
    } else if (minutes < 60) {
      label = TimeAgoStrings.minutesShort(minutes);
    } else if (hours < 24) {
      label = TimeAgoStrings.hoursShort(hours);
    } else if (days < 7) {
      label = TimeAgoStrings.daysShort(days);
    } else if (days < 30) {
      label = TimeAgoStrings.weeksShort((days / 7).floor());
    } else if (days < 365) {
      label = TimeAgoStrings.monthsShort((days / 30).floor());
    } else {
      label = TimeAgoStrings.yearsShort((days / 365).floor());
    }

    return isFuture ? '+$label' : label;
  }
}
