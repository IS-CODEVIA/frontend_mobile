import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../riverpod/assignment_notices_riverpod.dart';
import '../widgets/assignment_notice_card.dart';
import '../widgets/new_notice_dialog.dart';

class AssignmentNoticesPage extends ConsumerWidget {
  final String subjectName;

  const AssignmentNoticesPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final notices = ref.watch(assignmentNoticesForSubjectProvider(subjectName));

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: SubjectBottomNav(subjectName: subjectName),
      body: Column(
        children: [
          const HeaderStudents(),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => NewNoticeDialog.show(context, ref, subjectName),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Nuevo anuncio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00CFBB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        return AssignmentNoticeCard(notice: notices[index]);
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
