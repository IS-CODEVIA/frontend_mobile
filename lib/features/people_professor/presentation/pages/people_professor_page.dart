import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';

import '../../domain/models/person_model.dart';
import '../riverpod/people_professor_riverpod.dart';
import '../widgets/role_section.dart';

class PeopleProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;
  final String? joinCode;

  const PeopleProfessorPage({
    super.key,
    required this.subjectName,
    required this.courseId,
    this.joinCode,
  });

  @override
  ConsumerState<PeopleProfessorPage> createState() =>
      _PeopleProfessorPageState();
}

class _PeopleProfessorPageState extends ConsumerState<PeopleProfessorPage> {
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
      bottomNavigationBar: ProfessorSubjectBottomNav(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
        joinCode: widget.joinCode,
      ),
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
                    if (widget.joinCode != null &&
                        widget.joinCode!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.key_rounded,
                              size: 16,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Código de clase: ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              widget.joinCode!,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
