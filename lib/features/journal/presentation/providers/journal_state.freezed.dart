// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off

part of 'journal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using MyClass._(). This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the Freezed documentation here for more informations: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JournalState {
  List<JournalEntry> get entries => throw _privateConstructorUsedError;
  List<JournalEntry> get filteredEntries => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  MoodType? get moodFilter => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  JournalEntry? get draft => throw _privateConstructorUsedError;
  bool get isDraftSaving => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalStateCopyWith<JournalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalStateCopyWith<$Res> {
  factory $JournalStateCopyWith(
          JournalState value, $Res Function(JournalState) then) =
      _$JournalStateCopyWithImpl<$Res, JournalState>;
  @useResult
  $Res call(
      {List<JournalEntry> entries,
      List<JournalEntry> filteredEntries,
      String searchQuery,
      MoodType? moodFilter,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      JournalEntry? draft,
      bool isDraftSaving});

  $JournalEntryCopyWith<$Res>? get draft;
}

/// @nodoc
class _$JournalStateCopyWithImpl<$Res, $Val extends JournalState>
    implements $JournalStateCopyWith<$Res> {
  _$JournalStateCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? filteredEntries = null,
    Object? searchQuery = null,
    Object? moodFilter = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? draft = freezed,
    Object? isDraftSaving = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<JournalEntry>,
      filteredEntries: null == filteredEntries
          ? _value.filteredEntries
          : filteredEntries // ignore: cast_nullable_to_non_nullable
              as List<JournalEntry>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      moodFilter: freezed == moodFilter
          ? _value.moodFilter
          : moodFilter // ignore: cast_nullable_to_non_nullable
              as MoodType?,
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
      draft: freezed == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as JournalEntry?,
      isDraftSaving: null == isDraftSaving
          ? _value.isDraftSaving
          : isDraftSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $JournalEntryCopyWith<$Res>? get draft {
    if (_value.draft == null) {
      return null;
    }

    return $JournalEntryCopyWith<$Res>(_value.draft!, (value) {
      return _then(_value.copyWith(draft: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalStateImplCopyWith<$Res>
    implements $JournalStateCopyWith<$Res> {
  factory _$$JournalStateImplCopyWith(
          _$JournalStateImpl value, $Res Function(_$JournalStateImpl) then) =
      __$$JournalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<JournalEntry> entries,
      List<JournalEntry> filteredEntries,
      String searchQuery,
      MoodType? moodFilter,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      JournalEntry? draft,
      bool isDraftSaving});

  @override
  $JournalEntryCopyWith<$Res>? get draft;
}

/// @nodoc
class __$$JournalStateImplCopyWithImpl<$Res>
    extends _$JournalStateCopyWithImpl<$Res, _$JournalStateImpl>
    implements _$$JournalStateImplCopyWith<$Res> {
  __$$JournalStateImplCopyWithImpl(
      _$JournalStateImpl _value, $Res Function(_$JournalStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? filteredEntries = null,
    Object? searchQuery = null,
    Object? moodFilter = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? draft = freezed,
    Object? isDraftSaving = null,
  }) {
    return _then(_$JournalStateImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<JournalEntry>,
      filteredEntries: null == filteredEntries
          ? _value._filteredEntries
          : filteredEntries // ignore: cast_nullable_to_non_nullable
              as List<JournalEntry>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      moodFilter: freezed == moodFilter
          ? _value.moodFilter
          : moodFilter // ignore: cast_nullable_to_non_nullable
              as MoodType?,
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
      draft: freezed == draft
          ? _value.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as JournalEntry?,
      isDraftSaving: null == isDraftSaving
          ? _value.isDraftSaving
          : isDraftSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
class _$JournalStateImpl implements _JournalState {
  const _$JournalStateImpl(
      {final List<JournalEntry> entries = const [],
      final List<JournalEntry> filteredEntries = const [],
      this.searchQuery = '',
      this.moodFilter,
      this.isLoading = false,
      this.isSaving = false,
      this.errorMessage,
      this.draft,
      this.isDraftSaving = false})
      : _entries = entries,
        _filteredEntries = filteredEntries;

  final List<JournalEntry> _entries;
  @override
  @JsonKey()
  List<JournalEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    return EqualUnmodifiableListView(_entries);
  }

  final List<JournalEntry> _filteredEntries;
  @override
  @JsonKey()
  List<JournalEntry> get filteredEntries {
    if (_filteredEntries is EqualUnmodifiableListView) return _filteredEntries;
    return EqualUnmodifiableListView(_filteredEntries);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  final MoodType? moodFilter;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? errorMessage;
  @override
  final JournalEntry? draft;
  @override
  @JsonKey()
  final bool isDraftSaving;

  @override
  String toString() {
    return 'JournalState(entries: $entries, filteredEntries: $filteredEntries, searchQuery: $searchQuery, moodFilter: $moodFilter, isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage, draft: $draft, isDraftSaving: $isDraftSaving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalStateImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality()
                .equals(other._filteredEntries, _filteredEntries) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.moodFilter, moodFilter) ||
                other.moodFilter == moodFilter) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.isDraftSaving, isDraftSaving) ||
                other.isDraftSaving == isDraftSaving));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      const DeepCollectionEquality().hash(_filteredEntries),
      searchQuery,
      moodFilter,
      isLoading,
      isSaving,
      errorMessage,
      draft,
      isDraftSaving);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalStateImplCopyWith<_$JournalStateImpl> get copyWith =>
      __$$JournalStateImplCopyWithImpl<_$JournalStateImpl>(this, _$identity);
}

abstract class _JournalState implements JournalState {
  const factory _JournalState(
      {final List<JournalEntry> entries,
      final List<JournalEntry> filteredEntries,
      final String searchQuery,
      final MoodType? moodFilter,
      final bool isLoading,
      final bool isSaving,
      final String? errorMessage,
      final JournalEntry? draft,
      final bool isDraftSaving}) = _$JournalStateImpl;

  @override
  List<JournalEntry> get entries;
  @override
  List<JournalEntry> get filteredEntries;
  @override
  String get searchQuery;
  @override
  MoodType? get moodFilter;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  String? get errorMessage;
  @override
  JournalEntry? get draft;
  @override
  bool get isDraftSaving;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalStateImplCopyWith<_$JournalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
