import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/home_student_di.dart';
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

  const HomeStudentState({
    this.isLoading = false,
    this.error,
    this.isJoining = false,
    this.joinError,
    this.joinResult,
    this.subjects = const [],
  });

  HomeStudentState copyWith({
    bool? isLoading,
    String? error,
    bool? isJoining,
    String? joinError,
    JoinCourseEntity? joinResult,
    List<SubjectModel>? subjects,
  }) {
    return HomeStudentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isJoining: isJoining ?? this.isJoining,
      joinError: joinError,
      joinResult: joinResult ?? this.joinResult,
      subjects: subjects ?? this.subjects,
    );
  }
}

class HomeStudentNotifier extends Notifier<HomeStudentState> {
  @override
  HomeStudentState build() {
    loadEnrollments();
    return const HomeStudentState();
  }

  Future<void> loadEnrollments() async {
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
      state = state.copyWith(subjects: subjects);
    } catch (e, st) {
      debugPrint('loadEnrollments error: $e\n$st');
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<JoinCourseEntity?> joinCourse(String joinCode) async {
    state = state.copyWith(isJoining: true, joinError: null, joinResult: null);
    try {
      final result = await ref.read(_joinCourseUsecaseProvider)(joinCode);
      state = state.copyWith(isJoining: false, joinResult: result);
      loadEnrollments();
      return result;
    } catch (e, st) {
      debugPrint('joinCourse error: $e\n$st');
      state = state.copyWith(isJoining: false, joinError: e.toString());
      return null;
    }
  }

  void clearJoinResult() {
    state = state.copyWith(joinResult: null, joinError: null);
  }
}

final homeStudentProvider =
    NotifierProvider<HomeStudentNotifier, HomeStudentState>(
  HomeStudentNotifier.new,
);

final subjectsProvider = Provider<List<SubjectModel>>((ref) {
  return ref.watch(homeStudentProvider).subjects;
});
