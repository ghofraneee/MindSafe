import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ThemeModeConverter implements JsonConverter<ThemeMode, int> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(int json) {
    if (json >= 0 && json < ThemeMode.values.length) {
      return ThemeMode.values[json];
    }
    return ThemeMode.system;
  }

  @override
  int toJson(ThemeMode object) => object.index;
}
