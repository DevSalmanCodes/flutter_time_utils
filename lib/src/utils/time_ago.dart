import 'timeago_formatter.dart';

/// Returns a human-readable relative time string from [date] to now.
///
/// This provides a familiar top-level function API similar to the popular
/// `timeago` package. 
///
/// Parameters:
/// - [short] — compact single-unit label, e.g. `"5m"`, `"2h"`, `"3d"`.
/// - [numeric] — when `false`, uses natural phrases for 1-day boundaries:
///   `"Yesterday"` / `"Tomorrow"` instead of `"1 day ago"` / `"in 1 day"`.
/// - [clock] — optional reference time to calculate the difference against.
///
/// Examples:
/// ```dart
/// timeAgo(DateTime.now().subtract(5.minutes));   // "5 minutes ago"
/// timeAgo(DateTime.now().subtract(1.hours));     // "1 hour ago"
/// timeAgo(DateTime.now().subtract(1.days));      // "Yesterday"
/// timeAgo(DateTime.now().add(5.minutes));        // "in 5 minutes"
/// ```
String timeAgo(
  DateTime date, {
  bool short = false,
  bool numeric = true,
  DateTime? clock,
}) {
  return TimeAgoFormatter.format(
    date,
    short: short,
    numeric: numeric,
    now: clock,
  );
}

// ─────────────────────────────────────────
// Legacy support
// ─────────────────────────────────────────

@Deprecated('Use timeAgo() instead.')
String getTimeAgo(DateTime date) => timeAgo(date);
