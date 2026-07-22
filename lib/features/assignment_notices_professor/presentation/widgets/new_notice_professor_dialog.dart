import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/assignment_notices_professor_riverpod.dart';

class NewNoticeProfessorDialog {
  static void show(
    BuildContext context,
    WidgetRef ref,
    int courseId,
  ) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Nuevo anuncio'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Escribe tu anuncio...',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El anuncio no puede ir vacío';
              }
              if (value.trim().length < 10) {
                return 'Mínimo 10 caracteres';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final result = await ref
                  .read(professorNoticesProvider.notifier)
                  .createNotice(
                    courseId: courseId,
                    title: controller.text.trim(),
                  );
              if (ctx.mounted) {
                Navigator.pop(ctx);
                if (result == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al crear el anuncio'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anuncio creado correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }
}
