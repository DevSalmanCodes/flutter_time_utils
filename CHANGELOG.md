# Changelog

## 1.1.1
- **Feature**: Added top-level `timeAgo(date)` function identical to the popular `timeago` package.
- **Documentation**: Updated `README.md` to showcase the new concise getter API (`timeAgo`, `fromNow`).

## 1.1.0

* Upgraded `timeAgo` into a production-level utility (`TimeAgoFormatter`, `TimeAgoStrings`).
* `DateTime.timeAgo()` now accepts `short` and `numeric` parameters.
* Added short format: `date.timeAgo(short: true)` → `"5m"`, `"2h"`, `"3d"`.
* Added `Duration.ago`, `Duration.fromNow`, `Duration.agoShort`, `Duration.fromNowShort` getters.
* `TimeAgoStrings` class provides localization-ready static string overrides.
* Future date support: `futureDate.timeAgo()` → `"in 2 hours"`.

## 1.0.0

* Initial release.
* `Duration` extensions: `int.seconds`, `int.minutes`, `int.hours`, `int.days`, `Duration.sleep()`.
* `DateTime` extensions: `format()`, `isToday`, `isYesterday`, `isTomorrow`, `startOfDay`, `endOfDay`, `timeAgo()`.
* Lightweight date formatter with no `intl` dependency.
* `timeAgo()` utility supporting seconds, minutes, hours, days, and weeks.
* `formatDuration()` utility for human-readable duration strings.
