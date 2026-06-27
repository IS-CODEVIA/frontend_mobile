import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_riverpod.dart';

class NavbarStudents extends ConsumerWidget {
  const NavbarStudents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final itemStyle = textTheme.titleMedium?.copyWith(
      color: colorScheme.onSecondary,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );

    return Drawer(
      backgroundColor: colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 32.0, bottom: 48.0),
              child: Image.asset(
                'assets/images/up_logo_2.png',
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            _buildMenuItem('Asignaturas', Icons.menu_book_rounded, itemStyle, () => context.goNamed('home')),
            const SizedBox(height: 16),
            _buildMenuItem('Avisos', Icons.mail_outline_rounded, itemStyle, () => context.goNamed('notices')),
            const SizedBox(height: 16),
            _buildMenuItem('Archivadas', Icons.archive_outlined, itemStyle, () => context.goNamed('archived')),
            const Spacer(),
            Container(
              width: double.infinity,
              color: colorScheme.scrim.withValues(alpha: 0.15),
              padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem('Archivos offline', Icons.download_rounded, itemStyle, () {}),
                  const SizedBox(height: 16),
                  _buildMenuItem('Configuracion', Icons.settings_outlined, itemStyle, () => context.goNamed('settings')),
                  const SizedBox(height: 16),
                  _buildMenuItem('Ayuda', Icons.help_outline_rounded, itemStyle, () => _showHelpModal(context)),
                  const SizedBox(height: 16),
                  _buildMenuItem('Cerrar sesión', Icons.logout_rounded, itemStyle, () async {
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (context.mounted) context.goNamed('login');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 12),
            const Text('Ayuda'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _helpSection('Asignaturas', 'Visualiza y gestiona tus materias activas. Toca una asignatura para ver sus avisos, material y compañeros.'),
              const SizedBox(height: 16),
              _helpSection('Avisos', 'Consulta los anuncios publicados por tus profesores en cada materia.'),
              const SizedBox(height: 16),
              _helpSection('Archivadas', 'Accede a materias de ciclos anteriores. Toca una para consultar su información.'),
              const SizedBox(height: 16),
              _helpSection('Material', 'Descarga y revisa los materiales de estudio por unidad.'),
              const SizedBox(height: 16),
              _helpSection('Personas', 'Conoce a los integrantes de cada clase: profesores y compañeros.'),
              const SizedBox(height: 16),
              _helpSection('Configuracion', 'Personaliza tu perfil, foto, notificaciones y preferencias de la app.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _helpSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    TextStyle? style,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: style?.color, size: 24),
            const SizedBox(width: 16),
            Text(title, style: style),
          ],
        ),
      ),
    );
  }
}
