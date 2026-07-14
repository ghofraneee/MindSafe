import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/core/utils/mood_type_converter.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

part 'mood_entry.freezed.dart';
part 'mood_entry.g.dart';

@freezed
class MoodEntry with _$MoodEntry {
  const factory MoodEntry({
    required String id,
    required String userId,
    @MoodTypeConverter() required MoodType mood,
    required DateTime createdAt,
    @Default(5.0) double energyLevel,
    @Default(5.0) double stressLevel,
    @Default(7.0) double sleepHours,
    String? notes,
  }) = _MoodEntry;

  factory MoodEntry.fromJson(Map<String, dynamic> json) =>
      _$MoodEntryFromJson(json);
}
