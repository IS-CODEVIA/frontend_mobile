import 'package:flutter/material.dart';
import '../../domain/models/person_model.dart';
import 'person_list_item.dart';

class RoleSection extends StatelessWidget {
  final String title;
  final List<PersonModel> people;

  const RoleSection({super.key, required this.title, required this.people});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (people.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Título de la sección (Profesor / Alumnos)
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Línea divisoria azul oscuro
        Divider(
          color: colorScheme.secondary,
          thickness: 1.0,
          height: 16,
        ),
        const SizedBox(height: 8),
        // Lista de personas en esta sección
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: people.length,
          itemBuilder: (context, index) {
            return PersonListItem(person: people[index]);
          },
        ),
      ],
    );
  }
}