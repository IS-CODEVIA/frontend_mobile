import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/archived_professor_subject_bottom_nav.dart';

import '../../../../features/assignment_notices_professor/presentation/riverpod/assignment_notices_professor_riverpod.dart';
import '../../../../features/assignment_notices_professor/presentation/widgets/assignment_notice_professor_card.dart';

class ArchivedAssignmentNoticesProfessorPage extends ConsumerWidget {
  final String subjectName;

  const ArchivedAssignmentNoticesProfessorPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(professorNoticesForCourseProvider(0));

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar: ArchivedProfessorSubjectBottomNav(subjectName: subjectName),
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
                  Text(
                    subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Avisos',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: state.notices.length,
                      itemBuilder: (context, index) {
                        return AssignmentNoticeProfessorCard(notice: state.notices[index]);
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
