import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';

import '../riverpod/settings_students_riverpod.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_option_card.dart';

class SettingsStudentsPage extends ConsumerWidget {
  const SettingsStudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final options = ref.watch(settingsOptionsProvider);

    return Scaffold(
      drawer: const NavbarStudents(),
      body: Column(
        children: [
          const HeaderStudents(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Configuración',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProfileHeader(),
                  const SizedBox(height: 24),
                  Text(
                    'Preferencias',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SettingsOptionCard(option: option),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
