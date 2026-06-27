import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/subject_professor_model.dart';

final professorSubjectsProvider =
    NotifierProvider<ProfessorSubjectsNotifier, List<SubjectProfessorModel>>(
  ProfessorSubjectsNotifier.new,
);

class ProfessorSubjectsNotifier extends Notifier<List<SubjectProfessorModel>> {
  @override
  List<SubjectProfessorModel> build() {
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
  }

  void addSubject(SubjectProfessorModel subject) {
    state = [...state, subject];
  }
}
