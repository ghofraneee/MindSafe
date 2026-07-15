// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodEntryImpl _$$MoodEntryImplFromJson(Map<String, dynamic> json) =>
    _$MoodEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mood: const MoodTypeConverter().fromJson(json['mood'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      energyLevel: (json['energyLevel'] as num?)?.toDouble() ?? 5.0,
      stressLevel: (json['stressLevel'] as num?)?.toDouble() ?? 5.0,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 7.0,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$MoodEntryImplToJson(_$MoodEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mood': const MoodTypeConverter().toJson(instance.mood),
      'createdAt': instance.createdAt.toIso8601String(),
      'energyLevel': instance.energyLevel,
      'stressLevel': instance.stressLevel,
      'sleepHours': instance.sleepHours,
      'notes': instance.notes,
    };
