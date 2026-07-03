import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/transcription_riverpod.dart';

class LiveStatusIndicator extends ConsumerWidget {
  const LiveStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final connState = ref.watch(
      transcriptionProvider.select((s) => s.connectionState),
    );

    final bool isLive = connState == TranscriptionConnectionState.connected;
    final bool isConnecting =
        connState == TranscriptionConnectionState.connecting;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isConnecting
              ? Icons.sensors_off
              : isLive
                  ? Icons.sensors
                  : Icons.sensors_off,
          color: isLive ? colorScheme.error : colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          isConnecting
              ? 'Conectando...'
              : isLive
                  ? 'En vivo'
                  : 'Desconectado',
          style: textTheme.titleMedium?.copyWith(
            color:
                isLive ? colorScheme.error : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
