import 'package:json_annotation/json_annotation.dart';

import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class MoodTypeConverter implements JsonConverter<MoodType, String> {
  const MoodTypeConverter();

  @override
  MoodType fromJson(String json) => MoodType.fromName(json);

  @override
  String toJson(MoodType object) => object.name;
}

class MoodTypeNullableConverter implements JsonConverter<MoodType?, String?> {
  const MoodTypeNullableConverter();

  @override
  MoodType? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return MoodType.fromName(json);
  }

  @override
  String? toJson(MoodType? object) => object?.name;
}
