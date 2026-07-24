import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';
import '../../../transcription/domain/entities/transcription_entity.dart';
import '../../../transcription/presentation/pages/transcription_detail_page_professor.dart';
import '../../../transcription/presentation/riverpod/transcription_riverpod.dart';
import '../../../transcription/presentation/widgets/transcription_card.dart';
import '../../domain/entities/material_entity.dart';

import '../riverpod/material_professor_riverpod.dart';
import '../widgets/create_material_sheet.dart';
import '../widgets/material_card.dart';

class MaterialProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;
  final String? joinCode;

  const MaterialProfessorPage({
    super.key,
    required this.subjectName,
    required this.courseId,
    this.joinCode,
  });

  @override
  ConsumerState<MaterialProfessorPage> createState() =>
      _MaterialProfessorPageState();
}

enum _ContentFilter { all, materials, transcriptions }

class _MaterialProfessorPageState
    extends ConsumerState<MaterialProfessorPage> {
  _ContentFilter _selectedFilter = _ContentFilter.all;

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
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isSmall = MediaQuery.of(context).size.width < 360;
    final padding = horizontalPadding(context);

    final materialsAsync =
        ref.watch(materialsByCourseIdProvider(widget.courseId));
    final transcriptions =
        ref.watch(transcriptionsByCourseIdProvider(widget.courseId));

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar: ProfessorSubjectBottomNav(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
        joinCode: widget.joinCode,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => CreateMaterialSheet(
              subjectName: widget.subjectName,
              courseId: widget.courseId,
            ),
          );
        },
        backgroundColor: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, color: colorScheme.onSecondary, size: isSmall ? 24 : 32),
      ),
      body: Column(
        children: [
          const HeaderProfessors(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: padding),
              children: [
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
                SizedBox(height: isTablet ? 24 : 16),
                Row(
                  children: [
                    Icon(Icons.folder_outlined,
                        color: colorScheme.secondary,
                        size: isTablet ? 28 : 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Material de ${widget.subjectName}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveFontSize(context, 16),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmall ? 12 : 16, vertical: 4),
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
                            size: isSmall ? 18 : 20,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          _filterLabel(_selectedFilter),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: responsiveFontSize(context, 14),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_drop_down_rounded,
                            color: colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                if (_selectedFilter != _ContentFilter.transcriptions)
                  ...materialsAsync.when(
                    loading: () => [const Center(child: CircularProgressIndicator())],
                    error: (e, _) => [Center(child: Text('Error: $e'))],
                    data: (materials) => _buildMaterialsSection(colorScheme, textTheme, materials),
                  ),
                if (_selectedFilter != _ContentFilter.materials)
                  ..._buildTranscriptionsSection(
                      colorScheme, textTheme, transcriptions),
                SizedBox(height: isTablet ? 100 : 80),
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
    List<MaterialEntity> materials,
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
                  'Aún no hay materiales',
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
    return materials.map((m) => MaterialCard(
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
          Expanded(
            child: Text(
              'Transcripciones de ${widget.subjectName}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
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
                  builder: (_) => TranscriptionDetailProfessorPage(
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
