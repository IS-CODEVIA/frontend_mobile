import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_riverpod.dart';
import '../../features/offline_files/presentation/pages/offline_files_page.dart';
import '../responsive/responsive_utils.dart';

class NavbarStudents extends ConsumerWidget {
  const NavbarStudents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final landscape = isLandscape(context);

    final itemStyle = textTheme.titleMedium?.copyWith(
      color: colorScheme.onSecondary,
      fontWeight: FontWeight.w600,
      fontSize: landscape ? 15 : 18,
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
              padding: EdgeInsets.only(
                left: landscape ? 20.0 : 32.0,
                top: landscape ? 12.0 : 32.0,
                bottom: landscape ? 12.0 : 48.0,
              ),
              child: Image.asset(
                'assets/images/up_logo_2.png',
                height: landscape ? 50 : 80,
                fit: BoxFit.contain,
              ),
            ),
            _buildMenuItem('Asignaturas', Icons.menu_book_rounded, itemStyle, () => context.goNamed('home'), landscape),
            SizedBox(height: landscape ? 6 : 16),
            _buildMenuItem('Avisos', Icons.mail_outline_rounded, itemStyle, () => context.goNamed('notices'), landscape),
            SizedBox(height: landscape ? 6 : 16),
            _buildMenuItem('Archivadas', Icons.archive_outlined, itemStyle, () => context.goNamed('archived'), landscape),
            const Spacer(),
            Container(
              width: double.infinity,
              color: colorScheme.scrim.withValues(alpha: 0.15),
              padding: EdgeInsets.only(top: landscape ? 8.0 : 24.0, bottom: landscape ? 12.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem('Archivos offline', Icons.download_rounded, itemStyle, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OfflineFilesPage()),
                    );
                  }, landscape),
                  SizedBox(height: landscape ? 6 : 16),
                  _buildMenuItem('Configuracion', Icons.settings_outlined, itemStyle, () => context.goNamed('settings'), landscape),
                  SizedBox(height: landscape ? 6 : 16),
                  _buildMenuItem('Ayuda', Icons.help_outline_rounded, itemStyle, () => _showHelpModal(context), landscape),
                  SizedBox(height: landscape ? 6 : 16),
                  _buildMenuItem('Cerrar sesión', Icons.logout_rounded, itemStyle, () async {
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (context.mounted) context.goNamed('login');
                  }, landscape),
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
    bool landscape,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: landscape ? 16.0 : 28.0,
          vertical: landscape ? 4.0 : 10.0,
        ),
        child: Row(
          children: [
            Icon(icon, color: style?.color, size: landscape ? 20 : 24),
            SizedBox(width: landscape ? 10 : 16),
            Flexible(
              child: Text(
                title,
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
