import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/archived_professor_subject_bottom_nav.dart';

import '../../../../features/material_professor/presentation/riverpod/material_professor_riverpod.dart';
import '../../../../features/material_professor/presentation/widgets/material_card.dart';
import '../../../../features/transcription/presentation/riverpod/transcription_riverpod.dart';
import '../../../../features/transcription/presentation/widgets/transcription_card.dart';

class ArchivedMaterialProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const ArchivedMaterialProfessorPage({
    super.key,
    required this.subjectName,
    this.courseId = 0,
  });

  @override
  ConsumerState<ArchivedMaterialProfessorPage> createState() =>
      _ArchivedMaterialProfessorPageState();
}

class _ArchivedMaterialProfessorPageState
    extends ConsumerState<ArchivedMaterialProfessorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(materialsProfessorProvider.notifier)
          .loadMaterials(widget.courseId);
      ref
          .read(transcriptionsProvider.notifier)
          .loadTranscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final materials =
        ref.watch(materialsByCourseIdProvider(widget.courseId));
    final transcriptions =
        ref.watch(transcriptionsByCourseIdProvider(widget.courseId));

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar:
          ArchivedProfessorSubjectBottomNav(subjectName: widget.subjectName),
      body: Column(
        children: [
          const HeaderProfessors(),
          Expanded(
            child: ListView(
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.folder_outlined,
                        color: colorScheme.secondary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Material de ${widget.subjectName}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (materials.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.folder_off_outlined,
                              size: 48, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(
                            'Aún no hay materiales',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...materials.map((m) => MaterialCard(
                        material: m,
                        subjectName: widget.subjectName,
                        courseId: widget.courseId,
                      )),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded,
                        color: colorScheme.secondary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Transcripciones de ${widget.subjectName}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (transcriptions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 48, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(
                            'Aún no hay transcripciones',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...transcriptions.map((t) => TranscriptionCard(
                        transcription: t,
                        subjectName: widget.subjectName,
                        courseId: widget.courseId,
                      )),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
