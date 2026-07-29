import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_riverpod.dart';
import '../responsive/responsive_utils.dart';

class HeaderStudents extends ConsumerWidget {
  const HeaderStudents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarUrl = ref.watch(authViewModelProvider).asData?.value.user?.avatarUrl;
    final landscape = isLandscape(context);
    final headerHeight = responsiveHeaderHeight(context);
    final logoHeight = headerHeight * (landscape ? 0.45 : 0.62);
    final avatarRadius = landscape ? 18.0 : 24.0;
    final iconSize = landscape ? 22.0 : 30.0;

    return CustomPaint(
      painter: _HeaderPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: headerHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: landscape ? 12.0 : 16.0),
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
                        size: landscape ? 22 : 28,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    SizedBox(width: landscape ? 4 : 8),
                    Image.asset(
                      'assets/images/up_logo_2.png',
                      height: logoHeight,
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
                      radius: avatarRadius,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: iconSize,
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
