import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/widgets/section_header.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/settings/domain/entities/app_settings.dart';
import 'package:mindsafe/features/settings/presentation/providers/settings_provider.dart';
import 'package:mindsafe/features/settings/presentation/screens/pin_lock_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SizedBox(height: 8),
          const SectionHeader(title: 'Wellness Tools'),
          _SettingsTile(
            icon: Icons.air_rounded,
            title: 'Box Breathing',
            subtitle: '4-4-4-4 guided exercise',
            onTap: () => context.push('/wellness/breathing'),
          ),
          _SettingsTile(
            icon: Icons.self_improvement_rounded,
            title: 'Meditation Timer',
            onTap: () => context.push('/wellness/meditation'),
          ),
          _SettingsTile(
            icon: Icons.music_note_rounded,
            title: 'Calming Sounds',
            onTap: () => context.push('/wellness/sounds'),
          ),
          _SettingsTile(
            icon: Icons.emergency_rounded,
            title: 'Emergency Contacts',
            iconColor: AppColors.error,
            onTap: () => context.push('/wellness/emergency'),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Appearance'),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            subtitle: _themeLabel(settings.themeMode),
            trailing: Switch.adaptive(
              value: settings.themeMode == ThemeMode.dark,
              activeColor: AppColors.primary,
              onChanged: (value) {
                ref.read(settingsNotifierProvider.notifier).toggleDarkMode(value);
              },
            ),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Notifications'),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            title: 'Push Notifications',
            trailing: Switch.adaptive(
              value: settings.notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(notificationsEnabled: value),
                    );
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.alarm_rounded,
            title: 'Mood Reminders',
            trailing: Switch.adaptive(
              value: settings.moodReminders,
              activeColor: AppColors.primary,
              onChanged: (value) {
                ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(moodReminders: value),
                    );
              },
            ),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Language'),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: settings.language == 'en' ? 'English' : settings.language,
            onTap: () => _showLanguagePicker(context, ref, settings),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Data'),
          _SettingsTile(
            icon: Icons.upload_rounded,
            title: 'Export Data',
            subtitle: 'Share moods and journals as JSON',
            onTap: () => _exportData(context, ref),
          ),
          _SettingsTile(
            icon: Icons.delete_forever_rounded,
            title: 'Delete Account',
            subtitle: 'Permanently remove your account',
            iconColor: AppColors.error,
            onTap: () => _confirmDeleteAccount(context, ref),
          ),
          _SettingsTile(
            icon: Icons.restart_alt_rounded,
            title: 'Reset App',
            subtitle: 'Wipe all local data',
            iconColor: AppColors.warning,
            onTap: () => _confirmResetApp(context, ref),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Privacy'),
          _SettingsTile(
            icon: Icons.pin_rounded,
            title: 'PIN Lock',
            trailing: Switch.adaptive(
              value: settings.pinEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) async {
                if (value) {
                  final result = await context.push<bool>(
                    '/settings/pin',
                    extra: PinLockMode.setPin,
                  );
                  if (result != true && context.mounted) {
                    ref.read(settingsNotifierProvider.notifier).update(
                          settings.copyWith(pinEnabled: false),
                        );
                  }
                } else {
                  await ref.read(settingsNotifierProvider.notifier).clearPin();
                }
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Unlock',
            trailing: Switch.adaptive(
              value: settings.biometricEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) async {
                await ref.read(authNotifierProvider.notifier).enableBiometric(value);
                await ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(biometricEnabled: value),
                    );
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.screenshot_monitor_rounded,
            title: 'Hide Screenshots',
            subtitle: 'Block screenshots in app switcher',
            trailing: Switch.adaptive(
              value: settings.hideScreenshots,
              activeColor: AppColors.primary,
              onChanged: (value) {
                ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(hideScreenshots: value),
                    );
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.timer_rounded,
            title: 'Auto-Lock',
            subtitle: 'Locks after 5 min of inactivity',
            trailing: const Icon(Icons.info_outline_rounded, size: 20),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Auto-lock is enabled via PrivacyService'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'Dark',
        ThemeMode.light => 'Light',
        ThemeMode.system => 'System',
      };

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final json = await ref.read(settingsNotifierProvider.notifier).exportData();
      await Share.share(
        json,
        subject: 'MindSafe Data Export',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This permanently removes your account and local session. '
          'Your encrypted mood and journal data will remain until you reset the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(authNotifierProvider.notifier).deleteAccount();
    if (context.mounted) {
      context.go('/welcome');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')),
      );
    }
  }

  Future<void> _confirmResetApp(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset App?'),
        content: const Text(
          'This wipes all encrypted local data including moods, journals, '
          'and settings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(settingsNotifierProvider.notifier).resetApp();
    await ref.read(authNotifierProvider.notifier).logout();
    if (context.mounted) {
      context.go('/welcome');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App reset complete')),
      );
    }
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: settings.language == 'en'
                  ? const Icon(Icons.check_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(language: 'en'),
                    );
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Français'),
              trailing: settings.language == 'fr'
                  ? const Icon(Icons.check_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(settingsNotifierProvider.notifier).update(
                      settings.copyWith(language: 'fr'),
                    );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
