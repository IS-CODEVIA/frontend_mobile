import 'package:flutter/material.dart';

enum TransmissionStatus { idle, recording, paused }

class TransmissionControls extends StatefulWidget {
  const TransmissionControls({super.key});

  @override
  State<TransmissionControls> createState() => _TransmissionControlsState();
}

class _TransmissionControlsState extends State<TransmissionControls> {
  TransmissionStatus _status = TransmissionStatus.idle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    switch (_status) {
      case TransmissionStatus.idle:
        return _buildIdleState(colorScheme, textTheme);
      case TransmissionStatus.recording:
        return _buildActiveState(colorScheme, textTheme);
      case TransmissionStatus.paused:
        return _buildPausedState(colorScheme, textTheme);
    }
  }

  Widget _buildIdleState(ColorScheme colorScheme, TextTheme textTheme) {
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
            onPressed: () => setState(() => _status = TransmissionStatus.recording),
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

  Widget _buildActiveState(ColorScheme colorScheme, TextTheme textTheme) {
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
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(
              icon: Icons.pause_rounded,
              label: 'Pausar',
              color: colorScheme.tertiary,
              onTap: () => setState(() => _status = TransmissionStatus.paused),
            ),
            const SizedBox(width: 24),
            _ControlButton(
              icon: Icons.stop_rounded,
              label: 'Terminar',
              color: Colors.red,
              onTap: () => setState(() => _status = TransmissionStatus.idle),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPausedState(ColorScheme colorScheme, TextTheme textTheme) {
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
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(
              icon: Icons.play_arrow_rounded,
              label: 'Reanudar',
              color: colorScheme.primary,
              onTap: () => setState(() => _status = TransmissionStatus.recording),
            ),
            const SizedBox(width: 24),
            _ControlButton(
              icon: Icons.stop_rounded,
              label: 'Terminar',
              color: Colors.red,
              onTap: () => setState(() => _status = TransmissionStatus.idle),
            ),
          ],
        ),
      ],
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
