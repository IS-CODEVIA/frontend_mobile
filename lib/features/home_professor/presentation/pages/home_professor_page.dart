import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';

import '../riverpod/home_professor_riverpod.dart';
import '../widgets/subject_professor_card.dart';

class HomeProfessorPage extends ConsumerWidget {
  const HomeProfessorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final subjects = ref.watch(professorSubjectsProvider);

    return Scaffold(
      drawer: const NavbarProfessors(),
      body: Column(
        children: [
          const HeaderProfessors(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Asignaturas',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${subjects.length}',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        return SubjectProfessorCard(subject: subjects[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
