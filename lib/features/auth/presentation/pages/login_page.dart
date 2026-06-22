import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpod/auth_riverpod.dart';
import '../widgets/welcome_background.dart';
import '../widgets/role_selector_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const WelcomeBackground(child: SizedBox.expand()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 260),
                  Text(
                    'Iniciar sesion',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      RoleSelectorButton(
                        title: 'Docente',
                        icon: Icons.person_outline,
                        isSelected: !authState.isStudent,
                        onTap: () => ref.read(authViewModelProvider.notifier).setRole(false),
                      ),
                      const SizedBox(width: 16),
                      RoleSelectorButton(
                        title: 'Alumno',
                        icon: Icons.school_outlined,
                        isSelected: authState.isStudent,
                        onTap: () => ref.read(authViewModelProvider.notifier).setRole(true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const CustomTextField(label: 'Email'),
                  const SizedBox(height: 16),
                  const CustomTextField(label: 'Password', isPassword: true),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Olvidaste tu contraseña?',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            right: 32,
            child: OutlinedButton(
              onPressed: () {
                if (authState.isStudent) {
                  context.goNamed('home');
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Iniciar sesion',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 56,
            left: 32,
            child: GestureDetector(
              onTap: () => context.goNamed('register'),
              child: RichText(
                text: TextSpan(
                  text: 'Sin cuenta? ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Registrar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
