import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/features/wellness/domain/entities/emergency_contact.dart';

const _contactsKey = 'personal_emergency_contacts';

final staticHelplinesProvider = Provider<List<EmergencyContact>>((ref) {
  return const [
    EmergencyContact(
      id: 'iasp',
      name: 'IASP Crisis Line',
      phone: '988',
      relationship: 'International Association for Suicide Prevention',
      isHelpline: true,
    ),
    EmergencyContact(
      id: 'crisis_text',
      name: 'Crisis Text Line',
      phone: '741741',
      relationship: 'Text HOME to connect',
      isHelpline: true,
    ),
    EmergencyContact(
      id: 'emergency_us',
      name: 'Emergency (US)',
      phone: '911',
      isHelpline: true,
    ),
    EmergencyContact(
      id: 'emergency_eu',
      name: 'Emergency (EU)',
      phone: '112',
      isHelpline: true,
    ),
  ];
});

class EmergencyContactsNotifier
    extends StateNotifier<AsyncValue<List<EmergencyContact>>> {
  EmergencyContactsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = _ref.read(storageServiceProvider);
      final raw = storage.settingsBox.get(_contactsKey);
      if (raw is! List) return <EmergencyContact>[];

      return raw
          .whereType<Map>()
          .map((e) => EmergencyContact.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  Future<void> addContact(EmergencyContact contact) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, contact];
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateContact(EmergencyContact contact) async {
    final current = state.valueOrNull ?? [];
    final updated = current
        .map((c) => c.id == contact.id ? contact : c)
        .toList();
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> deleteContact(String id) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((c) => c.id != id).toList();
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> _persist(List<EmergencyContact> contacts) async {
    final storage = _ref.read(storageServiceProvider);
    await storage.settingsBox.put(
      _contactsKey,
      contacts.map((c) => c.toJson()).toList(),
    );
  }
}

final personalContactsProvider = StateNotifierProvider<
    EmergencyContactsNotifier, AsyncValue<List<EmergencyContact>>>((ref) {
  return EmergencyContactsNotifier(ref);
});

enum CalmingSound {
  rain('Rain', 'assets/sounds/rain.mp3', Icons.water_drop_rounded),
  ocean('Ocean', 'assets/sounds/ocean.mp3', Icons.waves_rounded),
  forest('Forest', 'assets/sounds/forest.mp3', Icons.forest_rounded),
  whiteNoise('White Noise', 'assets/sounds/white_noise.mp3', Icons.graphic_eq_rounded),
  stream('Stream', 'assets/sounds/stream.mp3', Icons.water_rounded);

  const CalmingSound(this.label, this.assetPath, this.icon);

  final String label;
  final String assetPath;
  final IconData icon;
}

enum BreathingPhase { inhale, holdIn, exhale, holdOut }

final breathingPhaseProvider = StateProvider<BreathingPhase>(
  (_) => BreathingPhase.inhale,
);

final breathingActiveProvider = StateProvider<bool>((_) => false);

final meditationSecondsProvider = StateProvider<int>(
  (_) => 300,
);

final meditationRunningProvider = StateProvider<bool>((_) => false);

final meditationRemainingProvider = StateProvider<int>((_) => 300);
