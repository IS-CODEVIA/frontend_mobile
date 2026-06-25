import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';

import '../widgets/transmission_controls.dart';
import '../widgets/chat_sheet.dart';

class TranscriptorProfessorPage extends ConsumerWidget {
  final String subjectName;

  const TranscriptorProfessorPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar: ProfessorSubjectBottomNav(subjectName: subjectName),
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
                        Icons.record_voice_over_outlined,
                        color: colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Transcripcion en vivo',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: colorScheme.secondary,
                          size: 28,
                        ),
                        tooltip: 'Ver mensajes de alumnos',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ChatSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: TransmissionControls(),
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
