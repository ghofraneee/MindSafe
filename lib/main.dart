import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/core/router/app_router.dart';
import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/core/theme/app_theme.dart';
import 'package:mindsafe/core/widgets/privacy_guard.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/settings/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());

  final storageService = StorageService();
  await storageService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MindSafeApp(),
    ),
  );
}

class MindSafeApp extends ConsumerWidget {
  const MindSafeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'MindSafe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final authenticated = ref.watch(isAuthenticatedProvider);
        if (!authenticated) return child;
        return PrivacyGuard(child: child);
      },
    );
  }
}
