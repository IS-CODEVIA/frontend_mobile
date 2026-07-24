import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/archived_professor_subject_bottom_nav.dart';

import '../../../../features/people_professor/domain/models/person_model.dart';
import '../../../../features/people_professor/presentation/riverpod/people_professor_riverpod.dart';
import '../../../../features/people_professor/presentation/widgets/role_section.dart';

class ArchivedPeopleProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const ArchivedPeopleProfessorPage({
    super.key,
    required this.subjectName,
    this.courseId = 0,
  });

  @override
  ConsumerState<ArchivedPeopleProfessorPage> createState() =>
      _ArchivedPeopleProfessorPageState();
}

class _ArchivedPeopleProfessorPageState
    extends ConsumerState<ArchivedPeopleProfessorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(professorPeopleProvider.notifier)
          .loadPeople(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final peopleAsync =
        ref.watch(professorPeopleForCourseProvider(widget.courseId));

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar:
          ArchivedProfessorSubjectBottomNav(subjectName: widget.subjectName),
      body: Column(
        children: [
          const HeaderProfessors(),
          Expanded(
            child: peopleAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (state) {
                final teachers = state.people.where((p) => p.role == ClassRole.teacher).toList();
                final students = state.people.where((p) => p.role == ClassRole.student).toList();
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.subjectName,
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    RoleSection(title: 'Profesor', people: teachers),
                    RoleSection(title: 'Alumnos', people: students),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
