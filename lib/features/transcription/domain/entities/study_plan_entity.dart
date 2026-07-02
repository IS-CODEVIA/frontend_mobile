class StudyPlanEntity {
  final String planId;
  final String topic;
  final String difficulty;
  final int durationHours;
  final List<ModuleEntity> modules;

  const StudyPlanEntity({
    required this.planId,
    required this.topic,
    required this.difficulty,
    required this.durationHours,
    required this.modules,
  });
}

class ModuleEntity {
  final String title;
  final List<String> concepts;
  final List<SessionEntity> sessions;

  const ModuleEntity({
    required this.title,
    required this.concepts,
    required this.sessions,
  });
}

class SessionEntity {
  final int order;
  final String title;
  final String type;
  final int durationMin;
  final List<String> conceptsCovered;
  final String description;
  final AssessmentEntity? assessment;

  const SessionEntity({
    required this.order,
    required this.title,
    required this.type,
    required this.durationMin,
    required this.conceptsCovered,
    required this.description,
    this.assessment,
  });
}

class AssessmentEntity {
  final String type;
  final String description;

  const AssessmentEntity({
    required this.type,
    required this.description,
  });
}
