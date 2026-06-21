import 'package:flutter/material.dart';

class RegisterBackground extends StatelessWidget {
  final Widget child;

  const RegisterBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _RegisterBackgroundPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
      ),
      child: child,
    );
  }
}

class _RegisterBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _RegisterBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  
  void paint(Canvas canvas, Size size) {
    final paintSecondary = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final paintPrimary = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final waveTop = size.height * 0.16;

    // Onda Superior Teal - Fondo
    final pathPrimaryTop = Path();
    pathPrimaryTop.moveTo(0, waveTop);
    pathPrimaryTop.cubicTo(
      size.width * 0.35, size.height * 0.19,
      size.width * 0.65, size.height * 0.08,
      size.width, size.height * 0.20,
    );
    pathPrimaryTop.lineTo(size.width, 0);
    pathPrimaryTop.lineTo(0, 0);
    pathPrimaryTop.close();
    canvas.drawPath(pathPrimaryTop, paintPrimary);

    // Onda Superior Azul Oscuro - Frente
    final pathSecondaryTop = Path();
    pathSecondaryTop.moveTo(0, size.height * 0.14);
    pathSecondaryTop.cubicTo(
      size.width * 0.3, size.height * 0.11,
      size.width * 0.5, size.height * 0.03,
      size.width * 0.8, 0,
    );
    pathSecondaryTop.lineTo(0, 0);
    pathSecondaryTop.close();
    canvas.drawPath(pathSecondaryTop, paintSecondary);

    // Onda Inferior Azul Oscuro (CORREGIDA)
    // Ahora inicia en el 85% del alto (0.85) en lugar del 96%
    final pathSecondaryBottom = Path();
    pathSecondaryBottom.moveTo(0, size.height * 0.85); 
    pathSecondaryBottom.cubicTo(
      size.width * 0.3, size.height * 0.92,
      size.width * 0.6, size.height * 0.78,
      size.width, size.height * 0.82,
    );
    pathSecondaryBottom.lineTo(size.width, size.height);
    pathSecondaryBottom.lineTo(0, size.height);
    pathSecondaryBottom.close();
    canvas.drawPath(pathSecondaryBottom, paintSecondary);
  }

  

  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}