import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mindsafe/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:mindsafe/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:mindsafe/features/authentication/presentation/screens/login_screen.dart';
import 'package:mindsafe/features/authentication/presentation/screens/register_screen.dart';
import 'package:mindsafe/features/authentication/presentation/screens/splash_screen.dart';
import 'package:mindsafe/features/authentication/presentation/screens/welcome_screen.dart';
import 'package:mindsafe/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:mindsafe/features/home/presentation/screens/main_shell.dart';
import 'package:mindsafe/features/journal/presentation/screens/journal_editor_screen.dart';
import 'package:mindsafe/features/journal/presentation/screens/journal_list_screen.dart';
import 'package:mindsafe/features/mood/presentation/screens/mood_history_screen.dart';
import 'package:mindsafe/features/mood/presentation/screens/mood_tracker_screen.dart';
import 'package:mindsafe/features/profile/presentation/screens/profile_screen.dart';
import 'package:mindsafe/features/settings/presentation/screens/pin_lock_screen.dart';
import 'package:mindsafe/features/settings/presentation/screens/settings_screen.dart';
import 'package:mindsafe/features/wellness/presentation/screens/breathing_exercise_screen.dart';
import 'package:mindsafe/features/wellness/presentation/screens/calming_sounds_screen.dart';
import 'package:mindsafe/features/wellness/presentation/screens/emergency_contacts_screen.dart';
import 'package:mindsafe/features/wellness/presentation/screens/meditation_timer_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mood',
                builder: (context, state) => const MoodTrackerScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const MoodHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const JournalEditorScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => JournalEditorScreen(
                      entryId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'pin',
            builder: (context, state) {
              final mode = state.extra is PinLockMode
                  ? state.extra! as PinLockMode
                  : PinLockMode.enterPin;
              return PinLockScreen(mode: mode);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/breathe',
        builder: (context, state) => const BreathingExerciseScreen(),
      ),
      GoRoute(
        path: '/meditate',
        builder: (context, state) => const MeditationTimerScreen(),
      ),
      GoRoute(
        path: '/wellness/breathing',
        builder: (context, state) => const BreathingExerciseScreen(),
      ),
      GoRoute(
        path: '/wellness/meditation',
        builder: (context, state) => const MeditationTimerScreen(),
      ),
      GoRoute(
        path: '/wellness/emergency',
        builder: (context, state) => const EmergencyContactsScreen(),
      ),
      GoRoute(
        path: '/wellness/sounds',
        builder: (context, state) => const CalmingSoundsScreen(),
      ),
    ],
  );
});
