import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/widgets/section_header.dart';
import 'package:mindsafe/features/wellness/domain/entities/emergency_contact.dart';
import 'package:mindsafe/features/wellness/presentation/providers/wellness_provider.dart';

class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  Future<void> _callNumber(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot dial $phone on this device')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helplines = ref.watch(staticHelplinesProvider);
    final personalAsync = ref.watch(personalContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showContactDialog(context, ref),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Contact'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'If you are in immediate danger, call emergency services.',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Crisis Helplines'),
          ...helplines.map(
            (c) => _ContactCard(
              contact: c,
              onCall: () => _callNumber(context, c.phone),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Personal Contacts'),
          personalAsync.when(
            data: (contacts) {
              if (contacts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Add trusted contacts you can reach out to',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                  ),
                );
              }
              return Column(
                children: contacts.map((c) {
                  return _ContactCard(
                    contact: c,
                    onCall: () => _callNumber(context, c.phone),
                    onEdit: () => _showContactDialog(context, ref, contact: c),
                    onDelete: () => ref
                        .read(personalContactsProvider.notifier)
                        .deleteContact(c.id),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }

  Future<void> _showContactDialog(
    BuildContext context,
    WidgetRef ref, {
    EmergencyContact? contact,
  }) async {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');
    final relationController =
        TextEditingController(text: contact?.relationship ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true) return;

    final updated = EmergencyContact(
      id: contact?.id ?? const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      relationship: relationController.text.trim().isEmpty
          ? null
          : relationController.text.trim(),
    );

    if (updated.name.isEmpty || updated.phone.isEmpty) return;

    if (contact == null) {
      await ref.read(personalContactsProvider.notifier).addContact(updated);
    } else {
      await ref.read(personalContactsProvider.notifier).updateContact(updated);
    }
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.onCall,
    this.onEdit,
    this.onDelete,
  });

  final EmergencyContact contact;
  final VoidCallback onCall;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: contact.isHelpline
              ? AppColors.error.withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: 0.12),
          child: Icon(
            contact.isHelpline ? Icons.support_agent_rounded : Icons.person_rounded,
            color: contact.isHelpline ? AppColors.error : AppColors.primary,
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            contact.phone,
            if (contact.relationship != null) contact.relationship,
          ].join(' · '),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                onPressed: onDelete,
              ),
            IconButton(
              icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
              onPressed: onCall,
            ),
          ],
        ),
      ),
    );
  }
}
