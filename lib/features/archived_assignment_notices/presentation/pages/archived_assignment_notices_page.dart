import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/archived_subject_bottom_nav.dart';

import '../../../../features/assignment_notices/presentation/riverpod/assignment_notices_riverpod.dart';
import '../../../../features/assignment_notices/presentation/widgets/assignment_notice_card.dart';

class ArchivedAssignmentNoticesPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const ArchivedAssignmentNoticesPage({
    super.key,
    required this.subjectName,
    this.courseId = 0,
  });

  @override
  ConsumerState<ArchivedAssignmentNoticesPage> createState() =>
      _ArchivedAssignmentNoticesPageState();
}

class _ArchivedAssignmentNoticesPageState
    extends ConsumerState<ArchivedAssignmentNoticesPage> {
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

    final state =
        ref.watch(studentNoticesForCourseProvider(widget.courseId));

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: ArchivedSubjectBottomNav(
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
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.error != null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.error_outline,
                                          size: 48,
                                          color: colorScheme.error),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.error!,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.error,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(studentNoticesProvider
                                                  .notifier)
                                              .loadNotices(widget.courseId);
                                        },
                                        child: const Text('Reintentar'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : state.notices.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            Icons.notifications_off_outlined,
                                            size: 48,
                                            color: colorScheme
                                                .onSurfaceVariant),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No hay avisos',
                                          style: textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => ref
                                        .read(studentNoticesProvider.notifier)
                                        .loadNotices(widget.courseId),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 24),
                                      itemCount: state.notices.length,
                                      itemBuilder: (context, index) {
                                        return AssignmentNoticeCard(
                                            notice: state.notices[index]);
                                      },
                                    ),
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
