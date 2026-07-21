import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/home_professor_di.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/archive_class_usecase.dart';
import '../../domain/usecases/create_course_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/unarchive_class_usecase.dart';

final _homeProfessorDIProvider = Provider<HomeProfessorDI>((ref) {
  return HomeProfessorDI(ref.watch(appContainerProvider)!);
});

final _getCoursesUsecaseProvider = Provider<GetCoursesUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).getCoursesUsecase;
});

final _createCourseUsecaseProvider = Provider<CreateCourseUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).createCourseUsecase;
});

final _archiveClassUsecaseProvider = Provider<ArchiveClassUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).archiveClassUsecase;
});

final _unarchiveClassUsecaseProvider = Provider<UnarchiveClassUsecase>((ref) {
  return ref.watch(_homeProfessorDIProvider).unarchiveClassUsecase;
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

  Future<bool> archiveClass(int classId) async {
    try {
      await ref.read(_archiveClassUsecaseProvider)(classId);
      ref.read(archivedCourseIdsProvider.notifier).add(classId);
      return true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('archiveClass error: $e\n$st');
      }
      return false;
    }
  }

  Future<bool> unarchiveClass(int classId) async {
    try {
      await ref.read(_unarchiveClassUsecaseProvider)(classId);
      ref.read(archivedCourseIdsProvider.notifier).remove(classId);
      return true;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('unarchiveClass error: $e\n$st');
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
