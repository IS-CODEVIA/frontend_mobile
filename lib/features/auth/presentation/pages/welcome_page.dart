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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: WelcomeBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment(-0.4, 0.16),
                child: UpLogo(),
              ),
              Positioned(
                bottom: 48,
                right: 32,
                child: ComenzarButton(
                  onPressed: () => context.goNamed('login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
