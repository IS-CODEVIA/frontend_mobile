import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final Widget child;

  const WelcomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _WelcomeBackgroundPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary, 
      ),
      child: child,
    );
  }
}

class _WelcomeBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _WelcomeBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintSecondary = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final paintPrimary = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // 1. Onda Superior Teal (Verde agua) - Fondo
    final pathPrimaryTop = Path();
    pathPrimaryTop.moveTo(0, size.height * 0.35);
    pathPrimaryTop.cubicTo(
      size.width * 0.35, size.height * 0.38, 
      size.width * 0.65, size.height * 0.15, 
      size.width, size.height * 0.45,
    );
    pathPrimaryTop.lineTo(size.width, 0);
    pathPrimaryTop.lineTo(0, 0);
    pathPrimaryTop.close();
    canvas.drawPath(pathPrimaryTop, paintPrimary);

    // 2. Onda Superior Azul Oscuro - Frente
    final pathSecondaryTop = Path();
    pathSecondaryTop.moveTo(0, size.height * 0.33);
    pathSecondaryTop.cubicTo(
      size.width * 0.3, size.height * 0.28, 
      size.width * 0.5, size.height * 0.12, 
      size.width * 0.8, 0,
    );
    pathSecondaryTop.lineTo(0, 0);
    pathSecondaryTop.close();
    canvas.drawPath(pathSecondaryTop, paintSecondary);

   
    final pathSecondaryBottom = Path();
    pathSecondaryBottom.moveTo(0, size.height * 0.90);
    pathSecondaryBottom.cubicTo(
      size.width * 0.3, size.height * 0.95, 
      size.width * 0.6, size.height * 0.75, 
      size.width, size.height * 0.82,
    );
    pathSecondaryBottom.lineTo(size.width, size.height);
    pathSecondaryBottom.lineTo(0, size.height);
    pathSecondaryBottom.close();
    canvas.drawPath(pathSecondaryBottom, paintSecondary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}