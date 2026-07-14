import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:mindsafe/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:mindsafe/features/journal/domain/entities/journal_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

import '../../mocks/mock_services.dart';

void main() {
  late FakeStorageService storage;
  late JournalRepositoryImpl repository;
  const uuid = Uuid();

  setUp(() {
    storage = FakeStorageService();
    repository = JournalRepositoryImpl(storageService: storage);
  });

  JournalEntry buildEntry({
    String id = 'entry-1',
    String title = 'Morning reflection',
    MoodType? moodTag = MoodType.good,
    bool isDraft = false,
  }) =>
      JournalEntry(
        id: id,
        title: title,
        description: 'Today I felt calm and focused.',
        moodTag: moodTag,
        createdAt: DateTime(2024, 6, 1, 8),
        updatedAt: DateTime(2024, 6, 1, 8),
        isDraft: isDraft,
      );

  group('JournalRepositoryImpl', () {
    test('saves and retrieves journal entries', () async {
      final entry = buildEntry();
      await repository.saveEntry(entry);

      final entries = await repository.getAllEntries();
      expect(entries, hasLength(1));
      expect(entries.first.title, 'Morning reflection');
      expect(entries.first.moodTag, MoodType.good);
    });

    test('updates an existing entry', () async {
      final entry = buildEntry();
      await repository.saveEntry(entry);

      final updated = entry.copyWith(
        title: 'Updated title',
        updatedAt: DateTime(2024, 6, 2, 9),
      );
      await repository.updateEntry(updated);

      final stored = await repository.getEntryById(entry.id);
      expect(stored?.title, 'Updated title');
    });

    test('deletes an entry', () async {
      await repository.saveEntry(buildEntry());
      await repository.deleteEntry('entry-1');

      final entries = await repository.getAllEntries();
      expect(entries, isEmpty);
    });

    test('searches entries by title or description', () async {
      await repository.saveEntry(buildEntry());
      await repository.saveEntry(
        buildEntry(
          id: 'entry-2',
          title: 'Evening thoughts',
          moodTag: MoodType.neutral,
        ),
      );

      final results = await repository.search('evening');
      expect(results, hasLength(1));
      expect(results.first.title, 'Evening thoughts');
    });

    test('filters entries by mood tag', () async {
      await repository.saveEntry(buildEntry());
      await repository.saveEntry(
        buildEntry(
          id: 'entry-2',
          title: 'Tough day',
          moodTag: MoodType.sad,
        ),
      );

      final sadEntries = await repository.filterByMood(MoodType.sad);
      expect(sadEntries, hasLength(1));
      expect(sadEntries.first.moodTag, MoodType.sad);
    });

    test('saves and clears draft entries', () async {
      final draft = buildEntry(id: uuid.v4(), isDraft: true);
      await repository.saveDraft(draft);

      final loaded = await repository.getDraft();
      expect(loaded?.isDraft, isTrue);
      expect(loaded?.title, draft.title);

      await repository.clearDraft();
      expect(await repository.getDraft(), isNull);
    });

    test('published entries exclude drafts from list', () async {
      await repository.saveEntry(buildEntry());
      await repository.saveDraft(
        buildEntry(id: 'draft-1', title: 'Draft note', isDraft: true),
      );

      final entries = await repository.getAllEntries();
      expect(entries, hasLength(1));
      expect(entries.first.title, 'Morning reflection');
    });
  });
}
