import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../../domain/models/person_model.dart';
import '../riverpod/people_riverpod.dart';
import '../widgets/role_section.dart';

class PeopleStudentPage extends ConsumerWidget {
  final String subjectName;
  final int courseId;

  const PeopleStudentPage({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final allPeople = ref.watch(classPeopleProvider);

    final teachers = allPeople.where((p) => p.role == ClassRole.teacher).toList();
    final students = allPeople.where((p) => p.role == ClassRole.student).toList();

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: SubjectBottomNav(
        subjectName: subjectName,
        courseId: courseId,
      ),

      body: Column(
        children: [
          const HeaderStudents(),
          
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
                
                RoleSection(
                  title: 'Profesor',
                  people: teachers,
                ),
                
                RoleSection(
                  title: 'Alumnos',
                  people: students,
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
