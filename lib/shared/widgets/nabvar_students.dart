import 'package:flutter/material.dart';

class NavbarStudents extends StatelessWidget {
  const NavbarStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Estilo base para el texto del menú
    final itemStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );

    return Drawer(
      backgroundColor: colorScheme.secondary, // Fondo azul oscuro
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
            // Logo superior
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 32.0, bottom: 48.0),
              child: Image.asset(
                'assets/images/up_logo_2.png',
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            
            // Sección Principal
            _buildMenuItem('Asignaturas', itemStyle, () {}),
            const SizedBox(height: 16),
            _buildMenuItem('Avisos', itemStyle, () {}),
            const SizedBox(height: 16),
            _buildMenuItem('Archivadas', itemStyle, () {}),
            
            const Spacer(), // Empuja el resto de elementos hacia abajo
            
            // Sección Inferior (con un sutil fondo más oscuro como en tu diseño)
            Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.15), 
              padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem('Archivos offline', itemStyle, () {}),
                  const SizedBox(height: 16),
                  _buildMenuItem('Configuracion', itemStyle, () {}),
                  const SizedBox(height: 16),
                  _buildMenuItem('Ayuda', itemStyle, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para cada elemento de la lista
  Widget _buildMenuItem(String title, TextStyle? style, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}