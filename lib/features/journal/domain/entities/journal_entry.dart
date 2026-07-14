import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/core/utils/mood_type_converter.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

part 'journal_entry.freezed.dart';

@freezed
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required String title,
    required String description,
    @MoodTypeNullableConverter() MoodType? moodTag,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDraft,
  }) = _JournalEntry;
}
