import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/home_professor_di.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/create_course_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';

final _homeProfessorDIProvider = Provider<HomeProfessorDI>((ref) {
  return HomeProfessorDI(ref.watch(appContainerProvider)!);
});

final _getCoursesUsecaseProvider = Provider<GetCoursesUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).getCoursesUsecase;
});

final _createCourseUsecaseProvider = Provider<CreateCourseUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).createCourseUsecase;
});

final professorSubjectsProvider =
    NotifierProvider<ProfessorSubjectsNotifier, List<CourseEntity>>(
  ProfessorSubjectsNotifier.new,
);

class ProfessorSubjectsNotifier extends Notifier<List<CourseEntity>> {
  @override
  List<CourseEntity> build() {
    _loadCourses();
    return [];
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await ref.read(_getCoursesUsecaseProvider)();
      state = courses;
    } catch (_) {}
  }

  Future<CourseEntity?> createCourse({
    required String courseName,
    required String section,
    required String period,
  }) async {
    try {
      final course = await ref.read(_createCourseUsecaseProvider)(
        courseName: courseName,
        section: section,
        period: period,
      );
      state = [...state, course];
      return course;
    } catch (_) {
      return null;
    }
  }
}
