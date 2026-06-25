import 'package:flutter/material.dart';
import '../../domain/models/person_model.dart';

class RoleSection extends StatelessWidget {
  final String title;
  final List<PersonModel> people;

  const RoleSection({super.key, required this.title, required this.people});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...people.map((person) => _buildPersonCard(person, colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildPersonCard(PersonModel person, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest,
          child: Icon(Icons.person, color: colorScheme.outline),
        ),
        title: Text(person.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(person.subtitle, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      ),
    );
  }
}
