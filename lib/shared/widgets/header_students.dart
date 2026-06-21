import 'package:flutter/material.dart';

class HeaderStudents extends StatelessWidget {
  const HeaderStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _HeaderPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reducido un poco para hacer espacio
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // NUEVO: Fila con el menú de hamburguesa y el logo
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu, 
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // Esto abre el Drawer mágicamente
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/up_logo_2.png',
                      height: 40, // Ligeramente más pequeño para convivir con el ícono
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                
                // Foto de perfil (se queda igual)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _HeaderPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _HeaderPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintTeal = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final paintBlue = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    // 1. Onda Superior Teal (Fondo)
    final pathTeal = Path();
    pathTeal.moveTo(0, 0);
    // Baja por la izquierda casi hasta el fondo del widget
    pathTeal.lineTo(0, size.height * 0.95);
    // Curva hacia la derecha
    pathTeal.cubicTo(
      size.width * 0.35, size.height * 1.05, 
      size.width * 0.65, size.height * 0.55, 
      size.width, size.height * 0.75,
    );
    pathTeal.lineTo(size.width, 0);
    pathTeal.close();
    canvas.drawPath(pathTeal, paintTeal);

    // 2. Onda Superior Azul Oscuro (Frente)
    final pathBlue = Path();
    pathBlue.moveTo(0, 0);
    // Baja por la izquierda pero un poco menos que la onda Teal
    pathBlue.lineTo(0, size.height * 0.85);
    // Curva "S" pronunciada hacia arriba a la derecha
    pathBlue.cubicTo(
      size.width * 0.45, size.height * 0.85, 
      size.width * 0.65, size.height * 0.25, 
      size.width, size.height * 0.25,
    );
    pathBlue.lineTo(size.width, 0);
    pathBlue.close();
    canvas.drawPath(pathBlue, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}