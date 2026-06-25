import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/assignment_notice_model.dart';

class AssignmentNoticesNotifier extends Notifier<Map<String, List<AssignmentNoticeModel>>> {
  @override
  Map<String, List<AssignmentNoticeModel>> build() => {
        'Mineria de datos': [
          AssignmentNoticeModel(
            id: '1',
            authorName: 'Horacio Solis',
            date: '10 jun 2026',
            message: 'Mineria de datos: Mañana no habra sesion',
          ),
          AssignmentNoticeModel(
            id: '2',
            authorName: 'Horacio Solis',
            date: '12 jun 2026',
            message: 'La siguiente practica sera en equipo de 3 personas',
          ),
        ],
        'Programacion web': [
          AssignmentNoticeModel(
            id: '3',
            authorName: 'Jose Alonso Macias',
            date: '11 jun 2026',
            message: 'Programacion web: Revisar el capitulo 5 para la siguiente clase',
          ),
        ],
      };

  void addNotice(String subjectName, AssignmentNoticeModel notice) {
    final current = state[subjectName] ?? [];
    state = {
      ...state,
      subjectName: [...current, notice],
    };
  }
}

final assignmentNoticesProvider =
    NotifierProvider<AssignmentNoticesNotifier, Map<String, List<AssignmentNoticeModel>>>(
  AssignmentNoticesNotifier.new,
);

final assignmentNoticesForSubjectProvider =
    Provider.family<List<AssignmentNoticeModel>, String>((ref, subjectName) {
  final all = ref.watch(assignmentNoticesProvider);
  return all[subjectName] ?? [];
});
