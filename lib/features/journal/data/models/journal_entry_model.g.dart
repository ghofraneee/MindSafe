// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryModelImpl _$$JournalEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$JournalEntryModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      moodTag: json['moodTag'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDraft: json['isDraft'] as bool? ?? false,
    );

Map<String, dynamic> _$$JournalEntryModelImplToJson(
        _$JournalEntryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'moodTag': instance.moodTag,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isDraft': instance.isDraft,
    };
