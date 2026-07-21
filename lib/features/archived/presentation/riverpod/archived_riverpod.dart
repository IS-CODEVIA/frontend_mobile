import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home_student/presentation/riverpod/home_students_riverpod.dart';
import '../../domain/models/archived_subject_model.dart';

final archivedSubjectsProvider = Provider<List<ArchivedSubjectModel>>((ref) {
  final enrollments = ref.watch(archivedEnrollmentsProvider);
  return enrollments.asMap().entries.map((e) {
    final enrollment = e.value;
    return ArchivedSubjectModel(
      id: enrollment.enrollmentId.toString(),
      courseId: enrollment.courseId,
      title: enrollment.courseName,
      subtitle: '${enrollment.section} - ${enrollment.period}',
      teacherName: '',
      colorSeed: e.key,
    );
  }).toList();
});
