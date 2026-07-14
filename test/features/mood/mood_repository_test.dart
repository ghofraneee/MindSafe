import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:mindsafe/features/mood/data/repositories/mood_repository_impl.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

import '../../mocks/mock_services.dart';

void main() {
  late FakeStorageService storage;
  late MoodRepositoryImpl repository;
  const userId = 'user-1';
  const uuid = Uuid();

  setUp(() {
    storage = FakeStorageService();
    repository = MoodRepositoryImpl(storageService: storage);
  });

  MoodEntry buildEntry({MoodType mood = MoodType.good}) => MoodEntry(
        id: uuid.v4(),
        userId: userId,
        mood: mood,
        createdAt: DateTime(2024, 6, 1, 10),
        notes: 'Feeling okay',
      );

  group('MoodRepositoryImpl', () {
    test('returns empty list when no moods stored', () async {
      final moods = await repository.getMoods(userId: userId);
      expect(moods, isEmpty);
    });

    test('saves and retrieves mood entries', () async {
      final entry = buildEntry();
      await repository.saveMood(entry);

      final moods = await repository.getMoods(userId: userId);
      expect(moods, hasLength(1));
      expect(moods.first.id, entry.id);
      expect(moods.first.mood, MoodType.good);
      expect(moods.first.notes, 'Feeling okay');
    });

    test('updates an existing mood entry', () async {
      final entry = buildEntry();
      await repository.saveMood(entry);

      final updated = entry.copyWith(
        mood: MoodType.amazing,
        notes: 'Great day',
      );
      await repository.saveMood(updated);

      final moods = await repository.getMoods(userId: userId);
      expect(moods.single.mood, MoodType.amazing);
      expect(moods.single.notes, 'Great day');
    });

    test('deletes a mood entry', () async {
      final entry = buildEntry();
      await repository.saveMood(entry);

      await repository.deleteMood(entry.id);

      final moods = await repository.getMoods(userId: userId);
      expect(moods, isEmpty);
    });

    test('clears moods for a specific user', () async {
      await repository.saveMood(buildEntry());
      await repository.saveMood(
        buildEntry().copyWith(
          id: uuid.v4(),
          userId: 'other-user',
        ),
      );

      await repository.clearMoods(userId: userId);

      final allMoods = await repository.getMoods();
      expect(allMoods, hasLength(1));
      expect(allMoods.single.userId, 'other-user');
    });
  });
}
