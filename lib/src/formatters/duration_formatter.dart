/// Formats a [Duration] into a compact, human-readable string.
///
/// Rules:
/// - Days take priority over hours/minutes/seconds.
/// - Hours are shown with remaining minutes if applicable.
/// - Minutes are shown with remaining seconds if applicable.
/// - Falls back to seconds if duration is less than a minute.
///
/// Examples:
/// ```dart
/// formatDuration(Duration(seconds: 125));         // "2m 5s"
/// formatDuration(Duration(hours: 2));             // "2h"
/// formatDuration(Duration(hours: 1, minutes: 30)); // "1h 30m"
/// formatDuration(Duration(days: 1));              // "1d"
/// formatDuration(Duration(seconds: 45));          // "45s"
/// ```
String formatDuration(Duration duration) {
  if (duration.isNegative) {
    return '-${formatDuration(-duration)}';
  }

  final days = duration.inDays;
  final hours = duration.inHours.remainder(24);
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (days > 0) {
    return hours > 0 ? '${days}d ${hours}h' : '${days}d';
  }

  if (hours > 0) {
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  if (minutes > 0) {
    return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
  }

  return '${seconds}s';
}
