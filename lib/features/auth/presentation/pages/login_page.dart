import 'package:flutter/material.dart';

import '../widgets/welcome_background.dart';
import '../widgets/role_selector_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isStudent = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                        isSelected: !_isStudent,
                        onTap: () => setState(() => _isStudent = false),
                      ),
                      const SizedBox(width: 16),
                      RoleSelectorButton(
                        title: 'Alumno',
                        icon: Icons.school_outlined,
                        isSelected: _isStudent,
                        onTap: () => setState(() => _isStudent = true),
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
                        'Forgot Password?',
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
              onPressed: () {},
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
              onTap: () {},
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
