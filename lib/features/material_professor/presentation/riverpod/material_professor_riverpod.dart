import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/material_professor_di.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/usecases/create_material_usecase.dart';
import '../../domain/usecases/get_materials_usecase.dart';

final _materialProfessorDIProvider = Provider<MaterialProfessorDI>((ref) {
  return MaterialProfessorDI(ref.watch(appContainerProvider)!);
});

final _getMaterialsUsecaseProvider = Provider<GetMaterialsUsecase>((ref) {
  return ref.watch(_materialProfessorDIProvider).getMaterialsUsecase;
});

final _createMaterialUsecaseProvider = Provider<CreateMaterialUsecase>((ref) {
  return ref.watch(_materialProfessorDIProvider).createMaterialUsecase;
});

final materialsProfessorProvider =
    NotifierProvider<MaterialsProfessorNotifier, Map<int, List<MaterialEntity>>>(
  MaterialsProfessorNotifier.new,
);

final materialsByCourseIdProvider =
    Provider.family<List<MaterialEntity>, int>((ref, courseId) {
  final all = ref.watch(materialsProfessorProvider);
  return all[courseId] ?? [];
});

class MaterialsProfessorNotifier
    extends Notifier<Map<int, List<MaterialEntity>>> {
  @override
  Map<int, List<MaterialEntity>> build() => {};

  Future<void> loadMaterials(int courseId) async {
    try {
      final materials = await ref.read(_getMaterialsUsecaseProvider)(
        courseId: courseId,
      );
      materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = {...state, courseId: materials};
    } catch (_) {}
  }

  Future<MaterialEntity?> createMaterial({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    try {
      final material = await ref.read(_createMaterialUsecaseProvider)(
        courseId: courseId,
        title: title,
        fileUrl: fileUrl,
        description: description,
        fileType: fileType,
      );
      final current = state[courseId] ?? [];
      state = {...state, courseId: [...current, material]};
      return material;
    } catch (_) {
      return null;
    }
  }
}
