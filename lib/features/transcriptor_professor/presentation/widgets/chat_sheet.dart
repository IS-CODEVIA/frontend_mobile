import 'package:flutter/material.dart';

class ChatSheet extends StatelessWidget {
  const ChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat, color: colorScheme.onSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Mensajes de alumnos',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _chatBubble(colorScheme, textTheme, 'Alumno', 'Profesor, no entendi el ejercicio 3', false),
                const SizedBox(height: 8),
                _chatBubble(colorScheme, textTheme, 'Alumno', 'Podria repetir la explicacion?', false),
                const SizedBox(height: 8),
                _chatBubble(colorScheme, textTheme, 'Tu', 'Claro, al final de la clase lo explico de nuevo', true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send_rounded, color: colorScheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatBubble(ColorScheme colorScheme, TextTheme textTheme, String author, String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? colorScheme.primaryContainer : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(message, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
