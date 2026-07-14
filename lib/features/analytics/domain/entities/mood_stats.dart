import 'package:mindsafe/features/analytics/domain/entities/mood_trend_point.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class MoodStats {
  const MoodStats({
    required this.weeklyAverage,
    required this.monthlyAverage,
    required this.streak,
    required this.distribution,
    required this.trendPoints,
    required this.totalEntries,
  });

  final double weeklyAverage;
  final double monthlyAverage;
  final int streak;
  final Map<MoodType, int> distribution;
  final List<MoodTrendPoint> trendPoints;
  final int totalEntries;

  factory MoodStats.empty() => const MoodStats(
        weeklyAverage: 0,
        monthlyAverage: 0,
        streak: 0,
        distribution: {},
        trendPoints: [],
        totalEntries: 0,
      );
}
