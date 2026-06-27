import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets_professor/header_professors.dart';
import '../../../../shared/widgets_professor/navbar_professors.dart';
import '../../../../shared/widgets_professor/professor_subject_bottom_nav.dart';

import '../riverpod/material_professor_riverpod.dart';
import '../widgets/create_material_sheet.dart';
import '../widgets/material_card.dart';

class MaterialProfessorPage extends ConsumerStatefulWidget {
  final String subjectName;

  const MaterialProfessorPage({super.key, required this.subjectName});

  @override
  ConsumerState<MaterialProfessorPage> createState() =>
      _MaterialProfessorPageState();
}

class _MaterialProfessorPageState
    extends ConsumerState<MaterialProfessorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(materialsProfessorProvider.notifier)
          .loadMaterials(widget.subjectName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final materials =
        ref.watch(materialsForSubjectProvider(widget.subjectName));

    return Scaffold(
      drawer: const NavbarProfessors(),
      bottomNavigationBar:
          ProfessorSubjectBottomNav(subjectName: widget.subjectName),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) =>
                CreateMaterialSheet(subjectName: widget.subjectName),
          );
        },
        backgroundColor: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, color: colorScheme.onSecondary, size: 32),
      ),
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
                  Expanded(
                    child: materials.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.folder_off_outlined,
                                    size: 48,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(height: 12),
                                Text(
                                  'Aún no hay materiales',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Presiona + para subir tu primer material',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.only(top: 8, bottom: 80),
                            itemCount: materials.length,
                            itemBuilder: (context, index) {
                              return MaterialCard(
                                material: materials[index],
                                subjectName: widget.subjectName,
                              );
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
