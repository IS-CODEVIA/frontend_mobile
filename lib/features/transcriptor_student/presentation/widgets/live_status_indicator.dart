import 'package:flutter/material.dart';

class LiveStatusIndicator extends StatelessWidget {
  const LiveStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.sensors,
          color: colorScheme.error,
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          'En vivo',
          style: textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}