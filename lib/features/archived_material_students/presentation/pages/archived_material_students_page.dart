import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/archived_subject_bottom_nav.dart';

import '../../../../features/material_students/presentation/riverpod/materials_riverpod.dart';
import '../../../../features/material_students/presentation/widgets/unit_material_section.dart';

class ArchivedMaterialStudentsPage extends ConsumerWidget {
  final String subjectName;

  const ArchivedMaterialStudentsPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final unitsData = ref.watch(materialsProvider);

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
                
                ...unitsData.map((unit) => UnitMaterialSection(unitModel: unit, subjectName: subjectName)),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
