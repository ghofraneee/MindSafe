import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindsafe/core/widgets/mood_emoji.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

void main() {
  testWidgets('MoodEmoji displays the correct emoji', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MoodEmoji(mood: MoodType.amazing),
        ),
      ),
    );

    expect(find.text('😊'), findsOneWidget);
  });

  testWidgets('MoodEmoji shows label when showLabel is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MoodEmoji(
            mood: MoodType.sad,
            showLabel: true,
          ),
        ),
      ),
    );

    expect(find.text('😔'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);
  });

  testWidgets('MoodEmojiPicker renders all mood options', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodEmojiPicker(
            selectedMood: MoodType.neutral,
            onMoodSelected: (_) {},
            showLabels: false,
          ),
        ),
      ),
    );

    for (final mood in MoodType.values) {
      expect(find.text(mood.emoji), findsOneWidget);
    }
  });

  testWidgets('MoodEmoji calls onTap when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodEmoji(
            mood: MoodType.good,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('🙂'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
