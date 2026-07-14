import 'package:flutter/material.dart';

/// User achievement badge for wellness milestones.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    bool? unlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
