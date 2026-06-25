import 'package:flutter/material.dart';
import '../../domain/models/person_model.dart';

class PersonListItem extends StatelessWidget {
  final PersonModel person;

  const PersonListItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: Icon(Icons.person, color: colorScheme.outline, size: 30),
          ),
          const SizedBox(width: 16),
          
          // Textos (Nombre y Subtítulo)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  person.subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary, // Azul oscuro
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}