/// A lightweight Flutter package providing Duration extensions, DateTime utilities,
/// date formatting helpers, relative time (timeAgo), and duration formatting —
/// all without any heavy dependencies.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_time_utils/flutter_time_utils.dart';
///
/// // Duration extensions
/// await 2.seconds.sleep();
/// print((2.minutes + 5.seconds).formatted); // "2m 5s"
///
/// // Duration time-ago shortcuts
/// print(5.minutes.ago);              // "5 minutes ago"
/// print(2.days.fromNow);             // "in 2 days"
/// print(3.hours.agoShort);           // "3h"
///
/// // DateTime extensions
/// print(DateTime.now().format('dd MMM yyyy'));     // "25 Mar 2026"
/// print(DateTime.now().isToday);                  // true
/// print(someDate.timeAgo);                        // "3 days ago"
/// print(someDate.timeAgoShort);                   // "3d"
/// 
/// // Top-level TimeAgo (like `timeago` package)
/// print(timeAgo(someDate));                       // "3 days ago"
/// print(timeAgo(futureDate, short: true));        // "+2h"
///
/// // Standalone formatters
/// print(formatDate(DateTime.now(), 'hh:mm a'));   // "10:56 AM"
/// print(formatDuration(125.seconds));             // "2m 5s"
///
/// // Localization-ready string overrides
/// TimeAgoStrings.justNow = 'Gerade eben';
/// ```
library flutter_time_utils;

// Extensions
export 'src/extensions/duration_extensions.dart';
export 'src/extensions/datetime_extensions.dart';

// Formatters
export 'src/formatters/date_formatter.dart';
export 'src/formatters/duration_formatter.dart';

// Utils
export 'src/utils/time_ago.dart';
export 'src/utils/timeago_formatter.dart';
