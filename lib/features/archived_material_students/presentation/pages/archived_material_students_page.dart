import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/archived_subject_bottom_nav.dart';

import '../../../../features/material_students/presentation/widgets/unit_material_section.dart';
import '../../../../features/material_students/domain/models/material_model.dart';

class ArchivedMaterialStudentsPage extends ConsumerWidget {
  final String subjectName;
  final int courseId;

  const ArchivedMaterialStudentsPage({
    super.key,
    required this.subjectName,
    this.courseId = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final unitsData = <UnitMaterialsModel>[];

    return Scaffold(
      drawer: const NavbarStudents(), 
      bottomNavigationBar: ArchivedSubjectBottomNav(subjectName: subjectName),
      body: Column(
        children: [
          const HeaderStudents(),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 16),
                
                Text(
                  subjectName,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                ...unitsData.map((unit) => UnitMaterialSection(
                  unitModel: unit,
                  subjectName: subjectName,
                  courseId: courseId,
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
