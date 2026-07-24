import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_riverpod.dart';

class HeaderProfessors extends ConsumerWidget {
  const HeaderProfessors({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarUrl = ref.watch(authViewModelProvider).asData?.value.user?.avatarUrl;

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/up_logo_2.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.goNamed('profile'),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: colorScheme.outline,
                            )
                          : null,
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

    final pathTeal = Path();
    pathTeal.moveTo(0, 0);
    pathTeal.lineTo(0, size.height * 0.95);
    pathTeal.cubicTo(
      size.width * 0.35, size.height * 1.05,
      size.width * 0.65, size.height * 0.55,
      size.width, size.height * 0.75,
    );
    pathTeal.lineTo(size.width, 0);
    pathTeal.close();
    canvas.drawPath(pathTeal, paintTeal);

    final pathBlue = Path();
    pathBlue.moveTo(0, 0);
    pathBlue.lineTo(0, size.height * 0.85);
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
