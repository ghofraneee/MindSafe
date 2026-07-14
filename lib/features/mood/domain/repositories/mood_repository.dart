import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';

abstract class MoodRepository {
  Future<List<MoodEntry>> getMoods({String? userId});

  Future<MoodEntry> saveMood(MoodEntry entry);

  Future<void> deleteMood(String id);

  Future<void> clearMoods({String? userId});
}
