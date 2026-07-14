import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/core/utils/mood_type_converter.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

part 'mood_entry_model.freezed.dart';
part 'mood_entry_model.g.dart';

@freezed
class MoodEntryModel with _$MoodEntryModel {
  const MoodEntryModel._();

  const factory MoodEntryModel({
    required String id,
    required String userId,
    @MoodTypeConverter() required MoodType mood,
    required DateTime createdAt,
    @Default(5.0) double energyLevel,
    @Default(5.0) double stressLevel,
    @Default(7.0) double sleepHours,
    @JsonKey(readValue: _readNotes) String? notes,
  }) = _MoodEntryModel;

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) =>
      _$MoodEntryModelFromJson(json);

  factory MoodEntryModel.fromEntity(MoodEntry entry) => MoodEntryModel(
        id: entry.id,
        userId: entry.userId,
        mood: entry.mood,
        createdAt: entry.createdAt,
        energyLevel: entry.energyLevel,
        stressLevel: entry.stressLevel,
        sleepHours: entry.sleepHours,
        notes: entry.notes,
      );

  MoodEntry toEntity() => MoodEntry(
        id: id,
        userId: userId,
        mood: mood,
        createdAt: createdAt,
        energyLevel: energyLevel,
        stressLevel: stressLevel,
        sleepHours: sleepHours,
        notes: notes,
      );
}

Object? _readNotes(Map<dynamic, dynamic> json, String key) {
  return json['notes'] ?? json['note'];
}
