import 'package:flutter/material.dart';
import '../../domain/models/transcription_message.dart';

class TranscriptionBox extends StatelessWidget {
  final List<TranscriptionMessage> messages;

  const TranscriptionBox({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: messages.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final message = messages[index];
          return RichText(
            text: TextSpan(
              text: '${message.speaker}: ',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold, // Nombre en negrita
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: message.text,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500, // Texto normal
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}