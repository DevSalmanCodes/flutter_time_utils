import 'package:flutter/material.dart';
import 'package:flutter_time_utils/flutter_time_utils.dart';

void main() {
  runApp(const FlutterTimeUtilsExampleApp());
}

class FlutterTimeUtilsExampleApp extends StatelessWidget {
  const FlutterTimeUtilsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_time_utils Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSleeping = false;
  String _lastAction = '—';

  Future<void> _runSleep() async {
    setState(() {
      _isSleeping = true;
      _lastAction = 'Sleeping for 2 seconds…';
    });
    await 2.seconds.sleep();
    setState(() {
      _isSleeping = false;
      _lastAction = 'Woke up after 2 seconds!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        title: const Text('flutter_time_utils Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── Duration Extensions ───────────────────────
          _SectionCard(
            icon: Icons.timer_outlined,
            title: 'Duration Extensions',
            children: [
              _Row('5.seconds', '${5.seconds}'),
              _Row('10.minutes', '${10.minutes}'),
              _Row('2.5.minutes', '${2.5.minutes}'),
              _Row('2.hours', '${2.hours}'),
              _Row('3.days', '${3.days}'),
              _Row('(2.minutes + 5.seconds).formatted',
                  (2.minutes + 5.seconds).formatted),
              _Row('1.hours.formatted', 1.hours.formatted),
              _Row('(1.hours + 30.minutes).formatted',
                  (1.hours + 30.minutes).formatted),
            ],
          ),
          const SizedBox(height: 12),

          // ─── Duration.sleep() ─────────────────────────
          _SectionCard(
            icon: Icons.bedtime_outlined,
            title: 'Duration.sleep()',
            children: [
              const Text(
                'await 2.seconds.sleep()',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                _lastAction,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _isSleeping ? null : _runSleep,
                icon: _isSleeping
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(_isSleeping ? 'Sleeping…' : 'Run Sleep'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ─── DateTime Extensions ───────────────────────
          _SectionCard(
            icon: Icons.calendar_month_outlined,
            title: 'DateTime Extensions',
            children: [
              _Row('now.format("dd MMM yyyy")', now.format('dd MMM yyyy')),
              _Row('now.format("hh:mm a")', now.format('hh:mm a')),
              _Row('now.format("EEEE")', now.format('dd/MM/yyyy HH:mm:ss')),
              _Row('now.isToday', '${now.isToday}'),
              _Row('now.isYesterday', '${now.isYesterday}'),
              _Row('now.isTomorrow', '${now.isTomorrow}'),
              _Row('now.isPast', '${now.isPast}'),
              _Row('now.isFuture', '${now.isFuture}'),
              _Row('now.startOfDay', '${now.startOfDay}'),
              _Row('now.endOfDay', '${now.endOfDay}'),
            ],
          ),
          const SizedBox(height: 12),

          // ─── timeAgo ──────────────────────────────────
          _SectionCard(
            icon: Icons.history_outlined,
            title: 'timeAgo',
            children: [
              _Row(
                'just now (3s ago)',
                now.subtract(3.seconds).timeAgo,
              ),
              _Row(
                '2 minutes ago',
                now.subtract(2.minutes).timeAgo,
              ),
              _Row(
                '3 days ago',
                now.subtract(3.days).timeAgo,
              ),
              _Row(
                'in 5 minutes (future)',
                now.add(5.minutes).timeAgo,
              ),
              const Divider(height: 24),
              const Text('Top-level function (timeago style):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _Row('timeAgo(date)', timeAgo(now.subtract(5.minutes))),
              _Row('timeAgo(date, short: true)',
                  timeAgo(now.subtract(2.days), short: true)),
              _Row('timeAgo(date, numeric: false)',
                  timeAgo(now.subtract(25.hours), numeric: false)),
              const Divider(height: 24),
              const Text('Short format (timeAgoShort):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _Row('5 minutes ago', now.subtract(5.minutes).timeAgoShort),
              _Row('3 hours ago', now.subtract(3.hours).timeAgoShort),
              _Row('2 days ago', now.subtract(2.days).timeAgoShort),
              _Row('in 5 minutes (future)', now.add(5.minutes).timeAgoShort),
            ],
          ),
          const SizedBox(height: 12),

          // ─── Duration Time-Ago Shortcuts ────────────
          _SectionCard(
            icon: Icons.bolt_outlined,
            title: 'Duration Time-Ago',
            children: [
              _Row('5.minutes.ago', 5.minutes.ago),
              _Row('2.hours.ago', 2.hours.ago),
              _Row('1.days.ago', 1.days.ago),
              _Row('2.days.fromNow', 2.days.fromNow),
              const Divider(height: 24),
              const Text('Short format:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _Row('5.minutes.agoShort', 5.minutes.agoShort),
              _Row('3.hours.agoShort', 3.hours.agoShort),
              _Row('2.days.fromNowShort', 2.days.fromNowShort),
            ],
          ),
          const SizedBox(height: 12),

          // ─── formatDuration ───────────────────────────
          _SectionCard(
            icon: Icons.hourglass_bottom_outlined,
            title: 'formatDuration()',
            children: [
              _Row('45.seconds', formatDuration(45.seconds)),
              _Row('5.minutes', formatDuration(5.minutes)),
              _Row('2.minutes + 5.seconds',
                  formatDuration(2.minutes + 5.seconds)),
              _Row('2.hours', formatDuration(2.hours)),
              _Row(
                  '1.hours + 30.minutes', formatDuration(1.hours + 30.minutes)),
              _Row('1.days', formatDuration(1.days)),
              _Row('1.days + 6.hours', formatDuration(1.days + 6.hours)),
              _Row('-30.seconds (negative)', formatDuration(-30.seconds)),
            ],
          ),
          const SizedBox(height: 12),

          // ─── formatDate ───────────────────────────────
          _SectionCard(
            icon: Icons.text_fields_outlined,
            title: 'formatDate() — token showcase',
            children: [
              _Row('"dd MMM yyyy"', formatDate(now, 'dd MMM yyyy')),
              _Row('"MMMM d, yyyy"', formatDate(now, 'MMMM d, yyyy')),
              _Row('"MM/dd/yyyy"', formatDate(now, 'MM/dd/yyyy')),
              _Row('"HH:mm:ss"', formatDate(now, 'HH:mm:ss')),
              _Row('"hh:mm a"', formatDate(now, 'hh:mm a')),
              _Row('"yy"', formatDate(now, 'yy')),
            ],
          ),
          const SizedBox(height: 24),
          Text(timeAgo(DateTime.parse('2026-03-25T11:00:00'), numeric: false))
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.code, this.result);

  final String code;
  final String result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: scheme.onSurface.withAlpha(200),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              result,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: scheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
