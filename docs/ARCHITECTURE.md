# MindSafe Architecture

This document describes the architectural decisions, data flow, and implementation patterns used in MindSafe.

## Overview

MindSafe uses **feature-first Clean Architecture** with three layers per feature:

1. **Domain** — Pure Dart business logic (entities, repository interfaces, failures)
2. **Data** — Persistence and external I/O (models, repository implementations)
3. **Presentation** — Flutter UI and Riverpod state (screens, widgets, providers)

Dependencies flow inward: Presentation → Domain ← Data. The domain layer has no Flutter or infrastructure imports (except where entities require framework types like `ThemeMode`).

## State management

### Riverpod providers

| Provider | Type | Responsibility |
|----------|------|----------------|
| `authNotifierProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | Session lifecycle |
| `moodNotifierProvider` | `StateNotifierProvider<MoodNotifier, MoodState>` | Mood list and today's entry |
| `journalNotifierProvider` | `StateNotifierProvider<JournalNotifier, JournalState>` | Entries, search, drafts |
| `settingsNotifierProvider` | `StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>` | Preferences |
| `routerProvider` | `Provider<GoRouter>` | Navigation |
| `storageServiceProvider` | `Provider<StorageService>` | Global storage (overridden at startup) |

### Freezed state classes

State and entity classes use `@freezed` for:

- Immutable data with `copyWith`
- Union types for `AuthState` (`initial`, `loading`, `authenticated`, `unauthenticated`, `error`)
- JSON serialization where persistence is needed
- Generated `maybeWhen` / `when` for exhaustive pattern matching

Example auth flow:

```dart
// AuthNotifier sets union states
state = const AuthState.loading();
state = AuthState.authenticated(user);

// UI reads with maybeWhen
ref.watch(authNotifierProvider).maybeWhen(
  authenticated: (user) => HomeScreen(user: user),
  orElse: () => LoginScreen(),
);
```

## Data persistence

### StorageService

Central service managing:

- **5 encrypted Hive boxes**: users, moods, journals, settings, drafts
- **Secure storage**: encryption key, session token, PIN hash/salt, biometric flag

```
┌─────────────────────────────────────────┐
│              StorageService              │
├─────────────┬───────────────────────────┤
│ Hive Boxes  │ Flutter Secure Storage    │
│ (AES-256)   │ (Keychain / Encrypted SP) │
├─────────────┼───────────────────────────┤
│ users       │ encryption_key            │
│ moods       │ session_token             │
│ journals    │ remember_me               │
│ settings    │ pin_hash / pin_salt       │
│ drafts      │ biometric_enabled         │
└─────────────┴───────────────────────────┘
```

### Repository pattern

Each feature defines an abstract repository in `domain/repositories/` and implements it in `data/repositories/`:

```
AuthRepository (interface)
    └── AuthRepositoryImpl
            ├── StorageService (users box + secure storage)
            └── BiometricService
