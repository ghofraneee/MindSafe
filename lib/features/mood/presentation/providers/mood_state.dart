import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';

part 'mood_state.freezed.dart';

@freezed
class MoodState with _$MoodState {
  const factory MoodState({
    @Default([]) List<MoodEntry> moods,
    MoodEntry? todayMood,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _MoodState;
}
