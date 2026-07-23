import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/study_plan_service.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../data/models/study_plan_model.dart';

enum StudyPlanStatus { idle, loading, success, error }

class StudyPlanState {
  final StudyPlanStatus status;
  final StudyPlanEntity? plan;
  final String? error;

  const StudyPlanState({
    this.status = StudyPlanStatus.idle,
    this.plan,
    this.error,
  });
}

final _studyPlanServiceProvider = Provider<StudyPlanService>((ref) {
  return StudyPlanService();
});

class StudyPlanNotifier extends Notifier<StudyPlanState> {
  @override
  StudyPlanState build() => const StudyPlanState();

  Future<void> generate({
    required String userId,
    required String sessionId,
    String? topic,
  }) async {
    state = const StudyPlanState(status: StudyPlanStatus.loading);
    try {
      final service = ref.read(_studyPlanServiceProvider);

      await service.generateStudyPlan(
        userId: userId,
        sessionId: sessionId,
        topic: topic,
        difficulty: 'intermedio',
        durationHours: 10,
      );

      final json = await service.getStudyPlan(sessionId);
      final plan = StudyPlanModel.fromJson(json);
      state = StudyPlanState(status: StudyPlanStatus.success, plan: plan);
    } catch (e) {
      state = StudyPlanState(
        status: StudyPlanStatus.error,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const StudyPlanState();
  }
}

final studyPlanProvider =
    NotifierProvider<StudyPlanNotifier, StudyPlanState>(StudyPlanNotifier.new);
