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
    NotifierProvider<StudentNoticesNotifier, Map<int, StudentNoticesState>>(
  StudentNoticesNotifier.new,
);

final studentNoticesForCourseProvider =
    Provider.family<StudentNoticesState, int>((ref, courseId) {
  final all = ref.watch(studentNoticesProvider);
  return all[courseId] ?? const StudentNoticesState(isLoading: true);
});

class StudentNoticesNotifier
    extends Notifier<Map<int, StudentNoticesState>> {
  @override
  Map<int, StudentNoticesState> build() => {};

  Future<void> loadNotices(int courseId) async {
    state = {
      ...state,
      courseId: const StudentNoticesState(isLoading: true),
    };
    try {
      final notices = await ref.read(_getNoticesUsecaseProvider)(
        courseId: courseId,
      );
      notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = {
        ...state,
        courseId: StudentNoticesState(notices: notices),
      };
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('loadNotices error: $e\n$st');
      }
      state = {
        ...state,
        courseId: StudentNoticesState(error: e.toString()),
      };
    }
  }

  void clearError(int courseId) {
    final current = state[courseId];
    if (current != null && current.error != null) {
      state = {
        ...state,
        courseId: StudentNoticesState(notices: current.notices),
      };
    }
  }
}
