import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/journal_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

part 'journal_entry_model.freezed.dart';
part 'journal_entry_model.g.dart';

@freezed
class JournalEntryModel with _$JournalEntryModel {
  const JournalEntryModel._();

  const factory JournalEntryModel({
    required String id,
    required String title,
    required String description,
    String? moodTag,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDraft,
  }) = _JournalEntryModel;

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);

  JournalEntry toEntity() => JournalEntry(
        id: id,
        title: title,
        description: description,
        moodTag: MoodType.tryFromName(moodTag),
        createdAt: createdAt,
        updatedAt: updatedAt,
        isDraft: isDraft,
      );

  factory JournalEntryModel.fromEntity(JournalEntry entity) =>
      JournalEntryModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        moodTag: entity.moodTag?.name,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isDraft: entity.isDraft,
      );
}
