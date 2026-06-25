import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/person_model.dart';

final classPeopleProvider = Provider<List<PersonModel>>((ref) {
  return [
    // Profesor
    PersonModel(
      id: '1',
      name: 'Horacio Solis',
      subtitle: 'Ingenieria en software',
      role: ClassRole.teacher,
    ),
    // Alumnos
    PersonModel(
      id: '2',
      name: 'Carlos Gael Castro Trujillo',
      subtitle: 'IT2ID',
      role: ClassRole.student,
    ),
    PersonModel(
      id: '3',
      name: 'Briyan de Jesus Chanona',
      subtitle: 'IT2ID',
      role: ClassRole.student,
    ),
  ];
});