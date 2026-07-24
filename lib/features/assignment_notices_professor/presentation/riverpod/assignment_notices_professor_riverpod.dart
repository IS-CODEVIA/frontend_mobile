import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/assignment_notices_professor_di.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/usecases/create_notice_usecase.dart';
import '../../domain/usecases/get_notices_usecase.dart';

final _diProvider = Provider<AssignmentNoticesProfessorDI>((ref) {
  return AssignmentNoticesProfessorDI(ref.watch(appContainerProvider)!);
});

final _getNoticesUsecaseProvider = Provider<GetNoticesUsecase>(
  (ref) => ref.watch(_diProvider).getNoticesUsecase,
);

final _createNoticeUsecaseProvider = Provider<CreateNoticeUsecase>(
  (ref) => ref.watch(_diProvider).createNoticeUsecase,
);

class ProfessorNoticesState {
  final bool isLoading;
  final List<NoticeEntity> notices;
  final String? error;

  const ProfessorNoticesState({
    this.isLoading = false,
    this.notices = const [],
    this.error,
  });
}

final professorNoticesProvider = AsyncNotifierProvider<ProfessorNoticesNotifier,
    Map<int, ProfessorNoticesState>>(
  ProfessorNoticesNotifier.new,
);

final professorNoticesForCourseProvider =
    Provider.family<AsyncValue<ProfessorNoticesState>, int>((ref, courseId) {
  final all = ref.watch(professorNoticesProvider);
  final state = all.value?[courseId] ?? const ProfessorNoticesState(isLoading: true);
  if (state.isLoading) return const AsyncValue.loading();
  if (state.error != null) return AsyncValue.error(state.error!, StackTrace.current);
  return AsyncValue.data(state);
});

class ProfessorNoticesNotifier
    extends AsyncNotifier<Map<int, ProfessorNoticesState>> {
  @override
  Future<Map<int, ProfessorNoticesState>> build() async => {};

  Future<void> loadNotices(int courseId) async {
    state = AsyncValue.data({
      ...state.value ?? {},
      courseId: const ProfessorNoticesState(isLoading: true),
    });
    try {
      final notices = await ref.read(_getNoticesUsecaseProvider)(
        courseId: courseId,
      );
      notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: ProfessorNoticesState(notices: notices),
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadNotices error: $e\n$st');
      }
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: ProfessorNoticesState(error: e.toString()),
      });
    }
  }

  Future<NoticeEntity?> createNotice({
    required int courseId,
    required String title,
    String? description,
  }) async {
    try {
      final notice = await ref.read(_createNoticeUsecaseProvider)(
        courseId: courseId,
        title: title,
        description: description,
      );
      final current = state.value?[courseId]?.notices ?? [];
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: ProfessorNoticesState(notices: [...current, notice]),
      });
      return notice;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('createNotice error: $e\n$st');
      }
      return null;
    }
  }
}
