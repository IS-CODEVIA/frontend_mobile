import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/responsive/responsive_utils.dart';
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
    final authAsync = ref.watch(authViewModelProvider);
    final isSmall = MediaQuery.of(context).size.width < 360;
    final padding = horizontalPadding(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder:
            (context, constraints) => authAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(error.toString()),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(authViewModelProvider),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  ),
              data:
                  (authState) => Stack(
                    children: [
                      const WelcomeBackground(child: SizedBox.expand()),
                      SafeArea(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: sh(context, 0.3)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Iniciar sesion',
                                        style: textTheme.headlineLarge?.copyWith(
                                          color: colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsiveFontSize(context, 32),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.03)),
                                Row(
                                  children: [
                                    RoleSelectorButton(
                                      title: 'Docente',
                                      icon: Icons.person_outline,
                                      isSelected: !authState.isStudent,
                                      onTap: () => ref.read(authViewModelProvider.notifier).setRole(false),
                                    ),
                                    SizedBox(width: isSmall ? 8 : 16),
                                    RoleSelectorButton(
                                      title: 'Alumno',
                                      icon: Icons.school_outlined,
                                      isSelected: authState.isStudent,
                                      onTap: () => ref.read(authViewModelProvider.notifier).setRole(true),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.03)),
                                CustomTextField(
                                  label: 'Email',
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ingresa tu correo';
                                    }
                                    if (value.trim().length > 254) {
                                      return 'Correo demasiado largo';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                                      return 'Correo no válido';
                                    }
                                    if (!value.trim().endsWith('@')) {
                                      return 'Usa tu correo institucional @upchiapas.edu.mx';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: sh(context, 0.02)),
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
                                    if (value.trim().length > 100) {
                                      return 'Máximo 100 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: sh(context, 0.015)),
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
                                        fontSize: responsiveFontSize(context, 14),
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
                                        fontSize: responsiveFontSize(context, 12),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: sh(context, 0.06)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: sh(context, 0.06),
                        right: padding,
                        child: OutlinedButton(
                          onPressed: authState.isLoading ? null : _login,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 24, vertical: isSmall ? 10 : 12),
                          ),
                          child:
                              authState.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onSecondary),
                                  )
                                  : Text(
                                    'Iniciar sesion',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSecondary,
                                      fontSize: responsiveFontSize(context, 14),
                                    ),
                                  ),
                        ),
                      ),
                      Positioned(
                        bottom: sh(context, 0.07),
                        left: padding,
                        child: GestureDetector(
                          onTap: () => context.goNamed('register'),
                          child: RichText(
                            text: TextSpan(
                              text: 'Sin cuenta? ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSecondary,
                                fontSize: responsiveFontSize(context, 14),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Registrar',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsiveFontSize(context, 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
      ),
    );
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(authViewModelProvider.notifier)
        .login(email: _emailController.text.trim(), password: _passwordController.text.trim());

    if (!mounted) return;
    final updated = ref.read(authViewModelProvider).asData?.value;
    if (updated != null && updated.status == AuthStatus.authenticated) {
      if (updated.isStudent) {
        context.goNamed('home');
      } else {
        context.goNamed('professor-home');
      }
    }
  }
}
