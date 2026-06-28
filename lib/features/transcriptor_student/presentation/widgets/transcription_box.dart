import 'package:flutter/material.dart';
import '../../../../core/network/transcription_service.dart';
import '../../domain/models/transcription_message.dart';

class TranscriptionBox extends StatelessWidget {
  final List<TranscriptionMessage> messages;
  final String? partialText;
  final TranscriptionConnectionState connectionState;

  const TranscriptionBox({
    super.key,
    required this.messages,
    this.partialText,
    this.connectionState = TranscriptionConnectionState.disconnected,
  });

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
      child: Column(
        children: [
          if (connectionState == TranscriptionConnectionState.connecting)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Conectando...',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (connectionState == TranscriptionConnectionState.disconnected &&
              messages.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Esperando transcripción...',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: messages.length + (partialText != null ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == messages.length && partialText != null) {
                    return _buildPartial(textTheme, colorScheme);
                  }
                  final message = messages[index];
                  return RichText(
                    text: TextSpan(
                      text: '${message.speaker}: ',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: message.text,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartial(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Transcribiendo...',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          partialText!,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
