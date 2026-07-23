import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/auth/presentation/riverpod/auth_riverpod.dart';
import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';

class SettingsProfessorPage extends ConsumerWidget {
  const SettingsProfessorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const NavbarProfessors(),
      body: Column(
        children: [
          const HeaderProfessors(),
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
                        'Configuracion',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildProfileCard(context, colorScheme, textTheme, ref),
                  const SizedBox(height: 24),
                  Text(
                    'Preferencias',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...['Notificaciones', 'Apariencia', 'Idioma', 'Privacidad', 'Acerca de'].map(
                    (title) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        elevation: 0,
                        color: colorScheme.surfaceContainerLow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: Icon(Icons.circle_outlined, color: colorScheme.secondary),
                          title: Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                        ),
                      ),
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

  Widget _buildProfileCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final avatarUrl = user?.avatarUrl;

    return GestureDetector(
      onTap: () => context.goNamed('profile'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 48,
                          color: colorScheme.outline,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para cargar una foto de perfil',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person_outline, user?.name ?? 'Sin nombre', textTheme, colorScheme),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.badge_outlined, user != null ? 'ID: ${user.userId}' : '---', textTheme, colorScheme),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email_outlined, user?.email ?? 'Sin correo', textTheme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(text, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
      ],
    );
  }
}
