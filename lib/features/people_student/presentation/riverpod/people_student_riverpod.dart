import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/people_student_di.dart';
import '../../domain/models/person_model.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';

final _diProvider = Provider<PeopleStudentDI>((ref) {
  return PeopleStudentDI(ref.watch(appContainerProvider)!);
});

final _getCourseDetailUsecaseProvider = Provider<GetCourseDetailUsecase>(
  (ref) => ref.watch(_diProvider).getCourseDetailUsecase,
);

class StudentPeopleState {
  final bool isLoading;
  final List<PersonModel> people;

  const StudentPeopleState({
    this.isLoading = false,
    this.people = const [],
  });
}

class StudentPeopleNotifier
    extends AsyncNotifier<Map<int, StudentPeopleState>> {
  @override
  Future<Map<int, StudentPeopleState>> build() async => {};

  Future<void> loadPeople(int courseId) async {
    state = AsyncValue.data({...state.value ?? {}, courseId: const StudentPeopleState(isLoading: true)});
    try {
      final detail = await ref.read(_getCourseDetailUsecaseProvider)(
        courseId: courseId,
      );
      final people = [
        PersonModel(
          id: detail.teacher.userId.toString(),
          name: detail.teacher.name,
          subtitle: '',
          role: ClassRole.teacher,
        ),
        ...detail.students.map(
          (s) => PersonModel(
            id: s.userId.toString(),
            name: s.name,
            subtitle: '',
            role: ClassRole.student,
          ),
        ),
      ];
      state = AsyncValue.data({...state.value ?? {}, courseId: StudentPeopleState(people: people)});
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadPeople error: $e\n$st');
      }
      state = AsyncValue.data({...state.value ?? {}, courseId: const StudentPeopleState()});
    }
  }
}

final studentPeopleProvider =
    AsyncNotifierProvider<StudentPeopleNotifier, Map<int, StudentPeopleState>>(
  StudentPeopleNotifier.new,
);

final studentPeopleForCourseProvider =
    Provider.family<AsyncValue<StudentPeopleState>, int>((ref, courseId) {
  final all = ref.watch(studentPeopleProvider);
  final state = all.value?[courseId] ?? const StudentPeopleState(isLoading: true);
  if (state.isLoading) return const AsyncValue.loading();
  return AsyncValue.data(state);
});
