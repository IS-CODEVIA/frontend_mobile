import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/home_student_di.dart';
import '../../domain/entities/enrolled_course_entity.dart';
import '../../domain/entities/join_course_entity.dart';
import '../../domain/models/subject_model.dart';
import '../../domain/usecases/get_my_enrollments_usecase.dart';
import '../../domain/usecases/join_course_usecase.dart';

final _homeStudentDIProvider = Provider<HomeStudentDI>((ref) {
  return HomeStudentDI(ref.watch(appContainerProvider)!);
});

final _joinCourseUsecaseProvider = Provider<JoinCourseUsecase>((ref) {
  return ref.watch(_homeStudentDIProvider).joinCourseUsecase;
});

final _getMyEnrollmentsUsecaseProvider = Provider<GetMyEnrollmentsUsecase>(
  (ref) => ref.watch(_homeStudentDIProvider).getMyEnrollmentsUsecase,
);

class HomeStudentState {
  final bool isLoading;
  final String? error;
  final bool isJoining;
  final String? joinError;
  final JoinCourseEntity? joinResult;
  final List<SubjectModel> subjects;
  final List<EnrolledCourseEntity> enrollments;

  const HomeStudentState({
    this.isLoading = false,
    this.error,
    this.isJoining = false,
    this.joinError,
    this.joinResult,
    this.subjects = const [],
    this.enrollments = const [],
  });

  HomeStudentState copyWith({
    bool? isLoading,
    String? error,
    bool? isJoining,
    String? joinError,
    JoinCourseEntity? joinResult,
    List<SubjectModel>? subjects,
    List<EnrolledCourseEntity>? enrollments,
  }) {
    return HomeStudentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isJoining: isJoining ?? this.isJoining,
      joinError: joinError,
      joinResult: joinResult ?? this.joinResult,
      subjects: subjects ?? this.subjects,
      enrollments: enrollments ?? this.enrollments,
    );
  }
}

class HomeStudentNotifier extends AsyncNotifier<HomeStudentState> {
  @override
  Future<HomeStudentState> build() async {
    try {
      final enrollments = await ref.read(_getMyEnrollmentsUsecaseProvider)();
      final subjects = enrollments
          .asMap()
          .entries
          .map(
            (e) => SubjectModel(
              id: e.value.courseId,
              courseId: e.value.courseId,
              title: e.value.courseName,
              subtitle: '${e.value.section} - ${e.value.period}',
              colorSeed: e.key,
            ),
          )
          .toList();
      return HomeStudentState(subjects: subjects, enrollments: enrollments);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadEnrollments error: $e\n$st');
      }
      return HomeStudentState(error: e.toString());
    }
  }

  Future<JoinCourseEntity?> joinCourse(String joinCode) async {
    state = AsyncValue.data(state.requireValue.copyWith(isJoining: true, joinError: null, joinResult: null));
    try {
      final result = await ref.read(_joinCourseUsecaseProvider)(joinCode);
      state = AsyncValue.data(state.requireValue.copyWith(isJoining: false, joinResult: result));
      ref.invalidateSelf();
      return result;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('joinCourse error: $e\n$st');
      }
      state = AsyncValue.data(state.requireValue.copyWith(isJoining: false, joinError: e.toString()));
      return null;
    }
  }

  void clearJoinResult() {
    state = AsyncValue.data(state.requireValue.copyWith(joinResult: null, joinError: null));
  }
}

final homeStudentProvider =
    AsyncNotifierProvider<HomeStudentNotifier, HomeStudentState>(
  HomeStudentNotifier.new,
);

final subjectsProvider = Provider<List<SubjectModel>>((ref) {
  return ref.watch(homeStudentProvider).asData?.value.subjects ?? [];
});

final enrolledCoursesProvider = Provider<List<EnrolledCourseEntity>>((ref) {
  return ref.watch(homeStudentProvider).asData?.value.enrollments ?? [];
});

final archivedEnrollmentsProvider = Provider<List<EnrolledCourseEntity>>((ref) {
  final courses = ref.watch(enrolledCoursesProvider);
  return courses.where((e) => e.status == 'archived').toList();
});
