/// Lightweight date formatter that supports common patterns
/// without requiring the `intl` package.
///
/// Uses a left-to-right regex token scanner to correctly handle
/// overlapping token names (e.g. `a` inside `Mar`).
///
/// Supported tokens:
/// | Token  | Output                  | Example  |
/// |--------|-------------------------|----------|
/// | yyyy   | 4-digit year            | 2026     |
/// | yy     | 2-digit year            | 26       |
/// | MMMM   | Full month name         | March    |
/// | MMM    | Abbreviated month name  | Mar      |
/// | MM     | 2-digit month           | 03       |
/// | M      | Month without padding   | 3        |
/// | dd     | 2-digit day             | 05       |
/// | d      | Day without padding     | 5        |
/// | HH     | 24-hour hour (padded)   | 09       |
/// | hh     | 12-hour hour (padded)   | 09       |
/// | mm     | Minutes (padded)        | 04       |
/// | ss     | Seconds (padded)        | 07       |
/// | a      | AM / PM                 | AM       |
///
/// Example:
/// ```dart
/// final date = DateTime(2026, 3, 25, 14, 5, 7);
/// formatDate(date, 'dd MMM yyyy');         // "25 Mar 2026"
/// formatDate(date, 'hh:mm a');             // "02:05 PM"
/// formatDate(date, 'dd/MM/yyyy HH:mm:ss'); // "25/03/2026 14:05:07"
/// ```
String formatDate(DateTime date, String pattern) {
  // Regex alternation with longest tokens first (critical!).
  // Dart's RegExp engine tries alternatives left-to-right, so 'yyyy'
  // takes priority over 'yy', 'MMMM' over 'MMM' over 'MM' over 'M', etc.
  // Non-token characters are NOT matched and are emitted verbatim.
  final tokenRegex = RegExp(
    r'yyyy|yy|MMMM|MMM|MM|M|dd|d|HH|hh|mm|ss|a',
  );

  final buffer = StringBuffer();
  int cursor = 0;

  for (final match in tokenRegex.allMatches(pattern)) {
    // Emit any literal text before this token.
    if (match.start > cursor) {
      buffer.write(pattern.substring(cursor, match.start));
    }
    buffer.write(_resolveToken(match.group(0)!, date));
    cursor = match.end;
  }

  // Emit any trailing literal text.
  if (cursor < pattern.length) {
    buffer.write(pattern.substring(cursor));
  }

  return buffer.toString();
}

// ─────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────

String _resolveToken(String token, DateTime date) {
  switch (token) {
    case 'yyyy':
      return date.year.toString();
    case 'yy':
      return date.year.toString().substring(2);
    case 'MMMM':
      return _monthName(date.month);
    case 'MMM':
      return _monthAbbr(date.month);
    case 'MM':
      return _pad(date.month);
    case 'M':
      return date.month.toString();
    case 'dd':
      return _pad(date.day);
    case 'd':
      return date.day.toString();
    case 'HH':
      return _pad(date.hour);
    case 'hh':
      return _pad(_to12Hour(date.hour));
    case 'mm':
      return _pad(date.minute);
    case 'ss':
      return _pad(date.second);
    case 'a':
      return date.hour < 12 ? 'AM' : 'PM';
    default:
      return token;
  }
}

String _pad(int value) => value.toString().padLeft(2, '0');

int _to12Hour(int hour) {
  if (hour == 0) return 12;
  if (hour > 12) return hour - 12;
  return hour;
}

String _monthAbbr(int month) => const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][month - 1];

String _monthName(int month) => const [
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
    ][month - 1];
