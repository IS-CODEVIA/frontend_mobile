import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/welcome_background.dart';
import '../widgets/up_logo.dart';
import '../widgets/comenzar_button.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WelcomeBackground(
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Align(
                  alignment: Alignment(screenWidth < 360 ? -0.3 : -0.4, 0.16),
                  child: UpLogo(),
                ),
                Positioned(
                  bottom: screenHeight * 0.06,
                  right: screenWidth * 0.08,
                  child: ComenzarButton(
                    onPressed: () => context.goNamed('login'),
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