```

Repositories map between **models** (JSON/Hive shape) and **entities** (domain shape):

- `UserModel` includes `passwordHash` / `passwordSalt` — never exposed via `UserEntity`
- `MoodEntryModel` ↔ `MoodEntry` via `fromEntity()` / `toEntity()`
- `JournalEntryModel` stores `moodTag` as `String?`; entity uses `MoodType?`

### JSON converters

Custom `JsonConverter` classes in `lib/core/utils/`:

| Converter | Maps |
|-----------|------|
| `MoodTypeConverter` | `MoodType` ↔ mood name `String` |
| `MoodTypeNullableConverter` | `MoodType?` ↔ `String?` |
| `ThemeModeConverter` | `ThemeMode` ↔ `int` index |

## Authentication

### Local auth simulation

Passwords are hashed with salted SHA-256 (`PasswordHasher`). This is suitable for a portfolio demo — production apps should use Argon2/bcrypt and server-side auth.

### Session model

1. Login succeeds → user ID stored in memory (`_inMemorySessionUserId`)
2. If "Remember me" → user ID persisted to secure storage
3. App restart → session restored only when remember-me flag is `true`
4. Biometric login requires remembered session + biometric flag

### Demo seeding

`AuthRepositoryImpl._ensureDemoUser()` creates `sarah@mindsafe.app` on first access when no users exist.

## Privacy architecture

### PrivacyService

Singleton-style service (via Riverpod) that:

- Observes app lifecycle (`WidgetsBindingObserver`)
- Runs inactivity timer (5 min → lock)
- Runs auto-logout timer (30 min → logout callback)
- Blocks screenshots via platform channel

### PrivacyGuard widget

Wraps `MaterialApp.router` builder output when user is authenticated:

```
MaterialApp.router
  └── builder
        └── PrivacyGuard (if authenticated)
              └── Listener (pointer → recordActivity)
                    └── Stack
                          ├── child (router content)
                          └── PinLockScreen overlay (if locked)
```

PrivacyGuard reads `settingsNotifierProvider` for `pinEnabled`. When disabled, the guard passes through without timers.

## Navigation

GoRouter with:

- Auth routes: `/splash`, `/welcome`, `/login`, `/register`
- `StatefulShellRoute.indexedStack` for bottom navigation (home, mood, journal, analytics, profile)
- Modal routes: `/settings`, `/settings/pin`, wellness screens

`PrivacyGuard` does not replace routing — it overlays PIN UI on top of the current route.

## Error handling

### Auth failures

Sealed `AuthFailure` hierarchy with user-facing messages:

- `InvalidCredentialsFailure`
- `EmailAlreadyExistsFailure`
- `BiometricAuthFailure`
- etc.

`AuthNotifier._messageFrom()` maps failures to UI snackbar text.

### Async settings

`SettingsNotifier` uses `AsyncValue<AppSettings>` for loading/error states during persistence operations.

## Testing architecture

### In-memory storage

`StorageService.inMemory()` provides:

- `_InMemoryBox` implementing Hive `Box<dynamic>`
- `InMemorySecureStore` for secure key/value pairs

`FakeStorageService` in tests extends this for zero-setup repository tests.

### Test layers

| Test file | Scope |
|-----------|-------|
| `auth_repository_test.dart` | Login, register, demo seed, logout |
| `mood_repository_test.dart` | CRUD, user-scoped clear |
| `journal_repository_test.dart` | CRUD, search, filter, drafts |
| `login_screen_test.dart` | Form validation, demo login navigation |
| `mood_emoji_test.dart` | Emoji display, labels, tap callbacks |

### Build runner dependency

Freezed-generated `.freezed.dart` and `.g.dart` files must exist before analyzer/tests pass:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Code generation

Files requiring `build_runner`:

```
*_entity.dart, *_model.dart, *_state.dart, app_settings.dart
  → *.freezed.dart (immutable classes, copyWith, unions)
  → *.g.dart (JSON serialization)
```

Do not hand-edit generated files. Regenerate after model changes.

## Design decisions

| Decision | Rationale |
|----------|-----------|
| Hive over SQLite | Simple key-value/list/map storage for portfolio scale |
| Riverpod over Bloc | Less boilerplate, compile-safe providers |
| Freezed over Equatable | Union types, JSON, copyWith in one package |
| Feature folders | Co-locate related code; scale to team ownership |
| Local-only auth | Demo/portfolio focus on privacy UX without backend |
| GoRouter shell route | Native-feeling bottom nav with preserved state |

## Extension points

To add a new feature:

1. Create `lib/features/<name>/domain/entities/`
2. Define `domain/repositories/<name>_repository.dart`
3. Implement `data/repositories/<name>_repository_impl.dart`
4. Add `presentation/providers/` with Riverpod notifier
5. Register routes in `app_router.dart`
6. Add repository test with `FakeStorageService`
