import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/archived_professor_subject_bottom_nav.dart';

import '../../../../features/people_professor/domain/models/person_model.dart';
import '../../../../features/people_professor/presentation/riverpod/people_professor_riverpod.dart';
import '../../../../features/people_professor/presentation/widgets/role_section.dart';

class ArchivedPeopleProfessorPage extends ConsumerWidget {
  final String subjectName;

  const ArchivedPeopleProfessorPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final allPeople = ref.watch(professorPeopleProvider);

    final teachers = allPeople.where((p) => p.role == ClassRole.teacher).toList();
    final students = allPeople.where((p) => p.role == ClassRole.student).toList();

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar: ArchivedProfessorSubjectBottomNav(subjectName: subjectName),
      body: Column(
        children: [
          const HeaderProfessors(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 16),
                Text(
                  subjectName,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RoleSection(title: 'Profesor', people: teachers),
                RoleSection(title: 'Alumnos', people: students),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
