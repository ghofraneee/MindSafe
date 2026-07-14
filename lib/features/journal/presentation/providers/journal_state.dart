import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/features/journal/domain/entities/journal_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

part 'journal_state.freezed.dart';

@freezed
class JournalState with _$JournalState {
  const factory JournalState({
    @Default([]) List<JournalEntry> entries,
    @Default([]) List<JournalEntry> filteredEntries,
    @Default('') String searchQuery,
    MoodType? moodFilter,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
    JournalEntry? draft,
    @Default(false) bool isDraftSaving,
  }) = _JournalState;
}
