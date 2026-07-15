// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoodState {
  List<MoodEntry> get moods => throw _privateConstructorUsedError;
  MoodEntry? get todayMood => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoodStateCopyWith<MoodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodStateCopyWith<$Res> {
  factory $MoodStateCopyWith(MoodState value, $Res Function(MoodState) then) =
      _$MoodStateCopyWithImpl<$Res, MoodState>;
  @useResult
  $Res call(
      {List<MoodEntry> moods,
      MoodEntry? todayMood,
      bool isLoading,
      bool isSaving,
      String? errorMessage});

  $MoodEntryCopyWith<$Res>? get todayMood;
}

/// @nodoc
class _$MoodStateCopyWithImpl<$Res, $Val extends MoodState>
    implements $MoodStateCopyWith<$Res> {
  _$MoodStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moods = null,
    Object? todayMood = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      moods: null == moods
          ? _value.moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<MoodEntry>,
      todayMood: freezed == todayMood
          ? _value.todayMood
          : todayMood // ignore: cast_nullable_to_non_nullable
              as MoodEntry?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MoodEntryCopyWith<$Res>? get todayMood {
    if (_value.todayMood == null) {
      return null;
    }

    return $MoodEntryCopyWith<$Res>(_value.todayMood!, (value) {
      return _then(_value.copyWith(todayMood: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MoodStateImplCopyWith<$Res>
    implements $MoodStateCopyWith<$Res> {
  factory _$$MoodStateImplCopyWith(
          _$MoodStateImpl value, $Res Function(_$MoodStateImpl) then) =
      __$$MoodStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MoodEntry> moods,
      MoodEntry? todayMood,
      bool isLoading,
      bool isSaving,
      String? errorMessage});

  @override
  $MoodEntryCopyWith<$Res>? get todayMood;
}

/// @nodoc
class __$$MoodStateImplCopyWithImpl<$Res>
    extends _$MoodStateCopyWithImpl<$Res, _$MoodStateImpl>
    implements _$$MoodStateImplCopyWith<$Res> {
  __$$MoodStateImplCopyWithImpl(
      _$MoodStateImpl _value, $Res Function(_$MoodStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moods = null,
    Object? todayMood = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$MoodStateImpl(
      moods: null == moods
          ? _value._moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<MoodEntry>,
      todayMood: freezed == todayMood
          ? _value.todayMood
          : todayMood // ignore: cast_nullable_to_non_nullable
              as MoodEntry?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MoodStateImpl implements _MoodState {
  const _$MoodStateImpl(
      {final List<MoodEntry> moods = const [],
      this.todayMood,
      this.isLoading = false,
      this.isSaving = false,
      this.errorMessage})
      : _moods = moods;

  final List<MoodEntry> _moods;
  @override
  @JsonKey()
  List<MoodEntry> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  @override
  final MoodEntry? todayMood;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MoodState(moods: $moods, todayMood: $todayMood, isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodStateImpl &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            (identical(other.todayMood, todayMood) ||
                other.todayMood == todayMood) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moods),
      todayMood,
      isLoading,
      isSaving,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodStateImplCopyWith<_$MoodStateImpl> get copyWith =>
      __$$MoodStateImplCopyWithImpl<_$MoodStateImpl>(this, _$identity);
}

abstract class _MoodState implements MoodState {
  const factory _MoodState(
      {final List<MoodEntry> moods,
      final MoodEntry? todayMood,
      final bool isLoading,
      final bool isSaving,
      final String? errorMessage}) = _$MoodStateImpl;

  @override
  List<MoodEntry> get moods;
  @override
  MoodEntry? get todayMood;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$MoodStateImplCopyWith<_$MoodStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
