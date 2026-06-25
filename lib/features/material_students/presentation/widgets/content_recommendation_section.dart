import 'package:flutter/material.dart';

class ContentRecommendationSection extends StatelessWidget {
  const ContentRecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Text(
          'Recomendacion de contenido',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: colorScheme.secondary,
          thickness: 1.0,
          height: 16,
        ),
        const SizedBox(height: 16),
        // Aquí podrías agregar un ListView o Column con las recomendaciones reales en el futuro
        Text(
          'Aún no hay recomendaciones generadas para esta clase.',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}