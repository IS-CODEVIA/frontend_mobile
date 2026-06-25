import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/assignment_notices_professor_riverpod.dart';

class NewNoticeProfessorDialog {
  static void show(BuildContext context, WidgetRef ref, String subjectName) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Nuevo anuncio'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Escribe tu anuncio...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(assignmentNoticesProfessorProvider.notifier).addNotice(
                  subjectName,
                  AssignmentNoticesProfessorModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    authorName: 'Tu',
                    date: 'Hoy',
                    message: controller.text.trim(),
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }
}
