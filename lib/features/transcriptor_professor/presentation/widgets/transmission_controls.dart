import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../riverpod/transcription_professor_riverpod.dart';
import 'save_transcription_sheet.dart';

class TransmissionControls extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const TransmissionControls({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.record_voice_over,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => notifier.startTransmission(widget.courseId),
              icon: const Icon(Icons.play_arrow, size: 24),
              label: const Text('Comenzar transmision'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ProfessorTranscriptionState tState,
    ProfessorTranscriptionNotifier notifier,
  ) {
    final landscape = isLandscape(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
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
                SizedBox(height: responsiveSpacing(context, 16)),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: landscape ? 100 : 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      tState.lastPartialText!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: responsiveSpacing(context, 16)),
              if (tState.partialHistory.length > 1)
                Text(
                  '${tState.partialHistory.length} fragmentos recibidos',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              SizedBox(height: responsiveSpacing(context, 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ControlButton(
                    icon: Icons.pause_rounded,
                    label: 'Pausar',
                    color: colorScheme.tertiary,
                    onTap: () => notifier.pauseTransmission(),
                    landscape: landscape,
                  ),
                  SizedBox(width: landscape ? 12 : 24),
                  _ControlButton(
                    icon: Icons.stop_rounded,
                    label: 'Terminar',
                    color: Colors.red,
                    onTap: () async {
                      await notifier.stopTransmission();
                      if (!mounted) return;
                      _showSaveSheet(this.context);
                    },
                    landscape: landscape,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPausedState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ProfessorTranscriptionState tState,
    ProfessorTranscriptionNotifier notifier,
  ) {
    final landscape = isLandscape(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
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
                SizedBox(height: responsiveSpacing(context, 16)),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: landscape ? 100 : 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      tState.lastPartialText!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: responsiveSpacing(context, 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ControlButton(
                    icon: Icons.play_arrow_rounded,
                    label: 'Reanudar',
                    color: colorScheme.primary,
                    onTap: () => notifier.resumeTransmission(),
                    landscape: landscape,
                  ),
                  SizedBox(width: landscape ? 12 : 24),
                  _ControlButton(
                    icon: Icons.stop_rounded,
                    label: 'Terminar',
                    color: Colors.red,
                    onTap: () async {
                      await notifier.stopTransmission();
                      if (!mounted) return;
                      _showSaveSheet(this.context);
                    },
                    landscape: landscape,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSaveSheet(BuildContext context) {
    final tState = ref.read(professorTranscriptionProvider);
    final fullText = tState.finalHistory.join('\n\n');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveTranscriptionSheet(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
        fullText: fullText,
      ),
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
  final bool landscape;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    final size = landscape ? 48.0 : 64.0;
    final iconSize = landscape ? 24.0 : 32.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: landscape ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
