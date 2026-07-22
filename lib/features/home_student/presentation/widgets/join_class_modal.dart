import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/home_students_riverpod.dart';

class JoinClassModal extends ConsumerStatefulWidget {
  const JoinClassModal({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const JoinClassModal(),
    );
  }

  @override
  ConsumerState<JoinClassModal> createState() => _JoinClassModalState();
}

class _JoinClassModalState extends ConsumerState<JoinClassModal> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final code = _codeController.text.trim().toUpperCase();

    final notifier = ref.read(homeStudentProvider.notifier);
    final result = await notifier.joinCourse(code);

    if (!mounted) return;

    if (result != null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Te has unido a la clase exitosamente'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(homeStudentProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school_rounded,
              size: 48,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Unirse a una clase',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ingresa el c\u00f3digo de la clase proporcionado por tu docente para acceder al contenido.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'C\u00f3digo de clase',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABC-123',
                      hintStyle: textTheme.titleMedium?.copyWith(
                        color: colorScheme.outline,
                        letterSpacing: 4,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.secondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.secondary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.error, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el código de la clase';
                      }
                      if (value.trim().length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      if (value.trim().length > 10) {
                        return 'Máximo 10 caracteres';
                      }
                      if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(value.trim())) {
                        return 'Solo letras, números y guiones';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            if (state.joinError != null) ...[
              const SizedBox(height: 12),
              Text(
                state.joinError!,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      state.isJoining ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: state.isJoining ? null : _handleJoin,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: state.isJoining
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Unirse',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
