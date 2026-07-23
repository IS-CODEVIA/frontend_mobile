import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';
import '../../../transcription/domain/entities/transcription_entity.dart';
import '../../../transcription/presentation/pages/transcription_detail_page_student.dart';
import '../../../transcription/presentation/riverpod/transcription_riverpod.dart';
import '../../../transcription/presentation/widgets/transcription_card.dart';
import '../../domain/entities/student_material_entity.dart';

import '../riverpod/materials_riverpod.dart';
import '../widgets/student_material_card.dart';

class MaterialStudentsPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const MaterialStudentsPage({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  ConsumerState<MaterialStudentsPage> createState() =>
      _MaterialStudentsPageState();
}

enum _ContentFilter { all, materials, transcriptions }

class _MaterialStudentsPageState extends ConsumerState<MaterialStudentsPage> {
  _ContentFilter _selectedFilter = _ContentFilter.all;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(studentMaterialsProvider.notifier)
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
        ref.watch(studentMaterialsForCourseProvider(widget.courseId));
    final transcriptions =
        ref.watch(transcriptionsByCourseIdProvider(widget.courseId));

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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.folder_outlined,
                        color: colorScheme.secondary, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Material de ${widget.subjectName}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(
                          () => _selectedFilter = _ContentFilter.transcriptions),
                      icon: Icon(Icons.menu_book_rounded,
                          color: colorScheme.secondary),
                      tooltip: 'Ver transcripciones',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: PopupMenuButton<_ContentFilter>(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) =>
                        setState(() => _selectedFilter = value),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _ContentFilter.all,
                        child: _FilterItem(
                          icon: Icons.select_all_rounded,
                          label: 'Todo',
                          isSelected: _selectedFilter == _ContentFilter.all,
                          colorScheme: colorScheme,
                        ),
                      ),
                      PopupMenuItem(
                        value: _ContentFilter.materials,
                        child: _FilterItem(
                          icon: Icons.folder_outlined,
                          label: 'Materiales',
                          isSelected:
                              _selectedFilter == _ContentFilter.materials,
                          colorScheme: colorScheme,
                        ),
                      ),
                      PopupMenuItem(
                        value: _ContentFilter.transcriptions,
                        child: _FilterItem(
                          icon: Icons.menu_book_rounded,
                          label: 'Transcripciones',
                          isSelected:
                              _selectedFilter == _ContentFilter.transcriptions,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_rounded,
                            size: 20, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          _filterLabel(_selectedFilter),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_drop_down_rounded,
                            color: colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedFilter != _ContentFilter.transcriptions)
                  ..._buildMaterialsSection(colorScheme, textTheme, materials),
                if (_selectedFilter != _ContentFilter.materials)
                  ..._buildTranscriptionsSection(
                      colorScheme, textTheme, transcriptions),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMaterialsSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<StudentMaterialEntity> materials,
  ) {
    if (materials.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.folder_off_outlined,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'No hay materiales disponibles',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }
    return materials.map((m) => StudentMaterialCard(
          material: m,
          subjectName: widget.subjectName,
          courseId: widget.courseId,
        )).toList();
  }

  List<Widget> _buildTranscriptionsSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<TranscriptionEntity> transcriptions,
  ) {
    final result = <Widget>[];
    result.add(const SizedBox(height: 24));
    result.add(
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
    );
    result.add(const SizedBox(height: 16));
    if (transcriptions.isEmpty) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.menu_book_outlined,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'No hay transcripciones disponibles',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      result.addAll(transcriptions.map((t) => TranscriptionCard(
            transcription: t,
            subjectName: widget.subjectName,
            courseId: widget.courseId,
            onViewMore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TranscriptionDetailStudentPage(
                    transcription: t,
                    subjectName: widget.subjectName,
                    courseId: widget.courseId,
                  ),
                ),
              );
            },
          )));
    }
    return result;
  }

  String _filterLabel(_ContentFilter filter) {
    switch (filter) {
      case _ContentFilter.all:
        return 'Todo';
      case _ContentFilter.materials:
        return 'Materiales';
      case _ContentFilter.transcriptions:
        return 'Transcripciones';
    }
  }
}

class _FilterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final ColorScheme colorScheme;

  const _FilterItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isSelected
              ? colorScheme.secondary
              : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected) ...[
          const Spacer(),
          Icon(Icons.check, size: 18, color: colorScheme.secondary),
        ],
      ],
    );
  }
}
