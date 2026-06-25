import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../../domain/models/material_model.dart';
import '../widgets/material_detail_header.dart';
import '../widgets/content_recommendation_section.dart';

class MaterialDetailPage extends ConsumerWidget {
  final MaterialItemModel material;
  final String subjectName;

  const MaterialDetailPage({super.key, required this.material, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isTranscription = material.type == MaterialItemType.transcription;

    return Scaffold(
      drawer: const NavbarStudents(), 
      bottomNavigationBar: SubjectBottomNav(subjectName: subjectName),

      body: Column(
        children: [
          const HeaderStudents(),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: colorScheme.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      material.unitName,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: colorScheme.secondary,
                  thickness: 1.0,
                  height: 16,
                ),
                const SizedBox(height: 16),
                
                MaterialDetailHeader(material: material),
                const SizedBox(height: 32),
                
                Text(
                  material.content,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                if (isTranscription) 
                  const ContentRecommendationSection(),
                   
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
