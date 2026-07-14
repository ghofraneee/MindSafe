// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using MyClass._(). This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the Freezed documentation here for more informations: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get pinEnabled => throw _privateConstructorUsedError;
  bool get biometricEnabled => throw _privateConstructorUsedError;
  bool get hideScreenshots => throw _privateConstructorUsedError;
  bool get moodReminders => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {@ThemeModeConverter() ThemeMode themeMode,
      bool notificationsEnabled,
      String language,
      bool pinEnabled,
      bool biometricEnabled,
      bool hideScreenshots,
      bool moodReminders});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? notificationsEnabled = null,
    Object? language = null,
    Object? pinEnabled = null,
    Object? biometricEnabled = null,
    Object? hideScreenshots = null,
    Object? moodReminders = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      pinEnabled: null == pinEnabled
          ? _value.pinEnabled
          : pinEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricEnabled: null == biometricEnabled
          ? _value.biometricEnabled
          : biometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hideScreenshots: null == hideScreenshots
          ? _value.hideScreenshots
          : hideScreenshots // ignore: cast_nullable_to_non_nullable
              as bool,
      moodReminders: null == moodReminders
          ? _value.moodReminders
          : moodReminders // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@ThemeModeConverter() ThemeMode themeMode,
      bool notificationsEnabled,
      String language,
      bool pinEnabled,
      bool biometricEnabled,
      bool hideScreenshots,
      bool moodReminders});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? notificationsEnabled = null,
    Object? language = null,
    Object? pinEnabled = null,
    Object? biometricEnabled = null,
    Object? hideScreenshots = null,
    Object? moodReminders = null,
  }) {
    return _then(_$AppSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      pinEnabled: null == pinEnabled
          ? _value.pinEnabled
          : pinEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      biometricEnabled: null == biometricEnabled
          ? _value.biometricEnabled
          : biometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hideScreenshots: null == hideScreenshots
          ? _value.hideScreenshots
          : hideScreenshots // ignore: cast_nullable_to_non_nullable
              as bool,
      moodReminders: null == moodReminders
          ? _value.moodReminders
          : moodReminders // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {@ThemeModeConverter() this.themeMode = ThemeMode.system,
      this.notificationsEnabled = true,
      this.language = 'en',
      this.pinEnabled = false,
      this.biometricEnabled = false,
      this.hideScreenshots = true,
      this.moodReminders = true});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final bool pinEnabled;
  @override
  @JsonKey()
  final bool biometricEnabled;
  @override
  @JsonKey()
  final bool hideScreenshots;
  @override
  @JsonKey()
  final bool moodReminders;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, notificationsEnabled: $notificationsEnabled, language: $language, pinEnabled: $pinEnabled, biometricEnabled: $biometricEnabled, hideScreenshots: $hideScreenshots, moodReminders: $moodReminders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.pinEnabled, pinEnabled) ||
                other.pinEnabled == pinEnabled) &&
            (identical(other.biometricEnabled, biometricEnabled) ||
                other.biometricEnabled == biometricEnabled) &&
            (identical(other.hideScreenshots, hideScreenshots) ||
                other.hideScreenshots == hideScreenshots) &&
            (identical(other.moodReminders, moodReminders) ||
                other.moodReminders == moodReminders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      themeMode,
      notificationsEnabled,
      language,
      pinEnabled,
      biometricEnabled,
      hideScreenshots,
      moodReminders);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {@ThemeModeConverter() final ThemeMode themeMode,
      final bool notificationsEnabled,
      final String language,
      final bool pinEnabled,
      final bool biometricEnabled,
      final bool hideScreenshots,
      final bool moodReminders}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  bool get notificationsEnabled;
  @override
  String get language;
  @override
  bool get pinEnabled;
  @override
  bool get biometricEnabled;
  @override
  bool get hideScreenshots;
  @override
  bool get moodReminders;

  @override
  Map<String, dynamic> toJson();
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
