import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/archived_subject_model.dart';

final archivedSubjectsProvider = Provider<List<ArchivedSubjectModel>>((ref) {
  return [
    ArchivedSubjectModel(
      id: '3',
      title: 'Calculo Diferencial',
      subtitle: 'Ing ITi1E',
      teacherName: 'Maria Garcia Lopez',
      colorSeed: 2,
    ),
    ArchivedSubjectModel(
      id: '4',
      title: 'Fundamentos de Programacion',
      subtitle: 'Ing ITi1E',
      teacherName: 'Carlos Mendoza Ruiz',
      colorSeed: 3,
    ),
    ArchivedSubjectModel(
      id: '5',
      title: 'Matematicas Discretas',
      subtitle: 'Ing ITi1E',
      teacherName: 'Ana Patricia Torres',
      colorSeed: 0,
    ),
  ];
});
