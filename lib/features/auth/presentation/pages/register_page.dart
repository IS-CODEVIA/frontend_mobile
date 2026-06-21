import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpod/auth_riverpod.dart';
import '../widgets/register_background.dart';
import '../widgets/role_selector_button.dart';
import '../widgets/custom_text_field.dart';
//import '../widgets/profile_picture_picker.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _studentIdController.dispose();
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
          const RegisterBackground(child: SizedBox.expand()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 110), 
                  Text(
                    'Registro',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      RoleSelectorButton(
                        title: 'Docente',
                        icon: Icons.person_outline,
                        isSelected: !authState.isStudent,
                        onTap: () => ref.read(authViewModelProvider.notifier).setRole(false),
                      ),
                      const SizedBox(width: 12),
                      RoleSelectorButton(
                        title: 'Alumno',
                        icon: Icons.school_outlined,
                        isSelected: authState.isStudent,
                        onTap: () => ref.read(authViewModelProvider.notifier).setRole(true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), 
              
                  const SizedBox(height: 24), 
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Nombre',
                          controller: _nameController,
                        ),
                      ),
                      const SizedBox(width: 16), 
                      Expanded(
                        child: CustomTextField(
                          label: 'Apellidos',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), 
                  CustomTextField(label: 'Matrícula', controller: _studentIdController),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'Correo electrónico', controller: _emailController),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'Contraseña', isPassword: true, controller: _passwordController),
                  
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        authState.error!,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                      ),
                    ),
          
                  const SizedBox(height: 140), 
                ],
              ),
            ),
          ),
          
    
          Positioned(
            bottom: 40,
            right: 32,
            child: OutlinedButton(
              onPressed: authState.isRegisterLoading
                  ? null
                  : () => ref.read(authViewModelProvider.notifier).register(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: authState.isRegisterLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onSecondary,
                      ),
                    )
                  : Text(
                      'Registro',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSecondary,
                      ),
                    ),
            ),
          ),
          
          Positioned(
            bottom: 52, 
            left: 30,
            child: GestureDetector(
              onTap: () => context.goNamed('login'),
              child: RichText(
                text: TextSpan(
                  text: 'tienes cuenta? ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Iniciar sesion',
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
