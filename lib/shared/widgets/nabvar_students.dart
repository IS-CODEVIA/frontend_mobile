import 'package:flutter/material.dart';

class NavbarStudents extends StatelessWidget {
  const NavbarStudents({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildMenuItem('Asignaturas', Icons.menu_book_rounded, itemStyle, () {}),
            const SizedBox(height: 16),
            _buildMenuItem('Avisos', Icons.mail_outline_rounded, itemStyle, () {}),
            const SizedBox(height: 16),
            _buildMenuItem('Archivadas', Icons.archive_outlined, itemStyle, () {}),
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
                  _buildMenuItem('Configuracion', Icons.settings_outlined, itemStyle, () {}),
                  const SizedBox(height: 16),
                  _buildMenuItem('Ayuda', Icons.help_outline_rounded, itemStyle, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
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
