import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/features/analytics/domain/entities/mood_stats.dart';
import 'package:mindsafe/features/analytics/domain/entities/mood_trend_point.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';
import 'package:mindsafe/features/mood/presentation/providers/mood_provider.dart';

MoodStats computeMoodStats(List<MoodEntry> entries) {
  if (entries.isEmpty) return MoodStats.empty();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final weekStart = today.subtract(const Duration(days: 6));
  final monthStart = today.subtract(const Duration(days: 29));

  double averageForPeriod(DateTime start) {
    final periodEntries = entries.where(
      (e) => !e.createdAt.isBefore(start),
    );
    if (periodEntries.isEmpty) return 0;
    final sum = periodEntries.fold<int>(0, (s, e) => s + e.mood.score);
    return sum / periodEntries.length;
  }

  final distribution = <MoodType, int>{};
  for (final mood in MoodType.values) {
    distribution[mood] = 0;
  }
  for (final entry in entries) {
    distribution[entry.mood] = (distribution[entry.mood] ?? 0) + 1;
  }

  final trendPoints = <MoodTrendPoint>[];
  for (var i = 13; i >= 0; i--) {
    final day = today.subtract(Duration(days: i));
    final nextDay = day.add(const Duration(days: 1));
    final dayEntries = entries.where(
      (e) => !e.createdAt.isBefore(day) && e.createdAt.isBefore(nextDay),
    );
    if (dayEntries.isEmpty) {
      trendPoints.add(
        MoodTrendPoint(date: day, averageScore: 0, entryCount: 0),
      );
    } else {
      final avg = dayEntries.fold<int>(0, (s, e) => s + e.mood.score) /
          dayEntries.length;
      trendPoints.add(
        MoodTrendPoint(
          date: day,
          averageScore: avg,
          entryCount: dayEntries.length,
        ),
      );
    }
  }

  final streak = _calculateStreak(entries, today);

  return MoodStats(
    weeklyAverage: averageForPeriod(weekStart),
    monthlyAverage: averageForPeriod(monthStart),
    streak: streak,
    distribution: distribution,
    trendPoints: trendPoints,
    totalEntries: entries.length,
  );
}

int _calculateStreak(List<MoodEntry> entries, DateTime today) {
  final daysWithEntries = <DateTime>{};
  for (final entry in entries) {
    final d = entry.createdAt;
    daysWithEntries.add(DateTime(d.year, d.month, d.day));
  }

  var streak = 0;
  var cursor = today;
  while (daysWithEntries.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

final moodStatsProvider = Provider<MoodStats>((ref) {
  final moods = ref.watch(moodListProvider);
  return computeMoodStats(moods);
});

final analyticsProvider = moodStatsProvider;
