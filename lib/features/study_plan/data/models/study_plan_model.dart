import '../../domain/entities/study_plan_entity.dart';

class StudyPlanPointModel {
  static StudyPlanPoint fromJson(Map<String, dynamic> json) {
    return StudyPlanPoint(
      titulo: json['titulo'] as String? ?? '',
      porQueImporta: json['por_que_importa'] as String? ?? '',
      explicacion: json['explicacion'] as String? ?? '',
      antesDeEntenderlo: (json['antes_de_entenderlo'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      comoSeRelaciona: (json['como_se_relaciona'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      ejemplo: json['ejemplo'] as String? ?? '',
    );
  }
}

class StudyPlanOrderModel {
  static StudyPlanOrder fromJson(Map<String, dynamic> json) {
    return StudyPlanOrder(
      orden: json['orden'] as int? ?? 0,
      tema: json['tema'] as String? ?? '',
      razon: json['razon'] as String? ?? '',
    );
  }
}

class StudyPlanRecommendationsModel {
  static StudyPlanRecommendations fromJson(Map<String, dynamic> json) {
    return StudyPlanRecommendations(
      repasarAntes:
          (json['repasar_antes_de_la_proxima_clase'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
      conceptosParaPracticar:
          (json['conceptos_para_practicar'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
      comoReforzar: (json['como_reforzar'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class StudyPlanModel {
  static StudyPlanEntity fromJson(Map<String, dynamic> json) {
    return StudyPlanEntity(
      planId: json['plan_id'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      durationHours: json['duration_hours'] as int? ?? 0,
      introduccion: json['introduccion'] as String? ?? '',
      puntosDeEstudio: (json['puntos_de_estudio'] as List? ?? [])
          .map((e) => StudyPlanPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ordenDeEstudio: (json['orden_de_estudio'] as List? ?? [])
          .map((e) => StudyPlanOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recomendaciones: StudyPlanRecommendationsModel.fromJson(
        json['recomendaciones'] as Map<String, dynamic>? ?? {},
      ),
      resumenFinal: json['resumen_final'] as String? ?? '',
    );
  }
}
