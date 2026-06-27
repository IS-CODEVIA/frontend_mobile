import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpod/auth_riverpod.dart';
import '../widgets/welcome_background.dart';
import '../widgets/role_selector_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: _formKey,
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
                          onTap: () => ref
                              .read(authViewModelProvider.notifier)
                              .setRole(false),
                        ),
                        const SizedBox(width: 16),
                        RoleSelectorButton(
                          title: 'Alumno',
                          icon: Icons.school_outlined,
                          isSelected: authState.isStudent,
                          onTap: () => ref
                              .read(authViewModelProvider.notifier)
                              .setRole(true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                          return 'Correo no válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        if (value.trim().length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
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
                    if (authState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          authState.error!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            right: 32,
            child: OutlinedButton(
              onPressed: authState.isLoading ? null : _login,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: authState.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onSecondary,
                      ),
                    )
                  : Text(
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

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(authViewModelProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    if (!mounted) return;
    final updated = ref.read(authViewModelProvider);
    if (updated.status == AuthStatus.authenticated) {
      if (updated.isStudent) {
        context.goNamed('home');
      } else {
        context.goNamed('professor-home');
      }
    }
  }
}
