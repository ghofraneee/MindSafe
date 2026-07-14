import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class MoodTrendPoint {
  const MoodTrendPoint({
    required this.date,
    required this.averageScore,
    required this.entryCount,
  });

  final DateTime date;
  final double averageScore;
  final int entryCount;
}
