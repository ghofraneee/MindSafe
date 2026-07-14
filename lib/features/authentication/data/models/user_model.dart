import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required String passwordHash,
    required String passwordSalt,
    String? avatarPath,
    @Default(0) int wellnessScore,
    @Default(0) int streak,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        name: name,
        avatarPath: avatarPath,
        wellnessScore: wellnessScore,
        streak: streak,
        createdAt: createdAt,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        passwordHash: '',
        passwordSalt: '',
        avatarPath: entity.avatarPath,
        wellnessScore: entity.wellnessScore,
        streak: entity.streak,
        createdAt: entity.createdAt,
      );

  factory UserModel.fromEntityWithCredentials({
    required UserEntity entity,
    required String passwordHash,
    required String passwordSalt,
  }) =>
      UserModel(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        passwordHash: passwordHash,
        passwordSalt: passwordSalt,
        avatarPath: entity.avatarPath,
        wellnessScore: entity.wellnessScore,
        streak: entity.streak,
        createdAt: entity.createdAt,
      );
}
