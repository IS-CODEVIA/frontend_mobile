class StudyPlanPoint {
  final String titulo;
  final String porQueImporta;
  final String explicacion;
  final List<String> antesDeEntenderlo;
  final List<String> comoSeRelaciona;
  final String ejemplo;

  const StudyPlanPoint({
    required this.titulo,
    required this.porQueImporta,
    required this.explicacion,
    required this.antesDeEntenderlo,
    required this.comoSeRelaciona,
    required this.ejemplo,
  });
}

class StudyPlanOrder {
  final int orden;
  final String tema;
  final String razon;

  const StudyPlanOrder({
    required this.orden,
    required this.tema,
    required this.razon,
  });
}

class StudyPlanRecommendations {
  final List<String> repasarAntes;
  final List<String> conceptosParaPracticar;
  final List<String> comoReforzar;

  const StudyPlanRecommendations({
    required this.repasarAntes,
    required this.conceptosParaPracticar,
    required this.comoReforzar,
  });
}

class StudyPlanEntity {
  final String planId;
  final String sessionId;
  final String topic;
  final String difficulty;
  final int durationHours;
  final String introduccion;
  final List<StudyPlanPoint> puntosDeEstudio;
  final List<StudyPlanOrder> ordenDeEstudio;
  final StudyPlanRecommendations recomendaciones;
  final String resumenFinal;

  const StudyPlanEntity({
    required this.planId,
    required this.sessionId,
    required this.topic,
    required this.difficulty,
    required this.durationHours,
    required this.introduccion,
    required this.puntosDeEstudio,
    required this.ordenDeEstudio,
    required this.recomendaciones,
    required this.resumenFinal,
  });
}
