import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../../domain/models/person_model.dart';
import '../riverpod/people_student_riverpod.dart';
import '../widgets/role_section.dart';

class PeopleStudentPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const PeopleStudentPage({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  ConsumerState<PeopleStudentPage> createState() => _PeopleStudentPageState();
}

class _PeopleStudentPageState extends ConsumerState<PeopleStudentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(studentPeopleProvider.notifier).loadPeople(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final state =
        ref.watch(studentPeopleForCourseProvider(widget.courseId));

    final teachers =
        state.people.where((p) => p.role == ClassRole.teacher).toList();
    final students =
        state.people.where((p) => p.role == ClassRole.student).toList();

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: SubjectBottomNav(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
      ),
      body: Column(
        children: [
          const HeaderStudents(),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        widget.subjectName,
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
