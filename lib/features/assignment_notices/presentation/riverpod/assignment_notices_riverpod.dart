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

final studentNoticesProvider =
    NotifierProvider<StudentNoticesNotifier, Map<int, List<NoticeEntity>>>(
  StudentNoticesNotifier.new,
);

final studentNoticesForCourseProvider =
    Provider.family<List<NoticeEntity>, int>((ref, courseId) {
  final all = ref.watch(studentNoticesProvider);
  return all[courseId] ?? [];
});

class StudentNoticesNotifier
    extends Notifier<Map<int, List<NoticeEntity>>> {
  @override
  Map<int, List<NoticeEntity>> build() => {};

  Future<void> loadNotices(int courseId) async {
    try {
      final notices = await ref.read(_getNoticesUsecaseProvider)(
        courseId: courseId,
      );
      state = {...state, courseId: notices};
    } catch (e, st) {
      debugPrint('loadNotices error: $e\n$st');
    }
  }
}
