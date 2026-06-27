import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/people_professor_di.dart';
import '../../domain/models/person_model.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';

final _diProvider = Provider<PeopleProfessorDI>((ref) {
  return PeopleProfessorDI(ref.watch(appContainerProvider)!);
});

final _getCourseDetailUsecaseProvider = Provider<GetCourseDetailUsecase>(
  (ref) => ref.watch(_diProvider).getCourseDetailUsecase,
);

class ProfessorPeopleState {
  final bool isLoading;
  final List<PersonModel> people;

  const ProfessorPeopleState({
    this.isLoading = false,
    this.people = const [],
  });
}

class ProfessorPeopleNotifier
    extends Notifier<Map<int, ProfessorPeopleState>> {
  @override
  Map<int, ProfessorPeopleState> build() => {};

  Future<void> loadPeople(int courseId) async {
    state = {
      ...state,
      courseId: const ProfessorPeopleState(isLoading: true),
    };
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
      state = {
        ...state,
        courseId: ProfessorPeopleState(people: people),
      };
    } catch (e, st) {
      debugPrint('loadPeople error: $e\n$st');
      state = {
        ...state,
        courseId: const ProfessorPeopleState(),
      };
    }
  }
}

final professorPeopleProvider = NotifierProvider<
    ProfessorPeopleNotifier, Map<int, ProfessorPeopleState>>(
  ProfessorPeopleNotifier.new,
);

final professorPeopleForCourseProvider =
    Provider.family<ProfessorPeopleState, int>((ref, courseId) {
  final all = ref.watch(professorPeopleProvider);
  return all[courseId] ?? const ProfessorPeopleState(isLoading: true);
});
