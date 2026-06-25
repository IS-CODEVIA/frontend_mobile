import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentNoticesProfessorModel {
  final String id;
  final String authorName;
  final String date;
  final String message;
  final String? authorAvatarUrl;

  const AssignmentNoticesProfessorModel({
    required this.id,
    required this.authorName,
    required this.date,
    required this.message,
    this.authorAvatarUrl,
  });
}

class AssignmentNoticesProfessorNotifier extends Notifier<Map<String, List<AssignmentNoticesProfessorModel>>> {
  @override
  Map<String, List<AssignmentNoticesProfessorModel>> build() => {
        'Mineria de datos': [
          AssignmentNoticesProfessorModel(
            id: '1',
            authorName: 'Horacio Solis',
            date: '10 jun 2026',
            message: 'Mineria de datos: Mañana no habra sesion',
          ),
          AssignmentNoticesProfessorModel(
            id: '2',
            authorName: 'Horacio Solis',
            date: '12 jun 2026',
            message: 'La siguiente practica sera en equipo de 3 personas',
          ),
        ],
        'Programacion web': [
          AssignmentNoticesProfessorModel(
            id: '3',
            authorName: 'Jose Alonso Macias',
            date: '11 jun 2026',
            message: 'Programacion web: Revisar el capitulo 5 para la siguiente clase',
          ),
        ],
      };

  void addNotice(String subjectName, AssignmentNoticesProfessorModel notice) {
    final current = state[subjectName] ?? [];
    state = {
      ...state,
      subjectName: [...current, notice],
    };
  }
}

final assignmentNoticesProfessorProvider =
    NotifierProvider<AssignmentNoticesProfessorNotifier, Map<String, List<AssignmentNoticesProfessorModel>>>(
  AssignmentNoticesProfessorNotifier.new,
);

final assignmentNoticesProfessorForSubjectProvider =
    Provider.family<List<AssignmentNoticesProfessorModel>, String>((ref, subjectName) {
  final all = ref.watch(assignmentNoticesProfessorProvider);
  return all[subjectName] ?? [];
});
