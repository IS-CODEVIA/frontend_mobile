import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/material_students_di.dart';
import '../../domain/entities/student_material_entity.dart';
import '../../domain/usecases/get_student_materials_usecase.dart';

final _diProvider = Provider<MaterialStudentsDI>((ref) {
  return MaterialStudentsDI(ref.watch(appContainerProvider)!);
});

final _getMaterialsUsecaseProvider = Provider<GetStudentMaterialsUsecase>(
  (ref) => ref.watch(_diProvider).getStudentMaterialsUsecase,
);

final studentMaterialsProvider = NotifierProvider<
    StudentMaterialsNotifier, Map<int, List<StudentMaterialEntity>>>(
  StudentMaterialsNotifier.new,
);

final studentMaterialsForCourseProvider =
    Provider.family<List<StudentMaterialEntity>, int>((ref, courseId) {
  final all = ref.watch(studentMaterialsProvider);
  return all[courseId] ?? [];
});

class StudentMaterialsNotifier
    extends Notifier<Map<int, List<StudentMaterialEntity>>> {
  @override
  Map<int, List<StudentMaterialEntity>> build() => {};

  Future<void> loadMaterials(int courseId) async {
    try {
      final materials = await ref.read(_getMaterialsUsecaseProvider)(
        courseId: courseId,
      );
      materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = {...state, courseId: materials};
    } catch (_) {}
  }
}
