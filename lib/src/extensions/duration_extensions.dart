import 'dart:async';

import '../utils/timeago_formatter.dart';

/// Duration extensions on [int].
///
/// Provides a clean, expressive API for creating [Duration] objects.
///
/// Example:
/// ```dart
/// final d = 5.seconds;       // Duration(seconds: 5)
/// final m = 10.minutes;      // Duration(minutes: 10)
/// final h = 2.hours;         // Duration(hours: 2)
/// final day = 3.days;        // Duration(days: 3)
/// ```
extension DurationIntX on int {
  /// Returns a [Duration] of this many seconds.
  Duration get seconds => Duration(seconds: this);

  /// Returns a [Duration] of this many minutes.
  Duration get minutes => Duration(minutes: this);

  /// Returns a [Duration] of this many hours.
  Duration get hours => Duration(hours: this);

  /// Returns a [Duration] of this many days.
  Duration get days => Duration(days: this);

  /// Returns a [Duration] of this many milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Returns a [Duration] of this many microseconds.
  Duration get microseconds => Duration(microseconds: this);
}

/// Duration extensions on [num] to support decimal values.
///
/// Example:
/// ```dart
/// final d = 2.5.minutes;     // Duration(minutes: 2, seconds: 30)
/// final h = 1.5.hours;       // Duration(hours: 1, minutes: 30)
/// ```
extension DurationNumX on num {
  Duration get seconds => Duration(microseconds: (this * 1000000).round());
  Duration get minutes => Duration(microseconds: (this * 60000000).round());
  Duration get hours => Duration(microseconds: (this * 3600000000).round());
  Duration get days => Duration(microseconds: (this * 86400000000).round());
}

/// Time-ago helpers for [Duration].
///
/// Provides expressive getters for human-readable relative strings.
///
/// Example:
/// ```dart
/// 5.minutes.ago              // "5 minutes ago"
/// 3.hours.ago                // "3 hours ago"
/// 2.days.fromNow             // "in 2 days"
/// ```
extension DurationAgoX on Duration {
  /// Returns a long relative time string for a past date offset by this duration.
  ///
  /// Equivalent to `DateTime.now().subtract(this).timeAgo`.
  ///
  /// Example:
  /// ```dart
  /// 5.minutes.ago    // "5 minutes ago"
  /// 2.days.ago       // "2 days ago"
  /// 1.hours.ago      // "1 hour ago"
  /// ```
  String get ago => TimeAgoFormatter.format(DateTime.now().subtract(this));

  /// Returns a long relative time string for a future date offset by this duration.
  ///
  /// Equivalent to `DateTime.now().add(this).timeAgo`.
  ///
  /// Example:
  /// ```dart
  /// 2.days.fromNow    // "in 2 days"
  /// 3.hours.fromNow   // "in 3 hours"
  /// ```
  String get fromNow => TimeAgoFormatter.format(DateTime.now().add(this));

  /// Short version of [ago]: returns compact label like `"5m"`, `"2d"`.
  ///
  /// Example:
  /// ```dart
  /// 5.minutes.agoShort    // "5m"
  /// 3.hours.agoShort      // "3h"
  /// ```
  String get agoShort =>
      TimeAgoFormatter.format(DateTime.now().subtract(this), short: true);

  /// Short version of [fromNow]: returns compact label prefixed with `"+"`.
  ///
  /// Example:
  /// ```dart
  /// 2.days.fromNowShort    // "+2d"
  /// 1.hours.fromNowShort   // "+1h"
  /// ```
  String get fromNowShort =>
      TimeAgoFormatter.format(DateTime.now().add(this), short: true);
}

/// Additional utility extensions on [Duration].
extension DurationExtension on Duration {
  // ─────────────────────────────────────────
  // Async / sleep
  // ─────────────────────────────────────────

  /// Suspends execution for this [Duration].
  ///
  /// Example:
  /// ```dart
  /// await 5.seconds.sleep();
  /// ```
  Future<void> sleep() => Future.delayed(this);

  // ─────────────────────────────────────────
  // Comparisons
  // ─────────────────────────────────────────

  /// Returns `true` if this duration is longer than [other].
  bool isLongerThan(Duration other) => this > other;

  /// Returns `true` if this duration is shorter than [other].
  bool isShorterThan(Duration other) => this < other;

  // ─────────────────────────────────────────
  // Human-readable compact string
  // ─────────────────────────────────────────

  /// Returns a compact human-readable string for this duration.
  ///
  /// Examples:
  /// ```dart
  /// 45.seconds.formatted         // "45s"
  /// (2.minutes + 5.seconds).formatted  // "2m 5s"
  /// 2.hours.formatted            // "2h"
  /// (1.hours + 30.minutes).formatted   // "1h 30m"
  /// 1.days.formatted             // "1d"
  /// ```
  String get formatted {
    if (inDays >= 1) return '${inDays}d';
    if (inHours >= 1) {
      final remaining = this - Duration(hours: inHours);
      return remaining.inMinutes > 0
          ? '${inHours}h ${remaining.inMinutes}m'
          : '${inHours}h';
    }
    if (inMinutes >= 1) {
      final remaining = this - Duration(minutes: inMinutes);
      return remaining.inSeconds > 0
          ? '${inMinutes}m ${remaining.inSeconds}s'
          : '${inMinutes}m';
    }
    return '${inSeconds}s';
  }

  // ─────────────────────────────────────────
  // Countdown
  // ─────────────────────────────────────────

  /// Counts down from [inSeconds] to `0`, calling [onTick] every second.
  ///
  /// Supports a completion callback via [onDone] and can be cancelled via
  /// the returned [StreamSubscription].
  ///
  /// Example:
  /// ```dart
  /// 10.seconds.countdown(
  ///   onTick: (value) => print(value), // 10 → 9 → ... → 0
  ///   onDone: () => print("Done!"),
  /// );
  /// ```
  StreamSubscription<int> countdown({
    required void Function(int value) onTick,
    void Function()? onDone,
  }) {
    int remaining = inSeconds;

    return Stream.periodic(const Duration(seconds: 1))
        .take(inSeconds + 1)
        .map((e) => e as int? ?? 0)
        .listen(
      (_) {
        onTick(remaining);
        if (remaining == 0) onDone?.call();
        remaining--;
      },
    );
  }

  /// Returns a stream emitting countdown values every second.
  ///
  /// Example:
  /// ```dart
  /// 10.seconds.countdownStream().listen(print);
  /// ```
  Stream<int> countdownStream() async* {
    for (int i = inSeconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
