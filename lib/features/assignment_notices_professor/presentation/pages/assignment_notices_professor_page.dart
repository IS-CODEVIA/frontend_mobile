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
    final landscape = isLandscape(context);
    final padding = horizontalPadding(context);

    final noticesAsync =
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
                  SizedBox(height: landscape ? responsiveSpacing(context, 16) : (isTablet ? 24 : 16)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.subjectName,
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: responsiveFontSize(context, landscape ? 18 : (isSmall ? 20 : 24)),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (widget.joinCode != null &&
                      widget.joinCode!.isNotEmpty) ...[
                    SizedBox(height: responsiveSpacing(context, 8)),
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
                            size: landscape ? 14 : 16,
                            color: colorScheme.secondary,
                          ),
                          SizedBox(width: landscape ? 4 : 8),
                          Flexible(
                            child: Text(
                              'Código de clase: ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: responsiveFontSize(context, landscape ? 12 : 14),
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
                                fontSize: responsiveFontSize(context, landscape ? 13 : 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: landscape ? responsiveSpacing(context, 8) : (isTablet ? 16 : 8)),
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: colorScheme.secondary,
                        size: landscape ? 20 : (isTablet ? 28 : 24),
                      ),
                      SizedBox(width: landscape ? 6 : 8),
                      Text(
                        'Avisos',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: responsiveFontSize(context, landscape ? 14 : 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: landscape ? responsiveSpacing(context, 12) : (isTablet ? 16 : 12)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => NewNoticeProfessorDialog.show(
                        context,
                        ref,
                        widget.courseId,
                      ),
                      icon: Icon(Icons.add_rounded,
                          size: landscape ? 16 : (isSmall ? 18 : 20)),
                      label: Text('Nuevo anuncio',
                          style: TextStyle(
                              fontSize: responsiveFontSize(context, landscape ? 12 : 14))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff008A7B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: landscape ? 6 : (isSmall ? 8 : 12)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: landscape ? responsiveSpacing(context, 16) : (isTablet ? 24 : 16)),
                  Expanded(
                    child: noticesAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,
                                  size: landscape ? 32 : (isTablet ? 64 : 48),
                                  color: colorScheme.error),
                              SizedBox(height: responsiveSpacing(context, 12)),
                              Text(
                                error.toString(),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                  fontSize: responsiveFontSize(context, landscape ? 12 : 14),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: responsiveSpacing(context, 8)),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(professorNoticesProvider.notifier)
                                      .loadNotices(widget.courseId);
                                },
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (state) => state.notices.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      Icons.notifications_off_outlined,
                                      size: landscape ? 32 : (isTablet ? 64 : 48),
                                      color: colorScheme
                                          .onSurfaceVariant),
                                  SizedBox(height: responsiveSpacing(context, 12)),
                                  Text(
                                    'No hay avisos',
                                    style: textTheme.bodyLarge
                                        ?.copyWith(
                                      color: colorScheme
                                          .onSurfaceVariant,
                                      fontSize: responsiveFontSize(context, landscape ? 14 : 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => ref
                                  .read(professorNoticesProvider.notifier)
                                  .loadNotices(widget.courseId),
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: landscape ? 16 : (isTablet ? 40 : 24)),
                                itemCount: state.notices.length,
                                itemBuilder: (context, index) {
                                  return AssignmentNoticeProfessorCard(
                                      notice:
                                          state.notices[index]);
                                },
                              ),
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
