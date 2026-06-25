import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/archived_subject_professor_model.dart';

final archivedProfessorSubjectsProvider = Provider<List<ArchivedSubjectProfessorModel>>((ref) {
  return [
    ArchivedSubjectProfessorModel(
      id: '3',
      title: 'Calculo Diferencial',
      subtitle: 'Ing ITi1E',
      teacherName: 'Horacio Solis Cisneros',
      colorSeed: 2,
    ),
    ArchivedSubjectProfessorModel(
      id: '4',
      title: 'Fundamentos de Programacion',
      subtitle: 'Ing ITi1E',
      teacherName: 'Horacio Solis Cisneros',
      colorSeed: 3,
    ),
  ];
});
