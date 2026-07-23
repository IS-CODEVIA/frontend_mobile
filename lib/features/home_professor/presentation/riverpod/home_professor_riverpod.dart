import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../data/datasources/course_remote_datasource.dart';
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

final _courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return ref.watch(_homeProfessorDIProvider).courseRemoteDataSource;
});

final professorSubjectsProvider =
    NotifierProvider<ProfessorSubjectsNotifier, List<CourseEntity>>(
  ProfessorSubjectsNotifier.new,
);

final archivedCourseIdsProvider = NotifierProvider<ArchivedCourseIdsNotifier, Set<int>>(
  ArchivedCourseIdsNotifier.new,
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
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('_loadCourses error: $e\n$st');
      }
    }
  }

  Future<CourseEntity?> createCourse({
    required String courseName,
    required String section,
    required String period,
    required int subjectId,
  }) async {
    try {
      final course = await ref.read(_createCourseUsecaseProvider)(
        courseName: courseName,
        section: section,
        period: period,
        subjectId: subjectId,
      );
      state = [...state, course];
      return course;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('createCourse error: $e\n$st');
      }
      return null;
    }
  }

  Future<bool> archiveCourse(int courseId) async {
    try {
      final ds = ref.read(_courseRemoteDataSourceProvider);
      final classes = await ds.getClasses(courseId);
      for (final c in classes) {
        if (!c.archived) {
          await ds.archiveClass(c.classId);
        }
      }
      ref.read(archivedCourseIdsProvider.notifier).add(courseId);
      return true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('archiveCourse error: $e\n$st');
      }
      return false;
    }
  }

  Future<bool> unarchiveCourse(int courseId) async {
    try {
      final ds = ref.read(_courseRemoteDataSourceProvider);
      final classes = await ds.getClasses(courseId);
      for (final c in classes) {
        if (c.archived) {
          await ds.unarchiveClass(c.classId);
        }
      }
      ref.read(archivedCourseIdsProvider.notifier).remove(courseId);
      return true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('unarchiveCourse error: $e\n$st');
      }
      return false;
    }
  }
}

class ArchivedCourseIdsNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void add(int id) {
    state = {...state, id};
  }

  void remove(int id) {
    state = {...state}..remove(id);
  }
}

final activeProfessorSubjectsProvider = Provider<List<CourseEntity>>((ref) {
  final courses = ref.watch(professorSubjectsProvider);
  final archivedIds = ref.watch(archivedCourseIdsProvider);
  return courses.where((c) => !archivedIds.contains(c.courseId)).toList();
});
