import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/assignment_notice_model.dart';
import '../riverpod/assignment_notices_riverpod.dart';

class NewNoticeDialog extends StatefulWidget {
  final WidgetRef ref;
  final String subjectName;

  const NewNoticeDialog({super.key, required this.ref, required this.subjectName});

  static void show(BuildContext context, WidgetRef ref, String subjectName) {
    showDialog(
      context: context,
      builder: (_) => NewNoticeDialog(ref: ref, subjectName: subjectName),
    );
  }

  @override
  State<NewNoticeDialog> createState() => _NewNoticeDialogState();
}

class _NewNoticeDialogState extends State<NewNoticeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.mark_email_unread_outlined, color: colorScheme.secondary, size: 24),
          const SizedBox(width: 8),
          Text(
            'Nuevo anuncio',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Escribe tu anuncio...',
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            widget.ref.read(assignmentNoticesProvider.notifier).addNotice(
              widget.subjectName,
              AssignmentNoticeModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                authorName: 'Tú',
                date: '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}',
                message: text,
              ),
            );
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xff00CFBB),
            foregroundColor: Colors.white,
          ),
          child: const Text('Publicar'),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return months[month - 1];
  }
}
