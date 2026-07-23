import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home_professor/presentation/riverpod/home_professor_riverpod.dart';
import '../../domain/models/archived_subject_professor_model.dart';

final archivedProfessorSubjectsProvider = Provider<List<ArchivedSubjectProfessorModel>>((ref) {
  final courses = ref.watch(professorSubjectsProvider);
  final archivedIds = ref.watch(archivedCourseIdsProvider);
  final archived = courses.where((c) => archivedIds.contains(c.courseId)).toList();
  return archived.asMap().entries.map((entry) {
    return ArchivedSubjectProfessorModel.fromCourse(entry.value, entry.key % 7);
  }).toList();
});
