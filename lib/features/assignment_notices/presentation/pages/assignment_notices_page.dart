import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../riverpod/assignment_notices_riverpod.dart';
import '../widgets/assignment_notice_card.dart';

class AssignmentNoticesPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const AssignmentNoticesPage({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  ConsumerState<AssignmentNoticesPage> createState() =>
      _AssignmentNoticesPageState();
}

class _AssignmentNoticesPageState
    extends ConsumerState<AssignmentNoticesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(studentNoticesProvider.notifier)
          .loadNotices(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final notices =
        ref.watch(studentNoticesForCourseProvider(widget.courseId));

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.subjectName,
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
                    child: notices.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.notifications_off_outlined,
                                    size: 48,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(height: 12),
                                Text(
                                  'No hay avisos',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.only(top: 8, bottom: 24),
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return AssignmentNoticeCard(
                                  notice: notices[index]);
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
