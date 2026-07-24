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
    extends AsyncNotifier<Map<int, ProfessorPeopleState>> {
  @override
  Future<Map<int, ProfessorPeopleState>> build() async => {};

  Future<void> loadPeople(int courseId) async {
    state = AsyncValue.data({...state.value ?? {}, courseId: const ProfessorPeopleState(isLoading: true)});
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
      state = AsyncValue.data({...state.value ?? {}, courseId: ProfessorPeopleState(people: people)});
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadPeople error: $e\n$st');
      }
      state = AsyncValue.data({...state.value ?? {}, courseId: const ProfessorPeopleState()});
    }
  }
}

final professorPeopleProvider = AsyncNotifierProvider<
    ProfessorPeopleNotifier, Map<int, ProfessorPeopleState>>(
  ProfessorPeopleNotifier.new,
);

final professorPeopleForCourseProvider =
    Provider.family<AsyncValue<ProfessorPeopleState>, int>((ref, courseId) {
  final all = ref.watch(professorPeopleProvider);
  final state = all.value?[courseId] ?? const ProfessorPeopleState(isLoading: true);
  if (state.isLoading) return const AsyncValue.loading();
  return AsyncValue.data(state);
});
