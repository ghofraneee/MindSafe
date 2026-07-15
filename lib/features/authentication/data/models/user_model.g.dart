// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      passwordHash: json['passwordHash'] as String,
      passwordSalt: json['passwordSalt'] as String,
      avatarPath: json['avatarPath'] as String?,
      wellnessScore: (json['wellnessScore'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'passwordHash': instance.passwordHash,
      'passwordSalt': instance.passwordSalt,
      'avatarPath': instance.avatarPath,
      'wellnessScore': instance.wellnessScore,
      'streak': instance.streak,
      'createdAt': instance.createdAt.toIso8601String(),
    };
