import '../../domain/entities/study_plan_entity.dart';

class StudyPlanModel {
  final String planId;
  final String topic;
  final String difficulty;
  final int durationHours;
  final List<ModuleModel> modules;

  const StudyPlanModel({
    required this.planId,
    required this.topic,
    required this.difficulty,
    required this.durationHours,
    required this.modules,
  });

  factory StudyPlanModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanModel(
      planId: json['plan_id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      durationHours: json['duration_hours'] as int? ?? 0,
      modules: (json['modules'] as List? ?? [])
          .map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  StudyPlanEntity toEntity() {
    return StudyPlanEntity(
      planId: planId,
      topic: topic,
      difficulty: difficulty,
      durationHours: durationHours,
      modules: modules.map((m) => m.toEntity()).toList(),
    );
  }
}

class ModuleModel {
  final String title;
  final List<String> concepts;
  final List<SessionModel> sessions;

  const ModuleModel({
    required this.title,
    required this.concepts,
    required this.sessions,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      title: json['title'] as String? ?? '',
      concepts: (json['concepts'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      sessions: (json['sessions'] as List? ?? [])
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ModuleEntity toEntity() {
    return ModuleEntity(
      title: title,
      concepts: concepts,
      sessions: sessions.map((s) => s.toEntity()).toList(),
    );
  }
}

class SessionModel {
  final int order;
  final String title;
  final String type;
  final int durationMin;
  final List<String> conceptsCovered;
  final String description;
  final AssessmentModel? assessment;

  const SessionModel({
    required this.order,
    required this.title,
    required this.type,
    required this.durationMin,
    required this.conceptsCovered,
    required this.description,
    this.assessment,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      durationMin: json['duration_min'] as int? ?? 0,
      conceptsCovered: (json['concepts_covered'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String? ?? '',
      assessment: json['assessment'] != null
          ? AssessmentModel.fromJson(json['assessment'] as Map<String, dynamic>)
          : null,
    );
  }

  SessionEntity toEntity() {
    return SessionEntity(
      order: order,
      title: title,
      type: type,
      durationMin: durationMin,
      conceptsCovered: conceptsCovered,
      description: description,
      assessment: assessment?.toEntity(),
    );
  }
}

class AssessmentModel {
  final String type;
  final String description;

  const AssessmentModel({
    required this.type,
    required this.description,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  AssessmentEntity toEntity() {
    return AssessmentEntity(
      type: type,
      description: description,
    );
  }
}
