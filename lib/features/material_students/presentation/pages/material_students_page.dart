import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

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

class _MaterialStudentsPageState extends ConsumerState<MaterialStudentsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(studentMaterialsProvider.notifier)
          .loadMaterials(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final materials =
        ref.watch(studentMaterialsForCourseProvider(widget.courseId));

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
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.folder_off_outlined,
                              size: 48,
                              color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            'No hay materiales disponibles',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...materials.map((m) => StudentMaterialCard(
                        material: m,
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
