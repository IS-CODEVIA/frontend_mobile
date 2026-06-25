import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/subject_professor_model.dart';

final professorSubjectsProvider = Provider<List<SubjectProfessorModel>>((ref) {
  return [
    SubjectProfessorModel(
      id: '1',
      title: 'Mineria de datos',
      subtitle: 'Ing ITi2D',
      professorName: 'Horacio Solis Cisneros',
      enrolledStudents: 25,
      colorSeed: 0,
    ),
   
  ];
});
