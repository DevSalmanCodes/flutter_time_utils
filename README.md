# flutter_time_utils

[![pub package](https://img.shields.io/pub/v/flutter_time_utils.svg)](https://pub.dev/packages/flutter_time_utils)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A lightweight Flutter package that provides **Duration extensions**, **DateTime helpers**, a **zero-dependency date formatter**, **relative time (timeAgo)**, and a **duration formatter** — keeping your time-related code clean and expressive.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| `int` extensions | `5.seconds`, `10.minutes`, `2.hours`, `3.days` |
| `Duration` extensions | `duration.sleep()`, `duration.formatted` |
| `DateTime` extensions | `format()`, `isToday`, `isYesterday`, `isTomorrow`, `startOfDay`, `endOfDay`, `timeAgo()` |
| `formatDate()` | Zero-dependency formatter with 14 tokens |
| `timeAgo()` | Human-readable relative time strings |
| `formatDuration()` | Compact duration strings like `"2m 5s"` |

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_time_utils: ^1.0.0
```

Then run:

```sh
flutter pub get
```

---

## 📖 Usage

### Import

```dart
import 'package:flutter_time_utils/flutter_time_utils.dart';
```

---

### ⏱ Duration Extensions

```dart
// Create durations with expressive syntax
final d1 = 5.seconds;     // Duration(seconds: 5)
final d2 = 10.minutes;    // Duration(minutes: 10)
final d3 = 2.hours;       // Duration(hours: 2)
final d4 = 3.days;        // Duration(days: 3)

// Delay execution
await 2.seconds.sleep();

// Human-readable string
print(125.seconds.formatted); // "2m 5s"
print(2.hours.formatted);     // "2h"
```

---

### 📅 DateTime Extensions

```dart
final now = DateTime.now();

// Formatting
print(now.format('dd MMM yyyy'));        // "25 Mar 2026"
print(now.format('hh:mm a'));            // "10:04 AM"
print(now.format('dd/MM/yyyy HH:mm:ss')); // "25/03/2026 14:05:07"

// Relative comparisons
print(now.isToday);     // true
print(now.isYesterday); // false
print(now.isTomorrow);  // false
print(now.isPast);      // false
print(now.isFuture);    // true (nanoseconds in the future)

// Day boundaries
print(now.startOfDay);  // 2026-03-25 00:00:00.000
print(now.endOfDay);    // 2026-03-25 23:59:59.999

// Relative time
print(now.subtract(2.minutes).timeAgo());  // "2 minutes ago"
print(now.subtract(1.days).timeAgo());     // "yesterday"
```

---

### 📅 formatDate() — Standalone

```dart
final date = DateTime(2026, 3, 25, 14, 5, 7);

formatDate(date, 'dd MMM yyyy');        // "25 Mar 2026"
formatDate(date, 'MMMM d, yyyy');       // "March 25, 2026"
formatDate(date, 'hh:mm a');            // "02:05 PM"
formatDate(date, 'HH:mm:ss');           // "14:05:07"
```

#### Supported Tokens

| Token  | Output                 | Example  |
|--------|------------------------|----------|
| `yyyy` | 4-digit year           | `2026`   |
| `yy`   | 2-digit year           | `26`     |
| `MMMM` | Full month name        | `March`  |
| `MMM`  | Abbreviated month      | `Mar`    |
| `MM`   | 2-digit month          | `03`     |
| `M`    | Month without padding  | `3`      |
| `dd`   | 2-digit day            | `05`     |
| `d`    | Day without padding    | `5`      |
| `HH`   | 24-hour hour (padded)  | `14`     |
| `hh`   | 12-hour hour (padded)  | `02`     |
| `mm`   | Minutes (padded)       | `05`     |
| `ss`   | Seconds (padded)       | `07`     |
| `a`    | AM / PM                | `PM`     |

---

### ⏳ timeAgo() — Standalone

```dart
import 'package:flutter_time_utils/flutter_time_utils.dart';

final now = DateTime.now();

print(getTimeAgo(now.subtract(Duration(seconds: 3))));   // "just now"
print(getTimeAgo(now.subtract(Duration(minutes: 2))));   // "2 minutes ago"
print(getTimeAgo(now.subtract(Duration(hours: 1))));     // "1 hour ago"
print(getTimeAgo(now.subtract(Duration(days: 1))));      // "yesterday"
print(getTimeAgo(now.subtract(Duration(days: 3))));      // "3 days ago"
print(getTimeAgo(now.subtract(Duration(days: 10))));     // "1 week ago"
print(getTimeAgo(now.add(Duration(minutes: 5))));        // "in 5 minutes"
```

---

### 🕐 formatDuration()

```dart
print(formatDuration(Duration(seconds: 125)));           // "2m 5s"
print(formatDuration(Duration(hours: 2)));               // "2h"
print(formatDuration(Duration(hours: 1, minutes: 30)));  // "1h 30m"
print(formatDuration(Duration(days: 1)));                // "1d"
print(formatDuration(Duration(seconds: 45)));            // "45s"
print(formatDuration(5.minutes));                        // "5m"
```

---

## 🧪 Running Tests

```sh
flutter test
```

---

## 📜 License

MIT © Salman Ahmad
