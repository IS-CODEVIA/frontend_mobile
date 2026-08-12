import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/responsive/responsive_utils.dart';
import '../riverpod/auth_riverpod.dart';
import '../widgets/register_background.dart';
import '../widgets/role_selector_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/terms_dialog.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).clearRegisterSuccess();
      ref.read(authViewModelProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
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

    ref.listen(authViewModelProvider, (_, next) {
      final data = next.asData?.value;
      if (data != null && data.isRegisterSuccess) {
        ref.read(authViewModelProvider.notifier).clearRegisterSuccess();
        context.goNamed('login');
      }
    });

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
                      const RegisterBackground(child: SizedBox.expand()),
                      SafeArea(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: sh(context, 0.12)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Registro',
                                        style: textTheme.headlineMedium?.copyWith(
                                          color: colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsiveFontSize(context, 28),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.025)),
                                Row(
                                  children: [
                                    RoleSelectorButton(
                                      title: 'Docente',
                                      icon: Icons.person_outline,
                                      isSelected: !authState.isStudent,
                                      onTap: () => ref.read(authViewModelProvider.notifier).setRole(false),
                                    ),
                                    SizedBox(width: isSmall ? 8 : 12),
                                    RoleSelectorButton(
                                      title: 'Alumno',
                                      icon: Icons.school_outlined,
                                      isSelected: authState.isStudent,
                                      onTap: () => ref.read(authViewModelProvider.notifier).setRole(true),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.03)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        label: 'Nombre',
                                        controller: _nameController,
                                        compact: isSmall,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Requerido';
                                          }
                                          if (value.trim().length < 2) {
                                            return 'Mínimo 2 caracteres';
                                          }
                                          if (value.trim().length > 50) {
                                            return 'Máximo 50 caracteres';
                                          }
                                          if (RegExp(r'[0-9]').hasMatch(value)) {
                                            return 'No debe contener números';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: isSmall ? 8 : 16),
                                    Expanded(
                                      child: CustomTextField(
                                        label: 'Apellidos',
                                        controller: _lastNameController,
                                        compact: isSmall,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Requerido';
                                          }
                                          if (value.trim().length < 2) {
                                            return 'Mínimo 2 caracteres';
                                          }
                                          if (value.trim().length > 50) {
                                            return 'Máximo 50 caracteres';
                                          }
                                          if (RegExp(r'[0-9]').hasMatch(value)) {
                                            return 'No debe contener números';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.02)),
                                CustomTextField(
                                  label: 'Correo electrónico',
                                  controller: _emailController,
                                  compact: isSmall,
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
                                    if (!value.trim().endsWith('.upchiapas.edu.mx')) {
                                      return 'Usa tu correo institucional @upchiapas.edu.mx';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: sh(context, 0.02)),
                                CustomTextField(
                                  label: 'Contraseña',
                                  isPassword: true,
                                  controller: _passwordController,
                                  compact: isSmall,
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
                                SizedBox(height: sh(context, 0.03)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                                      child: Container(
                                        width: isSmall ? 20 : 22,
                                        height: isSmall ? 20 : 22,
                                        decoration: BoxDecoration(
                                          color: _acceptedTerms ? colorScheme.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: _acceptedTerms ? colorScheme.primary : colorScheme.onSecondary,
                                            width: 2,
                                          ),
                                        ),
                                        child:
                                            _acceptedTerms
                                                ? Icon(
                                                  Icons.check,
                                                  size: isSmall ? 14 : 16,
                                                  color: colorScheme.onPrimary,
                                                )
                                                : null,
                                      ),
                                    ),
                                    SizedBox(width: isSmall ? 8 : 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                                        child: Text(
                                          'Acepto los términos y condiciones',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.secondary,
                                            fontSize: responsiveFontSize(context, 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh(context, 0.01)),
                                GestureDetector(
                                  onTap: () => showTermsDialog(context),
                                  child: Text(
                                    'Ver términos y condiciones',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
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
                        bottom: sh(context, 0.05),
                        right: padding,
                        child: OutlinedButton(
                          onPressed: (authState.isRegisterLoading || !_acceptedTerms) ? null : _register,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 24, vertical: isSmall ? 10 : 12),
                          ),
                          child:
                              authState.isRegisterLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onSecondary),
                                  )
                                  : Text(
                                    'Registro',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSecondary,
                                      fontSize: responsiveFontSize(context, 14),
                                    ),
                                  ),
                        ),
                      ),
                      Positioned(
                        bottom: sh(context, 0.065),
                        left: padding,
                        child: GestureDetector(
                          onTap: () => context.goNamed('login'),
                          child: RichText(
                            text: TextSpan(
                              text: 'tienes cuenta? ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSecondary,
                                fontSize: responsiveFontSize(context, 14),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Iniciar sesion',
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

  void _register() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final fullName = '$name $lastName';
    final isStudent = ref.read(authViewModelProvider).asData?.value.isStudent ?? true;
    final roleId = isStudent ? 1 : 2;

    ref.read(authViewModelProvider.notifier).register(name: fullName, email: email, password: password, roleId: roleId);
  }
}
