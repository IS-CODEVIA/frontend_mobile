import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';

import '../widgets/transmission_controls.dart';
import '../widgets/chat_sheet.dart';

class TranscriptorProfessorPage extends ConsumerWidget {
  final String subjectName;
  final int courseId;
  final String? joinCode;

  const TranscriptorProfessorPage({
    super.key,
    required this.subjectName,
    required this.courseId,
    this.joinCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final landscape = isLandscape(context);
    final padding = horizontalPadding(context);

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar: ProfessorSubjectBottomNav(
        subjectName: subjectName,
        courseId: courseId,
        joinCode: joinCode,
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
                  SizedBox(height: responsiveSpacing(context, 16)),
                  Text(
                    subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize(context, landscape ? 20 : 24),
                    ),
                  ),
                  if (joinCode != null && joinCode!.isNotEmpty) ...[
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
                          Text(
                            'Código de clase: ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: responsiveFontSize(context, landscape ? 12 : 14),
                            ),
                          ),
                          Text(
                            joinCode!,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: responsiveFontSize(context, landscape ? 14 : 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: responsiveSpacing(context, 8)),
                  Row(
                    children: [
                      Icon(
                        Icons.record_voice_over_outlined,
                        color: colorScheme.secondary,
                        size: landscape ? 20 : 24,
                      ),
                      SizedBox(width: landscape ? 6 : 8),
                      Text(
                        'Transcripcion en vivo',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: responsiveFontSize(context, landscape ? 14 : 16),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: colorScheme.secondary,
                          size: landscape ? 22 : 28,
                        ),
                        tooltip: 'Ver mensajes de alumnos',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ChatSheet(courseId: courseId),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveSpacing(context, 12)),
                  Expanded(
                    child: TransmissionControls(
                      subjectName: subjectName,
                      courseId: courseId,
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
