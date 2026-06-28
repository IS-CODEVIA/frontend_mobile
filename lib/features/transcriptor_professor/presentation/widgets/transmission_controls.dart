import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/transcription_service.dart';
import '../riverpod/transcription_professor_riverpod.dart';

class TransmissionControls extends ConsumerStatefulWidget {
  const TransmissionControls({super.key});

  @override
  ConsumerState<TransmissionControls> createState() =>
      _TransmissionControlsState();
}

class _TransmissionControlsState extends ConsumerState<TransmissionControls> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tState = ref.watch(professorTranscriptionProvider);
    final notifier = ref.read(professorTranscriptionProvider.notifier);

    if (tState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.clearError();
        _showError(context, tState.error!);
      });
    }

    if (tState.connectionState == TranscriptionConnectionState.connecting) {
      return _buildConnectingState(colorScheme, textTheme);
    }

    if (!tState.isRecording &&
        tState.connectionState != TranscriptionConnectionState.connected) {
      return _buildIdleState(colorScheme, textTheme, notifier);
    }

    if (tState.isRecording) {
      return _buildActiveState(colorScheme, textTheme, tState, notifier);
    }

    return _buildPausedState(colorScheme, textTheme, tState, notifier);
  }

  Widget _buildConnectingState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Conectando...',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ProfessorTranscriptionNotifier notifier,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.record_voice_over,
              size: 50,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Transcripcion en vivo',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia una transmision para transcribir tu clase',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => notifier.startTransmission(),
            icon: const Icon(Icons.play_arrow, size: 28),
            label: const Text('Comenzar transmision'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ProfessorTranscriptionState tState,
    ProfessorTranscriptionNotifier notifier,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'GRABANDO',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (tState.lastPartialText != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tState.lastPartialText!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (tState.partialHistory.length > 1)
          Text(
            '${tState.partialHistory.length} fragmentos recibidos',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(
              icon: Icons.pause_rounded,
              label: 'Pausar',
              color: colorScheme.tertiary,
              onTap: () => notifier.pauseTransmission(),
            ),
            const SizedBox(width: 24),
            _ControlButton(
              icon: Icons.stop_rounded,
              label: 'Terminar',
              color: Colors.red,
              onTap: () => notifier.stopTransmission(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPausedState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ProfessorTranscriptionState tState,
    ProfessorTranscriptionNotifier notifier,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'PAUSADO',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (tState.lastPartialText != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tState.lastPartialText!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(
              icon: Icons.play_arrow_rounded,
              label: 'Reanudar',
              color: colorScheme.primary,
              onTap: () => notifier.resumeTransmission(),
            ),
            const SizedBox(width: 24),
            _ControlButton(
              icon: Icons.stop_rounded,
              label: 'Terminar',
              color: Colors.red,
              onTap: () => notifier.stopTransmission(),
            ),
          ],
        ),
      ],
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
