import 'package:flutter/material.dart';

import 'package:mindsafe/core/constants/app_colors.dart';

/// Represents the five mood levels tracked in MindSafe.
enum MoodType {
  amazing,
  good,
  neutral,
  sad,
  veryBad;

  String get emoji => switch (this) {
        MoodType.amazing => '😊',
        MoodType.good => '🙂',
        MoodType.neutral => '😐',
        MoodType.sad => '😔',
        MoodType.veryBad => '😢',
      };

  String get label => switch (this) {
        MoodType.amazing => 'Amazing',
        MoodType.good => 'Good',
        MoodType.neutral => 'Neutral',
        MoodType.sad => 'Sad',
        MoodType.veryBad => 'Very Bad',
      };

  Color get color => switch (this) {
        MoodType.amazing => AppColors.moodAmazing,
        MoodType.good => AppColors.moodGood,
        MoodType.neutral => AppColors.moodNeutral,
        MoodType.sad => AppColors.moodSad,
        MoodType.veryBad => AppColors.moodVeryBad,
      };

  /// Numeric score from 1 (very bad) to 5 (amazing).
  int get score => switch (this) {
        MoodType.amazing => 5,
        MoodType.good => 4,
        MoodType.neutral => 3,
        MoodType.sad => 2,
        MoodType.veryBad => 1,
      };

  /// Parses a stored mood name; falls back to [MoodType.neutral] when unknown.
  static MoodType fromName(String name) {
    for (final mood in MoodType.values) {
      if (mood.name == name) return mood;
    }
    return MoodType.neutral;
  }

  /// Parses a nullable mood name (e.g. journal mood tags).
  static MoodType? tryFromName(String? name) {
    if (name == null || name.isEmpty) return null;
    for (final mood in MoodType.values) {
      if (mood.name == name) return mood;
    }
    return null;
  }
}
