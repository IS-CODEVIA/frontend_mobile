import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';

import '../riverpod/assignment_notices_professor_riverpod.dart';
import '../widgets/assignment_notice_professor_card.dart';
import '../widgets/new_notice_professor_dialog.dart';

class AssignmentNoticesProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;
  final String? joinCode;

  const AssignmentNoticesProfessorPage({
    super.key,
    required this.subjectName,
    required this.courseId,
    this.joinCode,
  });

  @override
  ConsumerState<AssignmentNoticesProfessorPage> createState() =>
      _AssignmentNoticesProfessorPageState();
}

class _AssignmentNoticesProfessorPageState
    extends ConsumerState<AssignmentNoticesProfessorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(professorNoticesProvider.notifier)
          .loadNotices(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSmall = MediaQuery.of(context).size.width < 360;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final padding = horizontalPadding(context);

    final state =
        ref.watch(professorNoticesForCourseProvider(widget.courseId));

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    widget.subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize(context, isSmall ? 20 : 24),
                    ),
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
                        border:
                            Border.all(color: colorScheme.outlineVariant),
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
                          Flexible(
                            child: Text(
                              'Código de clase: ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: responsiveFontSize(context, 14),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.joinCode!,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontSize: responsiveFontSize(context, 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: isTablet ? 16 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: colorScheme.secondary,
                        size: isTablet ? 28 : 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Avisos',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: responsiveFontSize(context, 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => NewNoticeProfessorDialog.show(
                        context,
                        ref,
                        widget.courseId,
                      ),
                      icon: Icon(Icons.add_rounded,
                          size: isSmall ? 18 : 20),
                      label: Text('Nuevo anuncio',
                          style: TextStyle(
                              fontSize: responsiveFontSize(context, 14))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00CFBB),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: isSmall ? 8 : 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
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
                                          size: isTablet ? 64 : 48,
                                          color: colorScheme.error),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.error!,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.error,
                                          fontSize: responsiveFontSize(context, 14),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(professorNoticesProvider
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
                                            size: isTablet ? 64 : 48,
                                            color: colorScheme
                                                .onSurfaceVariant),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No hay avisos',
                                          style: textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colorScheme
                                                .onSurfaceVariant,
                                            fontSize: responsiveFontSize(context, 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => ref
                                        .read(professorNoticesProvider
                                            .notifier)
                                        .loadNotices(widget.courseId),
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: isTablet ? 40 : 24),
                                      itemCount: state.notices.length,
                                      itemBuilder: (context, index) {
                                        return AssignmentNoticeProfessorCard(
                                            notice:
                                                state.notices[index]);
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
