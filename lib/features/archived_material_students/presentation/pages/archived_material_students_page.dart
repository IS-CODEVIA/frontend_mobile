import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/archived_subject_bottom_nav.dart';

import '../../../../features/material_students/presentation/widgets/unit_material_section.dart';
import '../../../../features/material_students/domain/models/material_model.dart';
import '../../../../features/material_students/presentation/riverpod/materials_riverpod.dart';

class ArchivedMaterialStudentsPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const ArchivedMaterialStudentsPage({
    super.key,
    required this.subjectName,
    this.courseId = 0,
  });

  @override
  ConsumerState<ArchivedMaterialStudentsPage> createState() =>
      _ArchivedMaterialStudentsPageState();
}

class _ArchivedMaterialStudentsPageState
    extends ConsumerState<ArchivedMaterialStudentsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.courseId > 0) {
      ref.read(studentMaterialsProvider.notifier).loadMaterials(widget.courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textScheme = Theme.of(context).textTheme;

    final materials = ref.watch(studentMaterialsForCourseProvider(widget.courseId));
    final unitsData = <UnitMaterialsModel>[];

    return Scaffold(
      drawer: const NavbarStudents(), 
      bottomNavigationBar: ArchivedSubjectBottomNav(subjectName: widget.subjectName),
      body: Column(
        children: [
          const HeaderStudents(),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 16),
                
                Text(
                  widget.subjectName,
                  style: textScheme.headlineMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                ...unitsData.map((unit) => UnitMaterialSection(
                  unitModel: unit,
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
