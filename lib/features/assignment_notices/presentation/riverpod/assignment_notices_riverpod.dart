import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/assignment_notices_di.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/usecases/get_notices_usecase.dart';

final _diProvider = Provider<AssignmentNoticesDI>((ref) {
  return AssignmentNoticesDI(ref.watch(appContainerProvider)!);
});

final _getNoticesUsecaseProvider = Provider<GetNoticesUsecase>(
  (ref) => ref.watch(_diProvider).getNoticesUsecase,
);

class StudentNoticesState {
  final bool isLoading;
  final List<NoticeEntity> notices;
  final String? error;

  const StudentNoticesState({
    this.isLoading = false,
    this.notices = const [],
    this.error,
  });
}

final studentNoticesProvider =
    AsyncNotifierProvider<StudentNoticesNotifier, Map<int, StudentNoticesState>>(
  StudentNoticesNotifier.new,
);

final studentNoticesForCourseProvider =
    Provider.family<AsyncValue<StudentNoticesState>, int>((ref, courseId) {
  final all = ref.watch(studentNoticesProvider);
  final state = all.value?[courseId] ?? const StudentNoticesState(isLoading: true);
  if (state.isLoading) return const AsyncValue.loading();
  if (state.error != null) return AsyncValue.error(state.error!, StackTrace.current);
  return AsyncValue.data(state);
});

class StudentNoticesNotifier
    extends AsyncNotifier<Map<int, StudentNoticesState>> {
  @override
  Future<Map<int, StudentNoticesState>> build() async => {};

  Future<void> loadNotices(int courseId) async {
    state = AsyncValue.data({
      ...state.value ?? {},
      courseId: const StudentNoticesState(isLoading: true),
    });
    try {
      final notices = await ref.read(_getNoticesUsecaseProvider)(
        courseId: courseId,
      );
      notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: StudentNoticesState(notices: notices),
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadNotices error: $e\n$st');
      }
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: StudentNoticesState(error: e.toString()),
      });
    }
  }

  void clearError(int courseId) {
    final current = state.value?[courseId];
    if (current != null && current.error != null) {
      state = AsyncValue.data({
        ...state.value ?? {},
        courseId: StudentNoticesState(notices: current.notices),
      });
    }
  }
}
