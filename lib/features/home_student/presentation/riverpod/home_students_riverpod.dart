import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/subject_model.dart';

final subjectsProvider = Provider<List<SubjectModel>>((ref) {
  return [
    SubjectModel(
      id: '1',
      title: 'Mineria de datos',
      subtitle: 'Ing ITi2D',
      teacherName: 'Horacio Solis Cisneros',
      colorSeed: 0,
    ),
    SubjectModel(
      id: '2',
      title: 'Programacion web',
      subtitle: 'Ing ITi2D',
      teacherName: 'Jose Alonso Macias',
      colorSeed: 1,
    ),
  ];
});
